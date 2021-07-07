using DrWatson
@quickactivate :Swalbe
using Images, Colors

function dewet_hiern(logo_source; 
                     ϵ=1e-3, 
                     h₀=1.0, 
                     device="CPU", 
                     slip=3.0, 
                     Tmax=10000,
                     dump=100,
                     T=Float64,
                     verbos=true)
	println("Starting logo dewetting")
	# Memory allocation
    logo = load(logo_source)
    sys = Swalbe.SysConst(Lx=size(logo)[1], Ly=size(logo)[2], Tmax=Tmax, tdump=dump, δ=slip)
    fout, ftemp, feq, height, velx, vely, vsq, pressure, dgrad, Fx, Fy, slipx, slipy, h∇px, h∇py = Swalbe.Sys(sys, device, false, T)
    fluid = zeros(Tmax÷dump, sys.Lx*sys.Ly) 
    theta = zeros(sys.Lx, sys.Ly)
    println("Reading logo: $(logo_source)\nand pattern substrate according to it")
    theta = T.(2/9 .- 1/18 .* red.(reverse(rot180(logo), dims=2)))
    if device == "CPU"
        for i in 1:sys.Lx, j in 1:sys.Ly
            height[i,j] = h₀ + ϵ * randn()
        end
        th = zeros(size(height))
        th .= theta 
    elseif device == "GPU"
        h = zeros(size(height))
        for i in 1:sys.Lx, j in 1:sys.Ly
            h[i,j] = h₀ + ϵ * randn()
        end
        # Lower contact angle inside the letters
		# Forward it to the GPU
		th = CUDA.adapt(CuArray, theta)
        height = CUDA.adapt(CuArray, h)
    end
    Swalbe.equilibrium!(fout, height, velx, vely, vsq)
    ftemp .= fout
    for t in 1:sys.Tmax
        if t % sys.tdump == 0
            mass = 0.0
            mass = sum(height)
            deltaH = maximum(height) - minimum(height)
            if verbos
                println("Time step $t mass is $(round(mass, digits=3)) and δh is $(round(deltaH, digits=3))")
            end
        end
        Swalbe.filmpressure!(pressure, height, dgrad, sys.γ, th, sys.n, sys.m, sys.hmin, sys.hcrit)
        Swalbe.∇f!(h∇px, h∇py, pressure, dgrad, height)
        Swalbe.slippage!(slipx, slipy, height, velx, vely, sys.δ, sys.μ)
        # Forces are the pressure gradient and the slippage due to substrate liquid boundary conditions
        Fx .= h∇px .+ slipx
        Fy .= h∇py .+ slipy
        # New equilibrium
        Swalbe.equilibrium!(feq, height, velx, vely, vsq)
        Swalbe.BGKandStream!(fout, feq, ftemp, -Fx, -Fy)
        # New moments
        Swalbe.moments!(height, velx, vely, fout)
        # Measurements, in this case only snapshots of simulation's arrays
        Swalbe.snapshot!(fluid, height, t, dumping = dump)
    end
    return fluid
    if device == "GPU"
        CUDA.reclaim()
    end
end

dewet_hiern("C:\\Users\\Zitzero\\Pictures\\Science\\logo_red.png", slip=3.0, Tmax=10000, dump=100, verbos=true)