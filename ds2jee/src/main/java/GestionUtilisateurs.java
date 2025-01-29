
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.ResultSet;

/**
 * Servlet implementation class GestionUtilisateurs
 */
@WebServlet("/GestionUtilisateurs")
public class GestionUtilisateurs extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GestionUtilisateurs() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		if("logaout".equals(action))
		{
			  HttpSession session = request.getSession(false);
		        if (session != null) {
		            session.invalidate();
		        }
		        response.sendRedirect("login.jsp"); 
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		try {
			// Chargement du pilote JDBC
			Class.forName("org.postgresql.Driver");
			Connection connection =DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");

			
			if ("connexionLib".equals(action)) {
			String mail = request.getParameter("email");
			String mdp = request.getParameter("password");
			
			String ReqInsert = "Select * from test.utilisateurs where email=? and motdepasse =?";
			PreparedStatement stmt =connection.prepareStatement(ReqInsert);
			stmt.setString(1, mail);
			stmt.setString(2, mdp);
            ResultSet rs=stmt.executeQuery();
            if (rs.next()) {
            	  HttpSession session = request.getSession();
                  session.setAttribute("userId", rs.getInt("id"));
            	  if(rs.getString("role").compareTo("client")==0)
                response.sendRedirect("homepage.jsp");
            	  else
            		  response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Email ou mot de passe incorrect.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }}else if("inscriLib".equals(action)) {
            	String nompren = request.getParameter("nompren");
            	String mail = request.getParameter("mail");
    			String mdp = request.getParameter("password");
    			
    			String php1 = "Select * from test.utilisateurs where email=? ";
    			PreparedStatement stmt =connection.prepareStatement(php1);
    			stmt.setString(1, mail);
                ResultSet rs=stmt.executeQuery();
                if (rs.next()) {
                	  
                	request.setAttribute("errorMessage", "Utilisateur déja existe");
                    request.getRequestDispatcher("inscription.jsp").forward(request, response);
                } else {
                	String php2 = "INSERT INTO test.utilisateurs ( nom, email,motdepasse,role)VALUES ( ?, ?, ?, ?);";
        			PreparedStatement stmt2 =connection.prepareStatement(php2);
        			stmt2.setString(1, nompren);
        			stmt2.setString(2, mail);
        			stmt2.setString(3, mdp);
        			stmt2.setString(4,"client");
                    stmt2.executeUpdate();
                   
                    response.sendRedirect("login.jsp");
            	
            }
                }else if("ModifierProfil".equals(action))
                {
                	
                	int id = Integer.parseInt(request.getParameter("id"));
                	String nompren = request.getParameter("name");
                	String mail = request.getParameter("email");
        			String mdp = request.getParameter("password");
                	String sql="UPDATE test.utilisateurs"
                			+ "	SET nom=?, email=?, motdepasse=?"
                			+ "	WHERE id=? ; ";
    				PreparedStatement stmt =connection.prepareStatement(sql);
        			stmt.setString(1, nompren);
        			stmt.setString(2, mail);
        			stmt.setString(3, mdp);
        			stmt.setInt(4, id);
        			stmt.executeUpdate();
        			request.setAttribute("updateStatus", true);
                    request.getRequestDispatcher("espacepersonnel.jsp").forward(request, response);
                	
                	
                }
		
			}catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Erreur lors de la connexion à labase de données.", e);
			}
			}
	}


