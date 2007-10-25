From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 1/5] camellia: cleanup
Date: Thu, 25 Oct 2007 12:45:04 +0100
Message-ID: <200710251245.04132.vda.linux@googlemail.com>
References: <200710251243.58701.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AHIIHoa1QedVz2q"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:22800 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbXJYLpO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2007 07:45:14 -0400
Received: by nf-out-0910.google.com with SMTP id g13so458745nfb
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2007 04:45:11 -0700 (PDT)
In-Reply-To: <200710251243.58701.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_AHIIHoa1QedVz2q
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> Hi Hervert,
> 
> Please review and maybe propagate upstream following patches.
> 
> camellia1.diff:
>     Move code blocks around so that related pieces are closer together:
>     e.g. CAMELLIA_ROUNDSM macro does not need to be separated
>     from the rest of the code by huge array of constants.
> 
>     Remove unused macros (COPY4WORD, SWAP4WORD, XOR4WORD[2])
> 
>     Drop SUBL(), SUBR() macros which only obscure things.
>     Same for CAMELLIA_SP1110() macro and KEY_TABLE_TYPE typedef.
> 
>     Remove useless comments:
>     /* encryption */ -- well it's obvious enough already!
>     void camellia_encrypt128(...)
> 
>     Combine swap with copying at the beginning/end of encrypt/decrypt.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_AHIIHoa1QedVz2q
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="camellia1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="camellia1.diff"

--- linux-2.6.23.src/crypto/camellia0.c	2007-10-24 19:01:54.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia.c	2007-10-24 19:03:05.000000000 +0100
@@ -36,176 +36,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-
-#define CAMELLIA_MIN_KEY_SIZE        16
-#define CAMELLIA_MAX_KEY_SIZE        32
-#define CAMELLIA_BLOCK_SIZE 16
-#define CAMELLIA_TABLE_BYTE_LEN 272
-#define CAMELLIA_TABLE_WORD_LEN (CAMELLIA_TABLE_BYTE_LEN / 4)
-
-typedef u32 KEY_TABLE_TYPE[CAMELLIA_TABLE_WORD_LEN];
-
-
-/* key constants */
-
-#define CAMELLIA_SIGMA1L (0xA09E667FL)
-#define CAMELLIA_SIGMA1R (0x3BCC908BL)
-#define CAMELLIA_SIGMA2L (0xB67AE858L)
-#define CAMELLIA_SIGMA2R (0x4CAA73B2L)
-#define CAMELLIA_SIGMA3L (0xC6EF372FL)
-#define CAMELLIA_SIGMA3R (0xE94F82BEL)
-#define CAMELLIA_SIGMA4L (0x54FF53A5L)
-#define CAMELLIA_SIGMA4R (0xF1D36F1CL)
-#define CAMELLIA_SIGMA5L (0x10E527FAL)
-#define CAMELLIA_SIGMA5R (0xDE682D1DL)
-#define CAMELLIA_SIGMA6L (0xB05688C2L)
-#define CAMELLIA_SIGMA6R (0xB3E6C1FDL)
-
-struct camellia_ctx {
-	int key_length;
-	KEY_TABLE_TYPE key_table;
-};
-
-
-/*
- *  macros
- */
-
-
-# define GETU32(pt) (((u32)(pt)[0] << 24)	\
-		     ^ ((u32)(pt)[1] << 16)	\
-		     ^ ((u32)(pt)[2] <<  8)	\
-		     ^ ((u32)(pt)[3]))
-
-#define COPY4WORD(dst, src)			\
-    do {					\
-	(dst)[0]=(src)[0];			\
-	(dst)[1]=(src)[1];			\
-	(dst)[2]=(src)[2];			\
-	(dst)[3]=(src)[3];			\
-    }while(0)
-
-#define SWAP4WORD(word)				\
-    do {					\
-	CAMELLIA_SWAP4((word)[0]);		\
-	CAMELLIA_SWAP4((word)[1]);		\
-	CAMELLIA_SWAP4((word)[2]);		\
-	CAMELLIA_SWAP4((word)[3]);		\
-    }while(0)
-
-#define XOR4WORD(a, b)/* a = a ^ b */		\
-    do {					\
-	(a)[0]^=(b)[0];				\
-	(a)[1]^=(b)[1];				\
-	(a)[2]^=(b)[2];				\
-	(a)[3]^=(b)[3];				\
-    }while(0)
-
-#define XOR4WORD2(a, b, c)/* a = b ^ c */	\
-    do {					\
-	(a)[0]=(b)[0]^(c)[0];			\
-	(a)[1]=(b)[1]^(c)[1];			\
-	(a)[2]=(b)[2]^(c)[2];			\
-	(a)[3]=(b)[3]^(c)[3];			\
-    }while(0)
-
-#define CAMELLIA_SUBKEY_L(INDEX) (subkey[(INDEX)*2])
-#define CAMELLIA_SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
-
-/* rotation right shift 1byte */
-#define CAMELLIA_RR8(x) (((x) >> 8) + ((x) << 24))
-/* rotation left shift 1bit */
-#define CAMELLIA_RL1(x) (((x) << 1) + ((x) >> 31))
-/* rotation left shift 1byte */
-#define CAMELLIA_RL8(x) (((x) << 8) + ((x) >> 24))
-
-#define CAMELLIA_ROLDQ(ll, lr, rl, rr, w0, w1, bits)	\
-    do {						\
-	w0 = ll;					\
-	ll = (ll << bits) + (lr >> (32 - bits));	\
-	lr = (lr << bits) + (rl >> (32 - bits));	\
-	rl = (rl << bits) + (rr >> (32 - bits));	\
-	rr = (rr << bits) + (w0 >> (32 - bits));	\
-    } while(0)
-
-#define CAMELLIA_ROLDQo32(ll, lr, rl, rr, w0, w1, bits)	\
-    do {						\
-	w0 = ll;					\
-	w1 = lr;					\
-	ll = (lr << (bits - 32)) + (rl >> (64 - bits));	\
-	lr = (rl << (bits - 32)) + (rr >> (64 - bits));	\
-	rl = (rr << (bits - 32)) + (w0 >> (64 - bits));	\
-	rr = (w0 << (bits - 32)) + (w1 >> (64 - bits));	\
-    } while(0)
-
-#define CAMELLIA_SP1110(INDEX) (camellia_sp1110[(INDEX)])
-#define CAMELLIA_SP0222(INDEX) (camellia_sp0222[(INDEX)])
-#define CAMELLIA_SP3033(INDEX) (camellia_sp3033[(INDEX)])
-#define CAMELLIA_SP4404(INDEX) (camellia_sp4404[(INDEX)])
-
-#define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
-    do {							\
-	il = xl ^ kl;						\
-	ir = xr ^ kr;						\
-	t0 = il >> 16;						\
-	t1 = ir >> 16;						\
-	yl = CAMELLIA_SP1110(ir & 0xff)				\
-	    ^ CAMELLIA_SP0222((t1 >> 8) & 0xff)			\
-	    ^ CAMELLIA_SP3033(t1 & 0xff)			\
-	    ^ CAMELLIA_SP4404((ir >> 8) & 0xff);		\
-	yr = CAMELLIA_SP1110((t0 >> 8) & 0xff)			\
-	    ^ CAMELLIA_SP0222(t0 & 0xff)			\
-	    ^ CAMELLIA_SP3033((il >> 8) & 0xff)			\
-	    ^ CAMELLIA_SP4404(il & 0xff);			\
-	yl ^= yr;						\
-	yr = CAMELLIA_RR8(yr);					\
-	yr ^= yl;						\
-    } while(0)
-
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
-	lr ^= CAMELLIA_RL1(t0);						\
-	t3 = krl;							\
-	t1 = klr;							\
-	t3 &= rl;							\
-	t1 |= lr;							\
-	ll ^= t1;							\
-	rr ^= CAMELLIA_RL1(t3);						\
-    } while(0)
-
-#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
-    do {								\
-	ir =  CAMELLIA_SP1110(xr & 0xff);				\
-	il =  CAMELLIA_SP1110((xl>>24) & 0xff);				\
-	ir ^= CAMELLIA_SP0222((xr>>24) & 0xff);				\
-	il ^= CAMELLIA_SP0222((xl>>16) & 0xff);				\
-	ir ^= CAMELLIA_SP3033((xr>>16) & 0xff);				\
-	il ^= CAMELLIA_SP3033((xl>>8) & 0xff);				\
-	ir ^= CAMELLIA_SP4404((xr>>8) & 0xff);				\
-	il ^= CAMELLIA_SP4404(xl & 0xff);				\
-	il ^= kl;							\
-	ir ^= il ^ kr;							\
-	yl ^= ir;							\
-	yr ^= CAMELLIA_RR8(il) ^ ir;					\
-    } while(0)
-
-/**
- * Stuff related to the Camellia key schedule
- */
-#define SUBL(x) subL[(x)]
-#define SUBR(x) subR[(x)]
-
-
 static const u32 camellia_sp1110[256] = {
 	0x70707000,0x82828200,0x2c2c2c00,0xececec00,
 	0xb3b3b300,0x27272700,0xc0c0c000,0xe5e5e500,
@@ -475,6 +305,122 @@ static const u32 camellia_sp4404[256] = 
 };
 
 
