import org.antlr.runtime.RecognitionException;


public class MissingVariableException extends RecognitionException{

	String id;
	public MissingVariableException(String id) {
		this.id = id;
	}
	
	@Override
	public String getMessage() {
		return "Unresolved identifier " + id;
	}
	 

}
