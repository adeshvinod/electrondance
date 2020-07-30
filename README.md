# electrondance
first isolate the instrument stem track and run it through a noise gate to remove any background hum.
mono recordings will work better than stereo when doing fft analysis.
import openCV library and minim libraries into processing sketch.
add the mp3 file into minim setup and mp4 file into movie setup.
experiment with the intensity variable and fft spectrum range to optimise the animation for your song.

slow down the video and audio by 0.2x (you can use inshot app).
set the framerate to 6 and use the slowed down versions in the processing sketch (code is heavy, computer may not have enough compute power to run smoothly wwithout lag).
start saving the .tif files into a specific folder(can be the data folder itself) by uncommenting the saveFrame() line.
use ffmpeg to render into a movie.(check ffmpeg README).
speedup the final movie to 5x to restore original speed.