+#define CAMELLIA_MIN_KEY_SIZE        16
+#define CAMELLIA_MAX_KEY_SIZE        32
+#define CAMELLIA_BLOCK_SIZE          16
+#define CAMELLIA_TABLE_BYTE_LEN     272
+
+
+/* key constants */
+
+#define CAMELLIA_SIGMA1L (0xA09E667FL)
+#define CAMELLIA_SIGMA1R (0x3BCC908BL)
+#define CAMELLIA_SIGMA2L (0xB67AE858L)
+#define CAMELLIA_SIGMA2R (0x4CAA73B2L)
+#define CAMELLIA_SIGMA3L (0xC6EF372FL)
+#define CAMELLIA_SIGMA3R (0xE94F82BEL)
+#define CAMELLIA_SIGMA4L (0x54FF53A5L)
+#define CAMELLIA_SIGMA4R (0xF1D36F1CL)
+#define CAMELLIA_SIGMA5L (0x10E527FAL)
+#define CAMELLIA_SIGMA5R (0xDE682D1DL)
+#define CAMELLIA_SIGMA6L (0xB05688C2L)
+#define CAMELLIA_SIGMA6R (0xB3E6C1FDL)
+
+/*
+ *  macros
+ */
+
+# define GETU32(pt) (((u32)(pt)[0] << 24)	\
+		     ^ ((u32)(pt)[1] << 16)	\
+		     ^ ((u32)(pt)[2] <<  8)	\
+		     ^ ((u32)(pt)[3]))
+
+/* rotation right shift 1byte */
+#define CAMELLIA_RR8(x) (((x) >> 8) + ((x) << 24))
+/* rotation left shift 1bit */
+#define CAMELLIA_RL1(x) (((x) << 1) + ((x) >> 31))
+/* rotation left shift 1byte */
+#define CAMELLIA_RL8(x) (((x) << 8) + ((x) >> 24))
+
+#define CAMELLIA_ROLDQ(ll, lr, rl, rr, w0, w1, bits)	\
+    do {						\
+	w0 = ll;					\
+	ll = (ll << bits) + (lr >> (32 - bits));	\
+	lr = (lr << bits) + (rl >> (32 - bits));	\
+	rl = (rl << bits) + (rr >> (32 - bits));	\
+	rr = (rr << bits) + (w0 >> (32 - bits));	\
+    } while(0)
+
+#define CAMELLIA_ROLDQo32(ll, lr, rl, rr, w0, w1, bits)	\
+    do {						\
+	w0 = ll;					\
+	w1 = lr;					\
+	ll = (lr << (bits - 32)) + (rl >> (64 - bits));	\
+	lr = (rl << (bits - 32)) + (rr >> (64 - bits));	\
+	rl = (rr << (bits - 32)) + (w0 >> (64 - bits));	\
+	rr = (w0 << (bits - 32)) + (w1 >> (64 - bits));	\
+    } while(0)
+
+
+#define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
+    do {							\
+	il = xl ^ kl;						\
+	ir = xr ^ kr;						\
+	t0 = il >> 16;						\
+	t1 = ir >> 16;						\
+	yl = camellia_sp1110[ir & 0xff]				\
+	   ^ camellia_sp0222[(t1 >> 8) & 0xff]			\
+	   ^ camellia_sp3033[t1 & 0xff]				\
+	   ^ camellia_sp4404[(ir >> 8) & 0xff];			\
+	yr = camellia_sp1110[(t0 >> 8) & 0xff]			\
+	   ^ camellia_sp0222[t0 & 0xff]				\
+	   ^ camellia_sp3033[(il >> 8) & 0xff]			\
+	   ^ camellia_sp4404[il & 0xff];			\
+	yl ^= yr;						\
+	yr = CAMELLIA_RR8(yr);					\
+	yr ^= yl;						\
+    } while(0)
+
+
+/*
+ * for speed up
+ *
+ */
+#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
+    do {								\
+	t0 = kll;							\
+	t2 = krr;							\
+	t0 &= ll;							\
+	t2 |= rr;							\
+	rl ^= t2;							\
+	lr ^= CAMELLIA_RL1(t0);						\
+	t3 = krl;							\
+	t1 = klr;							\
+	t3 &= rl;							\
+	t1 |= lr;							\
+	ll ^= t1;							\
+	rr ^= CAMELLIA_RL1(t3);						\
+    } while(0)
+
+#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
+    do {								\
+	ir =  camellia_sp1110[xr & 0xff];				\
+	il =  camellia_sp1110[(xl>>24) & 0xff];				\
+	ir ^= camellia_sp0222[(xr>>24) & 0xff];				\
+	il ^= camellia_sp0222[(xl>>16) & 0xff];				\
+	ir ^= camellia_sp3033[(xr>>16) & 0xff];				\
+	il ^= camellia_sp3033[(xl>>8) & 0xff];				\
+	ir ^= camellia_sp4404[(xr>>8) & 0xff];				\
+	il ^= camellia_sp4404[xl & 0xff];				\
+	il ^= kl;							\
+	ir ^= il ^ kr;							\
+	yl ^= ir;							\
+	yr ^= CAMELLIA_RR8(il) ^ ir;					\
+    } while(0)
+
+
+#define CAMELLIA_SUBKEY_L(INDEX) (subkey[(INDEX)*2])
+#define CAMELLIA_SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
 static void camellia_setup128(const unsigned char *key, u32 *subkey)
 {
@@ -495,47 +441,47 @@ static void camellia_setup128(const unsi
 	 * generate KL dependent subkeys
 	 */
 	/* kw1 */
-	SUBL(0) = kll; SUBR(0) = klr;
+	subL[0] = kll; subR[0] = klr;
 	/* kw2 */
-	SUBL(1) = krl; SUBR(1) = krr;
+	subL[1] = krl; subR[1] = krr;
 	/* rotation left shift 15bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k3 */
-	SUBL(4) = kll; SUBR(4) = klr;
+	subL[4] = kll; subR[4] = klr;
 	/* k4 */
-	SUBL(5) = krl; SUBR(5) = krr;
+	subL[5] = krl; subR[5] = krr;
 	/* rotation left shift 15+30bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 30);
 	/* k7 */
-	SUBL(10) = kll; SUBR(10) = klr;
+	subL[10] = kll; subR[10] = klr;
 	/* k8 */
-	SUBL(11) = krl; SUBR(11) = krr;
+	subL[11] = krl; subR[11] = krr;
 	/* rotation left shift 15+30+15bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k10 */
-	SUBL(13) = krl; SUBR(13) = krr;
+	subL[13] = krl; subR[13] = krr;
 	/* rotation left shift 15+30+15+17 bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* kl3 */
-	SUBL(16) = kll; SUBR(16) = klr;
+	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
-	SUBL(17) = krl; SUBR(17) = krr;
+	subL[17] = krl; subR[17] = krr;
 	/* rotation left shift 15+30+15+17+17 bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k13 */
-	SUBL(18) = kll; SUBR(18) = klr;
+	subL[18] = kll; subR[18] = klr;
 	/* k14 */
-	SUBL(19) = krl; SUBR(19) = krr;
+	subL[19] = krl; subR[19] = krr;
 	/* rotation left shift 15+30+15+17+17+17 bit */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k17 */
-	SUBL(22) = kll; SUBR(22) = klr;
+	subL[22] = kll; subR[22] = klr;
 	/* k18 */
-	SUBL(23) = krl; SUBR(23) = krr;
+	subL[23] = krl; subR[23] = krr;
 
 	/* generate KA */
-	kll = SUBL(0); klr = SUBR(0);
-	krl = SUBL(1); krr = SUBR(1);
+	kll = subL[0]; klr = subR[0];
+	krl = subL[1]; krr = subR[1];
 	CAMELLIA_F(kll, klr,
 		   CAMELLIA_SIGMA1L, CAMELLIA_SIGMA1R,
 		   w0, w1, il, ir, t0, t1);
@@ -555,152 +501,150 @@ static void camellia_setup128(const unsi
 
 	/* generate KA dependent subkeys */
 	/* k1, k2 */
-	SUBL(2) = kll; SUBR(2) = klr;
-	SUBL(3) = krl; SUBR(3) = krr;
+	subL[2] = kll; subR[2] = klr;
+	subL[3] = krl; subR[3] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k5,k6 */
-	SUBL(6) = kll; SUBR(6) = klr;
-	SUBL(7) = krl; SUBR(7) = krr;
+	subL[6] = kll; subR[6] = klr;
+	subL[7] = krl; subR[7] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* kl1, kl2 */
-	SUBL(8) = kll; SUBR(8) = klr;
-	SUBL(9) = krl; SUBR(9) = krr;
+	subL[8] = kll; subR[8] = klr;
+	subL[9] = krl; subR[9] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k9 */
-	SUBL(12) = kll; SUBR(12) = klr;
+	subL[12] = kll; subR[12] = klr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k11, k12 */
-	SUBL(14) = kll; SUBR(14) = klr;
-	SUBL(15) = krl; SUBR(15) = krr;
+	subL[14] = kll; subR[14] = klr;
+	subL[15] = krl; subR[15] = krr;
 	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
 	/* k15, k16 */
-	SUBL(20) = kll; SUBR(20) = klr;
-	SUBL(21) = krl; SUBR(21) = krr;
+	subL[20] = kll; subR[20] = klr;
+	subL[21] = krl; subR[21] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* kw3, kw4 */
-	SUBL(24) = kll; SUBR(24) = klr;
-	SUBL(25) = krl; SUBR(25) = krr;
-
+	subL[24] = kll; subR[24] = klr;
+	subL[25] = krl; subR[25] = krr;
 
 	/* absorb kw2 to other subkeys */
 	/* round 2 */
-	SUBL(3) ^= SUBL(1); SUBR(3) ^= SUBR(1);
+	subL[3] ^= subL[1]; subR[3] ^= subR[1];
 	/* round 4 */
-	SUBL(5) ^= SUBL(1); SUBR(5) ^= SUBR(1);
+	subL[5] ^= subL[1]; subR[5] ^= subR[1];
 	/* round 6 */
-	SUBL(7) ^= SUBL(1); SUBR(7) ^= SUBR(1);
-	SUBL(1) ^= SUBR(1) & ~SUBR(9);
-	dw = SUBL(1) & SUBL(9),
-		SUBR(1) ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
+	subL[7] ^= subL[1]; subR[7] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[9];
+	dw = subL[1] & subL[9],
+		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
 	/* round 8 */
-	SUBL(11) ^= SUBL(1); SUBR(11) ^= SUBR(1);
+	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
-	SUBL(13) ^= SUBL(1); SUBR(13) ^= SUBR(1);
+	subL[13] ^= subL[1]; subR[13] ^= subR[1];
 	/* round 12 */
-	SUBL(15) ^= SUBL(1); SUBR(15) ^= SUBR(1);
-	SUBL(1) ^= SUBR(1) & ~SUBR(17);
-	dw = SUBL(1) & SUBL(17),
-		SUBR(1) ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
+	subL[15] ^= subL[1]; subR[15] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[17];
+	dw = subL[1] & subL[17],
+		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
 	/* round 14 */
-	SUBL(19) ^= SUBL(1); SUBR(19) ^= SUBR(1);
+	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
-	SUBL(21) ^= SUBL(1); SUBR(21) ^= SUBR(1);
+	subL[21] ^= subL[1]; subR[21] ^= subR[1];
 	/* round 18 */
-	SUBL(23) ^= SUBL(1); SUBR(23) ^= SUBR(1);
+	subL[23] ^= subL[1]; subR[23] ^= subR[1];
 	/* kw3 */
-	SUBL(24) ^= SUBL(1); SUBR(24) ^= SUBR(1);
+	subL[24] ^= subL[1]; subR[24] ^= subR[1];
 
 	/* absorb kw4 to other subkeys */
-	kw4l = SUBL(25); kw4r = SUBR(25);
+	kw4l = subL[25]; kw4r = subR[25];
 	/* round 17 */
-	SUBL(22) ^= kw4l; SUBR(22) ^= kw4r;
+	subL[22] ^= kw4l; subR[22] ^= kw4r;
 	/* round 15 */
-	SUBL(20) ^= kw4l; SUBR(20) ^= kw4r;
+	subL[20] ^= kw4l; subR[20] ^= kw4r;
 	/* round 13 */
-	SUBL(18) ^= kw4l; SUBR(18) ^= kw4r;
-	kw4l ^= kw4r & ~SUBR(16);
-	dw = kw4l & SUBL(16),
+	subL[18] ^= kw4l; subR[18] ^= kw4r;
+	kw4l ^= kw4r & ~subR[16];
+	dw = kw4l & subL[16],
 		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl3) */
 	/* round 11 */
-	SUBL(14) ^= kw4l; SUBR(14) ^= kw4r;
+	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
-	SUBL(12) ^= kw4l; SUBR(12) ^= kw4r;
+	subL[12] ^= kw4l; subR[12] ^= kw4r;
 	/* round 7 */
-	SUBL(10) ^= kw4l; SUBR(10) ^= kw4r;
-	kw4l ^= kw4r & ~SUBR(8);
-	dw = kw4l & SUBL(8),
+	subL[10] ^= kw4l; subR[10] ^= kw4r;
+	kw4l ^= kw4r & ~subR[8];
+	dw = kw4l & subL[8],
 		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl1) */
 	/* round 5 */
-	SUBL(6) ^= kw4l; SUBR(6) ^= kw4r;
+	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
-	SUBL(4) ^= kw4l; SUBR(4) ^= kw4r;
+	subL[4] ^= kw4l; subR[4] ^= kw4r;
 	/* round 1 */
-	SUBL(2) ^= kw4l; SUBR(2) ^= kw4r;
+	subL[2] ^= kw4l; subR[2] ^= kw4r;
 	/* kw1 */
-	SUBL(0) ^= kw4l; SUBR(0) ^= kw4r;
-
+	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
 	/* key XOR is end of F-function */
-	CAMELLIA_SUBKEY_L(0) = SUBL(0) ^ SUBL(2);/* kw1 */
-	CAMELLIA_SUBKEY_R(0) = SUBR(0) ^ SUBR(2);
-	CAMELLIA_SUBKEY_L(2) = SUBL(3);       /* round 1 */
-	CAMELLIA_SUBKEY_R(2) = SUBR(3);
-	CAMELLIA_SUBKEY_L(3) = SUBL(2) ^ SUBL(4); /* round 2 */
-	CAMELLIA_SUBKEY_R(3) = SUBR(2) ^ SUBR(4);
-	CAMELLIA_SUBKEY_L(4) = SUBL(3) ^ SUBL(5); /* round 3 */
-	CAMELLIA_SUBKEY_R(4) = SUBR(3) ^ SUBR(5);
-	CAMELLIA_SUBKEY_L(5) = SUBL(4) ^ SUBL(6); /* round 4 */
-	CAMELLIA_SUBKEY_R(5) = SUBR(4) ^ SUBR(6);
-	CAMELLIA_SUBKEY_L(6) = SUBL(5) ^ SUBL(7); /* round 5 */
-	CAMELLIA_SUBKEY_R(6) = SUBR(5) ^ SUBR(7);
-	tl = SUBL(10) ^ (SUBR(10) & ~SUBR(8));
-	dw = tl & SUBL(8),  /* FL(kl1) */
-		tr = SUBR(10) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(7) = SUBL(6) ^ tl; /* round 6 */
-	CAMELLIA_SUBKEY_R(7) = SUBR(6) ^ tr;
-	CAMELLIA_SUBKEY_L(8) = SUBL(8);       /* FL(kl1) */
-	CAMELLIA_SUBKEY_R(8) = SUBR(8);
-	CAMELLIA_SUBKEY_L(9) = SUBL(9);       /* FLinv(kl2) */
-	CAMELLIA_SUBKEY_R(9) = SUBR(9);
-	tl = SUBL(7) ^ (SUBR(7) & ~SUBR(9));
-	dw = tl & SUBL(9),  /* FLinv(kl2) */
-		tr = SUBR(7) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(10) = tl ^ SUBL(11); /* round 7 */
-	CAMELLIA_SUBKEY_R(10) = tr ^ SUBR(11);
-	CAMELLIA_SUBKEY_L(11) = SUBL(10) ^ SUBL(12); /* round 8 */
-	CAMELLIA_SUBKEY_R(11) = SUBR(10) ^ SUBR(12);
-	CAMELLIA_SUBKEY_L(12) = SUBL(11) ^ SUBL(13); /* round 9 */
-	CAMELLIA_SUBKEY_R(12) = SUBR(11) ^ SUBR(13);
-	CAMELLIA_SUBKEY_L(13) = SUBL(12) ^ SUBL(14); /* round 10 */
-	CAMELLIA_SUBKEY_R(13) = SUBR(12) ^ SUBR(14);
-	CAMELLIA_SUBKEY_L(14) = SUBL(13) ^ SUBL(15); /* round 11 */
-	CAMELLIA_SUBKEY_R(14) = SUBR(13) ^ SUBR(15);
-	tl = SUBL(18) ^ (SUBR(18) & ~SUBR(16));
-	dw = tl & SUBL(16), /* FL(kl3) */
-		tr = SUBR(18) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(15) = SUBL(14) ^ tl; /* round 12 */
-	CAMELLIA_SUBKEY_R(15) = SUBR(14) ^ tr;
-	CAMELLIA_SUBKEY_L(16) = SUBL(16);     /* FL(kl3) */
-	CAMELLIA_SUBKEY_R(16) = SUBR(16);
-	CAMELLIA_SUBKEY_L(17) = SUBL(17);     /* FLinv(kl4) */
-	CAMELLIA_SUBKEY_R(17) = SUBR(17);
-	tl = SUBL(15) ^ (SUBR(15) & ~SUBR(17));
-	dw = tl & SUBL(17), /* FLinv(kl4) */
-		tr = SUBR(15) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(18) = tl ^ SUBL(19); /* round 13 */
-	CAMELLIA_SUBKEY_R(18) = tr ^ SUBR(19);
-	CAMELLIA_SUBKEY_L(19) = SUBL(18) ^ SUBL(20); /* round 14 */
-	CAMELLIA_SUBKEY_R(19) = SUBR(18) ^ SUBR(20);
-	CAMELLIA_SUBKEY_L(20) = SUBL(19) ^ SUBL(21); /* round 15 */
-	CAMELLIA_SUBKEY_R(20) = SUBR(19) ^ SUBR(21);
-	CAMELLIA_SUBKEY_L(21) = SUBL(20) ^ SUBL(22); /* round 16 */
-	CAMELLIA_SUBKEY_R(21) = SUBR(20) ^ SUBR(22);
-	CAMELLIA_SUBKEY_L(22) = SUBL(21) ^ SUBL(23); /* round 17 */
-	CAMELLIA_SUBKEY_R(22) = SUBR(21) ^ SUBR(23);
-	CAMELLIA_SUBKEY_L(23) = SUBL(22);     /* round 18 */
-	CAMELLIA_SUBKEY_R(23) = SUBR(22);
-	CAMELLIA_SUBKEY_L(24) = SUBL(24) ^ SUBL(23); /* kw3 */
-	CAMELLIA_SUBKEY_R(24) = SUBR(24) ^ SUBR(23);
+	CAMELLIA_SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
+	CAMELLIA_SUBKEY_R(0) = subR[0] ^ subR[2];
+	CAMELLIA_SUBKEY_L(2) = subL[3];       /* round 1 */
+	CAMELLIA_SUBKEY_R(2) = subR[3];
+	CAMELLIA_SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
+	CAMELLIA_SUBKEY_R(3) = subR[2] ^ subR[4];
+	CAMELLIA_SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
+	CAMELLIA_SUBKEY_R(4) = subR[3] ^ subR[5];
+	CAMELLIA_SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
+	CAMELLIA_SUBKEY_R(5) = subR[4] ^ subR[6];
+	CAMELLIA_SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
+	CAMELLIA_SUBKEY_R(6) = subR[5] ^ subR[7];
+	tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = tl & subL[8],  /* FL(kl1) */
+		tr = subR[10] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
+	CAMELLIA_SUBKEY_R(7) = subR[6] ^ tr;
+	CAMELLIA_SUBKEY_L(8) = subL[8];       /* FL(kl1) */
+	CAMELLIA_SUBKEY_R(8) = subR[8];
+	CAMELLIA_SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
+	CAMELLIA_SUBKEY_R(9) = subR[9];
+	tl = subL[7] ^ (subR[7] & ~subR[9]);
+	dw = tl & subL[9],  /* FLinv(kl2) */
+		tr = subR[7] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
+	CAMELLIA_SUBKEY_R(10) = tr ^ subR[11];
+	CAMELLIA_SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
+	CAMELLIA_SUBKEY_R(11) = subR[10] ^ subR[12];
+	CAMELLIA_SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
+	CAMELLIA_SUBKEY_R(12) = subR[11] ^ subR[13];
+	CAMELLIA_SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
+	CAMELLIA_SUBKEY_R(13) = subR[12] ^ subR[14];
+	CAMELLIA_SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
+	CAMELLIA_SUBKEY_R(14) = subR[13] ^ subR[15];
+	tl = subL[18] ^ (subR[18] & ~subR[16]);
+	dw = tl & subL[16], /* FL(kl3) */
+		tr = subR[18] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
+	CAMELLIA_SUBKEY_R(15) = subR[14] ^ tr;
+	CAMELLIA_SUBKEY_L(16) = subL[16];     /* FL(kl3) */
+	CAMELLIA_SUBKEY_R(16) = subR[16];
+	CAMELLIA_SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
+	CAMELLIA_SUBKEY_R(17) = subR[17];
+	tl = subL[15] ^ (subR[15] & ~subR[17]);
+	dw = tl & subL[17], /* FLinv(kl4) */
+		tr = subR[15] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
+	CAMELLIA_SUBKEY_R(18) = tr ^ subR[19];
+	CAMELLIA_SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
+	CAMELLIA_SUBKEY_R(19) = subR[18] ^ subR[20];
+	CAMELLIA_SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
+	CAMELLIA_SUBKEY_R(20) = subR[19] ^ subR[21];
+	CAMELLIA_SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
+	CAMELLIA_SUBKEY_R(21) = subR[20] ^ subR[22];
+	CAMELLIA_SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
+	CAMELLIA_SUBKEY_R(22) = subR[21] ^ subR[23];
+	CAMELLIA_SUBKEY_L(23) = subL[22];     /* round 18 */
+	CAMELLIA_SUBKEY_R(23) = subR[22];
+	CAMELLIA_SUBKEY_L(24) = subL[24] ^ subL[23]; /* kw3 */
+	CAMELLIA_SUBKEY_R(24) = subR[24] ^ subR[23];
 
 	/* apply the inverse of the last half of P-function */
 	dw = CAMELLIA_SUBKEY_L(2) ^ CAMELLIA_SUBKEY_R(2),
@@ -775,11 +719,8 @@ static void camellia_setup128(const unsi
 		dw = CAMELLIA_RL8(dw);/* round 18 */
 	CAMELLIA_SUBKEY_R(23) = CAMELLIA_SUBKEY_L(23) ^ dw,
 		CAMELLIA_SUBKEY_L(23) = dw;
-
-	return;
 }
 
-
 static void camellia_setup256(const unsigned char *key, u32 *subkey)
 {
 	u32 kll,klr,krl,krr;           /* left half of key */
@@ -805,56 +746,56 @@ static void camellia_setup256(const unsi
 
 	/* generate KL dependent subkeys */
 	/* kw1 */
-	SUBL(0) = kll; SUBR(0) = klr;
+	subL[0] = kll; subR[0] = klr;
 	/* kw2 */
-	SUBL(1) = krl; SUBR(1) = krr;
+	subL[1] = krl; subR[1] = krr;
 	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 45);
 	/* k9 */
-	SUBL(12) = kll; SUBR(12) = klr;
+	subL[12] = kll; subR[12] = klr;
 	/* k10 */
-	SUBL(13) = krl; SUBR(13) = krr;
+	subL[13] = krl; subR[13] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* kl3 */
-	SUBL(16) = kll; SUBR(16) = klr;
+	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
-	SUBL(17) = krl; SUBR(17) = krr;
+	subL[17] = krl; subR[17] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 17);
 	/* k17 */
-	SUBL(22) = kll; SUBR(22) = klr;
+	subL[22] = kll; subR[22] = klr;
 	/* k18 */
-	SUBL(23) = krl; SUBR(23) = krr;
+	subL[23] = krl; subR[23] = krr;
 	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 34);
 	/* k23 */
