clear;clc
num_channels=50;
states(1,num_channels)=0; %starts off at closed
time=1000;
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
P(1,time,2)=0; %array of simulated probabilities 
TP(1,time,2)=0; %array of theoretical probabilities
%variables to represent calcium in different regions (initial value)
cajsr=1; %calcium in junctional SR
cansr=1; %calcium in network SR
cads=90; %calcium in dyadic subspace
cai=90; %calcium in myoplasmic subspace
cao=1.8; %extracellular calcium content
%variables to control rate of change of calcium content in various regions
lamdajsr=.0130; %JSR volume fraction
lamdads=1.55*10^-04; %dyadic volume fraction
lamdansr=0.0458; %NSR volume fraction
vtefflux=250; %total rate of ca2+ efflux out of the subspace
vtrefill=5; %total JSR refill rate
jirefill=0;
jtrefill=0;
jiefflux=0;
jtefflux=0;
piryrnj=0; %fraction of open "rogue" RYR
bds=0.1; %dyadic subspace buffering fraction
bnsr=1; %NSR buffering fraction
btmyo=143; %total myoplasmic ca2+ buffer concentration
Ap=150; %concentration of SERCA molecules
kdi=0.91; %SERCA cai sensitivity
kdsr=2.24; %SERCA cads 
ki=(cai/(1*10^-3 *kdi))^2;
ksr=(cansr/(1*10^-3*kdsr))^2;
kmyo=0.96; %half saturation constant for myopalasmic ca2+ buffer
dcycle=0.104217+17.923*ksr+ki*(1.75583*10^6+7.61673*10^6*ksr)+ki^2*(6.08463*10^11+4.50544*10^11*ksr);
vcycle=(3.24873*10^12*(ki^2)+(ki*(9.17846*10^6-(11478.2*ksr)))-(0.329904*ksr))/dcycle;
jserca=2*vcycle*Ap;
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
N=1; %number of CRU's(eventually should be 20000)
for i=1:2
nopen=0; %number of channels open
states(1,num_channels)=0; %starts off at closed
nclosed=num_channels-nopen; %number of channels closed
if i==1
    phi=2.3*(10^-4)*(cansr+cajsr)+(2*10^-2);
elseif i==2
    phi=4.3*(10^-3)*(cansr+cajsr)+(2*10^-2);
end
for chan=1:num_channels %channel loop    
    for t=1:time %time loop
    xco=exp(-a*.5*(nclosed*cc-(nopen-1)*oo));
    xoc=exp(-a*.5*(nopen*oo-(nclosed-1)*cc));
    dt=0.1/((nclosed*xco*(phi)*(kplus)*(cai^eta))+(nopen*xoc*kminus)); 
    r=rand(1,1);%generates a random number
    if states(1,chan)==0
        if r<(nclosed*xco*(phi)*(kplus)*(cai^eta))*dt
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
P(1,t,i)=nopen/num_channels; %creates an array of the open probs
tclosed=1/(nclosed*xco*(phi)*(kplus)*(cai^eta)); %calculates the theoretical probability
topen=1/(nopen*xoc*kminus);
Popen=topen/(topen+tclosed);
TP(1,t,i)=Popen;
%change calcium content
btjsr=140 * 10^2;
kjsr=638;
bijsr=(1+((btjsr*kjsr)/(kjsr+cajsr^2)))^-1;
vryr=4.9194*exp(-5);
vryrnj=2.41;
jiryr=nopen*vryr*(cajsr-cads);
jryrnj=piryrnj*vryrnj*(cansr-cai);
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
cajsr=cajsr+dt*((bijsr/lamdajsr)*(jirefill-jiryr));
cads=cads+dt*((bds/lamdads)*(jiryr-jiefflux));
cansr=cansr+dt*((bnsr/lamdansr)*(jserca-jtrefill-jryrnj));
cai=Bmyo*(jtefflux-jncx-jserca+jbca-jpmca+jryrnj);
end
display(P)
display(TP);
TIME(1,time)=0;
for x=1:time
    TIME(1,x)=x;
end
%Graphs simulated probability
hold on
plot(TIME,P(:,:,1),'b');
plot(TIME,P(:,:,2),'r') %plots time on the x axis, and P on the y axis. 
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ on a cardiac cell');
xlabel('Time');
ylabel('Simulated Open Probability');
pngname=sprintf('Cell_Sim.png');
print('-dpng','-r300',pngname)
close all;

% Graphs theoretical probability
hold on
plot(TIME,TP(:,:,1),'b');
plot(TIME,TP(:,:,2),'r') %plots time on the x axis, and P on the y axis. 
hold off
grid on
legend('Normal','Mutated');
title('Effect of increasing Ca2+ on a cardiac cell');
xlabel('Time');
ylabel('Theoretical Open Probability');
pngname2=sprintf('Cell_Theo.png');
print('-dpng','-r300',pngname2)
