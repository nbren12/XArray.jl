# -*- tab-width:2 -*-
module XArray

export plot, DataArray


using NetCDF

using Plots
import Plots.plot

type DataArray{T, M, N} <: AbstractArray{T, N}
    data::AbstractArray{T, N}
    dims:: Array{Symbol,1}
    coords::Dict{Symbol, M}
end


# Necessary methods for subtypes of AbstractArray
# TODO real indexing 
Base.size(A::DataArray) = size(A.data)
Base.setindex!(A::DataArray, inds...) = setindex!(A.data, v, inds...)
Base.getindex(A::DataArray, inds::Int...) = A.data[inds...]

"""
A[1:10, 1:10] style indexing
"""
function Base.getindex(A::DataArray, inds::Union{UnitRange, Colon, AbstractVector}...)
    data = getindex(A.data, inds...)
    coords = Dict{Symbol, Any}(dim=>A.coords[dim][i] for (dim, i) in zip(A.dims, inds))
    DataArray(data, A.dims, coords)
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

# Recipes for plotting

@recipe function f{T, M}(x::DataArray{T,M,2})
    # st --> :contourf
    xlabel --> string(x.dims[1])
    ylabel --> string(x.dims[2])

    if maximum(x.data) > 0 > minimum(x.data)
        c --> :bluesreds
    end

    dims = [x.coords[s] for s in x.dims]
    dims[1], dims[2], x.data'
end

# function plot{T, M}(x::DataArray{T, M, 2}; linetype=:contourf, kw...)
#     dims = [x.coords[s] for s in x.dims]
#     kw = Dict(kw)
#     kw[:linetype] = linetype

#     kw[:xlabel] = string(x.dims[1])
#     kw[:ylabel] = string(x.dims[2])

#     Plots.plot(dims[1], dims[2], x.data'; kw...)
# end

# function show(io::IO, x::DataArray)
#     print(io, "DataArray dims=$x.dims")
# end

# x = linspace(0,1,100)
# time = linspace(0,20, 200)

# z = broadcast((x,t)->(sin(x.-t)), x, time')

# coords = Dict(:x => x, :time=> time)
# dims = Symbol[:x, :time]




# daz = fromarr(z, dims, coords)


end
