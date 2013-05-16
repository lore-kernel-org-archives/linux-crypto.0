From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
Date: Thu, 16 May 2013 12:27:25 +0100
Message-ID: <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

By providing an OF match table with a suitable compatible string, we
can ensure the ux500-crypt driver is probed by supplying an associated
DT node in a given platform's Device Tree.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 4f8b11a..d3940b7 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1772,6 +1772,11 @@ static int ux500_cryp_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
+static const struct of_device_id ux500_cryp_match[] = {
+        { .compatible = "stericsson,ux500-cryp" },
+        { },
+};
+
 static struct platform_driver cryp_driver = {
 	.probe  = ux500_cryp_probe,
 	.remove = ux500_cryp_remove,
@@ -1779,6 +1784,7 @@ static struct platform_driver cryp_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = "cryp1",
+		.of_match_table = ux500_cryp_match,
 		.pm    = &ux500_cryp_pm,
 	}
 };
-- 
1.7.10.4
