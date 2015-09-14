%Single channel with increasing Ca2+ i
clear;clc        
casr=1000;
phi=2.3*(10^-4)*casr+(2*10^-2);
for i=1:2 %1 is normal, 2 is mutated
    ca_limit=100;
    eta=2.2;
    kplus=12;
    kminus=500;
    time=0;
    state=0; %starts off at closed
    Popen=0; %theoretical open probability of the channel
    topen=0; %time channel is open
    tclosed=0; %time channel is closed
    P(1,ca_limit,i)=0; %array of simulated probabilities
    TP(1,ca_limit,i)=0; %array of theoretical probabilities
    for ca=1:ca_limit %calcium content (initial value)
        dt=0.1/(phi*kplus*ca^eta +kminus);
        for t=1:100000 %time loop
            r=rand(1,1);%generates a random number
            if state==0
                if r<((phi)*(kplus)*(ca^eta))*dt
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
        P(1,ca,i)=topen/time; %creates an array of the open probs
        tclosed=1/(phi*kplus*ca^eta); %calculates the theoretical probability
        topen=1/kminus;
        Popen=topen/(topen+tclosed);
        TP(1,ca,i)=Popen;
        topen=0;
        time=0;
    end
    display(P)
    %display(TP);
    CA(1,ca_limit,1)=0; %creates an array of the increasing calcium values
    for x=1:ca_limit
        CA(1,x,1)=x;
    end
   phi=4.3*(10^-3)*casr+(2*10^-2);
end
hold on
    plot(CA,P(:,:,1),'b') %plots CA on the x axis, and P on the y axis.
    plot(CA,P(:,:,2),'r')
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ i on a single RyR channel');
xlabel('Ca2+ i content');
ylabel('Simulated Open Probability of RyR Channel');
pngname=sprintf('SingChan_Cai_Sim.png');
print('-dpng','-r300',pngname)
close all;
hold on
    plot(CA,TP(:,:,1),'b')
    plot(CA,TP(:,:,2),'r')
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ i on a single RyR channel');
xlabel('Ca2+ i content');
ylabel('Theoretical Open Probability of RyR Channel');
pngname2=sprintf('SingChan_Cai_Theo.png');
print('-dpng','-r300',pngname2)



