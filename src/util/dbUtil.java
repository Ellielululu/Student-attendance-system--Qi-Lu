package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class dbUtil {
    
	private String dbUrl="jdbc:mysql://localhost:3306/student_attendance_system?useUnicode=true&characterEncoding=utf8";
	private String dbUser="root";
	private String dbPassword="angela4A";
	private String jdbcName="com.mysql.jdbc.Driver";
	private Connection connection=null;
	public Connection getConnection(){
		
		try {
			Class.forName(jdbcName);
			connection=DriverManager.getConnection(dbUrl,dbUser,dbPassword);
			System.out.print("connected!");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.print("connection failed!");
			e.printStackTrace();
		}
		
		return connection;
		
	}
	
	public void closeCon(){
		if(connection!=null){
			try {
				connection.close();
				System.out.print("connection closed!");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String[] args){
		dbUtil dbUtil=new dbUtil();
		dbUtil.getConnection();
	}
}
