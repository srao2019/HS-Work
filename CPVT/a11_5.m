clear;clc
N=1; %Number of release sites
%calcium content in various regions
cajsr=1000;
cai=0.1;
cansr=1000;
cads=20;
cao=1.8;
%rate of change in cajsr
lamdajsr=.0130/20000; %JSR volume fraction
vtrefill=5/20000; %total JSR refill rate
btjsr=140 * 10^2;
kjsr=638;
%rate of change in cads
lamdads=7.5*10^-08; %dyadic volume fraction
bds=0.1; %dyadic subspace buffering fraction
vtefflux=250/20000; %total rate of ca2+ efflux out of the subspace
%rate of change in cansr
jirefill=0;
jiefflux=0;
jtrefill=0;
jtefflux=0;
lamdansr=0.0458/20000;
bnsr=1;
Ap=150; %concentration of SERCA molecules
kdi=0.91; %SERCA cai sensitivity
kdsr=2.24; %SERCA cads 
ki=(cai/(1*10^-3 *kdi))^2;
ksr=(cansr/(1*10^-3*kdsr))^2;
kmyo=0.96; %half saturation constant for myopalasmic ca2+ buffer
dcycle=0.104217+17.923*ksr+ki*(1.75583*10^6+7.61673*10^6*ksr)+ki^2*(6.08463*10^11+4.50544*10^11*ksr);
vcycle=(3.24873*10^12*(ki^2)+(ki*(9.17846*10^6-(11478.2*ksr)))-(0.329904*ksr))/dcycle;
jserca=2*vcycle*Ap;
%rate of change of cai
btmyo=143/20000;
piryrnj=0; %fraction of open "rogue" RYR
%variables for ncx exchanger
nao=140; %extracellular Na+ content
nai=10.2; %intracellular Na+ content
Am=1.5340 *10^-4; %capacitative area of cell membrane 
V=-85; %membrane voltage
vmyo=25.84; %myoplasmic volume
F=9.6485*10^4; %faraday constant
T=310; %temperature in kelvin
R=8314; % ideal gas content (joules)
etancx=0.35; %NCX voltage dependence coefficient
Kncxca=1380; %ca2+ half saturation constant for NCX
Kncxna=87500; %na+ half saturation constant for NCX
ksatncx=0.1; % NCX exchange saturation factor
Incx=1000; %maximal NCX current
incx=Incx*(nai^3*cao*exp(etancx*F*V/(R*T))-nai^3*cai*exp(etancx*F*V/(R*T)));
jncx=(-Am*incx)/(F*vmyo); %ncx exchanger
%Variables for PMCA
ipmca=0.75; %Maximal PMCA current
kpmca=0.5; %Calcium half saturation for PMCA
Ipmca=0;
jpmca=0;
%Variables for background calcium leak
gbca=7.36351*10^-4; %maximal background calcium conductance
ibca=0;
eca=0;
jbca=0;
%variables to calculate channel states
eta=2.2;
kplus=12;
kminus=500; 
a=.07;
oo=-.85;
cc=-.92;
time=0;
num_channels=49;
states(1,num_channels)=0; 
states(1,1:10)=1; %sets it to start out with 10 channels open
Popen=0; %theoretical open probability of the channel
topen=0; %time channel is open
tclosed=0; %time channel is closed
%Arrays of probabilities
P(1,:)=0; %array of simulated probabilities
TP(1,:)=0; %array of theoretical probabilities
%Arrays for calcium and channel values
Cads_vals(1,:)=0; %array of cads values
Cajsr_vals(1,:)=0; %array of cajsr values
Cansr_vals(1,:)=0;
Cai_vals(1,:)=0;
nopen=0; %number of channels open
nopen_vals(1,:)=0;
nclosed=num_channels-nopen; %number of channels closed
for t=1:10000 %time loop  
   nopen=0;
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
vryrnj=2.41;
jiryr=nopen*vryr*(cajsr-cads);
for i=1:N
 jirefill=jirefill+((vtrefill/N)*(cansr-cajsr));
end
for i=1:N
 jtrefill=jtrefill+jirefill;
end
for i=1:N
    jiefflux=(vtefflux/N)*(cads-cai);
end
for i=1:N
    jtefflux=jtefflux+jiefflux;
end
Ipmca=ipmca*(cai^2/(kpmca^2+cai^2));
jpmca=(-Am*Ipmca)/(2*F*vmyo); %ATPase flux of the PMCA
eca=((R*T)/(2*F))*log(cao/cai);
ibca=gbca*(V-eca);
jbca=(-Am*ibca)/(2*F*vmyo);
Bmyo=(1+((btmyo*kmyo)/(kmyo+cai)^2))^-1;
piryrnj=phi*kplus*(1-piryrnj)-(kminus*piryrnj);
jryrnj=piryrnj*vryrnj*(cansr-cai);
cads=cads+dt*((bds/lamdads)*(jiryr-jiefflux));
cajsr=cajsr+dt*((bijsr/lamdajsr)*(jirefill-jiryr));
cansr=cansr+dt*((bnsr/lamdansr)*(jserca-jtrefill-jryrnj));
cai=Bmyo*(jtefflux-jncx-jserca+jbca-jpmca+jryrnj);

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
%display(TP);
hold on
plot(Cads_vals,TP,'b')
plot(Cads_vals,P,'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
xlabel('Ca2+ content');
ylabel('Open Probability');

