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
    
    .container {
    padding=10px;
                max-width: 840px;
            width: 100%;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .card {
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s ease-in-out;
            flex: 1 1 calc(50% - 10px); /* Adjusts each card to take half the row with gap */
            width:400px;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card-header {
            padding: 15px 20px;
            background-color: #c93f35;
            color: white;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        .card-header h3 {
            margin: 0;
            font-size: 18px;
        }

        .card-header p {
            margin: 5px 0;
            font-size: 14px;
            color: #cce5ff;
        }

        .card-body {
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }


    .heart-container {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #ffcccc;
            border-radius: 50%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
          a{
          color:#c93f35;
          } 
           a:hover{
          color:#c93f35;
          } 
     </style> 
       
    
</head>
<body>

   <%@include file="navbar.html" %>
<div class="container">
 <%
          int userId = (int) request.getSession().getAttribute("userId");
            List<Livre> books = getBooksfavorits(userId);
            if (books.isEmpty()){%>
            <div class="card">
              <div class="card-header">
            <div class="card-body">
            <h3>il n'ya pas des livres dans la liste favoris</h3>
            </div>
            </div>
            </div>
            <% 
            	
            }else {
                for (Livre book : books) {
                	String noms="";
                	for (Auteur auteur:book.getAuteurs())
                	{
                		noms=noms+" "+auteur.getnom();
                	}
        %> <div class="card">
        <a href="consulterlivre.jsp?id=<%= book.getId() %>" class="card-link">
          
            <div class="card-header">
                <h3><%= book.getTitre() %></h3>
                <p>Auteur(s): <%= noms %></p>
                <p>Categorie: <%= book.getCategorie() %></p>
            </div>
            <div class="card-body">
            <div class="heart-container">
        <div class="heart">♥</div>
    </div>
               
            </div>
      
           </a>
         </div>
  
               
        <%   }
            } %>
      </div>
  
    
  
      
</body>
</html>
<%!
private List<Livre> getBooksfavorits(int id) {
    List<Livre> books = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	String username = "postgres";
	String password = "58358905";
	 try {
		Class.forName("org.postgresql.Driver");
    Connection conn = DriverManager.getConnection(url, username, password);
        String sql;
    
            sql = "SELECT livres.id,livres.titre,catégories.nom from test.livres ,test.favoris, test.utilisateurs ,test.catégories where utilisateurs.id=? and ?=favoris.id_user and livres.id=favoris.id_livre and catégories.id=livres.categorie_id ;";
      

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        	 stmt.setInt(1, id);
        	 stmt.setInt(2, id);
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
                    books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",0,"", rs.getString("nom"),true));
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
%>