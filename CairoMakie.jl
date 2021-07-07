### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 6387ea68-f280-40b7-be3f-7b8241a39624
using CairoMakie, Random, DataFrames, FileIO

# ╔═╡ 7a5f7917-e371-40a0-b684-f3feac6bec7c
md"## CairoMakie demo"

# ╔═╡ 9b4d3474-614b-4889-baa8-38471d4c76e0
let
    Random.seed!(123)
    fig = Figure(resolution = (400, 427))
    ax = Axis(fig,  aspect = 1, xlabel = "x", ylabel = "y")
    hmap = heatmap!(rand(20,20), colormap = :lajolla)
    cbar = Colorbar(fig, hmap, label = "values", height = 15, vertical = false,
     flipaxis = false, ticksize=15, tickalign = 1, width = Relative(3.55/4))
    fig[1, 1] = ax
    fig[2, 1] = cbar
    rowgap!(fig.layout, 7)
    fig
end

# ╔═╡ 5e7a5b8f-73fe-4ec0-8d28-79195ebaf8a9
md"My data to use on the same demo layout"

# ╔═╡ a86eee2c-7d8d-42fd-abaf-b9cecb56d065
begin
	L = [480, 1090]
# The logo dewetting data
	logo_data = load("E:\\JuliaStuff\\Data_PhD\\Tutorials\\Logo_dewetting.jld2") |> DataFrame
end

# ╔═╡ b764b630-889b-47de-a151-532203804cc8
"""
	corr_disp(arr)

Rotates and inverts an snapshot of the simulation to be correctly displayed in Makie.
"""
function corr_disp(arr; time=15000)
	new_arr = zeros(L[1], L[2])
	new_arr = reverse(rotr90(reshape(arr[!, Symbol("h_$(time)")],L[1],L[2])), dims=2)
	
	return new_arr
end

# ╔═╡ 8a108953-eb78-43fd-aac0-0afa0ba563a9
let
    fig = Figure(resolution = (860, 680))
    ax = Axis(fig,  aspect = 2, xlabel = "x", ylabel = "y")
    hmap = heatmap!(corr_disp(logo_data, time=20000), colormap = :viridis)
    cbar = Colorbar(fig, hmap, label = "thickness", height = 15, vertical = false,
     flipaxis = false, ticksize=15, tickalign = 1, width = Relative(3.55/4))
    fig[1, 1] = ax
    fig[2, 1] = cbar
    rowgap!(fig.layout, 7)
    fig
end

# ╔═╡ c0662743-134d-4904-8983-f3ee1bd26c59
let
    Random.seed!(123)
    n = 15
    x, y, color = rand(n), rand(n), rand(n)
    cmaps = [:cool, :viridis, :inferno, :thermal]

    function FigGridHeatSharedCbarH()
        fig = Figure(resolution = (600, 400))
        axes = []
        c = 1
		m = 3
        for i in 1:1, j in 1:m
            ax = Axis(fig[i, j],aspect=1,xgridvisible = false,ygridvisible = false)
            pnts = heatmap!(rand(10,10), colormap= cmaps[2], colorrange=(0, 1))
            #ax.xticks = [1,10]
            #ax.yticks = [1,10]
            cbar = Colorbar(fig, pnts, vertical = false, flipaxis = false,
            width = Relative(3/4), height = 15, tickwidth = 2, ticklabelsize = 14)
            cbar.ticks = [0,0.5,1]
            fig[2, 1:m] = cbar
            c+=1
            push!(axes, ax)
        end
		for k in 2:3
        	hideydecorations!(axes[k], ticks = true)
		end
        fig
    end
    fig = FigGridHeatSharedCbarH()
    fig
end

