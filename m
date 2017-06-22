From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: qat - avoid an uninitialized variable warning
Date: Thu, 22 Jun 2017 14:35:46 +0200
Message-ID: <20170622123604.505337-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53571 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdFVMg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 08:36:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

After commit 9e442aa6a753 ("x86: remove DMA_ERROR_CODE"), the inlining
decisions in the qat driver changed slightly, introducing a new false-positive
warning:

drivers/crypto/qat/qat_common/qat_algs.c: In function 'qat_alg_sgl_to_bufl.isra.6':
include/linux/dma-mapping.h:228:2: error: 'sz_out' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/crypto/qat/qat_common/qat_algs.c:676:9: note: 'sz_out' was declared here

The patch that introduced this is correct, so let's just avoid the
warning in this driver by rearranging the unwinding after an error
to make it more obvious to the compiler what is going on.

The problem here is the 'if (unlikely(dma_mapping_error(dev, blp)))'
check, in which the 'unlikely' causes gcc to forget what it knew about
the state of the variables. Cleaning up the dma state in the reverse
order it was created means we can simplify the logic so it doesn't have
to know about that state, and also makes it easier to understand.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 40 +++++++++++++++++---------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 5b5efcc52cb5..baffae817259 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -686,7 +686,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, blp)))
-		goto err;
+		goto err_in;
 
 	for_each_sg(sgl, sg, n, i) {
 		int y = sg_nctr;
@@ -699,7 +699,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 						      DMA_BIDIRECTIONAL);
 		bufl->bufers[y].len = sg->length;
 		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
-			goto err;
+			goto err_in;
 		sg_nctr++;
 	}
 	bufl->num_bufs = sg_nctr;
@@ -717,10 +717,10 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
-			goto err;
+			goto err_in;
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
-			goto err;
+			goto err_out;
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i) {
 			int y = sg_nctr;
@@ -732,7 +732,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 							sg->length,
 							DMA_BIDIRECTIONAL);
 			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
-				goto err;
+				goto err_out;
 			bufers[y].len = sg->length;
 			sg_nctr++;
 		}
@@ -747,9 +747,20 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		qat_req->buf.sz_out = 0;
 	}
 	return 0;
-err:
-	dev_err(dev, "Failed to map buf for dma\n");
-	sg_nctr = 0;
+
+err_out:
+	n = sg_nents(sglout);
+	for (i = 0; i < n; i++)
+		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
+			dma_unmap_single(dev, buflout->bufers[i].addr,
+					 buflout->bufers[i].len,
+					 DMA_BIDIRECTIONAL);
+	if (!dma_mapping_error(dev, bloutp))
+		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
+	kfree(buflout);
+
+err_in:
+	n = sg_nents(sgl);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
 			dma_unmap_single(dev, bufl->bufers[i].addr,
@@ -759,17 +770,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (!dma_mapping_error(dev, blp))
 		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 	kfree(bufl);
-	if (sgl != sglout && buflout) {
-		n = sg_nents(sglout);
-		for (i = 0; i < n; i++)
-			if (!dma_mapping_error(dev, buflout->bufers[i].addr))
-				dma_unmap_single(dev, buflout->bufers[i].addr,
-						 buflout->bufers[i].len,
-						 DMA_BIDIRECTIONAL);
-		if (!dma_mapping_error(dev, bloutp))
-			dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
-		kfree(buflout);
-	}
+
+	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
 }
 
-- 
2.9.0
