From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 07/13] crypto: caam/qi - explicitly set dma_ops
Date: Mon, 10 Jul 2017 08:40:33 +0300
Message-ID: <20170710054039.21555-8-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0069.outbound.protection.outlook.com ([104.47.40.69]:9344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751130AbdGJFlH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:07 -0400
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since ARM64 commit 1dccb598df549 ("arm64: simplify dma_get_ops"),
dma_ops no longer default to swiotlb_dma_ops, but to dummy_dma_ops.

dma_ops have to be explicitly set in the driver - at least for ARM64.

Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend support")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/qi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 01284faeee69..1c1f3faf6394 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -734,6 +734,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	qi_pdev = platform_device_register_full(&qi_pdev_info);
 	if (IS_ERR(qi_pdev))
 		return PTR_ERR(qi_pdev);
+	set_dma_ops(&qi_pdev->dev, get_dma_ops(ctrldev));
 
 	ctrlpriv = dev_get_drvdata(ctrldev);
 	qidev = &qi_pdev->dev;
-- 
2.12.0.264.gd6db3f216544
