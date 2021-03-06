 m = 233;
T = 2;
 prim = [1 zeros(1,158) 1 zeros(1,73) 1];  
Gen_x = hex2poly('17232BA853A7E731AF129F22FF4149563A419C26BF50A4C9D6EEFAD6126');
Gen_y = hex2poly('1DB537DECE819B7F70F555A67C427A8CD9BF18AEB9B56E0C11056FAE6A3');
Gen_pnt = [Gen_x(1,4:236);Gen_y(1,4:236)];
Gen_pnt_neg = [Gen_pnt(1,:);xor(Gen_pnt(1,:),Gen_pnt(2,:))];  
G_x_norm = hex2poly('0fde76d9dcd26e643ac26f1aa901aa129784b71fc0722b2d05614d650b3');
G_y_norm = hex2poly('0643e317633155c9e0447ba8020a3c43177450ee036d633501434cac978');
G_pnt_norm = [G_x_norm(1,4:236);G_y_norm(1,4:236)]; 
n     =  [0 hex2poly('8000000000000000000000000000069D5BB915BCD46EFB1AD5F173ABDF')]; % order of base point
n_1   = xor(n,[zeros(1,m-1) 1]); 
 
dc =  [0 hex2poly('4a626296d03ef011d988a5b2f9252f6839ab13e8c9314526116bf24f5d')]; % public key
 
FR  = hex2poly('1499e398ac5d79e368559b35ca49bb7305da6c0390bcf9e2300253203c9');
FR_233  = FR(1,4:236);
for i = 2:m
    FR_233(i,:) = gf_mul(FR_233(i-1,:),FR_233(i-1,:),prim,m); % normal to poly
end
FR_tmp = inv(gf(FR_233));
FR_inv = double(FR_tmp.x);  
Q = zeros(3,m);
R = [Gen_pnt;zeros(1,m-1) 1];
for i = 1:m
    if sum(Q ~= zeros(3,m),'all') == 0
        Q = zeros(3,m);
    else
        Q = pnt_double_proj_LD(Q,prim,m);
    end
    if dc(1,i) == 1
        if sum(Q ~= zeros(3,m),'all') == 0
            Q = R;
        else
            Q = pnt_add_proj_LD(Q,R,prim,m);
        end
    end
end
qx = gf_div(Q(1,:),Q(3,:),prim,m);
qy = gf_div(Q(2,:),gf_mul(Q(3,:),Q(3,:),prim,m),prim,m);
q = [qx;qy];
disp(poly2hex(q)); 
Q_ = zeros(3,m);
R_ = [G_pnt_norm;ones(1,m)];
for i = 1:m
    if sum(Q_ ~= zeros(3,m),'all') == 0
        Q_ = zeros(3,m);
    else
        Q_ = pnt_double_proj_LD_norm(Q_,m,T); 
    end
    if dc(1,i) == 1
        if sum(Q_ ~= zeros(3,m),'all') == 0
            Q_ = R_;
        else
            Q_ = pnt_add_proj_LD_norm(Q_,R_,m,T);
        end
    end
end
Q_conv = mod(Q_*FR_233,2);
qx_conv = gf_div(Q_conv(1,:),Q_conv(3,:),prim,m);
qy_conv = gf_div(Q_conv(2,:),gf_mul(Q_conv(3,:),Q_conv(3,:),prim,m),prim,m);
disp(poly2hex([qx_conv;qy_conv]));
qx_ = gf_mul_norm(Q_(1,:)*FR_233,gf_inv_norm(Q_(3,:),m,T),m,T);
qy_ = gf_mul_norm(Q_(2,:),gf_inv_norm(gf_sqr_norm(Q_(3,:)),m,T),m,T);
q_ = [qx_;qy_]; 
q__ = mod([q_(1,:)*FR_233;q_(2,:)*FR_233],2);
disp(poly2hex(q__));