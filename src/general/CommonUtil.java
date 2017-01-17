package general;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.StreamingOutput;
import javax.ws.rs.core.Response.Status;


public class CommonUtil {
	public static void close(Connection connection) {
		if (connection != null) {
			try {
				connection.close();
				connection = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static void close(Statement statement) {
		if (statement != null) {
			try {
				statement.close();
				statement = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static void close(ResultSet resultSet) {
		if (resultSet != null) {
			try {
				resultSet.close();
				resultSet = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static void close(PreparedStatement preparedStatement) {
		if (preparedStatement != null) {
			try {
				preparedStatement.close();
				preparedStatement = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static int getCounts(Connection con){
		int count = 0;
		 ResultSet resultSet;
		 Statement stmt;
			try{
				stmt =con.createStatement();
			resultSet = stmt.executeQuery("SELECT FOUND_ROWS()");
			resultSet.next();
			count = resultSet.getInt(1);
			CommonUtil.close(resultSet);
			CommonUtil.close(stmt);
			resultSet=null;
			}catch(SQLException e){
				e.printStackTrace();
			}
		return count;
	}
	public static JSONArray getJsonArrayFromResultSet(ResultSet rs,Object objToHandleNull){
		JSONArray jsonArray = new JSONArray();
		try {
			int total_rows = rs.getMetaData().getColumnCount();
			while(rs.next()){
				JSONObject obj = new JSONObject();
				for (int i = 0; i < total_rows; i++) {
					obj. put(rs.getMetaData().getColumnLabel(i + 1).toLowerCase(),rs.getString(i + 1)==null ? objToHandleNull : rs.getString(i + 1));
				}
				jsonArray.put(obj);
				obj=null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			close(rs);
		}
		return jsonArray;
	}
	public static JSONObject getJsonObjectFromResultSet(ResultSet rs,Object objToHandleNull){
		JSONObject obj = new JSONObject();
		try {
			int total_rows = rs.getMetaData().getColumnCount();
			while(rs.next()){
				for (int i = 0; i < total_rows; i++) {
					obj. put(rs.getMetaData().getColumnLabel(i + 1).toLowerCase(),rs.getString(i + 1)==null ? objToHandleNull : rs.getString(i + 1).trim());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			close(rs);
		}
		return obj;
	}
	public static String getParamString(String str, String value) throws Exception{
		if ((null != str) && (str.length() > 0)&&(!str.equalsIgnoreCase("null"))) {
			return str;
	    } else{
	    	return value;
	    }
	}
	
	public static int getParamInt(String str, int value) throws Exception{
		if ((null != str) && (str.length() > 0)&&(!str.equalsIgnoreCase("null"))) {
			return Integer.parseInt(str);
	    } else{
	    	return value;
	    }
	}
	public static List<String> getlastgeneratedid(PreparedStatement pst) throws SQLException{
      	ResultSet resultSet = null;
      	List<String> ls = new ArrayList<String>();
      	resultSet = pst.getGeneratedKeys();
//      	System.out.println("--rs-"+pst);
      	if(pst != null){
      		while(resultSet.next()){
      			ls.add(resultSet.getString(1));
      		}
      	}
      	close(resultSet);
      	resultSet = null;
      return ls;	
      }
	public static JSONObject saveToTable(String tableName,String json,Connection con) throws Exception{
		JSONObject retobj = new JSONObject();
//		System.out.println( "saveToTable >> "+tableName +">>" +json);
		 List<String> idlist = new ArrayList<String>();
		try {
			retobj.put("issuccess", "0");
			String query=" set ";
			List<Object> list=new ArrayList<Object>();
			JSONObject outerObject = new JSONObject(json);
		    JSONObject dataObject = outerObject.getJSONObject("data");
		    JSONObject whereObject =  outerObject.isNull("where") ? null : outerObject.getJSONObject("where");
	    	String[] elementNames = JSONObject.getNames(dataObject);
		      for (String elementName : elementNames){
		    	  Object value = dataObject.get(elementName);
		    	  if(value.toString().equalsIgnoreCase("NOW()")){
		    		  query+=elementName+"=NOW(),";
		    	  }
		    	  else{
		    		  query+=elementName+"=?,";
			    	  list.add(value);
		    	  }
		    	 
		      }
			  query=query.substring(0,query.length()-1);
			   if(whereObject!=null){
				   query="update "+tableName+query+ " where 1=1 ";
				   elementNames = JSONObject.getNames(whereObject);
				      for (String elementName : elementNames){
				    	  Object value = whereObject.get(elementName);
				    	  if(value.toString().equalsIgnoreCase("NOW()")){
				    		  query+=" AND "+elementName+"=NOW()";
				    	  }else{
				    		  query+=" AND "+elementName+"=?";
				    		  list.add(value);
				    	  }
				      }
			   }else{
				   query="insert into "+tableName+query;
			   }
//			   System.out.println("save to table >> "+query);
			   PreparedStatement preparedStatement=con.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			   int size=list.size();
			   for(int i=1;i<=size;i++){
				   preparedStatement.setObject(i, list.get(i-1));
			   }
			  preparedStatement.executeUpdate();
			  idlist = getlastgeneratedid(preparedStatement);
			  retobj.put("issuccess", "1");
			  retobj.put("idlist", idlist);
			  idlist = null;
//			  System.out.println(retobj);
			  close(preparedStatement);
			  preparedStatement=null;
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}finally{
			
		}
		return retobj;
	}
	
	public static String saveToTable(String tableName,String json,Map<String,String> map, Connection connection){
		String resp="fail" ;
		try {
			String query=" set ";
			List<Object> list=new ArrayList<Object>();
			JSONObject outerObject = new JSONObject(json);
		    JSONObject dataObject = outerObject.getJSONObject("data");
		    JSONObject whereObject =  outerObject.isNull("where") ? null : outerObject.getJSONObject("where");
	    	String[] elementNames = JSONObject.getNames(dataObject);
		      for (String elementName : elementNames){
		    	  Object value = dataObject.get(elementName);
		    	  if(map.get(elementName)!=(null)){
		    		  query+=elementName+"="+map.get(elementName)+",";
		    		  list.add(value);
		    	  }else{
			    	  if(value.toString().equalsIgnoreCase("NOW()")){
			    		  query+=elementName+"=NOW(),";
			    	  }else{
			    		  query+=elementName+"=?,";
				    	  list.add(value);
			    	  }
		    	  }
		      }
			  query=query.substring(0,query.length()-1);
			   if(whereObject!=null){
				   query="update "+tableName+query+ " where 1=1 ";
				   elementNames = JSONObject.getNames(whereObject);
				      for (String elementName : elementNames){
				    	  Object value = whereObject.get(elementName);
				    	  if(value.toString().equalsIgnoreCase("NOW()")){
				    		  query+=" AND "+elementName+"=NOW()";
				    	  }else{
				    		  query+=" AND "+elementName+"=?";
				    		  list.add(value);
				    	  }
				      }
			   }else{
				   query="insert into "+tableName+query;
			   }
			   PreparedStatement preparedStatement=connection.prepareStatement(query);
			   int size=list.size();
			   for(int i=1;i<=size;i++){
				   preparedStatement.setObject(i, list.get(i-1));
			   }
			   System.out.println("=========>"+preparedStatement);
			  preparedStatement.executeUpdate();
			  preparedStatement.close();
			  preparedStatement=null;
			   resp="success";
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			map=null;
		}
		return resp;
	}
	
	public static Response getResponse(String str,Status status){
		 switch (status) {
		case OK:
			 return Response.ok(str, MediaType.APPLICATION_JSON).build();
			//break;
		default:
			return Response.status(status).entity(str).type(MediaType.TEXT_PLAIN).build(); 
			//break;
		}
	 }
}
