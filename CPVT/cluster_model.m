clear;clc
ca_limit=50;
num_channels=50;
states(1,num_channels)=0; %starts off at closed
%variables for channel factor
eta=2.2;
kplus=12;
kminus=500;
a=.07;
oo=-.85;
cc=-.92;
%variables to display probability
Popen=0; %theoretical open probability of the channel
topen=0; 
tclosed=0;
P(1,ca_limit)=0; %array of simulated probabilities 
TP(1,ca_limit)=0; %array of theoretical probabilities
casr=1;
for ca=1:ca_limit %calcium content (initial value)
    index=1;
    nopen=0; %number of channels open
    states(1,num_channels)=0; %starts off at closed
    nclosed=num_channels-nopen; %number of channels closed
    phi=2.3*(10^-4)*casr+(2*10^-2);
    for chan=1:num_channels %channel loop    
        for t=1:1000 %time loop
        xco=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
        xoc=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
        dt=0.1/((nclosed*xco*(phi)*(kplus)*(ca^eta))+(nopen*xoc*kminus)); 
        r=rand(1,1);%generates a random number
        if states(1,chan)==0
            if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                states(1,chan)=1;  %change to open
            end
            %display(state);
        elseif states(1,chan)==1
            if r<(nopen*xoc*kminus)*dt
                states(1,chan)=0;  %change to closed
            end
            %display(state);
        end    
        end
        nopen=nopen+states(1,chan);
        nclosed=num_channels-nopen;
    end
    %calculate probabilities
    nclosed=num_channels-nopen;
    P(1,index)=nopen/num_channels; %creates an array of the open probs
    tclosed=1/(nclosed*xco*(phi)*(kplus)*(ca^eta)); %calculates the theoretical probability
    topen=1/(nopen*xoc*kminus);
    Popen=topen/(topen+tclosed);
    TP(1,index)=Popen;
    index=index+1;
end
display(P)
display(TP);
CA(1,1)=0; %creates an array of the increasing calcium values   
temp=1;
for x=1:ca_limit
    CA(1,temp)=x;
    temp=temp+1;
end

hold on
    plot(CA,TP,'b')
    plot(CA,P,'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
xlabel('Ca2+ content');
ylabel('Open Probability');
