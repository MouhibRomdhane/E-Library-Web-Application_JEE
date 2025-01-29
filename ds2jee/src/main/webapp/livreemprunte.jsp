<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.sql.*,ds2jee.Livre,ds2jee.Auteur" %>

<!DOCTYPE html>
<html>
<head>
    <title>Modifier Livre</title>
    
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
    
    <style>
      body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f3f4f6;
      color: #333;
      display: flex;
            flex-direction: column;
            align-items: center;
    }
    
    .main-container {
      display: flex;
    }
    
    /* Modern Sidebar */
    .sidebar {
      width: 250px;
      background: radial-gradient(#c93f35, #bf3d49);
      color: white;
      padding: 20px;
      height: 100vh;
      position: fixed;
      left: 0;
      top: 0;
      box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
    }
    
    .sidebar h2 {
      font-size: 22px;
      text-align: center;
      margin-bottom: 30px;
    }
    
    .sidebar ul {
      list-style: none;
      padding: 0;
    }
    
    .sidebar ul li {
      margin: 20px 0;
    }
    
    .sidebar ul li a {
      text-decoration: none;
      color: white;
      font-size: 18px;
      display: block;
      padding: 10px;
      border-radius: 5px;
      transition: background-color 0.3s ease;
    }
    
    .sidebar ul li a:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }
    
 .book-card {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
            margin: 20px 0;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .book-details {
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .book-details h2 {
            margin: 0 0 10px;
            font-size: 24px;
            color: #333333;
        }

        .book-details p {
            margin: 5px 0;
            font-size: 16px;
            color: #555555;
        }

        .book-date {
            padding: 15px;
            text-align: center;
            background-color: #c21f1f;
            color: #ffffff;
            font-size: 18px;
        }


     </style>   
    
</head>
<body>

   <%@include file="navbar.html" %>

 <%
            List<Livre> books = getBooksEmprunter();
            if (books == null){%>
            <h1>il n'ya pas des livres emprunter</h1>
            <% 
            	
            }else {
                for (Livre book : books) {
                	String noms = getAuthorsString(book.getAuteurs());
        %>
           
       <div class="book-card">
        <div class="book-details">
            <h2>  <%= book.getTitre() %></h2>
            <p>Auteur(s): <%= noms %></p>
            <p>Catégorie: <%= book.getCategorie() %></p>
        </div>
        <div class="book-date">
            Date:  <%= book.getDat_retour() %>
        </div>
  
         </div>      
        <%   }
            } %>
  
    
    <script>
        $(document).ready(function() {
            $('.selectpicker').selectpicker();
        });
    </script>
      
</body>
</html>
<%!
private List<Livre> getBooksEmprunter() {
    List<Livre> books = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	String username = "postgres";
	String password = "58358905";
	 try {
		Class.forName("org.postgresql.Driver");
    Connection conn = DriverManager.getConnection(url, username, password);
        String sql;
    
            sql = "SELECT livres.id,livres.titre,catégories.nom,livres.autorisation, empruntlivre.date_retour FROM test.livres,test.catégories,test.empruntlivre where livres.categorie_id=catégories.id and livres.id=empruntlivre.livre_id and empruntlivre.date_retour>=CURRENT_DATE ;";
      

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
           
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
                    books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",0,"", rs.getString("nom"),rs.getBoolean("autorisation"),rs.getDate("date_retour")));
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