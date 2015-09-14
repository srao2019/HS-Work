%Assignment 8/15, a basic montecarlo simulation
clear;clc
state=0; %closed is 0, open is 1
V=[1,10,100]; %testing various voltages
Popen=0;  %to determine open probability
for i=1:3  %To loop through various voltages
    v=V(i);
    delta=(0.1)/((6*v)+20);  %constant
    p=6*v*delta;  %close to open factor
    q=20*delta;     %open to close factor
    for t=0:1000
    r=rand(1,1); %generates a random number
    if state==0  %determines whether to use the open to close or close to open
        if r<p
        state=1;
        end
       %display(state)
    elseif state==1
        if r<q
            state=0;
        end
        %display(state);
    end
    Popen=Popen+state; %adds the current state to the number open. 
    end
    Popen=Popen/1000; %generates the open probability
    display(Popen)
end

    