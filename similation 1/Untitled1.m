clc 
clear

%%%%% Inintialisation du score %%%%%%%%

NumNodes=50; 
longx=100; 
longy=100;
Net=zeros(3,NumNodes); 
p=sqrt((longx.^2)+(longy.^2));
R=p*sqrt(log10(NumNodes)/NumNodes);  
E0=2;
time=3;
Enrmess=0.0001;
Enemess=0.0001;
engtot(1,1)=0;
engtot(2,1)=E0*NumNodes;
for t=1:1:time
      ss=rem((t+3),4)+1;
     if rem(t-1,4)==0
     figure;        
     end
for i=1:1:NumNodes   
  nod(i).id(t)=i;
  ID(t)=[nod(i).id(t)];
  nod(i).xd(t)=rand(1,1)*longx;
  X(t)=[nod(i).xd(t)];
  nod(i).yd(t)=rand(1,1)*longy; %direction suivant y
  Y(t)= [nod(i).yd(t)]; %vecteur Y
  nod(i).Nbrevoisin(t)=0; %nb voisin
  DEGRE(t)=nod(i).Nbrevoisin(t); % dgree 
  nod(i).e(t)=E0; % enegie initiale 
  ENERGY(t)=nod(i).e(t); % Enegie
  nod(i).erecep(t)=0; % energie recue
  Erecep(t)=nod(i).erecep(t); % vecteur energie recue
  nod(i).etrans(t)=0; % energie transmie
  Etrans(t)=nod(i).etrans(t); % vect enrgie transmie
  nod(i).eidle(t)=0; % enregie en repot
  Eidle(t)=nod(i).eidle(t); % vect enrgie repot
  nod(i).esleep(t)=0; % enrgie en vielle 
  Esleep(t)=nod(i).esleep(t); % vect enrgie en veille 
%%%%%% 
  nod(i).Econsumed(t)= nod(i).esleep(t)+nod(i).eidle(t)+ nod(i).etrans(t)+nod(i).erecep(t); % enrgie consommer
  ECOMSUMED(t)=nod(i).Econsumed(t); 
  nod(i).etat(t)=-1; %%%
  ETAT(t)=nod(i).etat(t); %%%%
 nod(i).etatnode(t)=0;  %%%%
  EtatNode(t)=nod(i).etatnode(t); %%%%
    Net(1,i,t)=ID(t);
    Net(2,i,t)=X(t);
    Net(3,i,t)=Y(t);
    if (t==1) Net(5,i,t)=E0;
    else
         Net(5,i,t)= Net(5,i,t-1);
    end
    Net(6,i,t)=Erecep(t);
    Net(7,i,t)=Etrans(t);
    Net(8,i,t)=Eidle(t);
    Net(9,i,t)=Esleep(t);
    Net(10,i,t)=ECOMSUMED(t);
       if (t==1) Net(11,i,t)=0;
    else
         Net(11,i,t)= Net(11,i,t-1);
       end
  Net(13,i,t)=0;
   Net(15,i,t)=EtatNode(t);
end
radek=1;
 for j=1:1:NumNodes
        for jTemp=1:1:NumNodes
         X1(t)=Net(2,j,t);
         Y1(t)=Net(3,j,t);
         X2(t)=Net(2,jTemp,t);
         Y2(t)=Net(3,jTemp,t);
         xSide(t)=abs(X2(t)-X1(t));
         ySide(t)=abs(Y2(t)-Y1(t));
         d=sqrt(xSide(t).^2+ySide(t).^2);
         if (d<R &&(j~=jTemp)&& Net(11,j,t)==0 && Net(11,jTemp,t)==0)
             vertice1=[X1(t),X2(t)];
             vertice2=[Y1(t),Y2(t)];
             E(radek,1,t)=j;
             E(radek,2,t)=jTemp;
             E(radek,3,t)=d;
             radek=radek+1;
         end
        end
    end
   i=1;
  for k=1:1:numel(E(:,1,t))-1
    E1=E(k,1,t);
    E2=E(k+1,1,t);
  if(E1==E2)
     DEGRE(t)=DEGRE(t)+1 ;
     Net(4,i,t)=DEGRE(t)+1;
 else
      i=i+1;
      DEGRE(t)=0;
  end
  end
    if(t-1==0)ah=1;  
  else ah=t-1;
    end
  load('matlab.mat') ;
  for s=1:1:length(E)
    Mob(s)=10*log10(E(s,3,t)/E(s,3,ah));
    for w=1:1:NumNodes
      if(w==s)
          mobilite(w)=sum(Mob(s));
      end
     end
  end
  a=0.10;
  b=0.70;
  c=0.20;
 
for x=1:1:NumNodes  
    poids(x)=a*mobilite(x)+b* Net(4,x,t)+c* Net(10,x,t);
    Net(14,x,t)=poids(x);
