From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [BUGFIX PATCH] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 10:41:11 +0300
Message-ID: <1503474071-7049-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The crypto API requires saving the last blocks of ciphertext
in req->info for use as IV for CTS mode. The ccree driver
was not doing this. This patch fixes that.

The bug was manifested with cts(cbc(aes)) mode in tcrypt tests.

Fixes: 302ef8ebb4b2 ("Add CryptoCell skcipher support")
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index af9afea..01011a2 100644
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
@@ -858,7 +876,6 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
-	req_ctx->backup_info = req->info;
 	req_ctx->is_giv = false;
 
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
@@ -871,8 +888,18 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
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
