clc;
clear;
X1_0=100;%Начальное значение фитопланктона% от 0 до 100
X2_0=10;%Начальное значение зоопланктона% от 0 до 100
U0=0;%Начальное значение управления
X1_star=20;%Значение фитопланктона, которые необходимо получить% от 0 до 100 
n=1000;%Область построения графика
h=0.01;%Шаг для метода Эйлера
E=0.005;%Точность для остановки и для ограничения на 0
R=0.0001;%0>R>1- const
%
%
%
%Все коэффициенты находятся выше. Не меняйте ничего после этих комментариев
%
%
%
f1=@(b1,x1,x2,x3,T)x3(T).*x1(T)-b1.*x1(T).*x2(T);%функция для расчета f1
f2=@(a2,b2,x1,x2,T)-a2.*x2(T)+b2.*x1(T).*x2(T);%функция для расчета f2
%Инициализация векторов х1,х2,х3
x1=NaN(1,n);
x2=NaN(1,n);
x3=NaN(1,n);
%Задаем исходные значения
x1(1)=X1_0;
x2(1)=X2_0;
x3(1)=U0;
solution_found=false;%true если х1 надодится в интервале [х1*-Е; х1*+Е]
NaN_found=false;%true если значение х1 или х2 оказалось NaN
negativeX1_found=false;%true если значение х1 стало отрицательным
negativeX2_found=false;%true если значение х2 стало отрицательным
for T1=[0:0.01:1, 2:10]%Перебор коэффициента Т1
    fprintf('T1= %.2f\n', T1);    
    for T2=[0:0.01:1, 2:10]%Перебор коэффициента Т2
        fprintf('\tT2= %.2f\n', T2);
                %for R=0.1:0.1:1 %оставлено на тот случай если придется
                %перебирать R
            %fprintf('\t\tR= %.2f\n', R);
            %if solution_found==true
                           % break
                       % else
            for a2=0.1:0.1:2 %Перебор коэффициента а2
                %fprintf('\t\t\ta2= %.2f\n', a2);                    
                for b1=0.1:0.1:2 %Перебор коэффициента b1
                    %fprintf('\t\t\t\tb1= %f\n', b1);
                    for b2=0.1:0.1:2 %Перебор коэффициента b2
                        %Инициализация векторов NaN перед каждой следующей
                        %итерацией
                        x1=NaN(1,n);
                        x2=NaN(1,n);
                        x3=NaN(1,n);
                        x1(1)=X1_0;
                        x2(1)=X2_0;
                        x3(1)=U0;
                        for t=2:n %Начало метода Эйлера
                            if (solution_found~=true)&&(NaN_found~=true)&&(negativeX1_found~=true)&&(negativeX2_found~=true) 
                            x1(t)=x1(t-1)+h.*f1(b1,x1,x2,x3,t-1);
                            x2(t)=x2(t-1)+h.*f2(a2,b2,x1,x2,t-1);
                            dphi=(-((X1_star)./(T2.*(x1(t-1).^2))).*f1(b1,x1,x2,x3,t-1))+(b1.*f2(a2,b2,x1,x2,t-1));
                            phi=-((x1(t-1)-X1_star)./(T2.*x1(t-1)))+b1.*x2(t-1);
                            psi1=x3(t-1)-phi;
                            U=((-(T1).^-1).*psi1)+dphi;
                            x3(t)=x3(t-1)+h.*R.*U;
                                if (x1(t)+E>=X1_star)&&(x1(t)-E<=X1_star)
                                %if round(x1(t))==X1_star
                                   solution_found=true;
                                   break;
                                end
                                if(isnan(x1(t)))||(isnan(x2(t)))||(isnan(x3(t)))
                                    NaN_found=true;
                                end
                                if x1(t)-E<=0
                                %if(x1(t)<0)
                                    negativeX1_found=true;
                                    break;
                                %else
                                    %disp("Х1 положительное");
                                end
                                if(x2(t)+E>=0)&&(x2(t)-E<=0)
                                %if(x2(t)<0)
                                    negativeX2_found=true;
                                    break;
                                end
                            else
                                NaN_found=false;
                                negativeX2_found=false;
                                break;
                            end
                        end
                        
                        
                         if (solution_found==true)||(negativeX1_found==true)
                            negativeX1_found=false;
                            negativeX2_found=false;
                            break;                            
                        end
                    end
                    if solution_found==true
                            break
                    end
                end
                if solution_found==true
                            break
                end
            end
           % end
       % end
       if solution_found==true
                            break
        end
    end
    if solution_found==true
                            break
                        else
    end  
end
if solution_found==true
    disp('Решение найдено!');
    fprintf('Начальные условия: зооплактон %d->%d\n', X1_0,X1_star);
    fprintf('x1= %f\n', x1(t));
    fprintf('x2= %f\n', x2(t));
    fprintf('a2= %.2f\n', a2);
    fprintf('b1= %.2f\n', b1);
    fprintf('b2= %.2f\n', b2);
    fprintf('T1= %.2f\n', T1);
    fprintf('T2= %.2f\n', T2);
    fprintf('R= %f\n', R);
    hold on;
    plot(0:n-1,x1,'b',0:n-1, x2, 'r');
    legend("Жертвы","Хищники");
    grid on;
    hold off;
end

