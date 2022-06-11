function [x1,y1] = getCURLYscatGadf(L,th,xc,yc,step,Curliness)

L1 = 0:step:L;
th1 = (th/180)*pi;
x1 = cos(th1)*L1;
x1 = x1 - mean(x1) + xc;
y1 = sin(th1)*L1;
y1 = y1 - mean(y1) + yc;

n_x = Curliness*randn(1,length(x1));
n_y = Curliness*randn(1,length(x1));

x1 = x1 + n_x;
y1 = y1 + n_y;

end

