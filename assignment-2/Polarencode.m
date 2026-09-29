function x = Polarencode(m, A, msg)

n = 2^m;
u = zeros(n, 1);

u(A) = msg;

x = RMmmencode(u, m);

end