package core;

public class SimpleVar {
	private int evalType;
	private String name;
	private int filePos;
	public SimpleVar(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
}
