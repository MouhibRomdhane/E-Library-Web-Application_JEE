<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.sql.*,ds2jee.Livre,ds2jee.Auteur" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Livres</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
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

    
    <div class="main-content">
    <%@include file="adnavbar.html" %>
    <div class="content">
    
     

        <h2>
            <% 
                String query = request.getParameter("query");
            int id = Integer.parseInt(request.getParameter("id"));
                if (query != null && !query.isEmpty()) {
                    out.print("Résultats de recherche pour: " + query);
                } else {
                    out.print("Listes des livres d'auteur: ");
                }
            %>
        </h2>

        <div class="book-container">
            <% 
                List<Livre> books = getBooksFromDatabase(query,id);
            if (books.isEmpty())
            {%> <div class="book-card">
            	<h2>il n'y a pas des livres</h2>
            	</div>
            	<% 
            }
                if (books != null) {
                    for (Livre book : books) {
                        String noms =getAuthorsString(book.getAuteurs());
                       
            %>
            <div class="book-card">
                <h3><%= book.getTitre() %></h3>
                <p><strong>Auteurs:</strong> <%= noms %></p>
                <p><strong>Résumé:</strong> <%= book.getResume() %></p>
                <p><strong>Année:</strong> <%= book.getAnnee() %></p>
                <p><strong>Format:</strong> <%= book.getFormat() %></p>
                <p><strong>Catégorie:</strong> <%= book.getCategorie() %></p>
                
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
            if (confirm('Êtes-vous sûr de vouloir supprimer ce livre ?')) {
                window.location.href = 'book?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>


<%!
    private List<Livre> getBooksFromDatabase(String query,int id) {
        List<Livre> books = new ArrayList<>();
        String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
		String username = "postgres";
		String password = "58358905";
		 try {
			Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);
            String sql;
            if (query == null || query.isEmpty()) {
                sql = "SELECT * ,catégories.nom FROM test.livres,test.catégories ,test.livre_auteurs where livres.id=livre_auteurs.livre_id and livres.categorie_id=catégories.id and livre_auteurs.auteur_id=?  ORDER BY livres.id DESC";
            } else {
                sql = "SELECT livres.id,livres.titre,livres.annee,Livres.resume,livres.format, auteurs.nom, catégories.nom as categorie_id FROM test.livres JOIN test.livre_auteurs ON livres.id=livre_auteurs.livre_id JOIN test.auteurs ON livre_auteurs.auteur_id = auteurs.id JOIN test.catégories ON livres.categorie_id = catégories.id	WHERE livres.titre LIKE ?  OR catégories.nom LIKE ?;";

                		
                		
                	
                		  
                		
              
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (query != null && !query.isEmpty()) {
                    stmt.setString(1, "%" + query + "%");
                    stmt.setString(2, "%" + query + "%");
                    
                }
                else
                	stmt.setInt(1,id );

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
                        books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,rs.getString("resume"),rs.getInt("annee"),rs.getString("format"), rs.getString("nom"),true));
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