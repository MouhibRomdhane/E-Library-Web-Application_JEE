

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet implementation class ViewDoc
 */
public class ViewDoc extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:postgresql://localhost:5432/bibliotheque";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "58358905";  
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewDoc() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String bookIdParam = request.getParameter("id");

        if (bookIdParam == null || bookIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is required.");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdParam);
            String filePath = getFilePathFromDatabase(bookId);

            if (filePath != null) {
                streamPDF(response, filePath);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Book ID.");
        }
    }

    private String getFilePathFromDatabase(int bookId) {
        String filePath = null;

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT file_path FROM test.livres WHERE id = ?")) {

            pstmt.setInt(1, bookId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                filePath = rs.getString("file_path");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return filePath;
    }

    private void streamPDF(HttpServletResponse response, String filePath) throws IOException {
        File pdfFile = new File(filePath);

        if (pdfFile.exists()) {
            response.setContentType("application/pdf");

            // Set the Content-Disposition header to "inline" to avoid download options
            response.setHeader("Content-Disposition", "inline");

            // Prevent caching of the PDF file
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");

            // Stream the PDF content
            try (FileInputStream in = new FileInputStream(pdfFile);
                 OutputStream out = response.getOutputStream()) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF file not found.");
        }
    }
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
