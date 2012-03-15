package exceptions;
import org.antlr.runtime.RecognitionException;


public class AmbiguousIdException extends RecognitionException{

	String id;
	
	public AmbiguousIdException(String id, int line, int pos) {
		this.id = id;
		this.line = line;
		this.charPositionInLine = pos;
	}
	
//	public AmbiguousIdException(String id, RecognitionException e) {
//		super(e);
//		this.id = id;
//	}
	
	@Override
	public String getMessage() {
		return line + ":" + charPositionInLine + " redeclaration of " + id;
	}
	

}
