%read image
[note10,map] = imread('ten.png');
figure,imshow(note10)

%Colour detection

count=0;
for i =10:416 % The other direction j = 1 : x
    flag=1;
    for j =10:801 % The other direction i = 1 : y
        if((note10(i,j)~=255)||flag==0)
            flag=0;
            count=count+1;
            y11(count)=i; % The other direction x1(count)=j
            break
        end
    end
end


count=0;
for j =10:801 % The other direction j = 1 : x
    flag=1;
    for i =10:416 % The other direction i = 1 : y
        if((note10(i,j)~=255)||flag==0)
            flag=0;
            count=count+1;
            x11(count)=j; % The other direction x1(count)=j
            break
        end
    end
end

PY11 = min(y11) % First record
PY21 = max(y11) % Last record
PX11 = min(x11) % First record
PX21 = max(x11) % Last record

note10_rgb_crop = imcrop(note10,[PX11 PY11 (PX21-PX11) (PY21-PY11)]);
figure,imshow(note10_rgb_crop);

figure,
subplot(3,1,1);
imhist(note10_rgb_crop(:,:,1));
legend('Red','Location','NorthWest');

subplot(3,1,2);
imhist(note10_rgb_crop(:,:,2));
legend('Green','Location','NorthWest');

subplot(3,1,3);
imhist(note10_rgb_crop(:,:,3));
legend('Blue','Location','NorthWest');




%Pre-processing
note10 = medfilt2(rgb2gray(note10));
note10 = histeq(note10);




note10_bw = im2bw(note10,map,0.05);
grid on;
axis on;
figure,imshow(note10_bw)

%cutting
count=0;
for i =10:416 % The other direction j = 1 : x
    flag=1;
    for j =10:801 % The other direction i = 1 : y
        if((note10_bw(i,j)==0)||flag==0)
            flag=0;
            count=count+1;
            y1(count)=i; % The other direction x1(count)=j
            break
        end
    end
end


count=0;
for j =10:801 % The other direction j = 1 : x
    flag=1;
    for i =10:416 % The other direction i = 1 : y
        if((note10_bw(i,j)==0)||flag==0)
            flag=0;
            count=count+1;
            x1(count)=j; % The other direction x1(count)=j
            break
        end
    end
end

PY1 = min(y1) % First record
PY2 = max(y1) % Last record
PX1 = min(x1) % First record
PX2 = max(x1) % Last record

note10_crop = imcrop(note10_bw,[PX1 PY1 (PX2-PX1) (PY2-PY1)]);
figure,imshow(note10_crop);
grid on;
axis on;

GX1 = 200;
GX2 = 250;
GY1 = 60;
GY2 = 100;

note10_template = imcrop(note10_crop,[GX1 GY1 50 40]);
figure,imshow(note10_template);

scale_y1 = 0.4;
scale_y2 = 0.4;
scale_x1 = 0.4;
scale_x2 = 0.6;

SX1 = 0;
SY1 = 0;
SX2 = PX2 - PX1;
SY2 = PY2 - PY1;

SY1 = round((SY2-SY1)*scale_y1)+SY1; % Set the boundary by proportional
SY2 = SY2 - round((SY2-SY1)* scale_y2);
SY1 = SY1 -10;
SY2 = SY2 +10;
SX1 = round((SX2-SX1)* scale_x1)+SX1;
SX2 = SX2 - round((SX2-SX1)* scale_x2); %Set the boundary by proportional

note10_segment = imcrop(note10_crop,[SX1 SY1 (SX2-SX1) (SY2-SY1)]);

c = normxcorr2(note10_template,note10_segment); % T1 is the template, S1 is the image
[max_c, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));
xpeak
ypeak
offset = [(xpeak-size(note10_template,2)) (ypeak-size(note10_template,1))];
xoffset=offset(1)+1 % Get the coordinate of X
yoffset=offset(2)+1 % Get the corrdinate of Y

figure,imshow(note10_segment);
grid on;
axis on;
hold on;
rectangle('Position',[xoffset yoffset xpeak-xoffset ypeak-yoffset],'EdgeColor','g')

note10_segment_crop = imcrop(note10_segment,[xoffset yoffset xpeak-xoffset ypeak-yoffset]);
figure,imshow(note10_segment_crop);

black_segment=0;
for i=1:size(note10_segment_crop,1)
    for j=1:size(note10_segment_crop,2)
        if(note10_segment_crop(i,j)==0)
            black_segment = black_segment + 1;
        end
    end
end

black_template=0;
for i=1:size(note10_template,1)
    for j=1:size(note10_template,2)
        if(note10_template(i,j)==0)
            black_template = black_template + 1;
        end
    end
end

diff = abs(black_template - black_segment);
if(diff < 50) 
    result = 'The currency is verified.';
    
else
    result = 'The currency is not verified'
end

disp(result);
