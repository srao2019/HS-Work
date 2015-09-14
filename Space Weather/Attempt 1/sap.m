for f = 54:55
  filename = sprintf('files/%d.dat',f);
  D = load(filename);
  DD(:,:,f-53) = D;
  whos D
end

min(DD(:,4,2)-DD(:,4,1))
break

compare= s-t
plot(1:99,s)
plot(1:99,t)





