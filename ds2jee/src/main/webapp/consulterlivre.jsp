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
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    
    <style>
      body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f3f4f6;
      color: #333;
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
  max-width: 700px; /* Adjust card width */
  margin: 40px auto;
  background: #ffffff;
  border-radius: 20px;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.25);
  overflow: hidden;
  font-family: 'Arial', sans-serif;
  display: flex;
  flex-direction: column;
}

/* Image Section */
.book-image img {
  width: 100%;
  height: 200px; /* Fixed height for the image */
  object-fit: cover; /* Ensure the image fits within the given space */
  display: block;
  border-bottom: 5px solid #f4f4f4;
}

/* Content Section */
.book-content {
  padding: 30px; /* Increased padding for spacing */
  text-align: left;
  flex: 1; /* Allow this section to grow taller */
}

.book-title {
  font-size: 32px; /* Larger title */
  font-weight: bold;
  color: #333;
  margin-bottom: 25px;
  text-align: center;
}

.book-details {
  margin-bottom: 30px;
  line-height: 1.6; /* Better line spacing for readability */
}

.detail-row {
  display: flex;
  margin-bottom: 15px;
}

.detail-label {
  font-weight: bold;
  font-size: 18px;
  color: #555;
  min-width: 120px; /* Space for the label */
}

.detail-value {
  font-size: 18px;
  color: #666;
  flex: 1;
}

/* Buttons Section */
.card-buttons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 20px;
}

button {
  padding: 15px 30px; /* Bigger buttons for emphasis */
  font-size: 16px; /* Larger text for buttons */
  border: none;
  border-radius: 30px; /* Rounded buttons */
  cursor: pointer;
  transition: all 0.3s ease-in-out;
}

.favorite-btn {
  background-color: #ff6b6b;
  color: #fff;
}

.favorite-btn:hover {
  background-color: #e63946;
}

.download-btn {
  background-color: #4caf50;
  color: #fff;
}

.download-btn:hover {
  background-color: #388e3c;
}



     </style>   
    
</head>
<body>

   <%@include file="navbar.html" %>
    <% 
    
    int userId = (int) request.getSession().getAttribute("userId");
        int bookId = Integer.parseInt(request.getParameter("id"));
    boolean fav=IfFavoris(bookId,userId);
    boolean empr=IfEmpruntee(bookId, userId);
        Livre book = getBookById(bookId);
       String aut= getAuthorsString(book.getAuteurs());
      
       
    %>

      <div class="book-card">
        <div class="book-image">
          <img src="bk.jpg" alt="Book Cover">
        </div>
        <div class="book-content">
          <h2 class="book-title"><%= book.getTitre() %></h2>
          <div class="book-details">
            <div class="detail-row">
              <span class="detail-label">Auteur(s):</span>
              <span class="detail-value"><%=aut%></span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Categorie:</span>
              <span class="detail-value"><%= book.getCategorie() %></span>
            </div>
            <div class="detail-row">
              <span class="detail-label">resume:</span>
              <span class="detail-value"><%= book.getResume() %> </span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Année:</span>
              <span class="detail-value"><%= book.getAnnee() %> </span>
            </div>
             <div class="detail-row">
              <span class="detail-label">Format :</span>
              <span class="detail-value"> <%= book.getFormat() %> </span>
            </div>
          </div>
          <form Action="GestionLivres" method="post">
          <input type="hidden" name="id" value="<%= book.getId() %>"><br>
          <div class="card-buttons">
            
             <% if(fav) {%>
            <button class="favorite-btn" type="submit" name="action" value="SupFav"><i class="fas fa-heart"></i></button>
            <%}else{ %>
            <button class="favorite-btn" type="submit" name="action" value="AjoutFav" ><i class="fa-regular fa-heart" style="color: #ffffff;"></i></button>
            
            <% }
             if(book.isAutorisation()) {%>
            <button class="download-btn" type="submit" name="action" value="Downloadbook" >Download</button>
            <%}else{ if(!empr)
            {%>
            <button class="download-btn" type="submit" name="action" value="Emprunterbook" >Emprunter</button>
            <%
            }else{
            	%>
           <button class="favorite-btn" type="button" >déjà emprunté</button>
            <% 	
            }	
            }%>
          </div>
          </form>
        </div>
    </div>
   
    <script>
        $(document).ready(function() {
            $('.selectpicker').selectpicker();
        });
    </script>
      
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
            String sql = "SELECT *,catégories.nom from test.livres,test.catégories where livres.categorie_id=catégories.id and livres.id= ? ";
                         

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
                      
                        book = new Livre(rs.getInt("id"), rs.getString("titre"), authors, rs.getString("resume"), rs.getInt("annee"), rs.getString("format"), rs.getString("nom"),rs.getBoolean("autorisation"));
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
private boolean IfFavoris(int id,int userid)
{
	
	 String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	    String username = "postgres";
	    String password = "58358905";

	    try {
	        Class.forName("org.postgresql.Driver");
	        try (Connection conn = DriverManager.getConnection(url, username, password)) {
	            String sql = "SELECT * from test.favoris where id_livre=? and id_user=? ";
	                         

	            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	                stmt.setInt(1, id);
	                stmt.setInt(2, userid);
	                try (ResultSet rs = stmt.executeQuery()) {
	                    if(rs.next()){
	                    	return true;
	                    }
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	           
	        }
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	       
	    }

return false;
}
private boolean IfEmpruntee(int id,int userid){
	
	 String url = "jdbc:postgresql://localhost:5432/bibliotheque"; // Replace with your actual database URL
	    String username = "postgres";
	    String password = "58358905";

	    try {
	        Class.forName("org.postgresql.Driver");
	        try (Connection conn = DriverManager.getConnection(url, username, password)) {
	            String sql = "SELECT * from test.empruntlivre where livre_id=? and user_id= ? and date_retour>=CURRENT_DATE ";
	                         

	            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	                stmt.setInt(1, id);
	                stmt.setInt(2, userid);
	                try (ResultSet rs = stmt.executeQuery()) {
	                    if(rs.next()){
	                    	return true;
	                    }
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	           
	        }
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	       
	    }

return false;
}
%>