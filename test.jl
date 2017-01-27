include("xarray.jl")
using XArray
using Plots
gr()
fname= "OUT_2D/HOMO_2km_16384x1_64_2000m_5s.HOMO_2K.smagor_16.2Dcom_1.nc"
tb = XArray.fromnc(fname, "TB")
plot(tb)
