package ds2jee;

public class Categorie {
	private int id;
	private String name;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Categorie(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	} 

}
