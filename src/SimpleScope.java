import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class SimpleScope {
	static public SimpleScope globalScope = null;
	static {
		globalScope = new SimpleScope();
		globalScope.parentScope = null;
		
		globalScope.addVar(new SimpleVar("INTEGER"));
		//TODO add everything else
		
	}

	ArrayList<SimpleVar> varList;
	Map<String, SimpleVar> varMap; 
	
	SimpleScope parentScope;
	
	
	public SimpleScope getParentScope() {
		return parentScope;
	}
	public void setParentScope(SimpleScope parentScope) {
		this.parentScope = parentScope;
	}
	
	public SimpleScope() {
		varList = new ArrayList<SimpleVar>();
		varMap = new HashMap<String, SimpleVar>();
	}
	public void addVar(SimpleVar var) {
		varList.add(var);
		varMap.put(var.getName(), var);
	}
	
	public boolean containsInside(String name) {
		return varMap.containsKey(name);
	}
	public boolean contains(String name) {
		boolean inside = containsInside(name);
		if (!inside) {
			if (parentScope != null) { 
				return parentScope.contains(name);
			} else return false;
		} 
		return true;
	}
	
}
