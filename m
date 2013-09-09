From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 5/7] crypto: caam - uninstantiate RNG state handle 0 if instantiated by caam driver
Date: Mon, 9 Sep 2013 18:56:32 +0300
Message-ID: <1378742194-32194-6-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:38883
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3IIP72 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:28 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the caam driver module instantiates the RNG state handle 0, then
upon the removal of the module, the RNG state handle is left
initialized. This patch takes care of reverting the state of the
handle back to its previous uninstantatied state.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c   |   57 +++++++++++++++++++++++++++++++++++++----
 drivers/crypto/caam/intern.h |    6 ++++
 2 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 3ad032f..9e9215a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -44,6 +44,17 @@ static void build_instantiation_desc(u32 *desc)
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
 
+/* Descriptor for deinstantiation of State Handle 0 of the RNG block. */
+static void build_deinstantiation_desc(u32 *desc)
+{
+	init_job_desc(desc, 0);
+
+	/* Uninstantiate State Handle 0 */
+	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+			 OP_ALG_AS_INITFINAL);
+
+	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
+}
 
 /*
  * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
@@ -59,7 +70,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc)
 	struct caam_full __iomem *topregs;
 	unsigned int timeout = 100000;
 	u32 deco_dbg_reg, flags;
-	int i, ret = 0;
+	int i;
 
 	/* Set the bit to request direct access to DECO0 */
 	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
@@ -102,11 +113,6 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc)
 		cpu_relax();
 	} while ((deco_dbg_reg & DESC_DBG_DECO_STAT_VALID) && --timeout);
 
-	if (!timeout) {
-		dev_err(ctrldev, "failed to instantiate RNG\n");
-		ret = -EIO;
-	}
-
 	/* Mark the DECO as free */
 	clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
 
@@ -146,6 +152,39 @@ static int instantiate_rng(struct device *ctrldev)
 	return ret;
 }
 
+/*
+ * deinstantiate_rng - builds and executes a descriptor on DECO0,
+ *		       which deinitializes the RNG block.
+ * @ctrldev - pointer to device
+ *
+ * Return: - 0 if no error occurred
+ *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
+ *	   - -ENODEV if DECO0 couldn't be acquired
+ *	   - -EAGAIN if an error occurred when executing the descriptor
+ */
+static int deinstantiate_rng(struct device *ctrldev)
+{
+	u32 *desc;
+	int i, ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	/* Create the descriptor for deinstantating RNG State Handle 0 */
+	build_deinstantiation_desc(desc);
+
+	/* Try to run it through DECO0 */
+	ret = run_descriptor_deco0(ctrldev, desc);
+
+	if (ret)
+		dev_err(ctrldev, "failed to deinstantiate RNG\n");
+
+	kfree(desc);
+
+	return ret;
+}
+
 static int caam_remove(struct platform_device *pdev)
 {
 	struct device *ctrldev;
@@ -165,6 +204,10 @@ static int caam_remove(struct platform_device *pdev)
 		irq_dispose_mapping(jrpriv->irq);
 	}
 
+	/* De-initialize RNG if it was initialized by this driver. */
+	if (ctrlpriv->rng4_init)
+		deinstantiate_rng(ctrldev);
+
 	/* Shut down debug views */
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove_recursive(ctrlpriv->dfs_root);
@@ -384,6 +427,8 @@ static int caam_probe(struct platform_device *pdev)
 			return ret;
 		}
 
+		ctrlpriv->rng4_init = 1;
+
 		/* Enable RDB bit so that RNG works faster */
 		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
 	}
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 34c4b9f..ada2429 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -87,6 +87,12 @@ struct caam_drv_private {
 	/* list of registered hash algorithms (mk generic context handle?) */
 	struct list_head hash_list;
 
+	/* RNG4 block */
+	bool rng4_init;		/* If RNG4 block is initialized by this driver,
+				   then this will be set; if it was initialized
+				   by another entity (e.g. u-boot), it will be
+				   cleared. */
+
 	/*
 	 * debugfs entries for developer view into driver/device
 	 * variables at runtime.
-- 
1.7.7.6
