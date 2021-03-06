clear;clc
phi=2.3*(10^-4)*casr+(2*10^-2);
ca_limit=100;
eta=2.2;
kplus=12;
kminus=500;
casr=1000;
a=.07;
oo=-.85;
cc=-.92;
time=0;
num_channels=49;
states(1,num_channels)=0; 
Popen=0; %theoretical open probability of the channel
topen=0; %time channel is open
tclosed=0; %time channel is closed
P(1,ca_limit)=0; %array of simulated probabilities
TP(1,ca_limit)=0; %array of theoretical probabilities
for ca=1:ca_limit %calcium content (initial value)
    nopen=0; %number of channels open
    nclosed=num_channels-nopen; %number of channels closed
    
    for chan=1:num_channels %channel loop    
        for t=1:1000 %time loop  
        xoc=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
        xco=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
        dt=0.1/((nclosed*xco*(phi)*(kplus)*(ca^eta))+(nopen*xoc*kminus)); 
        r=rand(1,1);%generates a random number
        if states(1,chan)==0
            if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
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
    P(1,ca)=nopen/num_channels; %creates an array of the open probs
    tclosed=1/(nclosed*xco*(phi)*(kplus)*(ca^eta)); %calculates the theoretical probability
    topen=1/(nopen*xoc*kminus);
    Popen=topen/(topen+tclosed);
    TP(1,ca)=Popen;
    topen=0;
end
display(P)
display(TP);
CA(1,ca_limit)=0; %creates an array of the increasing calcium values
for x=1:ca_limit
    CA(1,x)=x;
end
hold on
    plot(CA,TP,'b')
    plot(CA,P,'r') %plots CA on the x axis, and P on the y axis. 

hold off
grid on
xlabel('Ca2+ Content');
ylabel('Open Probability');


