From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 1/2] crypto: sahara: fix type of ret for wait_for_completion_timeout
Date: Sat,  7 Feb 2015 06:17:13 -0500
Message-ID: <1423307833-25546-1-git-send-email-hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:41260 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbbBGLVX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Feb 2015 06:21:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

return type of wait_for_completion_timeout is unsigned long not int, this
patch adds appropriate variables of type unsigned long.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

As ret is in used here for other calls a new variable of appropriate 
type is added.

Patch was only compile tested with imx_v4_v5_defconfig
CONFIG_CRYPTO_HW=y, CONFIG_CRYPTO_DEV_SAHARA=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/crypto/sahara.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 290a7f0..57b4fce 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -576,6 +576,7 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 	struct sahara_ctx *ctx;
 	struct sahara_aes_reqctx *rctx;
 	int ret;
+	unsigned long timeout;
 
 	/* Request is ready to be dispatched by the device */
 	dev_dbg(dev->device,
@@ -602,9 +603,9 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 
 	ret = sahara_hw_descriptor_create(dev);
 
-	ret = wait_for_completion_timeout(&dev->dma_completion,
+	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!ret) {
+	if (!timeout) {
 		dev_err(dev->device, "AES timeout\n");
 		return -ETIMEDOUT;
 	}
@@ -1045,6 +1046,7 @@ static int sahara_sha_process(struct ahash_request *req)
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
 	int ret = -EINPROGRESS;
+	unsigned long timeout;
 
 	ret = sahara_sha_prepare_request(req);
 	if (!ret)
@@ -1070,9 +1072,9 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	sahara_write(dev, dev->hw_phys_desc[0], SAHARA_REG_DAR);
 
-	ret = wait_for_completion_timeout(&dev->dma_completion,
+	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!ret) {
+	if (!timeout) {
 		dev_err(dev->device, "SHA timeout\n");
 		return -ETIMEDOUT;
 	}
-- 
1.7.10.4
