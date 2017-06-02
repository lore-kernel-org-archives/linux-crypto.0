From: David Gstir <david@sigma-star.at>
Subject: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Fri,  2 Jun 2017 14:24:45 +0200
Message-ID: <20170602122446.2427-2-david@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
Cc: richard@sigma-star.at, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gstir <david@sigma-star.at>
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602122446.2427-1-david@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Certain cipher modes like CTS expect the IV (req->info) of
ablkcipher_request (or equivalently req->iv of skcipher_request) to
contain the last ciphertext block when the {en,de}crypt operation is done.
This is currently not the case for the CAAM driver which in turn breaks
e.g. cts(cbc(aes)) when the CAAM driver is enabled.

This patch fixes the CAAM driver to properly set the IV after the
{en,de}crypt operation of ablkcipher finishes.

Signed-off-by: David Gstir <david@sigma-star.at>
---
 drivers/crypto/caam/caamalg.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 398807d1b77e..d13c1aee4427 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -882,10 +882,11 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
-#ifdef DEBUG
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	int nents;
 
+#ifdef DEBUG
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
@@ -904,6 +905,19 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
+
+	if (req->src == req->dst)
+		nents = edesc->src_nents;
+	else
+		nents = edesc->dst_nents;
+
+	/*
+	 * The crypto API expects us to set the IV (req->info) to the last
+	 * ciphertext block. This is used e.g. by the CTS mode.
+	 */
+	sg_pcopy_to_buffer(req->dst, nents, req->info, ivsize,
+			   req->nbytes - ivsize);
+
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
@@ -914,10 +928,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
-#ifdef DEBUG
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
+#ifdef DEBUG
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
@@ -935,6 +949,14 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
+
+	/*
+	 * The crypto API expects us to set the IV (req->info) to the last
+	 * ciphertext block.
+	 */
+	sg_pcopy_to_buffer(req->src, edesc->src_nents, req->info, ivsize,
+			   req->nbytes - ivsize);
+
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
-- 
2.12.0
