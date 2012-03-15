package exceptions;
import org.antlr.runtime.RecognitionException;




public class RRException extends RecognitionException {
	String errorMessage = "";
	
	public RRException() {
	}
	public RRException(RecognitionException e, String message) {
		super();
		errorMessage = message;
		this.line = e.line;
		this.charPositionInLine = e.charPositionInLine;
	}
	
	public RRException(RecognitionException e) {
		super();
		this.line = e.line;
		this.c = e.c;
	}

	@Override
	public String getMessage() {
		return "" + line + ":" + charPositionInLine + " " + errorMessage;
	}
	
}
