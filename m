From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/4] drivers/crypto/amcc/crypto4xx_core.c: fix error return code
Date: Mon, 17 Sep 2012 19:28:27 +0200
Message-ID: <1347902908-19006-3-git-send-email-peter.senna@gmail.com>
References: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
Cc: davem@davemloft.net, Julia.Lawall@lip6.fr, vzapolskiy@gmail.com,
	axel.lin@gmail.com, peter.senna@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 802e851..f88e3d8 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1226,6 +1226,7 @@ static int __init crypto4xx_probe(struct platform_device *ofdev)
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
 		dev_err(dev, "failed to of_iomap\n");
+		rc = -ENOMEM;
 		goto err_iomap;
 	}
 
-- 
1.7.11.4
