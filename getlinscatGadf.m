function [x1,y1] = getlinscatGadf(L,th,xc,yc,step)

L1 = 0:step:L;
th1 = (th/180)*pi;
x1 = cos(th1)*L1;
x1 = x1 - mean(x1) + xc;
y1 = sin(th1)*L1;
y1 = y1 - mean(y1) + yc;

end

