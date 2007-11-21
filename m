From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 20 Nov 2007 18:44:36 -0800
Message-ID: <200711201844.36562.vda.linux@googlemail.com>
References: <200711141428.25933.vda.linux@googlemail.com> <200711182030.17123.vda.linux@googlemail.com> <20071120.034957.465778866.takamiya@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Uu5QH1LsGwNm2sI"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:60814 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXKUCoq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2007 21:44:46 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1796520nze
        for <linux-crypto@vger.kernel.org>; Tue, 20 Nov 2007 18:44:44 -0800 (PST)
In-Reply-To: <20071120.034957.465778866.takamiya@linux-ipv6.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_Uu5QH1LsGwNm2sI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Herbert, Noriaki,

On Monday 19 November 2007 10:49, Noriaki TAKAMIYA wrote:
> > > > camellia6:
> > > >         unifies encrypt/decrypt routines for different key lengths.
> > > >         This reduces module size by ~25%, with tiny (less than 1%)
> > > >         speed impact.
> > > >         Also collapses encrypt/decrypt into more readable
> > > >         (visually shorter) form using macros.
> >
> > And here is
> >
> > camellia7:
> >         Move "key XOR is end of F-function" code part into
> >         camellia_setup_tail(), it is sufficiently similar
> >         between camellia_setup128 and camellia_setup256.
> >         This shaves off another ~1k:
> >           dec     hex filename
> >         21414    53a6 2.6.23.1.camellia6.t/crypto/camellia.o
> >         20518    5026 2.6.23.1.camellia7.t/crypto/camellia.o
> >         16355    3fe3 2.6.23.1.camellia6.t64/crypto/camellia.o
> >         15813    3dc5 2.6.23.1.camellia7.t64/crypto/camellia.o
> >
> >
> > At the moment I cannot run test it, try to do it ASAP.
> >
> > Takamiya-san, can you review attached patch please?
>
>   Sorry for late reply.
>
>   I think you're testing now:-), and if speed impact is less than 1%
>   as you say, I think it is acceptable.

Actaually I tested it only now. Explored wonders of ubuntu
package management. Why it doesn't rebuild module
when I do "touch camellia.c" and then run their magic stuff?
I suspected that these .deb, .rpm, .whatever are evil,
but it changed today. Now I *know* that. ;)

Back to patches.

It turns out that two more key setup stages can be easily folded into
common "tail". Attached patches do this.

I'm also attaching all previous patches not yet ACKed by Herbert
(patches 5,6,7).

camellia8:
        Analogously to camellia7 patch, move
        "absorb kw2 to other subkeys" and "absorb kw4 to other subkeys"
        code parts into camellia_setup_tail(). This further reduces
        source and object code size at the cost of two brances
        in key setup code.

Code sizes (starting from the state with pathces 1-4 already applied):
64-bit:
dec      hex   filename
22786    5902  2.6.23.1.camellia4.t64/crypto/camellia.o
21422    53ae  2.6.23.1.camellia5.t64/crypto/camellia.o
16355    3fe3  2.6.23.1.camellia6.t64/crypto/camellia.o
15813    3dc5  2.6.23.1.camellia7.t64/crypto/camellia.o
15670    3d36  2.6.23.1.camellia8.t64/crypto/camellia.o
32-bit:
29948    74fc  2.6.23.1.camellia4.t/crypto/camellia.o
29457    7311  2.6.23.1.camellia5.t/crypto/camellia.o
21414    53a6  2.6.23.1.camellia6.t/crypto/camellia.o
20518    5026  2.6.23.1.camellia7.t/crypto/camellia.o
18454    4816  2.6.23.1.camellia8.t/crypto/camellia.o

Code is compile-tested for 32/64-bit x86 and run tested on 32-bit
(tcrypt tests all pass).

Herbert, please let me know what you think about them.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda


--Boundary-00=_Uu5QH1LsGwNm2sI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.23.1.camellia5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23.1.camellia5.diff"

diff -urpN linux-2.6.23.1.camellia/crypto/camellia.c linux-2.6.23.1.camellia5/crypto/camellia.c
--- linux-2.6.23.1.camellia/crypto/camellia.c	2007-11-14 11:30:27.000000000 -0800
+++ linux-2.6.23.1.camellia5/crypto/camellia.c	2007-11-14 11:30:27.000000000 -0800
@@ -310,6 +310,589 @@ static const u32 camellia_sp4404[256] = 
 #define CAMELLIA_BLOCK_SIZE          16
 #define CAMELLIA_TABLE_BYTE_LEN     272
 
