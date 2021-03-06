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
    function obj = Crystal(index, angle)
      obj.size=1;
      obj.angle=angle;
      obj.dropletIndexes = {index};
      obj.dropletAngles = {angle};
      obj.valid = 1;
    end
    
    function addDroplet(obj, index, angle)
      if(~any(cell2mat(obj.dropletIndexes) == index))
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
    
    function crystalNum = getCrystalNum(obj)
      crystalNum = obj.crystalNum;
    end
    
    function d = printInfo(obj)
      for i=1:obj.size
        fprintf('index %i: %i  angle:%s\n', i, obj.dropletIndexes{i}, ...
                num2str(obj.dropletAngles{i},'%.2f'));
      end
    end
  end
end