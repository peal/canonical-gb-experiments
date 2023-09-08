LoadPackage("images",false);
LoadPackage("json",false);
LoadPackage("io",false);
LoadPackage("vole",false);

dupPermDown := function(P, maxPnt, copies)
	local newPerm, i, j;
	newPerm := [1..maxPnt * copies];
	for i in [1..maxPnt] do
		for j in [0..copies-1] do
			newPerm[i + j * maxPnt] := i^P + j * maxPnt;
		od;
	od;
	return PermList(newPerm);
end;

dupPermAcross := function(P, maxPnt, copies)
	local newPerm, i, j;
	newPerm := [1..maxPnt * copies];
	for i in [1..maxPnt] do
		for j in [1..copies] do
			newPerm[i * copies - copies + j] := (i^P) * copies - copies + j;
		od;
	od;
	return PermList(newPerm);
end;

outerProdGroups := function(G,H)
	local gensG, gensH, maxG, maxH, Hdups, Gdups, ret;
	
	gensG := GeneratorsOfGroup(G);
	gensH := GeneratorsOfGroup(H);
	
	maxG := LargestMovedPoint(G);
	maxH := LargestMovedPoint(H);
	
	Hdups := List(gensH, y -> dupPermDown(y, maxH, maxG));
	Gdups := List(gensG, x -> dupPermAcross(x, maxG, maxH));
	
	ret := Group(Flat([Hdups, Gdups]));
	SetSize(ret, Size(G) * Size(H));
	return ret;
end;


RunExperiment := function(G, s, order, doStab, filename, expdata, action)
    local t1,t2,stats,file,i;
    
    _IMAGES_ResetStats();
    StabChainMutable(G);
    StabTreeStabilizerOrbits(G, [], [1..LargestMovedPoint(G)]);

    t1 := NanosecondsSinceEpoch();
    if order = "vole" then
        Vole.CanonicalImagePerm(G, s, action);
    else
        CanonicalImage(G, s, action, rec(order := order, disableStabilizerCheck := doStab, stabilizer := Group(()) ));
    fi;
    t2 := NanosecondsSinceEpoch();
    stats := _IMAGES_GetStats();
    stats.time := t2 - t1;
    for i in RecNames(expdata) do
        stats.(i) := expdata.(i);
    od;
    stats.order := order;
    stats.disableStabilizerCheck := doStab;
    stats.filename := filename;
    file := IO_File(Concatenation(filename,".out"), "w");
    IO_Write(file, GapToJsonString(stats));
    IO_Close(file);
end;


RunPermExperiment := function(G, p, q, order, filename, expdata)
    local t1,t2,stats,file,i, dp, dq;
    
    _IMAGES_ResetStats();
    StabChainMutable(G);
    StabTreeStabilizerOrbits(G, [], [1..LargestMovedPoint(G)]);

    dp := Digraph(List([1..LargestMovedPoint(G)], x -> [x^p]));
    dq := Digraph(List([1..LargestMovedPoint(G)], x -> [x^q]));

    t1 := NanosecondsSinceEpoch();
    if order = "vole" then
        VoleFind.CanonicalPerm(G, [Constraint.Stabilize(dp, OnDigraphs)]);
        VoleFind.CanonicalPerm(G, [Constraint.Stabilize(dq, OnDigraphs)]);
    else
        RepresentativeAction(G, p, q);
    fi;
    t2 := NanosecondsSinceEpoch();
    stats := rec();
    stats.time := t2 - t1;
    for i in RecNames(expdata) do
        stats.(i) := expdata.(i);
    od;
    stats.order := order;
    stats.filename := filename;
    file := IO_File(Concatenation(filename,".out"), "w");
    IO_Write(file, GapToJsonString(stats));
    IO_Close(file);
end;

randomSet := function(base, size)
    local ret;
    ret := [];
    while Size(ret) < size do
        AddSet(ret, Random(base));
    od;
    return ret;
end;

DoPrimExp := function(l)
    local G, s;
    G := PrimitiveGroup(l[1],l[2]);
    Reset(GlobalMersenneTwister, 1);;
    G := G^Random(SymmetricGroup(LargestMovedPoint(G)));
    s := randomSet([1..l[1]], l[1]/l[3]);
    StabChainMutable(G);

    RunExperiment(G, s, l[4], l[5], l[6], rec(degree := l[1], num := l[2], divide := l[3]), OnSets );
end;

DoMsetExp := function(l)
    local G, comb, action, s;

    comb := Combinations([1..l[1]], l[2]);
    action := ActionHomomorphism(SymmetricGroup(l[1]), comb, OnSets);
    G := Image(action); 
    Reset(GlobalMersenneTwister, 1);;
    G := G^Random(SymmetricGroup(LargestMovedPoint(G)));
    s := randomSet([1..LargestMovedPoint(G)], LargestMovedPoint(G)/l[3]);
    StabChainMutable(G);

    RunExperiment(G, s, l[4], l[5], l[6], rec(baseset := l[1], num := l[2], degree := LargestMovedPoint(G), divide := l[3]), OnSets );
end;

DoGridExp := function(l)
    local G, s;
    G := outerProdGroups(SymmetricGroup(l[1]),SymmetricGroup(l[2]));
    Reset(GlobalMersenneTwister, 1);;
    G := G^Random(SymmetricGroup(LargestMovedPoint(G)));
    s := randomSet([1..l[1]*l[2]], (l[1]*l[2])/l[3]);
    StabChainMutable(G);

    RunExperiment(G, s, l[4], l[5], l[6], rec(g1 := l[1], g2 := l[2], divide := l[3], degree := LargestMovedPoint(G) ), OnSets );
end;

DoGridSetSetExp := function(l)
    local G, s, list;
    G := outerProdGroups(SymmetricGroup(l[1]),SymmetricGroup(l[2]));
    Reset(GlobalMersenneTwister, 1);;
    G := G^Random(SymmetricGroup(LargestMovedPoint(G)));
    list := [1..l[1]*l[2]];
    Shuffle(list);
    s := Set([1,l[3]+1..l[1]*l[2]-l[3]+1], x -> Set(list{[x..x+l[3]-1]}));
    StabChainMutable(G);

    RunExperiment(G, s, l[4], l[5], l[6], rec(g1 := l[1], g2 := l[2], divide := l[3], degree := LargestMovedPoint(G) ), OnSetsSets );
end;

DoGridPermExp := function(l)
    local G,p, q;
    G := outerProdGroups(SymmetricGroup(l[1]),SymmetricGroup(l[2]));
    Reset(GlobalMersenneTwister, l[3]);;
    G := G^Random(SymmetricGroup(LargestMovedPoint(G)));
    p := Product([1,3..LargestMovedPoint(G)-1], x->(x,x+1));
    p := p^Random(SymmetricGroup(LargestMovedPoint(G)));
    q := p^Random(SymmetricGroup(LargestMovedPoint(G)));

    RunPermExperiment(G, p, q, l[4], l[5],rec(g1 := l[1], g2 := l[2], seed := l[3], degree := LargestMovedPoint(G) ));
end;


