function X= Not_DCT(name)
%NOT_DCT Summary of this function goes here
%   Detailed explanation goes here
%name='shangrila.bmp';
rgb = imread(name); 
%imshow(rgb);
Im_info=imfinfo(name);
r=rgb(:,:,1);
g=rgb(:,:,2);
b=rgb(:,:,3);
[h,s] = size(r);
%%
%%Chuyen ma tran 2 chieu sang dang vecto
for i=1:h
    for j=1:s
        r1((i-1)*s+j,1)=r(i,j);
    end
end
for i=1:h
    for j=1:s
        g1((i-1)*s+j,1)=g(i,j);
    end
end
for i=1:h
    for j=1:s
        b1((i-1)*s+j,1)=b(i,j);
    end
end
%%
%%Ma hoa Huffman
X= struct;
X.r=double(r1);
X.g=double(g1);
X.b=double(b1);
starttime = cputime;
[v1 v2 v3 dict1 dict2 dict3] = Huffman_rgb(X);
fprintf(1, '   thoi gian ma hoa huffman: %1.3f\n', (cputime - starttime))
%%
%%Giai ma Huffman 
starttime = cputime;
Y =huffman_decode_rgb(dict1,dict2,dict3,v1,v2,v3);
fprintf(1, '   thoi gian giai ma  huffman: %1.3f\n', (cputime - starttime))
%%
%%Chuyen dang vecto sang ma tran 
r2=uint8(Y.r);
g2=uint8(Y.g);
b2=uint8(Y.b);
for i=1:h
    for j=1:s
        r3(i,j)=r2((i-1)*s+j,1);
    end
end
for i=1:h
    for j=1:s
        g3(i,j)=g2((i-1)*s+j,1);
    end
end
for i=1:h
    for j=1:s
        b3(i,j)=b2((i-1)*s+j,1);
    end
end
%%
%%Decode image
rgb_decode=cat(3,r3,g3,b3);
%Tinh MSE
MSE_notDCT=immse(rgb_decode,rgb);
fprintf('\nsai so trung binh binh phuong MSE: %0.4f\n',MSE_notDCT)
%Ti so tin hieu tren nhieu SNR va PSNR
[peaksnr_notDCT, snr_notDCT] = psnr(rgb_decode, rgb);
fprintf('\n ti so Peak-SNR: %0.4f', peaksnr_notDCT);
fprintf('\n ti so SNR:  %0.4f \n', snr_notDCT);
%Tinh ti so nen
Compress_ratio_notDCT = (Im_info.Width*Im_info.Height*24)/(numel(v1)+numel(v2)+numel(v3));
fprintf('\nTi so nen: %0.2f : %d\n',Compress_ratio_notDCT, 1);
end

