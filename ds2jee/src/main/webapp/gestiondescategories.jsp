<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, java.sql.*, ds2jee.Categorie" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Categories</title>
     <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
     <link rel="stylesheet" type="text/css" href="testcss.css">
</head>
<body>
      <div class="main-content">
  <%@include file="adnavbar.html" %>

    <div class="content">
        
    <div class="search-bar">
        <form action="gestiondescategories.jsp" method="get">
            <input type="text" name="query" placeholder="Rechercher par nom ">
            <button type="submit">Rechercher</button>
        </form>
         <form action="ajoutercategorie.jsp" method="get">
             
                <button type="submit" >Ajouter</button>
            </form>
    </div>
    
  <div class="book-container">
        <%
            String query = request.getParameter("query");
            List<Categorie> categories = getCategoriesFromDatabase(query);
            if (categories != null) {
                for (Categorie cat : categories) {
        %>
       <div class="book-card">
            <h3><%= cat.getName() %></h3>
            
            <div class="action-buttons">
                <a href="modifiercategorie.jsp?id=<%= cat.getId() %>" class="btn consult">Modifier</a>
                <a href="#" onclick="confirmDelete(<%= cat.getId() %>)" class="btn reserve">Supprimer</a>
                
            </div>
         </div>
        <%
                }
            }
        %>
        
   </div>
   </div>
   </div>

      <script>
        function confirmDelete(id) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cette catégorie ?')) {
                window.location.href = 'AdminGestion?action=deleteCategorie&id=' + id;
            }
        }
    </script> 
</body>
</html>

<%!
    private List<Categorie> getCategoriesFromDatabase(String query) {
        List<Categorie> categories = new ArrayList<>();
        String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
		String username = "postgres";
		String password = "58358905";
		 try {
				Class.forName("org.postgresql.Driver");
	        Connection conn = DriverManager.getConnection(url, username, password);
            String sql;
            if (query == null || query.isEmpty()) {
                sql = "SELECT * FROM test.catégories";
            } else {
                sql = "SELECT * FROM test.catégories WHERE nom LIKE ?";
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (query != null && !query.isEmpty()) {
                    stmt.setString(1, "%" + query + "%");
                }

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        categories.add(new Categorie(rs.getInt("id"), rs.getString("nom")));
                    }
                }
            }
        }  catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
        	
        	e.printStackTrace();
        	}
        return categories;
    }
%>