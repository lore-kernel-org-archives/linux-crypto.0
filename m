Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37772 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbeJ2SiV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 14:38:21 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] crypto: ccree: add support for CryptoCell 713
Date: Mon, 29 Oct 2018 09:50:12 +0000
Message-Id: <1540806616-5483-2-git-send-email-gilad@benyossef.com>
In-Reply-To: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
References: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for Arm TrustZone CryptoCell 713.
Note that this patch just enables using a 713 in backwards compatible mode
to 712. Newer 713 specific features will follow.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/Kconfig           |  2 +-
 drivers/crypto/ccree/cc_driver.c | 23 +++++++++++++++--------
 drivers/crypto/ccree/cc_driver.h |  5 +++--
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index a8c4ce0..bea4de6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -754,7 +754,7 @@ config CRYPTO_DEV_CCREE
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
-	  CryptoCell 712, 710 and 630 are supported.
+	  CryptoCell 713, 712, 710 and 630 are supported.
 	  Choose this if you wish to use hardware acceleration of
 	  cryptographic operations on the system REE.
 	  If unsure say Y.
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1ff229c..630c598 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -43,6 +43,10 @@ struct cc_hw_data {
 
 /* Hardware revisions defs. */
 
+static const struct cc_hw_data cc713_hw = {
+	.name = "713", .rev = CC_HW_REV_713
+};
+
 static const struct cc_hw_data cc712_hw = {
 	.name = "712", .rev = CC_HW_REV_712, .sig =  0xDCC71200U
 };
@@ -56,6 +60,7 @@ static const struct cc_hw_data cc630p_hw = {
 };
 
 static const struct of_device_id arm_ccree_dev_of_match[] = {
+	{ .compatible = "arm,cryptocell-713-ree", .data = &cc713_hw },
 	{ .compatible = "arm,cryptocell-712-ree", .data = &cc712_hw },
 	{ .compatible = "arm,cryptocell-710-ree", .data = &cc710_hw },
 	{ .compatible = "arm,cryptocell-630p-ree", .data = &cc630p_hw },
@@ -297,15 +302,17 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		return rc;
 	}
 
-	/* Verify correct mapping */
-	signature_val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
-	if (signature_val != hw_rev->sig) {
-		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-			signature_val, hw_rev->sig);
-		rc = -EINVAL;
-		goto post_clk_err;
+	if (hw_rev->rev <= CC_HW_REV_712) {
+		/* Verify correct mapping */
+		signature_val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
+		if (signature_val != hw_rev->sig) {
+			dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+				signature_val, hw_rev->sig);
+			rc = -EINVAL;
+			goto post_clk_err;
+		}
+		dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
 	}
-	dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
 
 	/* Display HW versions */
 	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index d608a4f..a06e5c9 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -36,12 +36,13 @@
 extern bool cc_dump_desc;
 extern bool cc_dump_bytes;
 
-#define DRV_MODULE_VERSION "4.0"
+#define DRV_MODULE_VERSION "5.0"
 
 enum cc_hw_rev {
 	CC_HW_REV_630 = 630,
 	CC_HW_REV_710 = 710,
-	CC_HW_REV_712 = 712
+	CC_HW_REV_712 = 712,
+	CC_HW_REV_713 = 713
 };
 
 #define CC_COHERENT_CACHE_PARAMS 0xEEE
-- 
2.7.4
