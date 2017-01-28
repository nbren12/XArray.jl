using XArray
using Base.Test



x = linspace(0,1,100)
time = linspace(0,20, 200)

z = broadcast((x,t)->(sin(x.-t)), x, time')

coords = Dict{Symbol, Any}(:x => x, :time=> time)
dims = Symbol[:x, :time]



daz = XArray.fromarr(z, dims, coords)


# subset array
@test isa(daz[1:10, 1:10], XArray.DataArray)
@test isa(daz[1, 1:10], XArray.DataArray)
@test length(daz[1,1:10].dims) == 1
@test daz[1,1:10].dims[1] == :time

## plotting works
# using Plots
# pyplot()
# plot(daz, st=:heatmap)
