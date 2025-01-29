import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/EpubServlet")
public class EpubServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is required");
            return;
        }

        int idbook = Integer.parseInt(id);
        String sql = "SELECT file_path FROM test.livres WHERE id = ?";

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, idbook);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String filePath = rs.getString("file_path");
                // Construct the file path based on the WEB-INF/epubs directory
                String absoluteFilePath = getServletContext().getRealPath("/WEB-INF/epubs/" + new File(filePath).getName());
                File file = new File(absoluteFilePath);
                if (file.exists()) {
                    response.setContentType("application/epub+zip");
                    response.setHeader("Content-Disposition", "inline;filename=" + file.getName());

                    try (FileInputStream in = new FileInputStream(file);
                         OutputStream out = response.getOutputStream()) {
                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = in.read(buffer)) != -1) {
                            out.write(buffer, 0, bytesRead);
                        }
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