end
l=size(E);
for k=1:1:NumNodes   
    ind=k;
    minpoids=poids(k);
    tes=0;
    for o=1:1:1:l(1)
       
        if(E(o,1,t)==k&&E(o,1,t)>0)
          if(poids(E(o,2,t))<minpoids)
           minpoids=poids(E(o,2,t));
           ind=E(o,2,t);
           tes=1;
          end
        if((poids(E(o,2,t))==minpoids)&&(Net(15,E(o,2,t),t)==1))
            tes=0;
          end
        end
        
end
    if (tes==1)
        ind;
        Net(15,ind,t)=1;
    end
end
Net(15,:,t)

for o=1:1:NumNodes
    subplot(2,2,ss),plot(Net(2,o,t),Net(3,o,t),'o');
    hold on;
      if(Net(15,o,t)==1) subplot(2,2,ss),plot(Net(2,o,t),Net(3,o,t),'r*');
             hold on;
      end
    
  
      
      
      
end

Net(2,NumNodes+1,t)=longx/2;
Net(3,NumNodes+1,t)=longx/2;
subplot(2,2,ss),plot(Net(2,NumNodes+1,t),Net(3,NumNodes+1,t),'*r'); 
hold on;
tai=size(E)
for i=1:1:NumNodes
    if(Net(15,i,t)==1)
X=[Net(2,i,t),Net(2,NumNodes+1,t)]; Y=[Net(3,i,t),Net(3,NumNodes+1,t)]; 
 subplot(2,2,ss),plot(X,Y,'-.r');
hold on;
    for ll=1:1:NumNodes
    if(Net(15,ll,t)==1) 
     
Xo=[Net(2,i,t),Net(2,ll,t)];
Yo=[Net(3,i,t),Net(3,ll,t)]; 
subplot(2,2,ss),plot(Xo,Yo,'g');
  hold on;
    end

   end
  
  
    
    end  
 
end
indncla=1;
for i=1:1:tai(1)
  if(E(i,1,t)>0)
     xSide=abs(Net(2,E(i,1,t),t)-Net(3,E(i,1,t),t));
     ySide=abs(Net(2,E(i,2,t),t)-Net(3,E(i,2,t),t));
     d=sqrt(xSide.^2+ySide.^2);
   if((Net(15,E(i,1,t),t)==1)&&(Net(13,E(i,2,t),t)==0)&&(Net(15,E(i,2,t),t)==0))
    vertice1=[Net(2,E(i,1,t),t),Net(2,E(i,2,t),t)];
    vertice3=[Net(3,E(i,1,t),t),Net(3,E(i,2,t),t)];
    Net(13,E(i,2,t),t)=1;
    Net(5,E(i,1,t),t)=Net(5,E(i,1,t),t)-2*Enrmess * d- Enrmess * d-Enemess * d;
    Net(5,E(i,2,t),t) = Net(5,E(i,2,t),t) - Enrmess * d- Enrmess * d-Enemess * d;
    subplot(2,2,ss),plot(vertice1, vertice3,'-.k');
    hold on;
    Neuclas(indncla,1,t)=E(i,1,t)
    Neuclas(indncla,2,t)=E(i,2,t)
 indncla=indncla+1;
    end
   end
end
taiNeuclas=size(Neuclas)
 for i=1:1:NumNodes
      somme=0;
      if (Net(15,i,t)==1)
         
          for j=1:1:taiNeuclas(1)
              if(Neuclas(j,1,t)==i) somme=somme+1;end
          end
           end
          nomclas(1,i,t)=i;
        nomclas(2,i,t)=somme;
 end
     
clusterhead=0;
nomneoudmort=0;
 for i=1:1:NumNodes
      if (Net(5,i,t)<=0)
        subplot(2,2,ss),plot(Net(2,i,t),Net(3,i,t),'b*');  
        hold on;
        if Net(11,i,t)==0
           nomneoudmort=nomneoudmort+1;
           Net(11,i,t)=1;
       end
      end
       if ( Net(15,i,t)==1)
        clusterhead=clusterhead+1;
        end
  end 
nombchef(t,1)=t;
nombchef(t,2)=clusterhead;
nmort(1,t)=t;
nmort(2,t)=nomneoudmort;
entot=0;
nactiv=0;
for i=1:1:NumNodes
    if(Net(5,1,t)>0)entot=entot+Net(5,1,t);
        nactiv=nactiv+1;
    end
end
engtot(1,t+1)=t;
engtot(2,t+1)=entot;
for i=1:1:NumNodes
    if(Net(5,1,t)>0)entot=entot+Net(5,1,t);
        nactiv=nactiv+1;
    end
