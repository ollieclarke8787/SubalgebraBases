-- undocumented methods and symbols (for each, consider... does it really need to be exported? should it be documented?)
undocumented {
    "grabLowestDegree",
    "insertPending",
    "SagbiDone"
    -- and so on...
    }

doc ///
   Key
     SubalgebraBases
   Headline
     a package for finding canonical subalgebra bases (aka SAGBI bases)
   Description
    Text
      Let $R=k[f_1,\ldots,f_k]$ denote the subalgebra of the polynomial ring $k[x_1,\ldots,x_n]$ generated by $f_1,\ldots ,f_k.$ We say
      $f_1,\ldots,f_k$ form a {\it subalgebra basis} with respect to a monomial order $<$ if the {\it initial algebra}
      associated to $<$, defined as $in(R) := k[in(f) \mid f \in R],$ is generated by the elements
      $in(f_1), \ldots , in(f_k).$
///

doc ///
   Key
     subalgebraBasis
     (subalgebraBasis,Subring)
     (subalgebraBasis, Matrix)
     (subalgebraBasis, List)
     [subalgebraBasis,Limit]
     [subalgebraBasis,PrintLevel]
     [subalgebraBasis,Strategy]
   Headline
     subalgebra basis (sagbi basis)
   Usage
     N = subalgebraBasis M
     N = subalgebraBasis A
     N = subalgebraBasis L
   Inputs
     A:Subring
     M:Matrix
       of generators for a subring of @ ofClass{PolynomialRing} @
     L:List
       containing generators for a subring of @ ofClass{PolynomialRing} @
     Limit=>ZZ
       a degree limit for the binomial "S-pairs" that are computed internally
     PrintLevel=>ZZ
     Strategy=>String
       not currently used
   Outputs
     N:Matrix
       whose entries form a partial subalgebra basis
   Description
    Text
        The output of this function is generally a partial subalgebra basis. This is unavoidable, since a subalgebra of a polynomial ring, endowed with some polynomial order, need not have a finite subalgebra basis. Here is a quintessential example of this phenomenon.
    Example
      R=QQ[x,y];
      A = subring matrix{{x+y,x*y,x*y^2}};
      subalgebraBasis(A,Limit=>3)
      subalgebraBasis(A,Limit=>10)
    Text
        Nevertheless, a finite subalgebra basis exists for many notable examples. 
        The following computation verifies a special case of Theorem 3.3 in "SAGBI bases with applications to blow-up algebras" by Conca, Herzog, and Valla.
    Example
        R=QQ[t,z_1..z_4,MonomialOrder=>{Weights=>{1,0,0,0,0},Lex}];
        M=matrix{{z_1,z_2,z_3},{z_2,z_3,z_4}};
        I=minors(2,M);
        A=subring(drop(gens R,1) | apply(I_*, p -> t* p))
        subalgebraBasis(A, PrintLevel => 1)
    Text
        Continuing with this example, we illustrate how the setting the option Limit may influence the output.
    Example
        subalgebraBasis(A, PrintLevel => 1, Limit=>1)
        subalgebraBasis(A, PrintLevel => 1, Limit=>6)
    Text
        The output of the last command is a finite Subalgebra Basis, but the computation necessary to verify this fact required setting Limit to at least 7.
    Text
      Some references for Subalgebra bases (aka canonical subalgebra bases, SAGBI bases):

      Kapur, D., Madlener, K. (1989). A completion procedure for computing a canonical basis of a $k$-subalgebra.
      Proceedings of {\it Computers and Mathematics 89} (eds. Kaltofen and Watt), MIT, Cambridge, June 1989,

      Robbiano, L., Sweedler, M. (1990). Subalgebra bases,
      in W.~Bruns, A.~Simis (eds.): {\it Commutative Algebra},
      Springer Lecture Notes in Mathematics {\bf 1430}, pp.~61--87,

      F. Ollivier, Canonical Bases: Relations with Standard bases, finiteness
      conditions and applications to tame automorphisms, in Effective Methods
      in Algebraic Geometry, Castiglioncello 1990, pp. 379-400,
      Progress in Math. {\bf 94} Birkhauser, Boston (1991),

      B. Sturmfels, Groebner bases and Convex Polytopes, Univ. Lecture
      Series 8, Amer Math Soc, Providence, 1996
   Caveat
   SeeAlso
///

