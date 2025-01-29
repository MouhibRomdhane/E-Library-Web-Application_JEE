package ds2jee;

import java.sql.Date;
import java.util.*;

public class Livre {
    private int id;
    private String titre;
private List<Auteur> auteurs;
    private String resume;
    private int annee;
    private String format;
    private String categorie;
    private String file_path;
public String getFile_path() {
		return file_path;
	}
	public void setFile_path(String file_path) {
		this.file_path = file_path;
	}
private boolean autorisation;
private Date dat_retour;
    // Getters et Setters
    
    public int getId() {
        return id;
    }
public void setId(int id) {
        this.id = id;
    }
 


	

    public Date getDat_retour() {
	return dat_retour;
}
public void setDat_retour(Date dat_retour) {
	this.dat_retour = dat_retour;
}
	public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }



    public String getResume() {
        return resume;
    }

    public void setResume(String resume) {
        this.resume = resume;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }
	public List<Auteur> getAuteurs() {
		return auteurs;
	}
	public void setAuteurs(List<Auteur> auteurs) {
		this.auteurs = auteurs;
	}
	public Livre(int id, String titre, List<Auteur> auteurs, String resume, int annee, String format,
			String categorie ,boolean autorisation) {
		super();
		this.id = id;
		this.titre = titre;
		this.auteurs = auteurs;
		this.resume = resume;
		this.annee = annee;
		this.format = format;
		this.categorie = categorie;
		this.autorisation=autorisation;
		
		
	}
	public Livre(int id, String titre, List<Auteur> auteurs, String resume, int annee, String format,
			String categorie ,boolean autorisation,String file_path) {
		super();
		this.id = id;
		this.titre = titre;
		this.auteurs = auteurs;
		this.resume = resume;
		this.annee = annee;
		this.format = format;
		this.categorie = categorie;
		this.autorisation=autorisation;
		this.file_path=file_path;
		
		
	}
	
	public Livre(int id, String titre, List<Auteur> auteurs, String resume, int annee, String format,
			String categorie ,boolean autorisation, Date dat_retour) {
		super();
		this.id = id;
		this.titre = titre;
		this.auteurs = auteurs;
		this.resume = resume;
		this.annee = annee;
		this.format = format;
		this.categorie = categorie;
		this.autorisation=autorisation;
		this.dat_retour=dat_retour;
	}
	public boolean isAutorisation() {
		return autorisation;
	}
	public void setAutorisation(boolean autorisation) {
		this.autorisation = autorisation;
	}

}
