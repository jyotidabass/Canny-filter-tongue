%Calculating Mask
T=0.1;
sigma=0.5;
m= round(sqrt(-log(T) * 2 * sigma^2));
x=-m:1:m;
y=-m:1:m;
[x,y]= meshgrid(x,y);
%calculating Guassian
g= (1/2*pi*sigma.^2)*exp(-((x.^2)+(y.^2))/2*sigma.^2);
%Finding Gradient
[FX,FY] = gradient(g)
im = imread('Tongue Pic. - Gulshan Rai.jpg');
[H W n]= size(im);
if(n==3)
im1=rgb2gray(im);
else
 im1=im;
end
%Convoling in X and Y direction
im1= conv2(im1,FX,'same');
im2= conv2(im1,FY,'same');
%Calculating Magnitude
magnitude= sqrt(im1.^2+im2.^2);
%Calculating Change in Direction
change_in_direction = atan2(im2,im1);
change_in_direction= radtodeg(change_in_direction);
%Quantizing the Angles
change_in_direction=change_in_direction+180;
nRows=size(change_in_direction,1);
nCols=size(change_in_direction,2);
magnitude= magnitude+1;
for i=1:nRows
   for j=1:nCols
       %making 0 
       if change_in_direction(i,j)>=0 && change_in_direction(i,j)<=22.5
               change_in_direction(i,j)= 0;        
       elseif change_in_direction(i,j)>=157.5 && change_in_direction(i,j)<=202.5
               change_in_direction(i,j)=0;
       elseif change_in_direction(i,j)>=337.5 && change_in_direction(i,j)<=360
               change_in_direction(i,j)=0;
         %Making 1
         elseif change_in_direction(i,j)>=22.5 && change_in_direction(i,j)<=67.5
               change_in_direction(i,j)=1;
         elseif change_in_direction(i,j)>=202.5 && change_in_direction(i,j)<=247.5
               change_in_direction(i,j)=1;
         %making 2
        elseif change_in_direction(i,j)>=67.5 && change_in_direction(i,j)<=112.5
               change_in_direction(i,j)=2;
        elseif change_in_direction(i,j)>=247.5 && change_in_direction(i,j)<=292.5
               change_in_direction(i,j)=2;
        %Making 3
        elseif change_in_direction(i,j)>=112.5 && change_in_direction(i,j)<=157.5
               change_in_direction(i,j)=3;
         elseif change_in_direction(i,j)>=292.5 && change_in_direction(i,j)<=337.5
               change_in_direction(i,j)=3;
       end    
   end
end

%Non_maxima Separation
nRow= size(magnitude,1);
nCol= size(magnitude,2);
%making Rows of our Matrice Zero
for r=1:nRow
    magnitude(r,1)=0;
    magnitude(r,nCol)=0;    
end
%making Columns of our Matrice Zero
for c= 1:nCol
    magnitude(1,c)=0;
    magnitude(nRow,c)=0;
end
%doing Non Maxima Final Round
for r=2:nRow-1
    for c=2:nCol-1
        %Checking for Zero Direction
        if(change_in_direction(r,c)==0)
           if magnitude(r,c)>magnitude(r+1,c)
               magnitude(r+1,c)=0;
           elseif magnitude(r,c)<magnitude(r+1,c)
               magnitude(r,c)=0;
           elseif magnitude(r,c)> magnitude(r-1,c)
               magnitude(r-1,c)=0;
           elseif magnitude(r,c)<magnitude(r-1,c)
               magnitude(r,c)=0;               
           end    
        end
        %checking for 1 direction
        if (change_in_direction(r,c)==1)
            if magnitude(r,c)>magnitude(r-1,c-1)
                magnitude(r-1,c-1)=0;
            elseif magnitude(r,c)<magnitude(r-1,c-1)
                magnitude(r,c)=0;
            elseif magnitude(r,c)>magnitude(r+1,c+1)
                magnitude(r+1,c+1)= 0;
            elseif magnitude(r,c)<magnitude(r+1,c+1)
                magnitude(r,c)=0;
            end    
        end    
        %checking for 2 direction
        if(change_in_direction==2)
            if magnitude(r,c)>magnitude(r,c+1)
                magnitude(r,c+1)=0;
            elseif magnitude(r,c)<magnitude(r,c+1)
                magnitude(r,c)=0;
            elseif magnitude(r,c)>magnitude(r,c-1)
                magnitude(r,c-1)=0;
            elseif magnitude(r,c)<magnitude(r,c-1)
                magnitude(r,c)=0;            
            end
        end
        %checking for 3 direction        
        if(change_in_direction==3)
            if magnitude(r,c)>magnitude(r-1,c+1)
                magnitude(r-1,c+1)=0;
            elseif magniude(r,c)<magnitude(r-1,c+1)
                magnitude(r,c)=0;
            elseif magnitude(r,c)>magnitude(r+1,c-1)
                 magnitude(r+1,c-1)=0;
            elseif magnitude(r,c)<magnitude(r+1,c-1)
                magnitude(r,c)=0;
            end
        end
    end
end
%Hysteresis Threholding
M = magnitude;
V = zeros(size(magnitude));
N=zeros(size(magnitude));
R= size(M,1);
C= size(M,2);
Th=50;
Tl=10;
%[M,N,V,r,c,R,C]= Threshold(M,N,V,r,c,R,C,Th,Tl);
