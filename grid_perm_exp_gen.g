for i in [10,20..50] do
        for seed in [1..10] do
        for k in [
                   ["gap" ],
                   ["vole" ]
                ] do
            filename := Concatenation("grid-setset-gap-", String(i),"-",String(i),"-",String(seed),"-",String(k[1]),".g");
            PrintTo(filename, "Read(\"../base.g\");\n");
            AppendTo(filename, Concatenation("DoGridPermExp([",String(i),",",String(i),",",String(seed),",\"",k[1],"\",\"",filename,"\"]);\n"));
            AppendTo(filename, "QUIT_GAP();\n");
        od;
        od;
od;
