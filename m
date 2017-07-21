From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH v1] crypto: brcm - Support more FlexRM rings than SPU engines.
Date: Fri, 21 Jul 2017 11:17:39 +0530
Message-ID: <1500616059-32352-1-git-send-email-raveendra.padasalagi@broadcom.com>
Cc: Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enhance code to generically support cases where DMA rings
are greater than or equal to number of SPU engines.
New hardware has underlying DMA engine-FlexRM with 32 rings
which can be used to communicate to any of the available
10 SPU engines.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org
---

Changes in v1:
  - Added error path to clean up mbox channel in spu_mb_init() in case
    mbox channel request fails.
  - Removed spu_reg_vbase[] and used spu->reg_vbase[] array to store
    mapped registers.
  - spu_dt_read() modified to improve readability

 drivers/crypto/bcm/cipher.c | 109 ++++++++++++++++++++------------------------
 drivers/crypto/bcm/cipher.h |  13 +++---
 2 files changed, 56 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index cc0d5b9..875b507 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -89,8 +89,6 @@
 module_param(aead_pri, int, 0644);
 MODULE_PARM_DESC(aead_pri, "Priority for AEAD algos");
 
-#define MAX_SPUS 16
-
 /* A type 3 BCM header, expected to precede the SPU header for SPU-M.
  * Bits 3 and 4 in the first byte encode the channel number (the dma ringset).
  * 0x60 - ring 0
@@ -119,7 +117,7 @@ static u8 select_channel(void)
 {
 	u8 chan_idx = atomic_inc_return(&iproc_priv.next_chan);
 
-	return chan_idx % iproc_priv.spu.num_spu;
+	return chan_idx % iproc_priv.spu.num_chan;
 }
 
 /**
@@ -4527,8 +4525,13 @@ static void spu_functions_register(struct device *dev,
  */
 static int spu_mb_init(struct device *dev)
 {
-	struct mbox_client *mcl = &iproc_priv.mcl[iproc_priv.spu.num_spu];
-	int err;
+	struct mbox_client *mcl = &iproc_priv.mcl;
+	int err, i;
+
+	iproc_priv.mbox = devm_kcalloc(dev, iproc_priv.spu.num_chan,
+				  sizeof(struct mbox_chan *), GFP_KERNEL);
+	if (!iproc_priv.mbox)
+		return -ENOMEM;
 
 	mcl->dev = dev;
 	mcl->tx_block = false;
@@ -4537,25 +4540,33 @@ static int spu_mb_init(struct device *dev)
 	mcl->rx_callback = spu_rx_callback;
 	mcl->tx_done = NULL;
 
-	iproc_priv.mbox[iproc_priv.spu.num_spu] =
-			mbox_request_channel(mcl, 0);
-	if (IS_ERR(iproc_priv.mbox[iproc_priv.spu.num_spu])) {
-		err = (int)PTR_ERR(iproc_priv.mbox[iproc_priv.spu.num_spu]);
-		dev_err(dev,
-			"Mbox channel %d request failed with err %d",
-			iproc_priv.spu.num_spu, err);
-		iproc_priv.mbox[iproc_priv.spu.num_spu] = NULL;
-		return err;
+	for (i = 0; i < iproc_priv.spu.num_chan; i++) {
+		iproc_priv.mbox[i] = mbox_request_channel(mcl, i);
+		if (IS_ERR(iproc_priv.mbox[i])) {
+			err = (int)PTR_ERR(iproc_priv.mbox[i]);
+			dev_err(dev,
+				"Mbox channel %d request failed with err %d",
+				i, err);
+			iproc_priv.mbox[i] = NULL;
+			goto free_channels;
+		}
 	}
 
 	return 0;
+free_channels:
+	for (i = 0; i < iproc_priv.spu.num_chan; i++) {
+		if (iproc_priv.mbox[i])
+			mbox_free_channel(iproc_priv.mbox[i]);
+	}
+
+	return err;
 }
 
 static void spu_mb_release(struct platform_device *pdev)
 {
 	int i;
 
-	for (i = 0; i < iproc_priv.spu.num_spu; i++)
+	for (i = 0; i < iproc_priv.spu.num_chan; i++)
 		mbox_free_channel(iproc_priv.mbox[i]);
 }
 
@@ -4566,7 +4577,7 @@ static void spu_counters_init(void)
 
 	atomic_set(&iproc_priv.session_count, 0);
 	atomic_set(&iproc_priv.stream_count, 0);
-	atomic_set(&iproc_priv.next_chan, (int)iproc_priv.spu.num_spu);
+	atomic_set(&iproc_priv.next_chan, (int)iproc_priv.spu.num_chan);
 	atomic64_set(&iproc_priv.bytes_in, 0);
 	atomic64_set(&iproc_priv.bytes_out, 0);
 	for (i = 0; i < SPU_OP_NUM; i++) {
@@ -4808,47 +4819,33 @@ static int spu_dt_read(struct platform_device *pdev)
 	struct resource *spu_ctrl_regs;
 	const struct of_device_id *match;
 	const struct spu_type_subtype *matched_spu_type;
-	void __iomem *spu_reg_vbase[MAX_SPUS];
-	int err;
+	struct device_node *dn = pdev->dev.of_node;
+	int err, i;
+
+	/* Count number of mailbox channels */
+	spu->num_chan = of_count_phandle_with_args(dn, "mboxes", "#mbox-cells");
 
 	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
 	matched_spu_type = match->data;
 
-	if (iproc_priv.spu.num_spu > 1) {
-		/* If this is 2nd or later SPU, make sure it's same type */
-		if ((spu->spu_type != matched_spu_type->type) ||
-		    (spu->spu_subtype != matched_spu_type->subtype)) {
-			err = -EINVAL;
-			dev_err(&pdev->dev, "Multiple SPU types not allowed");
-			return err;
-		}
-	} else {
-		/* Record type of first SPU */
-		spu->spu_type = matched_spu_type->type;
-		spu->spu_subtype = matched_spu_type->subtype;
-	}
+	spu->spu_type = matched_spu_type->type;
+	spu->spu_subtype = matched_spu_type->subtype;
 
-	/* Get and map SPU registers */
-	spu_ctrl_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!spu_ctrl_regs) {
-		err = -EINVAL;
-		dev_err(&pdev->dev, "Invalid/missing registers for SPU\n");
-		return err;
-	}
+	i = 0;
+	for (i = 0; (i < MAX_SPUS) && ((spu_ctrl_regs =
+		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL); i++) {
 
-	spu_reg_vbase[iproc_priv.spu.num_spu] =
-				devm_ioremap_resource(dev, spu_ctrl_regs);
-	if (IS_ERR(spu_reg_vbase[iproc_priv.spu.num_spu])) {
-		err = PTR_ERR(spu_reg_vbase[iproc_priv.spu.num_spu]);
-		dev_err(&pdev->dev, "Failed to map registers: %d\n",
-			err);
-		spu_reg_vbase[iproc_priv.spu.num_spu] = NULL;
-		return err;
+		spu->reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
+		if (IS_ERR(spu->reg_vbase[i])) {
+			err = PTR_ERR(spu->reg_vbase[i]);
+			dev_err(&pdev->dev, "Failed to map registers: %d\n",
+				err);
+			spu->reg_vbase[i] = NULL;
+			return err;
+		}
 	}
-
-	dev_dbg(dev, "SPU %d detected.", iproc_priv.spu.num_spu);
-
-	spu->reg_vbase[iproc_priv.spu.num_spu] = spu_reg_vbase;
+	spu->num_spu = i;
+	dev_dbg(dev, "Device has %d SPUs", spu->num_spu);
 
 	return 0;
 }
@@ -4859,8 +4856,8 @@ int bcm_spu_probe(struct platform_device *pdev)
 	struct spu_hw *spu = &iproc_priv.spu;
 	int err = 0;
 
-	iproc_priv.pdev[iproc_priv.spu.num_spu] = pdev;
-	platform_set_drvdata(iproc_priv.pdev[iproc_priv.spu.num_spu],
+	iproc_priv.pdev  = pdev;
+	platform_set_drvdata(iproc_priv.pdev,
 			     &iproc_priv);
 
 	err = spu_dt_read(pdev);
@@ -4871,12 +4868,6 @@ int bcm_spu_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto failure;
 
-	iproc_priv.spu.num_spu++;
-
-	/* If already initialized, we've just added another SPU and are done */
-	if (iproc_priv.inited)
-		return 0;
-
 	if (spu->spu_type == SPU_TYPE_SPUM)
 		iproc_priv.bcm_hdr_len = 8;
 	else if (spu->spu_type == SPU_TYPE_SPU2)
@@ -4892,8 +4883,6 @@ int bcm_spu_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto fail_reg;
 
-	iproc_priv.inited = true;
-
 	return 0;
 
 fail_reg:
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 51dca52..57a55eb 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -427,10 +427,13 @@ struct spu_hw {
 
 	/* The number of SPUs on this platform */
 	u32 num_spu;
+
+	/* The number of SPU channels on this platform */
+	u32 num_chan;
 };
 
 struct device_private {
-	struct platform_device *pdev[MAX_SPUS];
+	struct platform_device *pdev;
 
 	struct spu_hw spu;
 
@@ -470,12 +473,10 @@ struct device_private {
 	/* Number of ICV check failures for AEAD messages */
 	atomic_t bad_icv;
 
-	struct mbox_client mcl[MAX_SPUS];
-	/* Array of mailbox channel pointers, one for each channel */
-	struct mbox_chan *mbox[MAX_SPUS];
+	struct mbox_client mcl;
 
-	/* Driver initialized */
-	bool inited;
+	/* Array of mailbox channel pointers, one for each channel */
+	struct mbox_chan **mbox;
 };
 
 extern struct device_private iproc_priv;
-- 
1.9.1
