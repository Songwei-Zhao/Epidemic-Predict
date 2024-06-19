clear  all
clc
close all

tic
Flod=10; 
SearchAgents_no=60; 

Nc=100;                       % Number of chemotactic steps 50
Ns=4;                        % Limits the length of a swim
Nre=5;                       % The number of reproduction steps
Ned=2;                       % The number of elimination-dispersal events
Ped=0.25;                    % The probabilty that each bacteria will be eliminated/dispersed

Max_iteration=10000;

dimSize=5;   
%%%%%%%%%%%%%%%%%%%%%%%%%%
name='Chang Chun';     %chang chun1
p=xlsread(name);
time=size(p,1)-1;
num=size(p,1);

 
algrithmName={'WOA'};

 
%%%%%%%%%%%%%%%%%%%%%%%%%%
ee={'BFO','PSOBFO','CCGBFO','BFOChaosCsizeCLSGao','BFOChuChaos','BFOChaosGbest','BFOChaosCsize','BFOChuGBestChaos','BFOChuCsizeChaos','BFOGBestCsizeChaos','BFOChuGBestCsizeChaos'};


fhd=str2func('cec17_func');

startLineNum=2;% the startLineNum of overall sheet to write data
algrithmNum=size(algrithmName,2);

nLines = algrithmNum;
basic_linestyles = cellstr(char('-',':','-.','--'));
basic_Markers    = cellstr(char('o','x','+','*','s','d','v','^','<','>','p','h','.'));


MarkerEdgeColors = hsv(nLines);
linestyles       = repmat(basic_linestyles,ceil(nLines/numel(basic_linestyles)),1);
Markers          = repmat(basic_Markers,ceil(nLines/numel(basic_Markers)),1);
 
 Function_name_all={'covid'};

for funcNum=1:size(Function_name_all,2)
    dim = 30;
    Function_name=Function_name_all{funcNum};
    [lb,ub,dim,fhd]=Get_covid(Function_name,dim);
    display(['----------------',Function_name,'--------------------']); 
    Function_name=['F',num2str(funcNum)];
    %% benchmark function
    cg_curves=zeros(algrithmNum,Flod,Max_iteration);
    
     positions=zeros(algrithmNum,Flod,5);
     I_values = cell(10, 1);  
    %     for cflod=1:Flod
    parfor cflod=1:Flod
        %     for cflod=1:Flod
        display(['flod',num2str(cflod)]);
        for cnum=1:algrithmNum
            alg_fhd=str2func(algrithmName{cnum});
%             fhd = str2func(['cec17_func_', num2str(funcNum)]);
            
            if(any(strcmp(algrithmName{cnum},ee))==1)
                [cg_curve]=alg_fhd(SearchAgents_no,Nc,Ns,Nre,Ned,Ped,lb,ub,dimSize,fhd,Max_iteration,funcNum);
                
            else
                %   [cg_curve]=alg_fhd(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
                [position,cg_curve]=alg_fhd(p,time,SearchAgents_no,Max_iteration,lb,ub,dimSize,fhd);
%                  format shortE,position
            end
            if strcmp(algrithmName{cnum}, 'LMWOA')
                I = predict(p,position,time);
%                 a=xlsread(name);
%                 num=size(p,1);
                if I(num-2)>p(num-2,1)
                    result2=(2*p(num-2,1)-I(num-2))/p(num-2,1);
                else
                    result2=I(num-2)/p(num-2,1);
                end
                if I(num-1)>p(num-1,1)
                    result1=(2*p(num-1,1)-I(num-1))/p(num-1,1);
                else
                    result1=I(num-1)/p(num-1,1);
                end
                if I(num)>p(num,1)
                    result=(2*p(num,1)-I(num))/p(num,1);
                else
                    result=I(num)/p(num,1);
                end
%                display(['The accuracy of the last three days£º',num2str(result2),',',num2str(result1),',',num2str(result)]);
               allResults2(cnum, cflod) = result2;
               allResults1(cnum, cflod) = result1;
               allResults(cnum, cflod) = result;
               I_values{cflod} = I;
            end
            cg_curves(cnum,cflod,:)=cg_curve;
            positions(cnum,cflod,:)=position;
        end
    end
%     for i = 1:10
    [bestResults, bestFolds] = max(allResults(:));
    formattedResult2 = sprintf('%.2f%%', allResults2(:,bestFolds) * 100);
    formattedResult1 = sprintf('%.2f%%', allResults1(:,bestFolds) * 100);
    formattedResult = sprintf('%.2f%%', bestResults * 100);
    
    disp(['The best predictions for the last three days£º', formattedResult2, ',',formattedResult1, ',',formattedResult]);

    I_predict = I_values{bestFolds}(1:num+7);
    pw=p(1:num,1);
    plot(1:num+7,I_predict,'c','LineWidth', 2);
    hold on;
    plot(1:num,pw,'r--','LineWidth', 2);

    xlabel('Existing infected individuals');  
    ylabel('Date');  
    a=findobj(gcf);
    allaxes=findall(a,'Type','axes');
    set(allaxes,'FontName','Times','LineWidth',1,'FontSize',14,'FontWeight','bold');
    saveas(gcf, 'my_plot.png');
end

toc
