From: Aditya Shevade <aditya.shevade@gmail.com>
Subject: [PATCH] crypto: blowfish: Fixed a multi line macro issue
Date: Wed,  6 Apr 2011 23:49:20 -0700
Message-ID: <1302158960-20479-1-git-send-email-aditya.shevade@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Aditya Shevade <aditya.shevade@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1DGGt4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Apr 2011 02:49:56 -0400
Received: by iyb14 with SMTP id 14so2159078iyb.19
        for <linux-crypto@vger.kernel.org>; Wed, 06 Apr 2011 23:49:55 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed a multi line macro with do-while loop.
Fixed some other minor tab related issues.

Signed-off-by: Aditya Shevade <aditya.shevade@gmail.com>
---
 crypto/blowfish.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index a67d52e..5d9bc2e 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -309,9 +309,13 @@ static const u32 bf_sbox[256 * 4] = {
 #define GET32_0(x) (((x) >> (24)) & (0xff))
 
 #define bf_F(x) (((S[GET32_0(x)] + S[256 + GET32_1(x)]) ^ \
-          S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
+	S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
 
-#define ROUND(a, b, n)  b ^= P[n]; a ^= bf_F (b)
+#define ROUND(a, b, n)  \
+	do { \
+		b ^= P[n]; \
+		a ^= bf_F(b) \
+	} while (0)
 
 /*
  * The blowfish encipher, processes 64-bit blocks.
@@ -460,9 +464,9 @@ static struct crypto_alg alg = {
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	BF_MIN_KEY_SIZE,
 	.cia_max_keysize	=	BF_MAX_KEY_SIZE,
-	.cia_setkey   		= 	bf_setkey,
-	.cia_encrypt 		=	bf_encrypt,
-	.cia_decrypt  		=	bf_decrypt } }
+	.cia_setkey		=	bf_setkey,
+	.cia_encrypt		=	bf_encrypt,
+	.cia_decrypt		=	bf_decrypt } }
 };
 
 static int __init blowfish_mod_init(void)
-- 
1.7.4.3
