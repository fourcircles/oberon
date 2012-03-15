package exceptions;
import org.antlr.runtime.RecognitionException;


public class MissingVariableException extends RecognitionException{

	String id;
	public MissingVariableException(String id, int line, int pos) {
		this.id = id;
		this.line = line;
		this.charPositionInLine = pos;
	}
	
	@Override
	public String getMessage() {
		return "" + line + ":" + charPositionInLine + " Unresolved identifier " + id;
	}
	 

}
