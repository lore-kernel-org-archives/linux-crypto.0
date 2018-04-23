From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/2] crypto: ccree: use proper printk format
Date: Mon, 23 Apr 2018 08:25:15 +0100
Message-ID: <1524468316-6606-3-git-send-email-gilad@benyossef.com>
References: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix incorrect use of %pad as a printk format string for none dma_addr_t
variable.

Discovered via smatch.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 89ce013..37f2e6e 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -265,7 +265,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	if (rc) {
-		dev_err(dev, "Failed in dma_set_mask, mask=%pad\n", &dma_mask);
+		dev_err(dev, "Failed in dma_set_mask, mask=%llx\n", dma_mask);
 		return rc;
 	}
 
-- 
2.7.4
