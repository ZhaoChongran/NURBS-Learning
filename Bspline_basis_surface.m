%% Bspline basis surface
clc;clear
mesh_grid_x = 101;
mesh_grid_y = 101;
xx = linspace(0, 0.99, mesh_grid_x);
yy = linspace(0, 0.99, mesh_grid_y);

CC = zeros(3, mesh_grid_x, mesh_grid_y);

order_u = 1;
order_v = 1;

uu = [0, 1];
num_PP_u = 10;

if (order_u >= 1)
    for ii = 1 : order_u
        uu = [0, uu];
        uu = [uu, 1];
    end
    for ii = 1 : num_PP_u-order_u-1
        uu = [uu(1:order_u+ii), ii / (num_PP_u-order_u) , uu(order_u+ii+1:end)];
    end
end

vv = [0, 1];
num_PP_v = 10;
if (order_v >= 1)
    for ii = 1 : order_v
        vv = [0, vv];
        vv = [vv, 1];
    end
    for ii = 1 : num_PP_v-order_v-1
        vv = [vv(1:order_v+ii), ii / (num_PP_v-order_v) , vv(order_v+ii+1:end)];
    end
end

% control points
u_range = linspace(-1, 1.0, num_PP_u);
v_range = linspace(-1, 1.0, num_PP_v);
[UU, VV] = meshgrid(u_range, v_range);
WW = sin(UU) + cos(VV);

PP = zeros(3, num_PP_u, num_PP_v);
for ii = 1 : num_PP_u
    for jj = 1 : num_PP_v
        PP(1, ii, jj) = UU(ii,jj);
        PP(2, ii, jj) = VV(ii, jj);
        PP(3, ii, jj) = WW(ii, jj);
    end
end
for kk = 1 : mesh_grid_x
    for ll = 1 : mesh_grid_y
        for ii = 0 : num_PP_u-1
            for jj = 0 : num_PP_v-1
                CC(:, kk, ll) = CC(:, kk, ll) + Bspline(ii, order_u, uu, xx(kk)) .* PP(:, ii+1, jj+1) .* Bspline(jj, order_v, vv, yy(ll));
            end
        end
    end
end

XX = reshape(CC(1,:,:),[mesh_grid_x,mesh_grid_y]);
YY = reshape(CC(2,:,:),[mesh_grid_x,mesh_grid_y]);
ZZ = reshape(CC(3,:,:),[mesh_grid_x,mesh_grid_y]);

mesh( XX, YY, ZZ, LineWidth=3.0);
hold on
for ii = 1 : num_PP_u
    for jj = 1 : num_PP_v
        scatter3(PP(1,ii,jj), PP(2,ii,jj), PP(3,ii,jj), 100, 'filled', 'MarkerFaceColor','cyan');
        hold on
    end
end

function BB = Bspline(ii, pp, uu, xx)
if ( pp == 0 )
    if ( (xx < uu(ii+2)) && (xx >= uu(ii+1)) )
        BB = 1.0;
    else
        BB = 0.0;
    end
else
    a1 = xx - uu(ii+1);
    b1 = uu(ii+pp+1) - uu(ii+1);
    a2 = uu(ii+pp+2) - xx;
    b2 = uu(ii+pp+2) - uu(ii+2);

    if (b1 == 0)
        coe1 = 0;
    else
        coe1 = a1/b1;
    end
    if (b2 == 0)
        coe2 = 0;
    else
        coe2 = a2 / b2;
    end
    BB = coe1 .* Bspline(ii, pp-1, uu, xx) + coe2 .* Bspline(ii+1, pp-1, uu, xx);
end
end