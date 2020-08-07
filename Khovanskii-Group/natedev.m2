-- This file contains:
-- - useful debugging functions (debugPrintMap and debugPrintAllMaps) 
-- - A new example from Sturmfels chapter 11
-- - Usage of new features

pathToPackage = "./SubalgebraBases.m2"
installPackage(
    "SubalgebraBases",
    FileName=>pathToPackage,
    RunExamples => false,
    RerunExamples => false
    )
export {
    "debugPrintMap",
    "debugPrintAllMaps"
    }

--setRandomSeed("randseed1");

moTest := (subR, n, maxDeg) -> (
    subMap := subR#"PresRing"#"Substitution";
    fullSub := subR#"PresRing"#"FullSub";
    incBase := subR#"PresRing"#"InclusionBase";

    print("-------------------------------------------"); 
    print("-- moTest:");

    for i from 1 to n do(
	
    	testElt :=  sum for deg from 0 to maxDeg list(
	    random(deg, ambient subR)
	    )//subR;
    	print("-------------------------------------------");
    	-- Possible ways to choose a lead term.
    	A := leadTerm testElt;	 
    	B := leadTerm(subR, testElt);
    	C := leadTerm subMap testElt;
    	D := leadTerm fullSub testElt;
	
    	print("LHS:");
    	print(leadTerm fullSub A);
    	print("RHS:");
    	print(leadTerm fullSub B);
	
	-- MO of the upper variables == MO induced by substitution map. 
    	--assert(leadTerm fullSub A == leadTerm fullSub B);
	
	-- If two terms of testElt have the same lead term under the substitution map
	-- and that term happens to be D, this will fail if they happen to cancel out.
	-- The chances of this happening seem to be very low, but we could cherry pick 
	-- examples using the function toricSyz.
	assert(leadTerm fullSub B == D);
    	-- MO of the lower variables == MO of the ambient ring.
    	assert(fullSub C == D);
    	);
    print("-------------------------------------------"); 
    print("-- End moTest"); 
    print("-------------------------------------------"); 

);

 
debugPrintMap := f -> (
    a := gens source f;
    for i from 0 to (length a)-1 do(
	elt := f(a_i);
	print("maps "|toString(a_i)|" to "|toString(elt));
	);    
    );
