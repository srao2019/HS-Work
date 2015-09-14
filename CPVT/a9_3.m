clear;clc
ca_limit=100;
num_channels=50;
eta=2.2;
kplus=12;
kminus=500;
casr=1000;
time=0;
a=.07;
oo=-.85;
cc=-.92;
state=0; %starts off at closed
Popen=0; %theoretical open probability of the channel
nopen=1; %number of channels open
nclosed=num_channels-nopen; %number of channels closed
topen=0; %time channel is open
P(1,ca_limit)=0; %array of simulated probabilities
TP(1,ca_limit)=0; %array of theoretical probabilities
for ca=1:ca_limit %calcium content (initial value)
    phi=2.3*(10^-4)*casr+(2*10^-2);
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
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=2;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=0;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
                %display(state);
            elseif state==2
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=3;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=1;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==3
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=4;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=2;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==4
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=5;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=4;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==5
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=6;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=4;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==6
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=7;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=5;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==7
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=8;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=6;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==8
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=9;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=7;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==9;
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=10;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=8;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==10
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=11;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=9;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==11
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=12;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=10;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==12
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=13;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=11;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==13
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=14;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=12;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==14
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=15;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=13;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==15
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=16;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=14;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==16
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=17;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=15;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==17
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=18;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=16;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==18
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=19;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=17;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==19
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=20;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=18;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==20
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=21;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=19;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==21
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=22;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=20;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==22
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=23;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=21;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==23
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=24;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=22;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==24
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=25;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=23;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==25
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=26;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=24;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==26
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=27;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=25;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==27
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=28;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=26;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==28
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=29;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=27;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==29
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=30;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=28;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==30
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=31;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=29;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==31
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=32;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=30;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==32
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=33;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=31;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==33
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=34;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=32;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==34
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=35;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=33;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==35
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=36;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=34;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==36
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=37;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=35;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==37
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=38;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=36;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==38
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=39;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=37;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==39
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=40;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=38;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==40
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=41;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=39;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==41
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=42;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=40;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==42
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=43;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=41;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==43
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=44;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=42;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==44
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=45;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=43;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==45
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=46;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=44;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==46
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=47;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=45;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==47
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=48;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=46;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==48
                if r<(nclosed*xco*(phi)*(kplus)*(ca^eta))*dt
                    state=49;  
                    nopen=nopen+1;
                    nclosed=nclosed-1;
                elseif r<(nopen*xoc*kminus)
                    state=47;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            elseif state==49
                if r<(nopen*xoc*kminus)
                    state=48;
                    nclosed=nclosed+1;
                    nopen=nopen-1;
                end
            end
            topen=topen+state*dt; %sums up all states
            time=time+dt;
        end  
        P(1,ca)=topen/time; %creates an array of the open probs
        timeclosed=1/(nclosed*xco*(phi)*(kplus)*(ca^eta)); %calculates the theoretical probability
        timeopen=1/(nopen*xoc*kminus);
        Popen=topen/(timeopen+timeclosed);
        TP(1,ca)=Popen;
        topen=0;
        time=0;
        state=0;
end
display(P)
%display(TP);
CA(1,ca_limit)=0; %creates an array of the increasing calcium values
for x=1:ca_limit
    CA(1,x)=x;
end

hold on
    plot(CA,TP,'b')
    plot(CA,P,'r') %plots CA on the x axis, and P on the y axis. 
hold off
grid on
xlabel('Ca2+ content');
ylabel('Open Probability');

