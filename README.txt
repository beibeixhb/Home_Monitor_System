################################################################################
#                                                                              # 
#                 CSE 520S Real-Time System Final Project                      # 
#                                                                              # 
################################################################################

Project Name: Real Time Monitor

Members: 
Haobo Xing, haobo.xing@wustl.edu
Xueting Yue, xueting@wustl.edu
Yue Hu, yue.hu@wustl.edu

Manuals:

Before start:
Connect the hardware together, such as the camera to pi, the pi to
router, etc.

Set up two ec2 server, configure whatever programming tools like vim on server
and open the port 8082, 8084.

Prepare your iphone or simulator on your local machine.

Run:

First, follow the technical report and set up node.js and others on ec2 server.

Then, mkdir a folder as node project, put our source files into the folder.

As following, cd to that folder and run "node stream-server.js" cmd.

So far, guess the server is started successfully by checking the std output.

For the client side, run the "raspivid -t 0 -w width -h height -o - | ffmpeg -i
- -s widthxheight -f mpeg1video -b 800k -r 30
http://server-address:server-port/password/width/height/" cmd, where width is
the width of resolution and the height is so, and the widthxheight means so. The
address is the ec2 server address.

For master client, put steam-example.html to the ec2 server.

For iphone, configure the address and run it. You will see vedio on your iphone. 





