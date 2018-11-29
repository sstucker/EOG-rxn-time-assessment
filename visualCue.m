classdef visualCue < handle
    %handle class that ~handles~ display of visual stimulus
    %methods:
    %init
    %hideInstructions
    %showInstructions
    %centerCue,leftCue,rightCue
    %WindowAPIdebug <-- hacker use only
    %author: sstucker 11/29/18
    properties
        screen;
        centercue;
        leftcue;
        rightcue;
        instructions;
        distance = 400;
        %resolution of display
        xsize = 1920;
        ysize = 1080;
        %WindowAPI enables actual fullscreen but is tricky to install. set
        %to false if you don't have it
        useWindowAPI = true;
    end
    methods
        function WindowAPIdebug(obj)
            %Display WindowAPI info
            clear('WindowAPI');
            MexVersion = WindowAPI();
            whichWindowAPI = which(MexVersion);

            if isempty(whichWindowAPI)
               error(['JSimon:', mfilename, ':MissingMex'], ...
                  ['*** %s: WindowAPI.mex is not found in the path.\n', ...
                  '    Try to compile it again.'], mfilename);
            end

            fprintf('Using: %s\n\n', whichWindowAPI);
        end
        function init(obj)
           close all
           obj.screen = figure;
           set(obj.screen,'Color','k')
           plottools(obj.screen,'off')
           % Special maximizing such that the inner figure fills the screen:
           if obj.useWindowAPI == true
                WindowAPI(obj.screen, 'Position', 'work');
                WindowAPI(obj.screen, 'Position', 'full');  % Complete monitor
                WindowAPI(obj.screen, 'Button', 'off');
           end
           axis off;
           xlim([0 obj.xsize]);
           ylim([0 obj.ysize]);
           obj.centercue = rectangle('Position',[obj.xsize/2-15,obj.ysize/2-15,30,30],'Curvature',[1,1], 'FaceColor','w');
           obj.leftcue = rectangle('Position',[obj.xsize/2-15-obj.distance,obj.ysize/2-15,30,30],'Curvature',[1,1], 'FaceColor','g','Visible','off');
           obj.rightcue = rectangle('Position',[obj.xsize/2-15+obj.distance,obj.ysize/2-15,30,30],'Curvature',[1,1], 'FaceColor','r','Visible','off');
           obj.instructions = text(obj.xsize/2-600,680,'LOOK AT CENTER DOT UNTIL CUE','FontSize',24,'Color','w'); 
        end
        function hideInstructions(obj)
           set(obj.instructions,'Visible','off')
        end
        function showInstructions(obj)
           set(obj.instructions,'Visible','on')
        end
        function leftCue(obj)
           set(obj.rightcue,'Visible','off') 
           set(obj.centercue,'Visible','off')
           set(obj.leftcue,'Visible','on')
        end
        function rightCue(obj)
           set(obj.leftcue,'Visible','off')       
           set(obj.centercue,'Visible','off')
           set(obj.rightcue,'Visible','on')
        end
        function centerCue(obj)
           set(obj.leftcue,'Visible','off')           
           set(obj.rightcue,'Visible','off')            
           set(obj.centercue,'Visible','on')
        end
    end
end