From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/10] staging: ccree: turn compile time debug log to params
Date: Thu, 14 Dec 2017 14:02:44 +0000
Message-ID: <1513260170-26346-8-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:42210 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752547AbdLNODf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:03:35 -0500
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccree driver has some support to dump runtime data
to kernel log to assist in debugging. The code used to be
enabled by a build time flag. Refactor to enable it via
module/kernel parameters.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_config.h      |  2 --
 drivers/staging/ccree/ssi_driver.c      | 18 ++++++++++++------
 drivers/staging/ccree/ssi_driver.h      | 16 ++++++++++------
 drivers/staging/ccree/ssi_request_mgr.c | 26 +++++++++++++-------------
 4 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index b530974..bc90ad0 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -23,8 +23,6 @@
 
 #include <linux/version.h>
 
-//#define CC_DUMP_DESCS
-// #define CC_DUMP_BYTES
 /* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 #define DMA_BIT_MASK_LEN	48
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index dbca241..195fb27 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -72,20 +72,26 @@
 #include "ssi_pm.h"
 #include "ssi_fips.h"
 
-#ifdef CC_DUMP_BYTES
-void dump_byte_array(const char *name, const u8 *buf, size_t len)
+bool cc_dump_desc;
+module_param_named(dump_desc, cc_dump_desc, bool, 0600);
+MODULE_PARM_DESC(cc_dump_desc, "Dump descriptors to kernel log as debugging aid");
+
+bool cc_dump_bytes;
+module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
+MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
+
+void __dump_byte_array(const char *name, const u8 *buf, size_t len)
 {
-	char prefix[NAME_LEN];
+	char prefix[64];
 
 	if (!buf)
 		return;
 
 	snprintf(prefix, sizeof(prefix), "%s[%lu]: ", name, len);
 
-	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, len,
-		       false);
+	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, buf,
+		       len, false);
 }
-#endif
 
 static irqreturn_t cc_isr(int irq, void *dev_id)
 {
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 4e05386..12e2a8b 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -48,6 +48,9 @@
 #include "cc_hw_queue_defs.h"
 #include "ssi_sram_mgr.h"
 
+extern bool cc_dump_desc;
+extern bool cc_dump_bytes;
+
 #define DRV_MODULE_VERSION "3.0"
 
 #define CC_DEV_NAME_STR "cc715ree"
@@ -169,13 +172,14 @@ static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
 	return &drvdata->plat_dev->dev;
 }
 
-#ifdef CC_DUMP_BYTES
-void dump_byte_array(const char *name, const u8 *the_array,
-		     unsigned long size);
-#else
+void __dump_byte_array(const char *name, const u8 *the_array,
+		       unsigned long size);
 static inline void dump_byte_array(const char *name, const u8 *the_array,
-				   unsigned long size) {};
-#endif
+				   unsigned long size)
+{
+	if (cc_dump_bytes)
+		__dump_byte_array(name, the_array, size);
+}
 
 int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct cc_drvdata *drvdata);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f6374b0..2aa21f8 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -161,11 +161,12 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
 	return rc;
 }
 
-static void enqueue_seq(void __iomem *cc_base, struct cc_hw_desc seq[],
+static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
 			unsigned int seq_len)
 {
 	int i, w;
-	void * __iomem reg = cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+	void * __iomem reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+	struct device *dev = drvdata_to_dev(drvdata);
 
 	/*
 	 * We do indeed write all 6 command words to the same
@@ -175,11 +176,12 @@ static void enqueue_seq(void __iomem *cc_base, struct cc_hw_desc seq[],
 	for (i = 0; i < seq_len; i++) {
 		for (w = 0; w <= 5; w++)
 			writel_relaxed(seq[i].word[w], reg);
-#ifdef CC_DUMP_DESCS
-		dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
-			i, seq[i].word[0], seq[i].word[1], seq[i].word[2],
-			seq[i].word[3], seq[i].word[4], seq[i].word[5]);
-#endif
+
+		if (cc_dump_desc)
+			dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
+				i, seq[i].word[0], seq[i].word[1],
+				seq[i].word[2], seq[i].word[3],
+				seq[i].word[4], seq[i].word[5]);
 	}
 }
 
@@ -256,7 +258,6 @@ static int cc_queues_status(struct cc_drvdata *drvdata,
 int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 		 struct cc_hw_desc *desc, unsigned int len, bool is_dout)
 {
-	void __iomem *cc_base = drvdata->cc_base;
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int used_sw_slots;
 	unsigned int iv_seq_len = 0;
@@ -364,9 +365,9 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	wmb();
 
 	/* STAT_PHASE_4: Push sequence */
-	enqueue_seq(cc_base, iv_seq, iv_seq_len);
-	enqueue_seq(cc_base, desc, len);
-	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
+	enqueue_seq(drvdata, iv_seq, iv_seq_len);
+	enqueue_seq(drvdata, desc, len);
+	enqueue_seq(drvdata, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
 
 	if (req_mgr_h->q_free_slots < total_seq_len) {
 		/* This situation should never occur. Maybe indicating problem
@@ -407,7 +408,6 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 		      unsigned int len)
 {
-	void __iomem *cc_base = drvdata->cc_base;
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int total_seq_len = len; /*initial sequence length*/
 	int rc = 0;
@@ -426,7 +426,7 @@ int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 	 * to make sure there are no outstnading memory writes
 	 */
 	wmb();
-	enqueue_seq(cc_base, desc, len);
+	enqueue_seq(drvdata, desc, len);
 
 	/* Update the free slots in HW queue */
 	req_mgr_h->q_free_slots =
-- 
2.7.4