-	SUBL(30) = kll; SUBR(30) = klr;
+	subL[30] = kll; subR[30] = klr;
 	/* k24 */
-	SUBL(31) = krl; SUBR(31) = krr;
+	subL[31] = krl; subR[31] = krr;
 
 	/* generate KR dependent subkeys */
 	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
 	/* k3 */
-	SUBL(4) = krll; SUBR(4) = krlr;
+	subL[4] = krll; subR[4] = krlr;
 	/* k4 */
-	SUBL(5) = krrl; SUBR(5) = krrr;
+	subL[5] = krrl; subR[5] = krrr;
 	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
 	/* kl1 */
-	SUBL(8) = krll; SUBR(8) = krlr;
+	subL[8] = krll; subR[8] = krlr;
 	/* kl2 */
-	SUBL(9) = krrl; SUBR(9) = krrr;
+	subL[9] = krrl; subR[9] = krrr;
 	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k13 */
-	SUBL(18) = krll; SUBR(18) = krlr;
+	subL[18] = krll; subR[18] = krlr;
 	/* k14 */
-	SUBL(19) = krrl; SUBR(19) = krrr;
+	subL[19] = krrl; subR[19] = krrr;
 	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
 	/* k19 */
-	SUBL(26) = krll; SUBR(26) = krlr;
+	subL[26] = krll; subR[26] = krlr;
 	/* k20 */
