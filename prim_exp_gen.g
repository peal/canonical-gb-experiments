for i in [10..300] do
    for j in [1..NrPrimitiveGroups(i)] do
    for divider in [2,4,8] do
        for k in [
                   ["CanonicalConfig_FixedMinOrbit", true],
                   ["CanonicalConfig_FixedMinOrbit", false],
                   ["CanonicalConfig_RareOrbitPlusRare", true],
                   ["vole", true]
                ] do
            g := PrimitiveGroup(i,j);
            if not IsNaturalAlternatingGroup(g) and not IsNaturalSymmetricGroup(g) then
                filename := Concatenation("prim-gap-", String(i),"-",String(j),"-",String(divider),"-",String(k[1]), "-" , String(k[2]),".g");
                PrintTo(filename, "Read(\"../base.g\");\n");
                AppendTo(filename, Concatenation("DoPrimExp([",String(i),",",String(j),",",String(divider),",\"",k[1],"\",",String(k[2]),",\"",filename,"\"]);\n"));
                AppendTo(filename, "QUIT_GAP();\n");
            fi;
        od;
    od;
od;
od;
