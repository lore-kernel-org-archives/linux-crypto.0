From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/4] camellia: code shrink 3
Date: Wed, 21 Nov 2007 00:32:50 -0800
Message-ID: <200711210032.50790.vda.linux@googlemail.com>
References: <200711210022.28510.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_y0+QHxBkDPe7klm"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:23990 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbXKUIdG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 03:33:06 -0500
Received: by py-out-1112.google.com with SMTP id u77so7044847pyb
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 00:33:00 -0800 (PST)
In-Reply-To: <200711210022.28510.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_y0+QHxBkDPe7klm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 21 November 2007 00:22, Denys Vlasenko wrote:
> camellia8:
>         Analogously to camellia7 patch, move
>         "absorb kw2 to other subkeys" and "absorb kw4 to other subkeys"
>         code parts into camellia_setup_tail(). This further reduces
>         source and object code size at the cost of two brances
>         in key setup code.

I also tried to more more code into tail, but it becomes
more complicated. Up to this point is was straightforward.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>



I noticed that in [PATCH 2/4] and [PATCH 3/4] mails
I attached linux-2.6.23.1xxxxxxxxxx.diff files.

This is not a problem, the patches are actually
identical to cryptodev-2.6xxxxxxxxxxxx.diff ones,
except for leading directory prefix.
I verified that they do apply without rejects,
offsets or fuzz to cryptodev-2.6.
-- 
vda

--Boundary-00=_y0+QHxBkDPe7klm
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia8.diff"

diff -urpN cryptodev-2.6.camellia7/crypto/camellia.c cryptodev-2.6.camellia8/crypto/camellia.c
--- cryptodev-2.6.camellia7/crypto/camellia.c	2007-11-21 00:13:34.000000000 -0800
+++ cryptodev-2.6.camellia8/crypto/camellia.c	2007-11-21 00:14:10.000000000 -0800
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
 

--Boundary-00=_y0+QHxBkDPe7klm--
