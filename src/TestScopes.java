import static org.junit.Assert.*;

import java.io.IOException;

import org.antlr.runtime.RecognitionException;
import org.junit.Before;
import org.junit.Test;


public class TestScopes {
	private Main m;
	@Before 
	public void setUp() {
		m = new Main();
	}

	@Test
	public void test1() {
		try {
			m.parse("tests\\scopeTests\\test1.txt");
			fail("Ambiguous not found");
		} catch (AmbiguousId e) {
			
		} catch (IOException e) {
			fail("missing file test1");
		} catch (RecognitionException e) {
			fail("File has correct syntax");
		}
		
	}
}
