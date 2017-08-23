From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [BUGFIX PATCH v2] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 12:12:05 +0300
Message-ID: <1503479525-23947-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:53736 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753513AbdHWJMM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 05:12:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto API requires saving the last blocks of ciphertext
in req->info for use as IV for CTS mode. The ccree driver
was not doing this. This patch fixes that.

The bug was manifested with cts(cbc(aes)) mode in tcrypt tests.

Fixes: 302ef8ebb4b2 ("Add CryptoCell skcipher support")
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

Changes from v1:
- Free memory on error path, as pointed out by Stephan Mueller.

 drivers/staging/ccree/ssi_cipher.c | 40 ++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index af9afea..8d31a93 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -24,6 +24,7 @@
 #include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/xts.h>
+#include <crypto/scatterwalk.h>
 
 #include "ssi_config.h"
 #include "ssi_driver.h"
@@ -697,6 +698,7 @@ static int ssi_blkcipher_complete(struct device *dev,
 {
 	int completion_error = 0;
 	u32 inflight_counter;
+	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
 
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 
@@ -707,6 +709,22 @@ static int ssi_blkcipher_complete(struct device *dev,
 		ctx_p->drvdata->inflight_counter--;
 
 	if (areq) {
+		/*
+		 * The crypto API expects us to set the req->info to the last
+		 * ciphertext block. For encrypt, simply copy from the result.
+		 * For decrypt, we must copy from a saved buffer since this
+		 * could be an in-place decryption operation and the src is
+		 * lost by this point.
+		 */
+		if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
+			memcpy(req->info, req_ctx->backup_info, ivsize);
+			kfree(req_ctx->backup_info);
+		} else {
+			scatterwalk_map_and_copy(req->info, req->dst,
+						 (req->nbytes - ivsize),
+						 ivsize, 0);
+		}
+
 		ablkcipher_request_complete(areq, completion_error);
 		return 0;
 	}
@@ -739,11 +757,13 @@ static int ssi_blkcipher_process(
 	if (unlikely(validate_data_size(ctx_p, nbytes))) {
 		SSI_LOG_ERR("Unsupported data size %d.\n", nbytes);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto exit_process;
 	}
 	if (nbytes == 0) {
 		/* No data to process is valid */
-		return 0;
+		rc = 0;
+		goto exit_process;
 	}
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
 	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
@@ -818,6 +838,9 @@ static int ssi_blkcipher_process(
 	if (cts_restore_flag != 0)
 		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
 
+	if (rc != -EINPROGRESS)
+		kfree(req_ctx->backup_info);
+
 	return rc;
 }
 
@@ -858,7 +881,6 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
-	req_ctx->backup_info = req->info;
 	req_ctx->is_giv = false;
 
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
@@ -871,8 +893,18 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
-	req_ctx->backup_info = req->info;
+	/*
+	 * Allocate and save the last IV sized bytes of the source, which will
+	 * be lost in case of in-place decryption and might be needed for CTS.
+	 */
+	req_ctx->backup_info = kmalloc(ivsize, GFP_KERNEL);
+	if (!req_ctx->backup_info)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
+				 (req->nbytes - ivsize), ivsize, 0);
 	req_ctx->is_giv = false;
+
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
-- 
2.1.4