-- This is by far the easiest way to find the map that you need.
debugPrintAllMaps := subR -> (
    pres := makePresRing(subR);
    print("--------------------------------");
    print("-- PresRing map info dump:");
    print("--------------------------------");
    print("-- ProjectionInclusion:");
    debugPrintMap (pres#"ProjectionInclusion");
    print("-- ProjectionBase:");
    debugPrintMap (pres#"ProjectionBase");
    print("-- InclusionBase:");
    debugPrintMap (pres#"InclusionBase");
    print("-- Substitution:");
    debugPrintMap (pres#"Substitution");
    print("-- FullSub:");
    debugPrintMap (pres#"FullSub");
    print("--------------------------------");
    print("-- End PresRing map info dump.");
    print("--------------------------------");
    );

-- The reason I use a finite field is because that's what the original programmers used
-- when they wrote the tests 20 years ago. I assume the reason they did this was so that
-- they wouldn't accidentally write code that relies on an infinite field.  
kk = ZZ/101


-- This function is from the tests, but here it is slightly modified.
genericminors = (minorsize,rowsize,colsize) -> (
    -- (minorsize) by (minorsize) minors of a generic (rowsize) by (colsize) matrix
    matdim := rowsize * colsize;
    x = symbol x;
    R := kk[x_1 .. x_matdim];
    Temp := genericMatrix(R,x_1,rowsize,colsize);
    --print(Temp);
    gens minors(minorsize,Temp)
    );

autoreduce := (subR, idealGens) -> (
    reduced := for i from 0 to (numcols idealGens)-1 list(
	s := idealGens_(0,i);
	intrinsicReduce(subR, submatrix'(idealGens,,{i}), s)
	);
    reduced
    );

print("toricSyz test (Sturmfels example 11.19)");
t = symbol t;
R = kk[symbol t_1, symbol t_2]
subR = subalgebraBasis subring matrix(R, {{t_1^2, t_1*t_2, t_2^2}});
M = matrix(R, {{t_1^2, t_1*t_2}});
M = subR#"PresRing"#"InclusionBase"(M);
ans = matrix(R,{{-t_2^2, t_1*t_2}, {-t_1*t_2, t_1^2}});
--ans = subR#"PresRing"#"InclusionBase"(ans);
time assert (toricSyz(subR, M) == ans);

------------------------------------------
------------------------------------------
-- Sturmfels example 11.22
------------------------------------------
------------------------------------------
i = 2;
R = kk[symbol t_1, symbol t_2, symbol t_3];
A := {t_1*t_2*t_3, t_1^2*t_2, t_1*t_2^2, t_1^2*t_3, t_1*t_3^2, t_2^2*t_3, t_2*t_3^2};
B := matrix {{t_1^(2*i)*t_2^(2*i)*t_3^(2*i), t_1^((3*i)+2)*t_2*t_3^(3*i)}}
subR = sagbi subring A;
assert((set first entries gens subR) === (set A)); 
-- The algorithm was never guarenteed to generate a minimal set of generators.
-- In this case, the generators are redundant.
-- Can we find minimal generators of the syzygy module? There are supposed to be 7 when i=2.

result := toricSyz(subR, B)

assert(result * (transpose B) == 0);

debugPrintAllMaps subR;
tense := subR#"PresRing"#"TensorRing";
subst := subR#"PresRing"#"Substitution";
proj := subR#"PresRing"#"ProjectionBase";

KA := sagbi subring(leadTerm gens subR);

monoRing := subring(B//KA);
gVars := genVars(monoRing);
result2 := (KA#"PresRing"#"InclusionBase")(result);
result2 = (monoRing#"PresRing"#"InclusionBase")(result2);
result2 = result2 * (transpose gVars);
error "stop";

--moTest(subR, 10, 10);

-- Perhaps the problem is that the function needs to treat K[A] as the ring of scalars.
-- The syzygy module is really an intrinsic ideal? (I.e., can we make use of the function
-- intrinsicReduce to make this work? Autoreduction?)

-- This won't work because  p_10 and p_11 are not in the tensor ring of KA.
-- intrinsicReduce tries to write each term of the given polynomial as a product of an element in the
-- ideal and an element of the subring. We want the ideal to be the ideal generated by the entries of 
-- result2 and the subring to be KA.
-- 
--experimental := autoreduce(KA, transpose result);

M1 := KA#"PresRing"#"InclusionBase";
M2 := monoRing#"PresRing"#"InclusionBase";
coolRing := sagbi subring(M2 M1 (gens KA))
M3 := map(ambient coolRing, ring(result2));
print(M3 result2);
-- The problem is that since p_10 and p_11 aren't involved in the generators, 
-- the ideal technically isn't part of the subalgebra.
final := autoreduce(coolRing, transpose M3 result2);

------------------------------------------
------------------------------------------
-- Other Sturmfels example 
------------------------------------------
------------------------------------------

print("Sturmfels chapter 11 example 11.25.");
M = genericminors(2, 2, 5)
-- (I don't understand where that weight vector comes from.)
BaseRing := kk[x_1..x_10, MonomialOrder => {Weights=> {1,1,2,4,3,9,4,16,5,25}}]
N = sub(M, BaseRing);
subR := subring(N);
pres := subR#"PresRing";
tense = pres#"TensorRing";
g1 = ((p_10-p_12)*(p_12-p_15))_tense;
g2 = ((p_15 + p_13 + p_16)*(p_16 + p_17 + p_18))_tense
G = matrix({{g1, g2}})
-- These agree with what Sturmfels says they should be
print("-- lead terms of G:");
print(leadTerm G)
-- g_3 in Sturmfels.
f = ((p_16*p_18*g1) - (p_12*p_15*g2))_tense

subRSagbi = sagbi subR;
presSagbi = subRSagbi#"PresRing";
tenseSagbi = presSagbi#"TensorRing";

assert(ambient subRSagbi === ambient subR);
assert(tenseSagbi =!= tense);
assert(subR == subRSagbi);
assert(G%subRSagbi == 0);



------------------------------------------
------------------------------------------
-- intrinsicBuchberger test
------------------------------------------
------------------------------------------
m1 := map(tenseSagbi, tense, gens tenseSagbi);
G = m1 G;

result = intrinsicBuchberger(subRSagbi, G)

result = result // subRSagbi;
h = intrinsicReduce(subRSagbi, result, f);

ltH = leadTerm(subRSagbi,h);
ltResult = leadTerm(subRSagbi, result);
print("is h zero? - "|toString(h == 0));

------------------------------------------
------------------------------------------
-- end intrinsicBuchberger test
------------------------------------------
------------------------------------------


-- Normal form demo
 
f = f_tense;
print("-- f:");
print(f);
print("-- f % subR:");
output1 := f % subR;
print(output1);
print("-- f // subR:");
output2 := f // subR;
print(output2);

-- Notice how the flags are set when sagbi fails.
R = kk[x, y]
F = matrix{{x, x*y-y^2, x*y^2}}
subR = sagbi(F,Limit=>30) 
peek subR

-- Notice how the flags are set when sagbi succeeds.
R = kk[y, x]
F = matrix{{x, x*y-y^2, x*y^2}}
subR = sagbi(F) 
peek subR

error "stop"