doc ///
   Key
     subduction
     (subduction, Matrix, RingElement)
   Headline
     Perform subduction on an element of a ring.
   Usage
     result = subduction(S, f)
   Inputs
     S:Matrix
       Generators of the subalgebra.
     f:RingElement
       An element of the ring containing the entries of S.
   Outputs
     result:RingElement
       f after subduction has been performed.	
   Description
    Text
       The resulting matrix will have no monomials which are in the subalgebra generated by the
       monomials m_i. Each entry of M and the corresponding entry of the result differ by an element of the subalgebra generated by the f_i.
   Caveat
   SeeAlso
///
doc ///
   Key
     (subduction, Subring, RingElement)
   Headline
     Perform subduction on an element of a ring.
   Usage
     result = subduction(subR, f)
   Inputs
     subR:Subring
       must have a previously computed Sagbi basis.
     f:RingElement
       an element of the ambient ring of subR.
   Outputs
     result:RingElement
       f after subduction has been performed.	
   Description
     Text
       Performs subduction. Will throw an error if f is not a member of the ambient ring of subR or subR does not have a cached Sagbi basis.
   SeeAlso
     (symbol %, RingElement, Subring)
///


doc ///
   Key
     (symbol %, RingElement, Subring)
   Headline
     remainder modulo a subring
   Usage
     r = f % A
   Inputs
     f:RingElement
       an element of the ambient ring of $A$ (endowed with some monomial order.)
     A:Subring
   Outputs
     r:RingElement
       The normal form of f modulo $A$
   Description
     Text
       The result $r$ is zero if and only if $f$ belongs to $A$.
     Example
       R = QQ[x1, x2, x3];
       A = subring {x1+x2+x3, x1*x2+x1*x3+x2*x3, x1*x2*x3, (x1-x2)*(x1-x3)*(x2-x3)} --usual invariants of A_3
       f = x1 + x2 + 2*x3
       f % A
       g = x1^2*x2 + x2^2*x3 + x3^2*x1
       g % A
   SeeAlso
    Subring
    subring
///


doc ///
   Key
     Subring
   Description
     Text
       An instance of the type Subring consists an ambient polynomial ring, a matrix of generators, and a cache Table that stores computations relevant for subalgebra bases. The cache table facillitates operations such as membership testing.
   Caveat
   SeeAlso
       subring
       (gens, Subring)
       (ambient, Subring)
       subalgebraBasis
///

doc ///
 Key
  liftedPresentation
  (liftedPresentation,Subring)
 Headline
  Compute a lifted lifted presentation of a subring
 Usage
  I = liftedPresentation A
 Inputs
  A:Subring
 Outputs
  I:Ideal
 Description
  Text
    Let $A$ be a subring of a ring $R$ with generators $g_i$ and let $S$ be the ring $R[e_1, \dots, e_n]$. This method returns the ideal in $S$ generated by elements of the form $g_i - e_i$
  Example
    R = ZZ/101[a..c];
    G = matrix {{a+b+c, a*b+a*c+b*c, a*b*c}};
    A = subring G;
    print("A");
    liftedPresentation A
    print("B");
 SeeAlso
  Subring
  subring
///

doc ///
  Key
    setWeight
    (setWeight,Subring, List)
  Headline
    sets weight for ambient ring of a Subring
  Usage
    setWeight(A, W)
  Inputs
    A:Subring
    W:List
      a weight vector of the ambient ring of A
  Description
    Text
      Setting the weight vector allows the Subring to construct a lifted weight 
      vector which is applied to the presentation ring of A.
      In order to apply this weight vector to the presentation of A successfully, 
      setWeight must be used before presentationRing and presentation.
      In this example we set the weight of ambient ring of the Pl\"ucker algebra
      for Grassmannian(2, 4) such that the leading term of any maximal minor is 
      the leading term.
    Example
      (n, k) = (4, 2);
      D = toList apply((1,1) .. (k,n), (i,j) -> n*k - (n-j)*(i-1)) -- Diagonal weight vector 
      R = QQ[x_(1,1) .. x_(k,n)];
      X = transpose genericMatrix(R, n, k);
      M = matrix { for J in subsets(n, k) list det X_J };
      A = subring M; -- Plucker algebra
      setWeight(A, D)
      S = presentationRing(A, QQ[apply(toSequence\subsets(n, k), J -> p_J)])
      I = presentation A
      leadTerm(1, I)
  SeeAlso
    Subring
    subring
    liftedPresentation
    getWeight
    presentationRing
    presentation
///