-	SUBL(27) = krrl; SUBR(27) = krrr;
+	subL[27] = krrl; subR[27] = krrr;
 	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 34);
 
 	/* generate KA */
-	kll = SUBL(0) ^ krll; klr = SUBR(0) ^ krlr;
-	krl = SUBL(1) ^ krrl; krr = SUBR(1) ^ krrr;
+	kll = subL[0] ^ krll; klr = subR[0] ^ krlr;
+	krl = subL[1] ^ krrl; krr = subR[1] ^ krrr;
 	CAMELLIA_F(kll, klr,
 		   CAMELLIA_SIGMA1L, CAMELLIA_SIGMA1R,
 		   w0, w1, il, ir, t0, t1);
@@ -887,208 +828,207 @@ static void camellia_setup256(const unsi
 	/* generate KA dependent subkeys */
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 15);
 	/* k5 */
-	SUBL(6) = kll; SUBR(6) = klr;
+	subL[6] = kll; subR[6] = klr;
 	/* k6 */
-	SUBL(7) = krl; SUBR(7) = krr;
+	subL[7] = krl; subR[7] = krr;
 	CAMELLIA_ROLDQ(kll, klr, krl, krr, w0, w1, 30);
 	/* k11 */
-	SUBL(14) = kll; SUBR(14) = klr;
+	subL[14] = kll; subR[14] = klr;
 	/* k12 */
