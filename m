From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/5] camellia: de-unrolling
Date: Thu, 25 Oct 2007 12:47:16 +0100
Message-ID: <200710251247.16843.vda.linux@googlemail.com>
References: <200710251243.58701.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EJIIHQWjWl3Fm1m"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:25792 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbXJYLrY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2007 07:47:24 -0400
Received: by nf-out-0910.google.com with SMTP id g13so459246nfb
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2007 04:47:22 -0700 (PDT)
In-Reply-To: <200710251243.58701.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_EJIIHQWjWl3Fm1m
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> Hi Hervert,
> 
> Please review and maybe propagate upstream following patches.
> 
> camellia4.diff
>     Move huge unrolled pieces of code (3 screenfuls) at the end of
>     128/256 key setup routines into common camellia_setup_tail(),
>     convert it to loop there.
>     Loop is still unrolled six times, so performance hit is very small,
>     code size win is big.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_EJIIHQWjWl3Fm1m
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="camellia4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="camellia4.diff"

--- linux-2.6.23.src/crypto/camellia3.c	2007-10-24 19:03:27.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia.c	2007-10-24 19:03:57.000000000 +0100
@@ -424,6 +424,27 @@ static const u32 camellia_sp4404[256] = 
 #define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
 #define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
+static void camellia_setup_tail(u32 *subkey, int max)
+{
+	u32 dw;
+	int i = 2;
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
 static void camellia_setup128(const unsigned char *key, u32 *subkey)
 {
 	u32 kll, klr, krl, krr;
@@ -650,42 +671,7 @@ static void camellia_setup128(const unsi
 	SUBKEY_R(24) = subR[24] ^ subR[23];
 
 	/* apply the inverse of the last half of P-function */
-	dw = SUBKEY_L(2) ^ SUBKEY_R(2); dw = ROL8(dw);/* round 1 */
-	SUBKEY_R(2) = SUBKEY_L(2) ^ dw; SUBKEY_L(2) = dw;
-	dw = SUBKEY_L(3) ^ SUBKEY_R(3); dw = ROL8(dw);/* round 2 */
-	SUBKEY_R(3) = SUBKEY_L(3) ^ dw; SUBKEY_L(3) = dw;
-	dw = SUBKEY_L(4) ^ SUBKEY_R(4); dw = ROL8(dw);/* round 3 */
-	SUBKEY_R(4) = SUBKEY_L(4) ^ dw; SUBKEY_L(4) = dw;
-	dw = SUBKEY_L(5) ^ SUBKEY_R(5); dw = ROL8(dw);/* round 4 */
-	SUBKEY_R(5) = SUBKEY_L(5) ^ dw; SUBKEY_L(5) = dw;
-	dw = SUBKEY_L(6) ^ SUBKEY_R(6); dw = ROL8(dw);/* round 5 */
-	SUBKEY_R(6) = SUBKEY_L(6) ^ dw; SUBKEY_L(6) = dw;
-	dw = SUBKEY_L(7) ^ SUBKEY_R(7); dw = ROL8(dw);/* round 6 */
-	SUBKEY_R(7) = SUBKEY_L(7) ^ dw; SUBKEY_L(7) = dw;
-	dw = SUBKEY_L(10) ^ SUBKEY_R(10); dw = ROL8(dw);/* round 7 */
-	SUBKEY_R(10) = SUBKEY_L(10) ^ dw; SUBKEY_L(10) = dw;
-	dw = SUBKEY_L(11) ^ SUBKEY_R(11); dw = ROL8(dw);/* round 8 */
-	SUBKEY_R(11) = SUBKEY_L(11) ^ dw; SUBKEY_L(11) = dw;
-	dw = SUBKEY_L(12) ^ SUBKEY_R(12); dw = ROL8(dw);/* round 9 */
-	SUBKEY_R(12) = SUBKEY_L(12) ^ dw; SUBKEY_L(12) = dw;
-	dw = SUBKEY_L(13) ^ SUBKEY_R(13); dw = ROL8(dw);/* round 10 */
-	SUBKEY_R(13) = SUBKEY_L(13) ^ dw; SUBKEY_L(13) = dw;
-	dw = SUBKEY_L(14) ^ SUBKEY_R(14); dw = ROL8(dw);/* round 11 */
-	SUBKEY_R(14) = SUBKEY_L(14) ^ dw; SUBKEY_L(14) = dw;
-	dw = SUBKEY_L(15) ^ SUBKEY_R(15); dw = ROL8(dw);/* round 12 */
-	SUBKEY_R(15) = SUBKEY_L(15) ^ dw; SUBKEY_L(15) = dw;
-	dw = SUBKEY_L(18) ^ SUBKEY_R(18); dw = ROL8(dw);/* round 13 */
-	SUBKEY_R(18) = SUBKEY_L(18) ^ dw; SUBKEY_L(18) = dw;
-	dw = SUBKEY_L(19) ^ SUBKEY_R(19); dw = ROL8(dw);/* round 14 */
-	SUBKEY_R(19) = SUBKEY_L(19) ^ dw; SUBKEY_L(19) = dw;
-	dw = SUBKEY_L(20) ^ SUBKEY_R(20); dw = ROL8(dw);/* round 15 */
-	SUBKEY_R(20) = SUBKEY_L(20) ^ dw; SUBKEY_L(20) = dw;
-	dw = SUBKEY_L(21) ^ SUBKEY_R(21); dw = ROL8(dw);/* round 16 */
-	SUBKEY_R(21) = SUBKEY_L(21) ^ dw; SUBKEY_L(21) = dw;
-	dw = SUBKEY_L(22) ^ SUBKEY_R(22); dw = ROL8(dw);/* round 17 */
-	SUBKEY_R(22) = SUBKEY_L(22) ^ dw; SUBKEY_L(22) = dw;
-	dw = SUBKEY_L(23) ^ SUBKEY_R(23); dw = ROL8(dw);/* round 18 */
-	SUBKEY_R(23) = SUBKEY_L(23) ^ dw; SUBKEY_L(23) = dw;
+	camellia_setup_tail(subkey, 24);
 }
 
 static void camellia_setup256(const unsigned char *key, u32 *subkey)
@@ -995,54 +981,7 @@ static void camellia_setup256(const unsi
 	SUBKEY_R(32) = subR[32] ^ subR[31];
 
 	/* apply the inverse of the last half of P-function */
-	dw = SUBKEY_L(2) ^ SUBKEY_R(2); dw = ROL8(dw);/* round 1 */
-	SUBKEY_R(2) = SUBKEY_L(2) ^ dw; SUBKEY_L(2) = dw;
-	dw = SUBKEY_L(3) ^ SUBKEY_R(3); dw = ROL8(dw);/* round 2 */
-	SUBKEY_R(3) = SUBKEY_L(3) ^ dw; SUBKEY_L(3) = dw;
-	dw = SUBKEY_L(4) ^ SUBKEY_R(4); dw = ROL8(dw);/* round 3 */
-	SUBKEY_R(4) = SUBKEY_L(4) ^ dw; SUBKEY_L(4) = dw;
-	dw = SUBKEY_L(5) ^ SUBKEY_R(5); dw = ROL8(dw);/* round 4 */
-	SUBKEY_R(5) = SUBKEY_L(5) ^ dw; SUBKEY_L(5) = dw;
-	dw = SUBKEY_L(6) ^ SUBKEY_R(6); dw = ROL8(dw);/* round 5 */
-	SUBKEY_R(6) = SUBKEY_L(6) ^ dw; SUBKEY_L(6) = dw;
-	dw = SUBKEY_L(7) ^ SUBKEY_R(7); dw = ROL8(dw);/* round 6 */
-	SUBKEY_R(7) = SUBKEY_L(7) ^ dw; SUBKEY_L(7) = dw;
-	dw = SUBKEY_L(10) ^ SUBKEY_R(10); dw = ROL8(dw);/* round 7 */
-	SUBKEY_R(10) = SUBKEY_L(10) ^ dw; SUBKEY_L(10) = dw;
-	dw = SUBKEY_L(11) ^ SUBKEY_R(11); dw = ROL8(dw);/* round 8 */
-	SUBKEY_R(11) = SUBKEY_L(11) ^ dw; SUBKEY_L(11) = dw;
-	dw = SUBKEY_L(12) ^ SUBKEY_R(12); dw = ROL8(dw);/* round 9 */
-	SUBKEY_R(12) = SUBKEY_L(12) ^ dw; SUBKEY_L(12) = dw;
-	dw = SUBKEY_L(13) ^ SUBKEY_R(13); dw = ROL8(dw);/* round 10 */
-	SUBKEY_R(13) = SUBKEY_L(13) ^ dw; SUBKEY_L(13) = dw;
-	dw = SUBKEY_L(14) ^ SUBKEY_R(14); dw = ROL8(dw);/* round 11 */
-	SUBKEY_R(14) = SUBKEY_L(14) ^ dw; SUBKEY_L(14) = dw;
-	dw = SUBKEY_L(15) ^ SUBKEY_R(15); dw = ROL8(dw);/* round 12 */
-	SUBKEY_R(15) = SUBKEY_L(15) ^ dw; SUBKEY_L(15) = dw;
-	dw = SUBKEY_L(18) ^ SUBKEY_R(18); dw = ROL8(dw);/* round 13 */
-	SUBKEY_R(18) = SUBKEY_L(18) ^ dw; SUBKEY_L(18) = dw;
-	dw = SUBKEY_L(19) ^ SUBKEY_R(19); dw = ROL8(dw);/* round 14 */
-	SUBKEY_R(19) = SUBKEY_L(19) ^ dw; SUBKEY_L(19) = dw;
-	dw = SUBKEY_L(20) ^ SUBKEY_R(20); dw = ROL8(dw);/* round 15 */
-	SUBKEY_R(20) = SUBKEY_L(20) ^ dw; SUBKEY_L(20) = dw;
-	dw = SUBKEY_L(21) ^ SUBKEY_R(21); dw = ROL8(dw);/* round 16 */
-	SUBKEY_R(21) = SUBKEY_L(21) ^ dw; SUBKEY_L(21) = dw;
-	dw = SUBKEY_L(22) ^ SUBKEY_R(22); dw = ROL8(dw);/* round 17 */
-	SUBKEY_R(22) = SUBKEY_L(22) ^ dw; SUBKEY_L(22) = dw;
-	dw = SUBKEY_L(23) ^ SUBKEY_R(23); dw = ROL8(dw);/* round 18 */
-	SUBKEY_R(23) = SUBKEY_L(23) ^ dw; SUBKEY_L(23) = dw;
-	dw = SUBKEY_L(26) ^ SUBKEY_R(26); dw = ROL8(dw);/* round 19 */
-	SUBKEY_R(26) = SUBKEY_L(26) ^ dw; SUBKEY_L(26) = dw;
-	dw = SUBKEY_L(27) ^ SUBKEY_R(27); dw = ROL8(dw);/* round 20 */
-	SUBKEY_R(27) = SUBKEY_L(27) ^ dw; SUBKEY_L(27) = dw;
-	dw = SUBKEY_L(28) ^ SUBKEY_R(28); dw = ROL8(dw);/* round 21 */
-	SUBKEY_R(28) = SUBKEY_L(28) ^ dw; SUBKEY_L(28) = dw;
-	dw = SUBKEY_L(29) ^ SUBKEY_R(29); dw = ROL8(dw);/* round 22 */
-	SUBKEY_R(29) = SUBKEY_L(29) ^ dw; SUBKEY_L(29) = dw;
-	dw = SUBKEY_L(30) ^ SUBKEY_R(30); dw = ROL8(dw);/* round 23 */
-	SUBKEY_R(30) = SUBKEY_L(30) ^ dw; SUBKEY_L(30) = dw;
-	dw = SUBKEY_L(31) ^ SUBKEY_R(31); dw = ROL8(dw);/* round 24 */
-	SUBKEY_R(31) = SUBKEY_L(31) ^ dw; SUBKEY_L(31) = dw;
+	camellia_setup_tail(subkey, 32);
 }
 
 static void camellia_setup192(const unsigned char *key, u32 *subkey)

--Boundary-00=_EJIIHQWjWl3Fm1m--
