class GenerationStats {
  int generationNumber;
  int maxScore;
  int medianScore;
  int ninetyScore;
  int bestScore;
  
  GenerationStats(int _generationNumber, int _maxScore, int _medianScore, int _ninetyScore, int _bestScore) {
    generationNumber = _generationNumber;
    maxScore = _maxScore;
    medianScore = _medianScore;
    ninetyScore = _ninetyScore;
    bestScore = _bestScore;
  }
}