-	SUBL(15) = krl; SUBR(15) = krr;
+	subL[15] = krl; subR[15] = krr;
 	/* rotation left shift 32bit */
 	/* kl5 */
-	SUBL(24) = klr; SUBR(24) = krl;
+	subL[24] = klr; subR[24] = krl;
 	/* kl6 */
-	SUBL(25) = krr; SUBR(25) = kll;
+	subL[25] = krr; subR[25] = kll;
 	/* rotation left shift 49 from k11,k12 -> k21,k22 */
 	CAMELLIA_ROLDQo32(kll, klr, krl, krr, w0, w1, 49);
 	/* k21 */
-	SUBL(28) = kll; SUBR(28) = klr;
+	subL[28] = kll; subR[28] = klr;
 	/* k22 */
-	SUBL(29) = krl; SUBR(29) = krr;
+	subL[29] = krl; subR[29] = krr;
 
 	/* generate KB dependent subkeys */
 	/* k1 */
-	SUBL(2) = krll; SUBR(2) = krlr;
+	subL[2] = krll; subR[2] = krlr;
 	/* k2 */
-	SUBL(3) = krrl; SUBR(3) = krrr;
+	subL[3] = krrl; subR[3] = krrr;
 	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k7 */
-	SUBL(10) = krll; SUBR(10) = krlr;
+	subL[10] = krll; subR[10] = krlr;
 	/* k8 */
-	SUBL(11) = krrl; SUBR(11) = krrr;
+	subL[11] = krrl; subR[11] = krrr;
 	CAMELLIA_ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
 	/* k15 */
-	SUBL(20) = krll; SUBR(20) = krlr;
+	subL[20] = krll; subR[20] = krlr;
 	/* k16 */
-	SUBL(21) = krrl; SUBR(21) = krrr;
+	subL[21] = krrl; subR[21] = krrr;
 	CAMELLIA_ROLDQo32(krll, krlr, krrl, krrr, w0, w1, 51);
 	/* kw3 */
-	SUBL(32) = krll; SUBR(32) = krlr;
+	subL[32] = krll; subR[32] = krlr;
 	/* kw4 */
-	SUBL(33) = krrl; SUBR(33) = krrr;
+	subL[33] = krrl; subR[33] = krrr;
 
 	/* absorb kw2 to other subkeys */
 	/* round 2 */
-	SUBL(3) ^= SUBL(1); SUBR(3) ^= SUBR(1);
+	subL[3] ^= subL[1]; subR[3] ^= subR[1];
 	/* round 4 */
-	SUBL(5) ^= SUBL(1); SUBR(5) ^= SUBR(1);
+	subL[5] ^= subL[1]; subR[5] ^= subR[1];
 	/* round 6 */
-	SUBL(7) ^= SUBL(1); SUBR(7) ^= SUBR(1);
-	SUBL(1) ^= SUBR(1) & ~SUBR(9);
-	dw = SUBL(1) & SUBL(9),
-		SUBR(1) ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
+	subL[7] ^= subL[1]; subR[7] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[9];
+	dw = subL[1] & subL[9],
+		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl2) */
 	/* round 8 */
-	SUBL(11) ^= SUBL(1); SUBR(11) ^= SUBR(1);
+	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
-	SUBL(13) ^= SUBL(1); SUBR(13) ^= SUBR(1);
+	subL[13] ^= subL[1]; subR[13] ^= subR[1];
 	/* round 12 */
-	SUBL(15) ^= SUBL(1); SUBR(15) ^= SUBR(1);
-	SUBL(1) ^= SUBR(1) & ~SUBR(17);
-	dw = SUBL(1) & SUBL(17),
-		SUBR(1) ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
+	subL[15] ^= subL[1]; subR[15] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[17];
+	dw = subL[1] & subL[17],
+		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl4) */
 	/* round 14 */
-	SUBL(19) ^= SUBL(1); SUBR(19) ^= SUBR(1);
+	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
-	SUBL(21) ^= SUBL(1); SUBR(21) ^= SUBR(1);
+	subL[21] ^= subL[1]; subR[21] ^= subR[1];
 	/* round 18 */
-	SUBL(23) ^= SUBL(1); SUBR(23) ^= SUBR(1);
-	SUBL(1) ^= SUBR(1) & ~SUBR(25);
-	dw = SUBL(1) & SUBL(25),
-		SUBR(1) ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl6) */
+	subL[23] ^= subL[1]; subR[23] ^= subR[1];
+	subL[1] ^= subR[1] & ~subR[25];
+	dw = subL[1] & subL[25],
+		subR[1] ^= CAMELLIA_RL1(dw); /* modified for FLinv(kl6) */
 	/* round 20 */
-	SUBL(27) ^= SUBL(1); SUBR(27) ^= SUBR(1);
+	subL[27] ^= subL[1]; subR[27] ^= subR[1];
 	/* round 22 */
-	SUBL(29) ^= SUBL(1); SUBR(29) ^= SUBR(1);
+	subL[29] ^= subL[1]; subR[29] ^= subR[1];
 	/* round 24 */
-	SUBL(31) ^= SUBL(1); SUBR(31) ^= SUBR(1);
+	subL[31] ^= subL[1]; subR[31] ^= subR[1];
 	/* kw3 */
-	SUBL(32) ^= SUBL(1); SUBR(32) ^= SUBR(1);
-
+	subL[32] ^= subL[1]; subR[32] ^= subR[1];
 
 	/* absorb kw4 to other subkeys */
-	kw4l = SUBL(33); kw4r = SUBR(33);
+	kw4l = subL[33]; kw4r = subR[33];
 	/* round 23 */
-	SUBL(30) ^= kw4l; SUBR(30) ^= kw4r;
+	subL[30] ^= kw4l; subR[30] ^= kw4r;
 	/* round 21 */
