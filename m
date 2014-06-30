From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] [v2] crypto: sha512: add ARM NEON implementation
Date: Mon, 30 Jun 2014 10:25:52 +0200
Message-ID: <CAKv+Gu_88cAt-ypz2PyR=gOaLC--Qx+K-Mbe1ZjAxCPqE3tEag@mail.gmail.com>
References: <20140629143443.19040.40836.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:44246 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaF3IZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jun 2014 04:25:55 -0400
Received: by mail-la0-f46.google.com with SMTP id el20so4628941lab.33
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2014 01:25:53 -0700 (PDT)
In-Reply-To: <20140629143443.19040.40836.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29 June 2014 16:34, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> This patch adds ARM NEON assembly implementation of SHA-512 and SHA-3=
84
> algorithms.
>
> tcrypt benchmark results on Cortex-A8, sha512-generic vs sha512-neon-=
asm:
>
> block-size      bytes/update    old-vs-new
> 16              16              2.99x
> 64              16              2.67x
> 64              64              3.00x
> 256             16              2.64x
> 256             64              3.06x
> 256             256             3.33x
> 1024            16              2.53x
> 1024            256             3.39x
> 1024            1024            3.52x
> 2048            16              2.50x
> 2048            256             3.41x
> 2048            1024            3.54x
> 2048            2048            3.57x
> 4096            16              2.49x
> 4096            256             3.42x
> 4096            1024            3.56x
> 4096            4096            3.59x
> 8192            16              2.48x
> 8192            256             3.42x
> 8192            1024            3.56x
> 8192            4096            3.60x
> 8192            8192            3.60x
>

Nice speedup!

> Changes in v2:
>  - Use ENTRY/ENDPROC
>  - Don't provide Thumb2 version
>

Please move Changelog below '---'

> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Tested on Exynos-5250 (Cortex-A15)

ARM-asm
=3D=3D=3D=3D=3D=3D=3D=3D
[ 1715.164122] testing speed of sha512
[ 1715.164150] test  0 (   16 byte blocks,   16 bytes per update,   1
updates): 136277 opers/sec,   2180437 bytes/sec
[ 1718.159959] test  1 (   64 byte blocks,   16 bytes per update,   4
updates): 126636 opers/sec,   8104746 bytes/sec
[ 1721.159962] test  2 (   64 byte blocks,   64 bytes per update,   1
updates): 136605 opers/sec,   8742720 bytes/sec
[ 1724.159958] test  3 (  256 byte blocks,   16 bytes per update,  16
updates):  41576 opers/sec,  10643541 bytes/sec
[ 1727.159957] test  4 (  256 byte blocks,   64 bytes per update,   4
updates):  45984 opers/sec,  11771989 bytes/sec
[ 1730.159959] test  5 (  256 byte blocks,  256 bytes per update,   1
updates):  47479 opers/sec,  12154794 bytes/sec
[ 1733.159977] test  6 ( 1024 byte blocks,   16 bytes per update,  64
updates):  13410 opers/sec,  13731840 bytes/sec
[ 1736.160027] test  7 ( 1024 byte blocks,  256 bytes per update,   4
updates):  15916 opers/sec,  16298325 bytes/sec
[ 1739.159975] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates):  16095 opers/sec,  16481280 bytes/sec
[ 1742.159993] test  9 ( 2048 byte blocks,   16 bytes per update, 128
updates):   7042 opers/sec,  14423381 bytes/sec
[ 1745.159994] test 10 ( 2048 byte blocks,  256 bytes per update,   8
updates):   8438 opers/sec,  17281024 bytes/sec
[ 1748.159995] test 11 ( 2048 byte blocks, 1024 bytes per update,   2
updates):   8541 opers/sec,  17492650 bytes/sec
[ 1751.160001] test 12 ( 2048 byte blocks, 2048 bytes per update,   1
updates):   8560 opers/sec,  17531562 bytes/sec
[ 1754.159975] test 13 ( 4096 byte blocks,   16 bytes per update, 256
updates):   3612 opers/sec,  14794752 bytes/sec
[ 1757.160103] test 14 ( 4096 byte blocks,  256 bytes per update,  16
updates):   4350 opers/sec,  17820330 bytes/sec
[ 1760.160122] test 15 ( 4096 byte blocks, 1024 bytes per update,   4
updates):   4405 opers/sec,  18042880 bytes/sec
[ 1763.159957] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):   4463 opers/sec,  18280448 bytes/sec
[ 1766.160049] test 17 ( 8192 byte blocks,   16 bytes per update, 512
updates):   1829 opers/sec,  14988629 bytes/sec
[ 1769.160328] test 18 ( 8192 byte blocks,  256 bytes per update,  32
updates):   2209 opers/sec,  18101589 bytes/sec
[ 1772.160318] test 19 ( 8192 byte blocks, 1024 bytes per update,   8
updates):   2238 opers/sec,  18333696 bytes/sec
[ 1775.160278] test 20 ( 8192 byte blocks, 4096 bytes per update,   2
updates):   2245 opers/sec,  18393770 bytes/sec
[ 1778.160025] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):   2267 opers/sec,  18576725 bytes/sec

