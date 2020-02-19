# Violence Detection
A framework for violence detection

The insecurity is one of the biggest problems in the world, especially in latin America,  the governments around the world have installed many surveillance cameras but it is very difficult for a person to monitor all the cameras, in this way, the use of artificial intelligence will help enormously. This project started in my master thesis and have two years of developing. Moreover, this project aims to be a framework to store all the state of art in violence detection in video in order to encourage the research on this topic, we are going to applied this software in surveillance camera and hope to reduce the insecurity. Actually, there is nothing compared to that, the majority of research are theorically, but with this framework, we aim to apply it in the real world.

# Real time violence detection in video
In VIF folder the implementation of "Real time violence detection in video" is presented.
https://digital-library.theiet.org/content/conferences/10.1049/ic.2016.0030

Citing

Arceda, V. M., Fabián, K. F., & Gutíerrez, J. C. (2016). Real time violence detection in video.

# Fast car crash detection in video

In car-crash folder the implementation of "Fast car crash detection in video" is presented.
https://ieeexplore.ieee.org/abstract/document/8786306

In order to test the code, you need to download YOLO3 and compile Darknet as is mention in "https://pjreddie.com/darknet/install/"  it will generate the file "libdarknet.so". Then, edit the file "../car-crash/darknet.py" and edit the line bellow updating the path to your "libdarknet.so" file generated before:

lib = CDLL("path to libdarknet.so", RTLD_GLOBAL)

Citing

Arceda, V. E. M., & Riveros, E. L. (2018, October). Fast car crash detection in video. In 2018 XLIV Latin American Computer Conference (CLEI) (pp. 632-637). IEEE.



