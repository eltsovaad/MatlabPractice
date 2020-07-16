clc;
clear;
X1_0=100;%Начальное значение фитопланктона% от 0 до 100
X2_0=10;%Начальное значение зоопланктона% от 0 до 100
U0=0;%Начальное значение управления
X1_star=20;%Значение фитопланктона, которые необходимо получить% от 0 до 100 близко
B=200;%Значение зоопланктона, ограничение%
n=330;%Максимальное значение y
h=0.01;
E=0.005;
R=0.0001;
f1=@(b1,x1,x2,x3,T)x3(T).*x1(T)-b1.*x1(T).*x2(T);
f2=@(a2,b2,x1,x2,T)-a2.*x2(T)+b2.*x1(T).*x2(T);
x1=NaN(1,n);
x2=NaN(1,n);
x3=NaN(1,n);
%phi=zeros(1,n);
x1(1)=X1_0;
x2(1)=X2_0;
x3(1)=U0;
a2= 0.10;
b1= 0.60;
b2= 0.10;
T1= 0.01;
T2= 0.01;
for t=2:n
x1(t)=x1(t-1)+h.*f1(b1,x1,x2,x3,t-1);

                            x2(t)=x2(t-1)+h.*f2(a2,b2,x1,x2,t-1);
                            dphi=(-((X1_star)./(T2.*(x1(t-1).^2))).*f1(b1,x1,x2,x3,t-1))+(b1.*f2(a2,b2,x1,x2,t-1));
                            phi=-((x1(t-1)-X1_star)./(T2.*x1(t-1)))+b1.*x2(t-1);
                            psi1=x3(t-1)-phi;
                            U=((-(T1).^-1).*psi1)+dphi;
                            x3(t)=x3(t-1)+h.*R.*U;
end
hold on;
    plot(0:n-1,x1,'b',0:n-1, x2, 'r');
    legend("Жертвы","Хищники");
    grid on;
    hold off;