<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <header></header>

    <section class="login">
        <div class="login_box">
            <div class="left">
                <div class="contact">
                    <form action="GestionUtilisateurs" method="post">
                          <%
            String errorMessage =(String)request.getAttribute("errorMessage");
            if (errorMessage != null) {
            	%>     
            	<p class="error"><%= errorMessage %></p>  
            	 <%
            }
        %>   
       
                        <input type="text" id="nompren" placeholder="Nom et prenom" required  name="nompren"value=""/>
                   
                       
                        <input type="text" id="mail" placeholder="Email" required name="mail"/>
                        
                        <input type="password" id="password" placeholder="Password" required name="password"/> 
                        

                        <button class="submit" name="action" value="inscriLib">REGISTER</button>
                      
                       
                        
                       
                    </form>
                </div>
            </div>
            <div class="right">
               
            </div>
        </div>
    </section>


 
</body>

