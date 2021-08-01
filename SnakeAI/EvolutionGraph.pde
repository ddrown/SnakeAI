class EvolutionGraph extends PApplet {
  static final int showX = 50;
  
   EvolutionGraph() {
       super();
       PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
   }
   
   void settings() {
      size(900,600); 
   }
   
   void setup() {
       background(150);
       frameRate(30);
   }
   
   void scoreLine(int red, int green, int blue, float x, float xbuff, float ybuff, int score, int newscore) {
     stroke(red, green, blue);
     line(x-xbuff,height-50-(score*ybuff),x,height-50-(newscore*ybuff));
   }
   
   void draw() {
      background(150);
      fill(0);
      strokeWeight(1);
      textSize(15);
      textAlign(CENTER,CENTER);
      text("Generation", width/2,height-10);
      translate(10,height/2);
      rotate(PI/2);
      text("Score", 0,0);
      rotate(-PI/2);
      translate(-10,-height/2);
      textSize(10);
      float x = 35;
      float y = height-50;
      float xbuff = (width-50) / showX;
      float ybuff = (height-50) / 200.0;
      float ydif = ybuff * 10.0;
      for(int i=0; i<200; i+=10) {
         text(i,x,y);
         line(50,y,width,y);
         y-=ydif;
      }
      strokeWeight(2);
      GenerationStats lastgen = evolution.get(0);
      
      x = 50;
      y = height-35;
      for(int i=0; i<evolution.size() && i<showX; i++) {
        GenerationStats thisgen = evolution.get(i);
        text(thisgen.generationNumber,x,y); 

        if (i > 0) {
          scoreLine(0, 0, 255, x, xbuff, ybuff, lastgen.medianScore, thisgen.medianScore);
          scoreLine(0, 255, 0, x, xbuff, ybuff, lastgen.ninetyScore, thisgen.ninetyScore);
          scoreLine(200, 200, 200, x, xbuff, ybuff, lastgen.maxScore, thisgen.maxScore);
          scoreLine(255, 0, 0, x, xbuff, ybuff, lastgen.bestScore, thisgen.bestScore);
        }
        
        x+=xbuff;
        lastgen = thisgen;
      }
      stroke(0);
      strokeWeight(5);
      line(50,0,50,height-50);
      line(50,height-50,width,height-50);
   }
   
   void exit() {
      dispose();
      graph = null;
   }
}
