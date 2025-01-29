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
            <h1>Modifier Livre</h1>
            <%
                int bookId = Integer.parseInt(request.getParameter("id"));
                Livre book = getBookById(bookId);
                if (book == null) {
                    out.print("<p>Livre non trouvé.</p>");
                } else {
            %>

            <form action="AdminGestion" method="post">
                <input type="hidden" name="id" id="id" value="<%=book.getId() %>">
                
                <div class="form-group">
                    <label for="titre">Titre</label>
                    <input type="text" id="titre" name="titre" value="<%=book.getTitre() %>" required>
                </div>

                <div class="form-group">
                    <label for="resume">Résumé</label>
                    <textarea id="resume" name="resume" rows="4" required><%=book.getResume() %></textarea>
                </div>

                <div class="form-group">
                    <label for="annee">Année</label>
                    <input type="number" id="annee" name="annee" value="<%=book.getAnnee() %>" required>
                </div>

                <div class="form-group">
                    <label for="format">Format</label>
                    <select class="selectpicker" name="format" id="format">
                        <option value="PDF" <%=book.getFormat().equals("PDF") ? "selected" : "" %>>PDF</option>
                        <option value="EPUB" <%=book.getFormat().equals("EPUB") ? "selected" : "" %>>EPUB</option>
                    </select>
                </div>
                 <div class="form-group">
                    <label for="autoris">Autorisation</label>
                    <select class="selectpicker" name="autoris" id="autoris">
                    <%if(book.isAutorisation()) 
                    {%>
                        <option value="true"  selected="selected" > Telecharger</option>
                        <option value="false"  >Lire</option>
                        <%}else{ %>
                        <option value="true"   > >Telecharger</option>
                        <option value="false" selected="selected" >Lire</option>
                        <%} %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="path">Path</label>
                    <input type="text" id="path" name="path" value="<%=book.getFile_path() %>" required>
                </div>

                <div class="scroll-box-container">
                    <div class="scroll-box">
                        <label for="auteur">Auteur(s)</label>
                        <select class="selectpicker" multiple data-live-search="true" name="auteur" id="auteur">
                            <%
                            List<Auteur> auteurs = getAuteurs();
                            for (Auteur aut : auteurs) {
                                %>
                                <option value="<%=aut.getId() %>" <%=checkIDInList(book.getAuteurs(), aut.getId()) ? "selected" : "" %>>
                                    <%=aut.getnom() %>
                                </option>
                                <%
                            }
                            %>
                        </select>
                    </div>

                    <div class="scroll-box">
                        <label for="categorie">Catégories</label>
                            <select class="selectpicker" data-live-search="true" name="categorie" id="categorie">
                            <%
                            List<Categorie> categories = getCategoriesFromDatabase();
                            for (Categorie cat : categories) {
                            	if(cat.getName()==book.getCategorie())
                            	{
                                %>
                                <option value="<%=cat.getId() %>" selected="selected"><%=cat.getName()%></option>
                                <%
                            	}
                            	else{
                            		
                            		 %>
                                     <option value="<%=cat.getId() %>" ><%=cat.getName()%></option>
                                     <%
                            	}
                            }
                            %>
                        </select>
                    </div>
                </div>

                <button type="submit" name="action" value="modifierLivre">Enregistrer</button>
            </form>
            <% } %>

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
private Livre getBookById(int id) {
    Livre book = null;
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
    String username = "postgres";
    String password = "58358905";

    try {
        Class.forName("org.postgresql.Driver");
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            String sql = "SELECT livres.id, livres.titre, livres.annee, livres.resume, livres.format, auteurs.nom, catégories.nom as categorie_id ,livres.file_path ,livres.autorisation " +
                         "FROM test.livres " +
                         "JOIN test.livre_auteurs ON livres.id = livre_auteurs.livre_id " +
                         "JOIN test.auteurs ON livre_auteurs.auteur_id = auteurs.id " +
                         "JOIN test.catégories ON livres.categorie_id = catégories.id " +
                         "WHERE livres.id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
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
                      
                        book = new Livre(rs.getInt("id"), rs.getString("titre"), authors, rs.getString("resume"), rs.getInt("annee"), rs.getString("format"), rs.getString("categorie_id"),rs.getBoolean("autorisation"),rs.getString("file_path"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
           
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
       
    }

    return book;
}
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
private boolean checkIDInList(List<Auteur> list, int number) {
    for (Auteur auteur : list) {
        if (auteur.getId() == number) {
            return true;  
        }
    }
    return false; 
}
private List<Categorie> getCategoriesFromDatabase() {
    List<Categorie> categories = new ArrayList<>();
    String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	String username = "postgres";
	String password = "58358905";
	 try {
			Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);
        String sql;
        
            sql = "SELECT * FROM test.catégories";
    

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
          
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