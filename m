From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 15/20] crypto: caam - add support for SEC v5.x RNG4
Date: Fri, 22 Jun 2012 19:48:52 -0500
Message-ID: <1340412537-2325-10-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5084
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756753Ab2FWAu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:50:57 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SEC v4.x' RNGB h/w block self-initialized.  RNG4, available
on SEC versions 5 and beyond, is based on a different standard
that requires manual initialization.

Also update any new errors From the SEC v5.2 reference manual:
The SEC v5.2's RNG4 unit reuses some error IDs, thus the addition
of rng_err_id_list over the CHA-independent err_id_list.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c  | 129 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/desc.h  |   5 ++
 drivers/crypto/caam/error.c |  44 +++++++++++----
 drivers/crypto/caam/regs.h  |  32 ++++++++++-
 4 files changed, 196 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9a2db9c..ac6abb3 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -2,13 +2,15 @@
  * CAAM control-plane driver backend
  * Controller-level driver, kernel property detection, initialization
  *
- * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
 #include "compat.h"
 #include "regs.h"
 #include "intern.h"
 #include "jr.h"
+#include "desc_constr.h"
+#include "error.h"
 
 static int caam_remove(struct platform_device *pdev)
 {
@@ -43,10 +45,120 @@ static int caam_remove(struct platform_device *pdev)
 	return ret;
 }
 
