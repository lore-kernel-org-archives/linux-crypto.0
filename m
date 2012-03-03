From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] camellia: simplify key setup and CAMELLIA_ROUNDSM macro
Date: Sat, 03 Mar 2012 13:59:00 +0200
Message-ID: <20120303115900.25935.68751.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34926 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2CCL7E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Mar 2012 06:59:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

camellia_setup_tail() applies 'inverse of the last half of P-function' to
subkeys, which is unneeded if keys are applied directly to yl/yr in
CAMELLIA_ROUNDSM.

Patch speeds up key setup and should speed up CAMELLIA_ROUNDSM as applying
key to yl/yr early has less register dependencies.

Quick tcrypt camellia results:
 x86_64, AMD Phenom II, ~5% faster
 x86_64, Intel Core 2, ~0.5% faster
 i386, Intel Atom N270, ~1% faster

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/camellia.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/crypto/camellia.c b/crypto/camellia.c
index 64cff46..7ae4bcd 100644
--- a/crypto/camellia.c
+++ b/crypto/camellia.c
@@ -382,7 +382,6 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 {
 	u32 dw, tl, tr;
 	u32 kw4l, kw4r;
-	int i;
 
 	/* absorb kw2 to other subkeys */
 	/* round 2 */
@@ -557,24 +556,6 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_L(32) = subL[32] ^ subL[31]; /* kw3 */
 		SUBKEY_R(32) = subR[32] ^ subR[31];
 	}
-
-	/* apply the inverse of the last half of P-function */
-	i = 2;
-	do {
-		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = rol32(dw, 8);/* round 1 */
-		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
-		dw = SUBKEY_L(i + 1) ^ SUBKEY_R(i + 1); dw = rol32(dw, 8);/* round 2 */
-		SUBKEY_R(i + 1) = SUBKEY_L(i + 1) ^ dw; SUBKEY_L(i + 1) = dw;
-		dw = SUBKEY_L(i + 2) ^ SUBKEY_R(i + 2); dw = rol32(dw, 8);/* round 3 */
-		SUBKEY_R(i + 2) = SUBKEY_L(i + 2) ^ dw; SUBKEY_L(i + 2) = dw;
-		dw = SUBKEY_L(i + 3) ^ SUBKEY_R(i + 3); dw = rol32(dw, 8);/* round 4 */
-		SUBKEY_R(i + 3) = SUBKEY_L(i + 3) ^ dw; SUBKEY_L(i + 3) = dw;
-		dw = SUBKEY_L(i + 4) ^ SUBKEY_R(i + 4); dw = rol32(dw, 8);/* round 5 */
-		SUBKEY_R(i + 4) = SUBKEY_L(i + 4) ^ dw; SUBKEY_L(i + 4) = dw;
-		dw = SUBKEY_L(i + 5) ^ SUBKEY_R(i + 5); dw = rol32(dw, 8);/* round 6 */
-		SUBKEY_R(i + 5) = SUBKEY_L(i + 5) ^ dw; SUBKEY_L(i + 5) = dw;
-		i += 8;
-	} while (i < max);
 }
 
 static void camellia_setup128(const unsigned char *key, u32 *subkey)
@@ -869,6 +850,8 @@ static void camellia_setup192(const unsigned char *key, u32 *subkey)
 
 #define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
     do {								\
+	yl ^= kl;							\
+	yr ^= kr;							\
 	ir =  camellia_sp1110[(u8)xr];					\
 	il =  camellia_sp1110[    (xl >> 24)];				\
 	ir ^= camellia_sp0222[    (xr >> 24)];				\
@@ -877,8 +860,7 @@ static void camellia_setup192(const unsigned char *key, u32 *subkey)
 	il ^= camellia_sp3033[(u8)(xl >> 8)];				\
 	ir ^= camellia_sp4404[(u8)(xr >> 8)];				\
 	il ^= camellia_sp4404[(u8)xl];					\
-	il ^= kl;							\
-	ir ^= il ^ kr;							\
+	ir ^= il;							\
 	yl ^= ir;							\
 	yr ^= ror32(il, 8) ^ ir;						\
     } while (0)