ARM-neon
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 1810.729100] testing speed of sha512
[ 1810.729130] test  0 (   16 byte blocks,   16 bytes per update,   1
updates): 330941 opers/sec,   5295066 bytes/sec
[ 1813.724958] test  1 (   64 byte blocks,   16 bytes per update,   4
updates): 277607 opers/sec,  17766890 bytes/sec
[ 1816.724958] test  2 (   64 byte blocks,   64 bytes per update,   1
updates): 330251 opers/sec,  21136085 bytes/sec
[ 1819.724956] test  3 (  256 byte blocks,   16 bytes per update,  16
updates):  89849 opers/sec,  23001429 bytes/sec
[ 1822.724961] test  4 (  256 byte blocks,   64 bytes per update,   4
updates): 113344 opers/sec,  29016149 bytes/sec
[ 1825.724963] test  5 (  256 byte blocks,  256 bytes per update,   1
updates): 127466 opers/sec,  32631381 bytes/sec
[ 1828.724960] test  6 ( 1024 byte blocks,   16 bytes per update,  64
updates):  27818 opers/sec,  28485632 bytes/sec
[ 1831.724984] test  7 ( 1024 byte blocks,  256 bytes per update,   4
updates):  43672 opers/sec,  44720810 bytes/sec
[ 1834.724956] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates):  46260 opers/sec,  47370240 bytes/sec
[ 1837.724959] test  9 ( 2048 byte blocks,   16 bytes per update, 128
updates):  14483 opers/sec,  29661184 bytes/sec
[ 1840.725016] test 10 ( 2048 byte blocks,  256 bytes per update,   8
updates):  23254 opers/sec,  47624874 bytes/sec
[ 1843.724987] test 11 ( 2048 byte blocks, 1024 bytes per update,   2
updates):  24704 opers/sec,  50595157 bytes/sec
[ 1846.724962] test 12 ( 2048 byte blocks, 2048 bytes per update,   1
updates):  25007 opers/sec,  51215701 bytes/sec
[ 1849.724967] test 13 ( 4096 byte blocks,   16 bytes per update, 256
updates):   7392 opers/sec,  30280362 bytes/sec
[ 1852.725032] test 14 ( 4096 byte blocks,  256 bytes per update,  16
updates):  12004 opers/sec,  49171114 bytes/sec
[ 1855.725007] test 15 ( 4096 byte blocks, 1024 bytes per update,   4
updates):  12801 opers/sec,  52434261 bytes/sec
[ 1858.725014] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):  13031 opers/sec,  53376341 bytes/sec
[ 1861.725029] test 17 ( 8192 byte blocks,   16 bytes per update, 512
updates):   3733 opers/sec,  30580736 bytes/sec
[ 1864.725041] test 18 ( 8192 byte blocks,  256 bytes per update,  32
updates):   6108 opers/sec,  50042197 bytes/sec
[ 1867.725071] test 19 ( 8192 byte blocks, 1024 bytes per update,   8
updates):   6518 opers/sec,  53395456 bytes/sec
[ 1870.725106] test 20 ( 8192 byte blocks, 4096 bytes per update,   2
updates):   6635 opers/sec,  54353920 bytes/sec
[ 1873.725038] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):   6637 opers/sec,  54375765 bytes/sec


> ---
>  arch/arm/crypto/Makefile            |    2
>  arch/arm/crypto/sha512-armv7-neon.S |  455 +++++++++++++++++++++++++=
++++++++++
>  arch/arm/crypto/sha512_neon_glue.c  |  305 +++++++++++++++++++++++
>  crypto/Kconfig                      |   15 +
>  4 files changed, 777 insertions(+)
>  create mode 100644 arch/arm/crypto/sha512-armv7-neon.S
>  create mode 100644 arch/arm/crypto/sha512_neon_glue.c
>
> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> index 374956d..b48fa34 100644
> --- a/arch/arm/crypto/Makefile
> +++ b/arch/arm/crypto/Makefile
> @@ -6,11 +6,13 @@ obj-$(CONFIG_CRYPTO_AES_ARM) +=3D aes-arm.o
>  obj-$(CONFIG_CRYPTO_AES_ARM_BS) +=3D aes-arm-bs.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM) +=3D sha1-arm.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) +=3D sha1-arm-neon.o
> +obj-$(CONFIG_CRYPTO_SHA512_ARM_NEON) +=3D sha512-arm-neon.o
>
>  aes-arm-y      :=3D aes-armv4.o aes_glue.o
>  aes-arm-bs-y   :=3D aesbs-core.o aesbs-glue.o
>  sha1-arm-y     :=3D sha1-armv4-large.o sha1_glue.o
>  sha1-arm-neon-y        :=3D sha1-armv7-neon.o sha1_neon_glue.o
> +sha512-arm-neon-y :=3D sha512-armv7-neon.o sha512_neon_glue.o
>
>  quiet_cmd_perl =3D PERL    $@
>        cmd_perl =3D $(PERL) $(<) > $(@)
> diff --git a/arch/arm/crypto/sha512-armv7-neon.S b/arch/arm/crypto/sh=
a512-armv7-neon.S
> new file mode 100644
> index 0000000..fe99472
> --- /dev/null
> +++ b/arch/arm/crypto/sha512-armv7-neon.S
> @@ -0,0 +1,455 @@
> +/* sha512-armv7-neon.S  -  ARM/NEON assembly implementation of SHA-5=
12 transform
> + *
> + * Copyright =C2=A9 2013-2014 Jussi Kivilinna <jussi.kivilinna@iki.f=
i>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the Free
> + * Software Foundation; either version 2 of the License, or (at your=
 option)
> + * any later version.
> + */
> +
> +#include <linux/linkage.h>
> +
> +
> +.syntax unified
> +.code   32
> +.fpu neon
> +
> +.text
> +
> +/* structure of SHA512_CONTEXT */
> +#define hd_a 0
> +#define hd_b ((hd_a) + 8)
> +#define hd_c ((hd_b) + 8)
> +#define hd_d ((hd_c) + 8)
> +#define hd_e ((hd_d) + 8)
> +#define hd_f ((hd_e) + 8)
> +#define hd_g ((hd_f) + 8)
> +
> +/* register macros */
> +#define RK %r2
> +
> +#define RA d0
> +#define RB d1
> +#define RC d2
> +#define RD d3
> +#define RE d4
> +#define RF d5
> +#define RG d6
> +#define RH d7
> +
> +#define RT0 d8
> +#define RT1 d9
> +#define RT2 d10
> +#define RT3 d11
> +#define RT4 d12
> +#define RT5 d13
> +#define RT6 d14
> +#define RT7 d15
> +
> +#define RT01q q4
> +#define RT23q q5
> +#define RT45q q6
> +#define RT67q q7
> +
> +#define RW0 d16
> +#define RW1 d17
> +#define RW2 d18
> +#define RW3 d19
> +#define RW4 d20
> +#define RW5 d21
> +#define RW6 d22
> +#define RW7 d23
> +#define RW8 d24
> +#define RW9 d25
> +#define RW10 d26
> +#define RW11 d27
> +#define RW12 d28
> +#define RW13 d29
> +#define RW14 d30
> +#define RW15 d31
> +
> +#define RW01q q8
> +#define RW23q q9
> +#define RW45q q10
> +#define RW67q q11
> +#define RW89q q12
> +#define RW1011q q13
> +#define RW1213q q14
> +#define RW1415q q15
> +
> +/*******************************************************************=
****
> + * ARM assembly implementation of sha512 transform
> + *******************************************************************=
****/
> +#define rounds2_0_63(ra, rb, rc, rd, re, rf, rg, rh, rw0, rw1, rw01q=
, rw2, \
> +                     rw23q, rw1415q, rw9, rw10, interleave_op, arg1)=
 \
