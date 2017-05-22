% Ham giai ma ma hoa Huffman
% Muc dich: Giai ma vector chua cac bit nhi phan thanh cac vector du lieu anh                                                                        
% Input:  Cac vector du lieu anh chua cac bit nhi phan, cac bo tu dien                   
% Output: Cac vector du lieu anh


function X = huffman_decode (U1,U2,U3,dict1,dict2,dict3)

% Ham thuc hien giai ma
V1 = huffmandeco(U1,dict1);
V2 = huffmandeco(U2,dict2);
V3 = huffmandeco(U3,dict3);

% Ghep cac vector thanh phan lai
X = struct;
X.y = V1;
X.cb = V2;
X.cr = V3;

end

