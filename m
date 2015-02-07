From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 2/2 RFC] crypto: sahara: pass on error condition
Date: Sat,  7 Feb 2015 06:17:26 -0500
Message-ID: <1423307846-25580-1-git-send-email-hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:41269 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbbBGLVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Feb 2015 06:21:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A failure of sahara_hw_descriptor_create() with -EINVAL due to scatter list
out of bounds/invalid would not be reported back. This patch just passes on
the -EINVAL so it is visible in sahara_queue_manage().

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with imx_v4_v5_defconfig
CONFIG_CRYPTO_HW=y, CONFIG_CRYPTO_DEV_SAHARA=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/crypto/sahara.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 0c790be..a9eeb8b 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -602,6 +602,8 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 	reinit_completion(&dev->dma_completion);
 
 	ret = sahara_hw_descriptor_create(dev);
+	if (!ret)
+		return -EINVAL;
 
 	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-- 
1.7.10.4
