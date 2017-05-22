function [v1,v2,v3,dict1 ,dict2,dict3] =Huffman_rgb(X)
r=X.r;
g=X.g;
b=X.b;
%Huffman voi r
r_element =unique(r);
r_count=histc(r,r_element);
r_freq=r_count/numel(r);
r_dict=huffmandict(r_element,r_freq);
v1=huffmanenco(r,r_dict);
dict1 =r_dict;
%Huffman voi g
g_element =unique(g);
g_count=histc(g,g_element);
g_freq=g_count/numel(g);
g_dict=huffmandict(g_element,g_freq);
v2=huffmanenco(g,g_dict);
dict2=g_dict;
%Huffman voi b
b_element =unique(b);
b_count=histc(b,b_element);
b_freq=b_count/numel(b);
b_dict=huffmandict(b_element,b_freq);
v3=huffmanenco(b,b_dict);
dict3=b_dict;
end