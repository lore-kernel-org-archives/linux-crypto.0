From: David Gstir <david@sigma-star.at>
Subject: [PATCH] crypto: caam - properly set IV after {en,de}crypt
Date: Wed, 28 Jun 2017 15:27:10 +0200
Message-ID: <20170628132710.97278-1-david@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
Cc: richard@sigma-star.at, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gstir <david@sigma-star.at>,
        stable@vger.kernel.org
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdF1N1l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 09:27:41 -0400
In-Reply-To: <20170602122446.2427-1-david@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Certain cipher modes like CTS expect the IV (req->info) of
ablkcipher_request (or equivalently req->iv of skcipher_request) to
contain the last ciphertext block when the {en,de}crypt operation is done.
This is currently not the case for the CAAM driver which in turn breaks
e.g. cts(cbc(aes)) when the CAAM driver is enabled.

This patch fixes the CAAM driver to properly set the IV after the
{en,de}crypt operation of ablkcipher finishes.

This issue was revealed by the changes in the SW CTS mode in commit
0605c41cc53ca ("crypto: cts - Convert to skcipher")

Cc: <stable@vger.kernel.org> # 4.8+
Signed-off-by: David Gstir <david@sigma-star.at>
---
 drivers/crypto/caam/caamalg.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 398807d1b77e..c45b5bf65254 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -882,10 +882,10 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
-#ifdef DEBUG
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
+#ifdef DEBUG
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
@@ -904,6 +904,14 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
+
+	/*
+	 * The crypto API expects us to set the IV (req->info) to the last
+	 * ciphertext block. This is used e.g. by the CTS mode.
+	 */
+	scatterwalk_map_and_copy(req->info, req->dst, req->nbytes - ivsize,
+				 ivsize, 0);
+
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
@@ -914,10 +922,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
-#ifdef DEBUG
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
+#ifdef DEBUG
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
@@ -935,6 +943,14 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
+
+	/*
+	 * The crypto API expects us to set the IV (req->info) to the last
+	 * ciphertext block.
+	 */
+	scatterwalk_map_and_copy(req->info, req->src, req->nbytes - ivsize,
+				 ivsize, 0);
+
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
-- 
2.12.3
