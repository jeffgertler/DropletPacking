classdef Crystal < handle
  properties
    size; %number of droplets
    angle; %angle defining orientation
    dropletIndexes;  %array of droplet indexes
    dropletAngles;  %array of droplet angles
    valid;
    crystalNum;
    
    
  end
  methods
    function obj = crystal(index, angle)
      obj.size=1;
      obj.angle=angle;
      obj.dropletIndexes = {index};
      obj.dropletAngles = {angle};
    end
    
    function addDroplet(obj, index, angle, error)
      if(~any(cell2mat(obj.droplets) == index))
        obj.size = obj.size + 1;
        obj.dropletIndexes = [obj.dropletIndexes; {index}];
        obj.dropletAngles = [obj.dropletAngles; {angle}];
      end
    end
    
    function remove(obj)
      obj.valid = 0;
    end
    
    function valid = isValid(obj)
      valid = obj.valid;
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