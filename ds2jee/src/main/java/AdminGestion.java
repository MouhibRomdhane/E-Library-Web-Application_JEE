

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.Date;

/**
 * Servlet implementation class AdminGestion
 */
public class AdminGestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminGestion() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	// TODO Auto-generated method stub
		String action = request.getParameter("action");
		int id =Integer.parseInt(request.getParameter("id"));
		try {
			// Chargement du pilote JDBC
			Class.forName("org.postgresql.Driver");
			Connection connection =DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");

			
			if("deleteBook".equals(action)) {
	        	
	        	
	        	
	        	
	        	String sql="DELETE FROM test.livres WHERE id=?; ";
				PreparedStatement stmt =connection.prepareStatement(sql);
				stmt.setInt(1, id);

				stmt.executeUpdate();
				request.setAttribute("updateStatus", true);
				request.getRequestDispatcher("gestiondeslivres.jsp").forward(request, response);
	        } else if("deleteAuteur".equals(action)) {
          
					
					String sql="DELETE FROM test.auteurs"
							+ "	WHERE id=?;";
					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		 
	    			stmt.setInt(1, id);
	    			stmt.executeUpdate();
	    			response.sendRedirect("gestiondesauteurs.jsp");
	              }
	        else if("deleteCategorie".equals(action)) {
	            
				
				String sql="DELETE FROM test.catégories"
						+ "	WHERE id=?;";
				PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	 
    			stmt.setInt(1, id);
    			stmt.executeUpdate();
    			response.sendRedirect("gestiondescategories.jsp");
              }
       	
           	
           
			}catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Erreur lors de la connexion à labase de données.", e);
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

				
				if ("ajouterLivre".equals(action)) {
					
					String titre = request.getParameter("titre");
					String resume = request.getParameter("resume");
					String an=request.getParameter("annee");
					int annee = Integer.parseInt(an);
					String path = request.getParameter("path");
					String format = request.getParameter("format");
					String autori = request.getParameter("autoris");
				     boolean autoris = Boolean.parseBoolean(autori);
					String[] auteurs = request.getParameterValues("auteur");
					String catig = request.getParameter("categorie");
					int categorie = Integer.parseInt(catig);
					
					String sql="INSERT INTO test.livres"
							+ "(titre, resume, annee, format, categorie_id, autorisation, file_path)"
							+ "	VALUES (?, ?, ?, ?, ?, ?, ?); ";
					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

	    			stmt.setString(1, titre);
	    			stmt.setString(2, resume);
	    			stmt.setInt(3, annee);
	    			stmt.setString(4, format);
	    			stmt.setInt(5, categorie);
	    			stmt.setBoolean(6, autoris);
	    			stmt.setString(7, path);
	    			stmt.executeUpdate();
	    			
	    	               ResultSet rs = stmt.getGeneratedKeys();
	    	                if (rs.next()) {
	    	                    long lastInsertedId = rs.getLong(1);
	    	                	String sql2="INSERT INTO test.livre_auteurs"
	    		    					+ "	(livre_id,auteur_id)"
	    		    					+ "	VALUES (?,?);";
	    		    			PreparedStatement pstmt = connection.prepareStatement(sql2);
	    		    			 for (String aut : auteurs) {
	    		                     long autid = Long.parseLong(aut); // Convert String to int
	    		                     pstmt.setLong(1, lastInsertedId);
	    		                     pstmt.setLong(2, autid);
	    		                     pstmt.executeUpdate();
	    		                 }
	    		    			
	    	                }
	    	               
	    	                response.sendRedirect("gestiondeslivres.jsp");
	    	           
	    		
					
	            }else if("modifierLivre".equals(action)) {
	            
	            	String id=request.getParameter("id");
	            	
					int idbook = Integer.parseInt(id);
	            	String titre = request.getParameter("titre");
					String resume = request.getParameter("resume");
					String an=request.getParameter("annee");
					int annee = Integer.parseInt(an);
					String path = request.getParameter("path");
					String format = request.getParameter("format");
					String autori = request.getParameter("autoris");
				     boolean autoris = Boolean.parseBoolean(autori);
					String[] auteurs = request.getParameterValues("auteur");
					String catig = request.getParameter("categorie");
					int categorie = Integer.parseInt(catig);
	            	String sql="UPDATE test.livres"
	            			+ "	SET titre=?, resume=?, annee=?, format=?, categorie_id=?, autorisation=?, file_path=?"
	            			+ "	WHERE id=?";
	            	PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	    			stmt.setString(1, titre);
	    			stmt.setString(2, resume);
	    			stmt.setInt(3, annee);
	    			stmt.setString(4, format);
	    			stmt.setInt(5, categorie);
	    			stmt.setBoolean(6, autoris);
	    			stmt.setString(7, path);
	    			stmt.setInt(8, idbook);
	    			stmt.executeUpdate();
	    	     	String sql1="DELETE FROM test.livre_auteurs"
	    	     			+ "	WHERE livre_id=?;";
	            	PreparedStatement stmt1 = connection.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
	            	stmt1.setInt(1,idbook);
	            	stmt1.executeUpdate();
 	             
 	                    
 	                	String sql2="INSERT INTO test.livre_auteurs"
 		    					+ "	(livre_id,auteur_id)"
 		    					+ "	VALUES (?,?);";
 		    			PreparedStatement pstmt = connection.prepareStatement(sql2);
 		    			 for (String aut : auteurs) {
 		                     long autid = Long.parseLong(aut); // Convert String to int
 		                     pstmt.setLong(1, idbook);
 		                     pstmt.setLong(2, autid);
 		                     pstmt.executeUpdate();
 		                 }
 		    			response.sendRedirect("gestiondeslivres.jsp");
 	                }
 	              else if("ajoutauteur".equals(action)) {
 	                
 	            	 String nom = request.getParameter("nom");
 					String date = request.getParameter("datenes");
 					
 					String sql="INSERT INTO test.auteurs"
 							+ "	(nom, date_de_naissance)"
 							+ "	VALUES (?, ?);";
 					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
 					LocalDate localDate = LocalDate.parse(date);
 					  java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);
 	    			stmt.setString(1, nom);
 	    			stmt.setDate(2,sqlDate);
 	    			stmt.executeUpdate();
 	    			response.sendRedirect("gestiondesauteurs.jsp");
 	              }
 	             else if("ModifierAuteur".equals(action)) {
	                String id=request.getParameter("id");
					int idauth = Integer.parseInt(id);
 	            	 String nom = request.getParameter("nom");
 					String date = request.getParameter("datenes");
 					
 					String sql="UPDATE test.auteurs SET nom=?,date_de_naissance=? WHERE id=?;";
 					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
 					LocalDate localDate = LocalDate.parse(date);
 					  java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);
 					 
 					  stmt.setString(1, nom);
 	    			stmt.setDate(2,sqlDate);
 	    			stmt.setInt(3, idauth);
 	    			stmt.executeUpdate();
 	    			response.sendRedirect("gestiondesauteurs.jsp");
 	              }
 	            else if("modifierCategorie".equals(action)) {
	                String id=request.getParameter("id");
					int idauth = Integer.parseInt(id);
 	            	 String nom = request.getParameter("nom");
 					
 					
 					String sql="UPDATE test.catégories SET nom=? WHERE id=?;";
 					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); 
 					 stmt.setString(1, nom);
 	    			stmt.setInt(2, idauth);
 	    			stmt.executeUpdate();
 	    			response.sendRedirect("gestiondescategories.jsp");
 	              }
 	           else if("AjouterCategorie".equals(action)) {
	                
	            	 String nom = request.getParameter("nom");
					
					
					String sql="INSERT INTO test.catégories"
							+ "	( nom)"
							+ "	VALUES ( ?);";
					PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); 
					 stmt.setString(1, nom);
	    			
	    			stmt.executeUpdate();
	    			response.sendRedirect("gestiondescategories.jsp");
	              }
	               
 	               
 	                
	            
	           	
	           
				}catch (Exception e) {
				e.printStackTrace();
				throw new ServletException("Erreur lors de la connexion à labase de données.", e);
				}
				}
		}