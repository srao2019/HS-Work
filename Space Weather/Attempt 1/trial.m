for f = 54:114
  filename = sprintf('54.txt',f);
  D = load(filename);
end
s = D(:,3) - D(:,4)
