# Exports an object containing auto-generated information about each type.
module types

# Everything not specified for defense
# is assumed to be 1.0
# We don't specify offensive values, since those can be assumed
# from the defense of every other type, and we need to assume it because
# we're also auto-generating the composite dual types.

@enum PokeType none normal fire water electric grass ice fighting poison ground flying psychic bug rock ghost dragon dark steel fairy

struct CompositeType 
    primary::PokeType
    secondary::PokeType
end

# Main single-type array.
# type -> defenses
TypeList = Dict{PokeType, Dict{PokeType, Float64}}([
    (none, Dict()),
    (normal, Dict([
        (fighting, 2.0),
        (ghost, 0.0),
    ])),
    (fire, Dict([
        (fire, 0.5),
        (water, 2.0),
        (grass, 0.5),
        (ice, 0.5),
        (ground, 2.0),
        (bug, 0.5),
        (rock, 2.0),
        (steel, 0.5),
        (fairy, 0.5)
    ])),
    (water, Dict([
        (fire, 0.5),
        (water, 0.5),
        (electric, 2.0),
        (grass, 2.0),
        (ice, 0.5),
        (steel, 0.5)
    ])),
    (electric, Dict([
        (electric, 0.5),
        (ground, 2.0),
        (flying, 0.5),
        (steel, 0.5)
    ])),
    (grass, Dict([
        (fire, 2.0),
        (water, 0.5),
        (electric, 0.5),
        (grass, 0.5),
        (ice, 2.0),
        (poison, 2.0),
        (ground, 0.5),
        (flying, 2.0),
        (bug, 2.0)
    ])),
    (ice, Dict([
        (fire, 2.0),
        (ice, 0.5),
        (fighting, 2.0),
        (rock, 2.0),
        (steel, 2.0)
    ])),
    (fighting, Dict([
        (flying, 2.0),
        (psychic, 2.0),
        (bug, 0.5),
        (rock, 0.5),
        (dark, 0.5),
        (fairy, 2.0)
    ])),
    (poison, Dict([
        (grass, 0.5),
        (fighting, 0.5),
        (poison, 0.5),
        (ground, 2.0),
        (psychic, 2.0),
        (bug, 0.5),
        (fairy, 0.5)
    ])),
    (ground, Dict([
        (water, 2.0),
        (electric, 0.0),
        (grass, 2.0),
        (ice, 2.0),
        (poison, 0.5),
        (rock, 0.5)
    ])),
    (flying, Dict([
        (electric, 2.0),
        (grass, 0.5),
        (ice, 2.0),
        (fighting, 0.5),
        (ground, 0.0),
        (bug, 0.5),
        (rock, 2.0)
    ])),
    (psychic, Dict([
        (fighting, 0.5),
        (psychic, 0.5),
        (bug, 2.0),
        (dark, 2.0),
        (ghost, 2.0)
    ])),
    (bug, Dict([
        (fire, 2.0),
        (grass, 0.5),
        (fighting, 0.5),
        (ground, 0.5),
        (flying, 2.0),
        (rock, 2.0)
    ])),
    (rock, Dict([
        (normal, 0.5),
        (fire, 0.5),
        (water, 2.0),
        (grass, 2.0),
        (fighting, 2.0),
        (poison, 0.5),
        (ground, 2.0),
        (flying, 0.5),
        (steel, 2.0),
    ])),
    (ghost, Dict([
        (normal, 0.0),
        (fighting, 0.0),
        (poison, 0.5),
        (bug, 0.5),
        (ghost, 2.0),
        (dark, 2.0)
    ])),
    (dragon, Dict([
        (fire, 0.5),
        (water, 0.5),
        (electric, 0.5),
        (grass, 0.5),
        (ice, 2.0),
        (dragon, 2.0),
        (fairy, 2.0)
    ])),
    (dark, Dict([
        (fighting, 2.0),
        (psychic, 0.0),
        (bug, 2.0),
        (ghost, 0.5),
        (dark, 0.5),
        (fairy, 2.0)
    ])),
    (steel, Dict([
        (normal, 0.5),
        (fire, 2.0),
        (grass, 0.5),
        (ice, 0.5),
        (fighting, 2.0),
        (poison, 0.0),
        (ground, 2.0),
        (flying, 0.5),
        (psychic, 0.5),
        (bug, 0.5),
        (rock, 0.5),
        (dragon, 0.5),
        (steel, 0.5),
        (fairy, 0.5)
    ])),
    (fairy, Dict([
        (fighting, 0.5),
        (poison, 2.0),
        (bug, 0.5),
        (dragon, 0.0),
        (dark, 0.5),
        (steel, 2.0)
    ]))
]);

# Defense values for each composite type.
# Composite types will actually also include 'none' pairings,
# i.e. (dark, none) which represent single-types in the same data structure as well.
AllCompositeTypes = Dict{CompositeType, Dict{PokeType, Float64}}()

for (type, defenses) in TypeList
    for (otherType, otherDefenses) in TypeList
        if haskey(AllCompositeTypes, CompositeType(otherType, type)) || otherType == type
            continue;
        end
    
        combined = merge(*, defenses, otherDefenses);
        comp = CompositeType(type, otherType);
        AllCompositeTypes[comp] = combined;
    end
end

export TypeList;
export PokeType;
export CompositeType;

end