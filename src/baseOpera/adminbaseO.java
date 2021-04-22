package baseOpera;

import java.sql.ResultSet;
import java.sql.SQLException;

import model.admin;

public class adminbaseO extends baseOpera {
    public admin login(String name, String password){
    	String sql = "select * from admin where name = '" + name + "' and password = '" + password + "'";
    	ResultSet resultSet = query(sql);
    	try {
			if(resultSet.next()){
				admin admin=new admin();
				admin.setId(resultSet.getInt("id"));
				admin.setName(resultSet.getString("name"));
				admin.setPassword(resultSet.getString("password"));
				admin.setStatus(resultSet.getInt("status"));
				return admin;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return null;
    }
}
