%                  Tai lieu tham khao                                   %
%Digital image processing - C.Gonzalez, Richard E.Woods                 %
%Fundamentals of Multimedia - Li & Drew Prentice Hall 2003              %
%Data Classification and Compression class - Dr. Salari, Univ. of Toledo%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = standard(name,quality)
%quality=1;
%name='shangrila.bmp';
%Tien xu ly
%clear;
rgb = imread(name); 
%imshow(rgb);
Im_info= imfinfo(name);
I = prepro(rgb);
%khai bao ma tran luong tu hoa
Luminace = [16 11  10  16  24  40  51  61        
            12  12  14  19  26  58  60  55       
            14  13  16  24  40  57  69  56       
            14  17  22  29  51  87  80  62
            18  22  37  56  68  109 103 77
            24  35  55  64  81  104 113 92
            49  64  78  87  103 121 120 101
            72  92  95  98  112 100 103 99] * quality;
Chrominace = [17 18 24 47 99 99 99 99
              18 21 26 66 99 99 99 99
              24 26 56 99 99 99 99 99
              47 66 99 99 99 99 99 99
              99 99 99 99 99 99 99 99
              99 99 99 99 99 99 99 99
              99 99 99 99 99 99 99 99
              99 99 99 99 99 99 99 99] * quality;
%thu tu quet zigzag
% zig_zag = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
%            41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
%            43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
%            45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
%            62 63 56 64];
zig_zag = [1 2 9 17 10 3 4 11 18 25 33 26 19 12 5 ...
        6 13 20 27 34 41 49 42 35 28 21 14 7 8 15 ...
        22 29 36 43 50 57 58 51 44 37 30 23 16 24 ...
        31 38 45 52 59 60 53 46 39 32 40 47 54 61 ...
        62 55 48 56 63 64];
