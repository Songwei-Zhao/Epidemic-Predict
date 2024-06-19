function [I]=predict(p,X,time)
%     clear,clc;
    N = p(1,3);%���˿�
    S(1) =N-p(1,1);   %�׸���
    E(1) = 0;   %��¶��
    I(1) = p(1,1);   %��Ⱦ��
    Q(1) = 0;   %������
    R(1) = p(1,2);   %�ָ���
    t=40;
   %��һ������Ϊ��ʱʱ���û�а�����д��һ����Ҫ�ֶ��ģ����ǿ��Գ���������ǿ���
   %��һ�𣬾��ǽ��㷨�õ��Ĳ�����Ϊ�ⲿ�ֵ����룬��beta��lamda��gamma��theta��alpha
    beta=X(1);
    lamda=X(2);
    gamma=X(3);
    theta=X(4);
    %delta=9.3615e-01;
    alpha=X(5);
    c=1;
    for i=1:(time+10)
        
        S(i+1) = S(i)-beta*(I(i)+E(i))*S(i)/N-c*alpha* S(i);     %beta��һ���������ü����˵ò� alpha*                      
        
        E(i+1) = E(i)+beta*(I(i)+E(i))*S(i)/N-lamda*E(i);
        
        I(i+1) = I(i)+lamda*E(i)-gamma*I(i);
        
        Q(i+1) = Q(i)+gamma*I(i)-theta*Q(i);
		
		H(i+1) = c*alpha*S(i);
        
        R(i+1) = R(i)+theta*Q(i);
        
%         D(i+1) = D(i)+delta*Q(i);
        %���߱仯������ǿ�ȼ�ǿ�����Կ��ǻ�һЩ���Ʒ���
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
    