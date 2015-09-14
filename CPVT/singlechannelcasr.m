%Single Channel Casr Model
clear;clc        
for i=1:2 
    ca_limit=2000;
    eta=2.2;
    kplus=12;
    kminus=500;
    time=0;
    cai=8;
    state=0; %starts off at closed
    Popen=0; %theoretical open probability of the channel
    topen=0; %time channel is open
    tclosed=0; %time channel is closed
    P(1,ca_limit,i)=0; %array of simulated probabilities
    TP(1,ca_limit,i)=0; %array of theoretical probabilities
    for casr=1:ca_limit %calcium content (initial value)
        if i==1
            phi=2.3*(10^-4)*casr+(2*10^-2);
        elseif i==2
            phi=4.3*(10^-3)*casr+(2*10^-2);   
        end
        dt=0.1/(phi*kplus*cai^eta +kminus);
        for t=1:10000
             %time loop
            r=rand(1,1);%generates a random number
            if state==0
                if r<((phi)*(kplus)*(cai^eta))*dt
                state=1; %change to open
                end
                %display(state);
            elseif state==1
                if r<kminus*dt
                    state=0; %change to closed
                end
                %display(state);
            end
            topen=topen+state*dt; %sums up all states
            time=time+dt;
        end    
        P(1,casr,i)=topen/time; %creates an array of the open probs
        tclosed=1/(phi*kplus*cai^eta); %calculates the theoretical probability
        topen=1/kminus;
        Popen=topen/(topen+tclosed);
        TP(1,casr,i)=Popen;
        topen=0;
        time=0;
    end
    display(P)
    %display(TP);
    CA(1,ca_limit,1)=0; %creates an array of the increasing calcium values
    for x=1:ca_limit
        CA(1,x,1)=x;
    end
end
hold on
    plot(CA,P(:,:,1),'b')
    plot(CA,P(:,:,2),'r')
hold off
grid on
title('Effect of increasing Ca2+ sr on a single RyR channel');
legend('Normal','Mutated');
xlabel('Ca2+ sr content');
ylabel('Simulated Open Probability'); 
pngname=sprintf('SingChan_Casr_Sim.png');
print('-dpng','-r300',pngname)
close all;
hold on
    plot(CA,TP(:,:,1),'b')
    plot(CA,TP(:,:,2),'r')
hold off
grid on
title('Effect of increasing Ca2+ sr on a single RyR channel');
legend('Normal','Mutated');
xlabel('Ca2+ sr content');
ylabel('Theoretical Open Probability'); 
pngname2=sprintf('SingChan_Casr_Theo.png');
print('-dpng','-r300',pngname2)
