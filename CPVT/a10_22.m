clear;clc

%calcium content in various regions
cajsr=1000;
cai=0.1;
cansr=1000;
cads=20;
%rate of change in cajsr
lamdajsr=.0130/20000; %JSR volume fraction
vtrefill=5/20000; %total JSR refill rate
btjsr=140 * 10^2;
kjsr=638;
%rate of change in cads
lamdads=7.5*10^-08; %dyadic volume fraction
bds=0.1; %dyadic subspace buffering fraction
vtefflux=250/20000; %total rate of ca2+ efflux out of the subspace
eta=2.2;
kplus=12;
kminus=500; 
a=.07;
oo=-.85;
cc=-.92;
time=0;
num_channels=49;
states(1,num_channels)=0; 
states(1,1:10)=1;
Popen=0; %theoretical open probability of the channel
topen=0; %time channel is open
tclosed=0; %time channel is closed
P(1,:)=0; %array of simulated probabilities
TP(1,:)=0; %array of theoretical probabilities
Cads_vals(1,:)=0; %array of cads values
Cajsr_vals(1,:)=0; %array of cajsr values
nopen=0; %number of channels open
nopen_vals(1,:)=0;
nclosed=num_channels-nopen; %number of channels closed
for t=1:10000 %time loop  
   nopen=0;
   nclosed=num_channels-nopen;
    phi=2.3*(10^-4)*cajsr+(2*10^-2);
    for chan=1:num_channels %channel loop
        nopen=nopen+states(1,chan); %sums up all states
        nclosed=num_channels-nopen;
        xoc=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
        xco=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
        %dt=0.1/((nclosed*xco*(phi)*(kplus)*(cads^eta))+(nopen*xoc*kminus)); 
        dt=10^-6;
        r=rand(1,1);%generates a random number
        if states(1,chan)==0
            if r<(nclosed*xco*(phi)*(kplus)*(cads^eta))*dt
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
    bijsr=(1+(btjsr*kjsr)/(kjsr+cajsr)^2)^-1;
    vryr=5.75*10^(-5);
    jiryr=nopen*vryr*(cajsr-cads);
    jirefill=vtrefill*(cansr-cajsr);
    cajsr=cajsr+dt*((bijsr/lamdajsr)*(jirefill-jiryr));
    jiefflux=(vtefflux)*(cads-cai);
    cads=cads+dt*((bds/lamdads)*(jiryr-jiefflux));

    nclosed=num_channels-nopen;
    nopen_vals(1,t)=nopen;
 
Cads_vals(1,t)=cads;
Cajsr_vals(1,t)=cajsr;
P(1,t)=nopen/num_channels; %creates an array of the open probs
tclosed=1/(nclosed*xco*(phi)*(kplus)*(cads^eta)); %calculates the theoretical probability
topen=1/(nopen*xoc*kminus);
%Popen=topen/(topen+tclosed);
%TP(1,t)=Popen;
%topen=0;
end
display(P)
display(TP);
hold on
plot(Cads_vals,TP,'b')
plot(Cads_vals,P,'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
xlabel('Ca2+ content');
ylabel('Open Probability');