-	SUBL(28) ^= kw4l; SUBR(28) ^= kw4r;
+	subL[28] ^= kw4l; subR[28] ^= kw4r;
 	/* round 19 */
-	SUBL(26) ^= kw4l; SUBR(26) ^= kw4r;
-	kw4l ^= kw4r & ~SUBR(24);
-	dw = kw4l & SUBL(24),
+	subL[26] ^= kw4l; subR[26] ^= kw4r;
+	kw4l ^= kw4r & ~subR[24];
+	dw = kw4l & subL[24],
 		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl5) */
 	/* round 17 */
-	SUBL(22) ^= kw4l; SUBR(22) ^= kw4r;
+	subL[22] ^= kw4l; subR[22] ^= kw4r;
 	/* round 15 */
-	SUBL(20) ^= kw4l; SUBR(20) ^= kw4r;
+	subL[20] ^= kw4l; subR[20] ^= kw4r;
 	/* round 13 */
-	SUBL(18) ^= kw4l; SUBR(18) ^= kw4r;
-	kw4l ^= kw4r & ~SUBR(16);
-	dw = kw4l & SUBL(16),
+	subL[18] ^= kw4l; subR[18] ^= kw4r;
+	kw4l ^= kw4r & ~subR[16];
+	dw = kw4l & subL[16],
 		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl3) */
 	/* round 11 */
-	SUBL(14) ^= kw4l; SUBR(14) ^= kw4r;
+	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
-	SUBL(12) ^= kw4l; SUBR(12) ^= kw4r;
+	subL[12] ^= kw4l; subR[12] ^= kw4r;
 	/* round 7 */
-	SUBL(10) ^= kw4l; SUBR(10) ^= kw4r;
-	kw4l ^= kw4r & ~SUBR(8);
-	dw = kw4l & SUBL(8),
+	subL[10] ^= kw4l; subR[10] ^= kw4r;
+	kw4l ^= kw4r & ~subR[8];
+	dw = kw4l & subL[8],
 		kw4r ^= CAMELLIA_RL1(dw); /* modified for FL(kl1) */
 	/* round 5 */
-	SUBL(6) ^= kw4l; SUBR(6) ^= kw4r;
+	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
-	SUBL(4) ^= kw4l; SUBR(4) ^= kw4r;
+	subL[4] ^= kw4l; subR[4] ^= kw4r;
 	/* round 1 */
-	SUBL(2) ^= kw4l; SUBR(2) ^= kw4r;
+	subL[2] ^= kw4l; subR[2] ^= kw4r;
 	/* kw1 */
-	SUBL(0) ^= kw4l; SUBR(0) ^= kw4r;
+	subL[0] ^= kw4l; subR[0] ^= kw4r;
 
 	/* key XOR is end of F-function */
