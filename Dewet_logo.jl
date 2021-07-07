### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 191b2740-c20f-11eb-1bc3-4554934741e5
using DataFrames, JLD2, FileIO, Plots, Images, Colors, Swalbe, CUDA, HTTP

# ╔═╡ b2ec63db-847f-4986-b980-4d45482c7020
md"# Illustrative simulation
"

# ╔═╡ 5dc45dab-d666-43d4-b993-4985c5fe0501
md"## Dewetting of the **HI-ERN** logo

In this notebook we try to dewet the **HI-ERN** logo.
To do so we initialize a flat film and put small perturbations on top.
Under the film is a substrate on which we have printed the logo.

"

# ╔═╡ f72a2bc4-1ed8-448c-99a5-7d8fe85fd35d
html"""
<img src="https://hi-ern.de/SiteGlobals/StyleBundles/Bilder/NeuesLayout/hi-ern/logo.png?__blob=normal" width="820" height="320" />
"""

# ╔═╡ 80930386-a39f-41d6-9b33-c743dbde3b95
md"After some tweaking to make it as binary as possible we can add that image as an array to our simulation.
There was a default red in inkscape, I just stick to it.
This allows us to change the contact angle inside the letters and make them more wettable, such lower contact angle."

# ╔═╡ 3b5552d9-692d-4851-b353-630e5c5449dd
html"""
<img src="https://jugit.fz-juelich.de/s.zitz/timedependent_wettability/-/raw/master/Figures/logo_red.png?inline=false" width="820" height="320" />
"""

# ╔═╡ d77cdc31-10ce-4384-adf4-90c57d8919e7
# Work in progress scrap images from web
# img = load(HTTP.get("https://jugit.fz-juelich.de/s.zitz/timedependent_wettability/-/raw/master/Figures/logo_red.png?inline=false").body)

# ╔═╡ 7cc7da7e-c1da-4ba3-9d4d-af0d9d5bfa73
# The dewetting function
function dewet_hiern(sys::Swalbe.SysConst; ϵ=1e-3, h₀=1.0, device="GPU", T=Float64)
	println("Starting logo dewetting")
	# Memory allocation
    fout, ftemp, feq, height, velx, vely, vsq, pressure, dgrad, Fx, Fy, slipx, slipy, h∇px, h∇py = Swalbe.Sys(sys, device, false, T)
    if device == "CPU"
        for i in 1:sys.Lx, j in 1:sys.Ly
            height[i,j] = h₀ + ϵ * randn()
        end
    elseif device == "GPU"
        h = zeros(size(height))
        for i in 1:sys.Lx, j in 1:sys.Ly
            h[i,j] = h₀ + ϵ * randn()
        end
		logo = load("E:\\JuliaStuff\\Github_Gists\\807b9a7b2226e65643288df9a8cc1f46\\logo_red.png")
        # Lower contact angle inside the letters
		theta = 2/9 .- 1/18 .* red.(reverse(rot180(logo), dims=2))
		# Forward it to the GPU
		θ = CUDA.adapt(CuArray, theta)
        height = CUDA.adapt(CuArray, h)
    end
    Swalbe.equilibrium!(fout, height, velx, vely, vsq)
    ftemp .= fout
    for t in 1:sys.Tmax
        if t % sys.tdump == 0
            mass = 0.0
            mass = sum(height)
            if verbos
                println("Time step $t mass is $(round(mass, digits=3))")
            end
        end
        Swalbe.filmpressure!(pressure, height, dgrad, sys.γ, theta, sys.n, sys.m, sys.hmin, sys.hcrit)
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
        # Measurements, in this case only snapshots of simulational arrays
    end
    return height
    CUDA.reclaim()
end

# ╔═╡ a902a01d-04f5-4f2e-9414-decdc8f3bfd9
begin
	sys = Swalbe.SysConst(Lx=383, Ly=885, n=3, m=2, hmin=0.7)
	h = dewet_hiern(sys)
end

# ╔═╡ 6c154892-8375-4160-badf-fdfb16ce947e


# ╔═╡ Cell order:
# ╠═b2ec63db-847f-4986-b980-4d45482c7020
# ╠═191b2740-c20f-11eb-1bc3-4554934741e5
# ╟─5dc45dab-d666-43d4-b993-4985c5fe0501
# ╟─f72a2bc4-1ed8-448c-99a5-7d8fe85fd35d
# ╟─80930386-a39f-41d6-9b33-c743dbde3b95
# ╟─3b5552d9-692d-4851-b353-630e5c5449dd
# ╠═d77cdc31-10ce-4384-adf4-90c57d8919e7
# ╠═7cc7da7e-c1da-4ba3-9d4d-af0d9d5bfa73
# ╠═a902a01d-04f5-4f2e-9414-decdc8f3bfd9
# ╠═6c154892-8375-4160-badf-fdfb16ce947e
