%Space Weather Project
%Author:Sahana Rao
%Purpose: To compare the space weather forecasts of a consensus forecast
%to individual forecasters to find which was more accurate.
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
            MyList(j) = f;
            D=load(filename); %loads file into matrix D
            DD(:,:,j)=D; % 3-D matrix where each of the different forecasters data will be stored                        
            if f>57 % 57 is the baseline
                for i=2:size(D,1)
                    if (DD(i,col,j)-DD(i-1,col,1)==0) %gets rid of persistence
                        %fprintf('doh\n');
                        C(i,j)=NaN;
                    else
                        if col==2
                            C(i,j)=log10(DD(i,col,j))-log10(DD(i,col,1));
                            %if (C(i,j) == 0)
                                %fprintf('woohoo\n');
                            %   C(i,j) = NaN;
                            %end
                            %Compares each predicted variable with the control
                        else
                            C(i,j)=DD(i,col,j)-DD(i,col,1);
                        end
                    end
                end
            end
            j=j+1;
        else
            continue
        end
        %j=j+1;
    end
    j=1;%this is to use the correct forecaster in the plots.
    
    %Now we can add the consensus and create the plots.
    %for f=58:92
    for f=MyList
            for a=1:size(DD,1)
                for b=2:size(DD,2)
                    con(a,col,b)=DD(a,col,b);%collect all forecasters                
                end
                CON(a,1,1)=DD(a,1,1);%set dates of verification in matrix CON
                CON(a,col,1)=nanmean(con(a,col,2:end)); %takes mean 
            end
    end
    
    if col==2
        C(:,(end+1))=log10(CON(:,col,1))-log10(DD(:,col,1));
    else
        C(:,(end+1))=CON(:,col,1)-DD(:,col,1); 
        %calculates error of consensus. Done +1 to add one extra
        %column to C Matrix
    end
    
    for f=MyList
     if f>57      
            create_plots=true; 
     end
            if col==2
                v='Electron Flux';
            elseif col==3
                v='KP';
            elseif col==4
                v='Solar Wind Velocity';
            end
            noc=size(C,2); %done to set the consensus plot to the right column. 
            if (create_plots)
                plot(C(2:101,noc),'g'); %consensus
                hold on %makes the plots of individual vs. consensus
                plot(C(2:101,j),'b'); %individual forecaster
                xL = get(gca,'XLim');
                line(xL,[0 0],'Color','k','LineWidth',2);
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
                   plot(CONP(:,col),'g')
                   hold on
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
%Settings for histograms
    y='Number in Bins';
        if col==2
            t='Hist Electron Flux  ';  
        elseif col==3
            t='Hist KP';
        elseif col==4
            t='Hist Solar Wind Velocity  ';
        end    
    %Forecasters Hist
    histinfo = [ 0 20 9 70];
    Crshp=reshape(C,[],1);    
    hist(Crshp),histinfo(col)
    if col==2
        xlim([-3 3])
    elseif col==3
        xlim([-6 8])
    elseif col==4
        xlim([-400 500])
    end
    hold on
    yL=get(gca,'YLim');
    line([nanmean(Crshp) nanmean(Crshp)],yL,'Color','r')%mean
    hold off
    s=sprintf('  Forecaster Errors with %s of %d','\sigma', nanstd(Crshp)); 
    title([t s])
    xlabel('Distance from Verification');
    ylabel(y)
    pngname4=sprintf('Fhist%d.png',col);
    print('-dpng','-r300',pngname4)
    close all;
    
    %Consensus Hist
    hist(C(2:end,end)),histinfo(col)
    if col==2
        xlim([-3 3])
    elseif col==3
        xlim([-6 8])
    elseif col==4
        xlim([-400 500])
    end
    hold on
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','g');
    yL=get(gca,'YLim');
    line([nanmean(C(2:end,end)) nanmean(C(2:end,end))],yL,'Color','r')
    hold off
    xlabel('Distance from Verification');
    ylabel(y)
    s2=sprintf('Consensus Errors with %s of %d','\sigma',nanstd(C(2:end,end)));
    title([t s2])
    pngname5=sprintf('ConHist%d.png',col);
    print('-dpng','-r300',pngname5)
    close all;
%if col==3
    %keyboard
 fname=sprintf('Errors %d',col);
xlswrite(fname,C);
end
%end
%end