From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH] ERA retrieval and printing for SEC device
Date: Wed, 27 Jun 2012 10:47:41 +0300
Message-ID: <1340783261-7494-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.139] ([213.199.154.139]:14249 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751012Ab2F0EuA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 00:50:00 -0400
Received: from mail80-db3 (localhost [127.0.0.1])	by mail80-db3-R.bigfish.com
 (Postfix) with ESMTP id 9C26DC02BF	for <linux-crypto@vger.kernel.org>; Wed,
 27 Jun 2012 04:47:36 +0000 (UTC)
Received: from DB3EHSMHS010.bigfish.com (unknown [10.3.81.248])	by
 mail80-db3.bigfish.com (Postfix) with ESMTP id 5C8D6400046	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Jun 2012 04:47:08 +0000 (UTC)
Received: from localhost.localdomain ([10.171.77.122])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with ESMTP id q5R4mk0L016493	for
 <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2012 21:48:47 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for retrieving and printing of
SEC ERA information. It is useful for knowing beforehand
what features exist from the SEC point of view on a
certain SoC. Only era-s 1 to 4 are currently supported;
other eras will appear as unknown.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |   41 +++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/caam/ctrl.h |   13 +++++++++++++
 drivers/crypto/caam/regs.h |    6 ++++++
 3 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/caam/ctrl.h

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 77557eb..5fde51e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -9,6 +9,7 @@
 #include "regs.h"
 #include "intern.h"
 #include "jr.h"
+#include "ctrl.h"
 
 static int caam_remove(struct platform_device *pdev)
 {
@@ -43,10 +44,44 @@ static int caam_remove(struct platform_device *pdev)
 	return ret;
 }
 
+/**
+ * caam_get_era() - Return the ERA of the SEC on SoC, based
+ * on the SEC_VID register.
+ * Returns the ERA number (1..4) or -ENOTSUPP if the ERA is unknown.
+ * @caam_id - the value of the SEC_VID register
+ **/
+int caam_get_era(u64 caam_id)
+{
+	struct sec_vid *sec_vid = (struct sec_vid *)&caam_id;
+	const struct {
+		u16 ip_id;
+		u8 maj_rev;
+		u8 era;
+	} caam_eras[] = {
+		{0x0A10, 1, 1},
+		{0x0A10, 2, 2},
+		{0x0A12, 1, 3},
+		{0x0A14, 1, 3},
+		{0x0A14, 2, 4},
+		{0x0A16, 1, 4},
+		{0x0A11, 1, 4}
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(caam_eras); i++)
+		if (caam_eras[i].ip_id == sec_vid->ip_id &&
+			caam_eras[i].maj_rev == sec_vid->maj_rev)
+				return caam_eras[i].era;
+
+	return -ENOTSUPP;
+}
+EXPORT_SYMBOL(caam_get_era);
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
 	int ring, rspec;
+	u64 caam_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
@@ -146,9 +181,11 @@ static int caam_probe(struct platform_device *pdev)
 	/* Initialize queue allocator lock */
 	spin_lock_init(&ctrlpriv->jr_alloc_lock);
 
+	caam_id = rd_reg64(&topregs->ctrl.perfmon.caam_id);
+
 	/* Report "alive" for developer to see */
-	dev_info(dev, "device ID = 0x%016llx\n",
-		 rd_reg64(&topregs->ctrl.perfmon.caam_id));
+	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
+		 caam_get_era(caam_id));
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
new file mode 100644
index 0000000..980d44e
--- /dev/null
+++ b/drivers/crypto/caam/ctrl.h
@@ -0,0 +1,13 @@
+/*
+ * CAAM control-plane driver backend public-level include definitions
+ *
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ */
+
+#ifndef CTRL_H
+#define CTRL_H
+
+/* Prototypes for backend-level services exposed to APIs */
+int caam_get_era(u64 caam_id);
+
+#endif /* CTRL_H */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index e9f7a70..2055a70 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -117,6 +117,12 @@ struct jr_outentry {
 #define CHA_NUM_DECONUM_SHIFT	56
 #define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
 
+struct sec_vid {
+	u16 ip_id;
+	u8 maj_rev;
+	u8 min_rev;
+};
+
 struct caam_perfmon {
 	/* Performance Monitor Registers			f00-f9f */
 	u64 req_dequeued;	/* PC_REQ_DEQ - Dequeued Requests	     */
-- 
1.7.7.6