+/*
+ * NB: L and R below stand for 'left' and 'right' as in written numbers.
+ * That is, in (xxxL,xxxR) pair xxxL holds most significant digits,
+ * _not_ least significant ones!
+ */
+
+
+
+#if BITS_PER_LONG >= 64
+
+/*
+ * Key setup implementation with mostly 64-bit ops
+ */
+
+/* key constants */
+
+#define CAMELLIA_SIGMA1 (0xA09E667F3BCC908B)
+#define CAMELLIA_SIGMA2 (0xB67AE8584CAA73B2)
+#define CAMELLIA_SIGMA3 (0xC6EF372FE94F82BE)
+#define CAMELLIA_SIGMA4 (0x54FF53A5F1D36F1C)
+#define CAMELLIA_SIGMA5 (0x10E527FADE682D1D)
+#define CAMELLIA_SIGMA6 (0xB05688C2B3E6C1FD)
+
+/*
+ *  macros
+ */
+#define GETU64(v, pt) \
+    do { \
+	/* latest breed of gcc is clever enough to use move */ \
+	memcpy(&(v), (pt), 8); \
+	(v) = be64_to_cpu(v); \
+    } while(0)
+
+/* rotation right shift 1byte */
+#define ROR8(x) (((x) >> 8) + ((x) << (sizeof(x)*8 - 8)))
+/* rotation left shift 1bit */
+#define ROL1(x) (((x) << 1) + ((x) >> (sizeof(x)*8 - 1)))
+/* rotation left shift 1byte */
+#define ROL8(x) (((x) << 8) + ((x) >> (sizeof(x)*8 - 8)))
+
+#define ROLDQ(l, r, w, bits)				\
+    do {						\
+	w = l;						\
+	l = (l << bits) + (r >> (64 - bits));		\
+	r = (r << bits) + (w >> (64 - bits));		\
+    } while(0)
+
+#define CAMELLIA_F(x, k, y, i)					\
+    do {							\
+	u32 yl, yr;						\
+	i = x ^ k;						\
+	yl = camellia_sp1110[(u8)i]				\
+	   ^ camellia_sp0222[(u8)(i >> 24)]			\
+	   ^ camellia_sp3033[(u8)(i >> 16)]			\
+	   ^ camellia_sp4404[(u8)(i >> 8)];			\
+	yr = camellia_sp1110[    (i >> 56)]			\
+	   ^ camellia_sp0222[(u8)(i >> 48)]			\
+	   ^ camellia_sp3033[(u8)(i >> 40)]			\
+	   ^ camellia_sp4404[(u8)(i >> 32)];			\
+	yl ^= yr;						\
+	yr = ROR8(yr);						\
+	yr ^= yl;						\
+	y = ((u64)yl << 32) + yr;				\
+    } while(0)
+
+#define SUBKEY(INDEX) (subkey[(INDEX)])
+
+#ifdef __BIG_ENDIAN
+#define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2])
+#define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#else
+#define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2])
+#endif
+
+static void camellia_setup_tail(u64 *subkey, int max)
+{
+	u32 dw;
+	int i = 2;
+	do {
+		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = ROL8(dw);/* round 1 */
+		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
+		dw = SUBKEY_L(i + 1) ^ SUBKEY_R(i + 1); dw = ROL8(dw);/* round 2 */
+		SUBKEY_R(i + 1) = SUBKEY_L(i + 1) ^ dw; SUBKEY_L(i + 1) = dw;
+		dw = SUBKEY_L(i + 2) ^ SUBKEY_R(i + 2); dw = ROL8(dw);/* round 3 */
+		SUBKEY_R(i + 2) = SUBKEY_L(i + 2) ^ dw; SUBKEY_L(i + 2) = dw;
+		dw = SUBKEY_L(i + 3) ^ SUBKEY_R(i + 3); dw = ROL8(dw);/* round 4 */
+		SUBKEY_R(i + 3) = SUBKEY_L(i + 3) ^ dw; SUBKEY_L(i + 3) = dw;
+		dw = SUBKEY_L(i + 4) ^ SUBKEY_R(i + 4); dw = ROL8(dw);/* round 5 */
+		SUBKEY_R(i + 4) = SUBKEY_L(i + 4) ^ dw; SUBKEY_L(i + 4) = dw;
+		dw = SUBKEY_L(i + 5) ^ SUBKEY_R(i + 5); dw = ROL8(dw);/* round 6 */
+		SUBKEY_R(i + 5) = SUBKEY_L(i + 5) ^ dw; SUBKEY_L(i + 5) = dw;
+		i += 8;
+	} while (i < max);
+}
+
+#ifdef __BIG_ENDIAN
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#else
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2])
+#endif
+
+static void camellia_setup128(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;
+	u64 i, t, w;
+	u64 kw4;
+	u32 dw;
+	u64 sub[26];
+
+	/**
+	 *  k == kl || kr (|| is concatination)
+	 */
+	GETU64(kl, key     );
+	GETU64(kr, key +  8);
+
+	/**
+	 * generate KL dependent subkeys
+	 */
+	/* kw1 */
+	sub[0] = kl;
+	/* kw2 */
+	sub[1] = kr;
+	/* rotation left shift 15bit */
+	ROLDQ(kl, kr, w, 15);
+	/* k3 */
+	sub[4] = kl;
+	/* k4 */
+	sub[5] = kr;
+	/* rotation left shift 15+30bit */
+	ROLDQ(kl, kr, w, 30);
+	/* k7 */
+	sub[10] = kl;
+	/* k8 */
+	sub[11] = kr;
+	/* rotation left shift 15+30+15bit */
+	ROLDQ(kl, kr, w, 15);
+	/* k10 */
+	sub[13] = kr;
+	/* rotation left shift 15+30+15+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* kl3 */
+	sub[16] = kl;
+	/* kl4 */
+	sub[17] = kr;
+	/* rotation left shift 15+30+15+17+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* k13 */
+	sub[18] = kl;
+	/* k14 */
+	sub[19] = kr;
+	/* rotation left shift 15+30+15+17+17+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* k17 */
+	sub[22] = kl;
+	/* k18 */
+	sub[23] = kr;
+
+	/* generate KA */
+	kl = sub[0];
+	kr = sub[1];
+	CAMELLIA_F(kl, CAMELLIA_SIGMA1, w, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA2, kl, i);
+	/* current status == (kl, w) */
+	CAMELLIA_F(kl, CAMELLIA_SIGMA3, kr, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA4, w, i);
+	kl ^= w;
+
+	/* generate KA dependent subkeys */
+	/* k1, k2 */
+	sub[2] = kl;
+	sub[3] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* k5,k6 */
+	sub[6] = kl;
+	sub[7] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* kl1, kl2 */
+	sub[8] = kl;
+	sub[9] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* k9 */
+	sub[12] = kl;
+	ROLDQ(kl, kr, w, 15);
+	/* k11, k12 */
+	sub[14] = kl;
+	sub[15] = kr;
+	ROLDQ(kl, kr, w, 34);
+	/* k15, k16 */
+	sub[20] = kl;
+	sub[21] = kr;
+	ROLDQ(kl, kr, w, 17);
+	/* kw3, kw4 */
+	sub[24] = kl;
+	sub[25] = kr;
+
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	sub[3] ^= sub[1];
+	/* round 4 */
+	sub[5] ^= sub[1];
+	/* round 6 */
+	sub[7] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(9);
+	dw = subL(1) & subL(9),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	sub[11] ^= sub[1];
+	/* round 10 */
+	sub[13] ^= sub[1];
+	/* round 12 */
+	sub[15] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(17);
+	dw = subL(1) & subL(17),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	sub[19] ^= sub[1];
+	/* round 16 */
+	sub[21] ^= sub[1];
+	/* round 18 */
+	sub[23] ^= sub[1];
+	/* kw3 */
+	sub[24] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+	kw4 = sub[25];
+	/* round 17 */
+	sub[22] ^= kw4;
+	/* round 15 */
+	sub[20] ^= kw4;
+	/* round 13 */
+	sub[18] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32; //kw4l ^= kw4r & ~subR(16);
+	dw = (u32)(kw4 >> 32) & subL(16); // kw4l & subL[16],
+	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	sub[14] ^= kw4;
+	/* round 9 */
+	sub[12] ^= kw4;
+	/* round 7 */
+	sub[10] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32; //kw4l ^= kw4r & ~subR[8];
+	dw = (u32)(kw4 >> 32) & subL(8);
+	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	sub[6] ^= kw4;
+	/* round 3 */
+	sub[4] ^= kw4;
+	/* round 1 */
+	sub[2] ^= kw4;
+	/* kw1 */
+	sub[0] ^= kw4;
+
+	/* key XOR is end of F-function */
+	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
+	SUBKEY(2) = sub[3];       /* round 1 */
+	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
+	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
+	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
+	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
+	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = (u32)t & subL(8);  /* FL(kl1) */
+	t = (t << 32) | (subR(10) ^ ROL1(dw)); // tr = subR[10] ^ ROL1(dw);
+	SUBKEY(7) = sub[6] ^ t; /* round 6 */
+	SUBKEY(8) = sub[8];       /* FL(kl1) */
+	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
+	t = subL(7) ^ (subR(7) & ~subR(9));
+	dw = (u32)t & subL(9);  /* FLinv(kl2) */
+	t = (t << 32) | (subR(7) ^ ROL1(dw));
+	SUBKEY(10) = t ^ sub[11]; /* round 7 */
+	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
+	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
+	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
+	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
+	t = subL(18) ^ (subR(18) & ~subR(16));
+	dw = (u32)t & subL(16); /* FL(kl3) */
+	t = (t << 32) | (subR(18) ^ ROL1(dw));
+	SUBKEY(15) = sub[14] ^ t; /* round 12 */
+	SUBKEY(16) = sub[16];     /* FL(kl3) */
+	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
+	t = subL(15) ^ (subR(15) & ~subR(17));
+	dw = (u32)t & subL(17); /* FLinv(kl4) */
+	t = (t << 32) | (subR(15) ^ ROL1(dw));
+	SUBKEY(18) = t ^ sub[19]; /* round 13 */
+	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
+	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
+	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
+	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
+	SUBKEY(23) = sub[22];     /* round 18 */
+	SUBKEY(24) = sub[24] ^ sub[23]; /* kw3 */
+
+	/* apply the inverse of the last half of P-function */
+	camellia_setup_tail(subkey, 24);
+}
+
+static void camellia_setup256(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;        /* left half of key */
+	u64 krl, krr;      /* right half of key */
+	u64 i, t, w;       /* temporary variables */
+	u64 kw4;
+	u32 dw;
+	u64 sub[34];
+
+	/**
+	 *  key = (kl || kr || krl || krr)
+	 *  (|| is concatination)
+	 */
+	GETU64(kl,  key     );
+	GETU64(kr,  key +  8);
+	GETU64(krl, key + 16);
+	GETU64(krr, key + 24);
+
+	/* generate KL dependent subkeys */
+	/* kw1 */
+	sub[0] = kl;
+	/* kw2 */
+	sub[1] = kr;
+	ROLDQ(kl, kr, w, 45);
+	/* k9 */
+	sub[12] = kl;
+	/* k10 */
+	sub[13] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* kl3 */
+	sub[16] = kl;
+	/* kl4 */
+	sub[17] = kr;
+	ROLDQ(kl, kr, w, 17);
+	/* k17 */
+	sub[22] = kl;
+	/* k18 */
+	sub[23] = kr;
+	ROLDQ(kl, kr, w, 34);
+	/* k23 */
+	sub[30] = kl;
+	/* k24 */
+	sub[31] = kr;
+
+	/* generate KR dependent subkeys */
+	ROLDQ(krl, krr, w, 15);
+	/* k3 */
+	sub[4] = krl;
+	/* k4 */
+	sub[5] = krr;
+	ROLDQ(krl, krr, w, 15);
+	/* kl1 */
+	sub[8] = krl;
+	/* kl2 */
+	sub[9] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k13 */
+	sub[18] = krl;
+	/* k14 */
+	sub[19] = krr;
+	ROLDQ(krl, krr, w, 34);
+	/* k19 */
+	sub[26] = krl;
+	/* k20 */
+	sub[27] = krr;
+	ROLDQ(krl, krr, w, 34);
+
+	/* generate KA */
+	kl = sub[0] ^ krl;
+	kr = sub[1] ^ krr;
+	CAMELLIA_F(kl, CAMELLIA_SIGMA1, w, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA2, kl, i);
+	kl ^= krl;
+	CAMELLIA_F(kl, CAMELLIA_SIGMA3, kr, i);
+	kr ^= w ^ krr;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA4, w, i);
+	kl ^= w;
+
+	/* generate KB */
+	krl ^= kl;
+	krr ^= kr;
+	CAMELLIA_F(krl, CAMELLIA_SIGMA5, w, i);
+	krr ^= w;
+	CAMELLIA_F(krr, CAMELLIA_SIGMA6, w, i);
+	krl ^= w;
+
+	/* generate KA dependent subkeys */
+	ROLDQ(kl, kr, w, 15);
+	/* k5 */
+	sub[6] = kl;
+	/* k6 */
+	sub[7] = kr;
+	ROLDQ(kl, kr, w, 30);
+	/* k11 */
+	sub[14] = kl;
+	/* k12 */
+	sub[15] = kr;
+	/* kl5 */
+	ROLDQ(kl, kr, w, 32);
+	sub[24] = kl;
+	/* kl6 */
+	sub[25] = kr;
+	/* rotation left shift 49 from k11,k12 -> k21,k22 */
+	ROLDQ(kl, kr, w, (49 - 32));
+	/* k21 */
+	sub[28] = kl;
+	/* k22 */
+	sub[29] = kr;
+
+	/* generate KB dependent subkeys */
+	/* k1 */
+	sub[2] = krl;
+	/* k2 */
+	sub[3] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k7 */
+	sub[10] = krl;
+	/* k8 */
+	sub[11] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k15 */
+	sub[20] = krl;
+	/* k16 */
+	sub[21] = krr;
+	ROLDQ(krl, krr, w, 51);
+	/* kw3 */
+	sub[32] = krl;
+	/* kw4 */
+	sub[33] = krr;
+
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	sub[3] ^= sub[1];
+	/* round 4 */
+	sub[5] ^= sub[1];
+	/* round 6 */
+	sub[7] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(9);
+	dw = subL(1) & subL(9),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	sub[11] ^= sub[1];
+	/* round 10 */
+	sub[13] ^= sub[1];
+	/* round 12 */
+	sub[15] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(17);
+	dw = subL(1) & subL(17),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	sub[19] ^= sub[1];
+	/* round 16 */
+	sub[21] ^= sub[1];
+	/* round 18 */
+	sub[23] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(25);
+	dw = subL(1) & subL(25),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl6) */
+	/* round 20 */
+	sub[27] ^= sub[1];
+	/* round 22 */
+	sub[29] ^= sub[1];
+	/* round 24 */
+	sub[31] ^= sub[1];
+	/* kw3 */
+	sub[32] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+	kw4 = sub[33];
+	/* round 23 */
+	sub[30] ^= kw4;
+	/* round 21 */
+	sub[28] ^= kw4;
+	/* round 19 */
+	sub[26] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(24)) << 32; //kw4l ^= kw4r & ~subR[24];
+	dw = (u32)(kw4 >> 32) & subL(24),
+		kw4 ^= ROL1(dw); /* modified for FL(kl5) */
+	/* round 17 */
+	sub[22] ^= kw4;
+	/* round 15 */
+	sub[20] ^= kw4;
+	/* round 13 */
+	sub[18] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32;
+	dw = (u32)(kw4 >> 32) & subL(16),
+		kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	sub[14] ^= kw4;
+	/* round 9 */
+	sub[12] ^= kw4;
+	/* round 7 */
+	sub[10] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32;
+	dw = (u32)(kw4 >> 32) & subL(8),
+		kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	sub[6] ^= kw4;
+	/* round 3 */
+	sub[4] ^= kw4;
+	/* round 1 */
+	sub[2] ^= kw4;
+	/* kw1 */
+	sub[0] ^= kw4;
+
+	/* key XOR is end of F-function */
+	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
+	SUBKEY(2) = sub[3];       /* round 1 */
+	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
+	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
+	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
+	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
+	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = (u32)t & subL(8);  /* FL(kl1) */
+	t = (t << 32) | (subR(10) ^ ROL1(dw)); //tr = subR[10] ^ ROL1(dw);
+	SUBKEY(7) = sub[6] ^ t;   /* round 6 */
+	SUBKEY(8) = sub[8];       /* FL(kl1) */
+	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
+	t = subL(7) ^ (subR(7) & ~subR(9));
+	dw = (u32)t & subL(9);  /* FLinv(kl2) */
+	t = (t << 32) | (subR(7) ^ ROL1(dw));
+	SUBKEY(10) = t ^ sub[11]; /* round 7 */
+	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
+	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
+	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
+	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
+	t = subL(18) ^ (subR(18) & ~subR(16));
+	dw = (u32)t & subL(16); /* FL(kl3) */
+	t = (t << 32) | (subR(18) ^ ROL1(dw));
+	SUBKEY(15) = sub[14] ^ t; /* round 12 */
+	SUBKEY(16) = sub[16];     /* FL(kl3) */
+	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
+	t = subL(15) ^ (subR(15) & ~subR(17));
+	dw = (u32)t & subL(17); /* FLinv(kl4) */
+	t = (t << 32) | (subR(15) ^ ROL1(dw));
+	SUBKEY(18) = t ^ sub[19]; /* round 13 */
+	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
+	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
+	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
+	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
+	t = subL(26) ^ (subR(26) & ~subR(24));
+	dw = (u32)t & subL(24); /* FL(kl5) */
+	t = (t << 32) | (subR(26) ^ ROL1(dw));
+	SUBKEY(23) = sub[22] ^ t; /* round 18 */
+	SUBKEY(24) = sub[24];     /* FL(kl5) */
+	SUBKEY(25) = sub[25];     /* FLinv(kl6) */
+	t = subL(23) ^ (subR(23) & ~subR(25));
+	dw = (u32)t & subL(25); /* FLinv(kl6) */
+	t = (t << 32) | (subR(23) ^ ROL1(dw));
+	SUBKEY(26) = t ^ sub[27]; /* round 19 */
+	SUBKEY(27) = sub[26] ^ sub[28]; /* round 20 */
+	SUBKEY(28) = sub[27] ^ sub[29]; /* round 21 */
+	SUBKEY(29) = sub[28] ^ sub[30]; /* round 22 */
+	SUBKEY(30) = sub[29] ^ sub[31]; /* round 23 */
+	SUBKEY(31) = sub[30];     /* round 24 */
+	SUBKEY(32) = sub[32] ^ sub[31]; /* kw3 */
+
+	/* apply the inverse of the last half of P-function */
+	camellia_setup_tail(subkey, 32);
+}
+
+static void camellia_setup192(const unsigned char *key, u64 *subkey)
+{
+	unsigned char kk[32];
+	u64 krl, krr;
+
+	memcpy(kk, key, 24);
+	memcpy((unsigned char *)&krl, key+16, 8);
+	krr = ~krl;
+	memcpy(kk+24, (unsigned char *)&krr, 8);
+	camellia_setup256(kk, subkey);
+}
+
+typedef u64 key_element;
+typedef const u64 const_key_element;
+
+
+
+#else /* BITS_PER_LONG < 64 */
+
+/*
+ * Key setup implementation with 32-bit ops
+ */
 
 /* key constants */
 
