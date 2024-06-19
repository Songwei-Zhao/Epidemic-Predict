function [lb,ub,dim,fobj] = Get_covid(F,DimValue)
if nargin == 1
    DimValue = 10;
end
switch F
    case 'covid'
        fobj=@covid;
        lb=[0,0,0,0,0];
        ub=[1,1,2,2,1];
        dim=5;
end
end

function fitness = covid(p,t,X)
    N = p(1,3);%总人口
    S(1) =N-p(1,1);   %易感者
    E(1) = p(2,3);   %暴露者
    I(1) = p(1,1);   %感染者
    Q(1) = 0;   %隔离者
    R(1) = p(1,2);   %恢复者
      c = 1;
    for i=1:t

        S(i+1) = S(i)-X(1)*(I(i)+E(i))*S(i)/N-c*X(5)*S(i);    %  X(1) beta：患病率
        
        E(i+1) = E(i)+X(1)*(I(i)+E(i))*S(i)/N-X(2)*E(i); %X(2) lamda:暴露转感染概率
        
        I(i+1) = I(i)+X(2)*E(i)-X(3)*I(i);      %X(3)  gamma：隔离率
        
        Q(i+1) = Q(i)+X(3)*I(i)-X(4)*Q(i);

		H(i+1) = c*X(5)*S(i);
        
        R(i+1) = R(i)+X(4)*Q(i);     %X(4)  theta：治疗率
        
        %管控强度，可以调研改设
        if I(i+1)>1&&I(i+1)<100
            c=2;
        elseif I(i+1)>=100&&I(i+1)<10000
            c=8;
        elseif I(i+1)>=10000
            c=10;
        end   
    end


%     fitness=sum_I+abs(R(t+1)-2952);   %考虑感染人数和恢复者总数
  fitness=abs(I(floor((t+1)/4))-p(floor((t+1)/4),1))+abs(I(floor(2*(t+1)/4))-p(floor(2*(t+1)/4),1))+abs(I(floor(3*(t+1)/4))-p(floor(3*(t+1)/4),1))+abs(I(t+1)-p(t+1,1))+abs(R(t+1)-p(end,2));

end