+/*
+ * Descriptor to instantiate RNG State Handle 0 in normal mode and
+ * load the JDKEK, TDKEK and TDSK registers
+ */
+static void build_instantiation_desc(u32 *desc)
+{
+	u32 *jump_cmd;
+
+	init_job_desc(desc, 0);
+
+	/* INIT RNG in non-test mode */
+	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+			 OP_ALG_AS_INIT);
+
+	/* wait for done */
+	jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1);
+	set_jump_tgt_here(desc, jump_cmd);
+
+	/*
+	 * load 1 to clear written reg:
+	 * resets the done interrrupt and returns the RNG to idle.
+	 */
+	append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);
+
+	/* generate secure keys (non-test) */
+	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+			 OP_ALG_RNG4_SK);
+}
+
+struct instantiate_result {
+	struct completion completion;
+	int err;
+};
+
+static void rng4_init_done(struct device *dev, u32 *desc, u32 err,
+			   void *context)
+{
+	struct instantiate_result *instantiation = context;
+
+	if (err) {
+		char tmp[CAAM_ERROR_STR_MAX];
+
+		dev_err(dev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+	instantiation->err = err;
+	complete(&instantiation->completion);
+}
+
+static int instantiate_rng(struct device *jrdev)
+{
+	struct instantiate_result instantiation;
+
+	dma_addr_t desc_dma;
+	u32 *desc;
+	int ret;
+
+	desc = kmalloc(CAAM_CMD_SZ * 6, GFP_KERNEL | GFP_DMA);
+	if (!desc) {
+		dev_err(jrdev, "cannot allocate RNG init descriptor memory\n");
+		return -ENOMEM;
+	}
+
+	build_instantiation_desc(desc);
+	desc_dma = dma_map_single(jrdev, desc, desc_bytes(desc), DMA_TO_DEVICE);
+	init_completion(&instantiation.completion);
+	ret = caam_jr_enqueue(jrdev, desc, rng4_init_done, &instantiation);
+	if (!ret) {
+		wait_for_completion_interruptible(&instantiation.completion);
+		ret = instantiation.err;
+		if (ret)
+			dev_err(jrdev, "unable to instantiate RNG\n");
+	}
+
+	dma_unmap_single(jrdev, desc_dma, desc_bytes(desc), DMA_TO_DEVICE);
+
+	kfree(desc);
+
+	return ret;
+}
+
+/*
+ * By default, the TRNG runs for 200 clocks per sample;
+ * 800 clocks per sample generates better entropy.
+ */
+static void kick_trng(struct platform_device *pdev)
+{
+	struct device *ctrldev = &pdev->dev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_full __iomem *topregs;
+	struct rng4tst __iomem *r4tst;
+	u32 val;
+
+	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+	r4tst = &topregs->ctrl.r4tst[0];
+
+	/* put RNG4 into program mode */
+	setbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+	/* 800 clocks per sample */
+	val = rd_reg32(&r4tst->rtsdctl);
+	val = (val & ~RTSDCTL_ENT_DLY_MASK) | (800 << RTSDCTL_ENT_DLY_SHIFT);
+	wr_reg32(&r4tst->rtsdctl, val);
+	/* min. freq. count */
+	wr_reg32(&r4tst->rtfrqmin, 400);
+	/* max. freq. count */
+	wr_reg32(&r4tst->rtfrqmax, 6400);
+	/* put RNG4 into run mode */
+	clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ring, rspec;
+	int ret, ring, rspec;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
@@ -146,6 +258,19 @@ static int caam_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	/*
+	 * RNG4 based SECs (v5+) need special initialization prior
+	 * to executing any descriptors
+	 */
+	if (of_device_is_compatible(nprop, "fsl,sec-v5.0")) {
+		kick_trng(pdev);
+		ret = instantiate_rng(ctrlpriv->jrdev[0]);
+		if (ret) {
+			caam_remove(pdev);
+			return ret;
+		}
+	}
+
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
 	/* Initialize queue allocator lock */
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 3e68506..f7f833b 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1172,6 +1172,11 @@ struct sec4_sg_entry {
 #define OP_ALG_AAI_GSM		(0x10 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_EDGE		(0x20 << OP_ALG_AAI_SHIFT)
 
+/* RNG4 set */
+#define OP_ALG_RNG4_SHIFT	4
+#define OP_ALG_RNG4_MASK	(0x1f3 << OP_ALG_RNG4_SHIFT)
+
+#define OP_ALG_RNG4_SK		(0x100 << OP_ALG_RNG4_SHIFT)
 
 #define OP_ALG_AS_SHIFT		2
 #define OP_ALG_AS_MASK		(0x3 << OP_ALG_AS_SHIFT)
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 7e2d54b..9955ed9 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -39,18 +39,20 @@ static void report_ccb_status(u32 status, char *outstr)
 	char *cha_id_list[] = {
 		"",
 		"AES",
-		"DES, 3DES",
+		"DES",
 		"ARC4",
-		"MD5, SHA-1, SH-224, SHA-256, SHA-384, SHA-512",
+		"MDHA",
 		"RNG",
 		"SNOW f8",
-		"Kasumi f8, f9",
-		"All Public Key Algorithms",
-		"CRC",
+		"Kasumi f8/9",
+		"PKHA",
+		"CRCA",
 		"SNOW f9",
+		"ZUCE",
+		"ZUCA",
 	};
 	char *err_id_list[] = {
-		"None. No error.",
+		"No error.",
 		"Mode error.",
 		"Data size error.",
 		"Key size error.",
@@ -67,6 +69,20 @@ static void report_ccb_status(u32 status, char *outstr)
 		"Invalid CHA combination was selected",
 		"Invalid CHA selected.",
 	};
+	char *rng_err_id_list[] = {
+		"",
+		"",
+		"",
+		"Instantiate",
+		"Not instantiated",
+		"Test instantiate",
+		"Prediction resistance",
+		"",
+		"Prediction resistance and test request",
+		"Uninstantiate",
+		"",
+		"Secure key generation",
+	};
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
 	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
@@ -81,7 +97,13 @@ static void report_ccb_status(u32 status, char *outstr)
 			   cha_id, sizeof("ff"));
 	}
 
-	if (err_id < ARRAY_SIZE(err_id_list)) {
+	if ((cha_id << JRSTA_CCBERR_CHAID_SHIFT) == JRSTA_CCBERR_CHAID_RNG &&
+	    err_id < ARRAY_SIZE(rng_err_id_list) &&
+	    strlen(rng_err_id_list[err_id])) {
+		/* RNG-only error */
+		SPRINTFCAT(outstr, "%s", rng_err_id_list[err_id],
+			   strlen(rng_err_id_list[err_id]));
+	} else if (err_id < ARRAY_SIZE(err_id_list)) {
 		SPRINTFCAT(outstr, "%s", err_id_list[err_id],
 			   strlen(err_id_list[err_id]));
 	} else {
@@ -101,10 +123,10 @@ static void report_deco_status(u32 status, char *outstr)
 		u8 value;
 		char *error_text;
 	} desc_error_list[] = {
-		{ 0x00, "None. No error." },
+		{ 0x00, "No error." },
 		{ 0x01, "SGT Length Error. The descriptor is trying to read "
 			"more data than is contained in the SGT table." },
-		{ 0x02, "Reserved." },
+		{ 0x02, "SGT Null Entry Error." },
 		{ 0x03, "Job Ring Control Error. There is a bad value in the "
 			"Job Ring Control register." },
 		{ 0x04, "Invalid Descriptor Command. The Descriptor Command "
@@ -116,7 +138,7 @@ static void report_deco_status(u32 status, char *outstr)
 		{ 0x09, "Invalid OPERATION Command" },
 		{ 0x0A, "Invalid FIFO LOAD Command" },
 		{ 0x0B, "Invalid FIFO STORE Command" },
-		{ 0x0C, "Invalid MOVE Command" },
+		{ 0x0C, "Invalid MOVE/MOVE_LEN Command" },
 		{ 0x0D, "Invalid JUMP Command. A nonlocal JUMP Command is "
 			"invalid because the target is not a Job Header "
 			"Command, or the jump is from a Trusted Descriptor to "
@@ -166,6 +188,8 @@ static void report_deco_status(u32 status, char *outstr)
 			"(input frame; block ciphers) and IPsec decap (output "
 			"frame, when doing the next header byte update) and "
 			"DCRC (output frame)." },
+		{ 0x23, "Read Input Frame error" },
+		{ 0x24, "JDKEK, TDKEK or TDSK not loaded error" },
 		{ 0x80, "DNR (do not run) error" },
 		{ 0x81, "undefined protocol command" },
 		{ 0x82, "invalid setting in PDB" },
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index e9f7a70..6d9f1d9 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -167,7 +167,7 @@ struct partid {
 	u32 pidr;	/* partition ID, DECO */
 };
 
-/* RNG test mode (replicated twice in some configurations) */
+/* RNGB test mode (replicated twice in some configurations) */
 /* Padded out to 0x100 */
 struct rngtst {
 	u32 mode;		/* RTSTMODEx - Test mode */
@@ -200,6 +200,31 @@ struct rngtst {
 	u32 rsvd14[15];
 };
 
+/* RNG4 TRNG test registers */
+struct rng4tst {
+#define RTMCTL_PRGM 0x00010000	/* 1 -> program mode, 0 -> run mode */
+	u32 rtmctl;		/* misc. control register */
+	u32 rtscmisc;		/* statistical check misc. register */
+	u32 rtpkrrng;		/* poker range register */
+	union {
+		u32 rtpkrmax;	/* PRGM=1: poker max. limit register */
+		u32 rtpkrsq;	/* PRGM=0: poker square calc. result register */
+	};
+#define RTSDCTL_ENT_DLY_SHIFT 16
+#define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
+	u32 rtsdctl;		/* seed control register */
+	union {
+		u32 rtsblim;	/* PRGM=1: sparse bit limit register */
+		u32 rttotsam;	/* PRGM=0: total samples register */
+	};
+	u32 rtfrqmin;		/* frequency count min. limit register */
+	union {
+		u32 rtfrqmax;	/* PRGM=1: freq. count max. limit register */
+		u32 rtfrqcnt;	/* PRGM=0: freq. count register */
+	};
+	u32 rsvd1[56];
+};
+
 /*
  * caam_ctrl - basic core configuration
  * starts base + 0x0000 padded out to 0x1000
@@ -249,7 +274,10 @@ struct caam_ctrl {
 
 	/* RNG Test/Verification/Debug Access                   600-7ff */
 	/* (Useful in Test/Debug modes only...)                         */
-	struct rngtst rtst[2];
+	union {
+		struct rngtst rtst[2];
+		struct rng4tst r4tst[2];
+	};
 
 	u32 rsvd9[448];
 
-- 
1.7.11.1
