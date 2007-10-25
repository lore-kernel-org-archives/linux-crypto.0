From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/5] camellia: cleanup
Date: Thu, 25 Oct 2007 12:46:35 +0100
Message-ID: <200710251246.35917.vda.linux@googlemail.com>
References: <200710251243.58701.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bIIIH9Z4UmGnF6z"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:23650 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbXJYLqn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2007 07:46:43 -0400
Received: by nf-out-0910.google.com with SMTP id g13so459054nfb
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2007 04:46:41 -0700 (PDT)
In-Reply-To: <200710251243.58701.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_bIIIH9Z4UmGnF6z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> Hi Hervert,
> 
> Please review and maybe propagate upstream following patches.
> 
> camellia3.diff
>     Optimize GETU32 to use 4-byte memcpy (modern gcc will convert
>     such memcpy to single move instruction on i386).
>     Original GETU32 did four byte fetches, and shifted/XORed those.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_bIIIH9Z4UmGnF6z
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="camellia3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="camellia3.diff"

--- linux-2.6.23.src/crypto/camellia2.c	2007-10-24 19:03:22.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia.c	2007-10-24 19:03:27.000000000 +0100
@@ -330,10 +330,12 @@ static const u32 camellia_sp4404[256] = 
  *  macros
  */
 
-# define GETU32(pt) (((u32)(pt)[0] << 24)	\
-		     ^ ((u32)(pt)[1] << 16)	\
-		     ^ ((u32)(pt)[2] <<  8)	\
-		     ^ ((u32)(pt)[3]))
+# define GETU32(v, pt) \
+    do { \
+	/* latest breed of gcc is clever enough to use move */ \
+	memcpy(&(v), (pt), 4); \
+	(v) = be32_to_cpu(v); \
+    } while(0)
 
 /* rotation right shift 1byte */
 #define ROR8(x) (((x) >> 8) + ((x) << 24))
@@ -433,10 +435,11 @@ static void camellia_setup128(const unsi
 	/**
 	 *  k == kll || klr || krl || krr (|| is concatination)
 	 */
-	kll = GETU32(key     );
-	klr = GETU32(key +  4);
-	krl = GETU32(key +  8);
-	krr = GETU32(key + 12);
+	GETU32(kll, key     );
+	GETU32(klr, key +  4);
+	GETU32(krl, key +  8);
+	GETU32(krr, key + 12);
+
 	/**
 	 * generate KL dependent subkeys
 	 */
@@ -687,8 +690,8 @@ static void camellia_setup128(const unsi
 
 static void camellia_setup256(const unsigned char *key, u32 *subkey)
 {
-	u32 kll,klr,krl,krr;           /* left half of key */
-	u32 krll,krlr,krrl,krrr;       /* right half of key */
+	u32 kll, klr, krl, krr;        /* left half of key */
+	u32 krll, krlr, krrl, krrr;    /* right half of key */
 	u32 il, ir, t0, t1, w0, w1;    /* temporary variables */
 	u32 kw4l, kw4r, dw, tl, tr;
 	u32 subL[34];
@@ -698,14 +701,14 @@ static void camellia_setup256(const unsi
 	 *  key = (kll || klr || krl || krr || krll || krlr || krrl || krrr)
 	 *  (|| is concatination)
 	 */
-	kll  = GETU32(key     );
-	klr  = GETU32(key +  4);
-	krl  = GETU32(key +  8);
-	krr  = GETU32(key + 12);
-	krll = GETU32(key + 16);
-	krlr = GETU32(key + 20);
-	krrl = GETU32(key + 24);
-	krrr = GETU32(key + 28);
+	GETU32(kll,  key     );
+	GETU32(klr,  key +  4);
+	GETU32(krl,  key +  8);
+	GETU32(krr,  key + 12);
+	GETU32(krll, key + 16);
+	GETU32(krlr, key + 20);
+	GETU32(krrl, key + 24);
+	GETU32(krrr, key + 28);
 
 	/* generate KL dependent subkeys */
 	/* kw1 */

--Boundary-00=_bIIIH9Z4UmGnF6z--
