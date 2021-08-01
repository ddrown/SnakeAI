class Population {
   
   Snake[] snakes;
   Snake bestSnake, highScoreSnake;
   
   int bestSnakeScore = 0;
   int gen = 0;
   int samebest = 0;
   int highScore = 0;
   
   float bestFitness = 0;
   float fitnessSum = 0;
   
   Population(int size) {
      snakes = new Snake[size]; 
      for(int i = 0; i < snakes.length; i++) {
         snakes[i] = new Snake(); 
      }
      bestSnake = snakes[0].clone();
      bestSnake.replay = true;
      highScoreSnake = snakes[0].clone();
      highScoreSnake.replay = true;
   }
   
   boolean done() {  //check if all the snakes in the population are dead
      if(!bestSnake.dead) {
         return false;
      }

      for(int i = 0; i < snakes.length; i++) {
         if(!snakes[i].dead)
           return false;
      }
      return true;
   }
   
   void updateBest() {
      if(!bestSnake.dead) {  //if the best snake is not dead update it, this snake is a replay of the best from the past generation
         bestSnake.look();
         bestSnake.think();
         bestSnake.move();
      }
   }

   boolean update(int start, int end) {  //update all the snakes in the generation
      boolean foundLive = false;
      for(int i = start; i < snakes.length && i < end; i++) {
        if(!snakes[i].dead) {
           foundLive = true;
           snakes[i].look();
           snakes[i].think();
           snakes[i].move(); 
        }
      }
      return foundLive;
   }
   
   void show() {  //show either the best snake or all the snakes
      if(replayBest) {
        bestSnake.show();
        bestSnake.brain.show(0,0,360,790,bestSnake.vision, bestSnake.decision);  //show the brain of the best snake
      } else {
         for(int i = 0; i < snakes.length; i++) {
            snakes[i].show(); 
         }
      }
   }
   
   // depends on setBestSnake() being called first
   GenerationStats fitnessStats() {
     float fitnesses[] = new float[snakes.length];
     int scores[] = new int[snakes.length];
     float sum = 0;
     int scoresum = 0;
     
     for(int i = 0; i < snakes.length; i++) {
       fitnesses[i] = snakes[i].fitness;
       sum += snakes[i].fitness;
       scores[i] = snakes[i].score;
       scoresum += snakes[i].score;
     }
     fitnesses = sort(fitnesses);
     scores = sort(scores);
     int median = snakes.length / 2;
     int ninety = snakes.length * 90 / 100;
     StringBuilder output = new StringBuilder("max/avg/median/90% fitness "+fitnesses[snakes.length-1]);
     output.append("/"+(sum / snakes.length));
     output.append("/"+fitnesses[median]);
     output.append("/"+fitnesses[ninety]);
     output.append(" score "+scores[snakes.length-1]);
     output.append("/"+(scoresum / snakes.length));
     output.append("/"+scores[median]);
     output.append("/"+scores[ninety]);
     System.out.println(output.toString());
     
     return new GenerationStats(gen, scores[snakes.length-1], scores[median], scores[ninety], bestSnakeScore);
   }
   
   void setBestSnake() {  //set the best snake of the generation
       float max = 0;
       int maxIndex = 0, maxScore = 0, maxScoreIndex = 0;
       for(int i = 0; i < snakes.length; i++) {
          if(snakes[i].fitness > max) {
             max = snakes[i].fitness;
             maxIndex = i;
          }
          if(snakes[i].score > maxScore) {
            maxScore = snakes[i].score;
            maxScoreIndex = i;
          }
       }
       if(max > bestFitness) {
         bestFitness = max;
         bestSnake = snakes[maxIndex].cloneForReplay();
         bestSnakeScore = snakes[maxIndex].score;
         //samebest = 0;
         //mutationRate = defaultMutation;
       } else {
         bestSnake = bestSnake.cloneForReplay(); 
         /*
         samebest++;
         if(samebest > 2) {  //if the best snake has remained the same for more than 3 generations, raise the mutation rate
            mutationRate *= 2;
            samebest = 0;
         }*/
       }
       if(maxScore > highScore) {
         highScore = maxScore;
         highScoreSnake = snakes[maxScoreIndex].clone();
       }
   }
   
   Snake selectParent() {  //selects a random number in range of the fitnesssum and if a snake falls in that range then select it
      float rand = random(fitnessSum);
      float summation = 0;
      for(int i = 0; i < snakes.length; i++) {
         summation += snakes[i].fitness;
         if(summation > rand) {
           return snakes[i];
         }
      }
      return snakes[0];
   }
   
   void naturalSelection() {
      Snake[] newSnakes = new Snake[snakes.length];
      
      setBestSnake();
      calculateFitnessSum();
      
      newSnakes[0] = bestSnake.clone();  //add the best snake of the prior generation into the new generation
      newSnakes[1] = highScoreSnake.clone();
      for(int i = 2; i < snakes.length; i++) {
         Snake child = selectParent().crossover(selectParent());
         child.mutate();
         newSnakes[i] = child;
      }
      snakes = newSnakes.clone();
      gen+=1;
   }
   
   void mutate() {
       for(int i = 1; i < snakes.length; i++) {  //start from 1 as to not override the best snake placed in index 0
          snakes[i].mutate(); 
       }
   }
   
   void calculateFitness() {  //calculate the fitnesses for each snake
      for(int i = 0; i < snakes.length; i++) {
         snakes[i].calculateFitness(); 
      }
   }
   
   void calculateFitnessSum() {  //calculate the sum of all the snakes fitnesses
       fitnessSum = 0;
       for(int i = 0; i < snakes.length; i++) {
         fitnessSum += snakes[i].fitness; 
      }
   }
}
