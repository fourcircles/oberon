import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class SimpleScope {

	ArrayList<SimpleVar> varList;
	Map<String, SimpleVar> varMap; 
	
	SimpleScope parentScope;
	
	public SimpleScope() {
		varList = new ArrayList<SimpleVar>();
		varMap = new HashMap<String, SimpleVar>();
	}
	public void addVar(SimpleVar var) {
		varList.add(var);
		varMap.put(var.getName(), var);
	}
	
	public SimpleVar findInside(String name) {
		return varMap.get(name);
	}
	public SimpleVar findAnywhere(String name) {
		SimpleVar inside = findInside(name);
		if (inside == null) {
			if (parentScope != null) { 
				return parentScope.findAnywhere(name);
			} else return null;
		} 
		return inside;
	}
	
}
