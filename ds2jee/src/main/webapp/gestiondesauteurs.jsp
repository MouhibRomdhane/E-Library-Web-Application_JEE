<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, java.sql.*, ds2jee.Auteur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des auteurs</title>
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
            <form action="gestiondesauteurs.jsp" method="get">
                <input type="text" name="query" placeholder="Rechercher par nom de l'auteur">
                <button type="submit">Rechercher</button>
            </form>
             <form action="ajouterauteur.jsp" method="get">
             
                <button type="submit" >Ajouter</button>
            </form>
        </div>
     <h2>
            <% 
                String query = request.getParameter("query");
                if (query != null && !query.isEmpty()) {
                    out.print("Résultats de recherche pour: " + query);
                } else {
                    out.print("Listes des auteurs:");
                }
            %>
        </h2>
    <div class="book-container">
            <% 
               
                List<Auteur> authors = getAuthorsFromDatabase(query);
                if (authors != null) {
                	 
                    for (Auteur author : authors) {
                    	
            %>
            <div class="book-card">
              
                <h3><%= author.getnom() %></h3>
                <p>Date de naissance: <%= author.getDatenaissance() %></p>
                
                 
                <div class="action-buttons">
                    <a href="modifierauteur.jsp?id=<%= author.getId() %>" class="btn consult">Modifier</a>
                    <a href="#" onclick="confirmDelete(<%= author.getId() %>)" class="btn reserve">Supprimer</a>
                    <a href="listerauteurlivre.jsp?id=<%= author.getId() %>" class="btn consult">Voir les livres</a>
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
            if (confirm('Êtes-vous sûr de vouloir supprimer ce auteur ?')) {
                window.location.href = 'AdminGestion?action=deleteAuteur&id=' + id;
            }
        }
    </script>    
</body>
</html>


<%!
    private List<Auteur> getAuthorsFromDatabase(String query) {
        List<Auteur> authors = new ArrayList<>();
        String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
		String username = "postgres";
		String password = "58358905";
		 try {
				Class.forName("org.postgresql.Driver");
	        Connection conn = DriverManager.getConnection(url, username, password);
            String sql;
            if (query == null || query.isEmpty()) {
                sql = "SELECT * FROM test.auteurs";
            } else {
                sql = "SELECT * FROM test.auteurs WHERE nom LIKE ?";
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (query != null && !query.isEmpty()) {
                    stmt.setString(1, "%" + query + "%");
                }

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        authors.add(new Auteur(rs.getInt("id"), rs.getString("nom"), rs.getDate("date_de_naissance")));
                    }
                }
            }
        }  catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
        	
        	e.printStackTrace();
        	}
        return authors;
    }
%>