LoadPackage("vole", false);
LoadPackage("digraphs", false);

files := DirectoryContents(".");
files := Filtered(files, x -> Length(x) > 4 and x{[1..4]} = "sts-");

r := function(a,b)
    return Int((b-a)/1000/1000);
end;

for f in SortedList(files) do
    d := ReadDIMACSDigraph(f);
    g := SymmetricGroup(DigraphVertices(d));
    StabChainMutable(g);
    h := CyclicGroup(IsPermGroup, Length(DigraphVertices(d)));
    StabChainMutable(h);
    ha := AlternatingGroup(IsPermGroup, Length(DigraphVertices(d)));
    StabChainMutable(ha);
    t1 := NanosecondsSinceEpoch();
    NautyAutomorphismGroup(d);
    t2 := NanosecondsSinceEpoch();
    VoleFind.CanonicalPerm(g, [Constraint.Stabilize(d, OnDigraphs)]);
    t3 := NanosecondsSinceEpoch();
    VoleFind.CanonicalPerm(h, [Constraint.Stabilize(d, OnDigraphs)]);
    t4 := NanosecondsSinceEpoch();
    VoleFind.CanonicalPerm(ha, [Constraint.Stabilize(d, OnDigraphs)]);
    t5 := NanosecondsSinceEpoch();

    PrintFormatted("{} & {} & {} & {}& {}\n", f, r(t1,t2), r(t2,t3), r(t3,t4), r(t4,t5));
od;