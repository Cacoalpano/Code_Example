% Ham ma hoa Huffman
% Muc dich: Ma hoa vector du lieu anh thanh cac bit nhi phan                                                                           
% Input:  Cac vector du lieu anh                   
% Output: Cac vector chua cac bit nhi phan, cac bo tu dien


function [V1 V2 V3 dict1 dict2 dict3] = huffman(U)

% Cac vector thanh phan
U1 = U.y;
U2 = U.cb;
U3 = U.cr;

% Ma hoa huffman cho U1
% Thong ke cac phan tu cua U1
U1_element = unique(U1);
% So lan xuat hien cua cac phan tu trong mang U1 theo thu tu
U1_count = histc(U1,U1_element);
% Tan suat xuat hien cua cac phan tu trong mang U1 theo thu tu
U1_freq = U1_count/numel(U1);
% Tao bo tu dien
U1_dict = huffmandict(U1_element,U1_freq);
% Thuc hien ma hoa huffman
V1 = huffmanenco(U1,U1_dict);

% Tuong tu cho U2
U2_element = unique(U2);
U2_count = histc(U2,U2_element);
U2_freq = U2_count/numel(U2);
U2_dict = huffmandict(U2_element,U2_freq);
V2 = huffmanenco(U2,U2_dict);

% Tuong tu cho U3

U3_element = unique(U3);
U3_count = histc(U3,U3_element);
U3_freq = U3_count/numel(U3);
U3_dict = huffmandict(U3_element,U3_freq);
V3 = huffmanenco(U3,U3_dict);

% Luu lai bo tu dien de giai ma
dict1 = U1_dict;
dict2 = U2_dict;
dict3 = U3_dict;

end

