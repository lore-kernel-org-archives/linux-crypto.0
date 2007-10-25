From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/5] camellia: cleanup
Date: Thu, 25 Oct 2007 12:45:42 +0100
Message-ID: <200710251245.42880.vda.linux@googlemail.com>
References: <200710251243.58701.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mHIIHNdy7uXeeyU"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:22649 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbXJYLpy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2007 07:45:54 -0400
Received: by nf-out-0910.google.com with SMTP id g13so458880nfb
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2007 04:45:51 -0700 (PDT)
In-Reply-To: <200710251243.58701.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_mHIIHNdy7uXeeyU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> Hi Hervert,
> 
> Please review and maybe propagate upstream following patches.
> 
> camellia2.diff
>     Rename some macros to shorter names: CAMELLIA_RR8 -> ROR8,
>     making it easier to understand that it is just a right rotation,
>     nothing camellia-specific in it.
>     CAMELLIA_SUBKEY_L() -> SUBKEY_L() - just shorter.
> 
>     Move be32 <-> cpu conversions out of en/decrypt128/256 and into
>     camellia_en/decrypt - no reason to have that code duplicated twice.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_mHIIHNdy7uXeeyU
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="camellia2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="camellia2.diff"

--- linux-2.6.23.src/crypto/camellia1.c	2007-10-24 19:03:05.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia.c	2007-10-24 19:03:22.000000000 +0100
@@ -336,13 +336,13 @@ static const u32 camellia_sp4404[256] = 
 		     ^ ((u32)(pt)[3]))
 
 /* rotation right shift 1byte */
-#define CAMELLIA_RR8(x) (((x) >> 8) + ((x) << 24))
+#define ROR8(x) (((x) >> 8) + ((x) << 24))
 /* rotation left shift 1bit */
-#define CAMELLIA_RL1(x) (((x) << 1) + ((x) >> 31))
+#define ROL1(x) (((x) << 1) + ((x) >> 31))
 /* rotation left shift 1byte */
-#define CAMELLIA_RL8(x) (((x) << 8) + ((x) >> 24))
+#define ROL8(x) (((x) << 8) + ((x) >> 24))
 
-#define CAMELLIA_ROLDQ(ll, lr, rl, rr, w0, w1, bits)	\
+#define ROLDQ(ll, lr, rl, rr, w0, w1, bits)		\
     do {						\
 	w0 = ll;					\
 	ll = (ll << bits) + (lr >> (32 - bits));	\
@@ -351,7 +351,7 @@ static const u32 camellia_sp4404[256] = 
 	rr = (rr << bits) + (w0 >> (32 - bits));	\
     } while(0)
 
-#define CAMELLIA_ROLDQo32(ll, lr, rl, rr, w0, w1, bits)	\
+#define ROLDQo32(ll, lr, rl, rr, w0, w1, bits)		\
     do {						\
 	w0 = ll;					\
 	w1 = lr;					\
@@ -377,7 +377,7 @@ static const u32 camellia_sp4404[256] = 
 	   ^ camellia_sp3033[(il >> 8) & 0xff]			\
 	   ^ camellia_sp4404[il & 0xff];			\
 	yl ^= yr;						\
-	yr = CAMELLIA_RR8(yr);					\
+	yr = ROR8(yr);						\
 	yr ^= yl;						\
     } while(0)
 
@@ -393,13 +393,13 @@ static const u32 camellia_sp4404[256] = 
 	t0 &= ll;							\
 	t2 |= rr;							\
 	rl ^= t2;							\
-	lr ^= CAMELLIA_RL1(t0);						\
+	lr ^= ROL1(t0);							\
 	t3 = krl;							\
 	t1 = klr;							\
 	t3 &= rl;							\
 	t1 |= lr;							\
 	ll ^= t1;							\
-	rr ^= CAMELLIA_RL1(t3);						\
+	rr ^= ROL1(t3);							\
     } while(0)
 
 #define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
@@ -415,12 +415,12 @@ static const u32 camellia_sp4404[256] = 
 	il ^= kl;							\
 	ir ^= il ^ kr;							\
 	yl ^= ir;							\
-	yr ^= CAMELLIA_RR8(il) ^ ir;					\
+	yr ^= ROR8(il) ^ ir;						\
     } while(0)
 
 