end
indch=1;
for i=1:1:NumNodes
    if(Net(15,i,t)==1)
        Energnoeu(1,i,t)=i;
        Energnoeu(2,i,t)=Net(5,i,t);
        msg(1,indch,t)=i;
        msg(2,indch,t)=Energnoeu(1,i,t)/(Enrmess+Enemess);
        indch=indch+1;
    else
    Energnoeu(1,i,t)=i;
    Energnoeu(2,i,t)=0;
    end
end
z(:,2)=z(:,2)*0.93;
z(:,3)=z(:,3)*0.93;
z(:,4)=z(:,4)*0.93;
sub_d(:,1)=sub_d(:,1)-0.6;
xx=xx*1.15;
end
for k=1:1:time
     ind=1;
  for i=1:1:NumNodes
      
      if (nomclas(2,i,k)>0)
gnomclas(1,ind)=nomclas(1,i,k);
gnomclas(2,ind)=nomclas(2,i,k)
ind= ind+1;
      end
        
  end
 
xf=xx+1.5;
end


figure; 
x = [0.5,0.5,0.5;
0.8,0.8,0.8;
1.3,1.3,1.3;
1.9,1.9,1.9;
2.3,2.3,2.3;
2.8, 2.8, 2.8;
3.1,3.1,3.1;
3.5, 3.5, 3.5;
3.9,3.9,3.9;
4.3,4.3,4.3;];
y = [0.3,1;
0.5,2.1;
1.2,3.6;
1.9,5;
2.1,7;
3, 8.9;
3.6,10.2;
4, 12.1;
4.6,14;
5.3,16;];
z=[500,0,0,20;
    1000,80,85,200;
    2000,200,220,430;
    4000,400,500,830;
    5000,430,620,1100;
    6000,600,760,1340;
    10000,930,1310,3130;]
     figure; 
  plot(z(:,1), z(:,2), z(:,1), z(:,3), z(:,1), z(:,4),'LineWidth', 2)
  legend('hash bloom filers (x=1)', 'hash bloom filers (x=2)', 'hash bloom filers (x=3)', 'Location', 'SouthEast')
  xlabel('No.of devices')
  ylabel('Processing Time(milliseconds)')

figure;
bar(yd,xx)
yd = [500,500,500;
          1000,1000,1000;
          2000,2000,2000;
          3000,3000,3000;
          4000,4000,4000;
          5000,5000,5000;
          6000,6000,6000;
          7000,7000,7000;
          8000,8000,8000;
          9000,9000,9000;];
set(gca,'XTickLabel')
legend(' hash bloom fibers x=1',' hash bloom fibers x=2',' hash bloom fibers x=3');
xlim([0 10000])
ylabel('Expected transmission of data')
yda = [500,500;
          1000,1000;
          2000,2000;
          3000,3000;
          4000,4000;
          5000,5000;
          6000,6000;
          7000,7000;
          8000,8000;
          9000,9000;];

figure;
% 
bar(yda,yy) 
set(gca,'XTickLabel')
legend(' hash-bloom filters',' Non hash-bloom filters');
xlim([0 10000]) 
xlabel('No.of devices')
ylabel('Expected transmission of data(bytes)')
title('(h)');
figure; 

