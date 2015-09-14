%Space Weather Project
%Author:Sahana Rao
%Purpose: To compare the space weather forecasts and detect the forecast
%that was the most accurate.
clear; clc
create_plots=true;
consensus_plots=false;
for col=2:4
    for f=57:92                 %number of forecasts(57 is the control)
        filename=sprintf('Files/%d.dat',f);     % puts the data into a matrix
        if exist(filename)
            D=load(filename);
            DD(:,:,f-56)=D; % 3-D matrix where each of the different forecasters data will be stored                        
            if f>58 % 57 is the baseline
                for i=2:size(D,1)
                    if DD(i,col,f-57)-DD(i-1,col,1)==0 %gets rid of precedence?
                        C(i,f-57)=NaN;
                    else
                C(i,f-57)=log10(DD(i,col,f-57))-log10(DD(i,col,1));   %Compares each predicted variable with the control
                    end
                end
        if f==92
            for a=1:101
                for b=2:36
                    if DD(a,1,b)-DD(a,1,1)==0
                        n(a,col,b)=DD(a,col,b);%collect all forecasters who forecasted same days as verificatio               
                    end
                end
                N(a,1,1)=DD(a,1,1);%set dates of verification in matrix N
                N(a,col,1)=nanmean(n(a,col,2:36)); %takes mean 
            end
            C(:,36)=log10(N(:,col,1))-log10(DD(:,col,1));
            consensus_plots=true;      
        end
                if col==2
                    v='Electron Flux';
                elseif col==3
                    v='KP';
                elseif col==4
                    v='Solar Wind Velocity';
                end
                if (create_plots)
                    if (consensus_plots)
                        hold on
                        plot(C(:,36),'g');
                        plot(C(:,f-57),'b');
                        hold off
                        name=sprintf('Forecaster %d error(blue) and consensus(green)  ',f);
                        title([name v])
                        grid on                        
                        xlabel('Days')
                        ylabel('Error')
                        pngname=sprintf('%d-%d consensus.png',f,col);
                        print('-dpng','-r300',pngname)
                    end
                    plot(C(:,f-57));
                    name=sprintf('Forecaster %d error  ',f);
                    title([name v])
                    grid on
                    xlabel('Days')
                    ylabel('Error')
                    pngname=sprintf('%d-%d.png',f,col);
                    print('-dpng','-r300',pngname)
                    close all;
                end
            end
        end
    end
end
    for m=2:size(C,2)
       I = find(isnan(C(:,m)) == 0);
        a=C(I,m);
        R(m,1)=mean(a);
        R(m,2)=std(a);
        R(m,3)=max(a);
        R(m,4)=min(a);
        R(m,5)=length(I);
    end
    
    num=max(R(:,5))/2;
    R_r=[];
    
    for siz=1:size(R,1)
        if(~length(find(R(siz,:)== 0))>=1)
            R_r=[R_r; R(siz,:)];
        end
    end
    y='Number in Bins';
        if col==2
            t='Hist Electron Flux';
        elseif col==3
            t='Hist KP';
        elseif col==4
            t='Hist Solar Wind Velocity';
        end
        if size(R_r,2)>0
            hist(R_r(:,col));
            axis([-25 8 0 3])
            string1=sprintf('The mean is %d   The Standard deviation is %d',...
            nanmean(R_r(:,col)),nanstd(R_r(:,col)));
            legend(string1)
            r='Mean, Max, Min, Std.   ';
            title([r t]);
            pngname=sprintf('R_rhist%d.png',col);
            print('-dpng','-r300',pngname)
            hist(R(:,col));
            pngname=sprintf('Rhist%d.png',col);
            string2=sprintf('The mean is %d   The Standard deviation is %d',...
            nanmean(R(:,col)),nanstd(R(:,col)));
            legend(string2)
            r_r='Mean, Max,min, std minus zeros  ';
            title([r_r t]);
            print('-dpng','-r300',pngname)
                %if col==2
                    %for m=1:101
                        %if C(m,col)== 0
                           % C(m,col)=NaN;
                       % end
                    %end 
                    hist(reshape(C,[],1))
                    %hist(log(abs(C((2:end),col))));
                    %string3=sprintf('The mean is %d  The Standard deviation is %d',...
                    %nanmean(log(abs(C((I),col)))),nanstd(log(abs(C((I),col)))));
                    string3=sprintf('The mean is %d The Standard Deviation is %d',...
                    (nanmean(C(:,:))),(nanstd(C(:,:))));
                    %legend(string3);
                    s='Errors  ';
                    title([s t])
                    xlabel('Distance from Verification');
                    ylabel(y)
                    pngname=sprintf('Chist%d.png',col);
                    print('-dpng','-r300',pngname)
                %elseif col=3 
                    %hist(C(:,col));
                    %string4=sprintf('The mean is %d The Standard deviation is %d',...
                       % nanmean(C(:,col)),nanstd(C(:,col)));
                    %legend(string4)
                    %xlabel('Distance from Verification');
                    %ylabel(y)
                    %n='Errors   ';
                    %title([n t])
                    %pngname=sprintf('Chist%d.png',col);
                    %print('-dpng','-r300',pngname)
                %end
        end