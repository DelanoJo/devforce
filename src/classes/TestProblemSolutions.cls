@isTest
public class TestProblemSolutions{
    @isTest
    static void testDuplicateValueFinder() {
        ProblemSolutions ps = new ProblemSolutions();
        System.assertEquals(4,ps.duplicateValueFinder(new Integer[] {1,2,3,4,9,4}));
    }
    @isTest
    static void testNonRepeatingChar() {
        ProblemSolutions ps = new ProblemSolutions();
        System.assertEquals('E',ps.firstNonRepeatingCharacter('DEFD'));
    }
    @isTest
    static void testCardShuffler() {
        ProblemSolutions ps = new ProblemSolutions();
        Integer[] deck = new Integer[] {};
        for(Integer i = 0; i < 52; i ++){
            deck.add(i);        
        }
        Integer[] newDeck = ps.cardShuffler(deck);
        System.assertEquals(52, newDeck.size());
    }
}