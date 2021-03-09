clc 
clear
NumNodes=120; 
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
  nod(i).yd(t)=rand(1,1)*longy;
  Y(t)= [nod(i).yd(t)];
  nod(i).Nbrevoisin(t)=0;
  DEGRE(t)=nod(i).Nbrevoisin(t);
  nod(i).e(t)=E0;
  ENERGY(t)=nod(i).e(t);
  nod(i).erecep(t)=0;
  Erecep(t)=nod(i).erecep(t);
  nod(i).etrans(t)=0;
  Etrans(t)=nod(i).etrans(t);
  nod(i).eidle(t)=0;
  Eidle(t)=nod(i).eidle(t);
  nod(i).esleep(t)=0;
  Esleep(t)=nod(i).esleep(t);
  nod(i).Econsumed(t)= nod(i).esleep(t)+nod(i).eidle(t)+ nod(i).etrans(t)+nod(i).erecep(t);
  ECOMSUMED(t)=nod(i).Econsumed(t);
  nod(i).etat(t)=-1;
  ETAT(t)=nod(i).etat(t);
 nod(i).etatnode(t)=0; 
  EtatNode(t)=nod(i).etatnode(t);
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
  figure;
plot(gnomclas(1,:),gnomclas(2,:),'*r')
title('nombre de noeuds par cluster')
xlabel('clustrehead ')
ylabel(' nombre de membre')

  
end


figure;
stairs(engtot(1,:),engtot(2,:),'r:')
 

figure;
plot( nmort(1,:),nmort(2,:),'*r')
title('Nombre de noeud mort')
xlabel('Temps')
ylabel(' Nombrre Noeud ')
figure;
plot(nombchef(:,1),nombchef(:,2),'r:')
title('nombre de clusterhead')
xlabel('temps')
ylabel('nombre de clustrehead')

indch=1;
 figure;
plot(msg(1,:),msg(2,:),'*r')
title('nombre de massage totale recu par clusterhead')
xlabel('clusterhead')
ylabel('nombre de massage ')

figure;
hold on
bar(Net(5,:,time))
plot(Net(5,:,time),'r') 
xlabel('noeud')
 

