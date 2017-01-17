package general;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import org.json.JSONArray;
import org.json.JSONObject;

public class Root {
	public Connection con = null;
	protected String dbURL = null;
	protected String dbName = null;
	protected String dbUserName = null;
	protected String dbPwd = null;
	protected String dbDriver = null;
	protected static Map<String,String> DBPorpertyMap= new HashMap<String,String>();
	
	static {
		ResourceBundle rb = ResourceBundle.getBundle("properties/dbconfig");
		for (String key : rb.keySet()) {
			DBPorpertyMap.put(key, rb.getString(key));
		}
	}
	
	public void initParam() {
		String str = null;
		String dbserver = "Root";

		str = DBPorpertyMap.get(dbserver + ".DBName");
		if (str != null)
			this.dbName = str;
		str = DBPorpertyMap.get(dbserver + ".DBUrl");
		if (str != null)
			this.dbURL = str + "/" + this.dbName;

		str = DBPorpertyMap.get(dbserver + ".DBUser");
		if (str != null)
			this.dbUserName = str;

		str = DBPorpertyMap.get(dbserver + ".DBPassword");
		if (str != null)
			this.dbPwd = str;

		str = DBPorpertyMap.get(dbserver + ".DBDriver");
		if (str != null)
			this.dbDriver = str;
	}

	public Connection getConnection() {
		try {
			if (con != null && !con.isClosed()) {
				return con;
			}
			initParam();
			Class.forName(this.dbDriver);
			con = DriverManager.getConnection(this.dbURL, this.dbUserName, this.dbPwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}
	
	public void closeConnection() {
		try {
			if (con != null && !con.isClosed()) {
				con.close();
				con = null;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	public static void main(String[] args) {
		Root rt = new Root();
		Connection con1=rt.getConnection();
		DbUtils dbutil=new DbUtils(con1);
		String query ="select * from users";
		try {
			ResultSet rs =dbutil.selectFromDatabase(query );
			JSONArray js=CommonUtil.getJsonArrayFromResultSet(rs, "");
			System.out.println(js.toString());
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println("this.dbDriver" + rt.dbName);
	}
}
