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
    end
    
    % Add a new droplet. Checks to see if the group is empty.
    % Then cycles through cyrstals for an angle match.
    function addDroplet(obj, index, angle)
      % Adding new crystal with angle
      newCrystal = Crystal(index, angle);
      obj.crystals = [obj.crystals; {newCrystal}];
      newCrystal.crystalNum = length(obj.crystals);
      % Checking for neighboring crystals
      neighboringCrystals = CrystalGroup.findNeighboringCrystals(index, obj.crystals, obj.c);
      fprintf('index %i, length %i\n', index, length(neighboringCrystals));
      % Merging like angled crystals
      if(~isempty(neighboringCrystals))
        for i=1:length(neighboringCrystals)
          a = abs(neighboringCrystals{i}.getAngle() - angle) < obj.error;
          b = abs(neighboringCrystals{i}.getAngle() - angle) > (360-obj.error);
          if(a || b)
            % Merging
            if(newCrystal.getCrystalNum() ~= neighboringCrystals{i}.getCrystalNum())
              fprintf('merging size %i with size %i\n', newCrystal.getSize(), ...
                      neighboringCrystals{i}.getSize());
              CrystalGroup.mergeCrystals(newCrystal, neighboringCrystals{i});
              obj.crystals{neighboringCrystals{i}.crystalNum}.remove();
            end
          end
        end
      end
    end
    
    function paintPatches(obj)
      for i=1:length(obj.crystals)
        if(obj.crystals{i}.isValid())
          droplets = obj.crystals{i}.getIndexes();
          color = [.2, rand, rand];
          for j=1:length(droplets)
            patch(obj.v(obj.c{j},1),obj.v(obj.c{j},2),color);
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
      droplets = CrystalGroup.findNeighboringDroplets(index, c);
      if(~isempty(droplets))
        for i=1:length(droplets)
          crystal = CrystalGroup.crystalForDroplet(droplets{i}, crystals);
          if(crystal.isValid())
            neighboringCrystals = [neighboringCrystals; {crystal}];
          end
        end
      end
    end
    
    % Finds the crystal for a droplet index, returns -1 if not found.
    function crystal = crystalForDroplet(index, crystals)
      for i=1:length(crystals)
        if(any(cell2mat(crystals{i}.getIndexes()) == index))
          if(crystals{i}.isValid()>0)
            crystal = crystals{i};
            return
          end
        end
      end
      crystal = Crystal(-1, -1);
      crystal.remove();
    end
    
    % Finds neighboring droplet indexes
    function neighboringDroplets = findNeighboringDroplets(index, c)
      neighboringDroplets = {};
      virticies = c{index};
      for i=1:length(c)
        testVirticies = c{i};
        for j=1:length(testVirticies)
          if(any(virticies == testVirticies(j)) && index ~= i ...
              && ~any(cell2mat(neighboringDroplets) == i))
            neighboringDroplets = [neighboringDroplets; {i}];
          end
        end
      end
    end
    

    
  end
end