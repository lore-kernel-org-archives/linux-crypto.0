From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/5] camellia: code shrink #4
Date: Thu, 22 Nov 2007 14:44:24 -0800
Message-ID: <200711221444.24172.vda.linux@googlemail.com>
References: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IZgRHm9UGMsauGG"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:49035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXKVWqA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:46:00 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2481199rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:46:00 -0800 (PST)
In-Reply-To: <200711221441.45027.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_IZgRHm9UGMsauGG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> camellia8:
>         Analogously to camellia7 patch, move
>         "absorb kw2 to other subkeys" and "absorb kw4 to other subkeys"
>         code parts into camellia_setup_tail(). This further reduces
>         source and object code size at the cost of two brances
>         in key setup code.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com> 
--
vda

--Boundary-00=_IZgRHm9UGMsauGG
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia8.diff"

diff -urpN cryptodev-2.6.camellia7/crypto/camellia.c cryptodev-2.6.camellia8/crypto/camellia.c
--- cryptodev-2.6.camellia7/crypto/camellia.c	2007-11-22 14:19:58.000000000 -0800
+++ cryptodev-2.6.camellia8/crypto/camellia.c	2007-11-22 14:19:54.000000000 -0800
@@ -393,8 +393,92 @@ static const u32 camellia_sp4404[256] = 
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
@@ -509,7 +593,6 @@ static void camellia_setup128(const unsi
 {
 	u32 kll, klr, krl, krr;
 	u32 il, ir, t0, t1, w0, w1;
-	u32 kw4l, kw4r, dw;
 	u32 subL[26];
 	u32 subR[26];
 
@@ -609,63 +692,6 @@ static void camellia_setup128(const unsi
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
 
@@ -674,7 +700,6 @@ static void camellia_setup256(const unsi
 	u32 kll, klr, krl, krr;        /* left half of key */
 	u32 krll, krlr, krrl, krrr;    /* right half of key */
 	u32 il, ir, t0, t1, w0, w1;    /* temporary variables */
-	u32 kw4l, kw4r, dw;
 	u32 subL[34];
 	u32 subR[34];
 
@@ -816,81 +841,6 @@ static void camellia_setup256(const unsi
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
 

--Boundary-00=_IZgRHm9UGMsauGG--
