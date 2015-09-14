clear;clc
ca_limit=100;
num_channels=50;
eta=2.2;
kplus=12;
kminus=500;
%cai=90;
%cajsr=1;
%cansr=1;
%cads=90;
casr=1000;
%lamdajsr=.0130;
%lamdads=1.55*10^-04;
%lamdansr=0.0458;
%piryrnj=0;
%bds=0.1;
%bnsr=1;
%Ap=150;
%kdi=0.91;
%kdsr=2.24;
%ki=(cai/(1*10^-3 *kdi))^2;
%ksr=(cansr/(1*10^-3*kdsr))^2;
%dcycle=0.104217+17.923*ksr+ki(1.75583*10^6+7.61673*10^6*ksr)+ki^2*(6.08463*10^11+4.50544*10^11*ksr);
%vcycle=(3.24873*10^12*(ki^2)+(ki*(9.17846*10^6-(11478.2*ksr)))-(0.329904*ksr))/dcycle;
%jserca=2*vcycle*Ap;
%N=1; %number of CRU's( eventually should be 20000)
time=0;
a=.07;
oo=-.85;
cc=-.92;
state=0; %starts off at closed
Popen=0; %theoretical open probability of the channel
nopen=1; %number of channels open
nclosed=num_channels-nopen; %number of channels closed
topen=0; %time channel is open
tclosed=0; %time channel is closed
P(ca_limit,num_channels)=0; %array of simulated probabilities for all channels
TP(ca_limit,num_channels)=0; %array of theoretical probabilities for all channels
for ca=1:ca_limit %calcium content (initial value)
    phi=2.3*(10^-4)*casr+(2*10^-2);
    for chan=1:num_channels %channel loop
        for t=1:1000 %time loop
            xco=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
            xoc=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
            dt=0.1/((nclosed*xco*(phi)*(kplus)*(ca^eta))+(nopen*xoc*kminus)); 
            r=rand(1,1);%generates a random number
            if state==0
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=1;  %change to open
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                end
                %display(state);
            elseif state==1
                if r<(nopen*xoc*kminus)*dt
                    state=0;  %change to closed
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
                %display(state);
            end
            topen=topen+state*dt; %sums up all states
            time=time+dt;
        end  
        P(ca,chan)=topen/time; %creates an array of the open probs
        tclosed=1/(nclosed*xco*(phi)*(kplus)*(ca^eta)); %calculates the theoretical probability
        topen=1/(nopen*xoc*kminus);
        Popen=topen/(topen+tclosed);
        TP(ca,chan)=Popen;
        topen=0;
        time=0;
        state=1;
    end
    %btjsr=140 * 10^2;
    %kjsr=638;
    %bijsr=(1+((btjsr*kjsr)/(kjsr+cajsr^2)));
    %vryr=4.9194*exp(-5);
    %vryrnj=2.41;
    %jiryr=nopen*vryr*(cajsr-cads);
    %vtrefill=5;
    %jirefill=0;
    %jryrnj=piryrnj*vryrnj*(cansr-cai);
    %for i=1:N
     %   jirefill=jirefill+((vtrefill/N)*(cansr-cajsr));
    %end
   % jtrefill=0;
    %for ii=1:N
     %   jtrefill=jtrefill+jirefill;
    %end
   % cajsr=cajsr+dt*((bijsr/lamdajsr)*(jirefill-jiryr));
    %cads=cads+dt((bds/lamdads)*(jiryr*
   % cansr=cansr+dt*((bnsr/lamdansr)*(jserca-jtrefill-jryrnj));
    
end
display(P)
%display(TP);
CA(1,ca_limit)=0; %creates an array of the increasing calcium values
for x=1:ca_limit
    CA(1,x)=x;
end

hold on
    plot(CA,TP,'b')
    %plot(CA,P,'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
xlabel('Ca2+ content');
ylabel('Open Probability');


