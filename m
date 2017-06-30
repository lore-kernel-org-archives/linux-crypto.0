From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: mediatek: fix error return code in mtk_crypto_probe()
Date: Fri, 30 Jun 2017 01:24:54 -0500
Message-ID: <20170630062454.GA9699@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Propagate the return value of platform_get_irq on failure.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/mediatek/mtk-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 000b650..b182e94 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -500,7 +500,7 @@ static int mtk_crypto_probe(struct platform_device *pdev)
 		cryp->irq[i] = platform_get_irq(pdev, i);
 		if (cryp->irq[i] < 0) {
 			dev_err(cryp->dev, "no IRQ:%d resource info\n", i);
-			return -ENXIO;
+			return cryp->irq[i];
 		}
 	}
 
-- 
2.5.0
