# xsensDotServerToMatlab
CHanges in xsens_dot_server to enable UDP connection to MATLAB and move a 3D cube in MATLAB (related to https://github.com/xsens/xsens_dot_server )

To enable communication to Matlab or EPP

You will need to install npm datagram on your “node” library to enable UPD communication, for that CD to the folder in command prompt and write:

npm install datagram-stream

You also need to substitute the file “sensorServer.js” in the folder of xsens_dot_server, there I added a small UDP messaging where you can change the port.
Once all is set up, you can run Xsens DOT server again without issues, connect to sensors and start scanning. For the MATLAB example run the file GoatUDP attached in this email. 
I attach also an example of how it looks like in MATLAB "GoatUDP". You can set the cube visualization to 0 to just get strings.
