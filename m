From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/5] camellia: code shrink #3
Date: Thu, 22 Nov 2007 14:43:55 -0800
Message-ID: <200711221443.55302.vda.linux@googlemail.com>
References: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rYgRHvmQhPCkOcm"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:49035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXKVWp6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:45:58 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2481199rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:45:58 -0800 (PST)
In-Reply-To: <200711221441.45027.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_rYgRHvmQhPCkOcm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> camellia7:
>         Move "key XOR is end of F-function" code part into
>         camellia_setup_tail(), it is sufficiently similar
>         between camellia_setup128 and camellia_setup256.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com> 
--
vda

--Boundary-00=_rYgRHvmQhPCkOcm
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia7.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia7.diff"

diff -urpN cryptodev-2.6.camellia6/crypto/camellia.c cryptodev-2.6.camellia7/crypto/camellia.c
--- cryptodev-2.6.camellia6/crypto/camellia.c	2007-11-22 14:20:03.000000000 -0800
+++ cryptodev-2.6.camellia7/crypto/camellia.c	2007-11-22 14:19:58.000000000 -0800
@@ -390,10 +390,104 @@ static const u32 camellia_sp4404[256] = 
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
@@ -415,21 +509,19 @@ static void camellia_setup128(const unsi
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
@@ -574,70 +666,7 @@ static void camellia_setup128(const unsi
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
@@ -645,13 +674,13 @@ static void camellia_setup256(const unsi
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
@@ -862,92 +891,7 @@ static void camellia_setup256(const unsi
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

--Boundary-00=_rYgRHvmQhPCkOcm--
