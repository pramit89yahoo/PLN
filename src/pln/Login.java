package pln;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import general.CommonUtil;
import general.DbUtils;
import general.Root;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public Login() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println(request.getParameter("uname"));
        Root root = new Root();
        
        try{
        	root.getConnection();
        	DbUtils dbutil=new DbUtils(root.con);
        	HttpSession session = request.getSession(true);
            String sql="SELECT uid FROM users u WHERE u.uname =? AND u.upwd=? AND u.`ustatus`='active'";
            String uname =CommonUtil.getParamString(request.getParameter("uname"),"");
            String upwd =CommonUtil.getParamString(request.getParameter("upwd"),"");
            int uid=dbutil.getIntFromDatabase(sql,0,uname,upwd);
            if(uid>0)
            {
            	session.setAttribute("uid",uid);
            	response.sendRedirect("home.jsp");
				return;
            }
            else{
            	response.sendRedirect("login.jsp?notfound=1");
				return;
            }
        }
        catch(Exception ex)
        {
        	ex.printStackTrace();
        }
        finally{
        	root.closeConnection();
        }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
