From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: mxc-scc: fix error code in mxc_scc_probe()
Date: Fri, 30 Jun 2017 01:42:12 -0500
Message-ID: <20170630064212.GA13371@embeddedgus>
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
 drivers/crypto/mxc-scc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
index ee4be1b0..e01c463 100644
--- a/drivers/crypto/mxc-scc.c
+++ b/drivers/crypto/mxc-scc.c
@@ -708,8 +708,8 @@ static int mxc_scc_probe(struct platform_device *pdev)
 	for (i = 0; i < 2; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (irq < 0) {
-			dev_err(dev, "failed to get irq resource\n");
-			ret = -EINVAL;
+			dev_err(dev, "failed to get irq resource: %d\n", irq);
+			ret = irq;
 			goto err_out;
 		}
 
-- 
2.5.0
