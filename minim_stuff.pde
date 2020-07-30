//call setup_audio() in setup()
//use mousepressed or keypressed to execute song.play();
//execute fft.forward(song.mix);  in draw()
//call spectrum_display in draw
//add the correct sound file in setup audio

import ddf.minim.*;
import ddf.minim.analysis.*;
import java.lang.Math;

Minim minim;
AudioPlayer song;
FFT fft;



void setup_audio()
{   minim=new Minim(this);
    if(framerate==6)
    song=minim.loadFile("septextended.mp3");
    
    else if(framerate==30)
    song=minim.loadFile("septcrop.mp3");
    
    fft = new FFT(song.bufferSize(), song.sampleRate());
}

void spectrum_display()
{    float rectheight=0;
    for(int i = 0; i < fft.specSize()/6; i=i+1)
    {  rectheight=map(fft.getBand(i),20,140,0,100);
       rect(i*4,540,6,rectheight);
    
    }
}
