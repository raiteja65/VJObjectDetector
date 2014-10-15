function DisplayDetections(im, dets)

imshow(im);

k = size(dets,1);

hold on;
for i=1:k
   rectangle('Position', dets(i,:),'LineWidth',2,'EdgeColor', 'r'); 
end
hold off;
