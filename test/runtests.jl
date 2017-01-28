using XArray
using Plots
gr()


x = linspace(0,1,100)
time = linspace(0,20, 200)

z = broadcast((x,t)->(sin(x.-t)), x, time')

coords = Dict(:x => x, :time=> time)
dims = Symbol[:x, :time]



daz = XArray.fromarr(z, dims, coords)

# makeing plot
plot(daz)


# subset array
daz[1:10, 1:10]
