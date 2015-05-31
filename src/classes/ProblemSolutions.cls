public class ProblemSolutions{
    
    public Integer duplicateValueFinder(Integer[] iList) {
    	Integer[] iListCopy = iList.clone();
      	iListCopy.sort();
      	while(iListCopy.size()>1) {
      		Integer currentInteger = iListCopy.remove(0);
        	if(currentInteger == iListCopy[0]) {
        		return currentInteger;
        	}
      	}
      return null;
    }
    public String firstNonRepeatingCharacter(String source) {
      	Set<String> nonDupes = new Set<String>(), dupes = new Set<String>();
      	for(String value:source.split('')) {
        	if(!String.isBlank(value)) {
          		if(nonDupes.contains(value)) {
            		dupes.add(value);
          		}
          		nonDupes.add(value);
        	}
      	}
      	nonDupes.removeAll(dupes);
      	String searchString = String.join(new List<String>(dupes),'');
      	return source.substring(source.indexOfAnyBut(searchString), source.indexOfAnyBut(searchString)+1);
    }
    public Integer[] cardShuffler(Integer[] deck) {
        Integer[] newDeck = new Integer[]{}, myDeck = deck.clone();
        Double random = math.random();
      	for(Integer i = myDeck.size(); i > 0; i--) {
            decimal randomQ = random*(i+1);
            Integer toGetRandom = integer.valueOf(math.rint(randomQ));
            newDeck.add(myDeck[toGetRandom]);
      	}
        system.debug('&&& newDeck:' + newDeck);
        system.debug('&&& myDeck:' + myDeck);
      	return newDeck;
    }
}