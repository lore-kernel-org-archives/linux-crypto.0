From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] crypto: sahara: drop unnecessary default assignment
Date: Sat,  7 Feb 2015 06:16:46 -0500
Message-ID: <1423307806-25507-1-git-send-email-hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:41251 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbbBGLVB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Feb 2015 06:21:01 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All possible code-paths will assign ret to suitable values so this
default value is not needed.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with imx_v4_v5_defconfig
CONFIG_CRYPTO_HW=y, CONFIG_CRYPTO_DEV_SAHARA=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/crypto/sahara.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 57b4fce..8379b44 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1045,7 +1045,7 @@ static int sahara_sha_process(struct ahash_request *req)
 {
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
-	int ret = -EINPROGRESS;
+	int ret;
 	unsigned long timeout;
 
 	ret = sahara_sha_prepare_request(req);
-- 
1.7.10.4
