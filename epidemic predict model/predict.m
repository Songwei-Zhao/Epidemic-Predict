function [I]=predict(p,X,time)
%     clear,clc;
    N = p(1,3);%总人口
    S(1) =N-p(1,1);   %易感者
    E(1) = 0;   %暴露者
    I(1) = p(1,1);   %感染者
    Q(1) = 0;   %隔离者
    R(1) = p(1,2);   %恢复者
    t=40;
   %这一部分因为当时时间紧没有把两块写到一起，需要手动改，你们可以尝试与拟合那块结合
   %到一起，就是将算法得到的参数作为这部分的输入，即beta，lamda，gamma，theta，alpha
    beta=X(1);
    lamda=X(2);
    gamma=X(3);
    theta=X(4);
    %delta=9.3615e-01;
    alpha=X(5);
    c=1;
    for i=1:(time+10)
        
        S(i+1) = S(i)-beta*(I(i)+E(i))*S(i)/N-c*alpha* S(i);     %beta：一个病人能让几个人得病 alpha*                      
        
        E(i+1) = E(i)+beta*(I(i)+E(i))*S(i)/N-lamda*E(i);
        
        I(i+1) = I(i)+lamda*E(i)-gamma*I(i);
        
        Q(i+1) = Q(i)+gamma*I(i)-theta*Q(i);
		
		H(i+1) = c*alpha*S(i);
        
        R(i+1) = R(i)+theta*Q(i);
        
%         D(i+1) = D(i)+delta*Q(i);
        %政策变化，防控强度加强，可以考虑换一些控制方法
        if I(i+1)>1&&I(i+1)<100
            c=2;
        elseif I(i+1)>=100&&I(i+1)<50000
            c=8;
        elseif I(i+1)>=10000
            c=10;
        end
    end
%     a=xlsread('chang chun1');   
%     p=a(1:28,1);
%     plot(1:t,I,'c');
%     hold on;
%     plot(1:28,p,'r');
end
    