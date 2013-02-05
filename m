From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 1/2] crypto: caam - support for RNG version retrieval
Date: Tue, 5 Feb 2013 12:21:24 +0200
Message-ID: <1360059685-4953-2-git-send-email-alexandru.porosanu@freescale.com>
References: <1360059685-4953-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57260
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab3BEKW3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 05:22:29 -0500
Received: from mail97-va3 (localhost [127.0.0.1])	by mail97-va3-R.bigfish.com
 (Postfix) with ESMTP id 349AB2A01BC	for <linux-crypto@vger.kernel.org>; Tue,
  5 Feb 2013 10:22:28 +0000 (UTC)
Received: from VA3EHSMHS013.bigfish.com (unknown [10.7.14.240])	by
 mail97-va3.bigfish.com (Postfix) with ESMTP id 44353300051	for
 <linux-crypto@vger.kernel.org>; Tue,  5 Feb 2013 10:22:26 +0000 (UTC)
Received: from localhost.localdomain ([10.171.77.122])	by
 az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id r15AMLxI028285	for
 <linux-crypto@vger.kernel.org>; Tue, 5 Feb 2013 03:22:22 -0700
In-Reply-To: <1360059685-4953-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for retrieving the version of the RNG
block inside the SEC. This is done by retrieving the corresponding
value from the the CHAVID register.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |   11 +++++++++++
 drivers/crypto/caam/regs.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bf20dd8..d5e6837 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -189,6 +189,17 @@ int caam_get_era(u64 caam_id)
 }
 EXPORT_SYMBOL(caam_get_era);
 
+/**
+ * get_rng_vid() - Return the version of the (T)RNG  block of the SEC.
+ * @topregs - pointer to SEC register space
+ **/
+static inline u8 get_rng_vid(struct caam_full __iomem *topregs)
+{
+	u64 cha_vid = rd_reg64(&topregs->ctrl.perfmon.cha_id);
+
+	return (cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT;
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3223fc6..f0af0bb 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -117,6 +117,43 @@ struct jr_outentry {
 #define CHA_NUM_DECONUM_SHIFT	56
 #define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
 
+/* CHA Version IDs */
+#define CHA_ID_AES_SHIFT	0
+#define CHA_ID_AES_MASK		(0xfull << CHA_ID_AES_SHIFT)
+
+#define CHA_ID_DES_SHIFT	4
+#define CHA_ID_DES_MASK		(0xfull << CHA_ID_DES_SHIFT)
+
+#define CHA_ID_ARC4_SHIFT	8
+#define CHA_ID_ARC4_MASK	(0xfull << CHA_ID_ARC4_SHIFT)
+
+#define CHA_ID_MD_SHIFT		12
+#define CHA_ID_MD_MASK		(0xfull << CHA_ID_MD_SHIFT)
+
+#define CHA_ID_RNG_SHIFT	16
+#define CHA_ID_RNG_MASK		(0xfull << CHA_ID_RNG_SHIFT)
+
+#define CHA_ID_SNW8_SHIFT	20
+#define CHA_ID_SNW8_MASK	(0xfull << CHA_ID_SNW8_SHIFT)
+
+#define CHA_ID_KAS_SHIFT	24
+#define CHA_ID_KAS_MASK		(0xfull << CHA_ID_KAS_SHIFT)
+
+#define CHA_ID_PK_SHIFT		28
+#define CHA_ID_PK_MASK		(0xfull << CHA_ID_PK_SHIFT)
+
+#define CHA_ID_CRC_SHIFT	32
+#define CHA_ID_CRC_MASK		(0xfull << CHA_ID_CRC_SHIFT)
+
+#define CHA_ID_SNW9_SHIFT	36
+#define CHA_ID_SNW9_MASK	(0xfull << CHA_ID_SNW9_SHIFT)
+
+#define CHA_ID_DECO_SHIFT	56
+#define CHA_ID_DECO_MASK	(0xfull << CHA_ID_DECO_SHIFT)
+
+#define CHA_ID_JR_SHIFT		60
+#define CHA_ID_JR_MASK		(0xfull << CHA_ID_JR_SHIFT)
+
 struct sec_vid {
 	u16 ip_id;
 	u8 maj_rev;
-- 
1.7.7.6
