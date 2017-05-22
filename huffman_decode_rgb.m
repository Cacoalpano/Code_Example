function X =huffman_decode_rgb(dict1,dict2,dict3,U1,U2,U3)
V1 = huffmandeco(U1,dict1);
V2 = huffmandeco(U2,dict2);
V3 = huffmandeco(U3,dict3);
%X 
X = struct;
X.r= V1;
X.g = V2;
X.b = V3;
end
