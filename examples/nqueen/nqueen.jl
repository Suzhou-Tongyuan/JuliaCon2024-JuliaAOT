# source:
#   https://github.com/attractivechaos/plb2/blob/master/src/julia/nqueen.jl
lshift(x, i) = x << (i & (8*sizeof(x)-1))

function nq_solve(n)
	T = UInt32
	a = T[ 0 for i=1:n ]
	l = T[ 0 for i=1:n ]
	c = T[ 0 for i=1:n ]
	r = T[ 0 for i=1:n ]
	m = 0
	y0 = T((1<<n) - 1)
	k = 1
	@inbounds while k >= 1
		y = (l[k] | c[k] | r[k]) & y0
		if xor(y, y0) >> a[k] != 0
			i = a[k]
			while i < n && (y & (lshift(1, i))) != 0
				i += one(i)
			end
			if k < n
				z = lshift(one(T), i)
				a[k] = i + one(i)
				k += 1
				l[k] = (l[k-1] | z) << 1
				c[k] = c[k-1] | z
				r[k] = (r[k-1] | z) >> 1
			else
				m += 1
				k -= 1
			end
		else
			a[k] = 0
			k -= 1
		end
	end
	return m
end

function main(argv)
    n = parse(Int, argv[1])
	println(nq_solve(n))
end

@static @isdefined(SyslabCC) || main(ARGS)