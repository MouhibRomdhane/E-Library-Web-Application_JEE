<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.sql.*,ds2jee.Livre,ds2jee.Auteur" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
<meta charset="ISO-8859-1">
<style >
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
      background:  radial-gradient(#c93f35, #bf3d49);
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
    

        .content {
            flex-grow: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 30px;
            overflow-y: auto;
        }

        .profile-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .section-title {
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: bold;
            color: #333;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            position: relative;
        }

        label {
            font-weight: 600;
            font-size: 14px;
            color: #555;
        }

        input {
            width: 100%;
            padding: 16px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            transition: border-color 0.3s, box-shadow 0.3s;
            box-sizing: border-box;
        }

        input:focus {
            outline: none;
            border-color:#d95662;
            box-shadow: 0 0 8px rgba(255, 30, 0, 0.603);
        }

        .password-container {
            position: relative;
        }

        .password-container input {
            padding-right: 45px;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color:#d95662;
            font-size: 14px;
            background: none;
            border: none;
        }

        .save-button {
            background-color: #c93f35;
            color: white;
            border: none;
            padding: 16px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        .save-button:hover {
            background-color:#c93f35;
            transform: translateY(-2px);
        }

        .section-title {
            margin-bottom: 15px;
            font-size: 20px;
            font-weight: bold;
            color: #444;
        }

        .table-container {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 6px;
            background-color: #fff;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table thead th {
            position: sticky;
            top: 0;
            background-color:#c93f35;
            color: white;
            font-weight: bold;
            text-align: left;
            border: 1px solid #ddd;
            padding: 10px;
        }

        .table tbody td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
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
                width: 25%;
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
        }
</style>
<title>Espace personnel</title>
</head>
<body>
  <%@include file="navbar.html" %>
<%
int userId = (int) request.getSession().getAttribute("userId");
List<String> user=UserDetail(userId);


%>

 <div class="content">
 <%
        Boolean updateStatus = (Boolean) request.getAttribute("updateStatus");
        if (updateStatus != null && updateStatus) {
    %>
         <div class="overlay"></div>

  
    <div class="floating-card" id="successCard">
        <h2>Votre changement est enregistré</h2>
        <button onclick="hideCard()">OK</button>
    </div>
    <%
        } %>
        <div class="profile-container">
            <h2 class="section-title">Informations personnelles</h2>
            <form action="GestionUtilisateurs" method="post">
            <input type="hidden" name="id" value="<%= userId %>"><br>
                <div class="form-group">
                    <label for="name">Nom</label>
                    <input type="text" id="name" name="name" placeholder="changer votre nom" value="<%= user.get(0)%>">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="changer votre email" value="<%= user.get(1)%>">
                </div>
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="changer votre mot de passe" value="<%= user.get(2)%>">
                        <button type="button" class="toggle-password" onclick="togglePasswordVisibility()">Afficher</button>
                    </div>
                </div>
                <button type="submit" name="action" value="ModifierProfil"class="save-button">Enregistrer</button>
            </form>
        </div>

        <div>
            <h2 class="section-title">Livres téléchargés</h2>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Titre</th>
                            <th>Auteur</th>
                            <th>Date de dernier téléchargement</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%  List<Livre> books=getBookTelecharger(userId);          
                    		for (Livre book : books) {
                            	String noms=getAuthorsString(book.getAuteurs());
                            	
                    		%>
                        <tr>
                            <td><%=book.getTitre() %></td>
                            <td><%=noms%></td>
                            <td><%=book.getDat_retour() %></td>
                        </tr>
                   <%} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div>
            <h2 class="section-title">Livres empruntés</h2>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Titre</th>
                            <th>Auteur</th>
                            <th>Etat de l'emprunt</th>
                        </tr>
                    </thead>
                    <tbody>
                           <%  List<Livre> emp=getBookEmprunter(userId);          
                    		for (Livre book : emp) {
                            	String noms=getAuthorsString(book.getAuteurs());
                            	
                    		%>
                        <tr>
                            <td><%=book.getTitre() %></td>
                            <td><%=noms%></td>
                            <% if(book.getAnnee()==1) 
                            {%>
                            <td style="color: green; font-weight: bold; ">Activer</td>
                            <%}else{ %>
                            <td style="color: red; font-weight: bold; ">Terminer</td>
                            <%} %>
                        </tr>
                   <%} %>
                      
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleButton = document.querySelector('.toggle-password');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleButton.textContent = 'Masquer';
            } else {
                passwordInput.type = 'password';
                toggleButton.textContent = 'Afficher';
            }
        }
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
private List<String> UserDetail(int id) {
	
	   String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	    String username = "postgres";
	    String password = "58358905";
	    List<String> user=new ArrayList<>();

	    try {
	        Class.forName("org.postgresql.Driver");
	        try (Connection conn = DriverManager.getConnection(url, username, password)) {
	            String sql = "SELECT * from test.utilisateurs where id= ? ";
	                         

	            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	                stmt.setInt(1, id);
	                try (ResultSet rs = stmt.executeQuery()) {
	                    while(rs.next()){
	                    	user.add(rs.getString("nom"));
	                    	user.add(rs.getString("email"));
	                    	user.add(rs.getString("motdepasse"));
	             	
	                    }
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	           
	        }
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	       
	    }

	    return user;
	
	
	
	
}
private List<Livre> getBookEmprunter(int id) {
	List<Livre> books = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
    String username = "postgres";
    String password = "58358905";
    
    try {
        Class.forName("org.postgresql.Driver");
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            String sql4 = "SELECT *, CURRENT_DATE as datenow from test.empruntlivre where user_id=? ";
            String sql = "SELECT *,catégories.nom from test.livres,test.catégories where livres.categorie_id=catégories.id and livres.id= ? ";


            try (PreparedStatement stmt4 = conn.prepareStatement(sql4)) {
                stmt4.setInt(1, id);
                try (ResultSet rs4 = stmt4.executeQuery()) {
                    while(rs4.next()){
                    	try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setInt(1, rs4.getInt("livre_id"));
                            try (ResultSet rs = stmt.executeQuery()) {
                                while(rs.next()){
                        List<Auteur> authors = new ArrayList<>();
                        String sql2 = "SELECT * FROM test.livre_auteurs WHERE livre_id = ?";
                        String sql1 = "SELECT id, nom FROM test.auteurs WHERE id = ?";

                        try (PreparedStatement stmt3 = conn.prepareStatement(sql2)) {
                            stmt3.setInt(1, rs.getInt("id"));
                            try (ResultSet rs3 = stmt3.executeQuery()) {
                                while (rs3.next()) {
                                    try (PreparedStatement stmt2 = conn.prepareStatement(sql1)) {
                                        stmt2.setInt(1, rs3.getInt("auteur_id"));
                                        try (ResultSet rs2 = stmt2.executeQuery()) {
                                            while (rs2.next()) {
                                                Auteur auteur = new Auteur(rs2.getInt("id"), rs2.getString("nom"));
                                                authors.add(auteur);
                                            }
                                        }
                                    }
                                }
                            }}
                      if(rs4.getDate("date_retour").after(rs4.getDate("datenow")))
                      {
                        books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",1,"", rs.getString("nom"),rs.getBoolean("autorisation")));
                        }
                      else
                      {
                          books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",0,"", rs.getString("nom"),rs.getBoolean("autorisation")));

                      }
                    	  }
                      }
                    } }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
           
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
       
    }

    return books;
}
private List<Livre> getBookTelecharger(int id) {
	List<Livre> books = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
    String username = "postgres";
    String password = "58358905";

    try {
        Class.forName("org.postgresql.Driver");
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            String sql4 = "SELECT livre_id , MAX(date) as lastdate from test.telechargement where user_id=? group by livre_id; ";
            String sql = "SELECT *,catégories.nom from test.livres,test.catégories where livres.categorie_id=catégories.id and livres.id= ? ";


            try (PreparedStatement stmt4 = conn.prepareStatement(sql4)) {
                stmt4.setInt(1, id);
                try (ResultSet rs4 = stmt4.executeQuery()) {
                    while(rs4.next()){
                    	try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setInt(1, rs4.getInt("livre_id"));
                            try (ResultSet rs = stmt.executeQuery()) {
                                while(rs.next()){
                        List<Auteur> authors = new ArrayList<>();
                        String sql2 = "SELECT * FROM test.livre_auteurs WHERE livre_id = ?";
                        String sql1 = "SELECT id, nom FROM test.auteurs WHERE id = ?";

                        try (PreparedStatement stmt3 = conn.prepareStatement(sql2)) {
                            stmt3.setInt(1, rs.getInt("id"));
                            try (ResultSet rs3 = stmt3.executeQuery()) {
                                while (rs3.next()) {
                                    try (PreparedStatement stmt2 = conn.prepareStatement(sql1)) {
                                        stmt2.setInt(1, rs3.getInt("auteur_id"));
                                        try (ResultSet rs2 = stmt2.executeQuery()) {
                                            while (rs2.next()) {
                                                Auteur auteur = new Auteur(rs2.getInt("id"), rs2.getString("nom"));
                                                authors.add(auteur);
                                            }
                                        }
                                    }
                                }
                            }}
                      
                        books.add(new Livre(rs.getInt("id"),rs.getString("titre"), authors,"",0,"", rs.getString("nom"),rs.getBoolean("autorisation"),rs4.getDate("lastdate")));
                    } }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
           
        } } catch (SQLException e) {
            e.printStackTrace();
            
        }
            } catch (SQLException e) {
                e.printStackTrace();
               
            }
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