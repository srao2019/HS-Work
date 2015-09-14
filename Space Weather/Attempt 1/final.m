%Space Weather Project
%Author:Sahana Rao
%Purpose: To compare the space weather forecasts and detect the forecast
%that was the most accurate.
clear; clc
create_plots=false;
for col=2:4
    for f=92:114                 %number of forecasts(92 is the control)
        filename=sprintf('files/%d.dat',f);     % puts the data into a matrix
        if exist(filename)
            D=load(filename);
            DD(:,:,f-91)=D; % 3-D matrix where each of the different forecasters data will be stored
            if f>92 % 92 is the baseline
                for i=2:size(D,1)
                    if DD(i,col,f-91)-DD(i-1,col,1)==0
                        C(i,f-91)=NaN;
                    else
                C(i,f-91)=DD(i,col,f-91)-DD(i,col,1);   %Compares each predicted solar wind velocity with the control
                    end
                end
                if (create_plots)
                    plot(C(:,f-91))
                    name=sprintf('Forecaster %d error',f);
                    title(name)
                    grid on
                    pngname=sprintf('%d-%d.png',f,col);
                    print('-dpng','-r300',pngname)
                    close all;
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
    
    n=max(R(:,5))/2;
    R_r=[];
    
    for n=1:size(R,1)
        if(~length(find(R(n,:)== 0))>=1)
            R_r=[R_r; R(n,:)];
        end
    end
    
    if size(R_r,2)>0
        hist(R_r(:,col));
        axis([-25 8 0 3])
        pngname=sprintf('R_rhist%d.png',col);
        print('-dpng','-r300',pngname)
        hist(R(:,col));
        pngname=sprintf('Rhist%d.png',col);
        print('-dpng','-r300',pngname)
            if col==2
               for m=1:99
                   if C(m,col)== 0
                       C(m,col)=NaN;
                   end
               end 
            hist(log(abs(C((2:end),col))));
            string1=sprintf('The mean is %d  The Standard deviation is %d',...
            nanmean(log(abs(C((I),col)))),nanstd(log(abs(C((I),col)))));
            legend(string1)
            pngname=sprintf('Chist%d.png',col);
            print('-dpng','-r300',pngname)
            else 
            hist(C(:,col));
            pngname=sprintf('Chist%d.png',col);
            print('-dpng','-r300',pngname)
            end
    end 
end