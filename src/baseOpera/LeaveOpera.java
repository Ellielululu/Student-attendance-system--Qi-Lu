package baseOpera;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Leave;
import model.Page;

public class LeaveOpera extends baseOpera {
	public boolean addLeave(Leave leave){
		String sql = "INSERT INTO `leave` VALUES(null,"+leave.getStudentId()+",'"+leave.getInfo()+"',"+Leave.LEAVE_STATUS_WAIT+",'"+leave.getRemark()+"')";
		return update(sql);
	}
	
	
	public boolean editLeave(Leave leave){
		String sql = "update `leave` set student_id = "+leave.getStudentId()+", info = '"+leave.getInfo()+"',status = "+leave.getStatus()+",remark = '"+leave.getRemark()+"' where id = " + leave.getId();
		return update(sql);
	}
	
	public boolean deleteLeave(int id) {
		// TODO Auto-generated method stub
		String sql = "delete from `leave` where id = " + id ;
		return update(sql);
	}
	
	
	public List<Leave> getLeaveList(Leave leave,Page page){
		List<Leave> ret = new ArrayList<Leave>();
		String sql = "select * from `leave` ";
		if(leave.getStudentId() != 0){
			sql += " and student_id = " + leave.getStudentId() + "";
		}
		sql += " limit " + page.getStart() + "," + page.getPageSize();
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				Leave l = new Leave();
				l.setId(resultSet.getInt("id"));
				l.setStudentId(resultSet.getInt("student_id"));
				l.setInfo(resultSet.getString("info"));
				l.setStatus(resultSet.getInt("status"));
				l.setRemark(resultSet.getString("remark"));
				ret.add(l);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	public int getLeaveListTotal(Leave leave){
		int total = 0;
		String sql = "select count(*)as total from `leave` ";
		if(leave.getStudentId() != 0){
			sql += " and student_id = " + leave.getStudentId() + "";
		}
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				total = resultSet.getInt("total");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}
}
