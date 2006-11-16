From: linux@horizon.com
Subject: crypto/des.c cleanups for review
Date: 16 Nov 2006 02:05:16 -0500
Message-ID: <20061116070516.31107.qmail@science.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:23110 "HELO
	science.horizon.com") by vger.kernel.org with SMTP id S1161956AbWKPHFR
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Nov 2006 02:05:17 -0500
To: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I sent this to <da@osvik.no> on Nov. 1, but have received no response.
Is anyone interested?  The changes are all mixed up together, but I can
break them apart into a patch series if desired.

Going roughly in hunk order:
- Moved ROR and ROL macros closer to the IP and FP macros where
  they're used.
- Added comments in a number of places.
- Factored out the MASKSWAP() primitive from IP() and FP().
- Changed ROUND() slightly to reduce the number of temps needed.
  This is where I particularly want to ask you if there's a reason for
  the way you did it before.  Perferring 16-bit shifts to 8-bit ones is
  a 680[01]0 optimization, but is that terribly important these days?
  Coldfire has single-cycle shifts.
- Made the use of pt variable by the PC2() macro explicit.
- Does ekey() need that manually scheduled code?
- Shrunk dkey() code size, at some expense to speed.
- Eliminated flags local variable as unnecessary.
- Improved DES3 bad-key detection to ignore parity bits.

(All placed in the public domain if you want to use them.)

diff --git a/crypto/des.c b/crypto/des.c
index 1df3a71..856d843 100644
--- a/crypto/des.c
+++ b/crypto/des.c
@@ -28,9 +28,6 @@ #define DES3_EDE_KEY_SIZE	(3 * DES_KEY_S
 #define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
 #define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
 
-#define ROL(x, r) ((x) = rol32((x), (r)))
-#define ROR(x, r) ((x) = ror32((x), (r)))
-
 struct des_ctx {
 	u32 expkey[DES_EXPKEY_WORDS];
 };
@@ -76,6 +73,12 @@ static const u8 pc1[256] = {
 	0xae, 0xea, 0xee, 0xee, 0xbe, 0xfa, 0xfe, 0xfe
 };
 
+/*
+ * This table rotates the most significant 7 bits one place right.
+ * rs[i] = (i >> 1 & 0x7e) + (i << 6 & 0x80)
+ * Note that the odd elements of this array are actually
+ * "don't care"; the index used always has the low bit clear.
+ */
 static const u8 rs[256] = {
 	0x00, 0x00, 0x80, 0x80, 0x02, 0x02, 0x82, 0x82,
 	0x04, 0x04, 0x84, 0x84, 0x06, 0x06, 0x86, 0x86,
@@ -111,6 +114,11 @@ static const u8 rs[256] = {
 	0x7c, 0x7c, 0xfc, 0xfc, 0x7e, 0x7e, 0xfe, 0xfe
 };
 
+/*
+ * The pc2 table consists of 2 sections.  Each section is
+ * 4 columns of 128 entries each.  See the PC2() macro
+ * for details.
+ */
 static const u32 pc2[1024] = {
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00040000, 0x00000000, 0x04000000, 0x00100000,
@@ -527,84 +535,64 @@ static const u32 S8[64] = {
 
 /* Encryption components: IP, FP, and round function */
 
-#define IP(L, R, T)		\
-	ROL(R, 4);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xf0f0f0f0;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 12);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xffff0000;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 14);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xcccccccc;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 6);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xff00ff00;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 7);		\
+#define ROL(x, r) ((x) = rol32((x), (r)))
+#define ROR(x, r) ((x) = ror32((x), (r)))
+
+/* Swap the bits set in "mask" between L and R */
+#define MASKSWAP(L, R, T, mask)	\
 	T  = L;			\
 	L ^= R;			\
-	L &= 0xaaaaaaaa;	\
+	L &= (mask);		\
 	R ^= L;			\
-	L ^= T;			\
+	L ^= T;
+/*
+ * The above is more clearly written as 
+ * #define MASKSWAP(L, R, T, mask)	\
+ *	T  = (L ^ R) & (mask);		\
+ *	L ^= T;  R ^= T;
+ * But the form used is better for a 2-operand procesor.
+ */
+
+/* Initial permutation */
+#define IP(L, R, T)			\
+	ROL(R, 4);			\
+	MASKSWAP(L, R, T, 0xf0f0f0f0);	\
+	ROL(R, 12);			\
+	MASKSWAP(L, R, T, 0xffff0000);	\
+	ROR(R, 14);			\
+	MASKSWAP(L, R, T, 0xcccccccc);	\
+	ROL(R, 6);			\
+	MASKSWAP(L, R, T, 0xff00ff00);	\
+	ROR(R, 7);			\
+	MASKSWAP(L, R, T, 0xaaaaaaaa);	\
 	ROL(L, 1);
 