@@ -329,8 +912,7 @@ static const u32 camellia_sp4404[256] = 
 /*
  *  macros
  */
-
-# define GETU32(v, pt) \
+#define GETU32(v, pt) \
     do { \
 	/* latest breed of gcc is clever enough to use move */ \
 	memcpy(&(v), (pt), 4); \
@@ -363,64 +945,25 @@ static const u32 camellia_sp4404[256] = 
 	rr = (w0 << (bits - 32)) + (w1 >> (64 - bits));	\
     } while(0)
 
-
 #define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
     do {							\
 	il = xl ^ kl;						\
 	ir = xr ^ kr;						\
 	t0 = il >> 16;						\
 	t1 = ir >> 16;						\
-	yl = camellia_sp1110[ir & 0xff]				\
-	   ^ camellia_sp0222[(t1 >> 8) & 0xff]			\
-	   ^ camellia_sp3033[t1 & 0xff]				\
-	   ^ camellia_sp4404[(ir >> 8) & 0xff];			\
-	yr = camellia_sp1110[(t0 >> 8) & 0xff]			\
-	   ^ camellia_sp0222[t0 & 0xff]				\
-	   ^ camellia_sp3033[(il >> 8) & 0xff]			\
-	   ^ camellia_sp4404[il & 0xff];			\
+	yl = camellia_sp1110[(u8)(ir     )]			\
+	   ^ camellia_sp0222[    (t1 >> 8)]			\
+	   ^ camellia_sp3033[(u8)(t1     )]			\
+	   ^ camellia_sp4404[(u8)(ir >> 8)];			\
+	yr = camellia_sp1110[    (t0 >> 8)]			\
+	   ^ camellia_sp0222[(u8)(t0     )]			\
+	   ^ camellia_sp3033[(u8)(il >> 8)]			\
+	   ^ camellia_sp4404[(u8)(il     )];			\
 	yl ^= yr;						\
 	yr = ROR8(yr);						\
 	yr ^= yl;						\
     } while(0)
 
-
-/*
- * for speed up
- *
- */
-#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
-    do {								\
-	t0 = kll;							\
-	t2 = krr;							\
-	t0 &= ll;							\
-	t2 |= rr;							\
-	rl ^= t2;							\
-	lr ^= ROL1(t0);							\
-	t3 = krl;							\
-	t1 = klr;							\
-	t3 &= rl;							\
-	t1 |= lr;							\
-	ll ^= t1;							\
-	rr ^= ROL1(t3);							\
-    } while(0)
-
-#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
-    do {								\
-	ir =  camellia_sp1110[xr & 0xff];				\
-	il =  camellia_sp1110[(xl>>24) & 0xff];				\
-	ir ^= camellia_sp0222[(xr>>24) & 0xff];				\
-	il ^= camellia_sp0222[(xl>>16) & 0xff];				\
-	ir ^= camellia_sp3033[(xr>>16) & 0xff];				\
-	il ^= camellia_sp3033[(xl>>8) & 0xff];				\
-	ir ^= camellia_sp4404[(xr>>8) & 0xff];				\
-	il ^= camellia_sp4404[xl & 0xff];				\
-	il ^= kl;							\
-	ir ^= il ^ kr;							\
-	yl ^= ir;							\
-	yr ^= ROR8(il) ^ ir;						\
-    } while(0)
-
-
 #define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
 #define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
@@ -999,8 +1542,49 @@ static void camellia_setup192(const unsi
 	camellia_setup256(kk, subkey);
 }
 
+typedef u32 key_element;
+typedef const u32 const_key_element;
+
+#endif /* 32/64-bit key setup versions */
+
+
+
+/*
+ * Encrypt/decrypt
+ */
+#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
+    do {								\
+	t0 = kll;							\
+	t2 = krr;							\
+	t0 &= ll;							\
+	t2 |= rr;							\
+	rl ^= t2;							\
+	lr ^= ROL1(t0);							\
+	t3 = krl;							\
+	t1 = klr;							\
+	t3 &= rl;							\
+	t1 |= lr;							\
+	ll ^= t1;							\
+	rr ^= ROL1(t3);							\
+    } while(0)
+
+#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
+    do {								\
+	ir =  camellia_sp1110[(u8)xr];					\
+	il =  camellia_sp1110[    (xl >> 24)];				\
+	ir ^= camellia_sp0222[    (xr >> 24)];				\
+	il ^= camellia_sp0222[(u8)(xl >> 16)];				\
+	ir ^= camellia_sp3033[(u8)(xr >> 16)];				\
+	il ^= camellia_sp3033[(u8)(xl >> 8)];				\
+	ir ^= camellia_sp4404[(u8)(xr >> 8)];				\
+	il ^= camellia_sp4404[(u8)xl];					\
+	il ^= kl;							\
+	ir ^= il ^ kr;							\
+	yl ^= ir;							\
+	yr ^= ROR8(il) ^ ir;						\
+    } while(0)
 