# ╔═╡ a2d0c8c6-2063-4ed1-ad91-3e7ff08c4743
let
	noto_sans = assetpath("fonts", "NotoSans-Regular.ttf")
	noto_sans_bold = assetpath("fonts", "NotoSans-Bold.ttf")
    function FigGridHeatSharedCbarHLogo()
		
		# Defining the figure window
        fig = Figure(resolution = (1300, 450), font=noto_sans)
        axes = []
        c = 1
		m = 3
		# Data for the three heatmap images
		imgs = [corr_disp(logo_data, time=5000), corr_disp(logo_data, time=20000), corr_disp(logo_data, time=35000)]
		# Labels of the heatmaps
		times = ["5000 Δt", "20000 Δt", "35000 Δt"]
		# Gauge of the colormap
		h_lim = maximum(imgs[3])
		# Loop over the three images
        for i in 1:1, j in 1:m
            ax = Axis(fig[i, j],
				      aspect = 2, 
				      xgridvisible = false, 
				      ygridvisible = false, 
				      xlabel = "x Δx", 
				      ylabel = "y Δx", 
					  xticklabelsize=25,
					  yticklabelsize=25,
					  )
            pnts = heatmap!(imgs[j], colormap=:viridis, colorrange=(0, h_lim))
            ax.xticks = [1,512,1090]
            ax.yticks = [1,256,480]
			# ax.fontsize = 26
            # ax.yticks = [1,256,480]
			ax.title = times[j]
			ax.titlesize = 34
			ax.xlabelsize = 28
			ax.ylabelsize = 28
            cbar = Colorbar(fig, pnts, label="Film Thickness", vertical = false, flipaxis = false,
            width = Relative(4/5), height = 15, tickwidth = 2, ticklabelsize = 24, labelsize=26)
            cbar.ticks = [0,0.75,1.5,2.25]
            fig[2, 1:m] = cbar
            c+=1
            push!(axes, ax)
        end
		for k in 2:3
        	hideydecorations!(axes[k], ticks = true)
        	hidexdecorations!(axes[k], ticks = true)
			
		end
        fig
    end
    fig = FigGridHeatSharedCbarHLogo()
    fig
	# save("E:\\JuliaStuff\\Figures\\Hiern_logo.png", fig)
end

# ╔═╡ a198a1eb-c164-4ab9-b0ee-8296f080846e
md"## Let's try an animation

Would be cool to have an animation of changing heatmaps!"

# ╔═╡ 39c23799-6f5d-402a-b8dd-9404f78357f4
begin
	time = Node(0.0)

	xs = range(0, 7, length=40)

	ys_1 = @lift(sin.(xs .- $time))
	ys_2 = @lift(cos.(xs .- $time) .+ 3)

	fig = lines(xs, ys_1, color = :blue, linewidth = 4,
    	        axis = (title = @lift("t = $(round($time, digits = 1))"),))
	scatter!(xs, ys_2, color = :red, markersize = 15)

	framerate = 30
	timestamps = range(0, 2, step=1/framerate)

	record(fig, "time_animation.mp4", timestamps; framerate = framerate) do t
    	time[] = t
	end
end

# ╔═╡ cd57c594-a9ca-48cd-ac05-e4a547d93d05
begin
	time_n = Node(1000)
	
	time_st = collect(1000:500:50000)
	max_h = maximum(logo_data[!, :h_50000])
	fig_logo = Figure(resolution = (860, 680))
    ax = Axis(fig_logo, 
		      aspect = 2, 
		      xlabel = "x Δx", 
		      ylabel = "y Δx", 
		      title = @lift("t = $($time_n) Δt"),
			  xticklabelsize=25,
			  yticklabelsize=25,
			  xlabelsize = 28,
			  ylabelsize = 28,
		      titlesize = 34)
	data_logo = @lift(corr_disp(logo_data, time=Int($time_n)))
    hmap = heatmap!(data_logo, colormap = :viridis, colorrange=(0, max_h))
    cbar = Colorbar(fig_logo, hmap, label = "Film Thickness", height = 15, vertical = false,
     flipaxis = false, ticksize=15, tickalign = 1, width = Relative(3.55/4), ticklabelsize = 24, labelsize=26)
    fig_logo[1, 1] = ax
    fig_logo[2, 1] = cbar
    rowgap!(fig_logo.layout, 7)
	
    record(fig_logo, "logo_animation.gif", time_st; framerate = 30) do t
    	time_n[] = t
	end
end

# ╔═╡ Cell order:
# ╠═6387ea68-f280-40b7-be3f-7b8241a39624
# ╟─7a5f7917-e371-40a0-b684-f3feac6bec7c
# ╠═9b4d3474-614b-4889-baa8-38471d4c76e0
# ╟─5e7a5b8f-73fe-4ec0-8d28-79195ebaf8a9
# ╠═a86eee2c-7d8d-42fd-abaf-b9cecb56d065
# ╠═b764b630-889b-47de-a151-532203804cc8
# ╠═8a108953-eb78-43fd-aac0-0afa0ba563a9
# ╠═c0662743-134d-4904-8983-f3ee1bd26c59
# ╠═a2d0c8c6-2063-4ed1-ad91-3e7ff08c4743
# ╠═a198a1eb-c164-4ab9-b0ee-8296f080846e
# ╠═39c23799-6f5d-402a-b8dd-9404f78357f4
# ╠═cd57c594-a9ca-48cd-ac05-e4a547d93d05
