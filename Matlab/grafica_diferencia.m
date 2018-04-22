n = 11516;
n2 = 11517;

dif = zeros(n,1);

for i = 1:(n - 1)
    dif(i,1) = test(i,1) - vhdlout(i,1);
end

indice = 0:1:(n - 1);
indice2 = 0:1:(n2 - 1);

plot(indice2, test);
title('Filtrado según Matlab');

figure;
plot(indice, vhdlout);
title('Filtrado según VHDL');

figure;
plot(indice, dif);
title('Diferencia entre filtrado según Matlab y según VHDL');