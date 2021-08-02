sz=20;
R=0.4*ones(1,sz^2);
sigma=ones(1,sz^2);
Y=0.1;
nu=0.2;
r=10;
theta0(1:sz^2)=0;
A=eye(sz^2);
%A=reshape(A,[1,sz^4]);
b=pi*ones(sz^2,1);
%a=0*ones(sz^2,1);
options=optimoptions('fmincon','MaxFunEvals',2000000);
theta_min=fmincon(@(theta) totalenergy(sz,R,Y,sigma,nu,r,theta),theta0,A,b,[],[],[],[],[],options);
%theta_min=fminsearch(@(theta) totalenergy(sz,R,Y,sigma,nu,r,theta),theta0);





function E=totalenergy(sz,R,Y,sigma,nu,theta,cornum,Rij,phi,NoP)


E1=0;
E2=0;
for i=1:sz^2
    E2=E2-pi*(R(i))^2*(sigma(i))^2/(2*Y)*((1+nu)+(3-nu)*cos(2*theta(i)));
end


for i=1:sz^2
    for j=1:NoP
        E1=E1+4*pi*sigma(i)sigma(cornum(i,j))(R(i)R(cornum(i,j)))^2/(Y*Rij(j)^2)(cos(2*(theta(i)+theta(cornum(i,j))-2*phi(j)))-cos(2*theta(i)-2*phi(j))-cos(2*theta(cornum(i,j))-2*phi(j)));
    end
end


E=E1/2+E2;
end