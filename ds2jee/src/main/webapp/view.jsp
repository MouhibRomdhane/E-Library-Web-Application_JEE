<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure PDF Viewer</title>
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
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        #pdf-viewer {
            width: 100%;
            height: 90vh;
            border: none;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f0f0f0;
        }
        canvas {
            border: 1px solid #ccc;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <%@include file="navbar.html" %>
    <div id="pdf-viewer">
        <canvas id="pdf-canvas"></canvas>
    </div>
   

    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.16.105/pdf.min.js"></script>
    <script>
        const url = 'ViewDoc?id=1'; // URL to the servlet serving the PDF

        const pdfjsLib = window['pdfjs-dist/build/pdf'];

        // Configure worker
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.16.105/pdf.worker.min.js';

        // Load PDF document
        pdfjsLib.getDocument(url).promise.then(pdf => {
            pdf.getPage(1).then(page => {
                const viewport = page.getViewport({ scale: 1.5 });
                const canvas = document.getElementById('pdf-canvas');
                const context = canvas.getContext('2d');

                canvas.width = viewport.width;
                canvas.height = viewport.height;

                const renderContext = {
                    canvasContext: context,
                    viewport: viewport,
                };

                page.render(renderContext);
            });
        }).catch(error => {
            console.error(error);
        });
    </script>
</body>
</html>
