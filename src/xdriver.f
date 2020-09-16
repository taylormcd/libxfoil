      subroutine xdriver(ncoor,x_coor,y_coor,ccl,ccd)

      PARAMETER (IQX=286, IWX=36, IPX=5, ISX=2)
      PARAMETER (IBX=572)
      PARAMETER (IZX=322)
      PARAMETER (IVX=229)
      PARAMETER (NAX=800,NPX=8,NFX=128)
      CHARACTER*32 LABREF
      CHARACTER*64 FNAME, PFNAME, PFNAMX, ONAME, PREFIX
      CHARACTER*48 NAME, NAMEPOL, CODEPOL, NAMEREF
      CHARACTER*80 ISPARS
      LOGICAL OK,LIMAGE,
     &        LGAMU,LQINU,SHARP,LVISC,LALFA,LWAKE,LPACC,
     &        LBLINI,LIPAN,LQAIJ,LADIJ,LWDIJ,LCPXX,LQVDES,LQREFL,
     &        LQSPEC,LVCONV,LCPREF,LCLOCK,LPFILE,LPFILX,LPPSHO,
     &        LBFLAP,LFLAP,LEIW,LSCINI,LFOREF,LNORM,LGSAME,
     &        LPLCAM, LQSYM ,LGSYM , LQGRID, LGGRID, LGTICK,
     &        LQSLOP,LGSLOP, LCSLOP, LQSPPL, LGEOPL, LGPARM,
     &        LCPGRD,LBLGRD, LBLSYM, LCMINP, LHMOMP
      LOGICAL LPLOT,LSYM,LIQSET,LCLIP,LVLAB,LCURS,LLAND
      LOGICAL LPGRID, LPCDW, LPLIST, LPLEGN
      LOGICAL TFORCE
      REAL NX, NY, MASS, MINF1, MINF, MINF_CL, MVISC, MACHP1
      INTEGER RETYP, MATYP, AIJPIV
      CHARACTER*1 VMXBL

      REAL W1(6*IQX),W2(6*IQX),W3(6*IQX),W4(6*IQX),
     &     W5(6*IQX),W6(6*IQX),W7(6*IQX),W8(6*IQX)
      REAL BIJ(IQX,IZX), CIJ(IWX,IQX)

      COMMON/CR01/ VERSION
      COMMON/CC01/ FNAME,
     &             NAME,ISPARS,ONAME,PREFIX,
     &             PFNAME(NPX),PFNAMX(NPX),
     &             NAMEPOL(NPX), CODEPOL(NPX),
     &             NAMEREF(NPX)
      COMMON/QMAT/ Q(IQX,IQX),DQ(IQX),
     &             DZDG(IQX),DZDN(IQX),DZDM(IZX),
     &             DQDG(IQX),DQDM(IZX),QTAN1,QTAN2,
     &             Z_QINF,Z_ALFA,Z_QDOF0,Z_QDOF1,Z_QDOF2,Z_QDOF3
      COMMON/CR03/ AIJ(IQX,IQX),DIJ(IZX,IZX)
      COMMON/CR04/ QINV(IZX),QVIS(IZX),CPI(IZX),CPV(IZX),
     &             QINVU(IZX,2), QINV_A(IZX)
      COMMON/CR05/ X(IZX),Y(IZX),XP(IZX),YP(IZX),S(IZX),
     &             SLE,XLE,YLE,XTE,YTE,CHORD,YIMAGE,
     &             WGAP(IWX),WAKLEN
      COMMON/CR06/ GAM(IQX),GAMU(IQX,2),GAM_A(IQX),SIG(IZX),
     &             NX(IZX),NY(IZX),APANEL(IZX),
     &             SST,SST_GO,SST_GP,
     &             GAMTE,GAMTE_A,
     &             SIGTE,SIGTE_A,
     &             DSTE,ANTE,ASTE
      COMMON/CR07/ SSPLE,
     &             SSPEC(IBX),XSPOC(IBX),YSPOC(IBX),
     &             QGAMM(IBX),
     &             QSPEC(IBX,IPX),QSPECP(IBX,IPX),
     &             ALGAM,CLGAM,CMGAM,
     &             ALQSP(IPX),CLQSP(IPX),CMQSP(IPX),
     &             QF0(IQX),QF1(IQX),QF2(IQX),QF3(IQX),
     &             QDOF0,QDOF1,QDOF2,QDOF3,CLSPEC,FFILT
      COMMON/CI01/ IQ1,IQ2,NSP,NQSP,KQTARG,IACQSP,NC1,NNAME,NPREFIX
      COMMON/CR09/ ADEG,ALFA,AWAKE,MVISC,AVISC,
     &             XCMREF,YCMREF,
     &             CL,CM,CD,CDP,CDF,CL_ALF,CL_MSQ,
     &             PSIO,CIRC,COSA,SINA,QINF,
     &             GAMMA,GAMM1,
     &             MINF1,MINF,MINF_CL,TKLAM,TKL_MSQ,CPSTAR,QSTAR,
     &             CPMN,CPMNI,CPMNV,XCPMNI,XCPMNV
      COMMON/CI03/ NCPREF, NAPOL(NPX), NPOL, IPACT, NLREF,
     &             ICOLP(NPX),ICOLR(NPX),
     &             IMATYP(NPX),IRETYP(NPX), NXYPOL(NPX),
     &             NPOLREF, NDREF(4,NPX)
      COMMON/CR10/ XPREF(IQX),CPREF(IQX), VERSPOL(NPX),
     &             CPOLXY(IQX,2,NPX),
     &             MACHP1(NPX),
     &             REYNP1(NPX),
     &             ACRITP(NPX),XSTRIPP(ISX,NPX)

      COMMON/CC02/ LABREF

      COMMON/CR11/ PI,HOPI,QOPI,DTOR
      COMMON/CR12/ CVPAR,CTERAT,CTRRAT,XSREF1,XSREF2,XPREF1,XPREF2
      COMMON/CI04/ N,NB,NW,NPAN,IST,KIMAGE,
     &             ITMAX,NSEQEX,RETYP,MATYP,AIJPIV(IQX),
     &             IDEV,IDEVRP,IPSLU,NCOLOR,
     &             ICOLS(ISX),NOVER, NCM,NTK
      COMMON/CR13/ SIZE,SCRNFR,PLOTAR, PFAC,QFAC,VFAC,
     &             XWIND,YWIND,
     &             XPAGE,YPAGE,XMARG,YMARG,
     &             CH, CHG, CHQ,
     &             XOFAIR,YOFAIR,FACAIR, XOFA,YOFA,FACA,UPRWT,
     &             CPMIN,CPMAX,CPDEL,
     &             CPOLPLF(3,4),
     &             XCDWID,XALWID,XOCWID
      COMMON/CL01/ OK,LIMAGE,SHARP,
     &             LGAMU,LQINU,LVISC,LALFA,LWAKE,LPACC,
     &             LBLINI,LIPAN,LQAIJ,LADIJ,LWDIJ,LCPXX,LQVDES,LQREFL,
     &             LQSPEC,LVCONV,LCPREF,LCLOCK,LPFILE,LPFILX,LPPSHO,
     &             LBFLAP,LFLAP,LEIW,LSCINI,LFOREF,LNORM,LGSAME,
     &             LPLCAM,LQSYM ,LGSYM,
     &             LQGRID,LGGRID,LGTICK,
     &             LQSLOP,LGSLOP,LCSLOP,LQSPPL,LGEOPL,LGPARM,
     &             LCPGRD,LBLGRD,LBLSYM,
     &             LPLOT,LSYM,LIQSET,LCLIP,LVLAB,LCURS,LLAND,
     &             LPGRID,LPCDW,LPLIST,LPLEGN,
     &             LCMINP, LHMOMP
      COMMON/CR14/ XB(IBX),YB(IBX),
     &             XBP(IBX),YBP(IBX),SB(IBX),SNEW(4*IBX),
     &             XBF,YBF,XOF,YOF,HMOM,HFX,HFY,
     &             XBMIN,XBMAX,YBMIN,YBMAX,
     &             SBLE,CHORDB,AREAB,RADBLE,ANGBTE,
     &             EI11BA,EI22BA,APX1BA,APX2BA,
     &             EI11BT,EI22BT,APX1BT,APX2BT,
     &             THICKB,CAMBRB,
     &     XCM(2*IBX),YCM(2*IBX),SCM(2*IBX),XCMP(2*IBX),YCMP(2*IBX),
     &     XTK(2*IBX),YTK(2*IBX),STK(2*IBX),XTKP(2*IBX),YTKP(2*IBX)

      COMMON/CR15/ XSSI(IVX,ISX),UEDG(IVX,ISX),UINV(IVX,ISX),
     &             MASS(IVX,ISX),THET(IVX,ISX),DSTR(IVX,ISX),
     &             CTAU(IVX,ISX),DELT(IVX,ISX),USLP(IVX,ISX),
     &             GUXQ(IVX,ISX),GUXD(IVX,ISX),
     &             TAU(IVX,ISX),DIS(IVX,ISX),CTQ(IVX,ISX),
     &             VTI(IVX,ISX),
     &             REINF1,REINF,REINF_CL,ACRIT,
     &             XSTRIP(ISX),XOCTR(ISX),YOCTR(ISX),XSSITR(ISX),
     &             UINV_A(IVX,ISX)
      COMMON/CI05/ IBLTE(ISX),NBL(ISX),IPAN(IVX,ISX),ISYS(IVX,ISX),NSYS,
     &             ITRAN(ISX)
      COMMON/CL02/ TFORCE(ISX)
      COMMON/CR17/ RMSBL,RMXBL,RLX,VACCEL
      COMMON/CI06/ IMXBL,ISMXBL
      COMMON/CC03/ VMXBL
      COMMON/CR18/ XSF,YSF,XOFF,YOFF,
     &             XGMIN,XGMAX,YGMIN,YGMAX,DXYG,
     &             XCMIN,XCMAX,YCMIN,YCMAX,DXYC,DYOFFC,
     &             XPMIN,XPMAX,YPMIN,YPMAX,DXYP,DYOFFP,
     &             YSFP,GTICK
      COMMON/VMAT/ VA(3,2,IZX),VB(3,2,IZX),VDEL(3,2,IZX),
     &             VM(3,IZX,IZX),VZ(3,2)
      EQUIVALENCE (Q(1,1 ),W1(1)), (Q(1,7 ),W2(1)),
     &            (Q(1,13),W3(1)), (Q(1,19),W4(1)),
     &            (Q(1,25),W5(1)), (Q(1,31),W6(1)),
     &            (Q(1,37),W7(1)), (Q(1,43),W8(1))

      EQUIVALENCE (VM(1,1,1),BIJ(1,1)), (VM(1,1,IZX/2),CIJ(1,1))

      integer ncoor
      real x_coor(ncoor),y_coor(ncoor)
      real ccl,ccd
      integer i
c Set the coorinates:
      NB = ncoor
      do 5 i=1,ncoor
         xb(i) = x_coor(i)
         yb(i) = y_coor(i)
 5    continue

! Set alpha,Mach,RE:
      refin1 = 1e6
      minf1 = 0.01
      adeg  = 1.0

c Solve
      call oper()

c Copy cl,cd
      ccl = cl
      ccd = cd
c      ccl = 0.0
c      ccd = 0.0
c      do 5 i=1,ncoor
c         ccl = ccl + x_coor(i)
c         ccd = ccd + y_coor(i)
c 5       continue

         end
