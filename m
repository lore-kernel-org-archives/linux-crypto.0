From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: omap-des: fix error return code in omap_des_probe()
Date: Fri, 30 Jun 2017 02:07:04 -0500
Message-ID: <20170630070704.GA18278@embeddedgus>
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

Print and propagate the return value of platform_get_irq on failure.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/omap-des.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 0bcab00..d37c950 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1023,7 +1023,8 @@ static int omap_des_probe(struct platform_device *pdev)
 
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0) {
-			dev_err(dev, "can't get IRQ resource\n");
+			dev_err(dev, "can't get IRQ resource: %d\n", irq);
+			err = irq;
 			goto err_irq;
 		}
 
-- 
2.5.0
