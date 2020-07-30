/**
 * HSVColorTracking
 * Greg Borenstein
 * https://github.com/atduskgreg/opencv-processing-book/blob/master/code/hsv_color_tracking/HSVColorTracking/HSVColorTracking.pde
 *
 * Modified by Jordi Tost @jorditost (color selection)
 *
 * University of Applied Sciences Potsdam, 2014
 */
 
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

PShader blur;
Movie video;
OpenCV opencv;
PImage src, colorFilteredImage;
ArrayList<Contour> contours;
PVector trackdot_;
float framerate=6;

// <1> Set the range of Hue values for our filter
//tracks the hand motion
int rangeLow = 2;
int rangeHigh = 4;
float t=0;

void setup() {
   size(720, 720, P3D);
   frameRate(framerate);
   if(framerate==6)
  video = new Movie(this, "septextended.mp4");
  else if(framerate==30)
  video=new Movie(this,"septcrop.mp4");
  setup_audio();
  song.play();
  //while(song.isPlaying()==false)
  //delay(1);
  video.play();
 /* while(video.height==0)
  {
    delay(1);
  }
 */
  
  opencv = new OpenCV(this, width, height);
  contours = new ArrayList<Contour>();
  blur = loadShader("blur.glsl.txt"); 
  particle_initialize();
  
 
}


void keyPressed()
{ if (key=='o')
  {song.pause();
   video.pause();
  }
  else if(key=='r')
  { song.play();
    video.play();
  }
}

void draw() {
  background(0,0,0);
  // Read last captured frame
  if (video.available()) {
    video.read();
  }
  //image(video,0,0);
  fft.forward(song.mix);
  
    //spectrum_display();
   
    
   

  // <2> Load the new frame of our movie in to OpenCV
   if (video.width > 0 && video.height > 0) {//check if the cam instance has loaded pixels
    opencv.loadImage(video);
  } 
 
  
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);
  
  // <4> Copy the Hue channel of our image into 
  //     the gray channel, which we process.
 opencv.setGray(opencv.getH().clone());
  
  // <5> Filter the image based on the range of 
  //     hue values that match the object we want to track.
  opencv.inRange(rangeLow, rangeHigh);
  
  // <6> Get the processed image for reference.
  colorFilteredImage = opencv.getSnapshot();
  
  ///////////////////////////////////////////
  // We could process our image here!
  // See ImageFiltering.pde
  ///////////////////////////////////////////
  
  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  contours = opencv.findContours(true, true);
  
  // <8> Display background images
  //image(src, 0, 0);
  //image(colorFilteredImage, src.width, 0);
 // println("width:"+src.width+",   height:"+src.height);
  
  // <9> Check to make sure we've found any contours
  if (contours.size() > 0) {
    // <9> Get the first contour, which will be the largest one
    Contour biggestContour = contours.get(0);
    
    // <10> Find the bounding box of the largest contour,
    //      and hence our object.
    Rectangle r = biggestContour.getBoundingBox();
    
    // <11> Draw the bounding box of our object
    //colorMode(RGB);
    noFill(); 
    strokeWeight(2); 
    stroke(0.5, 0.5,0.3);
    //rect(r.x, r.y, r.width, r.height);
    
    // <12> Draw a dot in the middle of the bounding box, on the object.
    noStroke(); 
    
    fill(0.5, 0.5, 1);
   // ellipse(r.x + r.width/2, r.y + r.height/2, 30, 30);
    trackdot_=new PVector(r.x + r.width/2, r.y + r.height/2);
     particle_action(trackdot_);
  }
   filter(blur);
   float hue_=map(sin(t),-1,1,0,0.6);
   tint(hue_,0.7,0.8);
   image(src, 0, 0);
   t=t+0.05;
  //saveFrame("data/pic######");
    
}

void mousePressed() {
  colorMode(RGB);
  color c = get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
  int hue = int(map(hue(c), 0, 255, 0, 180));
  println("hue to detect: " + hue);
  
  rangeLow = hue - 1;
  rangeHigh = hue + 1;
  
  
}
