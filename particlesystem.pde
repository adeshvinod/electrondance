//call particle_initialize() in setup
//particle_action in draw()


int totalparticles=80;
Mover[] movers=new Mover[totalparticles];
trail[] trail_obj=new trail[totalparticles];
float wallforce=1.2;
float intensity=3;

class Mover{
  PVector location;
  PVector velocity;          //declaring attributes
  PVector acceleration;
  float   mass;
  
  
  Mover(float m,float x, float y){      //contruction function has special syntax without mention void,int,float etc
    location = new PVector(x,y);
    velocity=new PVector(0,0);
    acceleration= new PVector(0,0);
    mass=m;
  }
  
  
  void applyforce(PVector force){
    PVector facc=PVector.div(force,mass);
    //float slowmoacc= framerate/float(30);
    //facc.mult(slowmoacc);
    acceleration.add(facc);
  }
  
  
  
  void checkedges(){
    
    if (location.x>width)
    {velocity.x*=-1*wallforce;
    location.x=width-1;
     
    }else if(location.x<0)
    {velocity.x*=-1*wallforce;
     location.x=1;
    }
    else if(location.y>height)
    {velocity.y*=-1*wallforce;
    location.y=height-1;
    }
    else if(location.y<0)
    {velocity.y*=-1*wallforce;
     location.y=1;
    }
 }
  
  
  
  void update(){
    float slowmo= framerate/float(30);
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);   //ensures acceleration value doesnt increment every frame
  }
    
   
  void display()
  { pushMatrix();
    //ellipse(location.x,location.y,mass,mass);
    translate(location.x,location.y,-10);
    noStroke();
    colorMode(HSB,1);
    fill(mass/float(50),0.9,0.3,0.4);
    scale(0.8);
    sphere(mass);
    popMatrix();
  }
  
  
  
  
  void drag()
  { float speed=velocity.mag();
    float dragmag=0.08*speed*speed;
    PVector drag=velocity.get();
    drag.normalize();
    drag.mult(-dragmag);
    applyforce(drag);
  }
  
  
  
  void sonicforce(float boom,PVector trackdot)                              //changing origin
  { //PVector origin= new PVector(width/1.55,height/2);
    PVector origin= trackdot.copy(); 
    PVector dir= PVector.sub(location,origin);
    float maxdistance=pow((float((width)^2)+float((height)^2)),0.5);
    float distance=map(dir.mag(),0,maxdistance,1,3);
    dir.normalize();
    dir.mult(boom*20/(distance));
    applyforce(dir);
  }
  
  void centregravity(PVector trackdot)
  { PVector origin= trackdot.copy();
    //PVector origin= new PVector(width/1.5,height/2);
    PVector dir= PVector.sub(location,origin);
    dir.normalize();
    dir.mult(-80);
    applyforce(dir);
  }
  
  
}






class position{
  float x;
  float y;
  
  position(float x_, float y_){
    x=x_;
    y=y_;
  }
}



class trail extends Mover{
  float lifespan;
   ArrayList <position> posarray;
   float wallforce=1.2;
     
  trail(float m, float x, float y)
   { super(m,x,y);
     posarray=new ArrayList<position>();
     lifespan=40;
   }
   
   
   void display()
  { float fadetrail;
    lifespan=0;
    float trail_length=10;
    
    posarray.add(new position(location.x,location.y));
   noFill(); 
   colorMode(HSB,1);
   strokeWeight(3);
   beginShape();
   for(int i=0;i<posarray.size();i++)
   { fadetrail=map(lifespan,0,trail_length,0.1,0.3);
     position p=posarray.get(i);
      stroke(mass/60,0.8,0.8,fadetrail);
     vertex(p.x,p.y,5);
     lifespan++;
     if (posarray.size()>trail_length)
     posarray.remove(0);
   }
   endShape();
   
  }
}
 
 
 void particle_initialize()
 {
     for(int i=0;i<totalparticles;i++)
    { 
     movers[i]=new Mover(random(10,30),random(0,width),random(0,height));
     trail_obj[i]= new trail(random(20,60),random(0,width),random(0,height));
    }
    colorMode(RGB);
 }
 
 void particle_action(PVector temptrackdot)
 { 
    float boomforce = 0;
    float maximum=0;
 
  for(int i = 0; i < fft.specSize(); i+=1)
  {
    if(fft.getBand(i)>maximum)
       maximum=fft.getBand(i);
  }
  // float intensity=map(mouseY,0,600,50,300);
  if(maximum>0.11)
  boomforce=maximum*intensity;
  
 // println("intensity :"+intensity+", boomforce:"+boomforce);

  for(int i=0;i<totalparticles;i++)
  { //PVector gravity=new PVector(0,movers[i].mass*0.5);
    
    //movers[i].applyforce(gravity);
    
         
      trail_obj[i].drag();
      trail_obj[i].sonicforce(boomforce*0.7,temptrackdot);
      trail_obj[i].centregravity(temptrackdot);
      trail_obj[i].update();
      trail_obj[i].display();
      trail_obj[i].checkedges();
    
    
    //  movers[i].drag();
    //  movers[i].sonicforce(boomforce);
    //  movers[i].centregravity();
    //  movers[i].update();
    //  movers[i].display();
    //  movers[i].checkedges();

  }
 }
