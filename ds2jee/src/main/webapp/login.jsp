<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bibileotheque</title>
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
                        <h3>SE CONNECTER</h3>
                        <input type="text" id="email" placeholder="email" name="email"value=""/>
                        <input type="password" id="password" placeholder="Password" name="password"/>
                        <button class="submit" type ="submit" name="action" value="connexionLib">CONNEXION</button>
                      
                       
                        
                        <h4>INSCRIPTION</h4>
                        <br/>
                        <h5 class="inscription-employeur">
                            <a href="inscription.jsp">Inscrivez-vous maintenant </a>
                        </h5>
                      
                        
                    </form>
                </div>
            </div>
            <div class="right">
               
            </div>
        </div>
    </section>


 
</body>

</html>