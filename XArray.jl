# -*- tab-width:2 -*-
module XArray

export plot, DataArray


using NetCDF

using Plots
import Plots.plot
import Base.show

type DataArray{T, M, n}
    data::AbstractArray{T, n}
    dims:: Array{Symbol,1}
    coords::Dict{Symbol, M}
end

type Coord end

type DataSet end

function fromarr(data, dims, coords)
    if length(dims) != ndims(data)
        throw(ArgumentError("Size of data array should equal length of dims"))
    end
    DataArray(data, dims, coords)
end

function fromnc(fname, varname)
    ncf = ncinfo(fname)

    data = ncf[varname]

    dims = [Symbol(d.name) for d in data.dim]
    coords = Dict{Symbol, Any}(Symbol(k)=>collect(ncf[k]) for k in keys(ncf.dim))

    DataArray(collect(data), dims, coords)
end

function plot{T, M}(x::DataArray{T, M, 2}; linetype=:contourf, kw...)
    dims = [x.coords[s] for s in x.dims]
    kw = Dict(kw)
    kw[:linetype] = linetype

    kw[:xlabel] = string(x.dims[1])
    kw[:ylabel] = string(x.dims[2])

    Plots.plot(dims[1], dims[2], x.data'; kw...)
end

function show(io::IO, x::DataArray)
    print(io, "DataArray dims=$x.dims")
end

# x = linspace(0,1,100)
# time = linspace(0,20, 200)

# z = broadcast((x,t)->(sin(x.-t)), x, time')

# coords = Dict(:x => x, :time=> time)
# dims = Symbol[:x, :time]




# daz = fromarr(z, dims, coords)


end
