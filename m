From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: ccp-platform: print error message on
 platform_get_irq failure
Date: Fri, 30 Jun 2017 00:59:52 -0500
Message-ID: <20170630055952.GA6953@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Print error message on platform_get_irq failure before return.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/ccp/ccp-platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index e26969e..6020c4a 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -66,8 +66,10 @@ static int ccp_get_irq(struct ccp_device *ccp)
 	int ret;
 
 	ret = platform_get_irq(pdev, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_notice(dev, "unable to get IRQ (%d)\n", ret);
 		return ret;
+	}
 
 	ccp->irq = ret;
 	ret = request_irq(ccp->irq, ccp->vdata->perform->irqhandler, 0,
-- 
2.5.0
