%Cluster Casr Model
clear;clc;
cai=8;
ca_limit=2000;
eta=2.2;
kplus=12;
kminus=500;
a=.07;
oo=-.85;
cc=-.92;
num_channels=49;
states(1,num_channels)=0; 
Popen=0; %theoretical open probability of the channel
topen=0; %time channel is open
tclosed=0; %time channel is closed
P(1,ca_limit,2)=0; %array of simulated probabilities
TP(1,ca_limit,2)=0; %array of theoretical probabilities
for i=1:2  
    for casr=1:ca_limit %calcium content (initial value)
    nopen=0; %number of channels open
    nclosed=num_channels-nopen; %number of channels closed
        if i==1
            phi=2.3*(10^-4)*casr+(2*10^-2);
        elseif i==2
            phi=4.3*(10^-3)*casr+(2*10^-2);   
        end
    for chan=1:num_channels %channel loop    
        for t=1:1000 %time loop  
        xoc=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
        xco=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
        dt=0.1/((nclosed*xco*(phi)*(kplus)*(cai^eta))+(nopen*xoc*kminus)); 
        r=rand(1,1);%generates a random number
        if states(1,chan)==0
            if r<(nclosed*xco*(phi)*(kplus)*(cai^eta))*dt
            states(1,chan)=1; %change to open
            end
            %display(state);
        elseif states(1,chan)==1
            if r<(nopen*xoc*kminus)*dt
                states(1,chan)=0; %change to closed
            end
            %display(state);
        end
        end
    nopen=nopen+states(1,chan); %sums up all states
    nclosed=num_channels-nopen;
    end
    P(1,casr,i)=nopen/num_channels; %creates an array of the open probs
    tclosed=1/(nclosed*xco*(phi)*(kplus)*(cai^eta)); %calculates the theoretical probability
    topen=1/(nopen*xoc*kminus);
    Popen=topen/(topen+tclosed);
    TP(1,casr,i)=Popen;
    topen=0;
    end
end
CA(1,ca_limit)=0; %creates an array of the increasing calcium values
    for x=1:ca_limit
    CA(1,x)=x;
    end
%Changes 0s to NaNs
for i=1:2
    for j=1:ca_limit
        if TP(1,j,i)==0
            TP(1,j,i)=NaN;
        end
    end
end
    
display(P)
display(TP);
%Graphs simulated probability
hold on
plot(CA,P(:,:,1),'b');
plot(CA,P(:,:,2),'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ sr on cluster of RyR channels');
xlabel('Ca2+sr Content');
ylabel('Simulated Open Probability');
pngname=sprintf('Cluster_Casr_Sim.png');
print('-dpng','-r300',pngname)
close all;

% Graphs theoretical probability
hold on
plot(CA,TP(:,:,1),'b');
plot(CA,TP(:,:,2),'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ sr on cluster of RyR channels');
xlabel('Ca2+ sr Content');
ylabel('Theoretical Open Probability');
pngname2=sprintf('Cluster_Casr_Theo.png');
print('-dpng','-r300',pngname2)

