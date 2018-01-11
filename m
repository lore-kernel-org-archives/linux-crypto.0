From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 3/5] crypto: chelsio - Fix IV updated in XTS operation
Date: Thu, 11 Jan 2018 16:45:50 +0530
Message-ID: <0bb3434cc61d2d2a0b26b049f341c8bfe9a813e2.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:31878 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933764AbeAKLQG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:06 -0500
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Skip decrypt operation on IV received from HW for last request.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 drivers/crypto/chelsio/chcr_algo.c

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
old mode 100644
new mode 100755
index 280377f..27ee920
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1017,7 +1017,8 @@ static unsigned int adjust_ctr_overflow(u8 *iv, u32 bytes)
 	return bytes;
 }
 
-static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv)
+static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv,
+			     u32 isfinal)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
@@ -1044,7 +1045,8 @@ static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv)
 	for (i = 0; i < (round % 8); i++)
 		gf128mul_x_ble((le128 *)iv, (le128 *)iv);
 
-	crypto_cipher_decrypt_one(cipher, iv, iv);
+	if (!isfinal)
+		crypto_cipher_decrypt_one(cipher, iv, iv);
 out:
 	return ret;
 }
@@ -1065,7 +1067,7 @@ static int chcr_update_cipher_iv(struct ablkcipher_request *req,
 			CTR_RFC3686_IV_SIZE) = cpu_to_be32((reqctx->processed /
 						AES_BLOCK_SIZE) + 1);
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_XTS)
-		ret = chcr_update_tweak(req, iv);
+		ret = chcr_update_tweak(req, iv, 0);
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_CBC) {
 		if (reqctx->op)
 			sg_pcopy_to_buffer(req->src, sg_nents(req->src), iv,
@@ -1096,7 +1098,7 @@ static int chcr_final_cipher_iv(struct ablkcipher_request *req,
 		ctr_add_iv(iv, req->info, (reqctx->processed /
 			   AES_BLOCK_SIZE));
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_XTS)
-		ret = chcr_update_tweak(req, iv);
+		ret = chcr_update_tweak(req, iv, 1);
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_CBC) {
 		if (reqctx->op)
 			sg_pcopy_to_buffer(req->src, sg_nents(req->src), iv,
-- 
2.1.4
