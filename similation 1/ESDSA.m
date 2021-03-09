function [xQ,yQ] = ESDSA(pr_key)
 
import java.math.* 
xG=BigInteger('79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798',16);
yG=BigInteger('483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8',16);
G=[xG,yG];
p=BigInteger('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F',16);%mod
n =          'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141';    % Max private key
 
k=BigInteger(pr_key,16).subtract(BigInteger(n,16));
if k.divide(k.abs())=='1';
   disp(['  ' char(n)]); 
   return
end 
pr_key=char(BigInteger(pr_key,16).toString(2)); 
Q=G;
for i=2:length(pr_key)
 Q=adding(Q,Q,p);
  if str2num(pr_key(i))==1;
   Q=adding(G,Q,p);
  end
end 
xQ=char(Q(1).toString(16)); 
yQ=char(Q(2).toString(16));
zeros_(1:64-length(xQ))='0';    xQ=[zeros_ xQ];
zeros_(1:64-length(yQ))='0';    yQ=[zeros_ yQ];
end
function G=adding(P,Q,p)
import java.math.*
if P(1)==Q(1)
  a=BigInteger('2').multiply(P(2)).modInverse(p);
  m=BigInteger('3').multiply(P(1).pow(2).mod(p)).multiply(a).mod(p);
else
  a=P(1).subtract(Q(1)).modInverse(p);
  m=P(2).subtract(Q(2)).multiply(a).mod(p);    
end
G(1)=m.pow(2).subtract(P(1)).subtract(Q(1)).mod(p);
G(2)=P(2).add(m.multiply(G(1).subtract(P(1)))).negate().mod(p);
end