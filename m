From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 5/5] camellia: 64-bit optimization
Date: Thu, 22 Nov 2007 14:44:53 -0800
Message-ID: <200711221444.53688.vda.linux@googlemail.com>
References: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lZgRHj16c74QVjh"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:49035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXKVWqB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:46:01 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2481199rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:46:01 -0800 (PST)
In-Reply-To: <200711221441.45027.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_lZgRHj16c74QVjh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> camellia9:
>         Adds 64-bit key setup, it is used if BITS_PER_LONG is 64.
>         30% faster key setup and 1k (7%) smaller module on amd64.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com> 
--
vda

--Boundary-00=_lZgRHj16c74QVjh
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia9.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia9.diff"

diff -urpN cryptodev-2.6.camellia8/crypto/camellia.c cryptodev-2.6.camellia9/crypto/camellia.c
--- cryptodev-2.6.camellia8/crypto/camellia.c	2007-11-22 14:19:54.000000000 -0800
+++ cryptodev-2.6.camellia9/crypto/camellia.c	2007-11-22 14:22:22.000000000 -0800
@@ -304,7 +304,6 @@ static const u32 camellia_sp4404[256] = 
 	0xe3e300e3,0xf4f400f4,0xc7c700c7,0x9e9e009e,
 };
 
-
 #define CAMELLIA_MIN_KEY_SIZE        16
 #define CAMELLIA_MAX_KEY_SIZE        32
 #define CAMELLIA_BLOCK_SIZE          16
@@ -317,6 +316,494 @@ static const u32 camellia_sp4404[256] = 
  */
 
 
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
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#else
+#define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2])
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2])
+#endif
+
+static void camellia_setup_tail(u64 *subkey, u64 *sub, int max)
+{
+	u64 kw4;
+	u64 t;
+	u32 dw;
+	int i;
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
+static void camellia_setup128(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;
+	u64 i, w;
+	u64 sub[26];
+
+	/**
+	 *  k == kl || kr (|| is concatenation)
+	 */
+	GETU64(kl, key     );
+	GETU64(kr, key +  8);
+
+	/* generate KL dependent subkeys */
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
+	camellia_setup_tail(subkey, sub, 24);
+}
+
+static void camellia_setup256(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;        /* left half of key */
+	u64 krl, krr;      /* right half of key */
+	u64 i, w;          /* temporary variables */
+	u64 sub[34];
+
+	/**
+	 *  key = (kl || kr || krl || krr)
+	 *  (|| is concatenation)
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
+	camellia_setup_tail(subkey, sub, 32);
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
+
 /* key constants */
 
 #define CAMELLIA_SIGMA1L (0xA09E667FL)
@@ -859,6 +1346,12 @@ static void camellia_setup192(const unsi
 	camellia_setup256(kk, subkey);
 }
 
+typedef u32 key_element;
+typedef const u32 const_key_element;
+
+#endif /* 32/64-bit key setup versions */
+
+
 
 /*
  * Encrypt/decrypt
@@ -896,7 +1389,7 @@ static void camellia_setup192(const unsi
     } while(0)
 
 /* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
-static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
+static void camellia_do_encrypt(const_key_element *subkey, u32 *io, unsigned max)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
@@ -951,7 +1444,7 @@ static void camellia_do_encrypt(const u3
 	/* NB: io[0],[1] should be swapped with [2],[3] by caller! */
 }
 
-static void camellia_do_decrypt(const u32 *subkey, u32 *io, unsigned i)
+static void camellia_do_decrypt(const_key_element *subkey, u32 *io, unsigned i)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
@@ -1009,7 +1502,7 @@ static void camellia_do_decrypt(const u3
 
 struct camellia_ctx {
 	int key_length;
-	u32 key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(u32)];
+	key_element key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(key_element)];
 };
 
 static int

--Boundary-00=_lZgRHj16c74QVjh--
