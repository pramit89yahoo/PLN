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

@Path("Users")
public class Users {
	@Context
	HttpServletRequest request;
	@Context
	HttpServletResponse response;

	@POST
	@Path("saveUser")
	public String saveUsers(@FormParam("data") String data,@FormParam("whereObjData") String whereObjData) {
		Root root = new Root();
		System.out.println("Save users");
		try {
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			JSONObject usersdata = new JSONObject(Utils.makeSafe(data));
			JSONObject responseOfSaveToTable = new JSONObject();
			JSONObject outerwhereObj = new JSONObject();
			JSONObject json = new JSONObject();
			
			json.put("data", usersdata);
			if (whereObjData.length() > 2) {
				outerwhereObj = new JSONObject(Utils.makeSafe(whereObjData));
				json.put("where", outerwhereObj);
			}
			else if (checkUserName(usersdata.get("uname").toString(), dbutil)) {
				System.out.println("already taken");
				return "AlreadyTaken";
			}
			responseOfSaveToTable = new JSONObject(
					CommonUtil.saveToTable("users", json.toString(), root.con).toString());
			System.out.println("ResponseOfUsersSave" + responseOfSaveToTable);

		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		} finally {
			root.closeConnection();
		}
		return "Success";
	}

	private boolean checkUserName(String uname, DbUtils dbutil) {
		boolean isalready = false;
		try {
			if(dbutil.getIntFromDatabase("select count(*) from users where uname = ?", 0, uname) >0 )
			{
				System.out.println("AlreadyTaken");
				isalready=true;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return isalready;
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
			JSONObject gridObj = jsonObject.optJSONObject("gridCustomParams");
			int start =  Utils.getValue("start", 0, gridObj);
			int limit =  Utils.getValue("limit", 20, gridObj);
			root.getConnection();
			DbUtils dUtil=new DbUtils(root.con);
			ResultSet rs = dUtil.selectFromDatabase("select SQL_CALC_FOUND_ROWS uid,uname,ufname,ulname,uphone,uemail from users u where u.ustatus=? order by 1 desc limit "+start+","+limit,"active");
			int counts = dUtil.getIntFromDatabase("select count(*) from users u where u.ustatus=?", 0, "active");
			List<Object> sortKeys = new ArrayList<Object>();
			sortKeys.add("");
			sortKeys.add("");
			sortKeys.add("");
			sortKeys.add("");
			sortKeys.add("");
			sortKeys.add("");
			jArray = CommonUtil.getJsonArrayFromResultSet(rs, "");
			System.out.println(counts);
			response.put("count",counts);
			response.put("headers",new String[] {"ID","Username","First Name","Last Name","Phone #","Email","Action"});
			response.put("columns",new String[]{"uid","uname","ufname","ulname","uphone","uemail",""});
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
	@Path("deleteUser")
	public String deleteUser(@QueryParam("userid") String userid,@QueryParam("loginuser") String loginuser){
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String querystr = "UPDATE users set ustatus='Deleted',ulastmodifiedby=? where uid=?";
			dbutil.executeUpdate(querystr,loginuser, userid);
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
	@Path("editUser")
	public String editUser(@QueryParam("uid") String uid)
	{
		JSONObject data = new JSONObject();
		Root root = new Root();
		try{
			root.getConnection();
			DbUtils dbutil = new DbUtils(root.con);
			String query="select * from users u where u.uid=?";
			ResultSet rs=dbutil.selectFromDatabase(query, uid);
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
	
}
