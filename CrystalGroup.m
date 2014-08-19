classdef CrystalGroup < handle
  properties
    crystals; %array of crystals
    error; %error in angles
    
    v; %voronoi information
    c;
  end
  
  methods
    % Initialize the group
    function obj = CrystalGroup(error, v, c)
      obj.crystals = {};
      obj.error = error;
      obj.v = v;
      obj.c = c;
      disp('test');
    end
    
    % Add a new droplet. Checks to see if the group is empty.
    % Then cycles through cyrstals for an angle match.
    function addDroplet(obj, index, angle)
      % Adding new crystal with angle
      newCrystal = Crystal(index, angle);
      obj.crystals = [obj.crystals; {newCrystal}];
      newCrystal.crystalNum = length(obj.crystals);
      % Checking for neighboring crystals
      neighboringCrystals = findNeighboringCrystals(index);
      % Merging like angled crystals
      if(~isempty(neighboringCrystals))
        for i=1:length(neighboringCrystals)
          if(abs(neighboringCrystals{i}.getAngle - angle) < obj.error || ...
            abs(neighboringCrystals{i}.getAngle - angle) > (360-obj.error))
            % Merging
            if(newCrystal.getCrystalNum() ~= neighboringCrystals{i}.getCrystalNum())
              mergeCrystals(newCrystal, neighboringCrystals{i});
              obj.crystals{neighboringCrystals{i}.crystalNum}.remove();
            end
          end
        end
      end
    end
    

    
    function indexes = indexesForCrystal(obj, crystalNum)
      indexes = obj.crystals{crystalNum}.getIndexes();
    end
    
    function p = printCrystals(obj, details)
      for i=1:length(obj.crystals)
        fprintf('\nCrystal %i, size %i, angle %s\n', i, ...
                    obj.crystals{i}.getSize(), ...
                    num2str(obj.crystals{i}.getAngle(),'%.2f'));
        if(details)
        	obj.crystals{i}.printInfo();
        end
      end
    end
    
  end
  
  methods(Static)
    
    % Adds droplets from crystal2 to crystal1
    function mergeCrystals(crystal1, crystal2)
      indexes = crystal2.getIndexes();
      angles = crystal2.getAngles();
      for i=1:length(indexes)
        crystal1.addDroplet(indexes{i}, angles{i});
      end
    end
    
    % Finds neighboring crystals of a droplet index
    function neighboringCrystals = findNeighboringCrystals(index, crystals, c)
      neighboringCrystals = {};
      droplets = findNeighboringDroplets(index, c);
      for i=1:length(droplets)
        crystal = crystalForDroplet(droplets{i}, crystals);
        neighboringCrystals = [neighboringCrystals; {crystal}];
      end
    end
    
    % Finds the crystal for a droplet index, returns -1 if not found.
    function crystal = crystalForDroplet(index, crystals)
      for i=1:crystals
        if(any(crystals{i}.getIndexes() == index) && crystals{i}.isValid())
          crystal = crystals{i};
          return
        end
      end
      crystal = 0;
    end
    
    % Finds neighboring droplet indexes
    function neighboringDroplets = findNeighboringDroplets(index, c)
      neighboringDroplets = {};
      virticies = c{index};
      for i=1:length(c)
        testVirticies = c{i};
        for j=1:length(virticies)
          if(i ~= j && any(testVirticies == virticies(j)))
            neighboringDroplets = [neighboringDroplets; {i}];
          end
        end
      end
    end
    

    
  end
end