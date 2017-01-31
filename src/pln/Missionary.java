package pln;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.json.JSONArray;
import org.json.JSONObject;

import general.CommonUtil;
import general.DbUtils;
import general.Root;
import general.Utils;

@Path("Missionary")
public class Missionary {

	@Context	HttpServletRequest request;
	@Context	HttpServletResponse response;

	@POST
	@Path("saveMissionary")
	public String saveMissionary(@FormParam("data") String data,@FormParam("whereObjData") String whereObjData)
	{
		Root root = new Root();
		System.out.println("Save Missionary");
		try {
			root.getConnection();
			JSONObject missionarydata = new JSONObject(Utils.makeSafe(data));
			JSONObject responseOfSaveToTable = new JSONObject();
			JSONObject json = new JSONObject();
			JSONObject outerwhereObj = new JSONObject();
			
			if (whereObjData.length() > 2) {
				outerwhereObj = new JSONObject(Utils.makeSafe(whereObjData));
				json.put("where", outerwhereObj);
			}
			System.out.println(missionarydata);
			missionarydata.put("marrivaldate",Utils.formateStringDateToStringForMySql(missionarydata.getString("marrivaldate"),"dd-MMM-yyyy","yyyy-MM-dd"));
			missionarydata.put("mdepartdate",Utils.formateStringDateToStringForMySql(missionarydata.getString("mdepartdate"),"dd-MMM-yyyy","yyyy-MM-dd"));
			System.out.println(missionarydata);
			json.put("data", missionarydata);
			responseOfSaveToTable = new JSONObject(CommonUtil.saveToTable("missionary", json.toString(), root.con).toString());
			System.out.println("ResponseOfMissionarySave" + responseOfSaveToTable);

		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		} finally {
			root.closeConnection();
		}
		return "Success";
	}
	
	@POST
	@Path("loadGrid")
	public Response loadGrid(@FormParam("data") String data) {
		Root root = new Root();
		JSONObject response = new JSONObject();
		JSONArray jArray = new JSONArray();
		try{
			
			JSONObject jsonObject = new JSONObject();
			if (data != null) {
				jsonObject = null;
				jsonObject = new JSONObject(data);
			}
			int cmid = jsonObject.optInt("cmid");
			JSONObject gridObj = jsonObject.optJSONObject("gridCustomParams");
			int start =  Utils.getValue("start", 0, gridObj);
			int limit =  Utils.getValue("limit", 20, gridObj);
			String orderby =  Utils.getValue("orderby", "", gridObj);
			String ordertype =  Utils.getValue("orderType", "", gridObj);
			if(orderby!=null && orderby.trim().length()==0){
				orderby="m.mid";ordertype="desc";
			}
			
			root.getConnection();
			DbUtils dUtil=new DbUtils(root.con);
			ResultSet rs=null;
			if(cmid != 0)
			{
				 rs = dUtil.selectFromDatabase("select SQL_CALC_FOUND_ROWS mid,mtitle,mfname,mlname,DATE_FORMAT(marrivaldate,'%d-%b-%Y') AS marrivaldate,"
				 		+ "DATE_FORMAT(mdepartdate,'%d-%b-%Y') AS mdepartdate,mnationality "
				 		+ "from `missionary` m where m.mstatus=? and m.mid=? "
				 		+ "order by "+orderby+" "+ordertype+" limit "+start+","+limit,"active",cmid);
			}
			else{
				rs = dUtil.selectFromDatabase("select SQL_CALC_FOUND_ROWS mid,mtitle,mfname,mlname,DATE_FORMAT(marrivaldate,'%d-%b-%Y') AS marrivaldate,"
						+ "DATE_FORMAT(mdepartdate,'%d-%b-%Y') AS mdepartdate,mnationality "
						+ "from `missionary` m where m.mstatus=? "
						+ " order by "+orderby+" "+ordertype+" limit "+start+","+limit,"active");
			}
			int counts = dUtil.getIntFromDatabase("select count(*) from `missionary` m where m.mstatus=?", 0, "active");
			List<Object> sortKeys = new ArrayList<Object>();
			sortKeys.add(new JSONObject().put("sortby", "mid").put("dataType", "numeric"));
			sortKeys.add(new JSONObject().put("sortby", "mtitle").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "mfname").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "mlname").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "marrivaldate").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "mdepartdate").put("dataType", "string"));
			sortKeys.add(new JSONObject().put("sortby", "mnationality").put("dataType", "string"));
			jArray = CommonUtil.getJsonArrayFromResultSet(rs, "");
			System.out.println(counts);
			response.put("count",counts);
			response.put("headers",new String[] {"ID","Title","First Name","Last Name","Arrival Date","Departure Date","Nationality","Action"});
			response.put("columns",new String[]{"mid","mtitle","mfname","mlname","marrivaldate","mdepartdate","mnationality",""});
			response.put("data",jArray);
			response.put("sort",sortKeys);
			return CommonUtil.getResponse(response.toString(), Status.OK);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return CommonUtil.getResponse(response.toString(), Status.INTERNAL_SERVER_ERROR);
		}
		finally{
			root.closeConnection();
		}
	}
	
	@GET
	@Path("deleteMissionary")
	public String deleteUser(@QueryParam("mid") String mid,@QueryParam("loginuser") String loginuser){
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String querystr = "UPDATE missionary set mstatus='Deleted',mlastmodifiedby=? where mid=?";
			dbutil.executeUpdate(querystr,loginuser, mid);
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
	@Path("editMissionary")
	public String editMissionary(@QueryParam("mid") String mid)
	{
		JSONObject data = new JSONObject();
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String query="select mid,mtitle,mfname,mlname,DATE_FORMAT(marrivaldate,'%d-%b-%Y') AS marrivaldate,DATE_FORMAT(mdepartdate,'%d-%b-%Y') AS mdepartdate,mnationality from missionary m where m.mid=?";
			ResultSet rs=dbutil.selectFromDatabase(query, mid);
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
	@Path("getMissionary")
	public String getMissionary(@QueryParam("term") String term,@QueryParam("limit") int limit) throws Exception{
		String response = "";
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String sql= "select mid as id , concat(mlname,',',mfname) as label from missionary where (mfname like ? or mlname like ?) and mstatus ='active' order by concat(mlname,',',mfname) limit ?";
			term =term+"%";
			ResultSet rs=dbutil.selectFromDatabase(sql, term,term,limit);
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
	
	
}