-#define FP(L, R, T)		\
-	ROR(L, 1);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xaaaaaaaa;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 7);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xff00ff00;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 6);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xcccccccc;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROL(R, 14);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xffff0000;	\
-	R ^= L;			\
-	L ^= T;			\
-	ROR(R, 12);		\
-	T  = L;			\
-	L ^= R;			\
-	L &= 0xf0f0f0f0;	\
-	R ^= L;			\
-	L ^= T;			\
+/* Final permutation, inverse of initial permutation */
+#define FP(L, R, T)			\
+	ROR(L, 1);			\
+	MASKSWAP(L, R, T, 0xaaaaaaaa);	\
+	ROL(R, 7);			\
+	MASKSWAP(L, R, T, 0xff00ff00);	\
+	ROR(R, 6);			\
+	MASKSWAP(L, R, T, 0xcccccccc);	\
+	ROL(R, 14);			\
+	MASKSWAP(L, R, T, 0xffff0000);	\
+	ROR(R, 12);			\
+	MASKSWAP(L, R, T, 0xf0f0f0f0);	\
 	ROR(R, 4);
 
 #define ROUND(L, R, A, B, K, d)					\
-	B = K[0];			A = K[1];	K += d;	\
-	B ^= R;				A ^= R;			\
-	B &= 0x3f3f3f3f;		ROR(A, 4);		\
-	L ^= S8[0xff & B];		A &= 0x3f3f3f3f;	\
-	L ^= S6[0xff & (B >> 8)];	B >>= 16;		\
-	L ^= S7[0xff & A];					\
-	L ^= S5[0xff & (A >> 8)];	A >>= 16;		\
-	L ^= S4[0xff & B];					\
-	L ^= S2[0xff & (B >> 8)];				\
-	L ^= S3[0xff & A];					\
-	L ^= S1[0xff & (A >> 8)];
+	B = K[0];		A = K[1];		K += d;	\
+	B ^= R;			A ^= R;				\
+	B &= 0x3f3f3f3f;	ROR(A, 4);			\
+	L ^= S8[0xff & B];	A &= 0x3f3f3f3f;	B >>= 8	\
+	L ^= S7[0xff & A];	A >>= 8;			\
+	L ^= S6[0xff & B];	B >>= 8;			\
+	L ^= S5[0xff & A];	A >>= 8;			\
+	L ^= S4[0xff & B];	B >>= 8;			\
+	L ^= S3[0xff & A];	A >>= 8;			\
+	L ^= S2[B];						\
+	L ^= S1[A];
 
 /*
  * PC2 lookup tables are organized as 2 consecutive sets of 4 interleaved
@@ -615,12 +603,7 @@ #define ROUND(L, R, A, B, K, d)					\
  * or D_i in bits 7-1 (bit 0 being the least significant).
  */
 
-#define T1(x) pt[2 * (x) + 0]
-#define T2(x) pt[2 * (x) + 1]
-#define T3(x) pt[2 * (x) + 2]
-#define T4(x) pt[2 * (x) + 3]
-
-#define PC2(a, b, c, d) (T4(d) | T3(c) | T2(b) | T1(a))
+#define PC2(p, a, b, c, d) (p[2*(a)+0] | p[2*(b)+1] | p[2*(c)+2] | p[2*(d)+3])
 
 /*
  * Encryption key expansion
@@ -634,33 +617,33 @@ #define PC2(a, b, c, d) (T4(d) | T3(c) |
  *   Choice 1 has operated on the key.
  *
  */
-static unsigned long ekey(u32 *pe, const u8 *k)
+static unsigned long ekey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
-	/* K&R: long is at least 32 bits */
+	/* Long is the size of pointer, so good for indexing */
 	unsigned long a, b, c, d, w;
 	const u32 *pt = pc2;
 