-#define CAMELLIA_SUBKEY_L(INDEX) (subkey[(INDEX)*2])
-#define CAMELLIA_SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
+#define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
+#define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
 static void camellia_setup128(const unsigned char *key, u32 *subkey)
 {
@@ -445,35 +445,35 @@ static void camellia_setup128(const unsi
 	/* kw2 */
 	subL[1] = krl; subR[1] = krr;
 	/* rotation left shift 15bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k3 */
 	subL[4] = kll; subR[4] = klr;
 	/* k4 */
 	subL[5] = krl; subR[5] = krr;
 	/* rotation left shift 15+30bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 30);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 30);
 	/* k7 */
 	subL[10] = kll; subR[10] = klr;
 	/* k8 */
 	subL[11] = krl; subR[11] = krr;
 	/* rotation left shift 15+30+15bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k10 */
 	subL[13] = krl; subR[13] = krr;
 	/* rotation left shift 15+30+15+17 bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* kl3 */
 	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
 	subL[17] = krl; subR[17] = krr;
 	/* rotation left shift 15+30+15+17+17 bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k13 */
 	subL[18] = kll; subR[18] = klr;
 	/* k14 */
 	subL[19] = krl; subR[19] = krr;
 	/* rotation left shift 15+30+15+17+17+17 bit */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k17 */
 	subL[22] = kll; subR[22] = klr;
 	/* k18 */
@@ -503,26 +503,26 @@ static void camellia_setup128(const unsi
 	/* k1, k2 */
 	subL[2] = kll; subR[2] = klr;
 	subL[3] = krl; subR[3] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k5,k6 */
 	subL[6] = kll; subR[6] = klr;
 	subL[7] = krl; subR[7] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* kl1, kl2 */
 	subL[8] = kll; subR[8] = klr;
 	subL[9] = krl; subR[9] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k9 */
 	subL[12] = kll; subR[12] = klr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k11, k12 */
 	subL[14] = kll; subR[14] = klr;
 	subL[15] = krl; subR[15] = krr;
-	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
+	ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
 	/* k15, k16 */
 	subL[20] = kll; subR[20] = klr;
 	subL[21] = krl; subR[21] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* kw3, kw4 */
 	subL[24] = kll; subR[24] = klr;
 	subL[25] = krl; subR[25] = krr;
@@ -536,7 +536,7 @@ static void camellia_setup128(const unsi
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
 	dw = subL[1] & subL[9],
-		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
@@ -545,7 +545,7 @@ static void camellia_setup128(const unsi
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
 	dw = subL[1] & subL[17],
-		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
@@ -565,7 +565,7 @@ static void camellia_setup128(const unsi
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
 	dw = kw4l & subL[16],
-		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl3) */
+		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
@@ -574,7 +574,7 @@ static void camellia_setup128(const unsi
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
 	dw = kw4l & subL[8],
-		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl1) */
+		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
@@ -585,140 +585,104 @@ static void camellia_setup128(const unsi
 	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
 	/* key XOR is end of F-function */
-	CAMELLIA_SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
-	CAMELLIA_SUBKEY_R(0) = subR[0] ^ subR[2];
-	CAMELLIA_SUBKEY_L(2) = subL[3];       /* round 1 */
-	CAMELLIA_SUBKEY_R(2) = subR[3];
-	CAMELLIA_SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
-	CAMELLIA_SUBKEY_R(3) = subR[2] ^ subR[4];
-	CAMELLIA_SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
-	CAMELLIA_SUBKEY_R(4) = subR[3] ^ subR[5];
-	CAMELLIA_SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
-	CAMELLIA_SUBKEY_R(5) = subR[4] ^ subR[6];
-	CAMELLIA_SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
-	CAMELLIA_SUBKEY_R(6) = subR[5] ^ subR[7];
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
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
 	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
-	CAMELLIA_SUBKEY_R(7) = subR[6] ^ tr;
-	CAMELLIA_SUBKEY_L(8) = subL[8];       /* FL(kl1) */
-	CAMELLIA_SUBKEY_R(8) = subR[8];
-	CAMELLIA_SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
-	CAMELLIA_SUBKEY_R(9) = subR[9];
+		tr = subR[10] ^ ROL1(dw);
+	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
+	SUBKEY_R(7) = subR[6] ^ tr;
+	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
+	SUBKEY_R(8) = subR[8];
+	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
+	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
 	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
-	CAMELLIA_SUBKEY_R(10) = tr ^ subR[11];
-	CAMELLIA_SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
-	CAMELLIA_SUBKEY_R(11) = subR[10] ^ subR[12];
-	CAMELLIA_SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
-	CAMELLIA_SUBKEY_R(12) = subR[11] ^ subR[13];
-	CAMELLIA_SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
-	CAMELLIA_SUBKEY_R(13) = subR[12] ^ subR[14];
-	CAMELLIA_SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
-	CAMELLIA_SUBKEY_R(14) = subR[13] ^ subR[15];
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
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
 	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
-	CAMELLIA_SUBKEY_R(15) = subR[14] ^ tr;
-	CAMELLIA_SUBKEY_L(16) = subL[16];     /* FL(kl3) */
-	CAMELLIA_SUBKEY_R(16) = subR[16];
-	CAMELLIA_SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
-	CAMELLIA_SUBKEY_R(17) = subR[17];
+		tr = subR[18] ^ ROL1(dw);
+	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
+	SUBKEY_R(15) = subR[14] ^ tr;
+	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
+	SUBKEY_R(16) = subR[16];
+	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
+	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
 	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
-	CAMELLIA_SUBKEY_R(18) = tr ^ subR[19];
-	CAMELLIA_SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
-	CAMELLIA_SUBKEY_R(19) = subR[18] ^ subR[20];
-	CAMELLIA_SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
-	CAMELLIA_SUBKEY_R(20) = subR[19] ^ subR[21];
-	CAMELLIA_SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
-	CAMELLIA_SUBKEY_R(21) = subR[20] ^ subR[22];
-	CAMELLIA_SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
-	CAMELLIA_SUBKEY_R(22) = subR[21] ^ subR[23];
-	CAMELLIA_SUBKEY_L(23) = subL[22];     /* round 18 */
-	CAMELLIA_SUBKEY_R(23) = subR[22];
-	CAMELLIA_SUBKEY_L(24) = subL[24] ^ subL[23]; /* kw3 */
-	CAMELLIA_SUBKEY_R(24) = subR[24] ^ subR[23];
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
+	SUBKEY_L(23) = subL[22];     /* round 18 */
+	SUBKEY_R(23) = subR[22];
+	SUBKEY_L(24) = subL[24] ^ subL[23]; /* kw3 */
+	SUBKEY_R(24) = subR[24] ^ subR[23];
 
 	/* apply the inverse of the last half of P-function */
-	dw = CAMELLIA_SUBKEY_L(2) ^ CAMELLIA_SUBKEY_R(2),
-		dw = CAMELLIA_RL8(dw);/* round 1 */
-	CAMELLIA_SUBKEY_R(2) = CAMELLIA_SUBKEY_L(2) ^ dw,
-		CAMELLIA_SUBKEY_L(2) = dw;
-	dw = CAMELLIA_SUBKEY_L(3) ^ CAMELLIA_SUBKEY_R(3),
-		dw = CAMELLIA_RL8(dw);/* round 2 */
-	CAMELLIA_SUBKEY_R(3) = CAMELLIA_SUBKEY_L(3) ^ dw,
-		CAMELLIA_SUBKEY_L(3) = dw;
-	dw = CAMELLIA_SUBKEY_L(4) ^ CAMELLIA_SUBKEY_R(4),
-		dw = CAMELLIA_RL8(dw);/* round 3 */
-	CAMELLIA_SUBKEY_R(4) = CAMELLIA_SUBKEY_L(4) ^ dw,
-		CAMELLIA_SUBKEY_L(4) = dw;
-	dw = CAMELLIA_SUBKEY_L(5) ^ CAMELLIA_SUBKEY_R(5),
-		dw = CAMELLIA_RL8(dw);/* round 4 */
-	CAMELLIA_SUBKEY_R(5) = CAMELLIA_SUBKEY_L(5) ^ dw,
-		CAMELLIA_SUBKEY_L(5) = dw;
-	dw = CAMELLIA_SUBKEY_L(6) ^ CAMELLIA_SUBKEY_R(6),
-		dw = CAMELLIA_RL8(dw);/* round 5 */
-	CAMELLIA_SUBKEY_R(6) = CAMELLIA_SUBKEY_L(6) ^ dw,
-		CAMELLIA_SUBKEY_L(6) = dw;
-	dw = CAMELLIA_SUBKEY_L(7) ^ CAMELLIA_SUBKEY_R(7),
-		dw = CAMELLIA_RL8(dw);/* round 6 */
-	CAMELLIA_SUBKEY_R(7) = CAMELLIA_SUBKEY_L(7) ^ dw,
-		CAMELLIA_SUBKEY_L(7) = dw;
-	dw = CAMELLIA_SUBKEY_L(10) ^ CAMELLIA_SUBKEY_R(10),
-		dw = CAMELLIA_RL8(dw);/* round 7 */
-	CAMELLIA_SUBKEY_R(10) = CAMELLIA_SUBKEY_L(10) ^ dw,
-		CAMELLIA_SUBKEY_L(10) = dw;
-	dw = CAMELLIA_SUBKEY_L(11) ^ CAMELLIA_SUBKEY_R(11),
-		dw = CAMELLIA_RL8(dw);/* round 8 */
-	CAMELLIA_SUBKEY_R(11) = CAMELLIA_SUBKEY_L(11) ^ dw,
-		CAMELLIA_SUBKEY_L(11) = dw;
-	dw = CAMELLIA_SUBKEY_L(12) ^ CAMELLIA_SUBKEY_R(12),
-		dw = CAMELLIA_RL8(dw);/* round 9 */
-	CAMELLIA_SUBKEY_R(12) = CAMELLIA_SUBKEY_L(12) ^ dw,
-		CAMELLIA_SUBKEY_L(12) = dw;
-	dw = CAMELLIA_SUBKEY_L(13) ^ CAMELLIA_SUBKEY_R(13),
-		dw = CAMELLIA_RL8(dw);/* round 10 */
-	CAMELLIA_SUBKEY_R(13) = CAMELLIA_SUBKEY_L(13) ^ dw,
-		CAMELLIA_SUBKEY_L(13) = dw;
-	dw = CAMELLIA_SUBKEY_L(14) ^ CAMELLIA_SUBKEY_R(14),
-		dw = CAMELLIA_RL8(dw);/* round 11 */
-	CAMELLIA_SUBKEY_R(14) = CAMELLIA_SUBKEY_L(14) ^ dw,
-		CAMELLIA_SUBKEY_L(14) = dw;
-	dw = CAMELLIA_SUBKEY_L(15) ^ CAMELLIA_SUBKEY_R(15),
-		dw = CAMELLIA_RL8(dw);/* round 12 */
-	CAMELLIA_SUBKEY_R(15) = CAMELLIA_SUBKEY_L(15) ^ dw,
-		CAMELLIA_SUBKEY_L(15) = dw;
-	dw = CAMELLIA_SUBKEY_L(18) ^ CAMELLIA_SUBKEY_R(18),
-		dw = CAMELLIA_RL8(dw);/* round 13 */
-	CAMELLIA_SUBKEY_R(18) = CAMELLIA_SUBKEY_L(18) ^ dw,
-		CAMELLIA_SUBKEY_L(18) = dw;
-	dw = CAMELLIA_SUBKEY_L(19) ^ CAMELLIA_SUBKEY_R(19),
-		dw = CAMELLIA_RL8(dw);/* round 14 */
-	CAMELLIA_SUBKEY_R(19) = CAMELLIA_SUBKEY_L(19) ^ dw,
-		CAMELLIA_SUBKEY_L(19) = dw;
-	dw = CAMELLIA_SUBKEY_L(20) ^ CAMELLIA_SUBKEY_R(20),
-		dw = CAMELLIA_RL8(dw);/* round 15 */
-	CAMELLIA_SUBKEY_R(20) = CAMELLIA_SUBKEY_L(20) ^ dw,
-		CAMELLIA_SUBKEY_L(20) = dw;
-	dw = CAMELLIA_SUBKEY_L(21) ^ CAMELLIA_SUBKEY_R(21),
-		dw = CAMELLIA_RL8(dw);/* round 16 */
-	CAMELLIA_SUBKEY_R(21) = CAMELLIA_SUBKEY_L(21) ^ dw,
-		CAMELLIA_SUBKEY_L(21) = dw;
-	dw = CAMELLIA_SUBKEY_L(22) ^ CAMELLIA_SUBKEY_R(22),
-		dw = CAMELLIA_RL8(dw);/* round 17 */
-	CAMELLIA_SUBKEY_R(22) = CAMELLIA_SUBKEY_L(22) ^ dw,
-		CAMELLIA_SUBKEY_L(22) = dw;
-	dw = CAMELLIA_SUBKEY_L(23) ^ CAMELLIA_SUBKEY_R(23),
-		dw = CAMELLIA_RL8(dw);/* round 18 */
-	CAMELLIA_SUBKEY_R(23) = CAMELLIA_SUBKEY_L(23) ^ dw,
-		CAMELLIA_SUBKEY_L(23) = dw;
+	dw = SUBKEY_L(2) ^ SUBKEY_R(2); dw = ROL8(dw);/* round 1 */
+	SUBKEY_R(2) = SUBKEY_L(2) ^ dw; SUBKEY_L(2) = dw;
+	dw = SUBKEY_L(3) ^ SUBKEY_R(3); dw = ROL8(dw);/* round 2 */
+	SUBKEY_R(3) = SUBKEY_L(3) ^ dw; SUBKEY_L(3) = dw;
+	dw = SUBKEY_L(4) ^ SUBKEY_R(4); dw = ROL8(dw);/* round 3 */
+	SUBKEY_R(4) = SUBKEY_L(4) ^ dw; SUBKEY_L(4) = dw;
+	dw = SUBKEY_L(5) ^ SUBKEY_R(5); dw = ROL8(dw);/* round 4 */
+	SUBKEY_R(5) = SUBKEY_L(5) ^ dw; SUBKEY_L(5) = dw;
+	dw = SUBKEY_L(6) ^ SUBKEY_R(6); dw = ROL8(dw);/* round 5 */
+	SUBKEY_R(6) = SUBKEY_L(6) ^ dw; SUBKEY_L(6) = dw;
+	dw = SUBKEY_L(7) ^ SUBKEY_R(7); dw = ROL8(dw);/* round 6 */
+	SUBKEY_R(7) = SUBKEY_L(7) ^ dw; SUBKEY_L(7) = dw;
+	dw = SUBKEY_L(10) ^ SUBKEY_R(10); dw = ROL8(dw);/* round 7 */
+	SUBKEY_R(10) = SUBKEY_L(10) ^ dw; SUBKEY_L(10) = dw;
+	dw = SUBKEY_L(11) ^ SUBKEY_R(11); dw = ROL8(dw);/* round 8 */
+	SUBKEY_R(11) = SUBKEY_L(11) ^ dw; SUBKEY_L(11) = dw;
+	dw = SUBKEY_L(12) ^ SUBKEY_R(12); dw = ROL8(dw);/* round 9 */
+	SUBKEY_R(12) = SUBKEY_L(12) ^ dw; SUBKEY_L(12) = dw;
+	dw = SUBKEY_L(13) ^ SUBKEY_R(13); dw = ROL8(dw);/* round 10 */
+	SUBKEY_R(13) = SUBKEY_L(13) ^ dw; SUBKEY_L(13) = dw;
+	dw = SUBKEY_L(14) ^ SUBKEY_R(14); dw = ROL8(dw);/* round 11 */
+	SUBKEY_R(14) = SUBKEY_L(14) ^ dw; SUBKEY_L(14) = dw;
+	dw = SUBKEY_L(15) ^ SUBKEY_R(15); dw = ROL8(dw);/* round 12 */
+	SUBKEY_R(15) = SUBKEY_L(15) ^ dw; SUBKEY_L(15) = dw;
+	dw = SUBKEY_L(18) ^ SUBKEY_R(18); dw = ROL8(dw);/* round 13 */
+	SUBKEY_R(18) = SUBKEY_L(18) ^ dw; SUBKEY_L(18) = dw;
+	dw = SUBKEY_L(19) ^ SUBKEY_R(19); dw = ROL8(dw);/* round 14 */
+	SUBKEY_R(19) = SUBKEY_L(19) ^ dw; SUBKEY_L(19) = dw;
+	dw = SUBKEY_L(20) ^ SUBKEY_R(20); dw = ROL8(dw);/* round 15 */
+	SUBKEY_R(20) = SUBKEY_L(20) ^ dw; SUBKEY_L(20) = dw;
+	dw = SUBKEY_L(21) ^ SUBKEY_R(21); dw = ROL8(dw);/* round 16 */
+	SUBKEY_R(21) = SUBKEY_L(21) ^ dw; SUBKEY_L(21) = dw;
+	dw = SUBKEY_L(22) ^ SUBKEY_R(22); dw = ROL8(dw);/* round 17 */
+	SUBKEY_R(22) = SUBKEY_L(22) ^ dw; SUBKEY_L(22) = dw;
+	dw = SUBKEY_L(23) ^ SUBKEY_R(23); dw = ROL8(dw);/* round 18 */
+	SUBKEY_R(23) = SUBKEY_L(23) ^ dw; SUBKEY_L(23) = dw;
 }
 
 static void camellia_setup256(const unsigned char *key, u32 *subkey)
@@ -734,7 +698,6 @@ static void camellia_setup256(const unsi
 	 *  key = (kll || klr || krl || krr || krll || krlr || krrl || krrr)
 	 *  (|| is concatination)
 	 */
-
 	kll  = GETU32(key     );
 	klr  = GETU32(key +  4);
 	krl  = GETU32(key +  8);
@@ -749,49 +712,49 @@ static void camellia_setup256(const unsi
 	subL[0] = kll; subR[0] = klr;
 	/* kw2 */
 	subL[1] = krl; subR[1] = krr;
-	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 45);
+	ROLDQo32(kll, klr, krl, krr, w0, w1, 45);
 	/* k9 */
 	subL[12] = kll; subR[12] = klr;
 	/* k10 */
 	subL[13] = krl; subR[13] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* kl3 */
 	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
 	subL[17] = krl; subR[17] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k17 */
 	subL[22] = kll; subR[22] = klr;
 	/* k18 */
 	subL[23] = krl; subR[23] = krr;
-	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
+	ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
 	/* k23 */
 	subL[30] = kll; subR[30] = klr;
 	/* k24 */
 	subL[31] = krl; subR[31] = krr;
 
 	/* generate KR dependent subkeys */
-	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
+	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
 	/* k3 */
 	subL[4] = krll; subR[4] = krlr;
 	/* k4 */
 	subL[5] = krrl; subR[5] = krrr;
-	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
+	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
 	/* kl1 */
 	subL[8] = krll; subR[8] = krlr;
 	/* kl2 */
 	subL[9] = krrl; subR[9] = krrr;
-	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k13 */
 	subL[18] = krll; subR[18] = krlr;
 	/* k14 */
 	subL[19] = krrl; subR[19] = krrr;
-	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
+	ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
 	/* k19 */
 	subL[26] = krll; subR[26] = krlr;
 	/* k20 */
 	subL[27] = krrl; subR[27] = krrr;
-	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
+	ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
 
 	/* generate KA */
 	kll = subL[0] ^ krll; klr = subR[0] ^ krlr;
@@ -826,12 +789,12 @@ static void camellia_setup256(const unsi
 	krll ^= w0; krlr ^= w1;
 
 	/* generate KA dependent subkeys */
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k5 */
 	subL[6] = kll; subR[6] = klr;
 	/* k6 */
 	subL[7] = krl; subR[7] = krr;
-	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 30);
+	ROLDQ(kll, klr, krl, krr, w0, w1, 30);
 	/* k11 */
 	subL[14] = kll; subR[14] = klr;
 	/* k12 */
@@ -842,7 +805,7 @@ static void camellia_setup256(const unsi
 	/* kl6 */
 	subL[25] = krr; subR[25] = kll;
 	/* rotation left shift 49 from k11,k12 -> k21,k22 */
-	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 49);
+	ROLDQo32(kll, klr, krl, krr, w0, w1, 49);
 	/* k21 */
 	subL[28] = kll; subR[28] = klr;
 	/* k22 */
@@ -853,17 +816,17 @@ static void camellia_setup256(const unsi
 	subL[2] = krll; subR[2] = krlr;
 	/* k2 */
 	subL[3] = krrl; subR[3] = krrr;
-	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k7 */
 	subL[10] = krll; subR[10] = krlr;
 	/* k8 */
 	subL[11] = krrl; subR[11] = krrr;
-	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k15 */
 	subL[20] = krll; subR[20] = krlr;
 	/* k16 */
 	subL[21] = krrl; subR[21] = krrr;
-	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 51);
+	ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 51);
 	/* kw3 */
 	subL[32] = krll; subR[32] = krlr;
 	/* kw4 */
@@ -878,7 +841,7 @@ static void camellia_setup256(const unsi
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
 	dw = subL[1] & subL[9],
-		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
@@ -887,7 +850,7 @@ static void camellia_setup256(const unsi
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
 	dw = subL[1] & subL[17],
-		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
@@ -896,7 +859,7 @@ static void camellia_setup256(const unsi
 	subL[23] ^= subL[1]; subR[23] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[25];
 	dw = subL[1] & subL[25],
-		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl6) */
+		subR[1] ^= ROL1(dw); /* modified for FLinv(kl6) */
 	/* round 20 */
 	subL[27] ^= subL[1]; subR[27] ^= subR[1];
 	/* round 22 */
@@ -916,7 +879,7 @@ static void camellia_setup256(const unsi
 	subL[26] ^= kw4l; subR[26] ^= kw4r;
 	kw4l ^= kw4r & ~subR[24];
 	dw = kw4l & subL[24],
-		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl5) */
+		kw4r ^= ROL1(dw); /* modified for FL(kl5) */
 	/* round 17 */
 	subL[22] ^= kw4l; subR[22] ^= kw4r;
 	/* round 15 */
@@ -925,7 +888,7 @@ static void camellia_setup256(const unsi
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
 	dw = kw4l & subL[16],
-		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl3) */
+		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
@@ -934,7 +897,7 @@ static void camellia_setup256(const unsi
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
 	dw = kw4l & subL[8],
-		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl1) */
+		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
@@ -945,188 +908,138 @@ static void camellia_setup256(const unsi
 	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
 	/* key XOR is end of F-function */
-	CAMELLIA_SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
-	CAMELLIA_SUBKEY_R(0) = subR[0] ^ subR[2];
-	CAMELLIA_SUBKEY_L(2) = subL[3];       /* round 1 */
-	CAMELLIA_SUBKEY_R(2) = subR[3];
-	CAMELLIA_SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
-	CAMELLIA_SUBKEY_R(3) = subR[2] ^ subR[4];
-	CAMELLIA_SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
-	CAMELLIA_SUBKEY_R(4) = subR[3] ^ subR[5];
-	CAMELLIA_SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
-	CAMELLIA_SUBKEY_R(5) = subR[4] ^ subR[6];
-	CAMELLIA_SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
-	CAMELLIA_SUBKEY_R(6) = subR[5] ^ subR[7];
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
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
 	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
-	CAMELLIA_SUBKEY_R(7) = subR[6] ^ tr;
-	CAMELLIA_SUBKEY_L(8) = subL[8];       /* FL(kl1) */
-	CAMELLIA_SUBKEY_R(8) = subR[8];
-	CAMELLIA_SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
-	CAMELLIA_SUBKEY_R(9) = subR[9];
+		tr = subR[10] ^ ROL1(dw);
+	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
+	SUBKEY_R(7) = subR[6] ^ tr;
+	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
+	SUBKEY_R(8) = subR[8];
+	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
+	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
 	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
-	CAMELLIA_SUBKEY_R(10) = tr ^ subR[11];
-	CAMELLIA_SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
-	CAMELLIA_SUBKEY_R(11) = subR[10] ^ subR[12];
-	CAMELLIA_SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
-	CAMELLIA_SUBKEY_R(12) = subR[11] ^ subR[13];
-	CAMELLIA_SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
-	CAMELLIA_SUBKEY_R(13) = subR[12] ^ subR[14];
-	CAMELLIA_SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
-	CAMELLIA_SUBKEY_R(14) = subR[13] ^ subR[15];
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
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
 	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
-	CAMELLIA_SUBKEY_R(15) = subR[14] ^ tr;
-	CAMELLIA_SUBKEY_L(16) = subL[16];     /* FL(kl3) */
-	CAMELLIA_SUBKEY_R(16) = subR[16];
-	CAMELLIA_SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
-	CAMELLIA_SUBKEY_R(17) = subR[17];
+		tr = subR[18] ^ ROL1(dw);
+	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
+	SUBKEY_R(15) = subR[14] ^ tr;
+	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
+	SUBKEY_R(16) = subR[16];
+	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
+	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
 	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
-	CAMELLIA_SUBKEY_R(18) = tr ^ subR[19];
-	CAMELLIA_SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
-	CAMELLIA_SUBKEY_R(19) = subR[18] ^ subR[20];
-	CAMELLIA_SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
-	CAMELLIA_SUBKEY_R(20) = subR[19] ^ subR[21];
-	CAMELLIA_SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
-	CAMELLIA_SUBKEY_R(21) = subR[20] ^ subR[22];
-	CAMELLIA_SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
-	CAMELLIA_SUBKEY_R(22) = subR[21] ^ subR[23];
-	tl = subL[26] ^ (subR[26]
-			 & ~subR[24]);
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
+	tl = subL[26] ^ (subR[26] & ~subR[24]);
 	dw = tl & subL[24], /* FL(kl5) */
-		tr = subR[26] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
-	CAMELLIA_SUBKEY_R(23) = subR[22] ^ tr;
-	CAMELLIA_SUBKEY_L(24) = subL[24];     /* FL(kl5) */
-	CAMELLIA_SUBKEY_R(24) = subR[24];
-	CAMELLIA_SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
-	CAMELLIA_SUBKEY_R(25) = subR[25];
-	tl = subL[23] ^ (subR[23] &
-			 ~subR[25]);
+		tr = subR[26] ^ ROL1(dw);
+	SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
+	SUBKEY_R(23) = subR[22] ^ tr;
+	SUBKEY_L(24) = subL[24];     /* FL(kl5) */
+	SUBKEY_R(24) = subR[24];
+	SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
+	SUBKEY_R(25) = subR[25];
+	tl = subL[23] ^ (subR[23] & ~subR[25]);
 	dw = tl & subL[25], /* FLinv(kl6) */
-		tr = subR[23] ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
-	CAMELLIA_SUBKEY_R(26) = tr ^ subR[27];
-	CAMELLIA_SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
-	CAMELLIA_SUBKEY_R(27) = subR[26] ^ subR[28];
-	CAMELLIA_SUBKEY_L(28) = subL[27] ^ subL[29]; /* round 21 */
-	CAMELLIA_SUBKEY_R(28) = subR[27] ^ subR[29];
-	CAMELLIA_SUBKEY_L(29) = subL[28] ^ subL[30]; /* round 22 */
-	CAMELLIA_SUBKEY_R(29) = subR[28] ^ subR[30];
-	CAMELLIA_SUBKEY_L(30) = subL[29] ^ subL[31]; /* round 23 */
-	CAMELLIA_SUBKEY_R(30) = subR[29] ^ subR[31];
-	CAMELLIA_SUBKEY_L(31) = subL[30];     /* round 24 */
-	CAMELLIA_SUBKEY_R(31) = subR[30];
-	CAMELLIA_SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
-	CAMELLIA_SUBKEY_R(32) = subR[32] ^ subR[31];
+		tr = subR[23] ^ ROL1(dw);
+	SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
+	SUBKEY_R(26) = tr ^ subR[27];
+	SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
+	SUBKEY_R(27) = subR[26] ^ subR[28];
+	SUBKEY_L(28) = subL[27] ^ subL[29]; /* round 21 */
+	SUBKEY_R(28) = subR[27] ^ subR[29];
+	SUBKEY_L(29) = subL[28] ^ subL[30]; /* round 22 */
+	SUBKEY_R(29) = subR[28] ^ subR[30];
+	SUBKEY_L(30) = subL[29] ^ subL[31]; /* round 23 */
+	SUBKEY_R(30) = subR[29] ^ subR[31];
+	SUBKEY_L(31) = subL[30];     /* round 24 */
+	SUBKEY_R(31) = subR[30];
+	SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
+	SUBKEY_R(32) = subR[32] ^ subR[31];
 
 	/* apply the inverse of the last half of P-function */
-	dw = CAMELLIA_SUBKEY_L(2) ^ CAMELLIA_SUBKEY_R(2),
-		dw = CAMELLIA_RL8(dw);/* round 1 */
-	CAMELLIA_SUBKEY_R(2) = CAMELLIA_SUBKEY_L(2) ^ dw,
-		CAMELLIA_SUBKEY_L(2) = dw;
-	dw = CAMELLIA_SUBKEY_L(3) ^ CAMELLIA_SUBKEY_R(3),
-		dw = CAMELLIA_RL8(dw);/* round 2 */
-	CAMELLIA_SUBKEY_R(3) = CAMELLIA_SUBKEY_L(3) ^ dw,
-		CAMELLIA_SUBKEY_L(3) = dw;
-	dw = CAMELLIA_SUBKEY_L(4) ^ CAMELLIA_SUBKEY_R(4),
-		dw = CAMELLIA_RL8(dw);/* round 3 */
-	CAMELLIA_SUBKEY_R(4) = CAMELLIA_SUBKEY_L(4) ^ dw,
-		CAMELLIA_SUBKEY_L(4) = dw;
-	dw = CAMELLIA_SUBKEY_L(5) ^ CAMELLIA_SUBKEY_R(5),
-		dw = CAMELLIA_RL8(dw);/* round 4 */
-	CAMELLIA_SUBKEY_R(5) = CAMELLIA_SUBKEY_L(5) ^ dw,
-	CAMELLIA_SUBKEY_L(5) = dw;
-	dw = CAMELLIA_SUBKEY_L(6) ^ CAMELLIA_SUBKEY_R(6),
-		dw = CAMELLIA_RL8(dw);/* round 5 */
-	CAMELLIA_SUBKEY_R(6) = CAMELLIA_SUBKEY_L(6) ^ dw,
-		CAMELLIA_SUBKEY_L(6) = dw;
-	dw = CAMELLIA_SUBKEY_L(7) ^ CAMELLIA_SUBKEY_R(7),
-		dw = CAMELLIA_RL8(dw);/* round 6 */
-	CAMELLIA_SUBKEY_R(7) = CAMELLIA_SUBKEY_L(7) ^ dw,
-		CAMELLIA_SUBKEY_L(7) = dw;
-	dw = CAMELLIA_SUBKEY_L(10) ^ CAMELLIA_SUBKEY_R(10),
-		dw = CAMELLIA_RL8(dw);/* round 7 */
-	CAMELLIA_SUBKEY_R(10) = CAMELLIA_SUBKEY_L(10) ^ dw,
-		CAMELLIA_SUBKEY_L(10) = dw;
-	dw = CAMELLIA_SUBKEY_L(11) ^ CAMELLIA_SUBKEY_R(11),
-	    dw = CAMELLIA_RL8(dw);/* round 8 */
-	CAMELLIA_SUBKEY_R(11) = CAMELLIA_SUBKEY_L(11) ^ dw,
-		CAMELLIA_SUBKEY_L(11) = dw;
-	dw = CAMELLIA_SUBKEY_L(12) ^ CAMELLIA_SUBKEY_R(12),
-		dw = CAMELLIA_RL8(dw);/* round 9 */
-	CAMELLIA_SUBKEY_R(12) = CAMELLIA_SUBKEY_L(12) ^ dw,
-		CAMELLIA_SUBKEY_L(12) = dw;
-	dw = CAMELLIA_SUBKEY_L(13) ^ CAMELLIA_SUBKEY_R(13),
-		dw = CAMELLIA_RL8(dw);/* round 10 */
-	CAMELLIA_SUBKEY_R(13) = CAMELLIA_SUBKEY_L(13) ^ dw,
-		CAMELLIA_SUBKEY_L(13) = dw;
-	dw = CAMELLIA_SUBKEY_L(14) ^ CAMELLIA_SUBKEY_R(14),
-		dw = CAMELLIA_RL8(dw);/* round 11 */
-	CAMELLIA_SUBKEY_R(14) = CAMELLIA_SUBKEY_L(14) ^ dw,
-		CAMELLIA_SUBKEY_L(14) = dw;
-	dw = CAMELLIA_SUBKEY_L(15) ^ CAMELLIA_SUBKEY_R(15),
-		dw = CAMELLIA_RL8(dw);/* round 12 */
-	CAMELLIA_SUBKEY_R(15) = CAMELLIA_SUBKEY_L(15) ^ dw,
-		CAMELLIA_SUBKEY_L(15) = dw;
-	dw = CAMELLIA_SUBKEY_L(18) ^ CAMELLIA_SUBKEY_R(18),
-		dw = CAMELLIA_RL8(dw);/* round 13 */
-	CAMELLIA_SUBKEY_R(18) = CAMELLIA_SUBKEY_L(18) ^ dw,
-		CAMELLIA_SUBKEY_L(18) = dw;
-	dw = CAMELLIA_SUBKEY_L(19) ^ CAMELLIA_SUBKEY_R(19),
-		dw = CAMELLIA_RL8(dw);/* round 14 */
-	CAMELLIA_SUBKEY_R(19) = CAMELLIA_SUBKEY_L(19) ^ dw,
-		CAMELLIA_SUBKEY_L(19) = dw;
-	dw = CAMELLIA_SUBKEY_L(20) ^ CAMELLIA_SUBKEY_R(20),
-		dw = CAMELLIA_RL8(dw);/* round 15 */
-	CAMELLIA_SUBKEY_R(20) = CAMELLIA_SUBKEY_L(20) ^ dw,
-		CAMELLIA_SUBKEY_L(20) = dw;
-	dw = CAMELLIA_SUBKEY_L(21) ^ CAMELLIA_SUBKEY_R(21),
-		dw = CAMELLIA_RL8(dw);/* round 16 */
-	CAMELLIA_SUBKEY_R(21) = CAMELLIA_SUBKEY_L(21) ^ dw,
-		CAMELLIA_SUBKEY_L(21) = dw;
-	dw = CAMELLIA_SUBKEY_L(22) ^ CAMELLIA_SUBKEY_R(22),
-		dw = CAMELLIA_RL8(dw);/* round 17 */
-	CAMELLIA_SUBKEY_R(22) = CAMELLIA_SUBKEY_L(22) ^ dw,
-		CAMELLIA_SUBKEY_L(22) = dw;
-	dw = CAMELLIA_SUBKEY_L(23) ^ CAMELLIA_SUBKEY_R(23),
-		dw = CAMELLIA_RL8(dw);/* round 18 */
-	CAMELLIA_SUBKEY_R(23) = CAMELLIA_SUBKEY_L(23) ^ dw,
-		CAMELLIA_SUBKEY_L(23) = dw;
-	dw = CAMELLIA_SUBKEY_L(26) ^ CAMELLIA_SUBKEY_R(26),
-		dw = CAMELLIA_RL8(dw);/* round 19 */
-	CAMELLIA_SUBKEY_R(26) = CAMELLIA_SUBKEY_L(26) ^ dw,
-		CAMELLIA_SUBKEY_L(26) = dw;
-	dw = CAMELLIA_SUBKEY_L(27) ^ CAMELLIA_SUBKEY_R(27),
-		dw = CAMELLIA_RL8(dw);/* round 20 */
-	CAMELLIA_SUBKEY_R(27) = CAMELLIA_SUBKEY_L(27) ^ dw,
-		CAMELLIA_SUBKEY_L(27) = dw;
-	dw = CAMELLIA_SUBKEY_L(28) ^ CAMELLIA_SUBKEY_R(28),
-		dw = CAMELLIA_RL8(dw);/* round 21 */
-	CAMELLIA_SUBKEY_R(28) = CAMELLIA_SUBKEY_L(28) ^ dw,
-		CAMELLIA_SUBKEY_L(28) = dw;
-	dw = CAMELLIA_SUBKEY_L(29) ^ CAMELLIA_SUBKEY_R(29),
-		dw = CAMELLIA_RL8(dw);/* round 22 */
-	CAMELLIA_SUBKEY_R(29) = CAMELLIA_SUBKEY_L(29) ^ dw,
-		CAMELLIA_SUBKEY_L(29) = dw;
-	dw = CAMELLIA_SUBKEY_L(30) ^ CAMELLIA_SUBKEY_R(30),
-		dw = CAMELLIA_RL8(dw);/* round 23 */
-	CAMELLIA_SUBKEY_R(30) = CAMELLIA_SUBKEY_L(30) ^ dw,
-		CAMELLIA_SUBKEY_L(30) = dw;
-	dw = CAMELLIA_SUBKEY_L(31) ^ CAMELLIA_SUBKEY_R(31),
-		dw = CAMELLIA_RL8(dw);/* round 24 */
-	CAMELLIA_SUBKEY_R(31) = CAMELLIA_SUBKEY_L(31) ^ dw,
-		CAMELLIA_SUBKEY_L(31) = dw;
+	dw = SUBKEY_L(2) ^ SUBKEY_R(2); dw = ROL8(dw);/* round 1 */
+	SUBKEY_R(2) = SUBKEY_L(2) ^ dw; SUBKEY_L(2) = dw;
+	dw = SUBKEY_L(3) ^ SUBKEY_R(3); dw = ROL8(dw);/* round 2 */
+	SUBKEY_R(3) = SUBKEY_L(3) ^ dw; SUBKEY_L(3) = dw;
+	dw = SUBKEY_L(4) ^ SUBKEY_R(4); dw = ROL8(dw);/* round 3 */
+	SUBKEY_R(4) = SUBKEY_L(4) ^ dw; SUBKEY_L(4) = dw;
+	dw = SUBKEY_L(5) ^ SUBKEY_R(5); dw = ROL8(dw);/* round 4 */
+	SUBKEY_R(5) = SUBKEY_L(5) ^ dw; SUBKEY_L(5) = dw;
+	dw = SUBKEY_L(6) ^ SUBKEY_R(6); dw = ROL8(dw);/* round 5 */
+	SUBKEY_R(6) = SUBKEY_L(6) ^ dw; SUBKEY_L(6) = dw;
+	dw = SUBKEY_L(7) ^ SUBKEY_R(7); dw = ROL8(dw);/* round 6 */
+	SUBKEY_R(7) = SUBKEY_L(7) ^ dw; SUBKEY_L(7) = dw;
+	dw = SUBKEY_L(10) ^ SUBKEY_R(10); dw = ROL8(dw);/* round 7 */
+	SUBKEY_R(10) = SUBKEY_L(10) ^ dw; SUBKEY_L(10) = dw;
+	dw = SUBKEY_L(11) ^ SUBKEY_R(11); dw = ROL8(dw);/* round 8 */
+	SUBKEY_R(11) = SUBKEY_L(11) ^ dw; SUBKEY_L(11) = dw;
+	dw = SUBKEY_L(12) ^ SUBKEY_R(12); dw = ROL8(dw);/* round 9 */
+	SUBKEY_R(12) = SUBKEY_L(12) ^ dw; SUBKEY_L(12) = dw;
+	dw = SUBKEY_L(13) ^ SUBKEY_R(13); dw = ROL8(dw);/* round 10 */
+	SUBKEY_R(13) = SUBKEY_L(13) ^ dw; SUBKEY_L(13) = dw;
+	dw = SUBKEY_L(14) ^ SUBKEY_R(14); dw = ROL8(dw);/* round 11 */
+	SUBKEY_R(14) = SUBKEY_L(14) ^ dw; SUBKEY_L(14) = dw;
+	dw = SUBKEY_L(15) ^ SUBKEY_R(15); dw = ROL8(dw);/* round 12 */
+	SUBKEY_R(15) = SUBKEY_L(15) ^ dw; SUBKEY_L(15) = dw;
+	dw = SUBKEY_L(18) ^ SUBKEY_R(18); dw = ROL8(dw);/* round 13 */
+	SUBKEY_R(18) = SUBKEY_L(18) ^ dw; SUBKEY_L(18) = dw;
+	dw = SUBKEY_L(19) ^ SUBKEY_R(19); dw = ROL8(dw);/* round 14 */
+	SUBKEY_R(19) = SUBKEY_L(19) ^ dw; SUBKEY_L(19) = dw;
+	dw = SUBKEY_L(20) ^ SUBKEY_R(20); dw = ROL8(dw);/* round 15 */
+	SUBKEY_R(20) = SUBKEY_L(20) ^ dw; SUBKEY_L(20) = dw;
+	dw = SUBKEY_L(21) ^ SUBKEY_R(21); dw = ROL8(dw);/* round 16 */
+	SUBKEY_R(21) = SUBKEY_L(21) ^ dw; SUBKEY_L(21) = dw;
+	dw = SUBKEY_L(22) ^ SUBKEY_R(22); dw = ROL8(dw);/* round 17 */
+	SUBKEY_R(22) = SUBKEY_L(22) ^ dw; SUBKEY_L(22) = dw;
+	dw = SUBKEY_L(23) ^ SUBKEY_R(23); dw = ROL8(dw);/* round 18 */
+	SUBKEY_R(23) = SUBKEY_L(23) ^ dw; SUBKEY_L(23) = dw;
+	dw = SUBKEY_L(26) ^ SUBKEY_R(26); dw = ROL8(dw);/* round 19 */
+	SUBKEY_R(26) = SUBKEY_L(26) ^ dw; SUBKEY_L(26) = dw;
+	dw = SUBKEY_L(27) ^ SUBKEY_R(27); dw = ROL8(dw);/* round 20 */
+	SUBKEY_R(27) = SUBKEY_L(27) ^ dw; SUBKEY_L(27) = dw;
+	dw = SUBKEY_L(28) ^ SUBKEY_R(28); dw = ROL8(dw);/* round 21 */
+	SUBKEY_R(28) = SUBKEY_L(28) ^ dw; SUBKEY_L(28) = dw;
+	dw = SUBKEY_L(29) ^ SUBKEY_R(29); dw = ROL8(dw);/* round 22 */
+	SUBKEY_R(29) = SUBKEY_L(29) ^ dw; SUBKEY_L(29) = dw;
+	dw = SUBKEY_L(30) ^ SUBKEY_R(30); dw = ROL8(dw);/* round 23 */
+	SUBKEY_R(30) = SUBKEY_L(30) ^ dw; SUBKEY_L(30) = dw;
+	dw = SUBKEY_L(31) ^ SUBKEY_R(31); dw = ROL8(dw);/* round 24 */
+	SUBKEY_R(31) = SUBKEY_L(31) ^ dw; SUBKEY_L(31) = dw;
 }
 
 static void camellia_setup192(const unsigned char *key, u32 *subkey)
@@ -1145,424 +1058,400 @@ static void camellia_setup192(const unsi
 }
 
 
-static void camellia_encrypt128(const u32 *subkey, __be32 *io_text)
+static void camellia_encrypt128(const u32 *subkey, u32 *io_text)
 {
-	u32 il,ir,t0,t1;               /* temporary valiables */
+	u32 il,ir,t0,t1;               /* temporary variables */
 
 	u32 io[4];
 
-	io[0] = be32_to_cpu(io_text[0]);
-	io[1] = be32_to_cpu(io_text[1]);
-	io[2] = be32_to_cpu(io_text[2]);
-	io[3] = be32_to_cpu(io_text[3]);
-
 	/* pre whitening but absorb kw2 */
-	io[0] ^= CAMELLIA_SUBKEY_L(0);
-	io[1] ^= CAMELLIA_SUBKEY_R(0);
+	io[0] = io_text[0] ^ SUBKEY_L(0);
+	io[1] = io_text[1] ^ SUBKEY_R(0);
+	io[2] = io_text[2];
+	io[3] = io_text[3];
 
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(2),CAMELLIA_SUBKEY_R(2),
+			 SUBKEY_L(2),SUBKEY_R(2),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(3),CAMELLIA_SUBKEY_R(3),
+			 SUBKEY_L(3),SUBKEY_R(3),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(4),CAMELLIA_SUBKEY_R(4),
+			 SUBKEY_L(4),SUBKEY_R(4),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(5),CAMELLIA_SUBKEY_R(5),
+			 SUBKEY_L(5),SUBKEY_R(5),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(6),CAMELLIA_SUBKEY_R(6),
+			 SUBKEY_L(6),SUBKEY_R(6),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(7),CAMELLIA_SUBKEY_R(7),
+			 SUBKEY_L(7),SUBKEY_R(7),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(8),CAMELLIA_SUBKEY_R(8),
-		     CAMELLIA_SUBKEY_L(9),CAMELLIA_SUBKEY_R(9),
+		     SUBKEY_L(8),SUBKEY_R(8),
+		     SUBKEY_L(9),SUBKEY_R(9),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(10),CAMELLIA_SUBKEY_R(10),
+			 SUBKEY_L(10),SUBKEY_R(10),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(11),CAMELLIA_SUBKEY_R(11),
+			 SUBKEY_L(11),SUBKEY_R(11),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(12),CAMELLIA_SUBKEY_R(12),
+			 SUBKEY_L(12),SUBKEY_R(12),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(13),CAMELLIA_SUBKEY_R(13),
+			 SUBKEY_L(13),SUBKEY_R(13),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(14),CAMELLIA_SUBKEY_R(14),
+			 SUBKEY_L(14),SUBKEY_R(14),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(15),CAMELLIA_SUBKEY_R(15),
+			 SUBKEY_L(15),SUBKEY_R(15),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(16),CAMELLIA_SUBKEY_R(16),
-		     CAMELLIA_SUBKEY_L(17),CAMELLIA_SUBKEY_R(17),
+		     SUBKEY_L(16),SUBKEY_R(16),
+		     SUBKEY_L(17),SUBKEY_R(17),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(18),CAMELLIA_SUBKEY_R(18),
+			 SUBKEY_L(18),SUBKEY_R(18),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(19),CAMELLIA_SUBKEY_R(19),
+			 SUBKEY_L(19),SUBKEY_R(19),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(20),CAMELLIA_SUBKEY_R(20),
+			 SUBKEY_L(20),SUBKEY_R(20),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(21),CAMELLIA_SUBKEY_R(21),
+			 SUBKEY_L(21),SUBKEY_R(21),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(22),CAMELLIA_SUBKEY_R(22),
+			 SUBKEY_L(22),SUBKEY_R(22),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(23),CAMELLIA_SUBKEY_R(23),
+			 SUBKEY_L(23),SUBKEY_R(23),
 			 io[0],io[1],il,ir,t0,t1);
 
 	/* post whitening but kw4 */
-	io[2] ^= CAMELLIA_SUBKEY_L(24);
-	io[3] ^= CAMELLIA_SUBKEY_R(24);
-
-	io_text[0] = cpu_to_be32(io[2]);
-	io_text[1] = cpu_to_be32(io[3]);
-	io_text[2] = cpu_to_be32(io[0]);
-	io_text[3] = cpu_to_be32(io[1]);
+	io_text[0] = io[2] ^ SUBKEY_L(24);
+	io_text[1] = io[3] ^ SUBKEY_R(24);
+	io_text[2] = io[0];
+	io_text[3] = io[1];
 }
 
-static void camellia_decrypt128(const u32 *subkey, __be32 *io_text)
+static void camellia_decrypt128(const u32 *subkey, u32 *io_text)
 {
-	u32 il,ir,t0,t1;               /* temporary valiables */
+	u32 il,ir,t0,t1;               /* temporary variables */
 
 	u32 io[4];
 
-	io[0] = be32_to_cpu(io_text[0]);
-	io[1] = be32_to_cpu(io_text[1]);
-	io[2] = be32_to_cpu(io_text[2]);
-	io[3] = be32_to_cpu(io_text[3]);
-
 	/* pre whitening but absorb kw2 */
-	io[0] ^= CAMELLIA_SUBKEY_L(24);
-	io[1] ^= CAMELLIA_SUBKEY_R(24);
+	io[0] = io_text[0] ^ SUBKEY_L(24);
+	io[1] = io_text[1] ^ SUBKEY_R(24);
+	io[2] = io_text[2];
+	io[3] = io_text[3];
 
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(23),CAMELLIA_SUBKEY_R(23),
+			 SUBKEY_L(23),SUBKEY_R(23),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(22),CAMELLIA_SUBKEY_R(22),
+			 SUBKEY_L(22),SUBKEY_R(22),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(21),CAMELLIA_SUBKEY_R(21),
+			 SUBKEY_L(21),SUBKEY_R(21),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(20),CAMELLIA_SUBKEY_R(20),
+			 SUBKEY_L(20),SUBKEY_R(20),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(19),CAMELLIA_SUBKEY_R(19),
+			 SUBKEY_L(19),SUBKEY_R(19),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(18),CAMELLIA_SUBKEY_R(18),
+			 SUBKEY_L(18),SUBKEY_R(18),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(17),CAMELLIA_SUBKEY_R(17),
-		     CAMELLIA_SUBKEY_L(16),CAMELLIA_SUBKEY_R(16),
+		     SUBKEY_L(17),SUBKEY_R(17),
+		     SUBKEY_L(16),SUBKEY_R(16),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(15),CAMELLIA_SUBKEY_R(15),
+			 SUBKEY_L(15),SUBKEY_R(15),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(14),CAMELLIA_SUBKEY_R(14),
+			 SUBKEY_L(14),SUBKEY_R(14),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(13),CAMELLIA_SUBKEY_R(13),
+			 SUBKEY_L(13),SUBKEY_R(13),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(12),CAMELLIA_SUBKEY_R(12),
+			 SUBKEY_L(12),SUBKEY_R(12),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(11),CAMELLIA_SUBKEY_R(11),
+			 SUBKEY_L(11),SUBKEY_R(11),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(10),CAMELLIA_SUBKEY_R(10),
+			 SUBKEY_L(10),SUBKEY_R(10),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(9),CAMELLIA_SUBKEY_R(9),
-		     CAMELLIA_SUBKEY_L(8),CAMELLIA_SUBKEY_R(8),
+		     SUBKEY_L(9),SUBKEY_R(9),
+		     SUBKEY_L(8),SUBKEY_R(8),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(7),CAMELLIA_SUBKEY_R(7),
+			 SUBKEY_L(7),SUBKEY_R(7),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(6),CAMELLIA_SUBKEY_R(6),
+			 SUBKEY_L(6),SUBKEY_R(6),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(5),CAMELLIA_SUBKEY_R(5),
+			 SUBKEY_L(5),SUBKEY_R(5),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(4),CAMELLIA_SUBKEY_R(4),
+			 SUBKEY_L(4),SUBKEY_R(4),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(3),CAMELLIA_SUBKEY_R(3),
+			 SUBKEY_L(3),SUBKEY_R(3),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(2),CAMELLIA_SUBKEY_R(2),
+			 SUBKEY_L(2),SUBKEY_R(2),
 			 io[0],io[1],il,ir,t0,t1);
 
 	/* post whitening but kw4 */
-	io[2] ^= CAMELLIA_SUBKEY_L(0);
-	io[3] ^= CAMELLIA_SUBKEY_R(0);
-
-	io_text[0] = cpu_to_be32(io[2]);
-	io_text[1] = cpu_to_be32(io[3]);
-	io_text[2] = cpu_to_be32(io[0]);
-	io_text[3] = cpu_to_be32(io[1]);
+	io_text[0] = io[2] ^ SUBKEY_L(0);
+	io_text[1] = io[3] ^ SUBKEY_R(0);
+	io_text[2] = io[0];
+	io_text[3] = io[1];
 }
 
-static void camellia_encrypt256(const u32 *subkey, __be32 *io_text)
+static void camellia_encrypt256(const u32 *subkey, u32 *io_text)
 {
-	u32 il,ir,t0,t1;           /* temporary valiables */
+	u32 il,ir,t0,t1;           /* temporary variables */
 
 	u32 io[4];
 
-	io[0] = be32_to_cpu(io_text[0]);
-	io[1] = be32_to_cpu(io_text[1]);
-	io[2] = be32_to_cpu(io_text[2]);
-	io[3] = be32_to_cpu(io_text[3]);
-
 	/* pre whitening but absorb kw2 */
-	io[0] ^= CAMELLIA_SUBKEY_L(0);
-	io[1] ^= CAMELLIA_SUBKEY_R(0);
+	io[0] = io_text[0] ^ SUBKEY_L(0);
+	io[1] = io_text[1] ^ SUBKEY_R(0);
+	io[2] = io_text[2];
+	io[3] = io_text[3];
 
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(2),CAMELLIA_SUBKEY_R(2),
+			 SUBKEY_L(2),SUBKEY_R(2),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(3),CAMELLIA_SUBKEY_R(3),
+			 SUBKEY_L(3),SUBKEY_R(3),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(4),CAMELLIA_SUBKEY_R(4),
+			 SUBKEY_L(4),SUBKEY_R(4),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(5),CAMELLIA_SUBKEY_R(5),
+			 SUBKEY_L(5),SUBKEY_R(5),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(6),CAMELLIA_SUBKEY_R(6),
+			 SUBKEY_L(6),SUBKEY_R(6),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(7),CAMELLIA_SUBKEY_R(7),
+			 SUBKEY_L(7),SUBKEY_R(7),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(8),CAMELLIA_SUBKEY_R(8),
-		     CAMELLIA_SUBKEY_L(9),CAMELLIA_SUBKEY_R(9),
+		     SUBKEY_L(8),SUBKEY_R(8),
+		     SUBKEY_L(9),SUBKEY_R(9),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(10),CAMELLIA_SUBKEY_R(10),
+			 SUBKEY_L(10),SUBKEY_R(10),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(11),CAMELLIA_SUBKEY_R(11),
+			 SUBKEY_L(11),SUBKEY_R(11),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(12),CAMELLIA_SUBKEY_R(12),
+			 SUBKEY_L(12),SUBKEY_R(12),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(13),CAMELLIA_SUBKEY_R(13),
+			 SUBKEY_L(13),SUBKEY_R(13),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(14),CAMELLIA_SUBKEY_R(14),
+			 SUBKEY_L(14),SUBKEY_R(14),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(15),CAMELLIA_SUBKEY_R(15),
+			 SUBKEY_L(15),SUBKEY_R(15),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(16),CAMELLIA_SUBKEY_R(16),
-		     CAMELLIA_SUBKEY_L(17),CAMELLIA_SUBKEY_R(17),
+		     SUBKEY_L(16),SUBKEY_R(16),
+		     SUBKEY_L(17),SUBKEY_R(17),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(18),CAMELLIA_SUBKEY_R(18),
+			 SUBKEY_L(18),SUBKEY_R(18),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(19),CAMELLIA_SUBKEY_R(19),
+			 SUBKEY_L(19),SUBKEY_R(19),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(20),CAMELLIA_SUBKEY_R(20),
+			 SUBKEY_L(20),SUBKEY_R(20),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(21),CAMELLIA_SUBKEY_R(21),
+			 SUBKEY_L(21),SUBKEY_R(21),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(22),CAMELLIA_SUBKEY_R(22),
+			 SUBKEY_L(22),SUBKEY_R(22),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(23),CAMELLIA_SUBKEY_R(23),
+			 SUBKEY_L(23),SUBKEY_R(23),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(24),CAMELLIA_SUBKEY_R(24),
-		     CAMELLIA_SUBKEY_L(25),CAMELLIA_SUBKEY_R(25),
+		     SUBKEY_L(24),SUBKEY_R(24),
+		     SUBKEY_L(25),SUBKEY_R(25),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(26),CAMELLIA_SUBKEY_R(26),
+			 SUBKEY_L(26),SUBKEY_R(26),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(27),CAMELLIA_SUBKEY_R(27),
+			 SUBKEY_L(27),SUBKEY_R(27),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(28),CAMELLIA_SUBKEY_R(28),
+			 SUBKEY_L(28),SUBKEY_R(28),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(29),CAMELLIA_SUBKEY_R(29),
+			 SUBKEY_L(29),SUBKEY_R(29),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(30),CAMELLIA_SUBKEY_R(30),
+			 SUBKEY_L(30),SUBKEY_R(30),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(31),CAMELLIA_SUBKEY_R(31),
+			 SUBKEY_L(31),SUBKEY_R(31),
 			 io[0],io[1],il,ir,t0,t1);
 
 	/* post whitening but kw4 */
-	io[2] ^= CAMELLIA_SUBKEY_L(32);
-	io[3] ^= CAMELLIA_SUBKEY_R(32);
-
-	io_text[0] = cpu_to_be32(io[2]);
-	io_text[1] = cpu_to_be32(io[3]);
-	io_text[2] = cpu_to_be32(io[0]);
-	io_text[3] = cpu_to_be32(io[1]);
+	io_text[0] = io[2] ^ SUBKEY_L(32);
+	io_text[1] = io[3] ^ SUBKEY_R(32);
+	io_text[2] = io[0];
+	io_text[3] = io[1];
 }
 
-static void camellia_decrypt256(const u32 *subkey, __be32 *io_text)
+static void camellia_decrypt256(const u32 *subkey, u32 *io_text)
 {
-	u32 il,ir,t0,t1;           /* temporary valiables */
+	u32 il,ir,t0,t1;           /* temporary variables */
 
 	u32 io[4];
 
-	io[0] = be32_to_cpu(io_text[0]);
-	io[1] = be32_to_cpu(io_text[1]);
-	io[2] = be32_to_cpu(io_text[2]);
-	io[3] = be32_to_cpu(io_text[3]);
-
 	/* pre whitening but absorb kw2 */
-	io[0] ^= CAMELLIA_SUBKEY_L(32);
-	io[1] ^= CAMELLIA_SUBKEY_R(32);
+	io[0] = io_text[0] ^ SUBKEY_L(32);
+	io[1] = io_text[1] ^ SUBKEY_R(32);
+	io[2] = io_text[2];
+	io[3] = io_text[3];
 
 	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(31),CAMELLIA_SUBKEY_R(31),
+			 SUBKEY_L(31),SUBKEY_R(31),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(30),CAMELLIA_SUBKEY_R(30),
+			 SUBKEY_L(30),SUBKEY_R(30),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(29),CAMELLIA_SUBKEY_R(29),
+			 SUBKEY_L(29),SUBKEY_R(29),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(28),CAMELLIA_SUBKEY_R(28),
+			 SUBKEY_L(28),SUBKEY_R(28),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(27),CAMELLIA_SUBKEY_R(27),
+			 SUBKEY_L(27),SUBKEY_R(27),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(26),CAMELLIA_SUBKEY_R(26),
+			 SUBKEY_L(26),SUBKEY_R(26),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(25),CAMELLIA_SUBKEY_R(25),
-		     CAMELLIA_SUBKEY_L(24),CAMELLIA_SUBKEY_R(24),
+		     SUBKEY_L(25),SUBKEY_R(25),
+		     SUBKEY_L(24),SUBKEY_R(24),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(23),CAMELLIA_SUBKEY_R(23),
+			 SUBKEY_L(23),SUBKEY_R(23),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(22),CAMELLIA_SUBKEY_R(22),
+			 SUBKEY_L(22),SUBKEY_R(22),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(21),CAMELLIA_SUBKEY_R(21),
+			 SUBKEY_L(21),SUBKEY_R(21),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(20),CAMELLIA_SUBKEY_R(20),
+			 SUBKEY_L(20),SUBKEY_R(20),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(19),CAMELLIA_SUBKEY_R(19),
+			 SUBKEY_L(19),SUBKEY_R(19),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(18),CAMELLIA_SUBKEY_R(18),
+			 SUBKEY_L(18),SUBKEY_R(18),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(17),CAMELLIA_SUBKEY_R(17),
-		     CAMELLIA_SUBKEY_L(16),CAMELLIA_SUBKEY_R(16),
+		     SUBKEY_L(17),SUBKEY_R(17),
+		     SUBKEY_L(16),SUBKEY_R(16),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(15),CAMELLIA_SUBKEY_R(15),
+			 SUBKEY_L(15),SUBKEY_R(15),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(14),CAMELLIA_SUBKEY_R(14),
+			 SUBKEY_L(14),SUBKEY_R(14),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(13),CAMELLIA_SUBKEY_R(13),
+			 SUBKEY_L(13),SUBKEY_R(13),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(12),CAMELLIA_SUBKEY_R(12),
+			 SUBKEY_L(12),SUBKEY_R(12),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(11),CAMELLIA_SUBKEY_R(11),
+			 SUBKEY_L(11),SUBKEY_R(11),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(10),CAMELLIA_SUBKEY_R(10),
+			 SUBKEY_L(10),SUBKEY_R(10),
 			 io[0],io[1],il,ir,t0,t1);
 
 	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     CAMELLIA_SUBKEY_L(9),CAMELLIA_SUBKEY_R(9),
-		     CAMELLIA_SUBKEY_L(8),CAMELLIA_SUBKEY_R(8),
+		     SUBKEY_L(9),SUBKEY_R(9),
+		     SUBKEY_L(8),SUBKEY_R(8),
 		     t0,t1,il,ir);
 
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(7),CAMELLIA_SUBKEY_R(7),
+			 SUBKEY_L(7),SUBKEY_R(7),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(6),CAMELLIA_SUBKEY_R(6),
+			 SUBKEY_L(6),SUBKEY_R(6),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(5),CAMELLIA_SUBKEY_R(5),
+			 SUBKEY_L(5),SUBKEY_R(5),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(4),CAMELLIA_SUBKEY_R(4),
+			 SUBKEY_L(4),SUBKEY_R(4),
 			 io[0],io[1],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[0],io[1],
-			 CAMELLIA_SUBKEY_L(3),CAMELLIA_SUBKEY_R(3),
+			 SUBKEY_L(3),SUBKEY_R(3),
 			 io[2],io[3],il,ir,t0,t1);
 	CAMELLIA_ROUNDSM(io[2],io[3],
-			 CAMELLIA_SUBKEY_L(2),CAMELLIA_SUBKEY_R(2),
+			 SUBKEY_L(2),SUBKEY_R(2),
 			 io[0],io[1],il,ir,t0,t1);
 
 	/* post whitening but kw4 */
-	io[2] ^= CAMELLIA_SUBKEY_L(0);
-	io[3] ^= CAMELLIA_SUBKEY_R(0);
-
-	io_text[0] = cpu_to_be32(io[2]);
-	io_text[1] = cpu_to_be32(io[3]);
-	io_text[2] = cpu_to_be32(io[0]);
-	io_text[3] = cpu_to_be32(io[1]);
+	io_text[0] = io[2] ^ SUBKEY_L(0);
+	io_text[1] = io[3] ^ SUBKEY_R(0);
+	io_text[2] = io[0];
+	io_text[3] = io[1];
 }
 
 
@@ -1607,9 +1496,12 @@ static void camellia_encrypt(struct cryp
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
 
-	__be32 tmp[4];
+	u32 tmp[4];
 
-	memcpy(tmp, src, CAMELLIA_BLOCK_SIZE);
+	tmp[0] = be32_to_cpu(src[0]);
+	tmp[1] = be32_to_cpu(src[1]);
+	tmp[2] = be32_to_cpu(src[2]);
+	tmp[3] = be32_to_cpu(src[3]);
 
 	switch (cctx->key_length) {
 	case 16:
@@ -1622,7 +1514,10 @@ static void camellia_encrypt(struct cryp
 		break;
 	}
 
-	memcpy(dst, tmp, CAMELLIA_BLOCK_SIZE);
+	dst[0] = cpu_to_be32(tmp[0]);
+	dst[1] = cpu_to_be32(tmp[1]);
+	dst[2] = cpu_to_be32(tmp[2]);
+	dst[3] = cpu_to_be32(tmp[3]);
 }
 
 static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -1631,9 +1526,12 @@ static void camellia_decrypt(struct cryp
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
 
-	__be32 tmp[4];
+	u32 tmp[4];
 
-	memcpy(tmp, src, CAMELLIA_BLOCK_SIZE);
+	tmp[0] = be32_to_cpu(src[0]);
+	tmp[1] = be32_to_cpu(src[1]);
+	tmp[2] = be32_to_cpu(src[2]);
+	tmp[3] = be32_to_cpu(src[3]);
 
 	switch (cctx->key_length) {
 	case 16:
@@ -1646,7 +1544,10 @@ static void camellia_decrypt(struct cryp
 		break;
 	}
 
-	memcpy(dst, tmp, CAMELLIA_BLOCK_SIZE);
+	dst[0] = cpu_to_be32(tmp[0]);
+	dst[1] = cpu_to_be32(tmp[1]);
+	dst[2] = cpu_to_be32(tmp[2]);
+	dst[3] = cpu_to_be32(tmp[3]);
 }
 
 static struct crypto_alg camellia_alg = {

--Boundary-00=_mHIIHNdy7uXeeyU--
