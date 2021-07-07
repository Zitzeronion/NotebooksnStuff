using DataFrames, Plots, FileIO
# Dimensions of the logo .png
L = [480, 1090]
# The logo dewetting data
logo_data = load("E:\\JuliaStuff\\Data_PhD\\Tutorials\\Logo_dewetting.jld2") |> DataFrame

heatmap(reshape(logo_data[!, :h_10000],480, 1090), 
        c=:viridis, 
        aspect_ratio=1,
        grid=:none, 
        tickfont = (16, "Arial"),	# tick font and size
        guidefont = (18, "Arial"),	# label font and size
        ylim=(0, 480),
        xlim=(0,1090),
		label="t = 10000Δt", 					# labels
		xlabel="x/Δx", 						# x-axis label
		ylabel="y/Δx",					# y-axis label
        colorbar_title="thickness",
        framestyle = :none,
        )