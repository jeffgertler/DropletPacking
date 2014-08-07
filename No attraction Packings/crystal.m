classdef crystal < handle
  properties
    size; %number of droplets
    angle; %angle defining orientation
    dropletIndexes;  %array of droplet indexes
    dropletAngles;  %array of droplet angles
    
    
    
  end
  methods
    function obj = crystal(index, angle)
      obj.size=1;
      obj.angle=angle;
      obj.dropletIndexes = {index};
      obj.dropletAngles = {angle};
    end
    
    function didAdd = addDroplet(obj, index, angle, error)
      if(abs(obj.angle - angle) < error || abs(obj.angle - angle) > (360-error))
        obj.angle = (obj.angle*obj.size + angle) / (obj.size+1);
        obj.size = obj.size + 1;
        obj.dropletIndexes = [obj.dropletIndexes; {index}];
        obj.dropletAngles = [obj.dropletAngles; {angle}];
        didAdd = 1;
      else
        didAdd = -1;
      end
    end
    
    function size = getSize(obj)
      size = obj.size;
    end
    
    function angle = getAngle(obj)
      angle = obj.angle;
    end
    
    function indexes = getIndexes(obj)
      indexes = obj.dropletIndexes;
    end
    
    function angles = getAngles(obj)
      angles = obj.dropletAngles;
    end
    
    function d = printInfo(obj)
      for i=1:obj.size
        fprintf('index %i: %i  angle:%s\n', i, obj.dropletIndexes{i}, ...
                num2str(obj.dropletAngles{i},'%.2f'));
      end
    end
  end
end