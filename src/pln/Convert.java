package pln;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import general.CommonUtil;
import general.DbUtils;
import general.Root;
import general.Utils;

@Path("Convert")
public class Convert {
	@Context HttpServletRequest request;
	@Context HttpServletResponse response;
	
	@POST
	@Path("saveConvert")
	public String saveConvert(@FormParam("data") String data,@FormParam("convertArray") String convertArray,
			@DefaultValue("") @FormParam("whereObjData") String whereObjData,@DefaultValue("") @FormParam("missionaryId") String mid )
	{
		Root root = new Root();
		try {
			root.getConnection();
			JSONObject convertdata = new JSONObject(Utils.makeSafe(data));
			JSONObject responseOfSaveToTable = new JSONObject();
			JSONObject responseOfSaveToCMTable = new JSONObject();
			JSONArray jarray=new JSONArray(Utils.makeSafe(convertArray));
			JSONObject json = new JSONObject();
			JSONObject jsonCM = new JSONObject();
			JSONObject outerwhereObj = new JSONObject();
			String[] mArray={};
			JSONObject convertMissionaryData=new JSONObject();
			convertdata.put("cdate",Utils.formateStringDateToStringForMySql(convertdata.getString("cdate"),"dd-MMM-yyyy","yyyy-MM-dd"));
			
			if (whereObjData.length() > 2) {
				outerwhereObj = new JSONObject(Utils.makeSafe(whereObjData));
				json.put("where", outerwhereObj);
			}
			if(!mid.equalsIgnoreCase(""))
				mArray=mid.split(",");
			
			for(int i=0;i<jarray.length();i++)
			{
				convertdata.put("cname", jarray.getJSONObject(i).optString("cname"));
				convertdata.put("cage", jarray.getJSONObject(i).optString("cage"));
				convertdata.put("cgender", jarray.getJSONObject(i).optString("cgender"));
				json.put("data", convertdata);
				responseOfSaveToTable = new JSONObject(CommonUtil.saveToTable("`convert`", json.toString(), root.con).toString());
				System.out.println("responseOfSaveToTable >>"+responseOfSaveToTable);
				for (int j=0;j < mArray.length;j++)
				{
					convertMissionaryData.put("cid", (responseOfSaveToTable.optJSONArray("idlist")).optInt(0));
					convertMissionaryData.put("mid", mArray[j]);
					convertMissionaryData.put("cmlastmodifiedby", convertdata.opt("clastmodifiedby"));
					convertMissionaryData.put("cmlastmodifiedtime", convertdata.opt("clastmodifiedtime"));
					jsonCM.put("data", convertMissionaryData);
					System.out.println("jsonCM.put(data) >>"+jsonCM);
					responseOfSaveToCMTable = new JSONObject(CommonUtil.saveToTable("`convertmissionary`", jsonCM.toString(), root.con).toString());
				}
				
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		} finally {
			root.closeConnection();
		}
		return "Success";
	}
	@GET
	@Path("exportToExcel")
	public String exportToExcel(@DefaultValue("")@QueryParam("columns") String selcolumns,@Context HttpServletResponse httpResponse) throws JSONException {
		String disposition = "attachment; fileName=Converts.xls";
		httpResponse.setContentType("text/csv");
		httpResponse.setHeader("Content-Disposition", disposition);
		
		String resp=loadGrid("{}",selcolumns);
		CommonUtil obj = new CommonUtil();
		obj.exportToExcel(new JSONObject(resp), httpResponse, "Converts", "Converts Data", "-");
		
		return "";
	}
	
	@POST
	@Path("loadGrid")
	public String loadGrid(@FormParam("data") String data,@DefaultValue("")@FormParam("columns") String selColumns ) {
		Root root = new Root();
		JSONObject response = new JSONObject();
		JSONArray jArray = new JSONArray();
		String ConvertSearchCondition="";
		try{
			
			
			JSONObject jsonObject = new JSONObject();
			if (data != null) {
				jsonObject = null;
				jsonObject = new JSONObject(data);
			}
			JSONObject gridObj = jsonObject.optJSONObject("gridCustomParams");
			int cid = jsonObject.optInt("cid");
			if(cid!=0)
			{
				ConvertSearchCondition=" and c.cid="+cid;
			}
			int start =  Utils.getValue("start", 0, gridObj);
			int limit =  Utils.getValue("limit", 1000, gridObj);
			String orderby =  Utils.getValue("orderby", "", gridObj);
			String ordertype =  Utils.getValue("orderType", "", gridObj);
			if(orderby!=null && orderby.trim().length()==0){
				orderby="cid";ordertype="desc";
			}
			root.getConnection();
			DbUtils dUtil=new DbUtils(root.con);
			
			String sql="SELECT SQL_CALC_FOUND_ROWS c.cid,cname,cage,cgender,GROUP_CONCAT(concat(m.`mfname`,' ',m.`mlname`)) AS Missionary,"
					+ " DATE_FORMAT(cdate,'%d-%b-%Y') as cdate,cward,cstake,cbaptism"
					+ " FROM `convert` c "
					+ " LEFT JOIN convertmissionary cm on cm.cid=c.cid AND cm.`status` ='active'"
					+ " LEFT JOIN `missionary` m ON m.`mid`=cm.`mid` "
					+ " WHERE c.`cstatus`=? "+ConvertSearchCondition
					+ " group by c.cid"
					+ " order by "+orderby+" "+ordertype+" limit "+start+","+limit;
			//System.out.println(sql);
			
			ResultSet rs = dUtil.selectFromDatabase(sql,"active");
			int counts = dUtil.getIntFromDatabase("select count(*) from `convert` c where c.cstatus=?"+ConvertSearchCondition, 0, "active");
			
			String[] headersArray=new String[] {"ID","Name","Age","Gender","Missionary","Date","Ward","Stake","Baptism","Action"};
			String[] columnsArray=new String[]{"cid","cname","cage","cgender","missionary","cdate","cward","cstake","cbaptism",""};
			if(selColumns.length()>0)
			{
				List<String> tempheaders = new ArrayList<String>();
				List<String> tempcolumns = new ArrayList<String>();
				String[] Columns=selColumns.split(",");
				for(int i=0;i<Columns.length;i++){ 
					tempheaders.add(headersArray[i].toString());
					tempcolumns.add(columnsArray[i].toString());
				}  
				System.out.println(Columns.length);
				headersArray = new String[tempheaders.size() ];
				tempheaders.toArray( headersArray );
				columnsArray = new String[tempcolumns.size() ];
				tempcolumns.toArray( columnsArray );
			}
			System.out.println(selColumns+" and"+headersArray.length);
			List<Object> sortKeys = new ArrayList<Object>();
			sortKeys.add(new JSONObject().put("sortby", "cid").put("dataType", "numeric"));
			sortKeys.add(new JSONObject().put("sortby", "cname").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cage").put("dataType", "numeric"));
			sortKeys.add(new JSONObject().put("sortby", "cgender").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "missionary").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cdate").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cward").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cstake").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cbaptism").put("dataType", "numeric"));
			jArray = CommonUtil.getJsonArrayFromResultSet(rs, "");
			response.put("count",counts);
			response.put("headers",headersArray);
			response.put("columns",columnsArray);
			response.put("data",jArray);
			response.put("sort",sortKeys);
			return response.toString();
			//return CommonUtil.getResponse(response.toString(), Status.OK);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return response.toString();
			//return CommonUtil.getResponse(response.toString(), Status.INTERNAL_SERVER_ERROR);
		}
		finally{
			root.closeConnection();
		}
	}
	
	@GET
	@Path("deleteConvert")
	public String deleteUser(@QueryParam("cid") String cid,@QueryParam("loginuser") String loginuser){
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String querystr = "UPDATE `convert` set cstatus='Deleted',clastmodifiedby=? where cid=?";
			dbutil.executeUpdate(querystr,loginuser, cid);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return "error";
		}
		finally
		{
			root.closeConnection();
		}
		return "success";
	}
	
	@GET
	@Path("editConvert")
	public String editConvert(@QueryParam("cid") String cid)
	{
		JSONObject data = new JSONObject();
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String query=" SELECT c.cid,cname,cage,cgender,GROUP_CONCAT(CONCAT(CONCAT(m.mlname,' ',m.mfname,'#-#'),cm.`mid`) SEPARATOR '$-$') as mname,"
					+ " DATE_FORMAT(cdate,'%d-%b-%Y') AS cdate,cward,cstake,cbaptism "
					+ " FROM `convert` c "
					+ " LEFT JOIN convertmissionary cm on cm.cid=c.cid and cm.status='active'"
					+ " LEFT JOIN `missionary` m ON m.`mid`=cm.mid "
					+ " WHERE c.cid=?";
			ResultSet rs=dbutil.selectFromDatabase(query, cid);
			data=CommonUtil.getJsonObjectFromResultSet(rs, "");
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return "error";
		}
		finally
		{
			root.closeConnection();
		}
		return data.toString();
	}
	@GET
	@Path("getWard")
	public String getWard(@QueryParam("term") String term,@QueryParam("limit") int limit) throws Exception{
		String response = "";
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= "SELECT DISTINCT(cward) as label FROM `convert` where cward like ? limit ?";
			term =term+"%";
			ResultSet rs=dbutil.selectFromDatabase(sql, term,limit);
			response=CommonUtil.getJsonArrayFromResultSet(rs, "").toString();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
	@GET
	@Path("getStake")
	public String getStake(@QueryParam("term") String term,@QueryParam("limit") int limit) throws Exception{
		String response = "";
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= "SELECT DISTINCT(cstake) as label FROM `convert` where cstake like ? limit ?";
			term =term+"%";
			ResultSet rs=dbutil.selectFromDatabase(sql, term,limit);
			response=CommonUtil.getJsonArrayFromResultSet(rs, "").toString();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
	@POST
	@Path("getMonthlyConverts")
	public String getMonthlyConverts(@FormParam("data") String data){
		String response = "";
		Root root = new Root();
		try{
			JSONObject jdata = new JSONObject(Utils.makeSafe(data));
			List<String> parametersList = new ArrayList<String>();
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= "SELECT MONTHNAME(cdate) as entity,COUNT(*) as cnt,MONTH(cdate),YEAR(cdate) as monthid FROM `convert` c ";
					sql += " left JOIN convertmissionary cm ON cm.cid=c.cid AND cm.`status` ='active' " 
							+ "JOIN missionary m ON m.`mid`=cm.`mid`";
					sql+= " WHERE c.`cdate` BETWEEN ? AND ? AND c.`cstatus`='active' AND (m.`mdepartdate` IS NULL OR m.`mdepartdate` BETWEEN ? AND ?)";
			String startdate=Utils.formateStringDateToStringForMySql(jdata.getString("rstartdate"),"MM/dd/yyy","yyyy-MM-dd");
			String enddate=Utils.formateStringDateToStringForMySql(jdata.getString("renddate"),"MM/dd/yyy","yyyy-MM-dd");
			parametersList.add(startdate);
			parametersList.add(enddate);
			parametersList.add(startdate);
			parametersList.add(enddate);
			if(!jdata.optString("rtitle").equalsIgnoreCase(""))
			{
				sql+=" and m.mtitle=? ";
				parametersList.add(jdata.getString("rtitle"));
			}
			if(!jdata.optString("rnationality").equalsIgnoreCase(""))
			{
				sql+=" and m.mnationality=? ";
				parametersList.add(jdata.getString("rnationality"));
			}
			if(!jdata.optString("rstake").equalsIgnoreCase(""))
			{
				sql+=" and c.cstake=? ";
				parametersList.add(jdata.getString("rstake"));
			}
			if(!jdata.optString("rward").equalsIgnoreCase(""))
			{
				sql+=" and c.cward=? ";
				parametersList.add(jdata.getString("rward"));
			}
			if(!jdata.optString("rmissionary").equalsIgnoreCase("0"))
			{
				sql+=" and cm.mid=? ";
				parametersList.add(jdata.getString("rmissionary"));
			}
			sql+= "and c.cstatus='active' GROUP BY MONTH(cdate),MONTHNAME(cdate),YEAR(cdate) order by YEAR(cdate),MONTH(cdate)";
			
			ResultSet rs=dbutil.selectFromDatabase(sql,parametersList.toArray());
			response=CommonUtil.getJsonArrayFromResultSet(rs, "").toString();
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
	@POST
	@Path("getConvertsByGroups")
	public String getConvertsByMissionary(@FormParam("data") String data){
		String response = "";
		Root root = new Root();
		try{
			JSONObject jdata = new JSONObject(Utils.makeSafe(data));
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			JSONObject finalResponse=new JSONObject();
			
			String Missionary=generateGroupQueryResponse(dbutil,jdata,"CONCAT(m.`mlname`,',',m.`mfname`)");
			finalResponse.putOpt("Missionary",Missionary);
			String title=generateGroupQueryResponse(dbutil,jdata,"m.mtitle");
			finalResponse.putOpt("title",title);
			String mnationality=generateGroupQueryResponse(dbutil,jdata,"m.mnationality");
			finalResponse.putOpt("mnationality",mnationality);
			String rstake=generateGroupQueryResponse(dbutil,jdata,"c.cstake");
			finalResponse.putOpt("rstake",rstake);
			String cward=generateGroupQueryResponse(dbutil,jdata,"c.cward");
			finalResponse.putOpt("cward",cward);
			response=finalResponse.toString();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
	private String generateGroupQueryResponse(DbUtils dbutil,JSONObject jdata,String Groupby){
		String response="";
		String sql = "SELECT "+Groupby+" AS entity,COUNT(*) as cnt FROM `convert` c ";
		sql += " LEFT JOIN convertmissionary cm ON cm.cid=c.cid AND cm.`status` ='active' ";
		sql += " JOIN missionary m ON cm.`mid`=m.`mid`";
		sql += "WHERE c.`cdate` BETWEEN ? AND ? AND c.`cstatus`='active' AND (m.`mdepartdate` IS NULL OR m.`mdepartdate` BETWEEN ? AND ?)";
		try{
			List<String> parametersList = new ArrayList<String>();
			String startdate=Utils.formateStringDateToStringForMySql(jdata.getString("rstartdate"),"MM/dd/yyy","yyyy-MM-dd");
			String enddate=Utils.formateStringDateToStringForMySql(jdata.getString("renddate"),"MM/dd/yyy","yyyy-MM-dd");
			parametersList.add(startdate);
			parametersList.add(enddate);
			parametersList.add(startdate);
			parametersList.add(enddate);
			if(!jdata.optString("rtitle").equalsIgnoreCase(""))
			{
				sql+=" and m.mtitle=? ";
				parametersList.add(jdata.getString("rtitle"));
			}
			if(!jdata.optString("rnationality").equalsIgnoreCase(""))
			{
				sql+=" and m.mnationality=? ";
				parametersList.add(jdata.getString("rnationality"));
			}
			if(!jdata.optString("rstake").equalsIgnoreCase(""))
			{
				sql+=" and c.cstake=? ";
				parametersList.add(jdata.getString("rstake"));
			}
			if(!jdata.optString("rward").equalsIgnoreCase(""))
			{
				sql+=" and c.cward=? ";
				parametersList.add(jdata.getString("rward"));
			}
			if(!jdata.optString("rmissionary").equalsIgnoreCase("0"))
			{
				sql+=" and c.mid=? ";
				parametersList.add(jdata.getString("rmissionary"));
			}
			sql += "GROUP BY "+Groupby;
			ResultSet rs=dbutil.selectFromDatabase(sql,parametersList.toArray());
			response=CommonUtil.getJsonArrayFromResultSet(rs, "").toString();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return response;
	}
	@POST
	@Path("getDataReportConverts")
	public Response getDataReportConverts(@FormParam("data") String data){
		JSONObject response = new JSONObject();
		Root root = new Root();
		JSONArray jArray = new JSONArray();
		try{
//			System.out.println(data);
			JSONObject jsonObject = new JSONObject();
			if (data != null) {
				jsonObject = null;
				jsonObject = new JSONObject(data);
			}
			JSONObject gridObj = jsonObject.optJSONObject("gridCustomParams");
			int start =  Utils.getValue("start", 0, gridObj);
			int limit =  Utils.getValue("limit", 20, gridObj);
			String orderby =  Utils.getValue("orderby", "", gridObj);
			String ordertype =  Utils.getValue("orderType", "", gridObj);
			if(orderby!=null && orderby.trim().length()==0){
				orderby="c.cid";ordertype="desc";
			}
			JSONObject jdata = new JSONObject(Utils.makeSafe(data));
			List<String> parametersList = new ArrayList<String>();
			root.getConnection();
			String cidCondition=" c.cid ";
			DbUtils dbutil = new DbUtils(root.con);
			if(!jdata.optString("rstake").equalsIgnoreCase("") || !jdata.optString("rward").equalsIgnoreCase("") || 
					(jdata.optString("rward").equalsIgnoreCase("") &  jdata.optString("rstake").equalsIgnoreCase("") & jdata.optString("rtitle").equalsIgnoreCase("") &
							jdata.optString("rmissionary").equalsIgnoreCase("0") & jdata.optString("rnationality").equalsIgnoreCase("")) )
			{
				cidCondition=" distinct(c.cid) " ;
			}
			String sql= "SELECT SQL_CALC_FOUND_ROWS "+cidCondition+",cname,cage,cgender,group_concat(CONCAT(m.`mfname`,' ',m.`mlname`)) AS Missionary,"
					+ "DATE_FORMAT(cdate,'%d-%b-%Y') as cdate,cward,cstake,cbaptism,m.mtitle as title,m.mnationality as nationality "
					+ "FROM `convert` c "
					+ " LEFT JOIN `convertmissionary` cm  on cm.cid=c.cid and cm.status='active' "
					+ " left JOIN missionary m ON m.`mid`=cm.`mid`"
					+ " WHERE c.`cdate` BETWEEN ? AND ? AND c.`cstatus`='active' AND (m.`mdepartdate` IS NULL OR m.`mdepartdate` BETWEEN ? AND ?)";
			String startdate=Utils.formateStringDateToStringForMySql(jdata.getString("rstartdate"),"MM/dd/yyy","yyyy-MM-dd");
			String enddate=Utils.formateStringDateToStringForMySql(jdata.getString("renddate"),"MM/dd/yyy","yyyy-MM-dd");
			parametersList.add(startdate);
			parametersList.add(enddate);
			parametersList.add(startdate);
			parametersList.add(enddate);
			if(!jdata.optString("rtitle").equalsIgnoreCase(""))
			{
				sql+=" and m.mtitle=? ";
				parametersList.add(jdata.getString("rtitle"));
			}
			if(!jdata.optString("rnationality").equalsIgnoreCase(""))
			{
				sql+=" and m.mnationality=? ";
				parametersList.add(jdata.getString("rnationality"));
			}
			if(!jdata.optString("rstake").equalsIgnoreCase(""))
			{
				sql+=" and c.cstake=? ";
				parametersList.add(jdata.getString("rstake"));
			}
			if(!jdata.optString("rward").equalsIgnoreCase(""))
			{
				sql+=" and c.cward=? ";
				parametersList.add(jdata.getString("rward"));
			}
			if(!jdata.optString("rmissionary").equalsIgnoreCase("0"))
			{
				sql+=" and cm.mid=? ";
				parametersList.add(jdata.getString("rmissionary"));
			}
			sql+= " and c.cstatus='active'";
			sql+= " group by c.cid order by "+orderby+" "+ordertype;
			sql+=" limit "+start +","+limit;
			ResultSet rs=dbutil.selectFromDatabase(sql,parametersList.toArray());
			int counts=dbutil.getTotalCount();
			List<Object> sortKeys = new ArrayList<Object>();
			sortKeys.add(new JSONObject().put("sortby", "cid").put("dataType", "numeric"));
			sortKeys.add(new JSONObject().put("sortby", "cname").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "c.cdate").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "missionary").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "nationality").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cward").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "cstake").put("dataType", "string"));
			
			jArray = CommonUtil.getJsonArrayFromResultSet(rs, "");
			response.put("count",counts);
			response.put("headers",new String[] {"ID","Convert Name","Date","Missionary","Title","Nationality","Ward","Stake"});
			response.put("columns",new String[]{"cid","cname","cdate","missionary","title","nationality","cward","cstake"});
			response.put("data",jArray);
			response.put("sort",sortKeys);
			return CommonUtil.getResponse(response.toString(), Status.OK);
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return CommonUtil.getResponse(response.toString(), Status.INTERNAL_SERVER_ERROR);
		}
		finally{
        	root.closeConnection();
        }
	}
	
	@GET
	@Path("getConvertByName")
	public String getConvertByName(@QueryParam("term") String term,@QueryParam("limit") int limit) throws Exception{
		String response = "";
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= "select cid as id , cname as label "
					+ "from `convert` where (cname like ?) and cstatus ='active' order by cname limit ?";
			term ="%"+term+"%";
			ResultSet rs=dbutil.selectFromDatabase(sql, term,limit);
			response=CommonUtil.getJsonArrayFromResultSet(rs, "").toString();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
	@POST
	@Path("saveConvertMissionary")
	public String saveConvertMissionary(@FormParam("cid") String cid,@FormParam("mid") int mid,@DefaultValue("active") @FormParam("status") String status,@FormParam("lastmodifiedby") int lastmodifiedby) throws Exception{
		String response = "";
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= " insert into convertmissionary (cid,mid,cmlastmodifiedby,cmlastmodifiedtime) values (?,?,?,now()) ON DUPLICATE KEY UPDATE"
					+ " cmlastmodifiedby=?,status=?,cmlastmodifiedtime=now()";
			dbutil.executeUpdate(sql,cid,mid,lastmodifiedby,lastmodifiedby,status);
			response="success";
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			response="error";
		}
		finally{
        	root.closeConnection();
        }
		return response;
	}
}
