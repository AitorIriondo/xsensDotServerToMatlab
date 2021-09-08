function GoatUDP()
%%%%
%% Sets up UDP to send and recieve messages with Unity
cubeExample = true;
%% clear network settings
instrreset
% Setup UDP
u = udpport("datagram", 'LocalHost', "127.0.0.1", 'LocalPort', 9050);
u.Timeout = 0.9;

% If Connection is remote (not local machine running matlab) send dummy
% data to Unity after Unity is running so that it can get connection information.

% If you want to use the callback feature then something like this can be
% setup. But then data needs passed around in ways that aren't natural in
% matlab
% configureCallback(u,"datagram", 1,@recieveData)

% timer for how long it runs
t0 = clock;  

% Message to jump, needs to be bigger than 1
n = 2;

% How long the goat has signaled ready
readyCnt = 0;

% dummy signal for error 0-1. Up to an avg of 0.065
err = 0.02;
disp('ready');

%Dummy cube for visualization
if(cubeExample == true)
    figureHandle = figure(1);
    StopButton = uicontrol('Style','pushbutton','String','Stop & Close Serial Port','pos',[0, 0, 200, 25],'Callback','delete(gcbo)');
    degreeLabelX = uicontrol('Style','text','String','X:  0 Degrees','pos',[450, 50, 100, 20],'parent',figureHandle);
    degreeLabelY = uicontrol('Style','text','String','Y:  0 Degrees','pos',[450, 30, 100, 20],'parent',figureHandle);
    degreeLabelZ = uicontrol('Style','text','String','Z:  0 Degrees','pos',[450, 10, 100, 20],'parent',figureHandle);
    set(gcf,'Color','black');
    x = 0;
    y = 0;
    z = 0;
    i = 1;
    [vert, face] = NewCoords(x,y,z);
    view([1, 0, 0]);
    h = patch('Vertices',vert,'Faces',face,'FaceVertexCData',3,'FaceColor','flat');
    set(degreeLabelX,'String', ['X:  ' num2str(round(x)) ' degrees']);
    set(degreeLabelY,'String', ['Y:  ' num2str(round(y)) ' degrees']);
    set(degreeLabelZ,'String', ['Z:  ' num2str(round(z)) ' degrees']);
    axis off;
    axis([-1.1,1.1,-1.1,1.1,-1.1,1.1]);
end

while(etime(clock, t0) < 180)
        
    % small delay after redy signal before sending signal.
%     if(readyCnt > 15)
%         % send Jump signal
%         write(u, n, "double",'127.0.0.1', 5124);
%         readyCnt = 0;
%     end

    % check if data is availible and get if it is
    recVal = receiveDataGoat(u);

    % parse data packet (currently just sends a 1 if ready)
    if(~isempty(recVal))
%         disp(strcat("recval ", recVal));
        for i=1:length(recVal)
            readyCnt = readyCnt + recVal(i);
        end
    end
    
    % Generate random error signal
    err = 0.1*rand(1);
    % send error signal. 
    write(u, err, "double",'127.0.0.1', 5124);
    
    if(cubeExample == true && length(recVal) > 1)
        delete(h);
        x = str2double(recVal(3));
        y = str2double(recVal(4));
        z = str2double(recVal(5));
        [vert, face] = NewCoords(x,y,z);
        view([1, 0, 0]);
        h = patch('Vertices',vert,'Faces',face,'FaceVertexCData',3,'FaceColor','flat');
        set(degreeLabelX,'String', ['X:  ' num2str(round(x)) ' degrees']);
        set(degreeLabelY,'String', ['Y:  ' num2str(round(y)) ' degrees']);
        set(degreeLabelZ,'String', ['Z:  ' num2str(round(z)) ' degrees']);
        axis off;
        axis([-1.1,1.1,-1.1,1.1,-1.1,1.1]);


        x = updateAngle(x);

        y = updateAngle(y);

        z = updateAngle(z);

        pause(0.0001);
        drawnow;
        
    end
    
     pause(1/60); % used to simulate data rate
end



end

%% Function to recieve data from Unity UDP
function val = receiveDataGoat(src)

val = [];

if(src.NumDatagramsAvailable == 0)
    return
end

% reads data from UDP as an int
data = read(src,src.NumDatagramsAvailable, "string");
cnt = 1;
%% parse data packet
for j = 1:length(data)
    d = data(j);
    disp(d.Data);
   
   
%     for i = 1:length(d)
%         if((i~=0 && d.Data(i) == ""))
%             continue;
%         end
%         
%         val(cnt,:) = d.Data(i);
%         
%         cnt = cnt +1;
%     end
end
    text = d.Data;
    val = split(text,',');


end
