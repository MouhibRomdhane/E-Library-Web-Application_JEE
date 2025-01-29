

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class GestionLivres
 */
public class GestionLivres extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GestionLivres() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		int idbook =Integer.parseInt(request.getParameter("id"));
		int userId = (int) request.getSession().getAttribute("userId");
		try {
			// Chargement du pilote JDBC
			Class.forName("org.postgresql.Driver");
			Connection connection =DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");

			
			if ("AjoutFav".equals(action)) {
			
				
				String sql="INSERT INTO test.favoris(	id_livre, id_user)VALUES (?, ?); ";
				PreparedStatement stmt =connection.prepareStatement(sql);
    			stmt.setInt(1, idbook);
    			stmt.setInt(2, userId);
    			stmt.executeUpdate();
    			response.sendRedirect("consulterlivre.jsp?id="+idbook);

				
            }else if("SupFav".equals(action)) {
            	
				String sql="DELETE FROM test.favoris WHERE id_livre=? and id_user=?; ";
				PreparedStatement stmt =connection.prepareStatement(sql);
    			stmt.setInt(1, idbook);
    			stmt.setInt(2, userId);
    			stmt.executeUpdate();
    			response.sendRedirect("consulterlivre.jsp?id="+idbook);
            	
            }else if("Emprunterbook".equals(action)) {
            	
            	 String sql = "INSERT INTO test.empruntlivre (user_id, livre_id, date_emprunt, date_retour) VALUES (?, ?, CURRENT_DATE, CURRENT_DATE+INTERVAL '14 DAY')";                 
            	 PreparedStatement stmt = connection.prepareStatement(sql) ;

               

            	        stmt.setInt(1, userId);
                          stmt.setInt(2, idbook);
                          stmt.executeUpdate();
                          
                          request.setAttribute("updateStatus", true);
                          request.getRequestDispatcher("useremprunt.jsp").forward(request, response);
                          
               
            }else if("Downloadbook".equals(action)) {
            	
            	 String sql = "SELECT titre, file_path FROM test.livres WHERE id = ?";
            	 PreparedStatement stmt =connection.prepareStatement(sql);
     			stmt.setInt(1, idbook);
                 ResultSet rs = stmt.executeQuery();

                 if (rs.next()) {
                     String filePath = rs.getString("file_path");
                     String bookTitle = rs.getString("titre");

                     // Serve the file for download
                     File file = new File(filePath);
                     if (file.exists()) {
                    	  // Determine the content type based on the file extension
                         String contentType = "application/pdf";
                         if (filePath.toLowerCase().endsWith(".epub")) {
                             contentType = "application/epub+zip";
                         }
                         response.setHeader("Content-Disposition", "attachment;filename=" + bookTitle.replace(" ", "_") + "." + (contentType.endsWith("pdf") ? "pdf" : "epub"));

                         try (FileInputStream in = new FileInputStream(file);
                              OutputStream out = response.getOutputStream()) {
                             byte[] buffer = new byte[1024];
                             int bytesRead;
                             while ((bytesRead = in.read(buffer)) != -1) {
                                 out.write(buffer, 0, bytesRead);
                             }
                         }
                         
                         String sql2 = "INSERT INTO test.telechargement( user_id, livre_id, date) VALUES ( ?, ?, CURRENT_DATE);";
                    	 PreparedStatement stmt2 =connection.prepareStatement(sql2);
                    	 stmt2.setInt(1, userId);
             			stmt2.setInt(2, idbook);
                         stmt2.executeUpdate();

                         
                     } else {
                         response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                     }
                 } else {
                     response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                 }
            	
            }else if ("Viewbook".equals(action)) {
                String sql = "SELECT titre, file_path FROM test.livres WHERE id = ?";
                PreparedStatement stmt = connection.prepareStatement(sql);
                stmt.setInt(1, idbook);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String filePath = rs.getString("file_path");
                    String title = rs.getString("titre");
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();

                    out.println("<!DOCTYPE html>");
                    out.println("<html lang='en'>");
                    out.println("<head>");
                    out.println("<meta charset='UTF-8'>");
                    out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
                    out.println("<title>Voir livre</title>");
                    out.println("<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css\">");
                    out.println("<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css\" />");
                    out.println("<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>");
                    out.println("<script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js\"></script>");
                    out.println("<script src=\"https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js\"></script>");
                    out.println("<script src=\"https://cdn.jsdelivr.net/npm/epubjs@0.3.83/dist/epub.min.js\"></script>");
                    out.println("<style>");
                    out.println("iframe { width: 100%; height: 90vh; border: 1px solid #ccc; }");
                    out.println("body { font-family: 'Arial', sans-serif; margin: 0; padding: 0; background-color: #f3f4f6; color: #333; display: flex; flex-direction: column; align-items: center; }");
                    out.println(".main-container { display: flex; }");
                    out.println("/* Modern Sidebar */");
                    out.println(".sidebar { width: 250px; background: radial-gradient(#c93f35, #bf3d49); color: white; padding: 20px; height: 100vh; position: fixed; left: 0; top: 0; box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1); }");
                    out.println(".sidebar h2 { font-size: 22px; text-align: center; margin-bottom: 30px; }");
                    out.println(".sidebar ul { list-style: none; padding: 0; }");
                    out.println(".sidebar ul li { margin: 20px 0; }");
                    out.println(".sidebar ul li a { text-decoration: none; color: white; font-size: 18px; display: block; padding: 10px; border-radius: 5px; transition: background-color 0.3s ease; }");
                    out.println(".sidebar ul li a:hover { background-color: rgba(255, 255, 255, 0.2); }");
                    out.println("</style>");
                    out.println("</head>");
                    out.println("<nav class=\"sidebar\">");
                    out.println("      <h2>Mon bibliotheque</h2>");
                    out.println("      <ul>");
                    out.println("        <li><a href=\"homepage.jsp\">Acceuil</a></li>");
                    out.println("        <li><a href=\"useremprunt.jsp\">Mes emprunts</a></li>");
                    out.println("        <li><a href=\"favoris.jsp\">Favoris </a></li>");
                    out.println("       <li><a href=\"espacepersonnel.jsp\">Espace personnel</a></li>");
                    out.println("        <li><a href=\"GestionUtilisateurs?action=logaout\">deconnexion</a></li>");
                    out.println("      </ul>");
                    out.println("    </nav>");

                    // Determine the file type and embed the appropriate viewer
                    if (filePath.toLowerCase().endsWith(".pdf")) {
                        out.println("<iframe src='ViewDoc?id=" + idbook + "'></iframe>"); // Embedded PDF
                    } else if (filePath.toLowerCase().endsWith(".epub")) {
                        out.println("<div id='epub-viewer' style='width: 100%; height: 90vh;'></div>");
                        out.println("<script>");
                        out.println("document.addEventListener('DOMContentLoaded', function() {");
                        out.println("    var book = ePub('EpubServlet?id=" + idbook + "');");
                        out.println("    var rendition = book.renderTo('epub-viewer', { width: '100%', height: '90vh' });");
                        out.println("    rendition.display();");
                        out.println("});");
                        out.println("</script>");
                    } else {
                        out.println("<p>Unsupported file format</p>");
                    }

                    out.println("</body>");
                    out.println("</html>");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                }
            }



			}catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Erreur lors de la connexion à labase de données.", e);
			}
			}
	}


