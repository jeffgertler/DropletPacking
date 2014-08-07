classdef crystalGroup < handle
  properties
    size; %number of crystals
    crystals; %array of crystals
  end
  
  methods
    % Initialize the group
    function obj = crystalGroup()
      obj.size = 0;
      obj.crystals = {};
    end
    
    % Add a new droplet. Checks to see if the group is empty.
    % Then cycles through cyrstals for an angle match.
    function crystalNum = addDroplet(obj, index, angle, error)
      if(obj.size == 0)
        newCrystal = crystal(index, angle);
        obj.crystals = [obj.crystals; {newCrystal}];
        obj.size = obj.size+1;
        crystalNum = 1;
      else
        for i=1:obj.size
          if(obj.crystals{i}.addDroplet(index, angle, error) > 0)
            crystalNum = i;
            return
          end
        end
        newCrystal = crystal(index, angle);
        obj.crystals = [obj.crystals; {newCrystal}];
        obj.size = obj.size+1;
        crystalNum = obj.size;
      end
    end
    
    function size = getSize(obj)
      size = obj.size;
    end
    
    function indexes = indexesForCrystal(obj, crystalNum)
      indexes = obj.crystals{crystalNum}.getIndexes();
    end
    
    function p = printCrystals(obj, details)
      for i=1:obj.size
        fprintf('\nCrystal %i, size %i, angle %s\n', i, ...
                    obj.crystals{i}.getSize(), ...
                    num2str(obj.crystals{i}.getAngle(),'%.2f'));
        if(details)
        	obj.crystals{i}.printInfo();
        end
      end
    end
    
  end
end