function x = repro(I)
I.y = uint8(I.y +128);
I.cb = uint8(I.cb + 128);
I.cr = uint8(I.cr + 128);
%lay mau len
temp = I.y;
temp(:,1:2:end) = I.cb;
temp(:,2:2:end) = I.cb;
I.cb = temp;
temp(:,1:2:end) = I.cr;
temp(:,2:2:end) = I.cr;
I.cr = temp;
%ghep 3 khong gian mau
x = cat(3,I.y, I.cb, I.cr);
%chuyen khong gian mau sang rgn
x = ycbcr2rgb(x);
end