-	CAMELLIA_SUBKEY_L(0) = SUBL(0) ^ SUBL(2);/* kw1 */
-	CAMELLIA_SUBKEY_R(0) = SUBR(0) ^ SUBR(2);
-	CAMELLIA_SUBKEY_L(2) = SUBL(3);       /* round 1 */
-	CAMELLIA_SUBKEY_R(2) = SUBR(3);
-	CAMELLIA_SUBKEY_L(3) = SUBL(2) ^ SUBL(4); /* round 2 */
-	CAMELLIA_SUBKEY_R(3) = SUBR(2) ^ SUBR(4);
-	CAMELLIA_SUBKEY_L(4) = SUBL(3) ^ SUBL(5); /* round 3 */
-	CAMELLIA_SUBKEY_R(4) = SUBR(3) ^ SUBR(5);
-	CAMELLIA_SUBKEY_L(5) = SUBL(4) ^ SUBL(6); /* round 4 */
-	CAMELLIA_SUBKEY_R(5) = SUBR(4) ^ SUBR(6);
-	CAMELLIA_SUBKEY_L(6) = SUBL(5) ^ SUBL(7); /* round 5 */
-	CAMELLIA_SUBKEY_R(6) = SUBR(5) ^ SUBR(7);
-	tl = SUBL(10) ^ (SUBR(10) & ~SUBR(8));
-	dw = tl & SUBL(8),  /* FL(kl1) */
-		tr = SUBR(10) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(7) = SUBL(6) ^ tl; /* round 6 */
-	CAMELLIA_SUBKEY_R(7) = SUBR(6) ^ tr;
-	CAMELLIA_SUBKEY_L(8) = SUBL(8);       /* FL(kl1) */
-	CAMELLIA_SUBKEY_R(8) = SUBR(8);
-	CAMELLIA_SUBKEY_L(9) = SUBL(9);       /* FLinv(kl2) */
-	CAMELLIA_SUBKEY_R(9) = SUBR(9);
-	tl = SUBL(7) ^ (SUBR(7) & ~SUBR(9));
-	dw = tl & SUBL(9),  /* FLinv(kl2) */
-		tr = SUBR(7) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(10) = tl ^ SUBL(11); /* round 7 */
-	CAMELLIA_SUBKEY_R(10) = tr ^ SUBR(11);
-	CAMELLIA_SUBKEY_L(11) = SUBL(10) ^ SUBL(12); /* round 8 */
-	CAMELLIA_SUBKEY_R(11) = SUBR(10) ^ SUBR(12);
-	CAMELLIA_SUBKEY_L(12) = SUBL(11) ^ SUBL(13); /* round 9 */
-	CAMELLIA_SUBKEY_R(12) = SUBR(11) ^ SUBR(13);
-	CAMELLIA_SUBKEY_L(13) = SUBL(12) ^ SUBL(14); /* round 10 */
-	CAMELLIA_SUBKEY_R(13) = SUBR(12) ^ SUBR(14);
-	CAMELLIA_SUBKEY_L(14) = SUBL(13) ^ SUBL(15); /* round 11 */
-	CAMELLIA_SUBKEY_R(14) = SUBR(13) ^ SUBR(15);
-	tl = SUBL(18) ^ (SUBR(18) & ~SUBR(16));
-	dw = tl & SUBL(16), /* FL(kl3) */
-		tr = SUBR(18) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(15) = SUBL(14) ^ tl; /* round 12 */
-	CAMELLIA_SUBKEY_R(15) = SUBR(14) ^ tr;
-	CAMELLIA_SUBKEY_L(16) = SUBL(16);     /* FL(kl3) */
-	CAMELLIA_SUBKEY_R(16) = SUBR(16);
-	CAMELLIA_SUBKEY_L(17) = SUBL(17);     /* FLinv(kl4) */
-	CAMELLIA_SUBKEY_R(17) = SUBR(17);
-	tl = SUBL(15) ^ (SUBR(15) & ~SUBR(17));
-	dw = tl & SUBL(17), /* FLinv(kl4) */
-		tr = SUBR(15) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(18) = tl ^ SUBL(19); /* round 13 */
-	CAMELLIA_SUBKEY_R(18) = tr ^ SUBR(19);
-	CAMELLIA_SUBKEY_L(19) = SUBL(18) ^ SUBL(20); /* round 14 */
-	CAMELLIA_SUBKEY_R(19) = SUBR(18) ^ SUBR(20);
-	CAMELLIA_SUBKEY_L(20) = SUBL(19) ^ SUBL(21); /* round 15 */
-	CAMELLIA_SUBKEY_R(20) = SUBR(19) ^ SUBR(21);
-	CAMELLIA_SUBKEY_L(21) = SUBL(20) ^ SUBL(22); /* round 16 */
-	CAMELLIA_SUBKEY_R(21) = SUBR(20) ^ SUBR(22);
-	CAMELLIA_SUBKEY_L(22) = SUBL(21) ^ SUBL(23); /* round 17 */
-	CAMELLIA_SUBKEY_R(22) = SUBR(21) ^ SUBR(23);
-	tl = SUBL(26) ^ (SUBR(26)
-			 & ~SUBR(24));
-	dw = tl & SUBL(24), /* FL(kl5) */
-		tr = SUBR(26) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(23) = SUBL(22) ^ tl; /* round 18 */
-	CAMELLIA_SUBKEY_R(23) = SUBR(22) ^ tr;
-	CAMELLIA_SUBKEY_L(24) = SUBL(24);     /* FL(kl5) */
-	CAMELLIA_SUBKEY_R(24) = SUBR(24);
-	CAMELLIA_SUBKEY_L(25) = SUBL(25);     /* FLinv(kl6) */
-	CAMELLIA_SUBKEY_R(25) = SUBR(25);
-	tl = SUBL(23) ^ (SUBR(23) &
-			 ~SUBR(25));
-	dw = tl & SUBL(25), /* FLinv(kl6) */
-		tr = SUBR(23) ^ CAMELLIA_RL1(dw);
-	CAMELLIA_SUBKEY_L(26) = tl ^ SUBL(27); /* round 19 */
-	CAMELLIA_SUBKEY_R(26) = tr ^ SUBR(27);
-	CAMELLIA_SUBKEY_L(27) = SUBL(26) ^ SUBL(28); /* round 20 */
-	CAMELLIA_SUBKEY_R(27) = SUBR(26) ^ SUBR(28);
-	CAMELLIA_SUBKEY_L(28) = SUBL(27) ^ SUBL(29); /* round 21 */
-	CAMELLIA_SUBKEY_R(28) = SUBR(27) ^ SUBR(29);
-	CAMELLIA_SUBKEY_L(29) = SUBL(28) ^ SUBL(30); /* round 22 */
-	CAMELLIA_SUBKEY_R(29) = SUBR(28) ^ SUBR(30);
-	CAMELLIA_SUBKEY_L(30) = SUBL(29) ^ SUBL(31); /* round 23 */
-	CAMELLIA_SUBKEY_R(30) = SUBR(29) ^ SUBR(31);
-	CAMELLIA_SUBKEY_L(31) = SUBL(30);     /* round 24 */
-	CAMELLIA_SUBKEY_R(31) = SUBR(30);
-	CAMELLIA_SUBKEY_L(32) = SUBL(32) ^ SUBL(31); /* kw3 */
-	CAMELLIA_SUBKEY_R(32) = SUBR(32) ^ SUBR(31);
+	CAMELLIA_SUBKEY_L(0) = subL[0] ^ subL[2];/* kw1 */
+	CAMELLIA_SUBKEY_R(0) = subR[0] ^ subR[2];
+	CAMELLIA_SUBKEY_L(2) = subL[3];       /* round 1 */
+	CAMELLIA_SUBKEY_R(2) = subR[3];
+	CAMELLIA_SUBKEY_L(3) = subL[2] ^ subL[4]; /* round 2 */
+	CAMELLIA_SUBKEY_R(3) = subR[2] ^ subR[4];
+	CAMELLIA_SUBKEY_L(4) = subL[3] ^ subL[5]; /* round 3 */
+	CAMELLIA_SUBKEY_R(4) = subR[3] ^ subR[5];
+	CAMELLIA_SUBKEY_L(5) = subL[4] ^ subL[6]; /* round 4 */
+	CAMELLIA_SUBKEY_R(5) = subR[4] ^ subR[6];
+	CAMELLIA_SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
+	CAMELLIA_SUBKEY_R(6) = subR[5] ^ subR[7];
+	tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = tl & subL[8],  /* FL(kl1) */
+		tr = subR[10] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
+	CAMELLIA_SUBKEY_R(7) = subR[6] ^ tr;
+	CAMELLIA_SUBKEY_L(8) = subL[8];       /* FL(kl1) */
+	CAMELLIA_SUBKEY_R(8) = subR[8];
+	CAMELLIA_SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
+	CAMELLIA_SUBKEY_R(9) = subR[9];
+	tl = subL[7] ^ (subR[7] & ~subR[9]);
+	dw = tl & subL[9],  /* FLinv(kl2) */
+		tr = subR[7] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
+	CAMELLIA_SUBKEY_R(10) = tr ^ subR[11];
+	CAMELLIA_SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
+	CAMELLIA_SUBKEY_R(11) = subR[10] ^ subR[12];
+	CAMELLIA_SUBKEY_L(12) = subL[11] ^ subL[13]; /* round 9 */
+	CAMELLIA_SUBKEY_R(12) = subR[11] ^ subR[13];
+	CAMELLIA_SUBKEY_L(13) = subL[12] ^ subL[14]; /* round 10 */
+	CAMELLIA_SUBKEY_R(13) = subR[12] ^ subR[14];
+	CAMELLIA_SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
+	CAMELLIA_SUBKEY_R(14) = subR[13] ^ subR[15];
+	tl = subL[18] ^ (subR[18] & ~subR[16]);
+	dw = tl & subL[16], /* FL(kl3) */
+		tr = subR[18] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
+	CAMELLIA_SUBKEY_R(15) = subR[14] ^ tr;
+	CAMELLIA_SUBKEY_L(16) = subL[16];     /* FL(kl3) */
+	CAMELLIA_SUBKEY_R(16) = subR[16];
+	CAMELLIA_SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
+	CAMELLIA_SUBKEY_R(17) = subR[17];
+	tl = subL[15] ^ (subR[15] & ~subR[17]);
+	dw = tl & subL[17], /* FLinv(kl4) */
+		tr = subR[15] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
+	CAMELLIA_SUBKEY_R(18) = tr ^ subR[19];
+	CAMELLIA_SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
+	CAMELLIA_SUBKEY_R(19) = subR[18] ^ subR[20];
+	CAMELLIA_SUBKEY_L(20) = subL[19] ^ subL[21]; /* round 15 */
+	CAMELLIA_SUBKEY_R(20) = subR[19] ^ subR[21];
+	CAMELLIA_SUBKEY_L(21) = subL[20] ^ subL[22]; /* round 16 */
+	CAMELLIA_SUBKEY_R(21) = subR[20] ^ subR[22];
+	CAMELLIA_SUBKEY_L(22) = subL[21] ^ subL[23]; /* round 17 */
+	CAMELLIA_SUBKEY_R(22) = subR[21] ^ subR[23];
+	tl = subL[26] ^ (subR[26]
+			 & ~subR[24]);
+	dw = tl & subL[24], /* FL(kl5) */
+		tr = subR[26] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
+	CAMELLIA_SUBKEY_R(23) = subR[22] ^ tr;
+	CAMELLIA_SUBKEY_L(24) = subL[24];     /* FL(kl5) */
+	CAMELLIA_SUBKEY_R(24) = subR[24];
+	CAMELLIA_SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
+	CAMELLIA_SUBKEY_R(25) = subR[25];
+	tl = subL[23] ^ (subR[23] &
+			 ~subR[25]);
+	dw = tl & subL[25], /* FLinv(kl6) */
+		tr = subR[23] ^ CAMELLIA_RL1(dw);
+	CAMELLIA_SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
+	CAMELLIA_SUBKEY_R(26) = tr ^ subR[27];
+	CAMELLIA_SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
+	CAMELLIA_SUBKEY_R(27) = subR[26] ^ subR[28];
+	CAMELLIA_SUBKEY_L(28) = subL[27] ^ subL[29]; /* round 21 */
+	CAMELLIA_SUBKEY_R(28) = subR[27] ^ subR[29];
+	CAMELLIA_SUBKEY_L(29) = subL[28] ^ subL[30]; /* round 22 */
+	CAMELLIA_SUBKEY_R(29) = subR[28] ^ subR[30];
+	CAMELLIA_SUBKEY_L(30) = subL[29] ^ subL[31]; /* round 23 */
+	CAMELLIA_SUBKEY_R(30) = subR[29] ^ subR[31];
+	CAMELLIA_SUBKEY_L(31) = subL[30];     /* round 24 */
+	CAMELLIA_SUBKEY_R(31) = subR[30];
+	CAMELLIA_SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
+	CAMELLIA_SUBKEY_R(32) = subR[32] ^ subR[31];
 
 	/* apply the inverse of the last half of P-function */
 	dw = CAMELLIA_SUBKEY_L(2) ^ CAMELLIA_SUBKEY_R(2),
@@ -1187,8 +1127,6 @@ static void camellia_setup256(const unsi
 		dw = CAMELLIA_RL8(dw);/* round 24 */
 	CAMELLIA_SUBKEY_R(31) = CAMELLIA_SUBKEY_L(31) ^ dw,
 		CAMELLIA_SUBKEY_L(31) = dw;
-
-	return;
 }
 
 static void camellia_setup192(const unsigned char *key, u32 *subkey)
@@ -1197,20 +1135,16 @@ static void camellia_setup192(const unsi
 	u32 krll, krlr, krrl,krrr;
 
 	memcpy(kk, key, 24);
-	memcpy((unsigned char *)&krll, key+16,4);
-	memcpy((unsigned char *)&krlr, key+20,4);
+	memcpy((unsigned char *)&krll, key+16, 4);
+	memcpy((unsigned char *)&krlr, key+20, 4);
 	krrl = ~krll;
 	krrr = ~krlr;
 	memcpy(kk+24, (unsigned char *)&krrl, 4);
 	memcpy(kk+28, (unsigned char *)&krrr, 4);
 	camellia_setup256(kk, subkey);
-	return;
 }
 
 