> +       /* t1 =3D h + Sum1 (e) + Ch (e, f, g) + k[t] + w[t]; */ \
> +       vshr.u64 RT2, re, #14; \
> +       vshl.u64 RT3, re, #64 - 14; \
> +       interleave_op(arg1); \
> +       vshr.u64 RT4, re, #18; \
> +       vshl.u64 RT5, re, #64 - 18; \
> +       vld1.64 {RT0}, [RK]!; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, re, #41; \
> +       vshl.u64 RT5, re, #64 - 41; \
> +       vadd.u64 RT0, RT0, rw0; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vmov.64 RT7, re; \
> +       veor.64 RT1, RT2, RT3; \
> +       vbsl.64 RT7, rf, rg; \
> +       \
> +       vadd.u64 RT1, RT1, rh; \
> +       vshr.u64 RT2, ra, #28; \
> +       vshl.u64 RT3, ra, #64 - 28; \
> +       vadd.u64 RT1, RT1, RT0; \
> +       vshr.u64 RT4, ra, #34; \
> +       vshl.u64 RT5, ra, #64 - 34; \
> +       vadd.u64 RT1, RT1, RT7; \
> +       \
> +       /* h =3D Sum0 (a) + Maj (a, b, c); */ \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, ra, #39; \
> +       vshl.u64 RT5, ra, #64 - 39; \
> +       veor.64 RT0, ra, rb; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vbsl.64 RT0, rc, rb; \
> +       vadd.u64 rd, rd, RT1; /* d+=3Dt1; */ \
> +       veor.64 rh, RT2, RT3; \
> +       \
> +       /* t1 =3D g + Sum1 (d) + Ch (d, e, f) + k[t] + w[t]; */ \
> +       vshr.u64 RT2, rd, #14; \
> +       vshl.u64 RT3, rd, #64 - 14; \
> +       vadd.u64 rh, rh, RT0; \
> +       vshr.u64 RT4, rd, #18; \
> +       vshl.u64 RT5, rd, #64 - 18; \
> +       vadd.u64 rh, rh, RT1; /* h+=3Dt1; */ \
> +       vld1.64 {RT0}, [RK]!; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, rd, #41; \
> +       vshl.u64 RT5, rd, #64 - 41; \
> +       vadd.u64 RT0, RT0, rw1; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vmov.64 RT7, rd; \
> +       veor.64 RT1, RT2, RT3; \
> +       vbsl.64 RT7, re, rf; \
> +       \
> +       vadd.u64 RT1, RT1, rg; \
> +       vshr.u64 RT2, rh, #28; \
> +       vshl.u64 RT3, rh, #64 - 28; \
> +       vadd.u64 RT1, RT1, RT0; \
> +       vshr.u64 RT4, rh, #34; \
> +       vshl.u64 RT5, rh, #64 - 34; \
> +       vadd.u64 RT1, RT1, RT7; \
> +       \
> +       /* g =3D Sum0 (h) + Maj (h, a, b); */ \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, rh, #39; \
> +       vshl.u64 RT5, rh, #64 - 39; \
> +       veor.64 RT0, rh, ra; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vbsl.64 RT0, rb, ra; \
> +       vadd.u64 rc, rc, RT1; /* c+=3Dt1; */ \
> +       veor.64 rg, RT2, RT3; \
> +       \
> +       /* w[0] +=3D S1 (w[14]) + w[9] + S0 (w[1]); */ \
> +       /* w[1] +=3D S1 (w[15]) + w[10] + S0 (w[2]); */ \
> +       \
> +       /**** S0(w[1:2]) */ \
> +       \
> +       /* w[0:1] +=3D w[9:10] */ \
> +       /* RT23q =3D rw1:rw2 */ \
> +       vext.u64 RT23q, rw01q, rw23q, #1; \
> +       vadd.u64 rw0, rw9; \
> +       vadd.u64 rg, rg, RT0; \
> +       vadd.u64 rw1, rw10;\
> +       vadd.u64 rg, rg, RT1; /* g+=3Dt1; */ \
> +       \
> +       vshr.u64 RT45q, RT23q, #1; \
> +       vshl.u64 RT67q, RT23q, #64 - 1; \
> +       vshr.u64 RT01q, RT23q, #8; \
> +       veor.u64 RT45q, RT45q, RT67q; \
> +       vshl.u64 RT67q, RT23q, #64 - 8; \
> +       veor.u64 RT45q, RT45q, RT01q; \
> +       vshr.u64 RT01q, RT23q, #7; \
> +       veor.u64 RT45q, RT45q, RT67q; \
> +       \
> +       /**** S1(w[14:15]) */ \
> +       vshr.u64 RT23q, rw1415q, #6; \
> +       veor.u64 RT01q, RT01q, RT45q; \
> +       vshr.u64 RT45q, rw1415q, #19; \
> +       vshl.u64 RT67q, rw1415q, #64 - 19; \
> +       veor.u64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT45q, rw1415q, #61; \
> +       veor.u64 RT23q, RT23q, RT67q; \
> +       vshl.u64 RT67q, rw1415q, #64 - 61; \
> +       veor.u64 RT23q, RT23q, RT45q; \
> +       vadd.u64 rw01q, RT01q; /* w[0:1] +=3D S(w[1:2]) */ \
> +       veor.u64 RT01q, RT23q, RT67q;
> +#define vadd_RT01q(rw01q) \
> +       /* w[0:1] +=3D S(w[14:15]) */ \
> +       vadd.u64 rw01q, RT01q;
> +
> +#define dummy(_) /*_*/
> +
> +#define rounds2_64_79(ra, rb, rc, rd, re, rf, rg, rh, rw0, rw1, \
> +                     interleave_op1, arg1, interleave_op2, arg2) \
> +       /* t1 =3D h + Sum1 (e) + Ch (e, f, g) + k[t] + w[t]; */ \
> +       vshr.u64 RT2, re, #14; \
> +       vshl.u64 RT3, re, #64 - 14; \
> +       interleave_op1(arg1); \
> +       vshr.u64 RT4, re, #18; \
> +       vshl.u64 RT5, re, #64 - 18; \
> +       interleave_op2(arg2); \
> +       vld1.64 {RT0}, [RK]!; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, re, #41; \
> +       vshl.u64 RT5, re, #64 - 41; \
> +       vadd.u64 RT0, RT0, rw0; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vmov.64 RT7, re; \
> +       veor.64 RT1, RT2, RT3; \
> +       vbsl.64 RT7, rf, rg; \
> +       \
> +       vadd.u64 RT1, RT1, rh; \
> +       vshr.u64 RT2, ra, #28; \
> +       vshl.u64 RT3, ra, #64 - 28; \
> +       vadd.u64 RT1, RT1, RT0; \
> +       vshr.u64 RT4, ra, #34; \
> +       vshl.u64 RT5, ra, #64 - 34; \
> +       vadd.u64 RT1, RT1, RT7; \
> +       \
> +       /* h =3D Sum0 (a) + Maj (a, b, c); */ \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, ra, #39; \
> +       vshl.u64 RT5, ra, #64 - 39; \
> +       veor.64 RT0, ra, rb; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vbsl.64 RT0, rc, rb; \
> +       vadd.u64 rd, rd, RT1; /* d+=3Dt1; */ \
> +       veor.64 rh, RT2, RT3; \
> +       \
> +       /* t1 =3D g + Sum1 (d) + Ch (d, e, f) + k[t] + w[t]; */ \
> +       vshr.u64 RT2, rd, #14; \
> +       vshl.u64 RT3, rd, #64 - 14; \
> +       vadd.u64 rh, rh, RT0; \
> +       vshr.u64 RT4, rd, #18; \
> +       vshl.u64 RT5, rd, #64 - 18; \
> +       vadd.u64 rh, rh, RT1; /* h+=3Dt1; */ \
> +       vld1.64 {RT0}, [RK]!; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, rd, #41; \
> +       vshl.u64 RT5, rd, #64 - 41; \
> +       vadd.u64 RT0, RT0, rw1; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vmov.64 RT7, rd; \
> +       veor.64 RT1, RT2, RT3; \
> +       vbsl.64 RT7, re, rf; \
> +       \
> +       vadd.u64 RT1, RT1, rg; \
> +       vshr.u64 RT2, rh, #28; \
> +       vshl.u64 RT3, rh, #64 - 28; \
> +       vadd.u64 RT1, RT1, RT0; \
> +       vshr.u64 RT4, rh, #34; \
> +       vshl.u64 RT5, rh, #64 - 34; \
> +       vadd.u64 RT1, RT1, RT7; \
> +       \
> +       /* g =3D Sum0 (h) + Maj (h, a, b); */ \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vshr.u64 RT4, rh, #39; \
> +       vshl.u64 RT5, rh, #64 - 39; \
> +       veor.64 RT0, rh, ra; \
> +       veor.64 RT23q, RT23q, RT45q; \
> +       vbsl.64 RT0, rb, ra; \
> +       vadd.u64 rc, rc, RT1; /* c+=3Dt1; */ \
> +       veor.64 rg, RT2, RT3;
> +#define vadd_rg_RT0(rg) \
> +       vadd.u64 rg, rg, RT0;
> +#define vadd_rg_RT1(rg) \
> +       vadd.u64 rg, rg, RT1; /* g+=3Dt1; */
> +
> +.align 3
> +ENTRY(sha512_transform_neon)
> +       /* Input:
> +        *      %r0: SHA512_CONTEXT
> +        *      %r1: data
> +        *      %r2: u64 k[] constants
> +        *      %r3: nblks
> +        */
> +       push {%lr};
> +
> +       mov %lr, #0;
> +
> +       /* Load context to d0-d7 */
> +       vld1.64 {RA-RD}, [%r0]!;
> +       vld1.64 {RE-RH}, [%r0];
> +       sub %r0, #(4*8);
> +
> +       /* Load input to w[16], d16-d31 */
> +       /* NOTE: Assumes that on ARMv7 unaligned accesses are always =
allowed. */
> +       vld1.64 {RW0-RW3}, [%r1]!;
> +       vld1.64 {RW4-RW7}, [%r1]!;
> +       vld1.64 {RW8-RW11}, [%r1]!;
> +       vld1.64 {RW12-RW15}, [%r1]!;
> +#ifdef __ARMEL__
> +       /* byteswap */
> +       vrev64.8 RW01q, RW01q;
> +       vrev64.8 RW23q, RW23q;
> +       vrev64.8 RW45q, RW45q;
> +       vrev64.8 RW67q, RW67q;
> +       vrev64.8 RW89q, RW89q;
> +       vrev64.8 RW1011q, RW1011q;
> +       vrev64.8 RW1213q, RW1213q;
> +       vrev64.8 RW1415q, RW1415q;
> +#endif
> +
> +       /* EABI says that d8-d15 must be preserved by callee. */
> +       /*vpush {RT0-RT7};*/
> +
> +.Loop:
> +       rounds2_0_63(RA, RB, RC, RD, RE, RF, RG, RH, RW0, RW1, RW01q,=
 RW2,
> +                    RW23q, RW1415q, RW9, RW10, dummy, _);
> +       b .Lenter_rounds;
> +
> +.Loop_rounds:
> +       rounds2_0_63(RA, RB, RC, RD, RE, RF, RG, RH, RW0, RW1, RW01q,=
 RW2,
> +                    RW23q, RW1415q, RW9, RW10, vadd_RT01q, RW1415q);
> +.Lenter_rounds:
> +       rounds2_0_63(RG, RH, RA, RB, RC, RD, RE, RF, RW2, RW3, RW23q,=
 RW4,
> +                    RW45q, RW01q, RW11, RW12, vadd_RT01q, RW01q);
> +       rounds2_0_63(RE, RF, RG, RH, RA, RB, RC, RD, RW4, RW5, RW45q,=
 RW6,
> +                    RW67q, RW23q, RW13, RW14, vadd_RT01q, RW23q);
> +       rounds2_0_63(RC, RD, RE, RF, RG, RH, RA, RB, RW6, RW7, RW67q,=
 RW8,
> +                    RW89q, RW45q, RW15, RW0, vadd_RT01q, RW45q);
> +       rounds2_0_63(RA, RB, RC, RD, RE, RF, RG, RH, RW8, RW9, RW89q,=
 RW10,
> +                    RW1011q, RW67q, RW1, RW2, vadd_RT01q, RW67q);
> +       rounds2_0_63(RG, RH, RA, RB, RC, RD, RE, RF, RW10, RW11, RW10=
11q, RW12,
> +                    RW1213q, RW89q, RW3, RW4, vadd_RT01q, RW89q);
> +       add %lr, #16;
> +       rounds2_0_63(RE, RF, RG, RH, RA, RB, RC, RD, RW12, RW13, RW12=
13q, RW14,
> +                    RW1415q, RW1011q, RW5, RW6, vadd_RT01q, RW1011q)=
;
> +       cmp %lr, #64;
> +       rounds2_0_63(RC, RD, RE, RF, RG, RH, RA, RB, RW14, RW15, RW14=
15q, RW0,
> +                    RW01q, RW1213q, RW7, RW8, vadd_RT01q, RW1213q);
> +       bne .Loop_rounds;
> +
> +       subs %r3, #1;
> +
> +       rounds2_64_79(RA, RB, RC, RD, RE, RF, RG, RH, RW0, RW1,
> +                     vadd_RT01q, RW1415q, dummy, _);
> +       rounds2_64_79(RG, RH, RA, RB, RC, RD, RE, RF, RW2, RW3,
> +                     vadd_rg_RT0, RG, vadd_rg_RT1, RG);
> +       beq .Lhandle_tail;
> +       vld1.64 {RW0-RW3}, [%r1]!;
> +       rounds2_64_79(RE, RF, RG, RH, RA, RB, RC, RD, RW4, RW5,
> +                     vadd_rg_RT0, RE, vadd_rg_RT1, RE);
> +       rounds2_64_79(RC, RD, RE, RF, RG, RH, RA, RB, RW6, RW7,
> +                     vadd_rg_RT0, RC, vadd_rg_RT1, RC);
> +#ifdef __ARMEL__
> +       vrev64.8 RW01q, RW01q;
> +       vrev64.8 RW23q, RW23q;
> +#endif
> +       vld1.64 {RW4-RW7}, [%r1]!;
> +       rounds2_64_79(RA, RB, RC, RD, RE, RF, RG, RH, RW8, RW9,
> +                     vadd_rg_RT0, RA, vadd_rg_RT1, RA);
> +       rounds2_64_79(RG, RH, RA, RB, RC, RD, RE, RF, RW10, RW11,
> +                     vadd_rg_RT0, RG, vadd_rg_RT1, RG);
> +#ifdef __ARMEL__
> +       vrev64.8 RW45q, RW45q;
> +       vrev64.8 RW67q, RW67q;
> +#endif
> +       vld1.64 {RW8-RW11}, [%r1]!;
> +       rounds2_64_79(RE, RF, RG, RH, RA, RB, RC, RD, RW12, RW13,
> +                     vadd_rg_RT0, RE, vadd_rg_RT1, RE);
> +       rounds2_64_79(RC, RD, RE, RF, RG, RH, RA, RB, RW14, RW15,
> +                     vadd_rg_RT0, RC, vadd_rg_RT1, RC);
> +#ifdef __ARMEL__
> +       vrev64.8 RW89q, RW89q;
> +       vrev64.8 RW1011q, RW1011q;
> +#endif
> +       vld1.64 {RW12-RW15}, [%r1]!;
> +       vadd_rg_RT0(RA);
> +       vadd_rg_RT1(RA);
> +
> +       /* Load context */
> +       vld1.64 {RT0-RT3}, [%r0]!;
> +       vld1.64 {RT4-RT7}, [%r0];
> +       sub %r0, #(4*8);
> +
> +#ifdef __ARMEL__
> +       vrev64.8 RW1213q, RW1213q;
> +       vrev64.8 RW1415q, RW1415q;
> +#endif
> +
> +       vadd.u64 RA, RT0;
> +       vadd.u64 RB, RT1;
> +       vadd.u64 RC, RT2;
> +       vadd.u64 RD, RT3;
> +       vadd.u64 RE, RT4;
> +       vadd.u64 RF, RT5;
> +       vadd.u64 RG, RT6;
> +       vadd.u64 RH, RT7;
> +
> +       /* Store the first half of context */
> +       vst1.64 {RA-RD}, [%r0]!;
> +       sub RK, $(8*80);
> +       vst1.64 {RE-RH}, [%r0]; /* Store the last half of context */
> +       mov %lr, #0;
> +       sub %r0, #(4*8);
> +
> +       b .Loop;
> +
> +.Lhandle_tail:
> +       rounds2_64_79(RE, RF, RG, RH, RA, RB, RC, RD, RW4, RW5,
> +                     vadd_rg_RT0, RE, vadd_rg_RT1, RE);
> +       rounds2_64_79(RC, RD, RE, RF, RG, RH, RA, RB, RW6, RW7,
> +                     vadd_rg_RT0, RC, vadd_rg_RT1, RC);
> +       rounds2_64_79(RA, RB, RC, RD, RE, RF, RG, RH, RW8, RW9,
> +                     vadd_rg_RT0, RA, vadd_rg_RT1, RA);
> +       rounds2_64_79(RG, RH, RA, RB, RC, RD, RE, RF, RW10, RW11,
> +                     vadd_rg_RT0, RG, vadd_rg_RT1, RG);
> +       rounds2_64_79(RE, RF, RG, RH, RA, RB, RC, RD, RW12, RW13,
> +                     vadd_rg_RT0, RE, vadd_rg_RT1, RE);
> +       rounds2_64_79(RC, RD, RE, RF, RG, RH, RA, RB, RW14, RW15,
> +                     vadd_rg_RT0, RC, vadd_rg_RT1, RC);
> +
> +       /* Load context to d16-d23 */
> +       vld1.64 {RW0-RW3}, [%r0]!;
> +       vadd_rg_RT0(RA);
> +       vld1.64 {RW4-RW7}, [%r0];
> +       vadd_rg_RT1(RA);
> +       sub %r0, #(4*8);
> +
> +       vadd.u64 RA, RW0;
> +       vadd.u64 RB, RW1;
> +       vadd.u64 RC, RW2;
> +       vadd.u64 RD, RW3;
> +       vadd.u64 RE, RW4;
> +       vadd.u64 RF, RW5;
> +       vadd.u64 RG, RW6;
> +       vadd.u64 RH, RW7;
> +
> +       /* Store the first half of context */
> +       vst1.64 {RA-RD}, [%r0]!;
> +
> +       /* Clear used registers */
> +       /* d16-d31 */
> +       veor.u64 RW01q, RW01q;
> +       veor.u64 RW23q, RW23q;
> +       veor.u64 RW45q, RW45q;
> +       veor.u64 RW67q, RW67q;
> +       vst1.64 {RE-RH}, [%r0]; /* Store the last half of context */
> +       veor.u64 RW89q, RW89q;
> +       veor.u64 RW1011q, RW1011q;
> +       veor.u64 RW1213q, RW1213q;
> +       veor.u64 RW1415q, RW1415q;
> +       /* d8-d15 */
> +       /*vpop {RT0-RT7};*/
> +       /* d0-d7 (q0-q3) */
> +       veor.u64 %q0, %q0;
> +       veor.u64 %q1, %q1;
> +       veor.u64 %q2, %q2;
> +       veor.u64 %q3, %q3;
> +
> +       pop {%pc};
> +ENDPROC(sha512_transform_neon)
> diff --git a/arch/arm/crypto/sha512_neon_glue.c b/arch/arm/crypto/sha=
512_neon_glue.c
> new file mode 100644
> index 0000000..0d2758f
> --- /dev/null
> +++ b/arch/arm/crypto/sha512_neon_glue.c
> @@ -0,0 +1,305 @@
> +/*
> + * Glue code for the SHA512 Secure Hash Algorithm assembly implement=
ation
> + * using NEON instructions.
> + *
> + * Copyright =C2=A9 2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
> + *
> + * This file is based on sha512_ssse3_glue.c:
> + *   Copyright (C) 2013 Intel Corporation
> + *   Author: Tim Chen <tim.c.chen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the Free
> + * Software Foundation; either version 2 of the License, or (at your=
 option)
> + * any later version.
> + *
> + */
> +
> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/cryptohash.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <crypto/sha.h>
> +#include <asm/byteorder.h>
> +#include <asm/simd.h>
> +#include <asm/neon.h>
> +
> +
> +static const u64 sha512_k[] =3D {
> +       0x428a2f98d728ae22ULL, 0x7137449123ef65cdULL,
> +       0xb5c0fbcfec4d3b2fULL, 0xe9b5dba58189dbbcULL,
> +       0x3956c25bf348b538ULL, 0x59f111f1b605d019ULL,
> +       0x923f82a4af194f9bULL, 0xab1c5ed5da6d8118ULL,
> +       0xd807aa98a3030242ULL, 0x12835b0145706fbeULL,
> +       0x243185be4ee4b28cULL, 0x550c7dc3d5ffb4e2ULL,
> +       0x72be5d74f27b896fULL, 0x80deb1fe3b1696b1ULL,
> +       0x9bdc06a725c71235ULL, 0xc19bf174cf692694ULL,
> +       0xe49b69c19ef14ad2ULL, 0xefbe4786384f25e3ULL,
> +       0x0fc19dc68b8cd5b5ULL, 0x240ca1cc77ac9c65ULL,
> +       0x2de92c6f592b0275ULL, 0x4a7484aa6ea6e483ULL,
> +       0x5cb0a9dcbd41fbd4ULL, 0x76f988da831153b5ULL,
> +       0x983e5152ee66dfabULL, 0xa831c66d2db43210ULL,
> +       0xb00327c898fb213fULL, 0xbf597fc7beef0ee4ULL,
> +       0xc6e00bf33da88fc2ULL, 0xd5a79147930aa725ULL,
> +       0x06ca6351e003826fULL, 0x142929670a0e6e70ULL,
> +       0x27b70a8546d22ffcULL, 0x2e1b21385c26c926ULL,
> +       0x4d2c6dfc5ac42aedULL, 0x53380d139d95b3dfULL,
> +       0x650a73548baf63deULL, 0x766a0abb3c77b2a8ULL,
> +       0x81c2c92e47edaee6ULL, 0x92722c851482353bULL,
> +       0xa2bfe8a14cf10364ULL, 0xa81a664bbc423001ULL,
> +       0xc24b8b70d0f89791ULL, 0xc76c51a30654be30ULL,
> +       0xd192e819d6ef5218ULL, 0xd69906245565a910ULL,
> +       0xf40e35855771202aULL, 0x106aa07032bbd1b8ULL,
> +       0x19a4c116b8d2d0c8ULL, 0x1e376c085141ab53ULL,
> +       0x2748774cdf8eeb99ULL, 0x34b0bcb5e19b48a8ULL,
> +       0x391c0cb3c5c95a63ULL, 0x4ed8aa4ae3418acbULL,
> +       0x5b9cca4f7763e373ULL, 0x682e6ff3d6b2b8a3ULL,
> +       0x748f82ee5defb2fcULL, 0x78a5636f43172f60ULL,
> +       0x84c87814a1f0ab72ULL, 0x8cc702081a6439ecULL,
> +       0x90befffa23631e28ULL, 0xa4506cebde82bde9ULL,
> +       0xbef9a3f7b2c67915ULL, 0xc67178f2e372532bULL,
> +       0xca273eceea26619cULL, 0xd186b8c721c0c207ULL,
> +       0xeada7dd6cde0eb1eULL, 0xf57d4f7fee6ed178ULL,
> +       0x06f067aa72176fbaULL, 0x0a637dc5a2c898a6ULL,
> +       0x113f9804bef90daeULL, 0x1b710b35131c471bULL,
> +       0x28db77f523047d84ULL, 0x32caab7b40c72493ULL,
> +       0x3c9ebe0a15c9bebcULL, 0x431d67c49c100d4cULL,
> +       0x4cc5d4becb3e42b6ULL, 0x597f299cfc657e2aULL,
> +       0x5fcb6fab3ad6faecULL, 0x6c44198c4a475817ULL
> +};
> +
> +
> +asmlinkage void sha512_transform_neon(u64 *digest, const void *data,
> +                                     const u64 k[], unsigned int num=
_blks);
> +
> +
> +static int sha512_neon_init(struct shash_desc *desc)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +
> +       sctx->state[0] =3D SHA512_H0;
> +       sctx->state[1] =3D SHA512_H1;
> +       sctx->state[2] =3D SHA512_H2;
> +       sctx->state[3] =3D SHA512_H3;
> +       sctx->state[4] =3D SHA512_H4;
> +       sctx->state[5] =3D SHA512_H5;
> +       sctx->state[6] =3D SHA512_H6;
> +       sctx->state[7] =3D SHA512_H7;
> +       sctx->count[0] =3D sctx->count[1] =3D 0;
> +
> +       return 0;
> +}
> +
> +static int __sha512_neon_update(struct shash_desc *desc, const u8 *d=
ata,
> +                               unsigned int len, unsigned int partia=
l)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int done =3D 0;
> +
> +       sctx->count[0] +=3D len;
> +       if (sctx->count[0] < len)
> +               sctx->count[1]++;
> +
> +       if (partial) {
> +               done =3D SHA512_BLOCK_SIZE - partial;
> +               memcpy(sctx->buf + partial, data, done);
> +               sha512_transform_neon(sctx->state, sctx->buf, sha512_=
k, 1);
> +       }
> +
> +       if (len - done >=3D SHA512_BLOCK_SIZE) {
> +               const unsigned int rounds =3D (len - done) / SHA512_B=
LOCK_SIZE;
> +
> +               sha512_transform_neon(sctx->state, data + done, sha51=
2_k,
> +                                     rounds);
> +
> +               done +=3D rounds * SHA512_BLOCK_SIZE;
> +       }
> +
> +       memcpy(sctx->buf, data + done, len - done);
> +
> +       return 0;
> +}
> +
> +static int sha512_neon_update(struct shash_desc *desc, const u8 *dat=
a,
> +                            unsigned int len)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int partial =3D sctx->count[0] % SHA512_BLOCK_SIZE;
> +       int res;
> +
> +       /* Handle the fast case right here */
> +       if (partial + len < SHA512_BLOCK_SIZE) {
> +               sctx->count[0] +=3D len;
> +               if (sctx->count[0] < len)
> +                       sctx->count[1]++;
> +               memcpy(sctx->buf + partial, data, len);
> +
> +               return 0;
> +       }
> +
> +       if (!may_use_simd()) {
> +               res =3D crypto_sha512_update(desc, data, len);
> +       } else {
> +               kernel_neon_begin();
> +               res =3D __sha512_neon_update(desc, data, len, partial=
);
> +               kernel_neon_end();
> +       }
> +
> +       return res;
> +}
> +
> +
> +/* Add padding and return the message digest. */
> +static int sha512_neon_final(struct shash_desc *desc, u8 *out)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int i, index, padlen;
> +       __be64 *dst =3D (__be64 *)out;
> +       __be64 bits[2];
> +       static const u8 padding[SHA512_BLOCK_SIZE] =3D { 0x80, };
> +
> +       /* save number of bits */
> +       bits[1] =3D cpu_to_be64(sctx->count[0] << 3);
> +       bits[0] =3D cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] =
>> 61);
> +
> +       /* Pad out to 112 mod 128 and append length */
> +       index =3D sctx->count[0] & 0x7f;
> +       padlen =3D (index < 112) ? (112 - index) : ((128+112) - index=
);
> +
> +       if (!may_use_simd()) {
> +               crypto_sha512_update(desc, padding, padlen);
> +               crypto_sha512_update(desc, (const u8 *)&bits, sizeof(=
bits));
> +       } else {
> +               kernel_neon_begin();
> +               /* We need to fill a whole block for __sha512_neon_up=
date() */
> +               if (padlen <=3D 112) {
> +                       sctx->count[0] +=3D padlen;
> +                       if (sctx->count[0] < padlen)
> +                               sctx->count[1]++;
> +                       memcpy(sctx->buf + index, padding, padlen);
> +               } else {
> +                       __sha512_neon_update(desc, padding, padlen, i=
ndex);
> +               }
> +               __sha512_neon_update(desc, (const u8 *)&bits,
> +                                       sizeof(bits), 112);
> +               kernel_neon_end();
> +       }
> +
> +       /* Store state in digest */
> +       for (i =3D 0; i < 8; i++)
> +               dst[i] =3D cpu_to_be64(sctx->state[i]);
> +
> +       /* Wipe context */
> +       memset(sctx, 0, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static int sha512_neon_export(struct shash_desc *desc, void *out)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +
> +       memcpy(out, sctx, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static int sha512_neon_import(struct shash_desc *desc, const void *i=
n)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +
> +       memcpy(sctx, in, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static int sha384_neon_init(struct shash_desc *desc)
> +{
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
> +
> +       sctx->state[0] =3D SHA384_H0;
> +       sctx->state[1] =3D SHA384_H1;
> +       sctx->state[2] =3D SHA384_H2;
> +       sctx->state[3] =3D SHA384_H3;
> +       sctx->state[4] =3D SHA384_H4;
> +       sctx->state[5] =3D SHA384_H5;
> +       sctx->state[6] =3D SHA384_H6;
> +       sctx->state[7] =3D SHA384_H7;
> +
> +       sctx->count[0] =3D sctx->count[1] =3D 0;
> +
> +       return 0;
> +}
> +
> +static int sha384_neon_final(struct shash_desc *desc, u8 *hash)
> +{
> +       u8 D[SHA512_DIGEST_SIZE];
> +
> +       sha512_neon_final(desc, D);
> +
> +       memcpy(hash, D, SHA384_DIGEST_SIZE);
> +       memset(D, 0, SHA512_DIGEST_SIZE);
> +
> +       return 0;
> +}
> +
> +static struct shash_alg algs[] =3D { {
> +       .digestsize     =3D       SHA512_DIGEST_SIZE,
> +       .init           =3D       sha512_neon_init,
> +       .update         =3D       sha512_neon_update,
> +       .final          =3D       sha512_neon_final,
> +       .export         =3D       sha512_neon_export,
> +       .import         =3D       sha512_neon_import,
> +       .descsize       =3D       sizeof(struct sha512_state),
> +       .statesize      =3D       sizeof(struct sha512_state),
> +       .base           =3D       {
> +               .cra_name       =3D       "sha512",
> +               .cra_driver_name =3D      "sha512-neon",
> +               .cra_priority   =3D       250,
> +               .cra_flags      =3D       CRYPTO_ALG_TYPE_SHASH,
> +               .cra_blocksize  =3D       SHA512_BLOCK_SIZE,
> +               .cra_module     =3D       THIS_MODULE,
> +       }
> +},  {
> +       .digestsize     =3D       SHA384_DIGEST_SIZE,
> +       .init           =3D       sha384_neon_init,
> +       .update         =3D       sha512_neon_update,
> +       .final          =3D       sha384_neon_final,
> +       .export         =3D       sha512_neon_export,
> +       .import         =3D       sha512_neon_import,
> +       .descsize       =3D       sizeof(struct sha512_state),
> +       .statesize      =3D       sizeof(struct sha512_state),
> +       .base           =3D       {
> +               .cra_name       =3D       "sha384",
> +               .cra_driver_name =3D      "sha384-neon",
> +               .cra_priority   =3D       250,
> +               .cra_flags      =3D       CRYPTO_ALG_TYPE_SHASH,
> +               .cra_blocksize  =3D       SHA384_BLOCK_SIZE,
> +               .cra_module     =3D       THIS_MODULE,
> +       }
> +} };
> +
> +static int __init sha512_neon_mod_init(void)
> +{
> +       if (!cpu_has_neon())
> +               return -ENODEV;
> +
> +       return crypto_register_shashes(algs, ARRAY_SIZE(algs));
> +}
> +
> +static void __exit sha512_neon_mod_fini(void)
> +{
> +       crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
> +}
> +
> +module_init(sha512_neon_mod_init);
> +module_exit(sha512_neon_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("SHA512 Secure Hash Algorithm, NEON accelerated")=
;
> +
> +MODULE_ALIAS("sha512");
> +MODULE_ALIAS("sha384");
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 66d7ce1..9ec69e2 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -600,6 +600,21 @@ config CRYPTO_SHA512_SPARC64
>           SHA-512 secure hash standard (DFIPS 180-2) implemented
>           using sparc64 crypto instructions, when available.
>
> +config CRYPTO_SHA512_ARM_NEON
> +       tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
> +       depends on ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
> +       select CRYPTO_SHA512
> +       select CRYPTO_HASH
> +       help
> +         SHA-512 secure hash standard (DFIPS 180-2) implemented
> +         using ARM NEON instructions, when available.
> +
> +         This version of SHA implements a 512 bit hash with 256 bits=
 of
> +         security against collision attacks.
> +
> +         This code also includes SHA-384, a 384 bit hash with 192 bi=
ts
> +         of security against collision attacks.
> +
>  config CRYPTO_TGR192
>         tristate "Tiger digest algorithms"
>         select CRYPTO_HASH
>
