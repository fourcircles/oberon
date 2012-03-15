package core;

import org.antlr.runtime.Token;

public class SimpleVar {
	private int evalType;
	private String name;
	
	private int line;
	private int pos;
	
	public SimpleVar(String name) {
		this.name = name;
	}
	public SimpleVar(Token token) {
		this.name = token.getText();
		this.line = token.getLine();
		this.pos = token.getCharPositionInLine();
	}
	
	public int getDeclarationLine() {
		return line;
	}
	public int getDeclarationPositionInLine() {
		return pos;
	}
	
	public String getName() {
		return name;
	}
}
