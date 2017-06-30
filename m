From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: omap-aes: fix error return code in omap_aes_probe()
Date: Fri, 30 Jun 2017 02:00:54 -0500
Message-ID: <20170630070054.GA16513@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Propagate the return value of platform_get_irq on failure.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/omap-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 5120a17..c376a3e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1095,6 +1095,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0) {
 			dev_err(dev, "can't get IRQ resource\n");
+			err = irq;
 			goto err_irq;
 		}
 
-- 
2.5.0
