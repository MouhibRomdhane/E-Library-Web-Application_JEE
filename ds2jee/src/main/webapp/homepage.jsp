<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.sql.*,ds2jee.Livre,ds2jee.Auteur" %>

<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Livres</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    
    <link rel="stylesheet" type="text/css" href="testcss.css">
    <style >
        /* Floating card styling */
        .floating-card {
            display: none; /* Hidden by default */
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #d4edda;
            color: #155724;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            z-index: 1000;
        }

        .floating-card button {
            margin-top: 15px;
            background-color: #155724;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
        }

        .floating-card button:hover {
            background-color: #0d4418;
        }

        /* Background overlay */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }</style>
</head>
<body>
   <div class="main-container">
   <%@include file="navbar.html" %>
     <div class="content">
<div class="search-bar">
    <!-- Barre de recherche -->
    <form action="homepage.jsp" method="get">
        <input type="text" name="query" placeholder="Rechercher par titre, auteur, ou catégorie">
        <button type="submit">Rechercher</button>
    </form>
   
</div>
    <!-- Affichage des derniers livres ajoutés ou des résultats de recherche -->
    <h2>
        <%
            String query = request.getParameter("query");
            if (query != null && !query.isEmpty()) {
                out.print("Résultats de recherche pour: " + query);
            } else {
                out.print("Derniers livres ajoutés");
            }
        %>
    </h2>
<%
        Boolean updateStatus = (Boolean) request.getAttribute("updateStatus");
        if (updateStatus != null && updateStatus) {
    %>
         <div class="overlay"></div>

  
    <div class="floating-card" id="successCard">
        <p>The modification was successfully completed!</p>
        <button onclick="hideCard()">OK</button>
    </div>
    <%
        } %>
     <div class="book-container"> 

        <%
            List<Livre> books = getBooksFromDatabase(query);
            if (books != null) {
                for (Livre book : books) {
                	
                	String noms = getAuthorsString(book.getAuteurs());
        %>
           
        <div class="book-card" >
          <h3><%= book.getTitre() %> </h3>
           <p><strong>Auteurs:</strong><%= noms %> </p>
           <p><strong>Catégorie:</strong><%= book.getCategorie() %></p>
          <a href="consulterlivre.jsp?id=<%= book.getId() %>"class="btn consult">Consulter</a>
   
        </div>
               
        <%   }
            } %>
   </div>
 </div>
 </div>
 
    <script>
        // Show the appropriate card based on the update status
        window.onload = function() {
            const updateStatus = '<%= request.getAttribute("updateStatus") %>';
            if (updateStatus === 'true') {
                showCard('successCard');
            } else if (updateStatus === 'false') {
                showCard('errorCard');
            }
        };

        function showCard(cardId) {
            document.getElementById(cardId).style.display = 'block';
            document.querySelector('.overlay').style.display = 'block';
        }

        function hideCard() {
            document.querySelectorAll('.floating-card').forEach(card => {
                card.style.display = 'none';
            });
            document.querySelector('.overlay').style.display = 'none';
        }
    </script>
</body>
</html>

<%!
    private List<Livre> getBooksFromDatabase(String query) {
        List<Livre> books = new ArrayList<>();
        String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
		String username = "postgres";
		String password = "58358905";
		 try {
			Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);
            String sql;
            if (query == null || query.isEmpty()) {
                sql = "SELECT livres.id,livres.titre,catégories.nom,livres.autorisation  FROM test.livres,test.catégories where livres.categorie_id=catégories.id  ORDER BY livres.id DESC";
            } else {
                sql = "SELECT livres.id,livres.titre, catégories.nom,livres.autorisation  FROM test.livres JOIN test.livre_auteurs ON livres.id=livre_auteurs.livre_id JOIN test.auteurs ON livre_auteurs.auteur_id = auteurs.id JOIN test.catégories ON livres.categorie_id = catégories.id	WHERE   livres.titre LIKE ? OR auteurs.nom LIKE ?   OR catégories.nom LIKE ?;";
                
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (query != null && !query.isEmpty()) {
                    stmt.setString(1, "%" + query + "%");
                    stmt.setString(2, "%" + query + "%");
                    stmt.setString(3, "%" + query + "%");
                }

                try (ResultSet rs = stmt.executeQuery()) {
                	String sql2="select * from test.livre_auteurs where livre_id= ?";
                	String sql1 ="Select id ,nom from test.auteurs where id=?;" ;
                    while (rs.next()) {List<Auteur> authors = new ArrayList<>();
                    	PreparedStatement stmt3 = conn.prepareStatement(sql2);
                    	stmt3.setInt(1, rs.getInt("id"));
                    	ResultSet rs3 = stmt3.executeQuery();
                    	while(rs3.next())
                    	{
                    	PreparedStatement stmt2 = conn.prepareStatement(sql1);
                    	stmt2.setInt(1, rs3.getInt("auteur_id"));
                    	ResultSet rs2 = stmt2.executeQuery();
                    	
                    	while(rs2.next())
                    	{
                         Auteur auteur=new Auteur(rs2.getInt("id"),rs2.getString("nom"));
                         authors.add(auteur);
                         }}
                        books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",0,"", rs.getString("nom"),rs.getBoolean("autorisation")));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
        	
        	e.printStackTrace();
        	}
        return books;
    }
private String getAuthorsString(List<Auteur>auteurs) {
    String authors = "";
    for (int i = 0; i <auteurs.size(); i++) {
        if (i==auteurs.size()-1)
        	authors+=auteurs.get(i).getnom();
        else
        	authors+=auteurs.get(i).getnom()+",";
      }
	
    return authors;
}
%>