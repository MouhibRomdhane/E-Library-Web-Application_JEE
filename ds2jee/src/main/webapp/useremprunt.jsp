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
      background:radial-gradient(#c93f35, #bf3d49);
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

        .card-body .remaining-days {
            font-size: 16px;
            font-weight: 600;
            color: #ff6b6b;
            background-color: #ffe5e5;
            padding: 5px 10px;
            border-radius: 4px;
        }

        .card-body button {
            padding: 8px 16px;
            font-size: 14px;
            color: white;
            background-color: #28a745;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-body button:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

     </style>   
    
</head>
<body>

   <%@include file="navbar.html" %>
<div class="container">
 <%
          int userId = (int) request.getSession().getAttribute("userId");
            List<Livre> books = getBooksEmprunter(userId);
            if (books == null){%>
            <h1>il n'ya pas des livres emprunter</h1>
            <% 
            	
            }else {
                for (Livre book : books) {
                	String noms="";
                	for (Auteur auteur:book.getAuteurs())
                	{
                		noms=noms+" "+auteur.getnom();
                	}
        %>
           <div class="card">
            <div class="card-header">
                <h3><%= book.getTitre() %></h3>
                <p>Auteur(s): <%= noms %></p>
                <p>Categorie: <%= book.getCategorie() %></p>
            </div>
            <div class="card-body">
                <span class="remaining-days"><%= book.getAnnee() %>  jours restant</span>
                <form action="GestionLivres" method="post">
                <input type="hidden" name="id" value="<%= book.getId() %>"><br>
                 <button  type="submit" name="action" value="Viewbook">lire le livre</button>
                </form>
               
            </div>
        </div>
           
       
  
               
        <%   }
            } %>
      </div>
  
    
  
      
</body>
</html>
<%!
private List<Livre> getBooksEmprunter(int id) {
    List<Livre> books = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	String username = "postgres";
	String password = "58358905";
	 try {
		Class.forName("org.postgresql.Driver");
    Connection conn = DriverManager.getConnection(url, username, password);
        String sql;
    
            sql = "SELECT livres.id,livres.titre,catégories.nom,livres.autorisation,  empruntlivre.date_retour-empruntlivre.date_emprunt AS days_between FROM test.utilisateurs,test.livres,test.catégories,test.empruntlivre where livres.id=empruntlivre.livre_id and empruntlivre.user_id=? and livres.categorie_id=catégories.id and utilisateurs.id=empruntlivre.user_id and empruntlivre.date_retour>=CURRENT_DATE  ;";
      

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        	stmt.setInt(1, id);
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
                    books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",rs.getInt("days_between"),"", rs.getString("nom"),rs.getBoolean("autorisation")));
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