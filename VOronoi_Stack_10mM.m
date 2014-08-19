clear all;
close all;

% fname = imread('Series001_z00_ch00.tif');
% figure
% imshow(fname)

%Subjective tightness on inter-crystal angle
angleError = 60;

fname = 'No_Attraction/10mM_series014.tif';
info = imfinfo(fname);
num_images = numel(info);

for k = 1: 2 :num_images
%for k=1:1
  fprintf('Image %i/%i\n', (k+1)/2, num_images/2);
  A = imread(fname, k);
   
  [centers, radii] = imfindcircles(A,[6 9],'Sensitivity',0.95,'Method','twostage');

  h = viscircles(centers,radii);
  length(centers);

  x=centers(:,1);
  y=centers(:,2);

  voronoi(x,y);

  xlim([0 512]);
  ylim([0 512]);

  [v,c]=voronoin([x(:)  y(:)]); %v is the matrix of the vertices coordinates, 
                                %c is a vector cell array representing the
                                %voronoi region associated with each point,
                                %hence for point x(i) associated regoin is
                                %c(i)
  %B=voronoi(x,y);

  maxangle=60; %angle arround which we want to calculate the remainder of the difference, i.e
              %60 for hexagonal, 90 for cubic
  ncolorbins=maxangle+1; cbins=[0:1:ncolorbins]; %assign a color for each modulo from the target angle
  map=colormap(hsv(ncolorbins));
  
  % Creating the crystal group
  cG = CrystalGroup(angleError, v, c);

  for i = 1:length(c)
  %for i=1:123
    if(abs(i/length(c)-.10)< .5/length(c))
      disp('10% added');
    elseif(abs(i/length(c)-.20)< .5/length(c))
      disp('20% added');
    elseif(abs(i/length(c)-.30)< .5/length(c))
      disp('30% added');
    elseif(abs(i/length(c)-.40)< .5/length(c))
      disp('40% added');
    elseif(abs(i/length(c)-.50)< .5/length(c))
      disp('50% added');
    elseif(abs(i/length(c)-.60)< .5/length(c))
      disp('60% added');
    elseif(abs(i/length(c)-.70)< .5/length(c))
      disp('70% added');
    elseif(abs(i/length(c)-.80)< .5/length(c))
      disp('80% added');
    elseif(abs(i/length(c)-.90)< .5/length(c))
      disp('90% added');
    end
    
    %disp(c{i})
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
      %patch(v(c{i},1),v(c{i},2),i); % use color i. 

      %below is gary's modification
      %
      %    if length(v(c{i})) == 5
      %      patch(v(c{i},1),v(c{i},2),'w'); % use color w.
      %    end

      %now let's try to color based on orientation...

      %this part should be outside of the loop to make
      %it faster

      nneighbors=length(c{i});

      angs=atan2(v(c{i},2)-y(i),v(c{i},1)-x(i))*180/pi; %atan2 = arctangent(vector 
                                                %centered on particles
      ang=mean(mod(angs,maxangle));%mod = ecart par rapport a l'angle target de 
      %                             60 ou 90 degres pour chaque vortex, puis
      %                             moyenne de cet ecart autour d'une particle
      cc=find(ang < cbins,1); % en fonction de l'ecart cc a cet angle de base on 
                                %affecte la couleur indexee cc (d'ou un nombre
                                %de couleurs qui vaut angle cible
      %patch(v(c{i},1),v(c{i},2),map(cc,:)); % use color i.

      %%end gary's modification

      if(nneighbors == 6)
        % Adding droplets into crystal objects and checking angle edge case
        angs = mod(angs+360, 360); %makes negative angles positive
        % Checking that angles are approximetly equal
        if(max(diff(sort(angs))) - min(diff(sort(angs))) < 25)
          %checking edge case
          angle = 0;
          if(max(angs) + angleError > 360) angle = max(angs);
          else angle = min(angs);
          end

          % Inserting droplet
          cG.addDroplet(i, angle);
        else
          % Redding out tiles with uneven sides
          patch(v(c{i},1),v(c{i},2),'r');
        end
      else
        % Blacking out non hexagonal tiles
        patch(v(c{i},1),v(c{i},2),'k');
      end
      
      
    end
  end
  
  cG.printCrystals(0);
  cG.paintPatches();
  
  %patch(v(c{123},1),v(c{123},2),[1, 0, 1]);
  %patch(v(c{85},1),v(c{85},2),[1, 0, 1]);

  %patch(v(c{104},1),v(c{104},2),[1, 0, 1]);
  
  
  axis([0 512 0 512]);

  drawnow;

  filename=strcat('voronoi_10mM_014-',num2str((k+1)/2));
  print('-dtiff',filename); 

  
%pause
end

%%%
%if a particle has 6 neighbors
%if length(v(c{i}) == 6  %equal (== ), not equal (~=), >=, <=
%patch(v(c{i},1),v(c{i},2),'b')

%end


% A = uint8(zeros(512, 512, 11));
%  for i=1:nSlice, [A(:,:,i)]=imread(fname,i);
%      
% d = imdistline; %find the size of the circles
% delete(d); 

% [centers, radii] = imfindcircles(rgb,[6 9], 'Sensitivity', 0.97)
% imshow(rgb);
% 
% h = viscircles(centers,radii); %displays found circles
% length(centers)

%     
% [centers, radii] = imfindcircles(fname,[6 9],'Sensitivity',0.95,'Method','twostage');
% 
% h = viscircles(centers,radii);
% length(centers)
% 
% x=centers(:,1);
% y=centers(:,2);
% 
% voronoi(x,y)