subplot(221);
plot(sub_a(:,1), sub_a(:,2), sub_a(:,1), sub_a(:,3), sub_a(:,1), sub_a(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters(x=2)', 'hash bloom filters(x=3)', 'Location', 'SouthEast')
ylabel('Validation time(milliseconds)')
xlabel('No. of devices')
title('(a)');

subplot(222);
plot(sub_b(:,1), sub_b(:,2), sub_b(:,1), sub_b(:,3), sub_b(:,1), sub_b(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters (x=3)', 'Location', 'SouthEast')
ylabel('Energy consumption(j)')
xlabel('No of devices')
title('(b)');
subplot(223);
plot(sub_c(:,1), sub_c(:,2), sub_c(:,1), sub_c(:,3), sub_c(:,1), sub_c(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters (x=3)', 'Location', 'SouthEast')
ylabel('Validation time(milliseconds) ')
xlabel('Malicous devices')
title('(c)');
subplot(224);
plot(sub_d(:,1), sub_d(:,2), ':b','LineWidth',4)
hold on; 
plot(sub_d(:,1), sub_d(:,3),'--r','LineWidth',3) 
plot( sub_d(:,1), sub_d(:,4),'-y','LineWidth',2)
hold off;
%plot(sub_d(:,1), sub_d(:,2), sub_d(:,1), sub_d(:,3), sub_d(:,1), sub_d(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters(x=3)', 'Location', 'SouthEast')
ylabel('False detection rate')
xlabel('Malicious devices')
title('(d)');
figure; 
subplot(211); 
plot(sub_aa(:,1), sub_aa(:,2),'--bx',...
    'LineWidth',4,...
    'MarkerSize',15,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.8,0.8,0.8])
hold on; 
plot(sub_aa(:,1), sub_aa(:,3),'--rs',...
    'LineWidth',3,...
    'MarkerSize',11,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.6,0.6,0.6]) 
plot(sub_aa(:,1), sub_aa(:,4),'-^y',...
    'LineWidth',2,...
    'MarkerSize',9,...
    'MarkerEdgeColor','y',...
    'MarkerFaceColor',[0.4,0.4,0.4])
hold off;
%plot(sub_aa(:,1), sub_aa(:,2), sub_aa(:,1), sub_aa(:,3), sub_aa(:,1), sub_aa(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters (x=3)', 'Location', 'SouthEast')
ylabel('Leader selection time(milliseconds)')
xlabel('No of UAVs')
title('(e)');

subplot(212);
plot(sub_ba(:,1), sub_ba(:,2), '--bx',...
    'LineWidth',4,...
    'MarkerSize',15,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.8,0.8,0.8])
hold on; 
plot(sub_ba(:,1), sub_ba(:,3),'--rs',...
    'LineWidth',3,...
    'MarkerSize',11,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.6,0.6,0.6]) 
plot( sub_ba(:,1), sub_ba(:,4),'-^y',...
    'LineWidth',2,...
    'MarkerSize',9,...
    'MarkerEdgeColor','y',...
    'MarkerFaceColor',[0.4,0.4,0.4])
hold off;
%plot(sub_ba(:,1), sub_ba(:,2), sub_ba(:,1), sub_ba(:,3), sub_ba(:,1), sub_ba(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters (x=3)', 'Location', 'SouthEast')
ylabel('Synchronization time(seconds)')
xlabel('No of Gateways')
title('(f)');

figure; 
subplot(221);
plot(plot_a_a(:,1), plot_a_a(:,2), plot_a_a(:,1), plot_a_a(:,3), plot_a_a(:,1), plot_a_a(:,4),'LineWidth', 2)
legend('hash bloom filters (x=1)', 'hash bloom filters (x=2)', 'hash bloom filters (x=3)', 'Location', 'SouthEast')
ylabel('Throughput')
xlabel('Time')
subplot(222);
plot(plot_a_b(:,1), plot_a_b(:,2), plot_a_b(:,1), plot_a_b(:,3), plot_a_b(:,1), plot_a_b(:,4), plot_a_b(:,1), plot_a_b(:,5),'LineWidth', 2)
ylim([-0.2 1.5])
legend('Cloud Server', 'Datta 2', 'Sana','Propsed', 'Location', 'SouthEast')
ylabel('Energy Consumption')
xlabel('Data size(bytes)')
subplot(223);
plot(plot_a_d(:,1), plot_a_d(:,2), plot_a_d(:,1), plot_a_d(:,3), plot_a_d(:,1), plot_a_d(:,4), plot_a_d(:,1), plot_a_d(:,5),'LineWidth', 2)
ylim([2.5 16])
legend('UAV', 'loT Device phase 2', 'loT Device phase 1','MEC', 'Location', 'SouthEast')
ylabel('Processing time')
xlabel('Data size(bytes)')

subplot(224);
plot(plot_a_e(:,1), plot_a_e(:,2), plot_a_e(:,1), plot_a_e(:,3), plot_a_e(:,1), plot_a_e(:,4), plot_a_e(:,1), plot_a_e(:,5),'LineWidth', 2)
ylim([0.005 0.15])
legend('UAV', 'MEC server 1', 'MEC server 2','MEC server 3', 'Location', 'SouthEast')
ylabel('Energy consumption(j)')
xlabel('Data size(bytes)')

figure; 
subplot(221);
plot(plot_b_a(:,1), plot_b_a(:,2), plot_b_a(:,1), plot_b_a(:,3), plot_b_a(:,1), plot_b_a(:,4), plot_b_a(:,1), plot_b_a(:,5),'LineWidth', 2)
legend('2 validators', '5 validators', '8 validators', '10 validators', 'Location', 'SouthEast')
ylabel('Throughput')
xlabel('Time')

subplot(222);
plot(plot_b_b(:,1), plot_b_b(:,2), plot_b_b(:,1), plot_b_b(:,3), plot_b_b(:,1), plot_b_b(:,4), plot_b_b(:,1), plot_b_b(:,5),'LineWidth', 2)

legend('Full active', '10% down', '20% down', '30% down', '40% down', 'Location', 'SouthEast')
ylabel(' Throughput')
xlabel('Time')

subplot(223);
plot(plot_b_d(:,1), plot_b_d(:,2),'LineWidth', 2)
ylabel('Read')
xlabel('Time')


subplot(224);
plot(plot_b_e(:,1), plot_b_e(:,2),'LineWidth', 2)
ylabel('Latency')
xlabel('No of validators')

