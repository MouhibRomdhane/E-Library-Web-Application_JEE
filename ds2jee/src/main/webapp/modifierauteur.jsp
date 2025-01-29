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
          input[type="date"] {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            font-size: 16px;
            color: #333;
            width: 100%;
            cursor: pointer;
            transition: border-color 0.3s ease;
            margin-bottom: 20px; 
        }

        input[type="date"]:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.5);
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: invert(50%);
            opacity: 0.6;
        }

        input[type="date"]::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
        <%@include file="adnavbar.html" %>
    <%
        int auteurId = Integer.parseInt(request.getParameter("id"));
        Auteur auteur = getAuthorsById(auteurId);
        if (auteur == null) {
            out.print("<p>Livre non trouvé.</p>");
        } else {
       
    %>
  <div class="main-content">
   <div class="card">
   <h1>Modifier l'auteur</h1>
    <form   action="AdminGestion" method="post">
        <input type="hidden" name="id" id="id" value="<%=auteur.getId()%>">
        <label for="nom">Nom d'auteur</label>
        <input type="text" id="nom" name="nom" value="<%=auteur.getnom() %>" required>

       <label for="datenes">Date de naissance</label>
        <input type="date" id="datenes" name="datenes" value="<%=auteur.getDatenaissance() %>" required>

        <button type="submit" name="action" value="ModifierAuteur"  >Enregistrer</button>
    </form>
    <%} %>
    </div>
    </div>
    <script src="scripts.js"></script>
</body>
</html>

<%!
    private Auteur getAuthorsById(int id) {
        Auteur author = null;
        String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
		String username = "postgres";
		String password = "58358905";
		 try {
				Class.forName("org.postgresql.Driver");
	        Connection conn = DriverManager.getConnection(url, username, password);
            String sql;
           
                sql = "SELECT * FROM test.auteurs WHERE id = ?";
           
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
               
                    stmt.setInt(1, id);
           

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        author=new Auteur(rs.getInt("id"), rs.getString("nom"), rs.getDate("date_de_naissance"));
                    }
                }
            }
        }  catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
        	
        	e.printStackTrace();
        	}
        return author;
    }
%>