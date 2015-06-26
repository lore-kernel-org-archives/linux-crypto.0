From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] QAT: Fix uninitialized variable in qat driver
Date: Fri, 26 Jun 2015 13:56:48 -0400
Message-ID: <1435341408-21649-1-git-send-email-nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	qat-linux@intel.com (open list:QAT DRIVER)
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbFZR5L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jun 2015 13:57:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hit a warning when building QAT, indicating that sz_out might be uninitalized
before use.  Looks like if you hit an error path and jump to err: you might find
yourself trying to unmap an arbirarily long dma region.  Its safe on intel since
intel defines the invalid dma address as zero, but other arches don't, and if
qat makes its way to one of those, that can cause all sorts of corruption.

Fix is pretty easy, just init sz_out to zero, and gate the unmapping on sz_out
being non-zero

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Tadeusz Struk <tadeusz.struk@intel.com>
CC: qat-linux@intel.com (open list:QAT DRIVER)
---
 drivers/crypto/qat/qat_common/qat_algs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 067402c..35ab752 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -667,8 +667,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp;
 	dma_addr_t bloutp = 0;
 	struct scatterlist *sg;
-	size_t sz_out, sz = sizeof(struct qat_alg_buf_list) +
-			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
+	size_t sz_out = 0;
+	size_t sz = sizeof(struct qat_alg_buf_list) +
+			  ((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
 
 	if (unlikely(!n))
 		return -EINVAL;
@@ -793,7 +794,7 @@ err:
 				dma_unmap_single(dev, buflout->bufers[i].addr,
 						 buflout->bufers[i].len,
 						 DMA_BIDIRECTIONAL);
-		if (!dma_mapping_error(dev, bloutp))
+		if (sz_out && !dma_mapping_error(dev, bloutp))
 			dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 		kfree(buflout);
 	}
-- 
2.1.0
