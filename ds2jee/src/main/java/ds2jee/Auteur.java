package ds2jee;

import java.sql.Date;

public class Auteur {
    private int id;
    private String nom;
    private Date datenaissance;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getnom() {
		return nom;
	}
	public void setnom(String nom) {
		this.nom = nom;
	}
	public Date getDatenaissance() {
		return datenaissance;
	}
	public void setDatenaissance(Date datenaissance) {
		this.datenaissance = datenaissance;
	}
	public Auteur(int id, String nom, Date datenaissance) {
		super();
		this.id = id;
		this.nom = nom;
		this.datenaissance = datenaissance;
	}
	public Auteur(int id, String nom) {
		super();
		this.id = id;
		this.nom = nom;
	}


}