From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH] crypto: caam - fix ERA retrieval function
Date: Thu, 6 Feb 2014 10:27:19 +0200
Message-ID: <1391675239-11289-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>, <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:5053
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100AbaBFI3I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 03:29:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC ERA has to be retrieved by reading the "fsl,sec-era" property
from the device tree. This property is updated/filled in by
u-boot.

Change-Id: Ie1620354a0cf2cac5cd2c72bd5f2449f55858378
Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 36 ++++++++++--------------------------
 drivers/crypto/caam/ctrl.h |  2 +-
 2 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 63fb1af..ebb5617 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -14,7 +14,6 @@
 #include "jr.h"
 #include "desc_constr.h"
 #include "error.h"
-#include "ctrl.h"
 
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
@@ -352,32 +351,17 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 
 /**
  * caam_get_era() - Return the ERA of the SEC on SoC, based
- * on the SEC_VID register.
- * Returns the ERA number (1..4) or -ENOTSUPP if the ERA is unknown.
- * @caam_id - the value of the SEC_VID register
+ * on "sec-era" propery in the DTS. This property is updated by u-boot.
  **/
-int caam_get_era(u64 caam_id)
+int caam_get_era(void)
 {
-	struct sec_vid *sec_vid = (struct sec_vid *)&caam_id;
-	static const struct {
-		u16 ip_id;
-		u8 maj_rev;
-		u8 era;
-	} caam_eras[] = {
-		{0x0A10, 1, 1},
-		{0x0A10, 2, 2},
-		{0x0A12, 1, 3},
-		{0x0A14, 1, 3},
-		{0x0A14, 2, 4},
-		{0x0A16, 1, 4},
-		{0x0A11, 1, 4}
-	};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(caam_eras); i++)
-		if (caam_eras[i].ip_id == sec_vid->ip_id &&
-			caam_eras[i].maj_rev == sec_vid->maj_rev)
-				return caam_eras[i].era;
+	struct device_node *caam_node;
+	for_each_compatible_node(caam_node, NULL, "fsl,sec-v4.0") {
+		const uint32_t *prop = (uint32_t *)of_get_property(caam_node,
+				"fsl,sec-era",
+				NULL);
+		return prop ? *prop : -ENOTSUPP;
+	}
 
 	return -ENOTSUPP;
 }
@@ -564,7 +548,7 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
-		 caam_get_era(caam_id));
+		 caam_get_era());
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
index 980d44e..cac5402 100644
--- a/drivers/crypto/caam/ctrl.h
+++ b/drivers/crypto/caam/ctrl.h
@@ -8,6 +8,6 @@
 #define CTRL_H
 
 /* Prototypes for backend-level services exposed to APIs */
-int caam_get_era(u64 caam_id);
+int caam_get_era(void);
 
 #endif /* CTRL_H */
-- 
1.8.3.1