-* --This documentation doesn't work
doc ///
  Key
    (presentation, Subring)
  Headline
    get generators of the presentation
  Usage
    M = presentation A
  Inputs
    A:Subring
  Outputs
    M:matrix
      generators of the presentation ideal
  Description
    Text
      The presentationRign $pR$ of a subring $A$ has one generator for each
      generator of the subring. The presentation ideal is the kernel of the 
      map sending each variable of $pR$ to its corresponding generator of $A$. 
    Example
      R = QQ[x];
      A = subring({x, x^2, x^3});
      presentation A
      presentationRing A / ideal presentation A -- isomorphic to A
  SeeAlso
    Subring
    subring
    liftedPresentation
    presentationRing
    setWeight
///
*-

doc ///
  Key
    presentationRing
    (presentationRing, Subring, Ring)
    (presentationRing, Subring)
  Headline
    initialize the presentation ring
  Usage
    P = presentationRing(A, S)
  Inputs
    A:Subring
    S:Ring
      optional, a template ring to be used as the presentation ring
  Outputs
    P:Ring
      the presentation ring
  Description
    Text
      If no template ring $S$ is provided then presentationRing will generate a ring using the indexed variables $e_i$ where $i$ begins indexing from $0$.
    Example
      R = QQ[x, y];
      A = subring({x+y, x-y, x, y});
      pR = presentationRing A;
      describe pR
      presentation A
    Text
      If a template ring $S$ is provided, the number of generators of $S$ must match the number generators of the subring $A$.
    Example
      R = QQ[x1, x2, y1, y2];
      A = subring {x1*y1, x1*y2, x2*y1, x2*y2};
      S = QQ[p_(1,1), p_(1,2), p_(2,1), p_(2,2), MonomialOrder => {Eliminate 1}];
      pR = presentationRing(A, S);
      pR === S
      presentation A
    Text
      If $setWeight(A, W)$ is used then the presentationRing $pR$ will differ from template ring $S$.
      The weights used in the term order for $pR$ are the induced weights from $W$.
      The induced weight of a generator $e_i$ of $pR$ is the weight of leading term of the $i^{th}$
      generator of the subring $A$.  
    Example
      R = QQ[x, y, z];
      A = subring({x+y+z, x-y-z, x, y, z});
      setWeight(A, {0, 1, 2}); --weight x=0, y=1, z = 2
      pR = presentationRing A;
      pR_0^2 > pR_3^3 
    Text
      Note that to use setWeight, it must proceed presentationRing      
  SeeAlso
    Subring
    subring
    liftedPresentation
    presentation
    setWeight
///

doc ///
  Key
    hasComputedSagbi
    (hasComputedSagbi, Subring)
  Headline
    Check if an instance of Subring has a computed Sagbi basis. 
  Usage
    ans = hasComputedSagbi(subR)
  Inputs
    subR:Subring
  Outputs
    ans:Boolean
      Whether or not a Sagbi basis is present in the cache of subR.
  Description
    Text
      This function is used to check whether a call to subalgebraBasis has succeeded or failed.
    Example
      BaseRing = QQ[y,x]
      subR = subring(matrix{{x, x*y-y^2, x*y^2}})
      hasComputedSagbi subR
      subalgebraBasis subR
      hasComputedSagbi subR
  SeeAlso
    Subring
    subring
    subalgebraBasis
    gensSagbi
///

doc ///
  Key
    gensSagbi
    (gensSagbi, Subring)
  Headline
    Return the previously computed Sagbi basis of an instance of Subring.
  Usage
    S = gensSagbi(subR)
  Inputs
    subR:Subring
  Outputs
    S:Matrix
      A one row matrix whose entries are a Sagbi basis for subR. 
  Description
    Text
      This will throw an error unless a previous execution of subalgebraBasis(subR) has succeeded. 
    Example
      baseRing = QQ[a,b,c];
      subR = subring(matrix{{a+b+c-1, a^2+b^2+c^2-a, a^3+b^3+c^3-b}});
      subalgebraBasis subR;
      gens subR
      gensSagbi subR
  SeeAlso
    Subring
    subring
    subalgebraBasis
    hasComputedSagbi
///

doc ///
   Key
     subring
     (subring, List)
     (subring, Matrix)
   Headline
     Constructs a subring of a polynomial ring
   Usage
     A = subring M
   Inputs
     M:Matrix
       A one row matrix whose entries come from @ ofClass{PolynomialRing} @
     L:List 
       whose entries come from @ ofClass{PolynomialRing} @
   Outputs
     A:Subring
   Description
    Text
      A @ ofClass{Subring} @ stores the ambient polynomial ring, a matrix of the given generators, and a cache table with intermediate
    Example
       R = QQ[x];
       A = subring {x^4+x^3, x^2+x}
       member(x^3+x^2, A)
   Caveat
     The ambient ring and the generators are immutable values. A method for @TO "==" @ is currently not implemented.
   SeeAlso
     Subring
///
