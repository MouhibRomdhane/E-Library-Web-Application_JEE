<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.sql.*,ds2jee.Livre,ds2jee.Auteur,ds2jee.Categorie" %>

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
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #eef2f7;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 250px;
            background: radial-gradient(#c93f35, #bf3d49);
            color: white;
            padding: 20px;
            height: 100vh;
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

        .main-content {
            flex-grow: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 30px;
            overflow-y: auto;
        }

        .card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 70%;
            margin: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            font-size: 28px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"], input[type="number"], select, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .scroll-box-container {
            display: flex;
            gap: 20px;
        }

        .scroll-box {
            flex: 1;
        }

        button {
            padding: 12px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 18px;
            width: 100%;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <%@include file="adnavbar.html" %>

    <div class="main-content">
        <div class="card">
            <h1>Ajouter un livre</h1>
       
            <form action="AdminGestion" method="post">
               
                
                <div class="form-group">
                    <label for="titre">Titre</label>
                    <input type="text" id="titre" name="titre"  required>
                </div>

                <div class="form-group">
                    <label for="resume">Résumé</label>
                    <textarea id="resume" name="resume" rows="4" required></textarea>
                </div>

                <div class="form-group">
                    <label for="annee">Année</label>
                    <input type="number" id="annee" name="annee"  required>
                </div>

                <div class="form-group">
                    <label for="format">Format</label>
                    <select class="selectpicker" name="format" id="format">
                        <option value="PDF" >PDF</option>
                        <option value="EPUB"  >EPUB</option>
                    </select>
                </div>
               <div class="form-group">
                    <label for="autoris">Autorisation</label>
                    <select class="selectpicker" name="autoris" id="autoris">
                        <option value="true" >Telecharger</option>
                        <option value="false"  >Lire</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="path">Path</label>
                    <input type="text" id="path" name="path"  required>
                </div>

                <div class="scroll-box-container">
                    <div class="scroll-box">
                        <label for="auteur">Auteur(s)</label>
                        <select class="selectpicker" multiple data-live-search="true" name="auteur" id="auteur">
                           <%
        List<Auteur> auteurs = getAuteurs();
            for (Auteur aut : auteurs) {
            	
            
        %>
 
            	  <option value="<%=aut.getId()%>" ><%=aut.getnom()%></option>
   <%
            	
 }
  %>
                        </select>
                    </div>

                    <div class="scroll-box">
                        <label for="categorie">Catégories</label>
                            <select class="selectpicker" data-live-search="true" name="categorie" id="categorie">
                     <%
        List<Categorie> categories = getCategorie();
            for (Categorie cat : categories) {
            	
            
        %>
 
            	  <option value="<%=cat.getId()%>" ><%=cat.getName()%></option>
   <%
            	
 }
  %>
                        </select>
                    </div>
                </div>

                <button type="submit" name="action" value="ajouterLivre" >Enregistrer</button>
            </form>
        

            <script>
                $(document).ready(function() {
                    $('.selectpicker').selectpicker();
                });
            </script>
        </div>
    </div>
</body>
</html>
<%!

private List<Auteur> getAuteurs(){   
	String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
String username = "postgres";
String password = "58358905";
List<Auteur> auteurs=new ArrayList<>();
 try {
	Class.forName("org.postgresql.Driver");
Connection conn = DriverManager.getConnection(url, username, password);
    String sql;
  
sql="select * from test.auteurs ";
   PreparedStatement stmt = conn.prepareStatement(sql);
   ResultSet rs = stmt.executeQuery();
  
   while(rs.next())
   {
	   auteurs.add(new Auteur(rs.getInt("id"),rs.getString("nom")));
   }
           
    
} catch (SQLException e) {
    e.printStackTrace();
} catch (ClassNotFoundException e) {
	
	e.printStackTrace();
	}
	return auteurs;
	}
private List<Categorie> getCategorie(){   
	String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
String username = "postgres";
String password = "58358905";
List<Categorie> categories=new ArrayList<>();
 try {
	Class.forName("org.postgresql.Driver");
Connection conn = DriverManager.getConnection(url, username, password);
    String sql;
  
sql="select * from test.catégories ";
   PreparedStatement stmt = conn.prepareStatement(sql);
   ResultSet rs = stmt.executeQuery();
  
   while(rs.next())
   {
	   categories.add(new Categorie(rs.getInt("id"),rs.getString("nom")));
   }
           
    
} catch (SQLException e) {
    e.printStackTrace();
} catch (ClassNotFoundException e) {
	
	e.printStackTrace();
	}
	return categories;
	}

%>