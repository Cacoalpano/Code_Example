function I = prepro(rgb)
%chuyen he mau
ycrcb = rgb2ycbcr(rgb);
y = ycrcb(:,:,1);
cb = ycrcb(:,:,2);
cr = ycrcb(:,:,3);
%lay mau xuong
%cau truc lay mau 4:2:2
cr = cr(:,1:2:end);
cb = cb(:,1:2:end);
I = struct;
%level offset
I.y = double(y) - 128; 
I.cb = double(cb) - 128;
I.cr = double(cr) - 128;
end
