function drawpolicy(policy)

[y i] = max(policy,[],2);

y = [3 3 3 2 2 2 1 1 1 2 2 3 3 3 2 2 2 1 1 1];
x = [1 2 3 1 2 3 1 2 3 4 5 6 7 8 6 7 8 6 7 8];

for j=1:20
  if (i(j) == 1)
    u(j) = 0;
    v(j) = 1;
  end
  if (i(j) == 2)
    u(j) = 1;
    v(j) = 0;
  end
  if (i(j) == 3)
    u(j) = 0;
    v(j) = -1;
  end
  if (i(j) == 4)
    u(j) = -1;
    v(j) = 0;
  end
end


quiver(x,y,u,v, 0.3);
