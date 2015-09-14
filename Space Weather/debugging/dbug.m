%Space Weather Project
%Author:Sahana Rao
%Purpose: To compare the space weather forecasts and detect the forecast
%that was the most accurate. Compare a consensus forecast to individual
%forecasters to find which was more accurate.
clear 
create_plots=false;

%First we need to load the data
for col=2:4
    C=[];
    j=1;
    for f=57:92                 %number of forecasts(57 is the control)
        filename=sprintf('Files/%d.dat',f);     % puts the data into a matrix
        if exist(filename)%checks to see if the file exists or not.
            fprintf('GOT IN!!!: %f',f);
            D=load(filename); %loads file into matrix D
            DD(:,:,j)=D; % 3-D matrix where each of the different forecasters data will be stored                        
            if f>57 % 57 is the baseline
                for i=2:size(D,1)
                    if DD(i,col,j)-DD(i-1,col,1)==0 %gets rid of persistence
                        C(i,j)=NaN;
                    else
                        if col==2
                            C(i,j)=log10(DD(i,col,j))-log10(DD(i,col,1));
                            %Compares each predicted variable with the control
                        else
                            C(i,j)=DD(i,col,j)-DD(i,col,1);
                        end
                    end
                end
            end
        else
            continue
        end
        j=j+1; 
    end
    j=2;%this is to use the correct forecaster in the plots.
    
    %Now we can add the consensus and create the plots.
    for f=58:92
            for a=1:size(DD,1)
                for b=2:size(DD,2)
                    con(a,col,b)=DD(a,col,b);%collect all forecasters                
                end
                CON(a,1,1)=DD(a,1,1);%set dates of verification in matrix CON
                CON(a,col,1)=nanmean(con(a,col,2:end)); %takes mean 
            end
            if col==2
                C(:,(end+1))=log10(CON(:,col,1))-log10(DD(:,col,1));
            else
                C(:,(end+1))=CON(:,col,1)-DD(:,col,1);
            end
            %calculates error of consensus. Done +1 to add one extra
            %column to C Matrix
            create_plots=true; 
            if col==2
                v='Electron Flux';
            elseif col==3
                v='KP';
            elseif col==4
                v='Solar Wind Velocity';
            end
            
            noc=size(C,2); %done to set the consensus plot to the right column. 
            if (create_plots)
              if(C(2:101,1:end-1))==NaN
              else
                hold on  %makes the plots of individual vs. consensus
                plot(C(2:101,noc),'g'); %consensus
                plot(C(2:101,j),'b'); %individual forecaster
                line(0,0); %zero line
                hold off
                name=sprintf('Forecaster %d error and consensus for ',f);
                title([name v])
                grid on
                if col==2
                    axis([0 110 -2 2]);
                elseif col==3
                    axis([0 110 -9 9]);
                elseif col==4
                    axis([0 110 -200 200]);
                end               
                xlabel('Days')
                ylabel('Error')
                legend('Consensus', 'Forecaster')
                pngname=sprintf('%d-%d.png',f,col);
                print('-dpng','-r300',pngname)
                close all
               if f==92 
                   CONP(101,4)=0;  %Plots of consensus vs. verification
                   DDV(101,4)=0;
                   CONP(:,col)=CON(:,col,1); %Allows the matrices to be plotted.
                   DDV(:,col)=DD(:,col,1);
                   hold on
                   plot(CONP(:,col),'g')
                   plot(DDV(:,col),'r')
                   hold off
                   grid on
                   xlabel('Days')
                   ylabel('Value')
                   str='Verification and Consensus  ';
                   title([str v])
                   legend('Consensus','Verification')
                   pngname1=sprintf('C and V %d',col);
                   print('-dpng','-r300',pngname1)
                   close all
               end
            end
    j=j+1;%increments the count to use the correct forecaster in the plots. 
    end

        %end
    %end    
    end%I = find(isnan(C(:,1:35)) == 0);
for a=2:101
        St=[];
        %if C(a,b)== -Inf  %gets rid of ungraphable -Inf
            %C(a,b)=NaN;  %NaN's don't get included in graphs. 
        %end
            St(:,:)=C(:,1:end-1);
            Res(a,1)=nanmean(St(a,:));    %Results matrix contains mean,
            Res(a,2)=nanstd(St(a,:));     %standard deviation,
            Res(a,3)=max(St(a,:));        % maximum and minimum
            Res(a,4)=min(St(a,:));        % of the forecasters errors(not including con)
end

%R_r=[];
    
    %for siz=1:size(Res,1)
        %if(~length(find(Res(siz,:)== 0))>=1)
            %R_r=[R_r; Res(siz,:)];
        %end
    %end
    y='Number in Bins';
        if col==2
            t='Hist Electron Flux';
        elseif col==3
            t='Hist KP';
        elseif col==4
            t='Hist Solar Wind Velocity';
        end
%if size(R_r,2)>0
    %hist(R_r(:,:));
    %axis([-25 8 0 3])
    %string1=sprintf('The mean is %d   The Standard deviation is %d',...
    %nanmean(R_r(:,:)),nanstd(R_r(:,:)));
    %legend(string1)
    %r='Mean, Max, Min, Std.   ';
    %title([r t]);
    %pngname2=sprintf('R_rhist%d.png',col);
    %print('-dpng','-r300',pngname2)

    hist(Res(:,:)); %histogram of Results Matrix
    pngname3=sprintf('Rhist%d.png',col);
    string2=sprintf('The mean is %d   The Standard deviation is %d',nanmean(Res(:,:)),nanstd(Res(:,:)));
    legend(string2)
    legend('Mean','Std','Max','Min');
    r='Mean,Std,Max,Min ';
    title([r t]);
    print('-dpng','-r300',pngname3)
    
    %Errors Histogram
    histinfo = [ 0 20 9 70];
    Crshp=reshape(C,[],1);
    hold on
    hist(Crshp),histinfo(col)
    line(0,nanmean(C(2:end,1:end-1)),'r')
    line(0,C(2:end,end),'g')
    hold off
    string3=sprintf('The mean is %d   The Standard Deviation is %d ',(nanmean(C(:,1:end-1))),(nanstd(C(:,1:end-1)))) ;
    legend(string3)
    s='Errors  '; 
    title([s t])
    xlabel('Distance from Verification');
    ylabel(y)
    pngname4=sprintf('Chist%d.png',col);
    print('-dpng','-r300',pngname4)
    close all
%if col==3
    %keyboard
    fname=sprintf('Errors %d',col);
save(fname,'C');
end
%end
