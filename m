From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 1/5] camellia: code shrink
Date: Thu, 22 Nov 2007 14:45:02 -0800
Message-ID: <200711221445.02347.vda.linux@googlemail.com>
References: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uZgRHAh+/Mx75/g"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:48217 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXKVWqD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:46:03 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2481216rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:46:02 -0800 (PST)
In-Reply-To: <200711221441.45027.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_uZgRHAh+/Mx75/g
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> Patches start from 5 because pathches 1..4 are already
> in cryptodev-2.6.
>
> camellia5:
>         Remove unused macro params.
>         Use (u8)(expr) instead of (expr) & 0xff,
>         helps gcc to realize how to use simpler commands.
>         Move CAMELLIA_FLS macro closer to encrypt/decrypt routines.
>

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_uZgRHAh+/Mx75/g
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia5.diff"

diff -urpN cryptodev-2.6/crypto/camellia.c cryptodev-2.6.camellia5/crypto/camellia.c
--- cryptodev-2.6/crypto/camellia.c	2007-11-21 00:08:44.000000000 -0800
+++ cryptodev-2.6.camellia5/crypto/camellia.c	2007-11-22 14:14:11.000000000 -0800
@@ -310,6 +310,12 @@ static const u32 camellia_sp4404[256] = 
 #define CAMELLIA_BLOCK_SIZE          16
 #define CAMELLIA_TABLE_BYTE_LEN     272
 
+/*
+ * NB: L and R below stand for 'left' and 'right' as in written numbers.
+ * That is, in (xxxL,xxxR) pair xxxL holds most significant digits,
+ * _not_ least significant ones!
+ */
+
 
 /* key constants */
 
@@ -329,8 +335,7 @@ static const u32 camellia_sp4404[256] = 
 /*
  *  macros
  */
-
-# define GETU32(v, pt) \
+#define GETU32(v, pt) \
     do { \
 	/* latest breed of gcc is clever enough to use move */ \
 	memcpy(&(v), (pt), 4); \
@@ -363,64 +368,25 @@ static const u32 camellia_sp4404[256] = 
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
 
@@ -1000,6 +966,41 @@ static void camellia_setup192(const unsi
 }
 
 
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
+
 static void camellia_encrypt128(const u32 *subkey, u32 *io_text)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
@@ -1015,22 +1016,22 @@ static void camellia_encrypt128(const u3
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
@@ -1039,22 +1040,22 @@ static void camellia_encrypt128(const u3
 
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
@@ -1063,22 +1064,22 @@ static void camellia_encrypt128(const u3
 
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
@@ -1102,22 +1103,22 @@ static void camellia_decrypt128(const u3
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
@@ -1126,22 +1127,22 @@ static void camellia_decrypt128(const u3
 
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
@@ -1150,22 +1151,22 @@ static void camellia_decrypt128(const u3
 
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
@@ -1189,22 +1190,22 @@ static void camellia_encrypt256(const u3
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
@@ -1213,22 +1214,22 @@ static void camellia_encrypt256(const u3
 
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
@@ -1237,22 +1238,22 @@ static void camellia_encrypt256(const u3
 
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
@@ -1261,22 +1262,22 @@ static void camellia_encrypt256(const u3
 
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
@@ -1300,22 +1301,22 @@ static void camellia_decrypt256(const u3
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
@@ -1324,22 +1325,22 @@ static void camellia_decrypt256(const u3
 
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
@@ -1348,22 +1349,22 @@ static void camellia_decrypt256(const u3
 
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
@@ -1372,22 +1373,22 @@ static void camellia_decrypt256(const u3
 
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
@@ -1399,7 +1400,7 @@ static void camellia_decrypt256(const u3
 
 struct camellia_ctx {
 	int key_length;
-	u32 key_table[CAMELLIA_TABLE_BYTE_LEN / 4];
+	u32 key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(u32)];
 };
 
 static int

--Boundary-00=_uZgRHAh+/Mx75/g--
