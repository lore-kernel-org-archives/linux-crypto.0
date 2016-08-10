From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/6] crypto: sun4i-ss: fix indentation of two crypto alg
Date: Wed, 10 Aug 2016 11:45:34 +0200
Message-ID: <1470822334-20672-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36739 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938820AbcHJS71 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:59:27 -0400
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Two crypto alg are badly indented, this patch fix this style issue.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 68 ++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 107cd2a..3ac6c6c 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -172,45 +172,45 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 },
 {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 	.alg.crypto = {
-			.cra_name = "cbc(des3_ede)",
-			.cra_driver_name = "cbc-des3-sun4i-ss",
-			.cra_priority = 300,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-			.cra_module = THIS_MODULE,
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = sun4i_ss_cipher_init,
-			.cra_u.ablkcipher = {
-				.min_keysize    = DES3_EDE_KEY_SIZE,
-				.max_keysize    = DES3_EDE_KEY_SIZE,
-				.ivsize         = DES3_EDE_BLOCK_SIZE,
-				.setkey         = sun4i_ss_des3_setkey,
-				.encrypt        = sun4i_ss_cbc_des3_encrypt,
-				.decrypt        = sun4i_ss_cbc_des3_decrypt,
+		.cra_name = "cbc(des3_ede)",
+		.cra_driver_name = "cbc-des3-sun4i-ss",
+		.cra_priority = 300,
+		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sun4i_ss_cipher_init,
+		.cra_u.ablkcipher = {
+			.min_keysize    = DES3_EDE_KEY_SIZE,
+			.max_keysize    = DES3_EDE_KEY_SIZE,
+			.ivsize         = DES3_EDE_BLOCK_SIZE,
+			.setkey         = sun4i_ss_des3_setkey,
+			.encrypt        = sun4i_ss_cbc_des3_encrypt,
+			.decrypt        = sun4i_ss_cbc_des3_decrypt,
 		}
 	}
 },
 {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 	.alg.crypto = {
-			.cra_name = "ecb(des3_ede)",
-			.cra_driver_name = "ecb-des3-sun4i-ss",
-			.cra_priority = 300,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-			.cra_module = THIS_MODULE,
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = sun4i_ss_cipher_init,
-			.cra_u.ablkcipher = {
-				.min_keysize    = DES3_EDE_KEY_SIZE,
-				.max_keysize    = DES3_EDE_KEY_SIZE,
-				.ivsize         = DES3_EDE_BLOCK_SIZE,
-				.setkey         = sun4i_ss_des3_setkey,
-				.encrypt        = sun4i_ss_ecb_des3_encrypt,
-				.decrypt        = sun4i_ss_ecb_des3_decrypt,
+		.cra_name = "ecb(des3_ede)",
+		.cra_driver_name = "ecb-des3-sun4i-ss",
+		.cra_priority = 300,
+		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sun4i_ss_cipher_init,
+		.cra_u.ablkcipher = {
+			.min_keysize    = DES3_EDE_KEY_SIZE,
+			.max_keysize    = DES3_EDE_KEY_SIZE,
+			.ivsize         = DES3_EDE_BLOCK_SIZE,
+			.setkey         = sun4i_ss_des3_setkey,
+			.encrypt        = sun4i_ss_ecb_des3_encrypt,
+			.decrypt        = sun4i_ss_ecb_des3_decrypt,
 		}
 	}
 },
-- 
2.7.3
