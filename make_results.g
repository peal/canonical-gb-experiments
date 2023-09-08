LoadPackage("json");

readJson := function(filename)
local f, l, out;
f := InputTextFile(filename);
l := ReadLine(f);
out := [];
while l <> fail do
Add(out, JsonStringToGap(l));
l := ReadLine(f);
od;
out := Filtered(out, x -> x.time/1000/1000/1000 <= 30*60);
return out;
end;

nicenames := rec();
nicenames.("vole") := "Vole";
nicenames.("CanonicalConfig_RareOrbitPlusRare") := "RareOrbitPlusRare";
nicenames.("CanonicalConfig_FixedMinOrbit") := "FixedMinOrbit";

niceTime := function(t)
    t := t/1000/1000;
    if t > 10000 then
        return Int(t/1000);
    else
        return Float(Int(t)/1000);
    fi;
end;

makeTable := function(r)
    local strat, d, list;
for strat in ["vole", "CanonicalConfig_RareOrbitPlusRare","CanonicalConfig_FixedMinOrbit"] do
    PrintFormatted("{} ", nicenames.(strat));
    for d in [2,4,8] do
        list := Filtered(r, x -> x.order = strat and x.divide = d and x.disableStabilizerCheck = true);
        PrintFormatted("& {} & {}", Length(list), niceTime(Sum(List(list, x -> x.time))));
    od;
    list := Filtered(r, x -> x.order = strat and x.disableStabilizerCheck = true);
    PrintFormatted("& {} & {}", Length(list), niceTime(Sum(List(list, x -> x.time))));
    Print("\\\\\n");
od;
end;

r := readJson("grid-exps-all-output");
makeTable(r);
Print("\n");

r := readJson("prim-exps-all-output");
makeTable(r);
Print("\n");
r := readJson("grid_perm-exps-all-output");

orders := Set(r, x -> x.order);
sizes := Set(r, x -> x.g1);

for s in sizes do
    PrintFormatted("{} &", s);
    for o in orders do
        solves := Filtered(r, x -> x.order = o and x.g1 = s);
        PrintFormatted("{} & {} &", Length(solves), niceTime(Sum(List(solves, x -> x.time))/10));
    od;
    Print("\n");
od;