-static void camellia_encrypt128(const u32 *subkey, u32 *io_text)
+static void camellia_encrypt128(const_key_element *subkey, u32 *io_text)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
@@ -1015,22 +1599,22 @@ static void camellia_encrypt128(const u3
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(8),SUBKEY_R(8),
@@ -1039,22 +1623,22 @@ static void camellia_encrypt128(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(16),SUBKEY_R(16),
@@ -1063,22 +1647,22 @@ static void camellia_encrypt128(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	/* post whitening but kw4 */
 	io_text[0] = io[2] ^ SUBKEY_L(24);
@@ -1087,7 +1671,7 @@ static void camellia_encrypt128(const u3
 	io_text[3] = io[1];
 }
 
-static void camellia_decrypt128(const u32 *subkey, u32 *io_text)
+static void camellia_decrypt128(const_key_element *subkey, u32 *io_text)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
@@ -1102,22 +1686,22 @@ static void camellia_decrypt128(const u3
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(17),SUBKEY_R(17),
@@ -1126,22 +1710,22 @@ static void camellia_decrypt128(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(9),SUBKEY_R(9),
@@ -1150,22 +1734,22 @@ static void camellia_decrypt128(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	/* post whitening but kw4 */
 	io_text[0] = io[2] ^ SUBKEY_L(0);
@@ -1174,7 +1758,7 @@ static void camellia_decrypt128(const u3
 	io_text[3] = io[1];
 }
 
-static void camellia_encrypt256(const u32 *subkey, u32 *io_text)
+static void camellia_encrypt256(const_key_element *subkey, u32 *io_text)
 {
 	u32 il,ir,t0,t1;           /* temporary variables */
 
@@ -1189,22 +1773,22 @@ static void camellia_encrypt256(const u3
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(8),SUBKEY_R(8),
@@ -1213,22 +1797,22 @@ static void camellia_encrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(16),SUBKEY_R(16),
@@ -1237,22 +1821,22 @@ static void camellia_encrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(24),SUBKEY_R(24),
@@ -1261,22 +1845,22 @@ static void camellia_encrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	/* post whitening but kw4 */
 	io_text[0] = io[2] ^ SUBKEY_L(32);
@@ -1285,7 +1869,7 @@ static void camellia_encrypt256(const u3
 	io_text[3] = io[1];
 }
 
-static void camellia_decrypt256(const u32 *subkey, u32 *io_text)
+static void camellia_decrypt256(const_key_element *subkey, u32 *io_text)
 {
 	u32 il,ir,t0,t1;           /* temporary variables */
 
@@ -1300,22 +1884,22 @@ static void camellia_decrypt256(const u3
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(25),SUBKEY_R(25),
@@ -1324,22 +1908,22 @@ static void camellia_decrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(17),SUBKEY_R(17),
@@ -1348,22 +1932,22 @@ static void camellia_decrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
 		     SUBKEY_L(9),SUBKEY_R(9),
@@ -1372,22 +1956,22 @@ static void camellia_decrypt256(const u3
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir,t0,t1);
+			 io[2],io[3],il,ir);
 	CAMELLIA_ROUNDSM(io[2],io[3],
 			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir,t0,t1);
+			 io[0],io[1],il,ir);
 
 	/* post whitening but kw4 */
 	io_text[0] = io[2] ^ SUBKEY_L(0);
@@ -1399,7 +1983,7 @@ static void camellia_decrypt256(const u3
 
 struct camellia_ctx {
 	int key_length;
-	u32 key_table[CAMELLIA_TABLE_BYTE_LEN / 4];
+	key_element key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(key_element)];
 };
 
 static int

--Boundary-00=_Uu5QH1LsGwNm2sI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.23.1.camellia6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23.1.camellia6.diff"

diff -urpN linux-2.6.23.1.camellia5/crypto/camellia.c linux-2.6.23.1.camellia6/crypto/camellia.c
--- linux-2.6.23.1.camellia5/crypto/camellia.c	2007-11-14 11:30:27.000000000 -0800
+++ linux-2.6.23.1.camellia6/crypto/camellia.c	2007-11-14 11:30:27.000000000 -0800
@@ -1584,400 +1584,115 @@ typedef const u32 const_key_element;
 	yr ^= ROR8(il) ^ ir;						\
     } while(0)
 
-static void camellia_encrypt128(const_key_element *subkey, u32 *io_text)
+/* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
+static void camellia_do_encrypt(const_key_element *subkey, u32 *io, unsigned max)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
-	u32 io[4];
-
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(0);
+	io[1] ^= SUBKEY_R(0);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir);
-
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(24);
-	io_text[1] = io[3] ^ SUBKEY_R(24);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
-
-static void camellia_decrypt128(const_key_element *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;               /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(24);
-	io[1] = io_text[1] ^ SUBKEY_R(24);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     t0,t1,il,ir); \
+} while (0)
+
+	ROUNDS(0);
+	FLS(8);
+	ROUNDS(8);
+	FLS(16);
+	ROUNDS(16);
+	if (max == 32) {
+		FLS(24);
+		ROUNDS(24);
+	}
 
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir);
+#undef ROUNDS
+#undef FLS
 
 	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(0);
-	io_text[1] = io[3] ^ SUBKEY_R(0);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
+	io[2] ^= SUBKEY_L(max);
+	io[3] ^= SUBKEY_R(max);
+	/* NB: io[0],[1] should be swapped with [2],[3] by caller! */
 }
 
-static void camellia_encrypt256(const_key_element *subkey, u32 *io_text)
+static void camellia_do_decrypt(const_key_element *subkey, u32 *io, unsigned i)
 {
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
+	u32 il,ir,t0,t1;               /* temporary variables */
 
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(i);
+	io[1] ^= SUBKEY_R(i);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[0],io[1],il,ir);
-
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(32);
-	io_text[1] = io[3] ^ SUBKEY_R(32);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
-
-static void camellia_decrypt256(const_key_element *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(32);
-	io[1] = io_text[1] ^ SUBKEY_R(32);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     t0,t1,il,ir); \
+} while (0)
+
+	if (i == 32) {
+		ROUNDS(24);
+		FLS(24);
+	}
+	ROUNDS(16);
+	FLS(16);
+	ROUNDS(8);
+	FLS(8);
+	ROUNDS(0);
 
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir);
+#undef ROUNDS
+#undef FLS
 
 	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(0);
-	io_text[1] = io[3] ^ SUBKEY_R(0);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
+	io[2] ^= SUBKEY_L(0);
+	io[3] ^= SUBKEY_R(0);
+	/* NB: 0,1 should be swapped with 2,3 by caller! */
 }
 
 
@@ -2029,21 +1744,15 @@ static void camellia_encrypt(struct cryp
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	switch (cctx->key_length) {
-	case 16:
-		camellia_encrypt128(cctx->key_table, tmp);
-		break;
-	case 24:
-		/* fall through */
-	case 32:
-		camellia_encrypt256(cctx->key_table, tmp);
-		break;
-	}
-
-	dst[0] = cpu_to_be32(tmp[0]);
-	dst[1] = cpu_to_be32(tmp[1]);
-	dst[2] = cpu_to_be32(tmp[2]);
-	dst[3] = cpu_to_be32(tmp[3]);
+	camellia_do_encrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_encrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
 }
 
 static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -2059,21 +1768,15 @@ static void camellia_decrypt(struct cryp
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	switch (cctx->key_length) {
-	case 16:
-		camellia_decrypt128(cctx->key_table, tmp);
-		break;
-	case 24:
-		/* fall through */
-	case 32:
-		camellia_decrypt256(cctx->key_table, tmp);
-		break;
-	}
-
-	dst[0] = cpu_to_be32(tmp[0]);
-	dst[1] = cpu_to_be32(tmp[1]);
-	dst[2] = cpu_to_be32(tmp[2]);
-	dst[3] = cpu_to_be32(tmp[3]);
+	camellia_do_decrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_decrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
 }
 
 static struct crypto_alg camellia_alg = {

--Boundary-00=_Uu5QH1LsGwNm2sI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.23.1.camellia8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23.1.camellia8.diff"

diff -urpN linux-2.6.23.1.camellia7/crypto/camellia.c linux-2.6.23.1.camellia8/crypto/camellia.c
--- linux-2.6.23.1.camellia7/crypto/camellia.c	2007-11-18 20:15:19.000000000 -0800
+++ linux-2.6.23.1.camellia8/crypto/camellia.c	2007-11-20 18:29:39.000000000 -0800
@@ -391,10 +391,94 @@ static const u32 camellia_sp4404[256] = 
 
 static void camellia_setup_tail(u64 *subkey, u64 *sub, int max)
 {
+	u64 kw4;
 	u64 t;
 	u32 dw;
 	int i;
 
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	sub[3] ^= sub[1];
+	/* round 4 */
+	sub[5] ^= sub[1];
+	/* round 6 */
+	sub[7] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(9);
+	dw = subL(1) & subL(9),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	sub[11] ^= sub[1];
+	/* round 10 */
+	sub[13] ^= sub[1];
+	/* round 12 */
+	sub[15] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(17);
+	dw = subL(1) & subL(17),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	sub[19] ^= sub[1];
+	/* round 16 */
+	sub[21] ^= sub[1];
+	/* round 18 */
+	sub[23] ^= sub[1];
+	if (max == 24) {
+		/* kw3 */
+		sub[24] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+		kw4 = sub[25];
+	} else {
+		subL(1) ^= subR(1) & ~subR(25);
+		dw = subL(1) & subL(25),
+			subR(1) ^= ROL1(dw); /* modified for FLinv(kl6) */
+		/* round 20 */
+		sub[27] ^= sub[1];
+		/* round 22 */
+		sub[29] ^= sub[1];
+		/* round 24 */
+		sub[31] ^= sub[1];
+		/* kw3 */
+		sub[32] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+		kw4 = sub[33];
+		/* round 23 */
+		sub[30] ^= kw4;
+		/* round 21 */
+		sub[28] ^= kw4;
+		/* round 19 */
+		sub[26] ^= kw4;
+		kw4 ^= (u64)((u32)kw4 & ~subR(24)) << 32; //kw4l ^= kw4r & ~subR[24];
+		dw = (u32)(kw4 >> 32) & subL(24);
+		kw4 ^= ROL1(dw); /* modified for FL(kl5) */
+	}
+	/* round 17 */
+	sub[22] ^= kw4;
+	/* round 15 */
+	sub[20] ^= kw4;
+	/* round 13 */
+	sub[18] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32; //kw4l ^= kw4r & ~subR(16);
+	dw = (u32)(kw4 >> 32) & subL(16); // kw4l & subL[16],
+	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	sub[14] ^= kw4;
+	/* round 9 */
+	sub[12] ^= kw4;
+	/* round 7 */
+	sub[10] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32; //kw4l ^= kw4r & ~subR[8];
+	dw = (u32)(kw4 >> 32) & subL(8);
+	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	sub[6] ^= kw4;
+	/* round 3 */
+	sub[4] ^= kw4;
+	/* round 1 */
+	sub[2] ^= kw4;
+	/* kw1 */
+	sub[0] ^= kw4;
+
 	/* key XOR is end of F-function */
 	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
 	SUBKEY(2) = sub[3];       /* round 1 */
@@ -475,8 +559,6 @@ static void camellia_setup128(const unsi
 {
 	u64 kl, kr;
 	u64 i, w;
-	u64 kw4;
-	u32 dw;
 	u64 sub[26];
 
 	/**
@@ -565,63 +647,6 @@ static void camellia_setup128(const unsi
 	sub[24] = kl;
 	sub[25] = kr;
 
-	/* absorb kw2 to other subkeys */
-	/* round 2 */
-	sub[3] ^= sub[1];
-	/* round 4 */
-	sub[5] ^= sub[1];
-	/* round 6 */
-	sub[7] ^= sub[1];
-	subL(1) ^= subR(1) & ~subR(9);
-	dw = subL(1) & subL(9),
-		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
-	/* round 8 */
-	sub[11] ^= sub[1];
-	/* round 10 */
-	sub[13] ^= sub[1];
-	/* round 12 */
-	sub[15] ^= sub[1];
-	subL(1) ^= subR(1) & ~subR(17);
-	dw = subL(1) & subL(17),
-		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
-	/* round 14 */
-	sub[19] ^= sub[1];
-	/* round 16 */
-	sub[21] ^= sub[1];
-	/* round 18 */
-	sub[23] ^= sub[1];
-	/* kw3 */
-	sub[24] ^= sub[1];
-
-	/* absorb kw4 to other subkeys */
-	kw4 = sub[25];
-	/* round 17 */
-	sub[22] ^= kw4;
-	/* round 15 */
-	sub[20] ^= kw4;
-	/* round 13 */
-	sub[18] ^= kw4;
-	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32; //kw4l ^= kw4r & ~subR(16);
-	dw = (u32)(kw4 >> 32) & subL(16); // kw4l & subL[16],
-	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
-	/* round 11 */
-	sub[14] ^= kw4;
-	/* round 9 */
-	sub[12] ^= kw4;
-	/* round 7 */
-	sub[10] ^= kw4;
-	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32; //kw4l ^= kw4r & ~subR[8];
-	dw = (u32)(kw4 >> 32) & subL(8);
-	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
-	/* round 5 */
-	sub[6] ^= kw4;
-	/* round 3 */
-	sub[4] ^= kw4;
-	/* round 1 */
-	sub[2] ^= kw4;
-	/* kw1 */
-	sub[0] ^= kw4;
-
 	camellia_setup_tail(subkey, sub, 24);
 }
 
@@ -630,8 +655,6 @@ static void camellia_setup256(const unsi
 	u64 kl, kr;        /* left half of key */
 	u64 krl, krr;      /* right half of key */
 	u64 i, w;          /* temporary variables */
-	u64 kw4;
-	u32 dw;
 	u64 sub[34];
 
 	/**
@@ -756,81 +779,6 @@ static void camellia_setup256(const unsi
 	/* kw4 */
 	sub[33] = krr;
 
-	/* absorb kw2 to other subkeys */
-	/* round 2 */
-	sub[3] ^= sub[1];
-	/* round 4 */
-	sub[5] ^= sub[1];
-	/* round 6 */
-	sub[7] ^= sub[1];
-	subL(1) ^= subR(1) & ~subR(9);
-	dw = subL(1) & subL(9),
-		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
-	/* round 8 */
-	sub[11] ^= sub[1];
-	/* round 10 */
-	sub[13] ^= sub[1];
-	/* round 12 */
-	sub[15] ^= sub[1];
-	subL(1) ^= subR(1) & ~subR(17);
-	dw = subL(1) & subL(17),
-		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
-	/* round 14 */
-	sub[19] ^= sub[1];
-	/* round 16 */
-	sub[21] ^= sub[1];
-	/* round 18 */
-	sub[23] ^= sub[1];
-	subL(1) ^= subR(1) & ~subR(25);
-	dw = subL(1) & subL(25),
-		subR(1) ^= ROL1(dw); /* modified for FLinv(kl6) */
-	/* round 20 */
-	sub[27] ^= sub[1];
-	/* round 22 */
-	sub[29] ^= sub[1];
-	/* round 24 */
-	sub[31] ^= sub[1];
-	/* kw3 */
-	sub[32] ^= sub[1];
-
-	/* absorb kw4 to other subkeys */
-	kw4 = sub[33];
-	/* round 23 */
-	sub[30] ^= kw4;
-	/* round 21 */
-	sub[28] ^= kw4;
-	/* round 19 */
-	sub[26] ^= kw4;
-	kw4 ^= (u64)((u32)kw4 & ~subR(24)) << 32; //kw4l ^= kw4r & ~subR[24];
-	dw = (u32)(kw4 >> 32) & subL(24);
-	kw4 ^= ROL1(dw); /* modified for FL(kl5) */
-	/* round 17 */
-	sub[22] ^= kw4;
-	/* round 15 */
-	sub[20] ^= kw4;
-	/* round 13 */
-	sub[18] ^= kw4;
-	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32;
-	dw = (u32)(kw4 >> 32) & subL(16);
-	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
-	/* round 11 */
-	sub[14] ^= kw4;
-	/* round 9 */
-	sub[12] ^= kw4;
-	/* round 7 */
-	sub[10] ^= kw4;
-	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32;
-	dw = (u32)(kw4 >> 32) & subL(8);
-	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
-	/* round 5 */
-	sub[6] ^= kw4;
-	/* round 3 */
-	sub[4] ^= kw4;
-	/* round 1 */
-	sub[2] ^= kw4;
-	/* kw1 */
-	sub[0] ^= kw4;
-
 	camellia_setup_tail(subkey, sub, 32);
 }
 
@@ -933,8 +881,92 @@ typedef const u64 const_key_element;
 static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 {
 	u32 dw, tl, tr;
+	u32 kw4l, kw4r;
 	int i;
 
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	subL[3] ^= subL[1]; subR[3] ^= subR[1];
+	/* round 4 */
+	subL[5] ^= subL[1]; subR[5] ^= subR[1];
+	/* round 6 */
+	subL[7] ^= subL[1]; subR[7] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[9];
+	dw = subL[1] & subL[9],
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	subL[11] ^= subL[1]; subR[11] ^= subR[1];
+	/* round 10 */
+	subL[13] ^= subL[1]; subR[13] ^= subR[1];
+	/* round 12 */
+	subL[15] ^= subL[1]; subR[15] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[17];
+	dw = subL[1] & subL[17],
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	subL[19] ^= subL[1]; subR[19] ^= subR[1];
+	/* round 16 */
+	subL[21] ^= subL[1]; subR[21] ^= subR[1];
+	/* round 18 */
+	subL[23] ^= subL[1]; subR[23] ^= subR[1];
+	if (max == 24) {
+		/* kw3 */
+		subL[24] ^= subL[1]; subR[24] ^= subR[1];
+
+	/* absorb kw4 to other subkeys */
+		kw4l = subL[25]; kw4r = subR[25];
+	} else {
+		subL[1] ^= subR[1] & ~subR[25];
+		dw = subL[1] & subL[25],
+			subR[1] ^= ROL1(dw); /* modified for FLinv(kl6) */
+		/* round 20 */
+		subL[27] ^= subL[1]; subR[27] ^= subR[1];
+		/* round 22 */
+		subL[29] ^= subL[1]; subR[29] ^= subR[1];
+		/* round 24 */
+		subL[31] ^= subL[1]; subR[31] ^= subR[1];
+		/* kw3 */
+		subL[32] ^= subL[1]; subR[32] ^= subR[1];
+
+	/* absorb kw4 to other subkeys */
+		kw4l = subL[33]; kw4r = subR[33];
+		/* round 23 */
+		subL[30] ^= kw4l; subR[30] ^= kw4r;
+		/* round 21 */
+		subL[28] ^= kw4l; subR[28] ^= kw4r;
+		/* round 19 */
+		subL[26] ^= kw4l; subR[26] ^= kw4r;
+		kw4l ^= kw4r & ~subR[24];
+		dw = kw4l & subL[24],
+			kw4r ^= ROL1(dw); /* modified for FL(kl5) */
+	}
+	/* round 17 */
+	subL[22] ^= kw4l; subR[22] ^= kw4r;
+	/* round 15 */
+	subL[20] ^= kw4l; subR[20] ^= kw4r;
+	/* round 13 */
+	subL[18] ^= kw4l; subR[18] ^= kw4r;
+	kw4l ^= kw4r & ~subR[16];
+	dw = kw4l & subL[16],
+		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	subL[14] ^= kw4l; subR[14] ^= kw4r;
+	/* round 9 */
+	subL[12] ^= kw4l; subR[12] ^= kw4r;
+	/* round 7 */
+	subL[10] ^= kw4l; subR[10] ^= kw4r;
+	kw4l ^= kw4r & ~subR[8];
+	dw = kw4l & subL[8],
+		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	subL[6] ^= kw4l; subR[6] ^= kw4r;
+	/* round 3 */
+	subL[4] ^= kw4l; subR[4] ^= kw4r;
+	/* round 1 */
+	subL[2] ^= kw4l; subR[2] ^= kw4r;
+	/* kw1 */
+	subL[0] ^= kw4l; subR[0] ^= kw4r;
+
 	/* key XOR is end of F-function */
 	SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
 	SUBKEY_R(0) = subR[0] ^ subR[2];
@@ -1049,7 +1081,6 @@ static void camellia_setup128(const unsi
 {
 	u32 kll, klr, krl, krr;
 	u32 il, ir, t0, t1, w0, w1;
-	u32 kw4l, kw4r, dw;
 	u32 subL[26];
 	u32 subR[26];
 
@@ -1149,63 +1180,6 @@ static void camellia_setup128(const unsi
 	subL[24] = kll; subR[24] = klr;
 	subL[25] = krl; subR[25] = krr;
 
-	/* absorb kw2 to other subkeys */
-	/* round 2 */
-	subL[3] ^= subL[1]; subR[3] ^= subR[1];
-	/* round 4 */
-	subL[5] ^= subL[1]; subR[5] ^= subR[1];
-	/* round 6 */
-	subL[7] ^= subL[1]; subR[7] ^= subR[1];
-	subL[1] ^= subR[1] & ~subR[9];
-	dw = subL[1] & subL[9],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
-	/* round 8 */
-	subL[11] ^= subL[1]; subR[11] ^= subR[1];
-	/* round 10 */
-	subL[13] ^= subL[1]; subR[13] ^= subR[1];
-	/* round 12 */
-	subL[15] ^= subL[1]; subR[15] ^= subR[1];
-	subL[1] ^= subR[1] & ~subR[17];
-	dw = subL[1] & subL[17],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
-	/* round 14 */
-	subL[19] ^= subL[1]; subR[19] ^= subR[1];
-	/* round 16 */
-	subL[21] ^= subL[1]; subR[21] ^= subR[1];
-	/* round 18 */
-	subL[23] ^= subL[1]; subR[23] ^= subR[1];
-	/* kw3 */
-	subL[24] ^= subL[1]; subR[24] ^= subR[1];
-
-	/* absorb kw4 to other subkeys */
-	kw4l = subL[25]; kw4r = subR[25];
-	/* round 17 */
-	subL[22] ^= kw4l; subR[22] ^= kw4r;
-	/* round 15 */
-	subL[20] ^= kw4l; subR[20] ^= kw4r;
-	/* round 13 */
-	subL[18] ^= kw4l; subR[18] ^= kw4r;
-	kw4l ^= kw4r & ~subR[16];
-	dw = kw4l & subL[16],
-		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
-	/* round 11 */
-	subL[14] ^= kw4l; subR[14] ^= kw4r;
-	/* round 9 */
-	subL[12] ^= kw4l; subR[12] ^= kw4r;
-	/* round 7 */
-	subL[10] ^= kw4l; subR[10] ^= kw4r;
-	kw4l ^= kw4r & ~subR[8];
-	dw = kw4l & subL[8],
-		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
-	/* round 5 */
-	subL[6] ^= kw4l; subR[6] ^= kw4r;
-	/* round 3 */
-	subL[4] ^= kw4l; subR[4] ^= kw4r;
-	/* round 1 */
-	subL[2] ^= kw4l; subR[2] ^= kw4r;
-	/* kw1 */
-	subL[0] ^= kw4l; subR[0] ^= kw4r;
-
 	camellia_setup_tail(subkey, subL, subR, 24);
 }
 
@@ -1214,7 +1188,6 @@ static void camellia_setup256(const unsi
 	u32 kll, klr, krl, krr;        /* left half of key */
 	u32 krll, krlr, krrl, krrr;    /* right half of key */
 	u32 il, ir, t0, t1, w0, w1;    /* temporary variables */
-	u32 kw4l, kw4r, dw;
 	u32 subL[34];
 	u32 subR[34];
 
@@ -1356,81 +1329,6 @@ static void camellia_setup256(const unsi
 	/* kw4 */
 	subL[33] = krrl; subR[33] = krrr;
 
-	/* absorb kw2 to other subkeys */
-	/* round 2 */
-	subL[3] ^= subL[1]; subR[3] ^= subR[1];
-	/* round 4 */
-	subL[5] ^= subL[1]; subR[5] ^= subR[1];
-	/* round 6 */
-	subL[7] ^= subL[1]; subR[7] ^= subR[1];
-	subL[1] ^= subR[1] & ~subR[9];
-	dw = subL[1] & subL[9],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
-	/* round 8 */
-	subL[11] ^= subL[1]; subR[11] ^= subR[1];
-	/* round 10 */
-	subL[13] ^= subL[1]; subR[13] ^= subR[1];
-	/* round 12 */
-	subL[15] ^= subL[1]; subR[15] ^= subR[1];
-	subL[1] ^= subR[1] & ~subR[17];
-	dw = subL[1] & subL[17],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
-	/* round 14 */
-	subL[19] ^= subL[1]; subR[19] ^= subR[1];
-	/* round 16 */
-	subL[21] ^= subL[1]; subR[21] ^= subR[1];
-	/* round 18 */
-	subL[23] ^= subL[1]; subR[23] ^= subR[1];
-	subL[1] ^= subR[1] & ~subR[25];
-	dw = subL[1] & subL[25],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl6) */
-	/* round 20 */
-	subL[27] ^= subL[1]; subR[27] ^= subR[1];
-	/* round 22 */
-	subL[29] ^= subL[1]; subR[29] ^= subR[1];
-	/* round 24 */
-	subL[31] ^= subL[1]; subR[31] ^= subR[1];
-	/* kw3 */
-	subL[32] ^= subL[1]; subR[32] ^= subR[1];
-
-	/* absorb kw4 to other subkeys */
-	kw4l = subL[33]; kw4r = subR[33];
-	/* round 23 */
-	subL[30] ^= kw4l; subR[30] ^= kw4r;
-	/* round 21 */
-	subL[28] ^= kw4l; subR[28] ^= kw4r;
-	/* round 19 */
-	subL[26] ^= kw4l; subR[26] ^= kw4r;
-	kw4l ^= kw4r & ~subR[24];
-	dw = kw4l & subL[24],
-		kw4r ^= ROL1(dw); /* modified for FL(kl5) */
-	/* round 17 */
-	subL[22] ^= kw4l; subR[22] ^= kw4r;
-	/* round 15 */
-	subL[20] ^= kw4l; subR[20] ^= kw4r;
-	/* round 13 */
-	subL[18] ^= kw4l; subR[18] ^= kw4r;
-	kw4l ^= kw4r & ~subR[16];
-	dw = kw4l & subL[16],
-		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
-	/* round 11 */
-	subL[14] ^= kw4l; subR[14] ^= kw4r;
-	/* round 9 */
-	subL[12] ^= kw4l; subR[12] ^= kw4r;
-	/* round 7 */
-	subL[10] ^= kw4l; subR[10] ^= kw4r;
-	kw4l ^= kw4r & ~subR[8];
-	dw = kw4l & subL[8],
-		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
-	/* round 5 */
-	subL[6] ^= kw4l; subR[6] ^= kw4r;
-	/* round 3 */
-	subL[4] ^= kw4l; subR[4] ^= kw4r;
-	/* round 1 */
-	subL[2] ^= kw4l; subR[2] ^= kw4r;
-	/* kw1 */
-	subL[0] ^= kw4l; subR[0] ^= kw4r;
-
 	camellia_setup_tail(subkey, subL, subR, 32);
 }
 

--Boundary-00=_Uu5QH1LsGwNm2sI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.23.1.camellia7.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23.1.camellia7.diff"

diff -urpN linux-2.6.23.1.camellia6/crypto/camellia.c linux-2.6.23.1.camellia7/crypto/camellia.c
--- linux-2.6.23.1.camellia6/crypto/camellia.c	2007-11-14 11:30:27.000000000 -0800
+++ linux-2.6.23.1.camellia7/crypto/camellia.c	2007-11-18 20:15:19.000000000 -0800
@@ -380,15 +380,80 @@ static const u32 camellia_sp4404[256] = 
 #ifdef __BIG_ENDIAN
 #define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2])
 #define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
 #else
 #define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
 #define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2])
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2])
 #endif
 
-static void camellia_setup_tail(u64 *subkey, int max)
+static void camellia_setup_tail(u64 *subkey, u64 *sub, int max)
 {
+	u64 t;
 	u32 dw;
-	int i = 2;
+	int i;
+
+	/* key XOR is end of F-function */
+	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
+	SUBKEY(2) = sub[3];       /* round 1 */
+	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
+	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
+	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
+	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
+	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = (u32)t & subL(8);  /* FL(kl1) */
+	t = (t << 32) | (subR(10) ^ ROL1(dw)); // tr = subR[10] ^ ROL1(dw);
+	SUBKEY(7) = sub[6] ^ t;   /* round 6 */
+	SUBKEY(8) = sub[8];       /* FL(kl1) */
+	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
+	t = subL(7) ^ (subR(7) & ~subR(9));
+	dw = (u32)t & subL(9);  /* FLinv(kl2) */
+	t = (t << 32) | (subR(7) ^ ROL1(dw));
+	SUBKEY(10) = t ^ sub[11]; /* round 7 */
+	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
+	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
+	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
+	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
+	t = subL(18) ^ (subR(18) & ~subR(16));
+	dw = (u32)t & subL(16); /* FL(kl3) */
+	t = (t << 32) | (subR(18) ^ ROL1(dw));
+	SUBKEY(15) = sub[14] ^ t; /* round 12 */
+	SUBKEY(16) = sub[16];     /* FL(kl3) */
+	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
+	t = subL(15) ^ (subR(15) & ~subR(17));
+	dw = (u32)t & subL(17); /* FLinv(kl4) */
+	t = (t << 32) | (subR(15) ^ ROL1(dw));
+	SUBKEY(18) = t ^ sub[19]; /* round 13 */
+	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
+	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
+	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
+	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
+	if (max == 24) {
+		SUBKEY(23) = sub[22];     /* round 18 */
+		SUBKEY(24) = sub[24] ^ sub[23]; /* kw3 */
+	} else { 
+		t = subL(26) ^ (subR(26) & ~subR(24));
+		dw = (u32)t & subL(24); /* FL(kl5) */
+		t = (t << 32) | (subR(26) ^ ROL1(dw));
+		SUBKEY(23) = sub[22] ^ t; /* round 18 */
+		SUBKEY(24) = sub[24];     /* FL(kl5) */
+		SUBKEY(25) = sub[25];     /* FLinv(kl6) */
+		t = subL(23) ^ (subR(23) & ~subR(25));
+		dw = (u32)t & subL(25); /* FLinv(kl6) */
+		t = (t << 32) | (subR(23) ^ ROL1(dw));
+		SUBKEY(26) = t ^ sub[27]; /* round 19 */
+		SUBKEY(27) = sub[26] ^ sub[28]; /* round 20 */
+		SUBKEY(28) = sub[27] ^ sub[29]; /* round 21 */
+		SUBKEY(29) = sub[28] ^ sub[30]; /* round 22 */
+		SUBKEY(30) = sub[29] ^ sub[31]; /* round 23 */
+		SUBKEY(31) = sub[30];     /* round 24 */
+		SUBKEY(32) = sub[32] ^ sub[31]; /* kw3 */
+	}
+
+	/* apply the inverse of the last half of P-function */
+	i = 2;
 	do {
 		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = ROL8(dw);/* round 1 */
 		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
@@ -406,31 +471,21 @@ static void camellia_setup_tail(u64 *sub
 	} while (i < max);
 }
 
-#ifdef __BIG_ENDIAN
-#define subL(INDEX) (((u32*)sub)[(INDEX)*2])
-#define subR(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
-#else
-#define subL(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
-#define subR(INDEX) (((u32*)sub)[(INDEX)*2])
-#endif
-
 static void camellia_setup128(const unsigned char *key, u64 *subkey)
 {
 	u64 kl, kr;
-	u64 i, t, w;
+	u64 i, w;
 	u64 kw4;
 	u32 dw;
 	u64 sub[26];
 
 	/**
-	 *  k == kl || kr (|| is concatination)
+	 *  k == kl || kr (|| is concatenation)
 	 */
 	GETU64(kl, key     );
 	GETU64(kr, key +  8);
 
-	/**
-	 * generate KL dependent subkeys
-	 */
+	/* generate KL dependent subkeys */
 	/* kw1 */
 	sub[0] = kl;
 	/* kw2 */
@@ -567,60 +622,21 @@ static void camellia_setup128(const unsi
 	/* kw1 */
 	sub[0] ^= kw4;
 
-	/* key XOR is end of F-function */
-	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
-	SUBKEY(2) = sub[3];       /* round 1 */
-	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
-	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
-	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
-	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
-	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = (u32)t & subL(8);  /* FL(kl1) */
-	t = (t << 32) | (subR(10) ^ ROL1(dw)); // tr = subR[10] ^ ROL1(dw);
-	SUBKEY(7) = sub[6] ^ t; /* round 6 */
-	SUBKEY(8) = sub[8];       /* FL(kl1) */
-	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
-	t = subL(7) ^ (subR(7) & ~subR(9));
-	dw = (u32)t & subL(9);  /* FLinv(kl2) */
-	t = (t << 32) | (subR(7) ^ ROL1(dw));
-	SUBKEY(10) = t ^ sub[11]; /* round 7 */
-	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
-	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
-	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
-	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
-	t = subL(18) ^ (subR(18) & ~subR(16));
-	dw = (u32)t & subL(16); /* FL(kl3) */
-	t = (t << 32) | (subR(18) ^ ROL1(dw));
-	SUBKEY(15) = sub[14] ^ t; /* round 12 */
-	SUBKEY(16) = sub[16];     /* FL(kl3) */
-	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
-	t = subL(15) ^ (subR(15) & ~subR(17));
-	dw = (u32)t & subL(17); /* FLinv(kl4) */
-	t = (t << 32) | (subR(15) ^ ROL1(dw));
-	SUBKEY(18) = t ^ sub[19]; /* round 13 */
-	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
-	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
-	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
-	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
-	SUBKEY(23) = sub[22];     /* round 18 */
-	SUBKEY(24) = sub[24] ^ sub[23]; /* kw3 */
-
-	/* apply the inverse of the last half of P-function */
-	camellia_setup_tail(subkey, 24);
+	camellia_setup_tail(subkey, sub, 24);
 }
 
 static void camellia_setup256(const unsigned char *key, u64 *subkey)
 {
 	u64 kl, kr;        /* left half of key */
 	u64 krl, krr;      /* right half of key */
-	u64 i, t, w;       /* temporary variables */
+	u64 i, w;          /* temporary variables */
 	u64 kw4;
 	u32 dw;
 	u64 sub[34];
 
 	/**
 	 *  key = (kl || kr || krl || krr)
-	 *  (|| is concatination)
+	 *  (|| is concatenation)
 	 */
 	GETU64(kl,  key     );
 	GETU64(kr,  key +  8);
@@ -786,8 +802,8 @@ static void camellia_setup256(const unsi
 	/* round 19 */
 	sub[26] ^= kw4;
 	kw4 ^= (u64)((u32)kw4 & ~subR(24)) << 32; //kw4l ^= kw4r & ~subR[24];
-	dw = (u32)(kw4 >> 32) & subL(24),
-		kw4 ^= ROL1(dw); /* modified for FL(kl5) */
+	dw = (u32)(kw4 >> 32) & subL(24);
+	kw4 ^= ROL1(dw); /* modified for FL(kl5) */
 	/* round 17 */
 	sub[22] ^= kw4;
 	/* round 15 */
@@ -795,8 +811,8 @@ static void camellia_setup256(const unsi
 	/* round 13 */
 	sub[18] ^= kw4;
 	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32;
-	dw = (u32)(kw4 >> 32) & subL(16),
-		kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	dw = (u32)(kw4 >> 32) & subL(16);
+	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
 	/* round 11 */
 	sub[14] ^= kw4;
 	/* round 9 */
@@ -804,8 +820,8 @@ static void camellia_setup256(const unsi
 	/* round 7 */
 	sub[10] ^= kw4;
 	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32;
-	dw = (u32)(kw4 >> 32) & subL(8),
-		kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	dw = (u32)(kw4 >> 32) & subL(8);
+	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
 	/* round 5 */
 	sub[6] ^= kw4;
 	/* round 3 */
@@ -815,60 +831,7 @@ static void camellia_setup256(const unsi
 	/* kw1 */
 	sub[0] ^= kw4;
 
-	/* key XOR is end of F-function */
-	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
-	SUBKEY(2) = sub[3];       /* round 1 */
-	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
-	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
-	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
-	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
-	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = (u32)t & subL(8);  /* FL(kl1) */
-	t = (t << 32) | (subR(10) ^ ROL1(dw)); //tr = subR[10] ^ ROL1(dw);
-	SUBKEY(7) = sub[6] ^ t;   /* round 6 */
-	SUBKEY(8) = sub[8];       /* FL(kl1) */
-	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
-	t = subL(7) ^ (subR(7) & ~subR(9));
-	dw = (u32)t & subL(9);  /* FLinv(kl2) */
-	t = (t << 32) | (subR(7) ^ ROL1(dw));
-	SUBKEY(10) = t ^ sub[11]; /* round 7 */
-	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
-	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
-	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
-	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
-	t = subL(18) ^ (subR(18) & ~subR(16));
-	dw = (u32)t & subL(16); /* FL(kl3) */
-	t = (t << 32) | (subR(18) ^ ROL1(dw));
-	SUBKEY(15) = sub[14] ^ t; /* round 12 */
-	SUBKEY(16) = sub[16];     /* FL(kl3) */
-	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
-	t = subL(15) ^ (subR(15) & ~subR(17));
-	dw = (u32)t & subL(17); /* FLinv(kl4) */
-	t = (t << 32) | (subR(15) ^ ROL1(dw));
-	SUBKEY(18) = t ^ sub[19]; /* round 13 */
-	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
-	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
-	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
-	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
-	t = subL(26) ^ (subR(26) & ~subR(24));
-	dw = (u32)t & subL(24); /* FL(kl5) */
-	t = (t << 32) | (subR(26) ^ ROL1(dw));
-	SUBKEY(23) = sub[22] ^ t; /* round 18 */
-	SUBKEY(24) = sub[24];     /* FL(kl5) */
-	SUBKEY(25) = sub[25];     /* FLinv(kl6) */
-	t = subL(23) ^ (subR(23) & ~subR(25));
-	dw = (u32)t & subL(25); /* FLinv(kl6) */
-	t = (t << 32) | (subR(23) ^ ROL1(dw));
-	SUBKEY(26) = t ^ sub[27]; /* round 19 */
-	SUBKEY(27) = sub[26] ^ sub[28]; /* round 20 */
-	SUBKEY(28) = sub[27] ^ sub[29]; /* round 21 */
-	SUBKEY(29) = sub[28] ^ sub[30]; /* round 22 */
-	SUBKEY(30) = sub[29] ^ sub[31]; /* round 23 */
-	SUBKEY(31) = sub[30];     /* round 24 */
-	SUBKEY(32) = sub[32] ^ sub[31]; /* kw3 */
-
-	/* apply the inverse of the last half of P-function */
-	camellia_setup_tail(subkey, 32);
+	camellia_setup_tail(subkey, sub, 32);
 }
 
 static void camellia_setup192(const unsigned char *key, u64 *subkey)
@@ -967,10 +930,104 @@ typedef const u64 const_key_element;
 #define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
 #define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
-static void camellia_setup_tail(u32 *subkey, int max)
+static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 {
-	u32 dw;
-	int i = 2;
+	u32 dw, tl, tr;
+	int i;
+
+	/* key XOR is end of F-function */
+	SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
+	SUBKEY_R(0) = subR[0] ^ subR[2];
+	SUBKEY_L(2) = subL[3];       /* round 1 */
+	SUBKEY_R(2) = subR[3];
+	SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
+	SUBKEY_R(3) = subR[2] ^ subR[4];
+	SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
+	SUBKEY_R(4) = subR[3] ^ subR[5];
+	SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
+	SUBKEY_R(5) = subR[4] ^ subR[6];
+	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
+	SUBKEY_R(6) = subR[5] ^ subR[7];
+	tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = tl & subL[8],  /* FL(kl1) */
+		tr = subR[10] ^ ROL1(dw);
+	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
+	SUBKEY_R(7) = subR[6] ^ tr;
+	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
+	SUBKEY_R(8) = subR[8];
+	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
+	SUBKEY_R(9) = subR[9];
+	tl = subL[7] ^ (subR[7] & ~subR[9]);
+	dw = tl & subL[9],  /* FLinv(kl2) */
+		tr = subR[7] ^ ROL1(dw);
+	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
+	SUBKEY_R(10) = tr ^ subR[11];
+	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
+	SUBKEY_R(11) = subR[10] ^ subR[12];
+	SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
+	SUBKEY_R(12) = subR[11] ^ subR[13];
+	SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
+	SUBKEY_R(13) = subR[12] ^ subR[14];
+	SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
+	SUBKEY_R(14) = subR[13] ^ subR[15];
+	tl = subL[18] ^ (subR[18] & ~subR[16]);
+	dw = tl & subL[16], /* FL(kl3) */
+		tr = subR[18] ^ ROL1(dw);
+	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
+	SUBKEY_R(15) = subR[14] ^ tr;
+	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
+	SUBKEY_R(16) = subR[16];
+	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
+	SUBKEY_R(17) = subR[17];
+	tl = subL[15] ^ (subR[15] & ~subR[17]);
+	dw = tl & subL[17], /* FLinv(kl4) */
+		tr = subR[15] ^ ROL1(dw);
+	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
+	SUBKEY_R(18) = tr ^ subR[19];
+	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
+	SUBKEY_R(19) = subR[18] ^ subR[20];
+	SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
+	SUBKEY_R(20) = subR[19] ^ subR[21];
+	SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
+	SUBKEY_R(21) = subR[20] ^ subR[22];
+	SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
+	SUBKEY_R(22) = subR[21] ^ subR[23];
+	if (max == 24) {
+		SUBKEY_L(23) = subL[22];     /* round 18 */
+		SUBKEY_R(23) = subR[22];
+		SUBKEY_L(24) = subL[24] ^ subL[23]; /* kw3 */
+		SUBKEY_R(24) = subR[24] ^ subR[23];
+	} else {
+		tl = subL[26] ^ (subR[26] & ~subR[24]);
+		dw = tl & subL[24], /* FL(kl5) */
+			tr = subR[26] ^ ROL1(dw);
+		SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
+		SUBKEY_R(23) = subR[22] ^ tr;
+		SUBKEY_L(24) = subL[24];     /* FL(kl5) */
+		SUBKEY_R(24) = subR[24];
+		SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
+		SUBKEY_R(25) = subR[25];
+		tl = subL[23] ^ (subR[23] & ~subR[25]);
+		dw = tl & subL[25], /* FLinv(kl6) */
+			tr = subR[23] ^ ROL1(dw);
+		SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
+		SUBKEY_R(26) = tr ^ subR[27];
+		SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
+		SUBKEY_R(27) = subR[26] ^ subR[28];
+		SUBKEY_L(28) = subL[27] ^ subL[29]; /* round 21 */
+		SUBKEY_R(28) = subR[27] ^ subR[29];
+		SUBKEY_L(29) = subL[28] ^ subL[30]; /* round 22 */
+		SUBKEY_R(29) = subR[28] ^ subR[30];
+		SUBKEY_L(30) = subL[29] ^ subL[31]; /* round 23 */
+		SUBKEY_R(30) = subR[29] ^ subR[31];
+		SUBKEY_L(31) = subL[30];     /* round 24 */
+		SUBKEY_R(31) = subR[30];
+		SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
+		SUBKEY_R(32) = subR[32] ^ subR[31];
+	}
+
+	/* apply the inverse of the last half of P-function */
+	i = 2;
 	do {
 		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = ROL8(dw);/* round 1 */
 		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
@@ -992,21 +1049,19 @@ static void camellia_setup128(const unsi
 {
 	u32 kll, klr, krl, krr;
 	u32 il, ir, t0, t1, w0, w1;
-	u32 kw4l, kw4r, dw, tl, tr;
+	u32 kw4l, kw4r, dw;
 	u32 subL[26];
 	u32 subR[26];
 
 	/**
-	 *  k == kll || klr || krl || krr (|| is concatination)
+	 *  k == kll || klr || krl || krr (|| is concatenation)
 	 */
 	GETU32(kll, key     );
 	GETU32(klr, key +  4);
 	GETU32(krl, key +  8);
 	GETU32(krr, key + 12);
 
-	/**
-	 * generate KL dependent subkeys
-	 */
+	/* generate KL dependent subkeys */
 	/* kw1 */
 	subL[0] = kll; subR[0] = klr;
 	/* kw2 */
@@ -1151,70 +1206,7 @@ static void camellia_setup128(const unsi
 	/* kw1 */
 	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
-	/* key XOR is end of F-function */
-	SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
-	SUBKEY_R(0) = subR[0] ^ subR[2];
-	SUBKEY_L(2) = subL[3];       /* round 1 */
-	SUBKEY_R(2) = subR[3];
-	SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
-	SUBKEY_R(3) = subR[2] ^ subR[4];
-	SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
-	SUBKEY_R(4) = subR[3] ^ subR[5];
-	SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
-	SUBKEY_R(5) = subR[4] ^ subR[6];
-	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
-	SUBKEY_R(6) = subR[5] ^ subR[7];
-	tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ ROL1(dw);
-	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
-	SUBKEY_R(7) = subR[6] ^ tr;
-	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
-	SUBKEY_R(8) = subR[8];
-	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
-	SUBKEY_R(9) = subR[9];
-	tl = subL[7] ^ (subR[7] & ~subR[9]);
-	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ ROL1(dw);
-	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
-	SUBKEY_R(10) = tr ^ subR[11];
-	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
-	SUBKEY_R(11) = subR[10] ^ subR[12];
-	SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
-	SUBKEY_R(12) = subR[11] ^ subR[13];
-	SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
-	SUBKEY_R(13) = subR[12] ^ subR[14];
-	SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
-	SUBKEY_R(14) = subR[13] ^ subR[15];
-	tl = subL[18] ^ (subR[18] & ~subR[16]);
-	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ ROL1(dw);
-	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
-	SUBKEY_R(15) = subR[14] ^ tr;
-	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
-	SUBKEY_R(16) = subR[16];
-	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
-	SUBKEY_R(17) = subR[17];
-	tl = subL[15] ^ (subR[15] & ~subR[17]);
-	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ ROL1(dw);
-	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
-	SUBKEY_R(18) = tr ^ subR[19];
-	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
-	SUBKEY_R(19) = subR[18] ^ subR[20];
-	SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
-	SUBKEY_R(20) = subR[19] ^ subR[21];
-	SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
-	SUBKEY_R(21) = subR[20] ^ subR[22];
-	SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
-	SUBKEY_R(22) = subR[21] ^ subR[23];
-	SUBKEY_L(23) = subL[22];     /* round 18 */
-	SUBKEY_R(23) = subR[22];
-	SUBKEY_L(24) = subL[24] ^ subL[23]; /* kw3 */
-	SUBKEY_R(24) = subR[24] ^ subR[23];
-
-	/* apply the inverse of the last half of P-function */
-	camellia_setup_tail(subkey, 24);
+	camellia_setup_tail(subkey, subL, subR, 24);
 }
 
 static void camellia_setup256(const unsigned char *key, u32 *subkey)
@@ -1222,13 +1214,13 @@ static void camellia_setup256(const unsi
 	u32 kll, klr, krl, krr;        /* left half of key */
 	u32 krll, krlr, krrl, krrr;    /* right half of key */
 	u32 il, ir, t0, t1, w0, w1;    /* temporary variables */
-	u32 kw4l, kw4r, dw, tl, tr;
+	u32 kw4l, kw4r, dw;
 	u32 subL[34];
 	u32 subR[34];
 
 	/**
 	 *  key = (kll || klr || krl || krr || krll || krlr || krrl || krrr)
-	 *  (|| is concatination)
+	 *  (|| is concatenation)
 	 */
 	GETU32(kll,  key     );
 	GETU32(klr,  key +  4);
@@ -1439,92 +1431,7 @@ static void camellia_setup256(const unsi
 	/* kw1 */
 	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
-	/* key XOR is end of F-function */
-	SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
-	SUBKEY_R(0) = subR[0] ^ subR[2];
-	SUBKEY_L(2) = subL[3];       /* round 1 */
-	SUBKEY_R(2) = subR[3];
-	SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
-	SUBKEY_R(3) = subR[2] ^ subR[4];
-	SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
-	SUBKEY_R(4) = subR[3] ^ subR[5];
-	SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
-	SUBKEY_R(5) = subR[4] ^ subR[6];
-	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
-	SUBKEY_R(6) = subR[5] ^ subR[7];
-	tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ ROL1(dw);
-	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
-	SUBKEY_R(7) = subR[6] ^ tr;
-	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
-	SUBKEY_R(8) = subR[8];
-	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
-	SUBKEY_R(9) = subR[9];
-	tl = subL[7] ^ (subR[7] & ~subR[9]);
-	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ ROL1(dw);
-	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
-	SUBKEY_R(10) = tr ^ subR[11];
-	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
-	SUBKEY_R(11) = subR[10] ^ subR[12];
-	SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
-	SUBKEY_R(12) = subR[11] ^ subR[13];
-	SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
-	SUBKEY_R(13) = subR[12] ^ subR[14];
-	SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
-	SUBKEY_R(14) = subR[13] ^ subR[15];
-	tl = subL[18] ^ (subR[18] & ~subR[16]);
-	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ ROL1(dw);
-	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
-	SUBKEY_R(15) = subR[14] ^ tr;
-	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
-	SUBKEY_R(16) = subR[16];
-	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
-	SUBKEY_R(17) = subR[17];
-	tl = subL[15] ^ (subR[15] & ~subR[17]);
-	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ ROL1(dw);
-	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
-	SUBKEY_R(18) = tr ^ subR[19];
-	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
-	SUBKEY_R(19) = subR[18] ^ subR[20];
-	SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
-	SUBKEY_R(20) = subR[19] ^ subR[21];
-	SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
-	SUBKEY_R(21) = subR[20] ^ subR[22];
-	SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
-	SUBKEY_R(22) = subR[21] ^ subR[23];
-	tl = subL[26] ^ (subR[26] & ~subR[24]);
-	dw = tl & subL[24], /* FL(kl5) */
-		tr = subR[26] ^ ROL1(dw);
-	SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
-	SUBKEY_R(23) = subR[22] ^ tr;
-	SUBKEY_L(24) = subL[24];     /* FL(kl5) */
-	SUBKEY_R(24) = subR[24];
-	SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
-	SUBKEY_R(25) = subR[25];
-	tl = subL[23] ^ (subR[23] & ~subR[25]);
-	dw = tl & subL[25], /* FLinv(kl6) */
-		tr = subR[23] ^ ROL1(dw);
-	SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
-	SUBKEY_R(26) = tr ^ subR[27];
-	SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
-	SUBKEY_R(27) = subR[26] ^ subR[28];
-	SUBKEY_L(28) = subL[27] ^ subL[29]; /* round 21 */
-	SUBKEY_R(28) = subR[27] ^ subR[29];
-	SUBKEY_L(29) = subL[28] ^ subL[30]; /* round 22 */
-	SUBKEY_R(29) = subR[28] ^ subR[30];
-	SUBKEY_L(30) = subL[29] ^ subL[31]; /* round 23 */
-	SUBKEY_R(30) = subR[29] ^ subR[31];
-	SUBKEY_L(31) = subL[30];     /* round 24 */
-	SUBKEY_R(31) = subR[30];
-	SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
-	SUBKEY_R(32) = subR[32] ^ subR[31];
-
-	/* apply the inverse of the last half of P-function */
-	camellia_setup_tail(subkey, 32);
+	camellia_setup_tail(subkey, subL, subR, 32);
 }
 
 static void camellia_setup192(const unsigned char *key, u32 *subkey)

--Boundary-00=_Uu5QH1LsGwNm2sI--
