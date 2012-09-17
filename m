From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/4] drivers/crypto/ux500/cryp/cryp_core.c: fix error return code
Date: Mon, 17 Sep 2012 19:28:25 +0200
Message-ID: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
Cc: davem@davemloft.net, linus.walleij@linaro.org,
	andreas.westin@stericsson.com, rjw@sisk.pl, peter.senna@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..715c0fe 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1486,6 +1486,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	if (!res_irq) {
 		dev_err(dev, "[%s]: IORESOURCE_IRQ unavailable",
 			__func__);
+		ret = -ENODEV;
 		goto out_power;
 	}
 
-- 
1.7.11.4
