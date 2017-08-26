function Iout=affine_warp(Iin,M)
% Affine transformation function (Rotation, Translation, Resize)
Iin = rgb2gray(Iin);
% Make all x,y indices
[x,y]=ndgrid(0:size(Iin,1)-1,0:size(Iin,2)-1);

xd=x;
yd=y;

% Calculate the Transformed coordinates
Tlocalx = M(1,1) * xd + M(1,2) *yd + M(1,3) * 1;
Tlocaly = M(2,1) * xd + M(2,2) *yd + M(2,3) * 1;

Iout=image_interpolation(Iin,Tlocalx,Tlocaly);

function Iout = image_interpolation(Iin,Tlocalx,Tlocaly,ImageSize)


if(~isa(Iin,'double')), Iin=double(Iin); end
if(nargin<6), ImageSize=[size(Iin,1) size(Iin,2)]; end
if(ndims(Iin)==2), lo=1; else lo=3; end


xBas0=floor(Tlocalx);
yBas0=floor(Tlocaly);
tx=Tlocalx-xBas0;
ty=Tlocaly-yBas0;

% Determine the t vectors
vec_tx0= 0.5; vec_tx1= 0.5*tx; vec_tx2= 0.5*tx.^2; vec_tx3= 0.5*tx.^3;
vec_ty0= 0.5; vec_ty1= 0.5*ty; vec_ty2= 0.5*ty.^2;vec_ty3= 0.5*ty.^3;

% t vector multiplied with 4x4 bicubic kernel gives the to q vectors
vec_qx0= -1.0*vec_tx1 + 2.0*vec_tx2 - 1.0*vec_tx3;
vec_qx1=  2.0*vec_tx0 - 5.0*vec_tx2 + 3.0*vec_tx3;
vec_qx2=  1.0*vec_tx1 + 4.0*vec_tx2 - 3.0*vec_tx3;
vec_qx3= -1.0*vec_tx2 + 1.0*vec_tx3;

vec_qy0= -1.0*vec_ty1 + 2.0*vec_ty2 - 1.0*vec_ty3;
vec_qy1=  2.0*vec_ty0 - 5.0*vec_ty2 + 3.0*vec_ty3;
vec_qy2=  1.0*vec_ty1 + 4.0*vec_ty2 - 3.0*vec_ty3;
vec_qy3= -1.0*vec_ty2 + 1.0*vec_ty3;

% Determine 1D neighbour coordinates
xn0=xBas0-1; xn1=xBas0; xn2=xBas0+1; xn3=xBas0+2;
yn0=yBas0-1; yn1=yBas0; yn2=yBas0+1; yn3=yBas0+2;


% limit indexes to boundaries

check_xn0=(xn0<0)|(xn0>(size(Iin,1)-1));
check_xn1=(xn1<0)|(xn1>(size(Iin,1)-1));
check_xn2=(xn2<0)|(xn2>(size(Iin,1)-1));
check_xn3=(xn3<0)|(xn3>(size(Iin,1)-1));
check_yn0=(yn0<0)|(yn0>(size(Iin,2)-1));
check_yn1=(yn1<0)|(yn1>(size(Iin,2)-1));
check_yn2=(yn2<0)|(yn2>(size(Iin,2)-1));
check_yn3=(yn3<0)|(yn3>(size(Iin,2)-1));
xn0=min(max(xn0,0),size(Iin,1)-1);
xn1=min(max(xn1,0),size(Iin,1)-1);
xn2=min(max(xn2,0),size(Iin,1)-1);
xn3=min(max(xn3,0),size(Iin,1)-1);
yn0=min(max(yn0,0),size(Iin,2)-1);
yn1=min(max(yn1,0),size(Iin,2)-1);
yn2=min(max(yn2,0),size(Iin,2)-1);
yn3=min(max(yn3,0),size(Iin,2)-1);


Iout=zeros([ImageSize(1:2) lo]);
for i=1:lo % Loop incase of RGB
    Iin_one=Iin(:,:,i);
    
    % Get the intensities
    Iy0x0=Iin_one(1+xn0+yn0*size(Iin,1));Iy0x1=Iin_one(1+xn1+yn0*size(Iin,1));
    Iy0x2=Iin_one(1+xn2+yn0*size(Iin,1));Iy0x3=Iin_one(1+xn3+yn0*size(Iin,1));
    Iy1x0=Iin_one(1+xn0+yn1*size(Iin,1));Iy1x1=Iin_one(1+xn1+yn1*size(Iin,1));
    Iy1x2=Iin_one(1+xn2+yn1*size(Iin,1));Iy1x3=Iin_one(1+xn3+yn1*size(Iin,1));
    Iy2x0=Iin_one(1+xn0+yn2*size(Iin,1));Iy2x1=Iin_one(1+xn1+yn2*size(Iin,1));
    Iy2x2=Iin_one(1+xn2+yn2*size(Iin,1));Iy2x3=Iin_one(1+xn3+yn2*size(Iin,1));
    Iy3x0=Iin_one(1+xn0+yn3*size(Iin,1));Iy3x1=Iin_one(1+xn1+yn3*size(Iin,1));
    Iy3x2=Iin_one(1+xn2+yn3*size(Iin,1));Iy3x3=Iin_one(1+xn3+yn3*size(Iin,1));
    
    % Set pixels outside the image
    
    Iy0x0(check_yn0|check_xn0)=0;Iy0x1(check_yn0|check_xn1)=0;
    Iy0x2(check_yn0|check_xn2)=0;Iy0x3(check_yn0|check_xn3)=0;
    Iy1x0(check_yn1|check_xn0)=0;Iy1x1(check_yn1|check_xn1)=0;
    Iy1x2(check_yn1|check_xn2)=0;Iy1x3(check_yn1|check_xn3)=0;
    Iy2x0(check_yn2|check_xn0)=0;Iy2x1(check_yn2|check_xn1)=0;
    Iy2x2(check_yn2|check_xn2)=0;Iy2x3(check_yn2|check_xn3)=0;
    Iy3x0(check_yn3|check_xn0)=0;Iy3x1(check_yn3|check_xn1)=0;
    Iy3x2(check_yn3|check_xn2)=0;Iy3x3(check_yn3|check_xn3)=0;
    
    
    % Combine the weighted neighbour pixel intensities
    Iout_one=vec_qy0.*(vec_qx0.*Iy0x0+vec_qx1.*Iy0x1+vec_qx2.*Iy0x2+vec_qx3.*Iy0x3)+...
        vec_qy1.*(vec_qx0.*Iy1x0+vec_qx1.*Iy1x1+vec_qx2.*Iy1x2+vec_qx3.*Iy1x3)+...
        vec_qy2.*(vec_qx0.*Iy2x0+vec_qx1.*Iy2x1+vec_qx2.*Iy2x2+vec_qx3.*Iy2x3)+...
        vec_qy3.*(vec_qx0.*Iy3x0+vec_qx1.*Iy3x1+vec_qx2.*Iy3x2+vec_qx3.*Iy3x3);
    
        Iout(:,:,i)=reshape(Iout_one, ImageSize);
    Iout(:,:,i)=Iout_one;
    
end






