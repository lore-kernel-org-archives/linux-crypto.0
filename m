From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 3/3] crypto-ixp4xx: Less function calls in
 init_ixp_crypto() after error detection
Date: Tue, 17 Nov 2015 16:46:46 +0100
Message-ID: <564B4BE6.6010209@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <5648D2C1.8050603@users.sourceforge.net>
 <564B489F.10308@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51237 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbKQPq6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 10:46:58 -0500
In-Reply-To: <564B489F.10308@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 17 Nov 2015 16:15:21 +0100

The dma_pool_destroy() function was called in up to two cases by the
init_ixp_crypto() function during error handling even if a call of
the dma_pool_create() function failed.

This implementation detail could be improved by the adjustment
of jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ixp4xx_crypto.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 79b6958..0a5969c 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -483,23 +483,23 @@ static int init_ixp_crypto(struct device *dev)
 			sizeof(struct buffer_desc), 32, 0);
 	if (!buffer_pool) {
 		ret = -ENOMEM;
-		goto err;
+		goto release_npe;
 	}
 	ctx_pool = dma_pool_create("context", dev,
 			NPE_CTX_LEN, 16, 0);
 	if (!ctx_pool) {
 		ret = -ENOMEM;
-		goto err;
+		goto destroy_buffer_pool;
 	}
 	ret = qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0,
 				 "ixp_crypto:out", NULL);
 	if (ret)
-		goto err;
+		goto destroy_ctx_pool;
 	ret = qmgr_request_queue(RECV_QID, NPE_QLEN, 0, 0,
 				 "ixp_crypto:in", NULL);
 	if (ret) {
 		qmgr_release_queue(SEND_QID);
-		goto err;
+		goto destroy_ctx_pool;
 	}
 	qmgr_set_irq(RECV_QID, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
 	tasklet_init(&crypto_done_tasklet, crypto_done_action, 0);
@@ -510,9 +510,11 @@ static int init_ixp_crypto(struct device *dev)
 npe_error:
 	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
 	ret = -EIO;
-err:
+destroy_ctx_pool:
 	dma_pool_destroy(ctx_pool);
+destroy_buffer_pool:
 	dma_pool_destroy(buffer_pool);
+release_npe:
 	npe_release(npe_c);
 	return ret;
 }
-- 
2.6.2
