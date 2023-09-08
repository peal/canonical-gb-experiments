for i in [10..100] do
        for divider in [2,4,8] do
        for k in [
                   ["CanonicalConfig_FixedMinOrbit", true],
                   ["CanonicalConfig_FixedMinOrbit", false],
                   ["CanonicalConfig_RareOrbitPlusRare", true],
	           ["vole", true]
                ] do
            filename := Concatenation("grid-gap-", String(i),"-",String(i),"-",String(divider),"-",String(k[1]),"-",String(k[2]),".g");
            PrintTo(filename, "Read(\"../base.g\");\n");
            AppendTo(filename, Concatenation("DoGridExp([",String(i),",",String(i),",",String(divider),",\"",k[1],"\",",String(k[2]),",\"",filename,"\"]);\n"));
            AppendTo(filename, "QUIT_GAP();\n");
        od;
        od;
od;
