package general;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import general.CommonUtil;

public class DbUtils {
	private Connection connection;

	public DbUtils(Connection connection) {
		this.connection = connection;
	}

	public Connection getConnection() {
		return connection;
	}

	public Integer executeUpdate(String query, Object... values) throws SQLException {
		PreparedStatement preparedStatement = this.prepareStatement(query, values);
		return preparedStatement.executeUpdate();
	}

	public PreparedStatement prepareStatement(String query, Object... values) throws SQLException {
		PreparedStatement preparedStatement = connection.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE,
				ResultSet.CONCUR_UPDATABLE);
		this.setValues(preparedStatement, values);
		return preparedStatement;
	}

	public PreparedStatement prepareInsertStatement(String query, Object... values) throws SQLException {
		PreparedStatement preparedStatement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		this.setValues(preparedStatement, values);
		return preparedStatement;
	}

	public int getIntFromDatabase(String query, int ifnotfound, Object... values) throws SQLException, Exception {
		PreparedStatement preparedStatement = this.prepareStatement(query, values);
		ifnotfound = this.getIntFromPreparedStmt(preparedStatement, ifnotfound);
		CommonUtil.close(preparedStatement);
		return ifnotfound;
	}

	public int getIntFromPreparedStmt(PreparedStatement preparedStatement, int ifnotfound, Object... values)
			throws SQLException, Exception {
		this.setValues(preparedStatement, values);
		ResultSet resultSet = preparedStatement.executeQuery();
		if (resultSet.first()) {
			ifnotfound = CommonUtil.getParamInt(resultSet.getString(1), ifnotfound);
		}
		CommonUtil.close(resultSet);
		return ifnotfound;
	}
	public String getStringFromDatabase(String query,String ifnotfound, Object... values) throws SQLException,Exception {
        PreparedStatement preparedStatement = this.prepareStatement(query, values);
        ifnotfound=this.getStringFromPreparedStmt(preparedStatement, ifnotfound);
        CommonUtil.close(preparedStatement);
        return ifnotfound;
    }
    public String getStringFromPreparedStmt(PreparedStatement preparedStatement,String ifnotfound, Object... values) throws SQLException,Exception {
    	this.setValues(preparedStatement, values);
        ResultSet resultSet = preparedStatement.executeQuery();
        if(resultSet.first()){
        	ifnotfound=CommonUtil.getParamString(resultSet.getString(1),ifnotfound) ;
        }
        CommonUtil.close(resultSet);
        return ifnotfound;
    }
    public Integer executeInsert(String query, Object... values) throws SQLException {
        PreparedStatement preparedStatement = this.prepareInsertStatement(query, values);
        preparedStatement.executeUpdate();
        ResultSet rs = preparedStatement.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
        CommonUtil.close(rs);
        CommonUtil.close(preparedStatement);
        return 0;
    }
    public ResultSet selectFromDatabase(String query, Object... values) throws SQLException {
        ResultSet resultSet;
        PreparedStatement preparedStatement = this.prepareStatement(query, values);
      //  System.out.println("executeSelect > "+preparedStatement);

        resultSet = preparedStatement.executeQuery();
        return resultSet;
    }

	public void setValues(PreparedStatement preparedStatement, Object... values) throws SQLException {
		if (null != values) {
			for (int i = 0; i < values.length; i++) {
				preparedStatement.setObject(i + 1, values[i]);
			}
		}
	}
	
	public int getTotalCount(){
    	return CommonUtil.getCounts(connection);
    }

}
