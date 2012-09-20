From: Vakul Garg <vakul@freescale.com>
Subject: [PATCHv2] crypto:caam - Improved support of CAAM era retrieval.
Date: Thu, 20 Sep 2012 09:45:09 +0530
Message-ID: <1348114509-14117-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Vakul Garg <vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:32075
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab2ITESg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Sep 2012 00:18:36 -0400
Received: from mail105-db3 (localhost [127.0.0.1])	by
 mail105-db3-R.bigfish.com (Postfix) with ESMTP id E1F0248025B	for
 <linux-crypto@vger.kernel.org>; Thu, 20 Sep 2012 04:18:34 +0000 (UTC)
Received: from DB3EHSMHS002.bigfish.com (unknown [10.3.81.232])	by
 mail105-db3.bigfish.com (Postfix) with ESMTP id AEE362601DB	for
 <linux-crypto@vger.kernel.org>; Thu, 20 Sep 2012 04:18:31 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net ([10.213.130.145])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with ESMTP id q8K4HrIC030338	for
 <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2012 21:17:54 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CAAM api caam_get_era() currently supports devices upto ERA-4.
The era is looked up from a table mapping SECVID register to ERA
number. Post ERA-6, era can be directly read from register CCBVID.
This patch enhances api caam_get_era() to support additional pre
ERA-6 devices in the mapping table. For ERA-6 and later devices,
it returns ERA directly by reading CCBVID.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 drivers/crypto/caam/ctrl.c |   29 +++++++++++++++++++++--------
 drivers/crypto/caam/ctrl.h |    2 +-
 drivers/crypto/caam/regs.h |    7 +++++++
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b3fecfa..902b839 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -158,12 +158,15 @@ static void kick_trng(struct platform_device *pdev)
 
 /**
  * caam_get_era() - Return the ERA of the SEC on SoC, based
- * on the SEC_VID register.
- * Returns the ERA number (1..4) or -ENOTSUPP if the ERA is unknown.
+ * on the SEC_VID, CCBVID registers.
+ * Returns the ERA number or -ENOTSUPP if the ERA is unknown.
  * @caam_id - the value of the SEC_VID register
+ * @ccbvid - the value of CCBVID register
  **/
-int caam_get_era(u64 caam_id)
+int caam_get_era(u64 caam_id, u32 ccb_id)
 {
+	int i;
+	struct ccb_vid *ccb_vid = (struct ccb_vid *)&ccb_id;
 	struct sec_vid *sec_vid = (struct sec_vid *)&caam_id;
 	static const struct {
 		u16 ip_id;
@@ -176,15 +179,23 @@ int caam_get_era(u64 caam_id)
 		{0x0A14, 1, 3},
 		{0x0A14, 2, 4},
 		{0x0A16, 1, 4},
-		{0x0A11, 1, 4}
+		{0x0A10, 3, 4},
+		{0x0A11, 1, 4},
+		{0x0A18, 1, 4},
+		{0x0A11, 2, 5},
+		{0x0A12, 2, 5},
+		{0x0A13, 1, 5},
+		{0x0A1C, 1, 5}
 	};
-	int i;
+
+	if (ccb_vid->era)
+		return ccb_vid->era;
 
 	for (i = 0; i < ARRAY_SIZE(caam_eras); i++)
 		if (caam_eras[i].ip_id == sec_vid->ip_id &&
 			caam_eras[i].maj_rev == sec_vid->maj_rev)
-				return caam_eras[i].era;
-
+			return caam_eras[i].era;
+
 	return -ENOTSUPP;
 }
 EXPORT_SYMBOL(caam_get_era);
@@ -194,6 +205,7 @@ static int caam_probe(struct platform_device *pdev)
 {
 	int ret, ring, rspec;
 	u64 caam_id;
+	u32 ccb_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
@@ -312,10 +324,11 @@ static int caam_probe(struct platform_device *pdev)
 	spin_lock_init(&ctrlpriv->jr_alloc_lock);
 
 	caam_id = rd_reg64(&topregs->ctrl.perfmon.caam_id);
+	ccb_id = rd_reg32(&topregs->ctrl.perfmon.ccb_id);
 
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
-		 caam_get_era(caam_id));
+		 caam_get_era(caam_id, ccb_id));
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
index 980d44e..9ceebef 100644
--- a/drivers/crypto/caam/ctrl.h
+++ b/drivers/crypto/caam/ctrl.h
@@ -8,6 +8,6 @@
 #define CTRL_H
 
 /* Prototypes for backend-level services exposed to APIs */
-int caam_get_era(u64 caam_id);
+int caam_get_era(u64 caam_id, u32 ccb_id);
 
 #endif /* CTRL_H */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3223fc6..7d092e9 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -123,6 +123,13 @@ struct sec_vid {
 	u8 min_rev;
 };
 
+struct ccb_vid {
+	u8 era;		/*This field is '0' prior to CAAM ERA-6*/
+	u8 reserved;
+	u8 amjv;
+	u8 amnv;
+};
+
 struct caam_perfmon {
 	/* Performance Monitor Registers			f00-f9f */
 	u64 req_dequeued;	/* PC_REQ_DEQ - Dequeued Requests	     */
-- 
1.7.7.6
