
class SimonResolver
{
    ArrayList<Integer> sequenceToResolve = new ArrayList<Integer>();
    int currentIndex = 0;

    SimonResolver(ArrayList<Integer> receivedSequence) {
        sequenceToResolve = receivedSequence;
    }

    int compareSolution(int valueSent) {
        if (valueSent == sequenceToResolve.get(currentIndex)) {
            if (currentIndex == sequenceToResolve.size()-1) {
                return 2;
            }
            else {
                currentIndex++;
                return 1;
            }
        }
        else {
            currentIndex = 0;
            return 0;
        }
    }
}