%bien doi dct hai chieu
starttime = cputime;
t = dctmtx(8);                     % tinh ma tran DCT 8 x 8 
y = blkproc(I.y, [8 8], 'P1 * x * P2', t, t'); %bien doi DCT theo tung khoi 8 x 8
cb = blkproc(I.cb, [8 8], 'P1 * x * P2', t, t');
cr = blkproc(I.cr, [8 8], 'P1 * x * P2', t, t');
%luong tu hoa
y = blkproc(y, [8 8], 'round(x ./ P1)', Luminace);
cb = blkproc(cb, [8 8], 'round(x ./ P1)', Chrominace);
cr = blkproc(cr, [8 8], 'round(x ./ P1)', Chrominace);
fprintf(1, '   thoi gian DCT + luong tu hoa: %1.3f\n', (cputime - starttime))
%quet zigzag
starttime = cputime;
y = im2col(y, [8 8], 'distinct');  % Break 8x8 blocks into columns
s_y = size(y, 2);                   % Get number of blocks
y = y(zig_zag, :);                   % Reorder column elements
eoby = max(y(:)) + 1;               % Create end-of-block symbol
ry = zeros(numel(y) + size(y, 2), 1);
count = 0;
for j = 1:s_y                       % Process 1 block (col) at a time
   i = max(find(y(:, j)));         % Find last non-zero element
   if isempty(i)                   % No nonzero block values
      i = 0;
   end
   p = count + 1;
   q = p + i;
   ry(p:q) = [y(1:i, j); eoby];      % Truncate trailing 0's, add EOB,
   count = count + i + 1;          % and add to output vector
end

ry((count + 1):end) = [];           % Delete unusued portion of r
%--------------------------------------------------------------------%
cb = im2col(cb, [8 8], 'distinct');
s_cb = size(cb, 2);
cb = cb(zig_zag, :);
eobcb = max(cb(:)) + 1;
rcb = zeros(numel(cb) + size(cb, 2), 1);
count = 0;
for j = 1:s_cb
   i = max(find(cb(:, j)));
   if isempty(i)
      i = 0;
   end
   p = count + 1;
   q = p + i;
   rcb(p:q) = [cb(1:i, j); eobcb];
   count = count + i + 1;
end

rcb((count + 1):end) = [];
%-------------------------------------------------------------------%

cr = im2col(cr, [8 8], 'distinct');
s_cr = size(cr, 2);
cr = cr(zig_zag, :);
eobcr = max(cr(:)) + 1;
rcr = zeros(numel(cr) + size(cr, 2), 1);
count = 0;
for j = 1:s_cr
   i = max(find(cr(:, j)));
   if isempty(i)
      i = 0;
   end
   p = count + 1;
   q = p + i;
   rcr(p:q) = [cr(1:i, j); eobcr];
   count = count + i + 1;
end

rcr((count + 1):end) = [];
fprintf(1, '   thoi gian quet zig-zag: %1.3f\n', (cputime - starttime))

X = struct;
X.y = ry;
X.cb = rcb;
X.cr = rcr;
starttime = cputime;
[v1 v2 v3 dict1 dict2 dict3] = huffman(X);
fprintf(1, '   thoi gian ma hoa huffman: %1.3f\n', (cputime - starttime))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         giai nen jpeg                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%giai ma huffman
starttime = cputime;
X.y = huffmandeco(v1,dict1);
X.cb = huffmandeco(v2,dict2);
X.cr = huffmandeco(v3,dict3);
fprintf(1, '   thoi gian giai ma huffman: %1.3f\n', (cputime - starttime))
%phuc hoi zigzag
rev = zig_zag;                          % Compute inverse ordering
for k = 1:length(zig_zag)
   rev(k) = find(zig_zag == k);
end
zy = zeros(64, s_y);   k = 1;           % Form block columns by copying
for j = 1:s_y                          % successive values from x into
   for i = 1:64                       % columns of z, while changing
      if X.y(k) == eoby                  % to the next column whenever
         k = k + 1;   break;          % an EOB symbol is found.
      else
         zy(i, j) = X.y(k);
         k = k + 1;
      end
   end
end

zy = zy(rev, :);
xy = col2im(zy, [8 8], [size(I.y,1) size(I.y,2)], 'distinct'); 
%----------------------------------------------------------%
zcb = zeros(64, s_cb);   k = 1;
for j = 1:s_cb
   for i = 1:64
      if X.cb(k) == eobcb
         k = k + 1;   break;
      else
         zcb(i, j) = X.cb(k);
         k = k + 1;
      end
   end
end

zcb = zcb(rev, :);
xcb = col2im(zcb, [8 8], [size(I.cb,1) size(I.cb,2)], 'distinct'); 
%--------------------------------------------------------------%
zcr = zeros(64, s_cr);   k = 1;
for j = 1:s_cr
   for i = 1:64
      if X.cr(k) == eobcr
         k = k + 1;   break;
      else
         zcr(i, j) = X.cr(k);
         k = k + 1;
      end
   end
end

zcr = zcr(rev, :);
xcr = col2im(zcr, [8 8], [size(I.cr,1) size(I.cr,2)], 'distinct'); 
%luong tu hoa nguoc
starttime = cputime;
xy = blkproc(xy, [8 8], 'x .* P1', Luminace);           % Denormalize DCT
xcb = blkproc(xcb, [8 8], 'x .* P1', Chrominace);
xcr = blkproc(xcr, [8 8], 'x .* P1', Chrominace);
%bien doi DCT nguoc
xy = blkproc(xy, [8 8], 'P1 * x * P2', t', t);
xcb = blkproc(xcb, [8 8], 'P1 * x * P2', t', t);
xcr = blkproc(xcr, [8 8], 'P1 * x * P2', t', t);
fprintf(1, '   thoi gian luong tu hoa nguoc + DCT nguoc: %1.3f\n', (cputime - starttime))

X.y = xy;
X.cb = xcb;
X.cr = xcr;
Y = repro(X);
%sai so MSE
mse = immse(Y, rgb);
fprintf('\nsai so trung binh binh phuong MSE: %0.4f\n',mse);
%Ti so tin hieu tren nhieu SNR va PSNR
[peaksnr, snr] = psnr(Y, rgb);
fprintf('\n ti so Peak-SNR: %0.4f', peaksnr);
fprintf('\n ti so SNR:  %0.4f \n', snr);
%Tinh ti so nen
Compress_ratio = (Im_info.Width*Im_info.Height*24)/(numel(v1)+numel(v2)+numel(v3));
fprintf('\nTi so nen: %0.2f : %d\n',Compress_ratio, 1);
figure,imshow(Y)
end
