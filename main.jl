module main

using Statistics;

include("types.jl")

# General idea (first draft)
# - Create a list of every static single type
# - Create a 'defensive score' by just adding up every value of the defense dict. Lower is better.
# - Create an 'offensive score' by iterating all other types and adding up their defenses if relevant. Higher is better
#   - basically ortg/drtg from sports analysis
# - 'Power rating' by doing ortg - drtg.

# Improvements
# - Append every 'composite type' (dual typings) created from mapping all other keys (done)
# - Do an initial pass, then weight every immunity/etc by power rating
# - Do it for a full team (or any N pokemon)
# - Manually weight rock weakness harsher because of stealth rocks.

# power rating calculations -- single
powerList = Dict{types.PokeType, Float64}();
for (name, defenses) in types.TypeList
    drtg = 0.0;
    ortg = 0.0;
    for (otherName, otherDefenses) in types.TypeList
        drtg += get(defenses, otherName, 1.0);
        ortg += get(otherDefenses, name, 1.0);
    end

    power = ortg - drtg;
    powerList[name] = power;
end

# power rating calculations initial pass -- double
dualPowerList = Dict{types.CompositeType, Float64}();
for (type, defenses) in types.AllCompositeTypes
    drtg = 0.0;
    ortg = 0.0;
    for (otherType, otherDefenses) in types.AllCompositeTypes
        drtg += get(defenses, otherType.primary, 1.0) * get(defenses, otherType.secondary, 1.0);
        ortg += get(otherDefenses, type.primary, 1.0) * get(otherDefenses, type.secondary, 1.0);
    end

    power = ortg - drtg;
    dualPowerList[type] = power;
end

#= NOT DONE YET

# power rating calculations second pass
# here we take into consideration the relative power of each individual type
# in the offensive sense
# basically, if a certain typing is strong against a stronger type, then that is weighted better
# so a typing being strong against bug/grass is weighted relatively weakly, while a typing being strong against steel/fairy
# would be weighted very highly
# to get the coeffs for this we first construct a sigmoid based on the power rating
sorted = sort(collect(pairs(dualPowerList)), by = x -> x[2]);
sigmoid = x -> 1.0 / (1.0 + MathConstants.e ^ -0.01(x - (last(sorted)[2] + sorted[1][2] / 2.0)))
coeffs = Dict{types.CompositeType, Float64}()
for (k, v) in dualPowerList
    coeffs[k] = sigmoid(v);
end

# coeffs list built, so let's do the second pass now
# power rating calculations initial pass -- double

weightedPowerList = Dict{types.CompositeType, Float64}();
for (type, defenses) in types.AllCompositeTypes
    drtg = 0.0;
    ortg = 0.0;
    for (otherType, otherDefenses) in types.AllCompositeTypes
        drtg += get(defenses, otherType.primary, 1.0) * get(defenses, otherType.secondary, 1.0) * (get(coeffs, otherType, 1.0))
        ortg += get(otherDefenses, type.primary, 1.0) * get(otherDefenses, type.secondary, 1.0) * (get(coeffs, type, 1.0));
    end

    power = ortg - drtg;
    weightedPowerList[type] = power;
end

=# # NOT DONE YET

for (n, p) in sort(collect(pairs(dualPowerList)), by = x -> x[2])
    print(n.primary);
    print("/")
    print(n.secondary);
    print(" : ");
    println(p);
end

end