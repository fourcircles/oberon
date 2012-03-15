package exceptions;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.Token;

import core.SimpleScope;
import core.SimpleVar;


public class AmbiguousIdException extends RecognitionException{

	String id;
	int declarationLine;
	int declarationPositionInLine;
	
	public AmbiguousIdException(String id, int line, int pos) {
		this.id = id;
		this.line = line;
		this.charPositionInLine = pos;
	}
	public AmbiguousIdException(Token token, SimpleScope scope) {
		this.line = token.getLine();
		this.id = token.getText();
		this.charPositionInLine = token.getCharPositionInLine();
		
		SimpleVar v = scope.get(id);
		this.declarationLine = v.getDeclarationLine();
		this.declarationPositionInLine = v.getDeclarationPositionInLine();
	}
	
	@Override
	public String getMessage() {
		return line + ":" + charPositionInLine + " redeclaration of " + id
				+ ", first declared at " + declarationLine + ":" + declarationPositionInLine;
	}
	

}