-/**
- * Stuff related to camellia encryption/decryption
- */
 static void camellia_encrypt128(const u32 *subkey, __be32 *io_text)
 {
 	u32 il,ir,t0,t1;               /* temporary valiables */
@@ -1222,11 +1156,11 @@ static void camellia_encrypt128(const u3
 	io[2] = be32_to_cpu(io_text[2]);
 	io[3] = be32_to_cpu(io_text[3]);
 
-	/* pre whitening but absorb kw2*/
+	/* pre whitening but absorb kw2 */
 	io[0] ^= CAMELLIA_SUBKEY_L(0);
 	io[1] ^= CAMELLIA_SUBKEY_R(0);
-	/* main iteration */
 
+	/* main iteration */
 	CAMELLIA_ROUNDSM(io[0],io[1],
 			 CAMELLIA_SUBKEY_L(2),CAMELLIA_SUBKEY_R(2),
 			 io[2],io[3],il,ir,t0,t1);
@@ -1298,19 +1232,10 @@ static void camellia_encrypt128(const u3
 	io[2] ^= CAMELLIA_SUBKEY_L(24);
 	io[3] ^= CAMELLIA_SUBKEY_R(24);
 
-	t0 = io[0];
-	t1 = io[1];
-	io[0] = io[2];
-	io[1] = io[3];
-	io[2] = t0;
-	io[3] = t1;
-
-	io_text[0] = cpu_to_be32(io[0]);
-	io_text[1] = cpu_to_be32(io[1]);
-	io_text[2] = cpu_to_be32(io[2]);
-	io_text[3] = cpu_to_be32(io[3]);
-
-	return;
+	io_text[0] = cpu_to_be32(io[2]);
+	io_text[1] = cpu_to_be32(io[3]);
+	io_text[2] = cpu_to_be32(io[0]);
+	io_text[3] = cpu_to_be32(io[1]);
 }
 
 static void camellia_decrypt128(const u32 *subkey, __be32 *io_text)
@@ -1324,7 +1249,7 @@ static void camellia_decrypt128(const u3
 	io[2] = be32_to_cpu(io_text[2]);
 	io[3] = be32_to_cpu(io_text[3]);
 
-	/* pre whitening but absorb kw2*/
+	/* pre whitening but absorb kw2 */
 	io[0] ^= CAMELLIA_SUBKEY_L(24);
 	io[1] ^= CAMELLIA_SUBKEY_R(24);
 
@@ -1400,25 +1325,12 @@ static void camellia_decrypt128(const u3
 	io[2] ^= CAMELLIA_SUBKEY_L(0);
 	io[3] ^= CAMELLIA_SUBKEY_R(0);
 
-	t0 = io[0];
-	t1 = io[1];
-	io[0] = io[2];
-	io[1] = io[3];
-	io[2] = t0;
-	io[3] = t1;
-
-	io_text[0] = cpu_to_be32(io[0]);
-	io_text[1] = cpu_to_be32(io[1]);
-	io_text[2] = cpu_to_be32(io[2]);
-	io_text[3] = cpu_to_be32(io[3]);
-
-	return;
+	io_text[0] = cpu_to_be32(io[2]);
+	io_text[1] = cpu_to_be32(io[3]);
+	io_text[2] = cpu_to_be32(io[0]);
+	io_text[3] = cpu_to_be32(io[1]);
 }
 
-
-/**
- * stuff for 192 and 256bit encryption/decryption
- */
 static void camellia_encrypt256(const u32 *subkey, __be32 *io_text)
 {
 	u32 il,ir,t0,t1;           /* temporary valiables */
@@ -1430,7 +1342,7 @@ static void camellia_encrypt256(const u3
 	io[2] = be32_to_cpu(io_text[2]);
 	io[3] = be32_to_cpu(io_text[3]);
 
-	/* pre whitening but absorb kw2*/
+	/* pre whitening but absorb kw2 */
 	io[0] ^= CAMELLIA_SUBKEY_L(0);
 	io[1] ^= CAMELLIA_SUBKEY_R(0);
 
@@ -1530,22 +1442,12 @@ static void camellia_encrypt256(const u3
 	io[2] ^= CAMELLIA_SUBKEY_L(32);
 	io[3] ^= CAMELLIA_SUBKEY_R(32);
 
-	t0 = io[0];
-	t1 = io[1];
-	io[0] = io[2];
-	io[1] = io[3];
-	io[2] = t0;
-	io[3] = t1;
-
-	io_text[0] = cpu_to_be32(io[0]);
-	io_text[1] = cpu_to_be32(io[1]);
-	io_text[2] = cpu_to_be32(io[2]);
-	io_text[3] = cpu_to_be32(io[3]);
-
-	return;
+	io_text[0] = cpu_to_be32(io[2]);
+	io_text[1] = cpu_to_be32(io[3]);
+	io_text[2] = cpu_to_be32(io[0]);
+	io_text[3] = cpu_to_be32(io[1]);
 }
 
-
 static void camellia_decrypt256(const u32 *subkey, __be32 *io_text)
 {
 	u32 il,ir,t0,t1;           /* temporary valiables */
@@ -1557,7 +1459,7 @@ static void camellia_decrypt256(const u3
 	io[2] = be32_to_cpu(io_text[2]);
 	io[3] = be32_to_cpu(io_text[3]);
 
-	/* pre whitening but absorb kw2*/
+	/* pre whitening but absorb kw2 */
 	io[0] ^= CAMELLIA_SUBKEY_L(32);
 	io[1] ^= CAMELLIA_SUBKEY_R(32);
 
@@ -1657,22 +1559,18 @@ static void camellia_decrypt256(const u3
 	io[2] ^= CAMELLIA_SUBKEY_L(0);
 	io[3] ^= CAMELLIA_SUBKEY_R(0);
 
-	t0 = io[0];
-	t1 = io[1];
-	io[0] = io[2];
-	io[1] = io[3];
-	io[2] = t0;
-	io[3] = t1;
-
-	io_text[0] = cpu_to_be32(io[0]);
-	io_text[1] = cpu_to_be32(io[1]);
-	io_text[2] = cpu_to_be32(io[2]);
-	io_text[3] = cpu_to_be32(io[3]);
-
-	return;
+	io_text[0] = cpu_to_be32(io[2]);
+	io_text[1] = cpu_to_be32(io[3]);
+	io_text[2] = cpu_to_be32(io[0]);
+	io_text[3] = cpu_to_be32(io[1]);
 }
 
 
+struct camellia_ctx {
+	int key_length;
+	u32 key_table[CAMELLIA_TABLE_BYTE_LEN / 4];
+};
+
 static int
 camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		 unsigned int key_len)
@@ -1688,7 +1586,7 @@ camellia_set_key(struct crypto_tfm *tfm,
 
 	cctx->key_length = key_len;
 
-	switch(key_len) {
+	switch (key_len) {
 	case 16:
 		camellia_setup128(key, cctx->key_table);
 		break;
@@ -1698,14 +1596,11 @@ camellia_set_key(struct crypto_tfm *tfm,
 	case 32:
 		camellia_setup256(key, cctx->key_table);
 		break;
-	default:
-		break;
 	}
 
 	return 0;
 }
 
-
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
@@ -1725,14 +1620,11 @@ static void camellia_encrypt(struct cryp
 	case 32:
 		camellia_encrypt256(cctx->key_table, tmp);
 		break;
-	default:
-		break;
 	}
 
 	memcpy(dst, tmp, CAMELLIA_BLOCK_SIZE);
 }
 
-
 static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
@@ -1752,14 +1644,11 @@ static void camellia_decrypt(struct cryp
 	case 32:
 		camellia_decrypt256(cctx->key_table, tmp);
 		break;
-	default:
-		break;
 	}
 
 	memcpy(dst, tmp, CAMELLIA_BLOCK_SIZE);
 }
 
-
 static struct crypto_alg camellia_alg = {
 	.cra_name		=	"camellia",
 	.cra_driver_name	=	"camellia-generic",
@@ -1786,16 +1675,13 @@ static int __init camellia_init(void)
 	return crypto_register_alg(&camellia_alg);
 }
 
-
 static void __exit camellia_fini(void)
 {
 	crypto_unregister_alg(&camellia_alg);
 }
 
-
 module_init(camellia_init);
 module_exit(camellia_fini);
 
-
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
 MODULE_LICENSE("GPL");

--Boundary-00=_AHIIHoa1QedVz2q--
