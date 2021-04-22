package baseOpera;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.dbUtil;

public class baseOpera {
     private dbUtil dbutil=new dbUtil();
     
     public void closeCon(){
    	 dbutil.closeCon();
     }
     
     public ResultSet query(String sql){
    	
    	 try {
			
    		PreparedStatement prepareStatement = dbutil.getConnection().prepareStatement(sql);
		    return prepareStatement.executeQuery();
    	 } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	 return null;
     }
     public boolean update(String sql){
    	 try {
			return dbutil.getConnection().prepareStatement(sql).executeUpdate()>0;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	 return false;
     }
     }

