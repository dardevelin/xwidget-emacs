;;; hanja-jis.el --- Quail package for inputting Korean Hanja (JISX0208)  -*-coding: iso-2022-7bit;-*-

;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;   2006, 2007, 2008, 2009, 2010
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Keywords: multilingual, input method, Korean, Hangul

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'quail)

(quail-define-package
 "korean-hanja-jis" "Korean" "$B4A(B2" t
 "2$(C9z=D(BJIS$B4A;z(B: $B3:aD$(CGO4B(B $B4A;z$(C@G(B $B1$$(C@;(B $(CGQ1[(B2$(C9z$B<0$(C@87N(B $B8F=P$(CGO?)(B $BA*Z$(B"
 nil nil nil nil nil nil t)

(quail-define-rules
 ("rk"	"$B1]2>2@2A2B2C2D2E2G2H2K2M2N2Q2T2W2X2`2o3976P$PqQ+RjS'[H[I`]aPcwgWhSkEkhlKlhmF(B")
 ("rkr"	"$B3F3J3L3P3Q3S3U5Q5S9oH9RJS>T=WmXBZ([d]W`Bk4l;r((B")
 ("rks"	"$B064%4&4)4/43444B4G4H4J4N4V:&:):1?{U!XLYc[8[K[Y[e`CarcCecgek]s*su(B")
 ("rkf"	"$B2p3e3i3k3l7GP"[+brcqf;iypbpv(B")
 ("rka"	"$B4*4.46484:4;4E4F4U7g848::0QaT,T0VHY"Y~\m]>^@aQbWeHiTm^nGoHs|(B")
 ("rkq"	"$B2!389C9gL(R:b5fpo^(B")
 ("rkd"	"$B2,3`6/607D9/959>9G9K9P9V9]9_9dFzP6Q,S3U*V>XMY,[:[|aEbee,eZf5i(jvlora(B")
 ("ro"	"$B2B2U2p2r2~3'3)3+3,3.313435383;8DP"P$PCQsXAXhYb\4^taNb5k;(B")
 ("ror"	"$B5RS=(B")
 ("rod"	"$B9#99dkf=f>o3(B")
 ("ri"	"$B2X(B")
 ("rir"	"$BnS(B")
 ("rj"	"$B5n5o5p5q5r5t5w5x<V?x?~P`PbTRZ!Z)Z*]0_Yc@d(gplwn1nSnj(B")
 ("rjs"	"$B4%6R7o7r7z80X4Ykg'iJkim!qZ(B")
 ("rjf"	"$B3i7G7f8pC4KqPu[?[\]ccq(B")
 ("rja"	"$B4;7p7u8!84Q-QxQyQzQ{\}b[g@sX(B")
 ("rjq"	"$B5h619e=&Qg(B")
 ("rp"	"$B7F7GPuX\br(B")
 ("rur"	"$B2>3J3V3W7b7cPqYH\|g-h#k.ojqnr/rps&(B")
 ("rus"	"$B3_3o7x8#8$8(8*8+8/G{KzLzPWVtWz[G`Fa+d*f0l$s$(B")
 ("ruf"	"$B5K7@7h7i7k7mLRQSY1YIYMe~r!(B")
 ("rua"	"$B3y7s8,XDY:]>d/heni(B")
 ("ruq"	"$B3fKKXDnw(B")
 ("rud"	"$B5~6%6*6-6@6C797B7D7I7J7P7T7U7Y7Z7[7_9.999<9E9L:"P7Q?QDQHQmR&R'S+WMX]\{_i`{a9a[b~e%e4e;fVfzh3krmKmtpopts](B")
 ("rP"	"$B2|3#3&3,5(787<7@7K7L7N7O7Q7R7W7\:fFOU|W@X)[G^da8b#c4d"e;eki)kSl0r!s1(B")
 ("rh"	"$B6l8E8G8H8I8K8N8O8S8T8V8Z8[8\8]9F9M9Q9b9i9p;)<J?,C!ONPFQYQjRmZ?ZJZ^[W[][^\I\_]xa`b(bPb\cLd2f*f6fxiVjCk8kFkUlKmcn~pQrurzsi(B")
 ("rhr"	"$B6J9p9r9s9tC+H#S-ZO[g\`mXq~(B")
 ("rhs"	"$B:$:%:+:-:.TgVBW}[~^xhBjnrArJs.(B")
 ("rhf"	"$B3j9|\K]qs3(B")
 ("rhd"	"$B6!6&62636u8x8y9&9)95969WPeW0YJ[}\Jd3iOi^i_lop_(B")
 ("rhk"	"$B1;2I2J2L2[2]2a8S8X8YFiTFTnTrXyfxhTixjglvpy(B")
 ("rhkr"	"$B3G3TZ2Z<[v\Zayb_oWp9(B")
 ("rhks"	"$B4'4142474=4>4C4I4P4Q4S4X4[4\6z?{P%QN]Y^ub9eEeGf%k7oQopsA(B")
 ("rhkf"	"$B3g3hH&I0Qi[XfZ(B")
 ("rhkd"	"$B3H6)688w9-9[9\T]W"Z2[%[&[Z^+bhc~d!e&e-fykToJ(B")
 ("rho"	"$B3]757SS%XyYL[Jjh(B")
 ("rhl"	"$B2q2t2u2x2z2}3!P*PzTUW_XC\G`skK(B")
 ("rhlr"	"$Bg2qE(B")
 ("rhld"	"$B9(9I9O9l^3mDo)(B")
 ("ry"	"$B3I3P3S3z5j6#6+6,65666:6>8r8s9'9*9;9J9Y9Z;->7R{UHYxZJ\r_$`Db)c#c\fKg1i`m]n[q-qaqb(B")
 ("rn"	"$B11192$2%2*3C555V5W5X5_5a5d5e5f5l5q6e6f6g6h6i6j6k6m6n6o6p6q7)8{8}9$949=9B9XC!G#H7KUP}QJR"R?RkSRU=UBUdVOV}V~WaW|XvY+Yl[M[N]?]X]\a.aLbZc`d@gOgQgqhgiUjMjdk2kMkpmsn)n9nlplq'qDq\r-szs}(B")
 ("rnr"	"$B5E5F5G6I9m9qSxT"[xdxkqlr(B")
 ("rns"	"$B7/727374[ub0b1c[f:je(B")
 ("rnf"	"$B6~7!7"KYPcRPVA(B")
 ("rnd"	"$B5\5]5gcVm;(B")
 ("rnjs"	"$B4+4,5s7q7t7w7}7~8"R%R0RKT!X+[{\^bGe<ipq"(B")
 ("rnjf"	"$B7!OOP-RP`Um,om(B")
 ("rnp"	"$B4y5"50B|DYQ\R<[z]$]Eb'dOgLkLlnm,q9q?(B")
 ("rnl"	"$B5"5.5455S@[z]Eb's}(B")
 ("rnlr"	"$BDOVn(B")
 ("rb"	"$B0*1.5,5j6+6e7=7>:"DPTwYdYw\\b#bkcad}eYj_lbm|oaqDr-(B")
 ("rbs"	"$B556Q6]d0nbsKs}(B")
 ("rbf"	"$B5L(B")
 ("rmr"	"$B2D3W6K7`7a7d9nP4QnUqV![yh{n<(B")
 ("rms"	"$B6O6P6R6T6Z6\6`6a:,Xi\]`wbbhAk3ncq<(B")
 ("rmf"	"$B7@k?(B")
 ("rma"	"$B6S6W6X6Y6^6_6b8i:#SaZ"jPsX(B")
 ("rmq"	"$B075Z5^5b5h5i5kV)(B")
 ("rmd"	"$B919NOJOKQ>Wqbb(B")
 ("rl"	"$B0k4k4l4o4p4q4s4t4v4w4z4{4|4}4~5!5$5%5&5'5*5-5/5253585;5=5@5o778J8k8p:j:k:l<(B6H)IIL'P4PXQCQpSOSZT-TtV?W1YVZ\Zz[.[9[L[w\H]c]f]k^?aCc2cEe:f3f4fMk+k1kxl1leq@qVqgr?sJ(B")
 ("rlr"	"$B5J(B")
 ("rls"	"$B6[(B")
 ("rlf"	"$B5H5K5MPKYI(B")
 ("rla"	"$B6b(B")
 ("Rlr"	"$B5J(B")
 ("sk"	"$BF`FaFqQ5U1XoY.Y<Y=[kdy(B")
 ("skr"	"$BBz(B")
 ("sks"	"$BCHFqZ:_kl_(B")
 ("skf"	"$BFhYT^:(B")
 ("ska"	"$BCKFnFoSGU3n((B")
 ("skq"	"$BG<jU(B")
 ("skd"	"$BG9L<[((B")
 ("so"	"$BBQF`FbFwG5G6G=mr(B")
 ("sid"	"$B>nUP(B")
 ("su"	"$B=wY<Y=h'(B")
 ("sus"	"$BG/G2bzmY(B")
 ("suf"	"$BYT^:(B")
 ("sua"	"$BG0WwY@\,(B")
 ("suq"	"$B@]G1Ypm:oR(B")
 ("sud"	"$BG+Sf_?`Xfd(B")
 ("sP"	"$BG)Zc(B")
 ("sh"	"$BEXE[E\G>RsUWVfW8`obug*gBqN(B")
 ("shd"	"$BG;G?G@Q/(B")
 ("shk"	"$B<6(B")
 ("shl"	"$BG:G>X=g*q/(B")
 ("sy"	"$BE.G"U>Yz\vo?o_r)(B")
 ("sn"	"$BfU(B")
 ("sns"	"$BUD(B")
 ("snf"	"$BRefmkD(B")
 ("sb"	"$BI3WY`=nf(B")
 ("sbr"	"$BWYjHjI(B")
 ("smd"	"$BG=(B")
 ("sl"	"$BE%FtG)G*Wb_>_Pg7(B")
 ("slr"	"$BE.F?(B")
 ("slf"	"$BFtWbZc(B")
 ("sla"	"$BDBWl(B")
 ("ek"	"$BB?BgCcTl(B")
 ("eks"	"$B1_C"C0C1C4C6C;C<C=C@CACCCDCECGCICJFNFXP9SET%WAXIXUZR\g^Z`NaUeKh[iijXj{j|nBs((B")
 ("ekf"	"$BC#RtU'WeZ%_}`\m}orpZpg(B")
 ("eka"	"$BC4C8C9C?CLF^S7S8T`XkY?]__,_8abb>g<i!k)k}q5(B")
 ("ekq"	"$B7#EkEzF'Quh)(B")
 ("ekd"	"$BE^EbEdEvE|F2F5Q8Vq[c\+^oaDbUc'j0j;j}oFs^(B")
 ("eo"	"$B10BPBRBSBTBWB^B_BbBcBeBgFXT2UtVhZ,Z-`^gJi7o>p0(B")
 ("ejr"	"$BFAW\(B")
 ("eh"	"$B0p?^D)D7EHEIEKELEOEQERESETEUEYE]EaEgEhEiEmEnEpEqEsExE~F(F+F3F:F;R[T&V:Y[Y\YqZ.[7[m\*]%]9^9^mbQcKe6eBeCe{h8h9k/lum%mmokpkqC(B")
 ("ehr"	"$B<3FBFDFEFFFGFHFI`1`9`We{l&qqsb(B")
 ("ehs"	"$B=cFUFWFXFYFZF[F\Z}_wa&n,q+(B")
 ("ehf"	"$BFMF\Rt[S(B")
 ("ehd"	"$B4R6ME_E`ElEoF!F/F0F1F4F6F7F8F9F<Q*\u_.aVdig^gtr<s)sj(B")
 ("en"	"$B1%3u?`EMENEZEwF&F,FIP5Y5ceflh:iQjEjFl&nFr((B")
 ("ens"	"$BFVF[F\F_g=n,(B")
 ("emr"	"$BF@(B")
 ("emd"	"$BEPEtEuEyF#F%F*F-VS\t^naVc$d[d\eX(B")
 ("fk"	"$B;IMeMfMgSIXqapaziGn6oUozq`(B")
 ("fkr"	"$B3J3ZMlMmMnMoS>\[_``8`dqQ(B")
 ("fks"	"$BMpMqMsMvP,UO]3_Q_s`%k&oVolsB(B")
 ("fkf"	"$BQoSIT?T@dzme(B")
 ("fka"	"$BMrMtMuMwQ0U:Z0]4dWeqe|k"k5nN(B")
 ("fkq"	"$B@"O9YG[VgDgEoM(B")
 ("fkd"	"$BBlBmO-O/O1O2O5O:[-`f`gh>j'lplt(B")
 ("fo"	"$BPTWR(B")
 ("fod"	"$BNd(B")
 ("fir"	"$BN+N,Z6a@(B")
 ("fid"	"$BL:N+N<N>NBNCNHNINJNLPoQ@QZSJdmdnjllpltmQmRr4(B")
 ("fu"	"$B023BEWK{N7N8N9NeNoO$O?Q6R/S:W*[q]-`4`5avbjdze8eFg0gFh-i<iCiZjBoLocqfqk(B")
 ("fur"	"$BNONqNrV'[6]+],]._Ma|c*m`mapNr/(B")
 ("fus"	"$BNgNmNxNyNzN{N}N~O!O"O#SXXxYcZ;\Bf_gHmSo:rY(B")
 ("fuf"	"$BNsNtNuNvQXY`^0(B")
 ("fua"	"$B3yNwN|R=T~ZL_2_R(B")
 ("fuq"	"$BND`Zr'(B")
 ("fud"	"$BNNNaNbNfNgNhNjNkNmNnNpSz]2_:f9fYiYpMryst(B")
 ("fP"	"$BK-NcNiNlc9h-nTp1rg(B")
 ("fh"	"$B02:mH'IyN:O%O&O'O(O)O*O+O4O7R)S$Y}[E_#_3_I_N`$atb:gbgcgdiCmJmboNoOq!qfrisC(B")
 ("fhr"	"$B3Q9w</C+NPO<O=O?[rbqc3m\(B")
 ("fhs"	"$BO@^M(B")
 ("fhd"	"$BBlBmN5N6O.O6O8S/T;Tb[0\Y`|dFiDp/(B")
 ("fhl"	"$B@%MjMkN]O(Q4T^Z']*azb}d]f#fPi2iAkQlO(B")
 ("fy"	"$BN;N=N@NANENFNKUlW!Y|["_yegfXhznRoAs>(B")
 ("fyd"	"$BN5N6iD(B")
 ("fn"	"$B<HN^N_O,O0O3Q$\l`4`5aqdMe_e`j3jzo;o{qp(B")
 ("fnl"	"$BN^^%(B")
 ("fb"	"$BI5LxN-N.N/N0N1N2N\N]N_N`R-ShT^W!ZX\X^%_H`eaneYe`g{nvo9pEq:(B")
 ("fbr"	"$BN&O;R-Y$hz(B")
 ("fbs"	"$BNQNXO@PUVFVG\2^MeE(B")
 ("fbf"	"$B7*N'N(N*XKdE(B")
 ("fbd"	"$BN4VWcc(B")
 ("fmr"	"$BO>P>pU(B")
 ("fma"	"$BQ[W)XnhR(B")
 ("fmd"	"$B0=I)KSN?NGNMVE\AhQi3(B")
 ("fl"	"$B3=8qA8C,DsKiMxMyMzM{M|M}M~N!N"N#N$N%NRNoP]P^X&Xm_"`4`5crdaf@h.h=imjBkJl>nZqkr5rEsW(B")
 ("fls"	"$BNUNYNZN[RgX'iBm8m9nC(B")
 ("fla"	"$BNSNTNVNWaepC(B")
 ("flq"	"$B3^N)N3g~(B")
 ("ak"	"$BGMGOK`KaKbKcSWU@Vw`uadb{j1j2(B")
 ("akr"	"$BGyG|KFKkKlLNUki8(B")
 ("aks"	"$B17HTHUHZJZK|K}K~L!L"OQRDRXV]VoW>W?Xp^`_TbVe\h_jGktm*mNo8q=r#(B")
 ("akf"	"$BKuKvKwbFcBg}k$p\pi(B")
 ("akd"	"$BK4K:K;K>LQLVX1f&f(gjh+hOj<j=nzr3(B")
 ("ao"	"$BGMG^G_G`GaGcGdJrK?KdKeKfKgKhL%Ug`pgugvlNn2pJ(B")
 ("aor"	"$BG|G~I4L.`Sfwl=lBoyq^sN(B")
 ("aod"	"$B0:K(LALTLUQ3]ba0hNsf(B")
 ("aur"	"$BQLQQVm]qf2k,(B")
 ("aus"	"$BJYL2LHLILJLKLLLMP[QKU_^^b@bTeDsQ(B")
 ("auf"	"$BJNLG(B")
 ("aud"	"$B;.L=L>L?L@LCLDZy\U^rbTh,j&nIsf(B")
 ("aP"	"$BjV(B")
 ("ah"	"$B18243}G|InJgJhJiJkJlK9K?KAKEKFKHKlL0L6L7LNLOLSLWU(ZV`S`pa(b&bHcjdwfNfnhOkuqxr|(B")
 ("ahr"	"$BI$KRKTLZL\Q^[7]teYg|s/(B")
 ("ahf"	"$BKWL^]G]s(B")
 ("ahd"	"$BL4LXQOTm[$[/](_Bb^ga(B")
 ("ay"	"$B1,@&G-I@IAICIDIEJhL/ZbZe^]b?eMg{i8(B")
 ("an"	"$B@&I5IoIpIqIsJjJlK4K?KEKGL3L5L6L7L8L9LPU(V`W'XcXlYEZ[\>bHeYhOj]kX(B")
 ("anr"	"$BKAKOK|L[`Tfn(B")
 ("ans"	"$B2cJ-J8J9JZLHLdLfLgLhPnQfX$XpY_e$(B")
 ("anf"	"$BJ*L^(B")
 ("al"	"$B3aFfHxHyH}H~JFL#L$LBLoU;VKW9W=_>_Pdve[i/m?sHsSs`(B")
 ("als"	"$BIRL1LeV1X>XbZa^#eNf+o\sf(B")
 ("alf"	"$BL)L*\ikm(B")
 ("qkr"	"$B9}GmGnGoGqGsGtGuGvGwGzG}JmKPKQP8YsYv\w^p`a`yg.p;qPr0rX(B")
 ("qks"	"$BH<H>H?H@HBHCHIHJHKHLHRHSHWHXJ1JVJ[YBZ5\Q_/amcme+fvj6k'm*(B")
 ("qkf"	"$BH-H.H/H0H1H4KVUVX#Y6Y{^_b"b$cAlmq{r1(B")
 ("qkd"	"$BJoJ|J}K'K,K.K5K7K8K<K@KBKCKIR9RMUxVsWEWGZU[D\V^qb|cmg/gVhpiSkno%qwr7(B")
 ("qo"	"$BGPGRGSGUGVGXGZG[G\G]GeGfGrKLT/WQX`YA^\_d`jfujj(B")
 ("qor"	"$B3|GFGlGoGpGrGuI4PQVg[1`aa)cndjr0(B")
 ("qjs"	"$BH(H?HKHMHQHVHYK]ZYZZ\h_/_xc)effLg8j[o@s=(B")
 ("qjf"	"$BH2H3H5H6f/(B")
 ("qja"	"$BHAHEHFHHHOK^[p^"c{gw(B")
 ("qjq"	"$BK!`k(B")
 ("qur"	"$BI{I}JHJIJJJKQ|Z&]!`za2i0j~m2mdospH(B")
 ("qus"	"$BHPJQJTJUJXJ[MhQ~RFY(Y7ZN]repg&jokfmgn4n5qX(B")
 ("quf"	"$BHcJDJLJMP(Z~sh(B")
 ("qud"	"$BIBIMISJ:J;J<JAJBL_V"Vu[D\V_[c=cme3m~q6qX(B")
 ("qh"	"$BD=F>IVIaIcIhJ]JbJcJdJeJnJsJuTHUoUph^jppfse(B")
 ("qhr"	"$BIzI{I|I}I~J!J"J#J$KMKNKPR6Z=Z>\w]M_Ad9h*hyiui}j`m.mUmVqFrX(B")
 ("qhs"	"$BK\TqlL(B")
 ("qhd"	"$B0)HFIuJpJtJvJwJ{K%K)K*K/K1K@^"_bcsdK(B")
 ("qn"	"$B3x4L<C@lG]H]ITIUIVIWIXIYIZI\I^I_I`IbIcIdIeIfIgIiIjIkIlImIoItIzI{I|J#J$JmJsK6P=PZPmP|RuS_T4UUU[Y8YC[T[U[o\T]M^pf)g%gYgxijk>lRlgmUn>n]rjrksOsPse(B")
 ("qnr"	"$BKL(B")
 ("qns"	"$BBNHRH[J,J.J/J0J1J2J3J4J5J6J7K[K_RfW][C]d]p_9`6a'a=cic|gnlL(B")
 ("qnf"	"$BITJ&J'J(J)PGWJWgYD[,`Ac1q|sd(B")
 ("qnd"	"$BC*J+JxJ~K2TDW:boe^(B")
 ("qmr"	"$BR6(B")
 ("ql"	"$B7%H[H\H]H^H_HaHbHcHeHfHgHjHkHlHnHpHqHsHtHwHzH{H|I!J(JOP#PlR8SgU&U9U{X`[,\R`Aa]acbNbgc0c>dDdcdue#f1fGg#g$g>hKhoitjkl"l@lAlLl]nAp)pBp[pfqorL(B")
 ("qls"	"$BIFIKILINIOIPIQLFUMZ/]']R_@eoi@p~r&(B")
 ("qld"	"$BI9QRQVQ_U2Xaf[qHqU(B")
 ("tk"	"$B278%:3:6:;:=:>:?:@:p;E;G;H;J;K;L;M;N;U;W;[;`;b;d;e;l;r;t;v;w;{<%<-<K<L<M<N<O<P<R<S<U<X<Y?)?ZFcGAL&L,LcP/PXQPRSSNTzU0UmWP[O[h\L]y^/^V_C_S`:`[aBc+c,codAdBdCe/fSfhgRh5iImfnanmqJqKrBr^sM(B")
 ("tkr"	"$B:o:s:w?tSVZK\N`#oK(B")
 ("tks"	"$B;1;3;5;6;9;:;;;@IGQh[<]haMedlioYo[(B")
 ("tkf"	"$B;&;';5hq(B")
 ("tka"	"$B;0;2?9?yRTWD^zdsexf.glhujN(B")
 ("tkq"	"$B07=BA^Yg]=_'_(p@q%(B")
 ("tkd"	"$B7,8~=}=~>&>(>0>2>E>M>X>\>]>^>e>o>uAPASAVA[AjAzA|BlBmErF=FKH"MMRVUCURVyV{XS\k]O`.a3fFjak<ksrh(B")
 ("to"	"$B:I<%^/_Sg(lPp{rT(B")
 ("tor"	"$B:I:p:w?'T'XG\ecQi,(B")
 ("tod"	"$B1y>J@7@8`Ocy(B")
 ("tid"	"$Bq.(B")
 ("tj"	"$B5P:T=k=l=n=o=p=q=r=s=v=x=y=z={?p@3@4@>@@@BAMD)L;P0ScTPTfVYY3ZFZGd.e1fTf]fqsUsk(B")
 ("tjr"	"$B3c<.<M<a<b@J@K@N@O@P@YM<^Hb,hnirj.jinYnq(B")
 ("tjs"	"$B4T@f@g@h@k@p@q@v@z@{@~A"A#A%A*A-A/A1A5A6A7C1OKQ"SEUIUvX:^/`!a}c8e@fAgUiElqpG(B")
 ("tjf"	"$B1L6}7@@^@_@b@c@eC-FQSwYM\8]u^Xe(e2eJi-jxsv(B")
 ("tja"	"$BA!A.UQZ{]@]S]Tcxeyezj9k~lXnu(B")
 ("tjq"	"$B=&>D@"@]RYSqXRXwYpfcm:oRq#(B")
 ("tjd"	"$B>J>k@+@-@.@1@9@;@<@?@CX9Zp`Od-fag)(B")
 ("tp"	"$B:P:Y:{@$@*@G@b@vLcWB^/ih(B")
 ("th"	"$B037+:i<D=j>$>%>,>.>/><>?>B>C>F>K>P>R>S>dA:AAABAGAIAJALA]A_AcAgA{B}I%R#SbU?XG[`\f][]{^j_O_va4d,dTg[hvi+i?l!lsmvn:n[nyp<ppq[rCrM(B")
 ("thr"	"$B0@B+B.B/B0B3V$etkll^(B")
 ("ths"	"$B;AB9B;B=C'(B")
 ("thf"	"$BN(j+(B")
 ("thd"	"$B>>>YAWAwW~[@^DcpgNiOkVo1psr"(B")
 ("thkf"	"$B:~(B")
 ("tho"	"$B:?:U:~;&;/^/_S`tbl(B")
 ("thl"	"$B?h?jTj(B")
 ("tn"	"$B<i<j<l<m<s<u<w<x<y<z<{<|<}=$=%=(=+=/=2=7=C=I?\?b?c?e?g?k?o?p?q?tA\AiB5C(C/D\JfLyM"N(RWS4SUSVT1ThU?V-X{YSZ@ZK]U]z^,^l^{_|`Yc.cOdXdoe5e7elf7f{g!g;h%h5hki.j-l(l3n.nHnsnxo5p$p+qrr$(B")
 ("tnr"	"$B=G=H=I=J=L=M=N=OPhUY`GfihChr(B")
 ("tns"	"$B=V=X=Y=[=\=]=^=_=b=c=d=f=gFkWNWv^-d#d$f|h&hsh|kNkYo>s((B")
 ("tnf"	"$B=Q=RN(WuX|[2(B")
 ("tnd"	"$B?r?shE(B")
 ("tnl"	"$BPfPg^C(B")
 ("tmf"	"$BI(`niMi|(B")
 ("tmq"	"$B<>=&=,=1_<jyp.(B")
 ("tmd"	"$B>!>#>5>:>g>h>jANFlGhP+QtR4[Fejj$o~(B")
 ("tl"	"$B0;3A:|;&;H;O;S;T;\;k;m;n;x;{;~<(<,<E<F@'DsLpRQSASOS]UyU}W#W6WtYy`JfBg(gShahikkl5l9p{(B")
 ("tlr"	"$B6t<0<1>}>~?!?"?#?)?*B)Uf_omHq3(B")
 ("tls"	"$B:g?-?.?1?5?7?=?@?B?C?E?H?I?U?V?WC$GjH8RqS"UbXFY;Zo_~iglYpur`(B")
 ("tlf"	"$B<:<<<=<BUi\Cj)(B")
 ("tla"	"$B;2?3?4?<?D?R?SRTWZ\;]n_)_Dh~o=(B")
 ("tlq"	"$B=&=:===BDTRARB_'_(a#cgdb(B")
 ("Tkd"	"$BAPRV(B")
 ("Tl"	"$B;a(B")
 ("dk"	"$B0!0"0$2d2e2f2g2j2k2m2n368f;yP3Q;S(U.U4V6[s`Ha^h0jKk(kCn{o<rms!s"(B")
 ("dkr"	"$B0!0-0.0/3Y3Z3\DWOLP3RxTAVVVjX(X3\[hUhVh`k`n?s-sys{(B")
 ("dks"	"$B0B0D0F0H4_4c4f4g4i8APtZg]Vpzr=rnro(B")
 ("dkf"	"$B060D1ZX~Y!]"]1]Fk@mBn!odpK(B")
 ("dka"	"$B0C0E0G1^264`4b4dVIV^h?k^pws_sa(B")
 ("dkq"	"$B0(052!3{R}TZ`@(B")
 ("dkd"	"$B1{6D97Wi]J]vc?pYrs(B")
 ("do"	"$B0%0&0'3336373eS1SNS`T<V=[#]7b-bJbYbvc(ghi=oup'pKpOq>(B")
 ("dor"	"$B1U3[LkLqY/YUf~mCoup'(B")
 ("dod"	"$BSm]/f"rts@(B")
 ("di"	"$B<M<P<Y<c<fG8LiLjLkLlLmLnYh\?s,(B")
 ("dir"	"$B0s<c<eLsLtLvU>Ynd`h`hji;oPs4s~(B")
 ("did"	"$B>\>m>n>w>y>zMHMLMMMNMSM[M\PSTaUPWyZ7ZfZx\k_!_G_laZagaxc:cUjwl*nVqh(B")
 ("dj"	"$B1w5y5z5{8f8lS0S}S~^Kq,qGrNsw(B")
 ("djr"	"$B2/21225?M^\z(B")
 ("djs"	"$B1a8@8AGgI'PpUA_adN(B")
 ("djf"	"$B]"]1(B")
 ("dja"	"$B1b1f264`4d8387Q7RLSnV^Vx^;f,ofqd(B")
 ("djq"	"$B6H(B")
 ("dp"	"$BWk]P(B")
 ("du"	"$BFrG!M=M>M?M@MAMBP.]C^.aBe1gMgPh'i1ikl%q1(B")
 ("dur"	"$B0W0h1V1X5U<MKrLrLuXdehinl#o`ogp?qcrH(B")
 ("dus"	"$B0v1c1d1h1i1l1m1o1t8&8'<!A3FPFpG3J%RdSkU+U/WzYPYa\=])^'^2^7^=_]d'gCh/icj@l'(B")
 ("duf"	"$B0v1Y1\@bG.ReSYsv(B")
 ("dua"	"$B1^1j1k1p1v@wL-QG\ygfgroeqyr6rPsEsa(B")
 ("duq"	"$B1^MUSq[!pT(B")
 ("dud"	"$B1D1E1F1G1I1J1K1M1N1O1P1Q1S7J7^RiS[TJU$U%Zu\3\F^s_J`r`}`~ewj>lWn;pD(B")
 ("dP"	"$B0e1C1H1L1T4"7X7];y<IM@MBP)P.PdQ;Q<St[*]u`IbKbOcRfJghi"i#i:iRjcl%l?p?rIsL(B")
 ("dh"	"$B0-1(1*1w1x1|2(8^8`8a8b8c8d8g8h8mP~S*SKSSTITTT|U<UhWXX(XeZDZm_4_r_z`3`iiej(n+o2rbsg(B")
 ("dhr"	"$B0$206L9vM`(B")
 ("dhs"	"$B292:X2aicSi%i>jrr[r\(B")
 ("dhf"	"$BQ:\Eg,(B")
 ("dhd"	"$B2'MJTYW+a%a1a~c<hcp6s0(B")
 ("dhk"	"$B0#122i3?4$7&RwSyc]hbiwkBkw(B")
 ("dhks"	"$B08404K4P4X4a4e4hOPOROSU6^1_5iol2op(B")
 ("dhkf"	"$B[)(B")
 ("dhkd"	"$B1}2"2&9DUwWH[>]j(B")
 ("dho"	"$B0#3?OARwbdiw(B")
 ("dhl"	"$B0Z307(VLV[`Pbvi'r>(B")
 ("dy"	"$B1z3Z6F9x>qD8F+LsMEMIMKMRMTMWMXMZQ'TpU-UKULVRVvWTWUY9YjYz\[\v]H_$`"`vcXc_eeh}j4kon-n3qAs8t!t#t$(B")
 ("dyr"	"$B?+C+M]M_MaV;^ieUhljs(B")
 ("dyd"	"$B23B{M&M/M0MCMFMGMOMPMQMVMYP\XJXY\Wa5f`gNill}o0ps(B")
 ("dn"	"$B0r1&1'1)1*1+2$2%5m6h6r6s6v6w6x6y?uKtL`M$M%M'M+M4M9P2P}R^R_VJ\d]?]XaOb3c;c<d~foi9kpsIsz(B")
 ("dnr"	"$B000jR(TT_4_z(B")
 ("dns"	"$B0w1$1>1?1@Zt]N_pe"fQp(pq(B")
 ("dnf"	"$B080S1516]5_q(B")
 ("dnd"	"$B7'M:(B")
 ("dnjs"	"$B080w1!1`1e1g1n1q1r1s1u3@4j85868;I2QMT$T(U6UcXE^S`)gkiojOkdmWn|ovp((B")
 ("dnjf"	"$B1[7nXz[)denh(B")
 ("dnl"	"$B010L0N0O0Q0R0S0V0Y0^0_0`0b0c161R4m56OAQ&S@SxT#Vk^O`*a_eOh<ivjLm{pjr2(B")
 ("db"	"$B0T0]0d:y<t=@D\FSFjFyF}G(KnL{L|L}L~M!M"M#M(M)M*M-M.M1M2M3M5M6M7MDPRQASHS|U^ViXoYfYiZA\@^a^b`qahdre7g+gLhPi$iXj!j"j@k!k0kglzl|n'nXo+pds[sl(B")
 ("dbr"	"$B0i4!FyS|]Zdx(B")
 ("dbs"	"$B0t0}1<=aUzlVnJ(B")
 ("dbf"	"$Bffrr(B")
 ("dbd"	"$B=?M;e0(B")
 ("dms"	"$B1#286dRaT-T7X@X[]V`;p,su(B")
 ("dmf"	"$B255?(B")
 ("dma"	"$B0{0|0~1"2;5?6cR_U5V@];pF(B")
 ("dmq"	"$B5cM,M8X%(B")
 ("dmd"	"$B1~5?6EBkGhXfg?j$m@mA(B")
 ("dml"	"$B0M0U0X0a365#57595<5?5A5B5C5DODPaV=VTVXXt]:_q`Hbcc&ePg_nPq>(B")
 ("dl"	"$B0;0J0K0P0W0[0\1B;\<$<)<*<X?)BBBfCPFRFsFvP1U)UuVaW3W4W^^&`ba-aXfggokHlFlHlIm_mnp0(B")
 ("dlr"	"$B1WMbMcVXW5[;fDkjs2(B")
 ("dls"	"$B0u0v0x0y0z1l?M?N?O?YFRG&G'LbP@PAQ9QcTEUTW.]e^P_]h!h;iNpW(B")
 ("dlf"	"$B0l0m0n0oF|P!PETejRn_o-(B")
 ("dla"	"$B1A?QDBG$G%L-U,WljSjT(B")
 ("dlq"	"$B9~F{F~R]T)rl(B")
 ("dld"	"$B>jP;QtUT(B")
 ("wk"	"$B040q:4:8:::^:n;F;I;P;Q;R;Z;g;p;q;s;z;|<"<'<+<Q<T@F@QDSI&PwQ}RoR~UZWs^h_Ua*aSbDbEdggsh$hti4i5k9lGlZl`r8s:sn(B")
 ("wkr"	"$B:n:r<[<]<^<_<`?]?}SpU"UeZQ[P_Zd+e?ginLs'(B")
 ("wks"	"$B;7;DV#X}\"]L_%b7(B")
 ("wka"	"$B;=;C@xC9V*_*_+d>dQjDlQo4(B")
 ("wkq"	"$B;(AYA^C}SrYgd4p7p8(B")
 ("wkd"	"$B>">)>->1>8>@>O>Q>U>_>c>f>l>s>uATAqArAuB!B"D"D%D2D9F5P?TGTVTcTyT}U#UrVQW2\u\~^J^y`-`/`R`xaog6gGgIg`h7hIi,i6jfl[l\o6rc(B")
 ("wo"	"$B:F:H:K:M:R:X:[:\:_:`:b<F@FB8^hc7eRexl9lZsn(B")
 ("wod"	"$BA9AdAhAyVDVl`'bUd7d8kZo#(B")
 ("wj"	"$B093n5O<Q=m=s=t={=|A;A@CtCuCvCwCxCyDcDlDqE!EKGgH$LYPJRrW7Y3[A[R\:]|_L`2aTbicle*f8fTgsiWk:kIl7m0p3sr(B")
 ("wjr"	"$B2.<Z<d@Q@R@S@V@W@XB1C`CdD$D_E&E(E)E*E+E,E-LvR*W/_U`?a{c!d{gii4k6mlmqmx(B")
 ("wjs"	"$B<2=W@o@r@s@y@}A'A,A0A4B7C.DQE5E6E8E;E>E?EAEBECEDEEG{H*KjMdQ#QrR4RdSsT{UsV\W%X"X}Y%ZBZS]a^!_E`0a/aYaub!c"d%d5d?euf?fHg"lcm7mYm[nonto"oCp4pSp|q4qBs6s7t"(B")
 ("wjf"	"$B=`@Z@[@^@`@a@dCbLERERGRzY#ZqZr^6cffOlkmE(B")
 ("wja"	"$B0>@jA2E9E@FQG4V3dRpAsVsZ(B")
 ("wjq"	"$B@\D3XR\&\7\D]~^XfcrW(B")
 ("wjd"	"$B0f;*>=>Z>`>p>t>{@,@/@0@5@:@EBGCzD.D:DbDdDeDgDhDjDmDnDrDuDvDwDxDzD{E"E#E$FTKoLwMdP'RZVlY]ZW[l^F^[a6aKbMcWf^hGj:mwn&nDnKoFp=pP(B")
 ("wp"	"$B1-:O:Q:W:]:^=t=|@)@=@F@^BhBiBjDiDkDoDpDsDtD}P_Q1Q}Z+Zq_;bDbEbIgAi5lZm3pIpmpnsn(B")
 ("wh"	"$B3v7+:x;4<D=u><>H>[>rA;A<ADAEAFAHAKA`AaAbAeAfAgAlAtAxB$BdC{C|D$D&D+D,D/D4D7D8D;DUD^D_D`FXGBH%POPYS^SdWIXNXTXjY2Y4Zj[j[t\'\*_6`,bic/cGcZc^cud|e6f-fTfrg]iskGkPl!ldm/oXp:qt(B")
 ("whr"	"$BB-B2dHhwo7(B")
 ("whs"	"$BB:YO(B")
 ("whf"	"$B@[B4OHR@`L(B")
 ("whd"	"$B<o<p=!=*=>=D>a>bAnI"P:WOXQ\#\$\b^JdpeTj*l{m'm)oG(B")
 ("whk"	"$B:4:8:A:B:C(B")
 ("whl"	"$B:a(B")
 ("wy"	"$Bn[(B")
 ("wn"	"$B3t:n<g<k<n<r<v<~=#='=.=5=;=K?_AUAvB-B2ChCkClCmCpCqCrCsD4D]I*L+P&PMPvQ2QISUW$ZlaFaGcGdVdZe!eBfthwiakOlam4mTn$oIsG(B")
 ("wnr"	"$B4!C]dx(B")
 ("wns"	"$B1==S=T=W=Y=`=c=eFVH;KpQ.RETSWvX"X6^4_=b/jAm-mu(B")
 ("wnd"	"$B=0=ECfCg(B")
 ("wmr"	"$BB(B1(B")
 ("wmf"	"$B6{(B")
 ("wma"	"$BWc(B")
 ("wmq"	"$B=4=AIxM,\7eI(B")
 ("wmd"	"$B3(9y>I>Z>xA9A=A>A}A~B#D'YN\t__kz(B")
 ("wl"	"$B4t5@;V;X;Y;];^;_;c;f;h;i;j;o;}<1<A<G?%B~CNCOCRCSCXCYDRDlDqEVG7S!T.TMVcW7Yu[L]ma\c-fMfsgSk:lDlSlflym5mIn/owr?s9(B")
 ("wlr"	"$B?%?&D>SDcFcM(B")
 ("wls"	"$B?0?6?8?:?>???A?G?J?L?P?T?XC$DADCDDDEE6FxKyPVSQZi]I_~`_a+a;b8bCbSeVgKhmjWlcmGo/(B")
 ("wlf"	"$B<8<;<@<ACaCbE3IHLEPERzSDT9Ve[_fOg4g5lDlkmE(B")
 ("wla"	"$BD?ZPnErq(B")
 ("wlq"	"$B<9=4=8=AeI(B")
 ("wld"	"$B@!D'D(_-(B")
 ("ck"	"$B3n:!:5:7:9:<<V<W<ZOMPNSMV+VMY-Ym[3\Lbxd4gsm"n`(B")
 ("ckr"	"$B:q:u:x@NB*ByCeCxY'eSm0oXsqsx(B")
 ("cks"	"$B;8;<;>;?;A@qRUZ9`&cbdlesl-lUo4oSoTqB(B")
 ("ckf"	"$B;!;";$;%QkY)`\e'(B")
 ("cka"	"$B;2;4;BA2Q(Q)RTTOVPVZXNXOXPXrXs\ackk{k|l)l+q](B")
 ("ckd"	"$B>'>+>3>4>;>T?zAOARAdAkAsD*D1H+PiQlRRX0XHYoZHZd^E^k^}`KalcYgZm#r.(B")
 ("co"	"$B:9:D:L:N:S:V:W:Z<F@UMi\Me=hql8n`pV(B")
 ("cor"	"$B:p:t:u:v:}@UA<QFSTY>[Pbyd)dG(B")
 ("cj"	"$B:J=h@(A@Q]X.^Ge1hF(B")
 ("cjr"	"$B;I<\@I@L@M@TD=QqRhWFZ3^~akinljm$m(m6p"s5(B")
 ("cjs"	"$B0+6N6z6|;=@i@n@q@t@u@|A$A&A(A)A+C)E7PBPjQdSCV_Z#[a\9^I^Y_Ea$chh(lMlxoqotph(B")
 ("cjf"	"$BDVE/E0E1E2E4FLFmS5V%YZmPnno$oDoEq8(B")
 ("cja"	"$B84@mE:E<Q!W[Ww\a\y]~b]dSdUd^d_j9k-k[k~(B")
 ("cjq"	"$B>*>9>vC}D!D-D5E=aHaIaJbLjymLmM(B")
 ("cjd"	"$B;*;,@2@6@A@DD#D0W,W-fehGiq(B")
 ("cp"	"$B@ZBNBXBZBaDVDfDyD|D~FeFmSFSiSjYZ\<^8^|bIbfh\hxjim<m=n*pLqsqv(B")
 ("ch"	"$B7-=i>%>6>7>A>G>K>L>S>V>d?]A?ACApD6D8ICQvR#R+V%V9X!X7X^[B\%^W_VcDggkWl:mknLndqzs<ss(B")
 ("chr"	"$B<q>|?$?(?tB%B0SvV$ZKb`badHifk=m1o7qq(B")
 ("chs"	"$B1%@#B<WVn7(B")
 ("chd"	"$B=>=FAQAZAmAoC~DMF4G,N5N6P:PxR2WOWdX;eAeTfb(B")
 ("chl"	"$B:E:GVCYt\c^/(B")
 ("cn"	"$B0,1/3b<h<q="=%=)=-=6=9=P?[?d?m?n?u?v?wAFC\CjDFDGDHDIDJGkOISBU7U9VdX/YXYY\6\d^Wa,b2cTd6dHeWf\gmhZn@p%p2pcqWqerUsF(B")
 ("cnr"	"$B1/<3<4=3=K=LC[C\C^C_C`M.\egXm&(B")
 ("cns"	"$B=UDXrV(B")
 ("cnf"	"$B=P[2sY(B")
 ("cnd"	"$B2-=<=F>WCiCnCoMCQU`>g^j5(B")
 ("cnp"	"$BX,X-X8aahDlT(B")
 ("cnl"	"$B<h<q="=-?a?f?i?l@HOIS\U8X8Ye\r]^aafCf\g9hDk9nMqe(B")
 ("cmr"	"$BB&B'B,D=P<X<Z`(B")
 ("cms"	"$Bsp(B")
 ("cma"	"$Boo(B")
 ("cmd"	"$BA=A>AX(B")
 ("cl"	"$B:7:9;u<#<&>}?"?%CMCQCTCUCVCWCZD'D>FePLRHRNSPTiV5VbVpVz[i_ua7a?awbtcPcze#e>eLfWiPjul8lemOo!p5r5rKrvrwscso(B")
 ("clr"	"$BB'B,D<R,RNVzX<ZE(B")
 ("cls"	"$B?Fk%sp(B")
 ("clf"	"$B<7<?(B")
 ("cla"	"$B5N?/?2?;?KC9D@KmUjWZZP\;o*o,ooqT(B")
 ("clq"	"$Bj/(B")
 ("cld"	"$B>NGicJjYqU(B")
 ("cho"	"$B2wTo`V(B")
 ("xk"	"$B<XB>BBBCBDBEBFBGBHBIBJBKBLBMCSOMPIS#TXU`YYYe[4\s]}g!m>qLrx(B")
 ("xkr"	"$BBnBoBqBsBtBuBvBwBxByE'EYPkS6Y>[Q_7ner0(B")
 ("xks"	"$BBMC2C3C7C:C>CBCFF]FgW<X_Z:]QjX(B")
 ("xkf"	"$BC%C&(B")
 ("xka"	"$BC5C?b>lE(B")
 ("xkq"	"$BEcEkYr\PpaperW(B")
 ("xkd"	"$BEfErE|F"Vfb;j#(B")
 ("xo"	"$B@GB@BABUBVBYB[B]BaBfBgG=KXLaQ<\(cze)ihkHq&qM(B")
 ("xor"	"$BBpBrBtZ$_7(B")
 ("xh"	"$BEFEGEQEZEeF$Q=h9(B")
 ("xhs"	"$Bjt(B")
 ("xhd"	"$B23DKDLE{E}HuWxXV(B")
 ("xhl"	"$B?dBOB\B`DHDIDJFXjtpx(B")
 ("xn"	"$BEJEjF)F.L{Pye5o+qmr,(B")
 ("xmr"	"$BB_FCXW(B")
 ("vk"	"$B?|GCGDGEGGGHGIGJGKGLGNHmHvT3WfZ4[1`(``bncvfRg8hJh]jZllox(B")
 ("vks"	"$B:d:eH=HDHGHNR!]ra"ng(B")
 ("vkf"	"$B;+H,R\[5n\(B")
 ("vo"	"$B143-GIGTGWGXG\GbH4HmI#PPUVX#Y6ZT[1]o`cp>(B")
 ("vod"	"$BC*K#K5KDW:WEZU_0b|e^(B")
 ("vir"	"$BX?(B")
 ("vus"	"$BJ?JPJRJSJTJWJXJ\Y(fIgyi~jokfqY(B")
 ("vua"	"$BlJ(B")
 ("vud"	"$BDZI>IMJ?Wh^$bogyhLr9(B")
 ("vP"	"$B3AGQGYJ>J@JCJDJEKJUJVrW&ZIZMasi0qo(B")
 ("vh"	"$B1:3s3wGxGzI[I]IrJ^J_J`JaJqJyJzK"K$K&K+K0K=R1R5R7RvS.T5YF[T_F_\aWb.f}gTgzj\jqmynppRq0q}r:rDsR(B")
 ("vhr"	"$BGxGzI}K=_F(B")
 ("vy"	"$B<]I6I7I8I:I;I<I=I?QwUEXX]Ke]q(q)q*q_qjqurd(B")
 ("vns"	"$BJ,(B")
 ("vna"	"$BIJcHcI(B")
 ("vnd"	"$BIvIwK-afkel4q$qH(B")
 ("vb"	"$BI7(B")
 ("vl"	"$BH`HdHhHiHmHoHrllmdox(B")
 ("vlf"	"$B2^HfHgI$I%I+I,I-I.J'J)PGYDdJkvm+s+(B")
 ("vlq"	"$BI/I}K3^"(B")
 ("gk"	"$B2<2?2F2O2Y2\2b2l3E<6ROR`V|^Q`leKf!kEl.n"o(rQ(B")
 ("gkr"	"$B2)3X5TDaT[U\U]^A`Bajkbl;s?(B")
 ("gks"	"$B4(4@4A4M4W4Z8B:(UFUGW{Y*YRZ][e_K`Cb*f'n8qSqlsm(B")
 ("gkf"	"$B323d3e3mR$bRiys\(B")
 ("gka"	"$B4O4Y4^H!MtQbRyS2S?VH]#^>eHh1n8nro|pwq2rRsD(B")
 ("gkq"	"$B389^9gH:RnR}^eb4b5b6hdonr{(B")
 ("gkd"	"$B7e9+91939:9A9R9T9_9`FzP6PDRbWqe}fjobprr*(B")
 ("go"	"$B0g2r3#3$3*3/31323:3<:zPsT6TnTxUXW(Xh\4i&j7k;k_n0nOqO(B")
 ("gor"	"$B3/3Kbkk*mJ(B")
 ("god"	"$B0I8v9,9Te.jbr}(B")
 ("gid"	"$B5}6?6A6B8~9aSlq.(B")
 ("gj"	"$B135u5vTR[[]A^w(B")
 ("gjs"	"$B7{8%8.YW`[(B")
 ("gjf"	"$B]<iyj8(B")
 ("gja"	"$B8183VUp*qd(B")
 ("gur"	"$B3E3R3W7CTu^)r+(B")
 ("gus"	"$B0<7|8)8+8-82898<8=8>8?9`JGPWRl^-aRbAeQidjJnkp}(B")
 ("guf"	"$B7j7l>iJGLRUSk#pv(B")
 ("gua"	"$B7y(B")
 ("guq"	"$B0A3p6"6(6.64696<KKOFTsV7XDYQ^5`Ed)d:h2nwo}p!(B")
 ("gud"	"$B3>5|7:7;7?7A7U7V7e9UTk_W_X`rfzj%mj(B")
 ("gP"	"$B7E7RQBR>TxWBX*b=c4l~nQp^(B")
 ("gh"	"$B3O8C8F8L8M8P8Q8R8U8W8[8_8c8j8n8o9%9@9f9h9j9k:c;)<JD[QTTdW`Y&Z_Zn\5]]]l^v^w`7`ha!b(b+hYhfiHiKizn=o.q7(B")
 ("ghr"	"$B0?9s9tOGUeZO(B")
 ("ghs"	"$B:':*:+:.:2[~\!^U^g_c`m(B")
 ("ghf"	"$B3K9z9{]Gcts3(B")
 ("ghq"	"$B3f(B")
 ("ghd"	"$B909?9H9cR|]g]wkAobr*(B")
 ("ghk"	"$B2=2P2R2S2V2Z2_2h3q3r7$CtOBOCS;V<aAdqo&(B")
 ("ghkr"	"$B3H3M3N3OZ2Z<ayb_j?p9(B")
 ("ghks"	"$B4-45494<4?4D4T4]88OKT(TvUaUnXu]D^R^S_eb*bAbbl,l6oBqir%r](B")
 ("ghkf"	"$B1[3h3j;#`Qbwi]l/ohoi(B")
 ("ghkd"	"$B2+677;92989D9SKZQWQ`WSWrX5Zh^T^f_jd;dPfki{n#p&rS(B")
 ("gho"	"$B2h7S`VaA(B")
 ("ghl"	"$B2q2s2u2v2y2z2{3"3%=ZI0OEPrQER;TUWKXg[X\G^Neig:h"i'i\kKkRmorf(B")
 ("ghlr"	"$B2h3D3MaA(B")
 ("ghld"	"$B2#909U9li*mDo)sT(B")
 ("gy"	"$B6G8s8z9;9Z:hP{S,SeSoZCZ|[f^B_^`+qaqb(B")
 ("gn"	"$B0r5`8e8t8u8|9!9"PHRcSLSR^A_h`Md<kMmp(B")
 ("gns"	"$B7.7071FkR._m_nhXnU(B")
 ("gnd"	"$Bi*(B")
 ("gnjs"	"$B3~7vCHX:Zwh@kcl,(B")
 ("gnp"	"$BCnRCS<TL_{(B")
 ("gnl"	"$B4x5+51WCY&Zv]`ka(B")
 ("gb"	"$B5Y7H7MC\Z8_^iLl<(B")
 ("gbr"	"$BC\(B")
 ("gbf"	"$BWukys;(B")
 ("gbd"	"$B6$6'6;R3Wo^((B")
 ("gmr"	"$B9un^(B")
 ("gms"	"$B6U:/WLWWYWnW(B")
 ("gmf"	"$B5%5IKxV(k?(B")
 ("gma"	"$B6V7g(B")
 ("gmq"	"$B5[]@^*b%fE(B")
 ("gmd"	"$B6=Fz(B")
 ("gml"	"$B4n4r4u5)5:5>I1Q%RzS)S`XAXZY&Zk[']8_f_g_t`!`:c6f<nZrF(B")
 ("glf"	"$B5Merk#pvs\(B")
 ("unknown"	"$B4#<5DNFJFdFuJ=KsL]QeRIRpS&S9SuS{T*T+T8T:T>TBTCTKTNTQTWT\T_UNU~V&V,V-V.V/V0V2V4V8VNW;WjWnWpY0YKY^Z1Zs[=[b[n\)\-\.\/\0\1\O\S\j\n\o\p\q\x]&]6]B]i^<^L^c_&_1`<a:a<a>b<bBbXbmbpbsc%c5cNcdc}d&d1d=dIdLdYdddfdhdte9eaebemenevf$g3g\h4h6hHhMhWhhiFi[ibj,jQj^jmk\lCmZmhmimzn%n}o'oZo]p#p-pXp]p`q;qIqRr;r@rGrOrZr_rer~s#s%(B"))

;; arch-tag: 06336a2c-696e-45f1-9990-aff251e7493a
;;; hanja-jis.el ends here
