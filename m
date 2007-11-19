From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Sun, 18 Nov 2007 20:30:16 -0800
Message-ID: <200711182030.17123.vda.linux@googlemail.com>
References: <200711131534.33521.vda.linux@googlemail.com> <200711141428.25933.vda.linux@googlemail.com> <20071118132139.GA28491@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZFRQHBCV0H6AHHJ"
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:57792 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbXKSEa0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 23:30:26 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1322217rvb
        for <linux-crypto@vger.kernel.org>; Sun, 18 Nov 2007 20:30:25 -0800 (PST)
In-Reply-To: <20071118132139.GA28491@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_ZFRQHBCV0H6AHHJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Herbert,

On Sunday 18 November 2007 05:21, Herbert Xu wrote:
> On Wed, Nov 14, 2007 at 02:28:25PM -0700, Denys Vlasenko wrote:
> > I also split this patch into two parts for easier review:
> > camellia5:
> >         adds 64-bit key setup
>
> Sorry but this still duplicates way too much code.  Also key
> setup is the slow path relatively speaking so it's even less
> justifiable.

Oh, Herbert, have heart, my camellia.c source file is smaller
than the one I started from. It's not like it's twice as big.
It's smaller already.

64-bit key setup is not just faster, it is also smaller
by ~4k, and this benefit is always there, not only when
key setup is performed.

With attached camellia7 patch, I further reduce the size
of key setup routines by reusing a bit of the code
at the end of them. 2 screenfuls of code less.

I hope it makes code duplication a bit more tolerable.

> > camellia6:
> >         unifies encrypt/decrypt routines for different key lengths.
> >         This reduces module size by ~25%, with tiny (less than 1%)
> >         speed impact.
> >         Also collapses encrypt/decrypt into more readable
> >         (visually shorter) form using macros.

And here is

camellia7:
        Move "key XOR is end of F-function" code part into
        camellia_setup_tail(), it is sufficiently similar
        between camellia_setup128 and camellia_setup256.
        This shaves off another ~1k:
          dec     hex filename
        21414    53a6 2.6.23.1.camellia6.t/crypto/camellia.o
        20518    5026 2.6.23.1.camellia7.t/crypto/camellia.o
        16355    3fe3 2.6.23.1.camellia6.t64/crypto/camellia.o
        15813    3dc5 2.6.23.1.camellia7.t64/crypto/camellia.o


At the moment I cannot run test it, try to do it ASAP.

Takamiya-san, can you review attached patch please?

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda

--Boundary-00=_ZFRQHBCV0H6AHHJ
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

--Boundary-00=_ZFRQHBCV0H6AHHJ--