-	d = k[4]; d &= 0x0e; d <<= 4; d |= k[0] & 0x1e; d = pc1[d];
-	c = k[5]; c &= 0x0e; c <<= 4; c |= k[1] & 0x1e; c = pc1[c];
-	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
-	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
-
-	pe[15 * 2 + 0] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 0] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 0] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 0] = PC2(b, c, d, a);
+	d = pc1[ ((k[4] & 0x0e) << 4) + (k[0] & 0x1e) ];
+	c = pc1[ ((k[5] & 0x0e) << 4) + (k[1] & 0x1e) ];
+	b = pc1[ ((k[6] & 0x0e) << 4) + (k[2] & 0x1e) ];
+	a = pc1[ ((k[7] & 0x0e) << 4) + (k[3] & 0x1e) ];
+
+	pe[15 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[14 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 0] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 0] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 0] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 0] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 0] = PC2(pt, b, c, d, a);
 
 	/* Check if first half is weak */
 	w  = (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
@@ -668,30 +651,30 @@ static unsigned long ekey(u32 *pe, const
 	/* Skip to next table set */
 	pt += 512;
 
-	d = k[0]; d &= 0xe0; d >>= 4; d |= k[4] & 0xf0; d = pc1[d + 1];
-	c = k[1]; c &= 0xe0; c >>= 4; c |= k[5] & 0xf0; c = pc1[c + 1];
-	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
-	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
+	d = pc1[ ((k[0] & 0xe0) >> 4) + (k[4] & 0xf0) + 1 ];
+	c = pc1[ ((k[1] & 0xe0) >> 4) + (k[5] & 0xf0) + 1 ];
+	b = pc1[ ((k[2] & 0xe0) >> 4) + (k[6] & 0xf0) + 1 ];
+	a = pc1[ ((k[3] & 0xe0) >> 4) + (k[7] & 0xf0) + 1 ];
 
 	/* Check if second half is weak */
 	w |= (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
 
-	pe[15 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 1] = PC2(b, c, d, a);
+	pe[15 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d];
+	pe[14 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 1] = PC2(pt, b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 1] = PC2(pt, d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 1] = PC2(pt, a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 1] = PC2(pt, c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 1] = PC2(pt, b, c, d, a);
 
 	/* Fixup: 2413 5768 -> 1357 2468 */
 	for (d = 0; d < 16; ++d) {
@@ -714,93 +697,39 @@ static unsigned long ekey(u32 *pe, const
  * Decryption key expansion
  *
  * No weak key checking is performed, as this is only used by triple DES
- *
+ * This could be made a smidgen faster at the expense of a lot of space.
  */
-static void dkey(u32 *pe, const u8 *k)
+static void dkey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
-	/* K&R: long is at least 32 bits */
-	unsigned long a, b, c, d;
-	const u32 *pt = pc2;
-
-	d = k[4]; d &= 0x0e; d <<= 4; d |= k[0] & 0x1e; d = pc1[d];
-	c = k[5]; c &= 0x0e; c <<= 4; c |= k[1] & 0x1e; c = pc1[c];
-	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
-	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
-
-	pe[ 0 * 2] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2] = PC2(b, c, d, a);
-
-	/* Skip to next table set */
-	pt += 512;
-
-	d = k[0]; d &= 0xe0; d >>= 4; d |= k[4] & 0xf0; d = pc1[d + 1];
-	c = k[1]; c &= 0xe0; c >>= 4; c |= k[5] & 0xf0; c = pc1[c + 1];
-	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
-	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
-
-	pe[ 0 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2 + 1] = PC2(b, c, d, a);
-
-	/* Fixup: 2413 5768 -> 1357 2468 */
-	for (d = 0; d < 16; ++d) {
-		a = pe[2 * d];
-		b = pe[2 * d + 1];
-		c = a ^ b;
-		c &= 0xffff0000;
-		a ^= c;
-		b ^= c;
-		ROL(b, 18);
-		pe[2 * d] = a;
-		pe[2 * d + 1] = b;
+	unsigned i;
+
+	ekey(pe, k);
+	/* Swap 0<->30, 1<->31, 2<->28, 3<->29, 4<->26,... 14<->16, 15<->17 */
+	for (i = 0; i < 16; i++) {
+		unsigned j = 0x1e ^ i;
+		u32 t = pe[i];
+		pe[i] = pe[j];
+		pe[j] = t;
 	}
 }
 
-static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
+static int des_setkey(struct crypto_tfm *tfm, const u8 key[DES_KEY_SIZE],
 		      unsigned int keylen)
 {
 	struct des_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
 	/* Expand to tmp */
 	ret = ekey(tmp, key);
 
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+	if (unlikely(ret == 0) && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 
 	/* Copy to output */
-	memcpy(dctx->expkey, tmp, sizeof(dctx->expkey));
+	memcpy(dctx->expkey, tmp, sizeof dctx->expkey);
 
 	return 0;
 }
@@ -870,12 +799,11 @@ static int des3_ede_setkey(struct crypto
 	const u32 *K = (const u32 *)key;
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
 	u32 *expkey = dctx->expkey;
-	u32 *flags = &tfm->crt_flags;
 
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
+	if (unlikely(!(((K[0]^K[2]) | (K[1]^K[3])) & 0xfefefefe) ||
+		     !(((K[2]^K[4]) | (K[3]^K[5])) & 0xfefefefe)))
 	{
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
 		return -EINVAL;
 	}
 
@@ -984,7 +912,7 @@ MODULE_ALIAS("des3_ede");
 
 static int __init init(void)
 {
-	int ret = 0;
+	int ret;
 
 	ret = crypto_register_alg(&des_alg);
 	if (ret < 0)
