
addpath('/Users/matthewbuchan/Desktop/Polarity Data')
filename1 = 'angle_bins.xlsx';
filename2 = 'SNPL4';

anglebins = xlsread(filename1);
polarity =xlsread(filename2); 

rad_angle = degtorad(anglebins);

% So that for several columns of polarity 

%convert angle bins to radians for polarplot.m

%fit circle to experimental data & generate polarity index 'neuron q'

for j = 1:size(polarity, 2); 

ellipse = fit_ellipse(rad_angle, polarity(:,j)); 

if ~ isempty(ellipse.a) 

neuronq(j) = (ellipse.long_axis)/(ellipse.short_axis);

else 

   neuronq(j) = NaN; 

end

%shuffle values in angle and polarity columns 1000 times and compute a new
%q value for each shuffle 

for i = 1:1000

shuf_pol = shuffle(polarity(:,j));
shuf_ang = shuffle(rad_angle);

match_mat = [shuf_pol shuf_ang];

ellipse = fit_ellipse(match_mat(:,1), match_mat(:,2)); 

 if ~ isempty(ellipse.a) 

    q(i) = (ellipse.long_axis)/(ellipse.short_axis); 

 else 
    
    q(i) = NaN; 

 end
    
end 

%save to mean value 'normq'

normq = nanmean(q);
stdq = nanstd(q); 

%work out whether p_index is 2 standard deviations bigger than original
%neuronq value

p_index(j) = (neuronq(j) - normq)/stdq;

% if p_index > 0 
%     disp('Polar')
% else
%     disp ('Not Polar')
% end

%plot original neuron data 

figure(1)
polarplot(rad_angle, polarity); 

% ax = gca;
% 
% ax.RTick = [];
% ax.ThetaTick = [];


hold on

end

hold off
figure(2) 
polarplot(rad_angle, mean(polarity,2));

% ax = gca;
% ax.RTick = [4];


