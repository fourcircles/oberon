import org.antlr.runtime.RecognitionException;


public class AmbiguousId extends RecognitionException{

	String id;
	public AmbiguousId(String id) {
		this.id = id;
		
	}
	@Override
	public String getMessage() {
		return "redeclaration of " + id;
	}
	

}
