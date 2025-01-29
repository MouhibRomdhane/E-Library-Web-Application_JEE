<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, java.util.HashMap, java.util.Map, org.json.JSONObject, org.json.JSONArray" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    try {
        // JDBC code to fetch book statistics
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bibliotheque", "postgres", "58358905");
        Statement stmt = conn.createStatement();

        // Fetch borrowed books data
        ResultSet rsBorrowed = stmt.executeQuery("SELECT EXTRACT(MONTH FROM date_emprunt) AS month, COUNT(*) AS count FROM test.empruntlivre GROUP BY EXTRACT(MONTH FROM date_emprunt)");
        Map<Integer, Integer> borrowedData = new HashMap<>();
        while (rsBorrowed.next()) {
            borrowedData.put(rsBorrowed.getInt("month"), rsBorrowed.getInt("count"));
        }

        // Fetch downloaded books data
        ResultSet rsDownloaded = stmt.executeQuery("SELECT EXTRACT(MONTH FROM date) AS month, COUNT(*) AS count FROM test.telechargement GROUP BY EXTRACT(MONTH FROM date)");
        Map<Integer, Integer> downloadedData = new HashMap<>();
        while (rsDownloaded.next()) {
            downloadedData.put(rsDownloaded.getInt("month"), rsDownloaded.getInt("count"));
        }

        // Fetch added books data
        ResultSet rsAdded = stmt.executeQuery("SELECT EXTRACT(MONTH FROM date) AS month, COUNT(*) AS count FROM test.livres GROUP BY EXTRACT(MONTH FROM date)");
        Map<Integer, Integer> addedData = new HashMap<>();
        while (rsAdded.next()) {
            addedData.put(rsAdded.getInt("month"), rsAdded.getInt("count"));
        }

        // Close connections
        rsBorrowed.close();
        rsDownloaded.close();
        rsAdded.close();
        stmt.close();
        conn.close();

        // Prepare data for JSON
        List<String> labels = new ArrayList<>();
        List<Integer> borrowedList = new ArrayList<>();
        List<Integer> downloadedList = new ArrayList<>();
        List<Integer> addedList = new ArrayList<>();

        for (int i = 1; i <= 12; i++) {
            labels.add(getMonthName(i));
            borrowedList.add(borrowedData.getOrDefault(i, 0));
            downloadedList.add(downloadedData.getOrDefault(i, 0));
            addedList.add(addedData.getOrDefault(i, 0));
        }

        // Create JSON object
        JSONObject json = new JSONObject();
        json.put("labels", new JSONArray(labels));
        json.put("borrowedData", new JSONArray(borrowedList));
        json.put("downloadedData", new JSONArray(downloadedList));
        json.put("addedData", new JSONArray(addedList));

        out.print(json.toString());
        out.flush();
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"error\": \"" + e.getMessage() + "\"}");
    }
%>

<%!
    private String getMonthName(int month) {
        String[] monthNames = {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return monthNames[month - 1];
    }
%>
