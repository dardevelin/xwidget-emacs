;;; eucjp-ms.el -- translation table for eucJP-ms. -*- no-byte-compile: t -*-
;;; Automatically genrated from eucJP-13th.txt, eucJP-udc.txt, eucJP-ibmext.txt
(let ((map
       '(;JISEXT<->UNICODE
	 (#x2d21 . #x2460)
	 (#x2d22 . #x2461)
	 (#x2d23 . #x2462)
	 (#x2d24 . #x2463)
	 (#x2d25 . #x2464)
	 (#x2d26 . #x2465)
	 (#x2d27 . #x2466)
	 (#x2d28 . #x2467)
	 (#x2d29 . #x2468)
	 (#x2d2a . #x2469)
	 (#x2d2b . #x246A)
	 (#x2d2c . #x246B)
	 (#x2d2d . #x246C)
	 (#x2d2e . #x246D)
	 (#x2d2f . #x246E)
	 (#x2d30 . #x246F)
	 (#x2d31 . #x2470)
	 (#x2d32 . #x2471)
	 (#x2d33 . #x2472)
	 (#x2d34 . #x2473)
	 (#x2d35 . #x2160)
	 (#x2d36 . #x2161)
	 (#x2d37 . #x2162)
	 (#x2d38 . #x2163)
	 (#x2d39 . #x2164)
	 (#x2d3a . #x2165)
	 (#x2d3b . #x2166)
	 (#x2d3c . #x2167)
	 (#x2d3d . #x2168)
	 (#x2d3e . #x2169)
	 (#x2d40 . #x3349)
	 (#x2d41 . #x3314)
	 (#x2d42 . #x3322)
	 (#x2d43 . #x334D)
	 (#x2d44 . #x3318)
	 (#x2d45 . #x3327)
	 (#x2d46 . #x3303)
	 (#x2d47 . #x3336)
	 (#x2d48 . #x3351)
	 (#x2d49 . #x3357)
	 (#x2d4a . #x330D)
	 (#x2d4b . #x3326)
	 (#x2d4c . #x3323)
	 (#x2d4d . #x332B)
	 (#x2d4e . #x334A)
	 (#x2d4f . #x333B)
	 (#x2d50 . #x339C)
	 (#x2d51 . #x339D)
	 (#x2d52 . #x339E)
	 (#x2d53 . #x338E)
	 (#x2d54 . #x338F)
	 (#x2d55 . #x33C4)
	 (#x2d56 . #x33A1)
	 (#x2d5f . #x337B)
	 (#x2d60 . #x301D)
	 (#x2d61 . #x301F)
	 (#x2d62 . #x2116)
	 (#x2d63 . #x33CD)
	 (#x2d64 . #x2121)
	 (#x2d65 . #x32A4)
	 (#x2d66 . #x32A5)
	 (#x2d67 . #x32A6)
	 (#x2d68 . #x32A7)
	 (#x2d69 . #x32A8)
	 (#x2d6a . #x3231)
	 (#x2d6b . #x3232)
	 (#x2d6c . #x3239)
	 (#x2d6d . #x337E)
	 (#x2d6e . #x337D)
	 (#x2d6f . #x337C)
	 (#x2d70 . #x2252)
	 (#x2d71 . #x2261)
	 (#x2d72 . #x222B)
	 (#x2d73 . #x222E)
	 (#x2d74 . #x2211)
	 (#x2d75 . #x221A)
	 (#x2d76 . #x22A5)
	 (#x2d77 . #x2220)
	 (#x2d78 . #x221F)
	 (#x2d79 . #x22BF)
	 (#x2d7a . #x2235)
	 (#x2d7b . #x2229)
	 (#x2d7c . #x222A)
	 (#x7521 . #xE000)
	 (#x7522 . #xE001)
	 (#x7523 . #xE002)
	 (#x7524 . #xE003)
	 (#x7525 . #xE004)
	 (#x7526 . #xE005)
	 (#x7527 . #xE006)
	 (#x7528 . #xE007)
	 (#x7529 . #xE008)
	 (#x752a . #xE009)
	 (#x752b . #xE00A)
	 (#x752c . #xE00B)
	 (#x752d . #xE00C)
	 (#x752e . #xE00D)
	 (#x752f . #xE00E)
	 (#x7530 . #xE00F)
	 (#x7531 . #xE010)
	 (#x7532 . #xE011)
	 (#x7533 . #xE012)
	 (#x7534 . #xE013)
	 (#x7535 . #xE014)
	 (#x7536 . #xE015)
	 (#x7537 . #xE016)
	 (#x7538 . #xE017)
	 (#x7539 . #xE018)
	 (#x753a . #xE019)
	 (#x753b . #xE01A)
	 (#x753c . #xE01B)
	 (#x753d . #xE01C)
	 (#x753e . #xE01D)
	 (#x753f . #xE01E)
	 (#x7540 . #xE01F)
	 (#x7541 . #xE020)
	 (#x7542 . #xE021)
	 (#x7543 . #xE022)
	 (#x7544 . #xE023)
	 (#x7545 . #xE024)
	 (#x7546 . #xE025)
	 (#x7547 . #xE026)
	 (#x7548 . #xE027)
	 (#x7549 . #xE028)
	 (#x754a . #xE029)
	 (#x754b . #xE02A)
	 (#x754c . #xE02B)
	 (#x754d . #xE02C)
	 (#x754e . #xE02D)
	 (#x754f . #xE02E)
	 (#x7550 . #xE02F)
	 (#x7551 . #xE030)
	 (#x7552 . #xE031)
	 (#x7553 . #xE032)
	 (#x7554 . #xE033)
	 (#x7555 . #xE034)
	 (#x7556 . #xE035)
	 (#x7557 . #xE036)
	 (#x7558 . #xE037)
	 (#x7559 . #xE038)
	 (#x755a . #xE039)
	 (#x755b . #xE03A)
	 (#x755c . #xE03B)
	 (#x755d . #xE03C)
	 (#x755e . #xE03D)
	 (#x755f . #xE03E)
	 (#x7560 . #xE03F)
	 (#x7561 . #xE040)
	 (#x7562 . #xE041)
	 (#x7563 . #xE042)
	 (#x7564 . #xE043)
	 (#x7565 . #xE044)
	 (#x7566 . #xE045)
	 (#x7567 . #xE046)
	 (#x7568 . #xE047)
	 (#x7569 . #xE048)
	 (#x756a . #xE049)
	 (#x756b . #xE04A)
	 (#x756c . #xE04B)
	 (#x756d . #xE04C)
	 (#x756e . #xE04D)
	 (#x756f . #xE04E)
	 (#x7570 . #xE04F)
	 (#x7571 . #xE050)
	 (#x7572 . #xE051)
	 (#x7573 . #xE052)
	 (#x7574 . #xE053)
	 (#x7575 . #xE054)
	 (#x7576 . #xE055)
	 (#x7577 . #xE056)
	 (#x7578 . #xE057)
	 (#x7579 . #xE058)
	 (#x757a . #xE059)
	 (#x757b . #xE05A)
	 (#x757c . #xE05B)
	 (#x757d . #xE05C)
	 (#x757e . #xE05D)
	 (#x7621 . #xE05E)
	 (#x7622 . #xE05F)
	 (#x7623 . #xE060)
	 (#x7624 . #xE061)
	 (#x7625 . #xE062)
	 (#x7626 . #xE063)
	 (#x7627 . #xE064)
	 (#x7628 . #xE065)
	 (#x7629 . #xE066)
	 (#x762a . #xE067)
	 (#x762b . #xE068)
	 (#x762c . #xE069)
	 (#x762d . #xE06A)
	 (#x762e . #xE06B)
	 (#x762f . #xE06C)
	 (#x7630 . #xE06D)
	 (#x7631 . #xE06E)
	 (#x7632 . #xE06F)
	 (#x7633 . #xE070)
	 (#x7634 . #xE071)
	 (#x7635 . #xE072)
	 (#x7636 . #xE073)
	 (#x7637 . #xE074)
	 (#x7638 . #xE075)
	 (#x7639 . #xE076)
	 (#x763a . #xE077)
	 (#x763b . #xE078)
	 (#x763c . #xE079)
	 (#x763d . #xE07A)
	 (#x763e . #xE07B)
	 (#x763f . #xE07C)
	 (#x7640 . #xE07D)
	 (#x7641 . #xE07E)
	 (#x7642 . #xE07F)
	 (#x7643 . #xE080)
	 (#x7644 . #xE081)
	 (#x7645 . #xE082)
	 (#x7646 . #xE083)
	 (#x7647 . #xE084)
	 (#x7648 . #xE085)
	 (#x7649 . #xE086)
	 (#x764a . #xE087)
	 (#x764b . #xE088)
	 (#x764c . #xE089)
	 (#x764d . #xE08A)
	 (#x764e . #xE08B)
	 (#x764f . #xE08C)
	 (#x7650 . #xE08D)
	 (#x7651 . #xE08E)
	 (#x7652 . #xE08F)
	 (#x7653 . #xE090)
	 (#x7654 . #xE091)
	 (#x7655 . #xE092)
	 (#x7656 . #xE093)
	 (#x7657 . #xE094)
	 (#x7658 . #xE095)
	 (#x7659 . #xE096)
	 (#x765a . #xE097)
	 (#x765b . #xE098)
	 (#x765c . #xE099)
	 (#x765d . #xE09A)
	 (#x765e . #xE09B)
	 (#x765f . #xE09C)
	 (#x7660 . #xE09D)
	 (#x7661 . #xE09E)
	 (#x7662 . #xE09F)
	 (#x7663 . #xE0A0)
	 (#x7664 . #xE0A1)
	 (#x7665 . #xE0A2)
	 (#x7666 . #xE0A3)
	 (#x7667 . #xE0A4)
	 (#x7668 . #xE0A5)
	 (#x7669 . #xE0A6)
	 (#x766a . #xE0A7)
	 (#x766b . #xE0A8)
	 (#x766c . #xE0A9)
	 (#x766d . #xE0AA)
	 (#x766e . #xE0AB)
	 (#x766f . #xE0AC)
	 (#x7670 . #xE0AD)
	 (#x7671 . #xE0AE)
	 (#x7672 . #xE0AF)
	 (#x7673 . #xE0B0)
	 (#x7674 . #xE0B1)
	 (#x7675 . #xE0B2)
	 (#x7676 . #xE0B3)
	 (#x7677 . #xE0B4)
	 (#x7678 . #xE0B5)
	 (#x7679 . #xE0B6)
	 (#x767a . #xE0B7)
	 (#x767b . #xE0B8)
	 (#x767c . #xE0B9)
	 (#x767d . #xE0BA)
	 (#x767e . #xE0BB)
	 (#x7721 . #xE0BC)
	 (#x7722 . #xE0BD)
	 (#x7723 . #xE0BE)
	 (#x7724 . #xE0BF)
	 (#x7725 . #xE0C0)
	 (#x7726 . #xE0C1)
	 (#x7727 . #xE0C2)
	 (#x7728 . #xE0C3)
	 (#x7729 . #xE0C4)
	 (#x772a . #xE0C5)
	 (#x772b . #xE0C6)
	 (#x772c . #xE0C7)
	 (#x772d . #xE0C8)
	 (#x772e . #xE0C9)
	 (#x772f . #xE0CA)
	 (#x7730 . #xE0CB)
	 (#x7731 . #xE0CC)
	 (#x7732 . #xE0CD)
	 (#x7733 . #xE0CE)
	 (#x7734 . #xE0CF)
	 (#x7735 . #xE0D0)
	 (#x7736 . #xE0D1)
	 (#x7737 . #xE0D2)
	 (#x7738 . #xE0D3)
	 (#x7739 . #xE0D4)
	 (#x773a . #xE0D5)
	 (#x773b . #xE0D6)
	 (#x773c . #xE0D7)
	 (#x773d . #xE0D8)
	 (#x773e . #xE0D9)
	 (#x773f . #xE0DA)
	 (#x7740 . #xE0DB)
	 (#x7741 . #xE0DC)
	 (#x7742 . #xE0DD)
	 (#x7743 . #xE0DE)
	 (#x7744 . #xE0DF)
	 (#x7745 . #xE0E0)
	 (#x7746 . #xE0E1)
	 (#x7747 . #xE0E2)
	 (#x7748 . #xE0E3)
	 (#x7749 . #xE0E4)
	 (#x774a . #xE0E5)
	 (#x774b . #xE0E6)
	 (#x774c . #xE0E7)
	 (#x774d . #xE0E8)
	 (#x774e . #xE0E9)
	 (#x774f . #xE0EA)
	 (#x7750 . #xE0EB)
	 (#x7751 . #xE0EC)
	 (#x7752 . #xE0ED)
	 (#x7753 . #xE0EE)
	 (#x7754 . #xE0EF)
	 (#x7755 . #xE0F0)
	 (#x7756 . #xE0F1)
	 (#x7757 . #xE0F2)
	 (#x7758 . #xE0F3)
	 (#x7759 . #xE0F4)
	 (#x775a . #xE0F5)
	 (#x775b . #xE0F6)
	 (#x775c . #xE0F7)
	 (#x775d . #xE0F8)
	 (#x775e . #xE0F9)
	 (#x775f . #xE0FA)
	 (#x7760 . #xE0FB)
	 (#x7761 . #xE0FC)
	 (#x7762 . #xE0FD)
	 (#x7763 . #xE0FE)
	 (#x7764 . #xE0FF)
	 (#x7765 . #xE100)
	 (#x7766 . #xE101)
	 (#x7767 . #xE102)
	 (#x7768 . #xE103)
	 (#x7769 . #xE104)
	 (#x776a . #xE105)
	 (#x776b . #xE106)
	 (#x776c . #xE107)
	 (#x776d . #xE108)
	 (#x776e . #xE109)
	 (#x776f . #xE10A)
	 (#x7770 . #xE10B)
	 (#x7771 . #xE10C)
	 (#x7772 . #xE10D)
	 (#x7773 . #xE10E)
	 (#x7774 . #xE10F)
	 (#x7775 . #xE110)
	 (#x7776 . #xE111)
	 (#x7777 . #xE112)
	 (#x7778 . #xE113)
	 (#x7779 . #xE114)
	 (#x777a . #xE115)
	 (#x777b . #xE116)
	 (#x777c . #xE117)
	 (#x777d . #xE118)
	 (#x777e . #xE119)
	 (#x7821 . #xE11A)
	 (#x7822 . #xE11B)
	 (#x7823 . #xE11C)
	 (#x7824 . #xE11D)
	 (#x7825 . #xE11E)
	 (#x7826 . #xE11F)
	 (#x7827 . #xE120)
	 (#x7828 . #xE121)
	 (#x7829 . #xE122)
	 (#x782a . #xE123)
	 (#x782b . #xE124)
	 (#x782c . #xE125)
	 (#x782d . #xE126)
	 (#x782e . #xE127)
	 (#x782f . #xE128)
	 (#x7830 . #xE129)
	 (#x7831 . #xE12A)
	 (#x7832 . #xE12B)
	 (#x7833 . #xE12C)
	 (#x7834 . #xE12D)
	 (#x7835 . #xE12E)
	 (#x7836 . #xE12F)
	 (#x7837 . #xE130)
	 (#x7838 . #xE131)
	 (#x7839 . #xE132)
	 (#x783a . #xE133)
	 (#x783b . #xE134)
	 (#x783c . #xE135)
	 (#x783d . #xE136)
	 (#x783e . #xE137)
	 (#x783f . #xE138)
	 (#x7840 . #xE139)
	 (#x7841 . #xE13A)
	 (#x7842 . #xE13B)
	 (#x7843 . #xE13C)
	 (#x7844 . #xE13D)
	 (#x7845 . #xE13E)
	 (#x7846 . #xE13F)
	 (#x7847 . #xE140)
	 (#x7848 . #xE141)
	 (#x7849 . #xE142)
	 (#x784a . #xE143)
	 (#x784b . #xE144)
	 (#x784c . #xE145)
	 (#x784d . #xE146)
	 (#x784e . #xE147)
	 (#x784f . #xE148)
	 (#x7850 . #xE149)
	 (#x7851 . #xE14A)
	 (#x7852 . #xE14B)
	 (#x7853 . #xE14C)
	 (#x7854 . #xE14D)
	 (#x7855 . #xE14E)
	 (#x7856 . #xE14F)
	 (#x7857 . #xE150)
	 (#x7858 . #xE151)
	 (#x7859 . #xE152)
	 (#x785a . #xE153)
	 (#x785b . #xE154)
	 (#x785c . #xE155)
	 (#x785d . #xE156)
	 (#x785e . #xE157)
	 (#x785f . #xE158)
	 (#x7860 . #xE159)
	 (#x7861 . #xE15A)
	 (#x7862 . #xE15B)
	 (#x7863 . #xE15C)
	 (#x7864 . #xE15D)
	 (#x7865 . #xE15E)
	 (#x7866 . #xE15F)
	 (#x7867 . #xE160)
	 (#x7868 . #xE161)
	 (#x7869 . #xE162)
	 (#x786a . #xE163)
	 (#x786b . #xE164)
	 (#x786c . #xE165)
	 (#x786d . #xE166)
	 (#x786e . #xE167)
	 (#x786f . #xE168)
	 (#x7870 . #xE169)
	 (#x7871 . #xE16A)
	 (#x7872 . #xE16B)
	 (#x7873 . #xE16C)
	 (#x7874 . #xE16D)
	 (#x7875 . #xE16E)
	 (#x7876 . #xE16F)
	 (#x7877 . #xE170)
	 (#x7878 . #xE171)
	 (#x7879 . #xE172)
	 (#x787a . #xE173)
	 (#x787b . #xE174)
	 (#x787c . #xE175)
	 (#x787d . #xE176)
	 (#x787e . #xE177)
	 (#x7921 . #xE178)
	 (#x7922 . #xE179)
	 (#x7923 . #xE17A)
	 (#x7924 . #xE17B)
	 (#x7925 . #xE17C)
	 (#x7926 . #xE17D)
	 (#x7927 . #xE17E)
	 (#x7928 . #xE17F)
	 (#x7929 . #xE180)
	 (#x792a . #xE181)
	 (#x792b . #xE182)
	 (#x792c . #xE183)
	 (#x792d . #xE184)
	 (#x792e . #xE185)
	 (#x792f . #xE186)
	 (#x7930 . #xE187)
	 (#x7931 . #xE188)
	 (#x7932 . #xE189)
	 (#x7933 . #xE18A)
	 (#x7934 . #xE18B)
	 (#x7935 . #xE18C)
	 (#x7936 . #xE18D)
	 (#x7937 . #xE18E)
	 (#x7938 . #xE18F)
	 (#x7939 . #xE190)
	 (#x793a . #xE191)
	 (#x793b . #xE192)
	 (#x793c . #xE193)
	 (#x793d . #xE194)
	 (#x793e . #xE195)
	 (#x793f . #xE196)
	 (#x7940 . #xE197)
	 (#x7941 . #xE198)
	 (#x7942 . #xE199)
	 (#x7943 . #xE19A)
	 (#x7944 . #xE19B)
	 (#x7945 . #xE19C)
	 (#x7946 . #xE19D)
	 (#x7947 . #xE19E)
	 (#x7948 . #xE19F)
	 (#x7949 . #xE1A0)
	 (#x794a . #xE1A1)
	 (#x794b . #xE1A2)
	 (#x794c . #xE1A3)
	 (#x794d . #xE1A4)
	 (#x794e . #xE1A5)
	 (#x794f . #xE1A6)
	 (#x7950 . #xE1A7)
	 (#x7951 . #xE1A8)
	 (#x7952 . #xE1A9)
	 (#x7953 . #xE1AA)
	 (#x7954 . #xE1AB)
	 (#x7955 . #xE1AC)
	 (#x7956 . #xE1AD)
	 (#x7957 . #xE1AE)
	 (#x7958 . #xE1AF)
	 (#x7959 . #xE1B0)
	 (#x795a . #xE1B1)
	 (#x795b . #xE1B2)
	 (#x795c . #xE1B3)
	 (#x795d . #xE1B4)
	 (#x795e . #xE1B5)
	 (#x795f . #xE1B6)
	 (#x7960 . #xE1B7)
	 (#x7961 . #xE1B8)
	 (#x7962 . #xE1B9)
	 (#x7963 . #xE1BA)
	 (#x7964 . #xE1BB)
	 (#x7965 . #xE1BC)
	 (#x7966 . #xE1BD)
	 (#x7967 . #xE1BE)
	 (#x7968 . #xE1BF)
	 (#x7969 . #xE1C0)
	 (#x796a . #xE1C1)
	 (#x796b . #xE1C2)
	 (#x796c . #xE1C3)
	 (#x796d . #xE1C4)
	 (#x796e . #xE1C5)
	 (#x796f . #xE1C6)
	 (#x7970 . #xE1C7)
	 (#x7971 . #xE1C8)
	 (#x7972 . #xE1C9)
	 (#x7973 . #xE1CA)
	 (#x7974 . #xE1CB)
	 (#x7975 . #xE1CC)
	 (#x7976 . #xE1CD)
	 (#x7977 . #xE1CE)
	 (#x7978 . #xE1CF)
	 (#x7979 . #xE1D0)
	 (#x797a . #xE1D1)
	 (#x797b . #xE1D2)
	 (#x797c . #xE1D3)
	 (#x797d . #xE1D4)
	 (#x797e . #xE1D5)
	 (#x7a21 . #xE1D6)
	 (#x7a22 . #xE1D7)
	 (#x7a23 . #xE1D8)
	 (#x7a24 . #xE1D9)
	 (#x7a25 . #xE1DA)
	 (#x7a26 . #xE1DB)
	 (#x7a27 . #xE1DC)
	 (#x7a28 . #xE1DD)
	 (#x7a29 . #xE1DE)
	 (#x7a2a . #xE1DF)
	 (#x7a2b . #xE1E0)
	 (#x7a2c . #xE1E1)
	 (#x7a2d . #xE1E2)
	 (#x7a2e . #xE1E3)
	 (#x7a2f . #xE1E4)
	 (#x7a30 . #xE1E5)
	 (#x7a31 . #xE1E6)
	 (#x7a32 . #xE1E7)
	 (#x7a33 . #xE1E8)
	 (#x7a34 . #xE1E9)
	 (#x7a35 . #xE1EA)
	 (#x7a36 . #xE1EB)
	 (#x7a37 . #xE1EC)
	 (#x7a38 . #xE1ED)
	 (#x7a39 . #xE1EE)
	 (#x7a3a . #xE1EF)
	 (#x7a3b . #xE1F0)
	 (#x7a3c . #xE1F1)
	 (#x7a3d . #xE1F2)
	 (#x7a3e . #xE1F3)
	 (#x7a3f . #xE1F4)
	 (#x7a40 . #xE1F5)
	 (#x7a41 . #xE1F6)
	 (#x7a42 . #xE1F7)
	 (#x7a43 . #xE1F8)
	 (#x7a44 . #xE1F9)
	 (#x7a45 . #xE1FA)
	 (#x7a46 . #xE1FB)
	 (#x7a47 . #xE1FC)
	 (#x7a48 . #xE1FD)
	 (#x7a49 . #xE1FE)
	 (#x7a4a . #xE1FF)
	 (#x7a4b . #xE200)
	 (#x7a4c . #xE201)
	 (#x7a4d . #xE202)
	 (#x7a4e . #xE203)
	 (#x7a4f . #xE204)
	 (#x7a50 . #xE205)
	 (#x7a51 . #xE206)
	 (#x7a52 . #xE207)
	 (#x7a53 . #xE208)
	 (#x7a54 . #xE209)
	 (#x7a55 . #xE20A)
	 (#x7a56 . #xE20B)
	 (#x7a57 . #xE20C)
	 (#x7a58 . #xE20D)
	 (#x7a59 . #xE20E)
	 (#x7a5a . #xE20F)
	 (#x7a5b . #xE210)
	 (#x7a5c . #xE211)
	 (#x7a5d . #xE212)
	 (#x7a5e . #xE213)
	 (#x7a5f . #xE214)
	 (#x7a60 . #xE215)
	 (#x7a61 . #xE216)
	 (#x7a62 . #xE217)
	 (#x7a63 . #xE218)
	 (#x7a64 . #xE219)
	 (#x7a65 . #xE21A)
	 (#x7a66 . #xE21B)
	 (#x7a67 . #xE21C)
	 (#x7a68 . #xE21D)
	 (#x7a69 . #xE21E)
	 (#x7a6a . #xE21F)
	 (#x7a6b . #xE220)
	 (#x7a6c . #xE221)
	 (#x7a6d . #xE222)
	 (#x7a6e . #xE223)
	 (#x7a6f . #xE224)
	 (#x7a70 . #xE225)
	 (#x7a71 . #xE226)
	 (#x7a72 . #xE227)
	 (#x7a73 . #xE228)
	 (#x7a74 . #xE229)
	 (#x7a75 . #xE22A)
	 (#x7a76 . #xE22B)
	 (#x7a77 . #xE22C)
	 (#x7a78 . #xE22D)
	 (#x7a79 . #xE22E)
	 (#x7a7a . #xE22F)
	 (#x7a7b . #xE230)
	 (#x7a7c . #xE231)
	 (#x7a7d . #xE232)
	 (#x7a7e . #xE233)
	 (#x7b21 . #xE234)
	 (#x7b22 . #xE235)
	 (#x7b23 . #xE236)
	 (#x7b24 . #xE237)
	 (#x7b25 . #xE238)
	 (#x7b26 . #xE239)
	 (#x7b27 . #xE23A)
	 (#x7b28 . #xE23B)
	 (#x7b29 . #xE23C)
	 (#x7b2a . #xE23D)
	 (#x7b2b . #xE23E)
	 (#x7b2c . #xE23F)
	 (#x7b2d . #xE240)
	 (#x7b2e . #xE241)
	 (#x7b2f . #xE242)
	 (#x7b30 . #xE243)
	 (#x7b31 . #xE244)
	 (#x7b32 . #xE245)
	 (#x7b33 . #xE246)
	 (#x7b34 . #xE247)
	 (#x7b35 . #xE248)
	 (#x7b36 . #xE249)
	 (#x7b37 . #xE24A)
	 (#x7b38 . #xE24B)
	 (#x7b39 . #xE24C)
	 (#x7b3a . #xE24D)
	 (#x7b3b . #xE24E)
	 (#x7b3c . #xE24F)
	 (#x7b3d . #xE250)
	 (#x7b3e . #xE251)
	 (#x7b3f . #xE252)
	 (#x7b40 . #xE253)
	 (#x7b41 . #xE254)
	 (#x7b42 . #xE255)
	 (#x7b43 . #xE256)
	 (#x7b44 . #xE257)
	 (#x7b45 . #xE258)
	 (#x7b46 . #xE259)
	 (#x7b47 . #xE25A)
	 (#x7b48 . #xE25B)
	 (#x7b49 . #xE25C)
	 (#x7b4a . #xE25D)
	 (#x7b4b . #xE25E)
	 (#x7b4c . #xE25F)
	 (#x7b4d . #xE260)
	 (#x7b4e . #xE261)
	 (#x7b4f . #xE262)
	 (#x7b50 . #xE263)
	 (#x7b51 . #xE264)
	 (#x7b52 . #xE265)
	 (#x7b53 . #xE266)
	 (#x7b54 . #xE267)
	 (#x7b55 . #xE268)
	 (#x7b56 . #xE269)
	 (#x7b57 . #xE26A)
	 (#x7b58 . #xE26B)
	 (#x7b59 . #xE26C)
	 (#x7b5a . #xE26D)
	 (#x7b5b . #xE26E)
	 (#x7b5c . #xE26F)
	 (#x7b5d . #xE270)
	 (#x7b5e . #xE271)
	 (#x7b5f . #xE272)
	 (#x7b60 . #xE273)
	 (#x7b61 . #xE274)
	 (#x7b62 . #xE275)
	 (#x7b63 . #xE276)
	 (#x7b64 . #xE277)
	 (#x7b65 . #xE278)
	 (#x7b66 . #xE279)
	 (#x7b67 . #xE27A)
	 (#x7b68 . #xE27B)
	 (#x7b69 . #xE27C)
	 (#x7b6a . #xE27D)
	 (#x7b6b . #xE27E)
	 (#x7b6c . #xE27F)
	 (#x7b6d . #xE280)
	 (#x7b6e . #xE281)
	 (#x7b6f . #xE282)
	 (#x7b70 . #xE283)
	 (#x7b71 . #xE284)
	 (#x7b72 . #xE285)
	 (#x7b73 . #xE286)
	 (#x7b74 . #xE287)
	 (#x7b75 . #xE288)
	 (#x7b76 . #xE289)
	 (#x7b77 . #xE28A)
	 (#x7b78 . #xE28B)
	 (#x7b79 . #xE28C)
	 (#x7b7a . #xE28D)
	 (#x7b7b . #xE28E)
	 (#x7b7c . #xE28F)
	 (#x7b7d . #xE290)
	 (#x7b7e . #xE291)
	 (#x7c21 . #xE292)
	 (#x7c22 . #xE293)
	 (#x7c23 . #xE294)
	 (#x7c24 . #xE295)
	 (#x7c25 . #xE296)
	 (#x7c26 . #xE297)
	 (#x7c27 . #xE298)
	 (#x7c28 . #xE299)
	 (#x7c29 . #xE29A)
	 (#x7c2a . #xE29B)
	 (#x7c2b . #xE29C)
	 (#x7c2c . #xE29D)
	 (#x7c2d . #xE29E)
	 (#x7c2e . #xE29F)
	 (#x7c2f . #xE2A0)
	 (#x7c30 . #xE2A1)
	 (#x7c31 . #xE2A2)
	 (#x7c32 . #xE2A3)
	 (#x7c33 . #xE2A4)
	 (#x7c34 . #xE2A5)
	 (#x7c35 . #xE2A6)
	 (#x7c36 . #xE2A7)
	 (#x7c37 . #xE2A8)
	 (#x7c38 . #xE2A9)
	 (#x7c39 . #xE2AA)
	 (#x7c3a . #xE2AB)
	 (#x7c3b . #xE2AC)
	 (#x7c3c . #xE2AD)
	 (#x7c3d . #xE2AE)
	 (#x7c3e . #xE2AF)
	 (#x7c3f . #xE2B0)
	 (#x7c40 . #xE2B1)
	 (#x7c41 . #xE2B2)
	 (#x7c42 . #xE2B3)
	 (#x7c43 . #xE2B4)
	 (#x7c44 . #xE2B5)
	 (#x7c45 . #xE2B6)
	 (#x7c46 . #xE2B7)
	 (#x7c47 . #xE2B8)
	 (#x7c48 . #xE2B9)
	 (#x7c49 . #xE2BA)
	 (#x7c4a . #xE2BB)
	 (#x7c4b . #xE2BC)
	 (#x7c4c . #xE2BD)
	 (#x7c4d . #xE2BE)
	 (#x7c4e . #xE2BF)
	 (#x7c4f . #xE2C0)
	 (#x7c50 . #xE2C1)
	 (#x7c51 . #xE2C2)
	 (#x7c52 . #xE2C3)
	 (#x7c53 . #xE2C4)
	 (#x7c54 . #xE2C5)
	 (#x7c55 . #xE2C6)
	 (#x7c56 . #xE2C7)
	 (#x7c57 . #xE2C8)
	 (#x7c58 . #xE2C9)
	 (#x7c59 . #xE2CA)
	 (#x7c5a . #xE2CB)
	 (#x7c5b . #xE2CC)
	 (#x7c5c . #xE2CD)
	 (#x7c5d . #xE2CE)
	 (#x7c5e . #xE2CF)
	 (#x7c5f . #xE2D0)
	 (#x7c60 . #xE2D1)
	 (#x7c61 . #xE2D2)
	 (#x7c62 . #xE2D3)
	 (#x7c63 . #xE2D4)
	 (#x7c64 . #xE2D5)
	 (#x7c65 . #xE2D6)
	 (#x7c66 . #xE2D7)
	 (#x7c67 . #xE2D8)
	 (#x7c68 . #xE2D9)
	 (#x7c69 . #xE2DA)
	 (#x7c6a . #xE2DB)
	 (#x7c6b . #xE2DC)
	 (#x7c6c . #xE2DD)
	 (#x7c6d . #xE2DE)
	 (#x7c6e . #xE2DF)
	 (#x7c6f . #xE2E0)
	 (#x7c70 . #xE2E1)
	 (#x7c71 . #xE2E2)
	 (#x7c72 . #xE2E3)
	 (#x7c73 . #xE2E4)
	 (#x7c74 . #xE2E5)
	 (#x7c75 . #xE2E6)
	 (#x7c76 . #xE2E7)
	 (#x7c77 . #xE2E8)
	 (#x7c78 . #xE2E9)
	 (#x7c79 . #xE2EA)
	 (#x7c7a . #xE2EB)
	 (#x7c7b . #xE2EC)
	 (#x7c7c . #xE2ED)
	 (#x7c7d . #xE2EE)
	 (#x7c7e . #xE2EF)
	 (#x7d21 . #xE2F0)
	 (#x7d22 . #xE2F1)
	 (#x7d23 . #xE2F2)
	 (#x7d24 . #xE2F3)
	 (#x7d25 . #xE2F4)
	 (#x7d26 . #xE2F5)
	 (#x7d27 . #xE2F6)
	 (#x7d28 . #xE2F7)
	 (#x7d29 . #xE2F8)
	 (#x7d2a . #xE2F9)
	 (#x7d2b . #xE2FA)
	 (#x7d2c . #xE2FB)
	 (#x7d2d . #xE2FC)
	 (#x7d2e . #xE2FD)
	 (#x7d2f . #xE2FE)
	 (#x7d30 . #xE2FF)
	 (#x7d31 . #xE300)
	 (#x7d32 . #xE301)
	 (#x7d33 . #xE302)
	 (#x7d34 . #xE303)
	 (#x7d35 . #xE304)
	 (#x7d36 . #xE305)
	 (#x7d37 . #xE306)
	 (#x7d38 . #xE307)
	 (#x7d39 . #xE308)
	 (#x7d3a . #xE309)
	 (#x7d3b . #xE30A)
	 (#x7d3c . #xE30B)
	 (#x7d3d . #xE30C)
	 (#x7d3e . #xE30D)
	 (#x7d3f . #xE30E)
	 (#x7d40 . #xE30F)
	 (#x7d41 . #xE310)
	 (#x7d42 . #xE311)
	 (#x7d43 . #xE312)
	 (#x7d44 . #xE313)
	 (#x7d45 . #xE314)
	 (#x7d46 . #xE315)
	 (#x7d47 . #xE316)
	 (#x7d48 . #xE317)
	 (#x7d49 . #xE318)
	 (#x7d4a . #xE319)
	 (#x7d4b . #xE31A)
	 (#x7d4c . #xE31B)
	 (#x7d4d . #xE31C)
	 (#x7d4e . #xE31D)
	 (#x7d4f . #xE31E)
	 (#x7d50 . #xE31F)
	 (#x7d51 . #xE320)
	 (#x7d52 . #xE321)
	 (#x7d53 . #xE322)
	 (#x7d54 . #xE323)
	 (#x7d55 . #xE324)
	 (#x7d56 . #xE325)
	 (#x7d57 . #xE326)
	 (#x7d58 . #xE327)
	 (#x7d59 . #xE328)
	 (#x7d5a . #xE329)
	 (#x7d5b . #xE32A)
	 (#x7d5c . #xE32B)
	 (#x7d5d . #xE32C)
	 (#x7d5e . #xE32D)
	 (#x7d5f . #xE32E)
	 (#x7d60 . #xE32F)
	 (#x7d61 . #xE330)
	 (#x7d62 . #xE331)
	 (#x7d63 . #xE332)
	 (#x7d64 . #xE333)
	 (#x7d65 . #xE334)
	 (#x7d66 . #xE335)
	 (#x7d67 . #xE336)
	 (#x7d68 . #xE337)
	 (#x7d69 . #xE338)
	 (#x7d6a . #xE339)
	 (#x7d6b . #xE33A)
	 (#x7d6c . #xE33B)
	 (#x7d6d . #xE33C)
	 (#x7d6e . #xE33D)
	 (#x7d6f . #xE33E)
	 (#x7d70 . #xE33F)
	 (#x7d71 . #xE340)
	 (#x7d72 . #xE341)
	 (#x7d73 . #xE342)
	 (#x7d74 . #xE343)
	 (#x7d75 . #xE344)
	 (#x7d76 . #xE345)
	 (#x7d77 . #xE346)
	 (#x7d78 . #xE347)
	 (#x7d79 . #xE348)
	 (#x7d7a . #xE349)
	 (#x7d7b . #xE34A)
	 (#x7d7c . #xE34B)
	 (#x7d7d . #xE34C)
	 (#x7d7e . #xE34D)
	 (#x7e21 . #xE34E)
	 (#x7e22 . #xE34F)
	 (#x7e23 . #xE350)
	 (#x7e24 . #xE351)
	 (#x7e25 . #xE352)
	 (#x7e26 . #xE353)
	 (#x7e27 . #xE354)
	 (#x7e28 . #xE355)
	 (#x7e29 . #xE356)
	 (#x7e2a . #xE357)
	 (#x7e2b . #xE358)
	 (#x7e2c . #xE359)
	 (#x7e2d . #xE35A)
	 (#x7e2e . #xE35B)
	 (#x7e2f . #xE35C)
	 (#x7e30 . #xE35D)
	 (#x7e31 . #xE35E)
	 (#x7e32 . #xE35F)
	 (#x7e33 . #xE360)
	 (#x7e34 . #xE361)
	 (#x7e35 . #xE362)
	 (#x7e36 . #xE363)
	 (#x7e37 . #xE364)
	 (#x7e38 . #xE365)
	 (#x7e39 . #xE366)
	 (#x7e3a . #xE367)
	 (#x7e3b . #xE368)
	 (#x7e3c . #xE369)
	 (#x7e3d . #xE36A)
	 (#x7e3e . #xE36B)
	 (#x7e3f . #xE36C)
	 (#x7e40 . #xE36D)
	 (#x7e41 . #xE36E)
	 (#x7e42 . #xE36F)
	 (#x7e43 . #xE370)
	 (#x7e44 . #xE371)
	 (#x7e45 . #xE372)
	 (#x7e46 . #xE373)
	 (#x7e47 . #xE374)
	 (#x7e48 . #xE375)
	 (#x7e49 . #xE376)
	 (#x7e4a . #xE377)
	 (#x7e4b . #xE378)
	 (#x7e4c . #xE379)
	 (#x7e4d . #xE37A)
	 (#x7e4e . #xE37B)
	 (#x7e4f . #xE37C)
	 (#x7e50 . #xE37D)
	 (#x7e51 . #xE37E)
	 (#x7e52 . #xE37F)
	 (#x7e53 . #xE380)
	 (#x7e54 . #xE381)
	 (#x7e55 . #xE382)
	 (#x7e56 . #xE383)
	 (#x7e57 . #xE384)
	 (#x7e58 . #xE385)
	 (#x7e59 . #xE386)
	 (#x7e5a . #xE387)
	 (#x7e5b . #xE388)
	 (#x7e5c . #xE389)
	 (#x7e5d . #xE38A)
	 (#x7e5e . #xE38B)
	 (#x7e5f . #xE38C)
	 (#x7e60 . #xE38D)
	 (#x7e61 . #xE38E)
	 (#x7e62 . #xE38F)
	 (#x7e63 . #xE390)
	 (#x7e64 . #xE391)
	 (#x7e65 . #xE392)
	 (#x7e66 . #xE393)
	 (#x7e67 . #xE394)
	 (#x7e68 . #xE395)
	 (#x7e69 . #xE396)
	 (#x7e6a . #xE397)
	 (#x7e6b . #xE398)
	 (#x7e6c . #xE399)
	 (#x7e6d . #xE39A)
	 (#x7e6e . #xE39B)
	 (#x7e6f . #xE39C)
	 (#x7e70 . #xE39D)
	 (#x7e71 . #xE39E)
	 (#x7e72 . #xE39F)
	 (#x7e73 . #xE3A0)
	 (#x7e74 . #xE3A1)
	 (#x7e75 . #xE3A2)
	 (#x7e76 . #xE3A3)
	 (#x7e77 . #xE3A4)
	 (#x7e78 . #xE3A5)
	 (#x7e79 . #xE3A6)
	 (#x7e7a . #xE3A7)
	 (#x7e7b . #xE3A8)
	 (#x7e7c . #xE3A9)
	 (#x7e7d . #xE3AA)
	 (#x7e7e . #xE3AB)
	 (#x7521 #xE3AC)
	 (#x7522 #xE3AD)
	 (#x7523 #xE3AE)
	 (#x7524 #xE3AF)
	 (#x7525 #xE3B0)
	 (#x7526 #xE3B1)
	 (#x7527 #xE3B2)
	 (#x7528 #xE3B3)
	 (#x7529 #xE3B4)
	 (#x752a #xE3B5)
	 (#x752b #xE3B6)
	 (#x752c #xE3B7)
	 (#x752d #xE3B8)
	 (#x752e #xE3B9)
	 (#x752f #xE3BA)
	 (#x7530 #xE3BB)
	 (#x7531 #xE3BC)
	 (#x7532 #xE3BD)
	 (#x7533 #xE3BE)
	 (#x7534 #xE3BF)
	 (#x7535 #xE3C0)
	 (#x7536 #xE3C1)
	 (#x7537 #xE3C2)
	 (#x7538 #xE3C3)
	 (#x7539 #xE3C4)
	 (#x753a #xE3C5)
	 (#x753b #xE3C6)
	 (#x753c #xE3C7)
	 (#x753d #xE3C8)
	 (#x753e #xE3C9)
	 (#x753f #xE3CA)
	 (#x7540 #xE3CB)
	 (#x7541 #xE3CC)
	 (#x7542 #xE3CD)
	 (#x7543 #xE3CE)
	 (#x7544 #xE3CF)
	 (#x7545 #xE3D0)
	 (#x7546 #xE3D1)
	 (#x7547 #xE3D2)
	 (#x7548 #xE3D3)
	 (#x7549 #xE3D4)
	 (#x754a #xE3D5)
	 (#x754b #xE3D6)
	 (#x754c #xE3D7)
	 (#x754d #xE3D8)
	 (#x754e #xE3D9)
	 (#x754f #xE3DA)
	 (#x7550 #xE3DB)
	 (#x7551 #xE3DC)
	 (#x7552 #xE3DD)
	 (#x7553 #xE3DE)
	 (#x7554 #xE3DF)
	 (#x7555 #xE3E0)
	 (#x7556 #xE3E1)
	 (#x7557 #xE3E2)
	 (#x7558 #xE3E3)
	 (#x7559 #xE3E4)
	 (#x755a #xE3E5)
	 (#x755b #xE3E6)
	 (#x755c #xE3E7)
	 (#x755d #xE3E8)
	 (#x755e #xE3E9)
	 (#x755f #xE3EA)
	 (#x7560 #xE3EB)
	 (#x7561 #xE3EC)
	 (#x7562 #xE3ED)
	 (#x7563 #xE3EE)
	 (#x7564 #xE3EF)
	 (#x7565 #xE3F0)
	 (#x7566 #xE3F1)
	 (#x7567 #xE3F2)
	 (#x7568 #xE3F3)
	 (#x7569 #xE3F4)
	 (#x756a #xE3F5)
	 (#x756b #xE3F6)
	 (#x756c #xE3F7)
	 (#x756d #xE3F8)
	 (#x756e #xE3F9)
	 (#x756f #xE3FA)
	 (#x7570 #xE3FB)
	 (#x7571 #xE3FC)
	 (#x7572 #xE3FD)
	 (#x7573 #xE3FE)
	 (#x7574 #xE3FF)
	 (#x7575 #xE400)
	 (#x7576 #xE401)
	 (#x7577 #xE402)
	 (#x7578 #xE403)
	 (#x7579 #xE404)
	 (#x757a #xE405)
	 (#x757b #xE406)
	 (#x757c #xE407)
	 (#x757d #xE408)
	 (#x757e #xE409)
	 (#x7621 #xE40A)
	 (#x7622 #xE40B)
	 (#x7623 #xE40C)
	 (#x7624 #xE40D)
	 (#x7625 #xE40E)
	 (#x7626 #xE40F)
	 (#x7627 #xE410)
	 (#x7628 #xE411)
	 (#x7629 #xE412)
	 (#x762a #xE413)
	 (#x762b #xE414)
	 (#x762c #xE415)
	 (#x762d #xE416)
	 (#x762e #xE417)
	 (#x762f #xE418)
	 (#x7630 #xE419)
	 (#x7631 #xE41A)
	 (#x7632 #xE41B)
	 (#x7633 #xE41C)
	 (#x7634 #xE41D)
	 (#x7635 #xE41E)
	 (#x7636 #xE41F)
	 (#x7637 #xE420)
	 (#x7638 #xE421)
	 (#x7639 #xE422)
	 (#x763a #xE423)
	 (#x763b #xE424)
	 (#x763c #xE425)
	 (#x763d #xE426)
	 (#x763e #xE427)
	 (#x763f #xE428)
	 (#x7640 #xE429)
	 (#x7641 #xE42A)
	 (#x7642 #xE42B)
	 (#x7643 #xE42C)
	 (#x7644 #xE42D)
	 (#x7645 #xE42E)
	 (#x7646 #xE42F)
	 (#x7647 #xE430)
	 (#x7648 #xE431)
	 (#x7649 #xE432)
	 (#x764a #xE433)
	 (#x764b #xE434)
	 (#x764c #xE435)
	 (#x764d #xE436)
	 (#x764e #xE437)
	 (#x764f #xE438)
	 (#x7650 #xE439)
	 (#x7651 #xE43A)
	 (#x7652 #xE43B)
	 (#x7653 #xE43C)
	 (#x7654 #xE43D)
	 (#x7655 #xE43E)
	 (#x7656 #xE43F)
	 (#x7657 #xE440)
	 (#x7658 #xE441)
	 (#x7659 #xE442)
	 (#x765a #xE443)
	 (#x765b #xE444)
	 (#x765c #xE445)
	 (#x765d #xE446)
	 (#x765e #xE447)
	 (#x765f #xE448)
	 (#x7660 #xE449)
	 (#x7661 #xE44A)
	 (#x7662 #xE44B)
	 (#x7663 #xE44C)
	 (#x7664 #xE44D)
	 (#x7665 #xE44E)
	 (#x7666 #xE44F)
	 (#x7667 #xE450)
	 (#x7668 #xE451)
	 (#x7669 #xE452)
	 (#x766a #xE453)
	 (#x766b #xE454)
	 (#x766c #xE455)
	 (#x766d #xE456)
	 (#x766e #xE457)
	 (#x766f #xE458)
	 (#x7670 #xE459)
	 (#x7671 #xE45A)
	 (#x7672 #xE45B)
	 (#x7673 #xE45C)
	 (#x7674 #xE45D)
	 (#x7675 #xE45E)
	 (#x7676 #xE45F)
	 (#x7677 #xE460)
	 (#x7678 #xE461)
	 (#x7679 #xE462)
	 (#x767a #xE463)
	 (#x767b #xE464)
	 (#x767c #xE465)
	 (#x767d #xE466)
	 (#x767e #xE467)
	 (#x7721 #xE468)
	 (#x7722 #xE469)
	 (#x7723 #xE46A)
	 (#x7724 #xE46B)
	 (#x7725 #xE46C)
	 (#x7726 #xE46D)
	 (#x7727 #xE46E)
	 (#x7728 #xE46F)
	 (#x7729 #xE470)
	 (#x772a #xE471)
	 (#x772b #xE472)
	 (#x772c #xE473)
	 (#x772d #xE474)
	 (#x772e #xE475)
	 (#x772f #xE476)
	 (#x7730 #xE477)
	 (#x7731 #xE478)
	 (#x7732 #xE479)
	 (#x7733 #xE47A)
	 (#x7734 #xE47B)
	 (#x7735 #xE47C)
	 (#x7736 #xE47D)
	 (#x7737 #xE47E)
	 (#x7738 #xE47F)
	 (#x7739 #xE480)
	 (#x773a #xE481)
	 (#x773b #xE482)
	 (#x773c #xE483)
	 (#x773d #xE484)
	 (#x773e #xE485)
	 (#x773f #xE486)
	 (#x7740 #xE487)
	 (#x7741 #xE488)
	 (#x7742 #xE489)
	 (#x7743 #xE48A)
	 (#x7744 #xE48B)
	 (#x7745 #xE48C)
	 (#x7746 #xE48D)
	 (#x7747 #xE48E)
	 (#x7748 #xE48F)
	 (#x7749 #xE490)
	 (#x774a #xE491)
	 (#x774b #xE492)
	 (#x774c #xE493)
	 (#x774d #xE494)
	 (#x774e #xE495)
	 (#x774f #xE496)
	 (#x7750 #xE497)
	 (#x7751 #xE498)
	 (#x7752 #xE499)
	 (#x7753 #xE49A)
	 (#x7754 #xE49B)
	 (#x7755 #xE49C)
	 (#x7756 #xE49D)
	 (#x7757 #xE49E)
	 (#x7758 #xE49F)
	 (#x7759 #xE4A0)
	 (#x775a #xE4A1)
	 (#x775b #xE4A2)
	 (#x775c #xE4A3)
	 (#x775d #xE4A4)
	 (#x775e #xE4A5)
	 (#x775f #xE4A6)
	 (#x7760 #xE4A7)
	 (#x7761 #xE4A8)
	 (#x7762 #xE4A9)
	 (#x7763 #xE4AA)
	 (#x7764 #xE4AB)
	 (#x7765 #xE4AC)
	 (#x7766 #xE4AD)
	 (#x7767 #xE4AE)
	 (#x7768 #xE4AF)
	 (#x7769 #xE4B0)
	 (#x776a #xE4B1)
	 (#x776b #xE4B2)
	 (#x776c #xE4B3)
	 (#x776d #xE4B4)
	 (#x776e #xE4B5)
	 (#x776f #xE4B6)
	 (#x7770 #xE4B7)
	 (#x7771 #xE4B8)
	 (#x7772 #xE4B9)
	 (#x7773 #xE4BA)
	 (#x7774 #xE4BB)
	 (#x7775 #xE4BC)
	 (#x7776 #xE4BD)
	 (#x7777 #xE4BE)
	 (#x7778 #xE4BF)
	 (#x7779 #xE4C0)
	 (#x777a #xE4C1)
	 (#x777b #xE4C2)
	 (#x777c #xE4C3)
	 (#x777d #xE4C4)
	 (#x777e #xE4C5)
	 (#x7821 #xE4C6)
	 (#x7822 #xE4C7)
	 (#x7823 #xE4C8)
	 (#x7824 #xE4C9)
	 (#x7825 #xE4CA)
	 (#x7826 #xE4CB)
	 (#x7827 #xE4CC)
	 (#x7828 #xE4CD)
	 (#x7829 #xE4CE)
	 (#x782a #xE4CF)
	 (#x782b #xE4D0)
	 (#x782c #xE4D1)
	 (#x782d #xE4D2)
	 (#x782e #xE4D3)
	 (#x782f #xE4D4)
	 (#x7830 #xE4D5)
	 (#x7831 #xE4D6)
	 (#x7832 #xE4D7)
	 (#x7833 #xE4D8)
	 (#x7834 #xE4D9)
	 (#x7835 #xE4DA)
	 (#x7836 #xE4DB)
	 (#x7837 #xE4DC)
	 (#x7838 #xE4DD)
	 (#x7839 #xE4DE)
	 (#x783a #xE4DF)
	 (#x783b #xE4E0)
	 (#x783c #xE4E1)
	 (#x783d #xE4E2)
	 (#x783e #xE4E3)
	 (#x783f #xE4E4)
	 (#x7840 #xE4E5)
	 (#x7841 #xE4E6)
	 (#x7842 #xE4E7)
	 (#x7843 #xE4E8)
	 (#x7844 #xE4E9)
	 (#x7845 #xE4EA)
	 (#x7846 #xE4EB)
	 (#x7847 #xE4EC)
	 (#x7848 #xE4ED)
	 (#x7849 #xE4EE)
	 (#x784a #xE4EF)
	 (#x784b #xE4F0)
	 (#x784c #xE4F1)
	 (#x784d #xE4F2)
	 (#x784e #xE4F3)
	 (#x784f #xE4F4)
	 (#x7850 #xE4F5)
	 (#x7851 #xE4F6)
	 (#x7852 #xE4F7)
	 (#x7853 #xE4F8)
	 (#x7854 #xE4F9)
	 (#x7855 #xE4FA)
	 (#x7856 #xE4FB)
	 (#x7857 #xE4FC)
	 (#x7858 #xE4FD)
	 (#x7859 #xE4FE)
	 (#x785a #xE4FF)
	 (#x785b #xE500)
	 (#x785c #xE501)
	 (#x785d #xE502)
	 (#x785e #xE503)
	 (#x785f #xE504)
	 (#x7860 #xE505)
	 (#x7861 #xE506)
	 (#x7862 #xE507)
	 (#x7863 #xE508)
	 (#x7864 #xE509)
	 (#x7865 #xE50A)
	 (#x7866 #xE50B)
	 (#x7867 #xE50C)
	 (#x7868 #xE50D)
	 (#x7869 #xE50E)
	 (#x786a #xE50F)
	 (#x786b #xE510)
	 (#x786c #xE511)
	 (#x786d #xE512)
	 (#x786e #xE513)
	 (#x786f #xE514)
	 (#x7870 #xE515)
	 (#x7871 #xE516)
	 (#x7872 #xE517)
	 (#x7873 #xE518)
	 (#x7874 #xE519)
	 (#x7875 #xE51A)
	 (#x7876 #xE51B)
	 (#x7877 #xE51C)
	 (#x7878 #xE51D)
	 (#x7879 #xE51E)
	 (#x787a #xE51F)
	 (#x787b #xE520)
	 (#x787c #xE521)
	 (#x787d #xE522)
	 (#x787e #xE523)
	 (#x7921 #xE524)
	 (#x7922 #xE525)
	 (#x7923 #xE526)
	 (#x7924 #xE527)
	 (#x7925 #xE528)
	 (#x7926 #xE529)
	 (#x7927 #xE52A)
	 (#x7928 #xE52B)
	 (#x7929 #xE52C)
	 (#x792a #xE52D)
	 (#x792b #xE52E)
	 (#x792c #xE52F)
	 (#x792d #xE530)
	 (#x792e #xE531)
	 (#x792f #xE532)
	 (#x7930 #xE533)
	 (#x7931 #xE534)
	 (#x7932 #xE535)
	 (#x7933 #xE536)
	 (#x7934 #xE537)
	 (#x7935 #xE538)
	 (#x7936 #xE539)
	 (#x7937 #xE53A)
	 (#x7938 #xE53B)
	 (#x7939 #xE53C)
	 (#x793a #xE53D)
	 (#x793b #xE53E)
	 (#x793c #xE53F)
	 (#x793d #xE540)
	 (#x793e #xE541)
	 (#x793f #xE542)
	 (#x7940 #xE543)
	 (#x7941 #xE544)
	 (#x7942 #xE545)
	 (#x7943 #xE546)
	 (#x7944 #xE547)
	 (#x7945 #xE548)
	 (#x7946 #xE549)
	 (#x7947 #xE54A)
	 (#x7948 #xE54B)
	 (#x7949 #xE54C)
	 (#x794a #xE54D)
	 (#x794b #xE54E)
	 (#x794c #xE54F)
	 (#x794d #xE550)
	 (#x794e #xE551)
	 (#x794f #xE552)
	 (#x7950 #xE553)
	 (#x7951 #xE554)
	 (#x7952 #xE555)
	 (#x7953 #xE556)
	 (#x7954 #xE557)
	 (#x7955 #xE558)
	 (#x7956 #xE559)
	 (#x7957 #xE55A)
	 (#x7958 #xE55B)
	 (#x7959 #xE55C)
	 (#x795a #xE55D)
	 (#x795b #xE55E)
	 (#x795c #xE55F)
	 (#x795d #xE560)
	 (#x795e #xE561)
	 (#x795f #xE562)
	 (#x7960 #xE563)
	 (#x7961 #xE564)
	 (#x7962 #xE565)
	 (#x7963 #xE566)
	 (#x7964 #xE567)
	 (#x7965 #xE568)
	 (#x7966 #xE569)
	 (#x7967 #xE56A)
	 (#x7968 #xE56B)
	 (#x7969 #xE56C)
	 (#x796a #xE56D)
	 (#x796b #xE56E)
	 (#x796c #xE56F)
	 (#x796d #xE570)
	 (#x796e #xE571)
	 (#x796f #xE572)
	 (#x7970 #xE573)
	 (#x7971 #xE574)
	 (#x7972 #xE575)
	 (#x7973 #xE576)
	 (#x7974 #xE577)
	 (#x7975 #xE578)
	 (#x7976 #xE579)
	 (#x7977 #xE57A)
	 (#x7978 #xE57B)
	 (#x7979 #xE57C)
	 (#x797a #xE57D)
	 (#x797b #xE57E)
	 (#x797c #xE57F)
	 (#x797d #xE580)
	 (#x797e #xE581)
	 (#x7a21 #xE582)
	 (#x7a22 #xE583)
	 (#x7a23 #xE584)
	 (#x7a24 #xE585)
	 (#x7a25 #xE586)
	 (#x7a26 #xE587)
	 (#x7a27 #xE588)
	 (#x7a28 #xE589)
	 (#x7a29 #xE58A)
	 (#x7a2a #xE58B)
	 (#x7a2b #xE58C)
	 (#x7a2c #xE58D)
	 (#x7a2d #xE58E)
	 (#x7a2e #xE58F)
	 (#x7a2f #xE590)
	 (#x7a30 #xE591)
	 (#x7a31 #xE592)
	 (#x7a32 #xE593)
	 (#x7a33 #xE594)
	 (#x7a34 #xE595)
	 (#x7a35 #xE596)
	 (#x7a36 #xE597)
	 (#x7a37 #xE598)
	 (#x7a38 #xE599)
	 (#x7a39 #xE59A)
	 (#x7a3a #xE59B)
	 (#x7a3b #xE59C)
	 (#x7a3c #xE59D)
	 (#x7a3d #xE59E)
	 (#x7a3e #xE59F)
	 (#x7a3f #xE5A0)
	 (#x7a40 #xE5A1)
	 (#x7a41 #xE5A2)
	 (#x7a42 #xE5A3)
	 (#x7a43 #xE5A4)
	 (#x7a44 #xE5A5)
	 (#x7a45 #xE5A6)
	 (#x7a46 #xE5A7)
	 (#x7a47 #xE5A8)
	 (#x7a48 #xE5A9)
	 (#x7a49 #xE5AA)
	 (#x7a4a #xE5AB)
	 (#x7a4b #xE5AC)
	 (#x7a4c #xE5AD)
	 (#x7a4d #xE5AE)
	 (#x7a4e #xE5AF)
	 (#x7a4f #xE5B0)
	 (#x7a50 #xE5B1)
	 (#x7a51 #xE5B2)
	 (#x7a52 #xE5B3)
	 (#x7a53 #xE5B4)
	 (#x7a54 #xE5B5)
	 (#x7a55 #xE5B6)
	 (#x7a56 #xE5B7)
	 (#x7a57 #xE5B8)
	 (#x7a58 #xE5B9)
	 (#x7a59 #xE5BA)
	 (#x7a5a #xE5BB)
	 (#x7a5b #xE5BC)
	 (#x7a5c #xE5BD)
	 (#x7a5d #xE5BE)
	 (#x7a5e #xE5BF)
	 (#x7a5f #xE5C0)
	 (#x7a60 #xE5C1)
	 (#x7a61 #xE5C2)
	 (#x7a62 #xE5C3)
	 (#x7a63 #xE5C4)
	 (#x7a64 #xE5C5)
	 (#x7a65 #xE5C6)
	 (#x7a66 #xE5C7)
	 (#x7a67 #xE5C8)
	 (#x7a68 #xE5C9)
	 (#x7a69 #xE5CA)
	 (#x7a6a #xE5CB)
	 (#x7a6b #xE5CC)
	 (#x7a6c #xE5CD)
	 (#x7a6d #xE5CE)
	 (#x7a6e #xE5CF)
	 (#x7a6f #xE5D0)
	 (#x7a70 #xE5D1)
	 (#x7a71 #xE5D2)
	 (#x7a72 #xE5D3)
	 (#x7a73 #xE5D4)
	 (#x7a74 #xE5D5)
	 (#x7a75 #xE5D6)
	 (#x7a76 #xE5D7)
	 (#x7a77 #xE5D8)
	 (#x7a78 #xE5D9)
	 (#x7a79 #xE5DA)
	 (#x7a7a #xE5DB)
	 (#x7a7b #xE5DC)
	 (#x7a7c #xE5DD)
	 (#x7a7d #xE5DE)
	 (#x7a7e #xE5DF)
	 (#x7b21 #xE5E0)
	 (#x7b22 #xE5E1)
	 (#x7b23 #xE5E2)
	 (#x7b24 #xE5E3)
	 (#x7b25 #xE5E4)
	 (#x7b26 #xE5E5)
	 (#x7b27 #xE5E6)
	 (#x7b28 #xE5E7)
	 (#x7b29 #xE5E8)
	 (#x7b2a #xE5E9)
	 (#x7b2b #xE5EA)
	 (#x7b2c #xE5EB)
	 (#x7b2d #xE5EC)
	 (#x7b2e #xE5ED)
	 (#x7b2f #xE5EE)
	 (#x7b30 #xE5EF)
	 (#x7b31 #xE5F0)
	 (#x7b32 #xE5F1)
	 (#x7b33 #xE5F2)
	 (#x7b34 #xE5F3)
	 (#x7b35 #xE5F4)
	 (#x7b36 #xE5F5)
	 (#x7b37 #xE5F6)
	 (#x7b38 #xE5F7)
	 (#x7b39 #xE5F8)
	 (#x7b3a #xE5F9)
	 (#x7b3b #xE5FA)
	 (#x7b3c #xE5FB)
	 (#x7b3d #xE5FC)
	 (#x7b3e #xE5FD)
	 (#x7b3f #xE5FE)
	 (#x7b40 #xE5FF)
	 (#x7b41 #xE600)
	 (#x7b42 #xE601)
	 (#x7b43 #xE602)
	 (#x7b44 #xE603)
	 (#x7b45 #xE604)
	 (#x7b46 #xE605)
	 (#x7b47 #xE606)
	 (#x7b48 #xE607)
	 (#x7b49 #xE608)
	 (#x7b4a #xE609)
	 (#x7b4b #xE60A)
	 (#x7b4c #xE60B)
	 (#x7b4d #xE60C)
	 (#x7b4e #xE60D)
	 (#x7b4f #xE60E)
	 (#x7b50 #xE60F)
	 (#x7b51 #xE610)
	 (#x7b52 #xE611)
	 (#x7b53 #xE612)
	 (#x7b54 #xE613)
	 (#x7b55 #xE614)
	 (#x7b56 #xE615)
	 (#x7b57 #xE616)
	 (#x7b58 #xE617)
	 (#x7b59 #xE618)
	 (#x7b5a #xE619)
	 (#x7b5b #xE61A)
	 (#x7b5c #xE61B)
	 (#x7b5d #xE61C)
	 (#x7b5e #xE61D)
	 (#x7b5f #xE61E)
	 (#x7b60 #xE61F)
	 (#x7b61 #xE620)
	 (#x7b62 #xE621)
	 (#x7b63 #xE622)
	 (#x7b64 #xE623)
	 (#x7b65 #xE624)
	 (#x7b66 #xE625)
	 (#x7b67 #xE626)
	 (#x7b68 #xE627)
	 (#x7b69 #xE628)
	 (#x7b6a #xE629)
	 (#x7b6b #xE62A)
	 (#x7b6c #xE62B)
	 (#x7b6d #xE62C)
	 (#x7b6e #xE62D)
	 (#x7b6f #xE62E)
	 (#x7b70 #xE62F)
	 (#x7b71 #xE630)
	 (#x7b72 #xE631)
	 (#x7b73 #xE632)
	 (#x7b74 #xE633)
	 (#x7b75 #xE634)
	 (#x7b76 #xE635)
	 (#x7b77 #xE636)
	 (#x7b78 #xE637)
	 (#x7b79 #xE638)
	 (#x7b7a #xE639)
	 (#x7b7b #xE63A)
	 (#x7b7c #xE63B)
	 (#x7b7d #xE63C)
	 (#x7b7e #xE63D)
	 (#x7c21 #xE63E)
	 (#x7c22 #xE63F)
	 (#x7c23 #xE640)
	 (#x7c24 #xE641)
	 (#x7c25 #xE642)
	 (#x7c26 #xE643)
	 (#x7c27 #xE644)
	 (#x7c28 #xE645)
	 (#x7c29 #xE646)
	 (#x7c2a #xE647)
	 (#x7c2b #xE648)
	 (#x7c2c #xE649)
	 (#x7c2d #xE64A)
	 (#x7c2e #xE64B)
	 (#x7c2f #xE64C)
	 (#x7c30 #xE64D)
	 (#x7c31 #xE64E)
	 (#x7c32 #xE64F)
	 (#x7c33 #xE650)
	 (#x7c34 #xE651)
	 (#x7c35 #xE652)
	 (#x7c36 #xE653)
	 (#x7c37 #xE654)
	 (#x7c38 #xE655)
	 (#x7c39 #xE656)
	 (#x7c3a #xE657)
	 (#x7c3b #xE658)
	 (#x7c3c #xE659)
	 (#x7c3d #xE65A)
	 (#x7c3e #xE65B)
	 (#x7c3f #xE65C)
	 (#x7c40 #xE65D)
	 (#x7c41 #xE65E)
	 (#x7c42 #xE65F)
	 (#x7c43 #xE660)
	 (#x7c44 #xE661)
	 (#x7c45 #xE662)
	 (#x7c46 #xE663)
	 (#x7c47 #xE664)
	 (#x7c48 #xE665)
	 (#x7c49 #xE666)
	 (#x7c4a #xE667)
	 (#x7c4b #xE668)
	 (#x7c4c #xE669)
	 (#x7c4d #xE66A)
	 (#x7c4e #xE66B)
	 (#x7c4f #xE66C)
	 (#x7c50 #xE66D)
	 (#x7c51 #xE66E)
	 (#x7c52 #xE66F)
	 (#x7c53 #xE670)
	 (#x7c54 #xE671)
	 (#x7c55 #xE672)
	 (#x7c56 #xE673)
	 (#x7c57 #xE674)
	 (#x7c58 #xE675)
	 (#x7c59 #xE676)
	 (#x7c5a #xE677)
	 (#x7c5b #xE678)
	 (#x7c5c #xE679)
	 (#x7c5d #xE67A)
	 (#x7c5e #xE67B)
	 (#x7c5f #xE67C)
	 (#x7c60 #xE67D)
	 (#x7c61 #xE67E)
	 (#x7c62 #xE67F)
	 (#x7c63 #xE680)
	 (#x7c64 #xE681)
	 (#x7c65 #xE682)
	 (#x7c66 #xE683)
	 (#x7c67 #xE684)
	 (#x7c68 #xE685)
	 (#x7c69 #xE686)
	 (#x7c6a #xE687)
	 (#x7c6b #xE688)
	 (#x7c6c #xE689)
	 (#x7c6d #xE68A)
	 (#x7c6e #xE68B)
	 (#x7c6f #xE68C)
	 (#x7c70 #xE68D)
	 (#x7c71 #xE68E)
	 (#x7c72 #xE68F)
	 (#x7c73 #xE690)
	 (#x7c74 #xE691)
	 (#x7c75 #xE692)
	 (#x7c76 #xE693)
	 (#x7c77 #xE694)
	 (#x7c78 #xE695)
	 (#x7c79 #xE696)
	 (#x7c7a #xE697)
	 (#x7c7b #xE698)
	 (#x7c7c #xE699)
	 (#x7c7d #xE69A)
	 (#x7c7e #xE69B)
	 (#x7d21 #xE69C)
	 (#x7d22 #xE69D)
	 (#x7d23 #xE69E)
	 (#x7d24 #xE69F)
	 (#x7d25 #xE6A0)
	 (#x7d26 #xE6A1)
	 (#x7d27 #xE6A2)
	 (#x7d28 #xE6A3)
	 (#x7d29 #xE6A4)
	 (#x7d2a #xE6A5)
	 (#x7d2b #xE6A6)
	 (#x7d2c #xE6A7)
	 (#x7d2d #xE6A8)
	 (#x7d2e #xE6A9)
	 (#x7d2f #xE6AA)
	 (#x7d30 #xE6AB)
	 (#x7d31 #xE6AC)
	 (#x7d32 #xE6AD)
	 (#x7d33 #xE6AE)
	 (#x7d34 #xE6AF)
	 (#x7d35 #xE6B0)
	 (#x7d36 #xE6B1)
	 (#x7d37 #xE6B2)
	 (#x7d38 #xE6B3)
	 (#x7d39 #xE6B4)
	 (#x7d3a #xE6B5)
	 (#x7d3b #xE6B6)
	 (#x7d3c #xE6B7)
	 (#x7d3d #xE6B8)
	 (#x7d3e #xE6B9)
	 (#x7d3f #xE6BA)
	 (#x7d40 #xE6BB)
	 (#x7d41 #xE6BC)
	 (#x7d42 #xE6BD)
	 (#x7d43 #xE6BE)
	 (#x7d44 #xE6BF)
	 (#x7d45 #xE6C0)
	 (#x7d46 #xE6C1)
	 (#x7d47 #xE6C2)
	 (#x7d48 #xE6C3)
	 (#x7d49 #xE6C4)
	 (#x7d4a #xE6C5)
	 (#x7d4b #xE6C6)
	 (#x7d4c #xE6C7)
	 (#x7d4d #xE6C8)
	 (#x7d4e #xE6C9)
	 (#x7d4f #xE6CA)
	 (#x7d50 #xE6CB)
	 (#x7d51 #xE6CC)
	 (#x7d52 #xE6CD)
	 (#x7d53 #xE6CE)
	 (#x7d54 #xE6CF)
	 (#x7d55 #xE6D0)
	 (#x7d56 #xE6D1)
	 (#x7d57 #xE6D2)
	 (#x7d58 #xE6D3)
	 (#x7d59 #xE6D4)
	 (#x7d5a #xE6D5)
	 (#x7d5b #xE6D6)
	 (#x7d5c #xE6D7)
	 (#x7d5d #xE6D8)
	 (#x7d5e #xE6D9)
	 (#x7d5f #xE6DA)
	 (#x7d60 #xE6DB)
	 (#x7d61 #xE6DC)
	 (#x7d62 #xE6DD)
	 (#x7d63 #xE6DE)
	 (#x7d64 #xE6DF)
	 (#x7d65 #xE6E0)
	 (#x7d66 #xE6E1)
	 (#x7d67 #xE6E2)
	 (#x7d68 #xE6E3)
	 (#x7d69 #xE6E4)
	 (#x7d6a #xE6E5)
	 (#x7d6b #xE6E6)
	 (#x7d6c #xE6E7)
	 (#x7d6d #xE6E8)
	 (#x7d6e #xE6E9)
	 (#x7d6f #xE6EA)
	 (#x7d70 #xE6EB)
	 (#x7d71 #xE6EC)
	 (#x7d72 #xE6ED)
	 (#x7d73 #xE6EE)
	 (#x7d74 #xE6EF)
	 (#x7d75 #xE6F0)
	 (#x7d76 #xE6F1)
	 (#x7d77 #xE6F2)
	 (#x7d78 #xE6F3)
	 (#x7d79 #xE6F4)
	 (#x7d7a #xE6F5)
	 (#x7d7b #xE6F6)
	 (#x7d7c #xE6F7)
	 (#x7d7d #xE6F8)
	 (#x7d7e #xE6F9)
	 (#x7e21 #xE6FA)
	 (#x7e22 #xE6FB)
	 (#x7e23 #xE6FC)
	 (#x7e24 #xE6FD)
	 (#x7e25 #xE6FE)
	 (#x7e26 #xE6FF)
	 (#x7e27 #xE700)
	 (#x7e28 #xE701)
	 (#x7e29 #xE702)
	 (#x7e2a #xE703)
	 (#x7e2b #xE704)
	 (#x7e2c #xE705)
	 (#x7e2d #xE706)
	 (#x7e2e #xE707)
	 (#x7e2f #xE708)
	 (#x7e30 #xE709)
	 (#x7e31 #xE70A)
	 (#x7e32 #xE70B)
	 (#x7e33 #xE70C)
	 (#x7e34 #xE70D)
	 (#x7e35 #xE70E)
	 (#x7e36 #xE70F)
	 (#x7e37 #xE710)
	 (#x7e38 #xE711)
	 (#x7e39 #xE712)
	 (#x7e3a #xE713)
	 (#x7e3b #xE714)
	 (#x7e3c #xE715)
	 (#x7e3d #xE716)
	 (#x7e3e #xE717)
	 (#x7e3f #xE718)
	 (#x7e40 #xE719)
	 (#x7e41 #xE71A)
	 (#x7e42 #xE71B)
	 (#x7e43 #xE71C)
	 (#x7e44 #xE71D)
	 (#x7e45 #xE71E)
	 (#x7e46 #xE71F)
	 (#x7e47 #xE720)
	 (#x7e48 #xE721)
	 (#x7e49 #xE722)
	 (#x7e4a #xE723)
	 (#x7e4b #xE724)
	 (#x7e4c #xE725)
	 (#x7e4d #xE726)
	 (#x7e4e #xE727)
	 (#x7e4f #xE728)
	 (#x7e50 #xE729)
	 (#x7e51 #xE72A)
	 (#x7e52 #xE72B)
	 (#x7e53 #xE72C)
	 (#x7e54 #xE72D)
	 (#x7e55 #xE72E)
	 (#x7e56 #xE72F)
	 (#x7e57 #xE730)
	 (#x7e58 #xE731)
	 (#x7e59 #xE732)
	 (#x7e5a #xE733)
	 (#x7e5b #xE734)
	 (#x7e5c #xE735)
	 (#x7e5d #xE736)
	 (#x7e5e #xE737)
	 (#x7e5f #xE738)
	 (#x7e60 #xE739)
	 (#x7e61 #xE73A)
	 (#x7e62 #xE73B)
	 (#x7e63 #xE73C)
	 (#x7e64 #xE73D)
	 (#x7e65 #xE73E)
	 (#x7e66 #xE73F)
	 (#x7e67 #xE740)
	 (#x7e68 #xE741)
	 (#x7e69 #xE742)
	 (#x7e6a #xE743)
	 (#x7e6b #xE744)
	 (#x7e6c #xE745)
	 (#x7e6d #xE746)
	 (#x7e6e #xE747)
	 (#x7e6f #xE748)
	 (#x7e70 #xE749)
	 (#x7e71 #xE74A)
	 (#x7e72 #xE74B)
	 (#x7e73 #xE74C)
	 (#x7e74 #xE74D)
	 (#x7e75 #xE74E)
	 (#x7e76 #xE74F)
	 (#x7e77 #xE750)
	 (#x7e78 #xE751)
	 (#x7e79 #xE752)
	 (#x7e7a #xE753)
	 (#x7e7b #xE754)
	 (#x7e7c #xE755)
	 (#x7e7d #xE756)
	 (#x7e7e #xE757)
	 (#x7373 #x2170)
	 (#x7374 #x2171)
	 (#x7375 #x2172)
	 (#x7376 #x2173)
	 (#x7377 #x2174)
	 (#x7378 #x2175)
	 (#x7379 #x2176)
	 (#x737a #x2177)
	 (#x737b #x2178)
	 (#x737c #x2179)
	 (#x737d #x2160)
	 (#x737e #x2161)
	 (#x7421 #x2162)
	 (#x7422 #x2163)
	 (#x7423 #x2164)
	 (#x7424 #x2165)
	 (#x7425 #x2166)
	 (#x7426 #x2167)
	 (#x7427 #x2168)
	 (#x7428 #x2169)
	 (#x7429 #xFF07)
	 (#x742a #xFF02)
	 (#x742b #x3231)
	 (#x742c #x2116)
	 (#x742d #x2121)
	 (#x742e #x70BB)
	 (#x742f #x4EFC)
	 (#x7430 #x50F4)
	 (#x7431 #x51EC)
	 (#x7432 #x5307)
	 (#x7433 #x5324)
	 (#x7434 #xFA0E)
	 (#x7435 #x548A)
	 (#x7436 #x5759)
	 (#x7437 #xFA0F)
	 (#x7438 #xFA10)
	 (#x7439 #x589E)
	 (#x743a #x5BEC)
	 (#x743b #x5CF5)
	 (#x743c #x5D53)
	 (#x743d #xFA11)
	 (#x743e #x5FB7)
	 (#x743f #x6085)
	 (#x7440 #x6120)
	 (#x7441 #x654E)
	 (#x7442 #x663B)
	 (#x7443 #x6665)
	 (#x7444 #xFA12)
	 (#x7445 #xF929)
	 (#x7446 #x6801)
	 (#x7447 #xFA13)
	 (#x7448 #xFA14)
	 (#x7449 #x6A6B)
	 (#x744a #x6AE2)
	 (#x744b #x6DF8)
	 (#x744c #x6DF2)
	 (#x744d #x7028)
	 (#x744e #xFA15)
	 (#x744f #xFA16)
	 (#x7450 #x7501)
	 (#x7451 #x7682)
	 (#x7452 #x769E)
	 (#x7453 #xFA17)
	 (#x7454 #x7930)
	 (#x7455 #xFA18)
	 (#x7456 #xFA19)
	 (#x7457 #xFA1A)
	 (#x7458 #xFA1B)
	 (#x7459 #x7AE7)
	 (#x745a #xFA1C)
	 (#x745b #xFA1D)
	 (#x745c #x7DA0)
	 (#x745d #x7DD6)
	 (#x745e #xFA1E)
	 (#x745f #x8362)
	 (#x7460 #xFA1F)
	 (#x7461 #x85B0)
	 (#x7462 #xFA20)
	 (#x7463 #xFA21)
	 (#x7464 #x8807)
	 (#x7465 #xFA22)
	 (#x7466 #x8B7F)
	 (#x7467 #x8CF4)
	 (#x7468 #x8D76)
	 (#x7469 #xFA23)
	 (#x746a #xFA24)
	 (#x746b #xFA25)
	 (#x746c #x90DE)
	 (#x746d #xFA26)
	 (#x746e #x9115)
	 (#x746f #xFA27)
	 (#x7470 #xFA28)
	 (#x7471 #x9592)
	 (#x7472 #xF9DC)
	 (#x7473 #xFA29)
	 (#x7474 #x973B)
	 (#x7475 #x974D)
	 (#x7476 #x9751)
	 (#x7477 #xFA2A)
	 (#x7478 #xFA2B)
	 (#x7479 #xFA2C)
	 (#x747a #x999E)
	 (#x747b #x9AD9)
	 (#x747c #x9B72)
	 (#x747d #xFA2D)
	 (#x747e #x9ED1))))
  (mapc #'(lambda (x)
	    (if (integerp (cdr x))
		(setcar x (decode-char 'japanese-jisx0208 (car x)))
	      (setcar x (decode-char 'japanese-jisx0212 (car x)))
	      (setcdr x (cadr x))))
	map)
  (define-translation-table 'eucjp-ms-decode map)
  (mapc #'(lambda (x)
	    (let ((tmp (car x)))
	      (setcar x (cdr x)) (setcdr x tmp)))
	map)
  (define-translation-table 'eucjp-ms-encode map))

;; arch-tag: c4191096-288a-4f13-9b2a-ee7a1f11eb4a
