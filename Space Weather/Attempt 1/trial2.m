for f = 54:114
  filename = sprintf('55.txt',f);
  E = load(filename);
end
t = E(:,3) - E(:,4)
