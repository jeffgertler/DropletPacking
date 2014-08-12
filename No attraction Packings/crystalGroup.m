classdef crystalGroup < handle
  properties
    size; %number of crystals
    crystals; %array of crystals
    error; %error in angles
    
    v; %voronoi information
    c;
  end
  
  methods
    % Initialize the group
    function obj = crystalGroup(error, v, c)
      obj.size = 0;
      obj.crystals = {};
      obj.error = error;
      obj.v = v;
      obj.c = c;
    end
    
    % Add a new droplet. Checks to see if the group is empty.
    % Then cycles through cyrstals for an angle match.
    function crystalNum = addDroplet(obj, index, angle)
      % Adding new crystal with angle
      newCrystal = crystal(index, angle);
      % Checking for neighboring crystals
      neighboringCrystals = findNeighboringCrystals(index);
      % Merging like angled crystals
      if(neighboringCrystals ~= -1)
        for i=1:length(neighboringCrystals)
          if(abs(neighboringCrystals{i}.getAngle - angle) < obj.error || ...
            abs(neighboringCrystals{i}.getAngle - angle) > (360-obj.error))
            % Merging
            mergeCrystals(newCrystal, neighboringCrystals{i});
          end
        end
      % Bookkeeping stuff
      obj.crystals = [obj.crystals; {newCrystal}];
      obj.size = obj.size+1;
      crystalNum = obj.size;
    end
    
    % Adds droplets from crystal2 to crystal1. Delets crystal2
    function size = mergeCrystals(obj, crystal1, crystal2)
      % GET ER DONE
    end
    
    % Finds neighboring crystals of a droplet index
    function neighboringCrystals = findNeighboringCrystals(obj, index)
      neighboringCrystals = {};
      droplets = findNeighboringDroplets(index);
      for i=1:length(droplets)
        crystal = crystalForDroplet(droplets{i});
        if(crystal ~= -1)
          neighboringCrystals = [neighboringCrystals; {crystal}];
        end
      end
      if(isEmpty(neighboringCrystals))
        neighboringCrystals = -1;
      end
    end
    
    % Finds the crystal for a droplet index, returns -1 if not found.
    function crystal = crystalForDroplet(obj, index)
      for i=1:obj.crystals
        if(any(obj.crystals{i}.getIndexes() == index))
          crystal = obj.crystals{i};
          return
        end
      end
      crystal = -1;
    end
    
    % Finds neighboring droplet indexes
    function neighboringDroplets = findNeighboringDroplets(obj, index)
      neighboringDroplets = {};
      virticies = obj.c{index};
      for i=1:length(obj.c)
        testVirticies = obj.c{i};
        for j=1:length(virticies)
          if(i ~= j && any(testVirticies == virticies(j)))
            neighboringDroplets = [neighboringDroplets; {i}];
          end
        end
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