<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, java.util.HashMap, java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 20px;
        }

        .card {
            margin-bottom: 20px;
        }

        .card-header {
            background-color: #c93f35;
            color: white;
            font-weight: bold;
        }

        .list-group-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .badge {
            background-color:#c93f35;
        }
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
    
    </style>
</head>
<body>
 <%@include file="adnavbar.html" %>
    <div class="container mt-5">
        
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        Statistiques des livres
                    </div>
                    <div class="card-body">
                        <canvas id="bookChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        Utilisateurs les plus actifs
                    </div>
                    <div class="card-body">
                        <ul class="list-group">
                            <%
                                // JDBC code to fetch top active users
                                Class.forName("org.postgresql.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT u.nom, COUNT(e.user_id) AS count FROM test.utilisateurs u JOIN test.empruntlivre e ON u.id = e.user_id GROUP BY u.id ORDER BY count DESC LIMIT 5");
                                while (rs.next()) {
                            %>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <%= rs.getString("nom") %>
                                <span class="badge badge-primary badge-pill"><%= rs.getInt("count") %></span>
                            </li>
                            <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Fetch data from the server
            fetch('data.jsp')
                .then(response => response.json())
                .then(data => {
                    const labels = data.labels;
                    const borrowedData = data.borrowedData;
                    const downloadedData = data.downloadedData;
                    const addedData = data.addedData;

                    // Create the chart
                    const ctx = document.getElementById('bookChart').getContext('2d');
                    const bookChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Livres empruntés',
                                data: borrowedData,
                                backgroundColor: 'rgba(76, 175, 80, 0.2)',
                                borderColor: 'rgba(76, 175, 80, 1)',
                                borderWidth: 1
                            }, {
                                label: 'Livres téléchargés',
                                data: downloadedData,
                                backgroundColor: 'rgba(255, 152, 0, 0.2)',
                                borderColor: 'rgba(255, 152, 0, 1)',
                                borderWidth: 1
                            }, {
                                label: 'Livres ajoutés',
                                data: addedData,
                                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });
                });
        });
    </script>
</body>
</html>