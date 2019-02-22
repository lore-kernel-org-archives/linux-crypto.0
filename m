Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2EBC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 972142075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNZ50ydR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfBVKHe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:07:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35674 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVKHd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 05:07:33 -0500
Received: by mail-wm1-f67.google.com with SMTP id y15so1410367wma.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 02:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L3/UQohT6udXoACylZeYBQEFljcuCTau2g7fruQQnFc=;
        b=qNZ50ydRYvxA5DL4BU43CtzXe6/33o39z3VLNyrSpHCIhrwBXSrj5IUnhmQK6yIT75
         +qCHvqUQN4uSbZoh6Rv2iUNePZ8dkPjr/7jNxfaM48h4pTXKOK3puq8Yo6HRbs6F73Rb
         xr3glIiw+EEbtIwtSA2SuOTaA3lEa1IBwXpgWa18hXrxKYOn3+N9aJgEWERPEUxozP0H
         QQXeCh03M9K1KK2XIDlaTet8UvmpO8t+IAUBYSkIaEvXchypznmlrcGgcRlO/HoK5rmU
         JH8qfZxyHihYQqoPTmxtPEAqwXY4egqCmzfpb7K5pIcMkQKtPJj+fWUv3fJW1BxXL+sG
         /D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L3/UQohT6udXoACylZeYBQEFljcuCTau2g7fruQQnFc=;
        b=MSHtOqp8kxcYYQ0M3eJncPnOLKudMXCnF7Eg5xGn82zCfCpXgctnT0Zv8RTmBByOmg
         UHj5fs2uzbOfULZqICNcsaw2DFo6VSnIC3Du7FhXL7/MBB5frNdH2UH6e8C4/26mQhkY
         82nqLJKLPZDOsvLScmYYvHQ36IbrqSO8MkATvuKJkLUGFbksaXLwBKybIriD0bg7pHa0
         mdzPcan/Kjy31CTquhSgNj+OPjFaPq53+01Ekwggi7iVo/BGJvha7vFYF1YqGpAm/vaA
         uijsKTtyYFYUwZ3BguHl1JXm9CfC20oz341sYwmIbjE5vE7BP+Naa/CmwUH+EYyeL31Y
         8zIw==
X-Gm-Message-State: AHQUAuYU6L20Dg+OsdpHXUHf+1B9LGiJz9T5v+mnKejPF+6kvv1lcRaY
        GHvfR2tX+uytsjp3GOd3uuo=
X-Google-Smtp-Source: AHgI3IaWJG21iVDIV7mJ1dzjuU3HSIg+kGdouDLJ9/uaUgWt19n6tW8sXNhjzmoSNpyo0wO6+PaSGw==
X-Received: by 2002:a1c:2082:: with SMTP id g124mr1831119wmg.59.1550830049008;
        Fri, 22 Feb 2019 02:07:29 -0800 (PST)
Received: from roadflow-linux-dev.dtes.tfl.gov.uk (host81-149-116-186.in-addr.btopenworld.com. [81.149.116.186])
        by smtp.gmail.com with ESMTPSA id j41sm2094240wre.9.2019.02.22.02.07.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:07:27 -0800 (PST)
From:   spencercw@gmail.com
X-Google-Original-From: christopher.spencer@sea.co.uk
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Subject: [RFC 4/4] crypto: caam - use job ring for RNG instantiation instead of DECO
Date:   Fri, 22 Feb 2019 10:06:13 +0000
Message-Id: <20190222100613.2290-5-christopher.spencer@sea.co.uk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

This is required to support the i.MX8.

Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
---
 drivers/crypto/caam/Makefile   |   2 +-
 drivers/crypto/caam/ctrl.c     | 399 +--------------------------------
 drivers/crypto/caam/inst_rng.c | 374 ++++++++++++++++++++++++++++++
 drivers/crypto/caam/inst_rng.h |  18 ++
 drivers/crypto/caam/jr.c       |  15 +-
 5 files changed, 408 insertions(+), 400 deletions(-)
 create mode 100644 drivers/crypto/caam/inst_rng.c
 create mode 100644 drivers/crypto/caam/inst_rng.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 7bbfd06a11ff..1acd3dd2fb07 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caam_pkc.o
 
 caam-objs := ctrl.o
-caam_jr-objs := jr.o key_gen.o
+caam_jr-objs := jr.o key_gen.o inst_rng.o
 caam_pkc-y := caampkc.o pkc_desc.o
 ifneq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI),)
 	ccflags-y += -DCONFIG_CAAM_QI
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 36543a151e1e..e547e2ee5fcc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -39,280 +39,6 @@ static inline struct clk *caam_drv_identify_clk(struct device *dev,
 	return caam_imx ? devm_clk_get(dev, clk_name) : NULL;
 }
 
-/*
- * Descriptor to instantiate RNG State Handle 0 in normal mode and
- * load the JDKEK, TDKEK and TDSK registers
- */
-static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
-{
-	u32 *jump_cmd, op_flags;
-
-	init_job_desc(desc, 0);
-
-	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
-
-	/* INIT RNG in non-test mode */
-	append_operation(desc, op_flags);
-
-	if (!handle && do_sk) {
-		/*
-		 * For SH0, Secure Keys must be generated as well
-		 */
-
-		/* wait for done */
-		jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1);
-		set_jump_tgt_here(desc, jump_cmd);
-
-		/*
-		 * load 1 to clear written reg:
-		 * resets the done interrrupt and returns the RNG to idle.
-		 */
-		append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);
-
-		/* Initialize State Handle  */
-		append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-				 OP_ALG_AAI_RNG4_SK);
-	}
-
-	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
-}
-
-/* Descriptor for deinstantiation of State Handle 0 of the RNG block. */
-static void build_deinstantiation_desc(u32 *desc, int handle)
-{
-	init_job_desc(desc, 0);
-
-	/* Uninstantiate State Handle 0 */
-	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			 (handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INITFINAL);
-
-	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
-}
-
-/*
- * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
- *			  the software (no JR/QI used).
- * @ctrldev - pointer to device
- * @status - descriptor status, after being run
- *
- * Return: - 0 if no error occurred
- *	   - -ENODEV if the DECO couldn't be acquired
- *	   - -EAGAIN if an error occurred while executing the descriptor
- */
-static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
-					u32 *status)
-{
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_ctrl __iomem *ctrl = ctrlpriv->ctrl;
-	struct caam_deco __iomem *deco = ctrlpriv->deco;
-	unsigned int timeout = 100000;
-	u32 deco_dbg_reg, deco_state, flags;
-	int i;
-
-
-	if (ctrlpriv->virt_en == 1) {
-		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);
-
-		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
-		       --timeout)
-			cpu_relax();
-
-		timeout = 100000;
-	}
-
-	clrsetbits_32(&ctrl->deco_rq, 0, DECORR_RQD0ENABLE);
-
-	while (!(rd_reg32(&ctrl->deco_rq) & DECORR_DEN0) &&
-								 --timeout)
-		cpu_relax();
-
-	if (!timeout) {
-		dev_err(ctrldev, "failed to acquire DECO 0\n");
-		clrsetbits_32(&ctrl->deco_rq, DECORR_RQD0ENABLE, 0);
-		return -ENODEV;
-	}
-
-	for (i = 0; i < desc_len(desc); i++)
-		wr_reg32(&deco->descbuf[i], caam32_to_cpu(*(desc + i)));
-
-	flags = DECO_JQCR_WHL;
-	/*
-	 * If the descriptor length is longer than 4 words, then the
-	 * FOUR bit in JRCTRL register must be set.
-	 */
-	if (desc_len(desc) >= 4)
-		flags |= DECO_JQCR_FOUR;
-
-	/* Instruct the DECO to execute it */
-	clrsetbits_32(&deco->jr_ctl_hi, 0, flags);
-
-	timeout = 10000000;
-	do {
-		deco_dbg_reg = rd_reg32(&deco->desc_dbg);
-
-		if (ctrlpriv->era < 10)
-			deco_state = (deco_dbg_reg & DESC_DBG_DECO_STAT_MASK) >>
-				     DESC_DBG_DECO_STAT_SHIFT;
-		else
-			deco_state = (rd_reg32(&deco->dbg_exec) &
-				      DESC_DER_DECO_STAT_MASK) >>
-				     DESC_DER_DECO_STAT_SHIFT;
-
-		/*
-		 * If an error occured in the descriptor, then
-		 * the DECO status field will be set to 0x0D
-		 */
-		if (deco_state == DECO_STAT_HOST_ERR)
-			break;
-
-		cpu_relax();
-	} while ((deco_dbg_reg & DESC_DBG_DECO_STAT_VALID) && --timeout);
-
-	*status = rd_reg32(&deco->op_status_hi) &
-		  DECO_OP_STATUS_HI_ERR_MASK;
-
-	if (ctrlpriv->virt_en == 1)
-		clrsetbits_32(&ctrl->deco_rsr, DECORSR_JR0, 0);
-
-	/* Mark the DECO as free */
-	clrsetbits_32(&ctrl->deco_rq, DECORR_RQD0ENABLE, 0);
-
-	if (!timeout)
-		return -EAGAIN;
-
-	return 0;
-}
-
-/*
- * instantiate_rng - builds and executes a descriptor on DECO0,
- *		     which initializes the RNG block.
- * @ctrldev - pointer to device
- * @state_handle_mask - bitmask containing the instantiation status
- *			for the RNG4 state handles which exist in
- *			the RNG4 block: 1 if it's been instantiated
- *			by an external entry, 0 otherwise.
- * @gen_sk  - generate data to be loaded into the JDKEK, TDKEK and TDSK;
- *	      Caution: this can be done only once; if the keys need to be
- *	      regenerated, a POR is required
- *
- * Return: - 0 if no error occurred
- *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
- *	   - -ENODEV if DECO0 couldn't be acquired
- *	   - -EAGAIN if an error occurred when executing the descriptor
- *	      f.i. there was a RNG hardware error due to not "good enough"
- *	      entropy being aquired.
- */
-static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
-			   int gen_sk)
-{
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_ctrl __iomem *ctrl;
-	u32 *desc, status = 0, rdsta_val;
-	int ret = 0, sh_idx;
-
-	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
-		/*
-		 * If the corresponding bit is set, this state handle
-		 * was initialized by somebody else, so it's left alone.
-		 */
-		if ((1 << sh_idx) & state_handle_mask)
-			continue;
-
-		/* Create the descriptor for instantiating RNG State Handle */
-		build_instantiation_desc(desc, sh_idx, gen_sk);
-
-		/* Try to run it through DECO0 */
-		ret = run_descriptor_deco0(ctrldev, desc, &status);
-
-		/*
-		 * If ret is not 0, or descriptor status is not 0, then
-		 * something went wrong. No need to try the next state
-		 * handle (if available), bail out here.
-		 * Also, if for some reason, the State Handle didn't get
-		 * instantiated although the descriptor has finished
-		 * without any error (HW optimizations for later
-		 * CAAM eras), then try again.
-		 */
-		if (ret)
-			break;
-
-		rdsta_val = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
-		if ((status && status != JRSTA_SSRC_JUMP_HALT_CC) ||
-		    !(rdsta_val & (1 << sh_idx))) {
-			ret = -EAGAIN;
-			break;
-		}
-
-		dev_info(ctrldev, "Instantiated RNG4 SH%d\n", sh_idx);
-		/* Clear the contents before recreating the descriptor */
-		memset(desc, 0x00, CAAM_CMD_SZ * 7);
-	}
-
-	kfree(desc);
-
-	return ret;
-}
-
-/*
- * deinstantiate_rng - builds and executes a descriptor on DECO0,
- *		       which deinitializes the RNG block.
- * @ctrldev - pointer to device
- * @state_handle_mask - bitmask containing the instantiation status
- *			for the RNG4 state handles which exist in
- *			the RNG4 block: 1 if it's been instantiated
- *
- * Return: - 0 if no error occurred
- *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
- *	   - -ENODEV if DECO0 couldn't be acquired
- *	   - -EAGAIN if an error occurred when executing the descriptor
- */
-static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
-{
-	u32 *desc, status;
-	int sh_idx, ret = 0;
-
-	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
-		/*
-		 * If the corresponding bit is set, then it means the state
-		 * handle was initialized by us, and thus it needs to be
-		 * deinitialized as well
-		 */
-		if ((1 << sh_idx) & state_handle_mask) {
-			/*
-			 * Create the descriptor for deinstantating this state
-			 * handle
-			 */
-			build_deinstantiation_desc(desc, sh_idx);
-
-			/* Try to run it through DECO0 */
-			ret = run_descriptor_deco0(ctrldev, desc, &status);
-
-			if (ret ||
-			    (status && status != JRSTA_SSRC_JUMP_HALT_CC)) {
-				dev_err(ctrldev,
-					"Failed to deinstantiate RNG4 SH%d\n",
-					sh_idx);
-				break;
-			}
-			dev_info(ctrldev, "Deinstantiated RNG4 SH%d\n", sh_idx);
-		}
-	}
-
-	kfree(desc);
-
-	return ret;
-}
-
 static int caam_remove(struct platform_device *pdev)
 {
 	struct device *ctrldev;
@@ -331,13 +57,6 @@ static int caam_remove(struct platform_device *pdev)
 		caam_qi_shutdown(ctrlpriv->qidev);
 #endif
 
-	/*
-	 * De-initialize RNG state handles initialized by this driver.
-	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
-	 */
-	if (!ctrlpriv->mc_en && ctrlpriv->rng4_sh_init)
-		deinstantiate_rng(ctrldev, ctrlpriv->rng4_sh_init);
-
 	/* Shut down debug views */
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove_recursive(ctrlpriv->dfs_root);
@@ -356,57 +75,6 @@ static int caam_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/*
- * kick_trng - sets the various parameters for enabling the initialization
- *	       of the RNG4 block in CAAM
- * @pdev - pointer to the platform device
- * @ent_delay - Defines the length (in system clocks) of each entropy sample.
- */
-static void kick_trng(struct platform_device *pdev, int ent_delay)
-{
-	struct device *ctrldev = &pdev->dev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_ctrl __iomem *ctrl;
-	struct rng4tst __iomem *r4tst;
-	u32 val;
-
-	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	r4tst = &ctrl->r4tst[0];
-
-	/* put RNG4 into program mode */
-	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM);
-
-	/*
-	 * Performance-wise, it does not make sense to
-	 * set the delay to a value that is lower
-	 * than the last one that worked (i.e. the state handles
-	 * were instantiated properly. Thus, instead of wasting
-	 * time trying to set the values controlling the sample
-	 * frequency, the function simply returns.
-	 */
-	val = (rd_reg32(&r4tst->rtsdctl) & RTSDCTL_ENT_DLY_MASK)
-	      >> RTSDCTL_ENT_DLY_SHIFT;
-	if (ent_delay <= val)
-		goto start_rng;
-
-	val = rd_reg32(&r4tst->rtsdctl);
-	val = (val & ~RTSDCTL_ENT_DLY_MASK) |
-	      (ent_delay << RTSDCTL_ENT_DLY_SHIFT);
-	wr_reg32(&r4tst->rtsdctl, val);
-	/* min. freq. count, equal to 1/4 of the entropy sample length */
-	wr_reg32(&r4tst->rtfrqmin, ent_delay >> 2);
-	/* disable maximum frequency count */
-	wr_reg32(&r4tst->rtfrqmax, RTFRQMAX_DISABLE);
-	/* read the control register */
-	val = rd_reg32(&r4tst->rtmctl);
-start_rng:
-	/*
-	 * select raw sampling in both entropy shifter
-	 * and statistical checker; ; put RNG4 into run mode
-	 */
-	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM, RTMCTL_SAMP_MODE_RAW_ES_SC);
-}
-
 static int caam_get_era_from_hw(struct caam_ctrl __iomem *ctrl)
 {
 	static const struct {
@@ -571,7 +239,7 @@ MODULE_DEVICE_TABLE(of, caam_match);
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	int ret, ring;
 	u64 caam_id;
 	static const struct soc_device_attribute imx_soc[] = {
 		{.family = "Freescale i.MX"},
@@ -771,71 +439,6 @@ static int caam_probe(struct platform_device *pdev)
 		rng_vid = (rd_reg32(&ctrl->vreg.rng) & CHA_VER_VID_MASK) >>
 			   CHA_VER_VID_SHIFT;
 
-	/*
-	 * If SEC has RNG version >= 4 and RNG state handle has not been
-	 * already instantiated, do RNG instantiation
-	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
-	 */
-	if (!ctrlpriv->mc_en && rng_vid >= 4) {
-		ctrlpriv->rng4_sh_init =
-			rd_reg32(&ctrl->r4tst[0].rdsta);
-		/*
-		 * If the secure keys (TDKEK, JDKEK, TDSK), were already
-		 * generated, signal this to the function that is instantiating
-		 * the state handles. An error would occur if RNG4 attempts
-		 * to regenerate these keys before the next POR.
-		 */
-		gen_sk = ctrlpriv->rng4_sh_init & RDSTA_SKVN ? 0 : 1;
-		ctrlpriv->rng4_sh_init &= RDSTA_IFMASK;
-		do {
-			int inst_handles =
-				rd_reg32(&ctrl->r4tst[0].rdsta) &
-								RDSTA_IFMASK;
-			/*
-			 * If either SH were instantiated by somebody else
-			 * (e.g. u-boot) then it is assumed that the entropy
-			 * parameters are properly set and thus the function
-			 * setting these (kick_trng(...)) is skipped.
-			 * Also, if a handle was instantiated, do not change
-			 * the TRNG parameters.
-			 */
-			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
-				dev_info(dev,
-					 "Entropy delay = %u\n",
-					 ent_delay);
-				kick_trng(pdev, ent_delay);
-				ent_delay += 400;
-			}
-			/*
-			 * if instantiate_rng(...) fails, the loop will rerun
-			 * and the kick_trng(...) function will modfiy the
-			 * upper and lower limits of the entropy sampling
-			 * interval, leading to a sucessful initialization of
-			 * the RNG.
-			 */
-			ret = instantiate_rng(dev, inst_handles,
-					      gen_sk);
-			if (ret == -EAGAIN)
-				/*
-				 * if here, the loop will rerun,
-				 * so don't hog the CPU
-				 */
-				cpu_relax();
-		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
-		if (ret) {
-			dev_err(dev, "failed to instantiate RNG");
-			goto caam_remove;
-		}
-		/*
-		 * Set handles init'ed by this module as the complement of the
-		 * already initialized ones
-		 */
-		ctrlpriv->rng4_sh_init = ~ctrlpriv->rng4_sh_init & RDSTA_IFMASK;
-
-		/* Enable RDB bit so that RNG works faster */
-		clrsetbits_32(&ctrl->scfgr, 0, SCFGR_RDBENABLE);
-	}
-
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
 	caam_id = (u64)rd_reg32(&ctrl->perfmon.caam_id_ms) << 32 |
diff --git a/drivers/crypto/caam/inst_rng.c b/drivers/crypto/caam/inst_rng.c
new file mode 100644
index 000000000000..851bf7374cdb
--- /dev/null
+++ b/drivers/crypto/caam/inst_rng.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CAAM RNG instantiation driver backend
+ *
+ * Copyright 2017-2018 NXP
+ */
+
+#include <linux/device.h>
+#include <linux/of_address.h>
+#include <linux/wait.h>
+#include "compat.h"
+#include "regs.h"
+#include "intern.h"
+#include "jr.h"
+#include "desc_constr.h"
+#include "error.h"
+#include "ctrl.h"
+#include "inst_rng.h"
+
+static DECLARE_WAIT_QUEUE_HEAD(wq_desc);
+static int desc_completed;
+static int desc_status;
+
+/*
+ * Descriptor to instantiate RNG State Handle 0 in normal mode and
+ * load the JDKEK, TDKEK and TDSK registers
+ */
+static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
+{
+	u32 *jump_cmd, op_flags;
+
+	init_job_desc(desc, 0);
+
+	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
+
+	/* INIT RNG in non-test mode */
+	append_operation(desc, op_flags);
+
+	if (!handle && do_sk) {
+		/*
+		 * For SH0, Secure Keys must be generated as well
+		 */
+
+		/* wait for done */
+		jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1);
+		set_jump_tgt_here(desc, jump_cmd);
+
+		/*
+		 * load 1 to clear written reg:
+		 * resets the done interrupt and returns the RNG to idle.
+		 */
+		append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);
+
+		/* Initialize State Handle  */
+		append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+				 OP_ALG_AAI_RNG4_SK);
+	}
+
+	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
+}
+
+/* Descriptor for deinstantiation of State Handle 0 of the RNG block. */
+static void build_deinstantiation_desc(u32 *desc, int handle)
+{
+	init_job_desc(desc, 0);
+
+	/* Uninstantiate State Handle 0 */
+	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
+			 (handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INITFINAL);
+
+	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
+}
+
+void cbk_jr_rng_inst(struct device *jrdev, u32 *desc, u32 status, void *areq)
+{
+	if ((status & JRSTA_SSRC_JUMP_HALT_CC) == JRSTA_SSRC_JUMP_HALT_CC) {
+		dev_info(jrdev, "Instantiated RNG4 SH%d.\n", *((int *)areq));
+		desc_status = 0;
+	} else {
+		desc_status = -EAGAIN;
+	}
+	desc_completed = 1;
+	wake_up(&wq_desc);
+}
+
+/*
+ * run_descriptor_jr - runs a descriptor on first JR
+ * @status - descriptor status, after being run
+ *
+ * Return: - 0 if no error occurred
+ *	   - -ENODEV if the JR couldn't be acquired
+ *	   - -EAGAIN if an error occurred while executing the descriptor
+ */
+static int run_descriptor_jr(u32 *desc, int sh_idx)
+{
+	struct device *jrdev;
+	int ret;
+
+	jrdev = caam_jr_alloc();
+	if (IS_ERR(jrdev)) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return -ENODEV;
+	}
+	ret = caam_jr_enqueue(jrdev, desc, cbk_jr_rng_inst, &sh_idx);
+	if (ret) {
+		dev_err(jrdev, "caam_jr_enqueue() failed\n");
+		return ret;
+	}
+
+	/* wait for job descriptor completion */
+	wait_event(wq_desc, desc_completed != 0);
+	desc_completed = 0;
+	caam_jr_free(jrdev);
+	return desc_status;
+}
+
+/*
+ * instantiate_rng - builds and executes a descriptor on JR0,
+ *		     which initializes the RNG block.
+ * @state_handle_mask - bitmask containing the instantiation status
+ *			for the RNG4 state handles which exist in
+ *			the RNG4 block: 1 if it's been instantiated
+ *			by an external entry, 0 otherwise.
+ * @gen_sk  - generate data to be loaded into the JDKEK, TDKEK and TDSK;
+ *	      Caution: this can be done only once; if the keys need to be
+ *	      regenerated, a POR is required
+ *
+ * Return: - 0 if no error occurred
+ *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
+ *	   - -ENODEV if DECO0 couldn't be acquired
+ *	   - -EAGAIN if an error occurred when executing the descriptor
+ *	      f.i. there was a RNG hardware error due to not "good enough"
+ *	      entropy being acquired.
+ */
+static int instantiate_rng(int state_handle_mask, int gen_sk)
+{
+	u32 *desc;
+	int sh_idx, ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		/*
+		 * If the corresponding bit is set, this state handle
+		 * was initialized by somebody else, so it's left alone.
+		 */
+		if ((1 << sh_idx) & state_handle_mask)
+			continue;
+
+		/* Create the descriptor for instantiating RNG State Handle */
+		build_instantiation_desc(desc, sh_idx, gen_sk);
+
+		/* Try to run it through JR */
+		ret = run_descriptor_jr(desc, sh_idx);
+		if (ret)
+			pr_debug("Failed to run desc  RNG4 SH%d status (0x%x)\n",
+				 sh_idx, ret);
+		/* Clear the contents before recreating the descriptor */
+		memset(desc, 0x00, CAAM_CMD_SZ * 7);
+	}
+
+	kfree(desc);
+
+	return ret;
+}
+
+/*
+ * deinstantiate_rng - builds and executes a descriptor on JR0,
+ *		       which deinitializes the RNG block.
+ * @state_handle_mask - bitmask containing the instantiation status
+ *			for the RNG4 state handles which exist in
+ *			the RNG4 block: 1 if it's been instantiated
+ *
+ * Return: - 0 if no error occurred
+ *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
+ *	   - -ENODEV if DECO0 couldn't be acquired
+ *	   - -EAGAIN if an error occurred when executing the descriptor
+ */
+int deinstantiate_rng(int state_handle_mask)
+{
+	u32 *desc;
+	int sh_idx, ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		/*
+		 * If the corresponding bit is set, then it means the state
+		 * handle was initialized by us, and thus it needs to be
+		 * deinitialized as well
+		 */
+		if ((1 << sh_idx) & state_handle_mask) {
+			/*
+			 * Create the descriptor for deinstantating this state
+			 * handle
+			 */
+			build_deinstantiation_desc(desc, sh_idx);
+
+			/* Try to run it through JR */
+			ret = run_descriptor_jr(desc, sh_idx);
+			if (ret)
+				pr_debug("Failed to run desc to deinstantiate RNG4 SH%d\n",
+					 sh_idx);
+		}
+	}
+
+	kfree(desc);
+
+	return ret;
+}
+
+/*
+ * kick_trng - sets the various parameters for enabling the initialization
+ *	       of the RNG4 block in CAAM
+ * @ctrldev - pointer to the device
+ * @ent_delay - Defines the length (in system clocks) of each entropy sample.
+ */
+static void kick_trng(struct device *ctrldev, int ent_delay)
+{
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_ctrl __iomem *ctrl;
+	struct rng4tst __iomem *r4tst;
+	u32 val;
+
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+	r4tst = &ctrl->r4tst[0];
+
+	/* put RNG4 into program mode */
+	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM);
+
+	/*
+	 * Performance-wise, it does not make sense to
+	 * set the delay to a value that is lower
+	 * than the last one that worked (i.e. the state handles
+	 * were instantiated properly. Thus, instead of wasting
+	 * time trying to set the values controlling the sample
+	 * frequency, the function simply returns.
+	 */
+	val = (rd_reg32(&r4tst->rtsdctl) & RTSDCTL_ENT_DLY_MASK)
+	      >> RTSDCTL_ENT_DLY_SHIFT;
+	if (ent_delay <= val) {
+		/* put RNG4 into run mode */
+		clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM, 0);
+		return;
+	}
+
+	val = rd_reg32(&r4tst->rtsdctl);
+	val = (val & ~RTSDCTL_ENT_DLY_MASK) |
+	      (ent_delay << RTSDCTL_ENT_DLY_SHIFT);
+	wr_reg32(&r4tst->rtsdctl, val);
+	/* min. freq. count, equal to 1/4 of the entropy sample length */
+	wr_reg32(&r4tst->rtfrqmin, ent_delay >> 2);
+	/* max. freq. count, equal to 16 times the entropy sample length */
+	wr_reg32(&r4tst->rtfrqmax, ent_delay << 4);
+	/* read the control register */
+	val = rd_reg32(&r4tst->rtmctl);
+	/*
+	 * select raw sampling in both entropy shifter
+	 * and statistical checker
+	 */
+	clrsetbits_32(&val, 0, RTMCTL_SAMP_MODE_RAW_ES_SC);
+	/* put RNG4 into run mode */
+	clrsetbits_32(&val, RTMCTL_PRGM, 0);
+	/* write back the control register */
+	wr_reg32(&r4tst->rtmctl, val);
+}
+
+/*
+ * inst_rng_imx - RNG instantiation function for i.MX6/7/8m platforms
+ * @pdev - pointer to the device
+ */
+int inst_rng_imx(struct platform_device *pdev)
+{
+	struct device *ctrldev, *dev;
+	struct caam_drv_private *ctrlpriv;
+	struct caam_ctrl __iomem *ctrl;
+	int ret = 0, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	u32 cha_vid_ls;
+
+	dev = &pdev->dev;
+	ctrldev = pdev->dev.parent;
+	ctrlpriv = dev_get_drvdata(ctrldev);
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+
+	cha_vid_ls = rd_reg32(&ctrl->perfmon.cha_id_ls);
+
+	/*
+	 * If SEC has RNG version >= 4 and RNG state handle has not been
+	 * already instantiated, do RNG instantiation
+	 * In case of DPAA 2.x, RNG is managed by MC firmware.
+	 */
+	if (!caam_dpaa2 &&
+		(cha_vid_ls & CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT >= 4) {
+		ctrlpriv->rng4_sh_init =
+			rd_reg32(&ctrl->r4tst[0].rdsta);
+		/*
+		 * If the secure keys (TDKEK, JDKEK, TDSK), were already
+		 * generated, signal this to the function that is instantiating
+		 * the state handles. An error would occur if RNG4 attempts
+		 * to regenerate these keys before the next POR.
+		 */
+		gen_sk = ctrlpriv->rng4_sh_init & RDSTA_SKVN ? 0 : 1;
+		ctrlpriv->rng4_sh_init &= RDSTA_IFMASK;
+		do {
+			int inst_handles =
+				rd_reg32(&ctrl->r4tst[0].rdsta) &
+								RDSTA_IFMASK;
+			/*
+			 * If either SH were instantiated by somebody else
+			 * (e.g. u-boot) then it is assumed that the entropy
+			 * parameters are properly set and thus the function
+			 * setting these (kick_trng(...)) is skipped.
+			 * Also, if a handle was instantiated, do not change
+			 * the TRNG parameters.
+			 */
+			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
+				dev_info(dev,
+					 "Entropy delay = %u\n",
+					 ent_delay);
+				kick_trng(ctrldev, ent_delay);
+				ent_delay += ENT_DELAY_STEP;
+			}
+			/*
+			 * if instantiate_rng(...) fails, the loop will rerun
+			 * and the kick_trng(...) function will modify the
+			 * upper and lower limits of the entropy sampling
+			 * interval, leading to a sucessful initialization of
+			 * the RNG.
+			 */
+			ret = instantiate_rng(inst_handles, gen_sk);
+			if (ret == -EAGAIN)
+				/*
+				 * if here, the loop will rerun,
+				 * so don't hog the CPU
+				 */
+				cpu_relax();
+		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
+		if (ret) {
+			dev_err(dev, "failed to instantiate RNG");
+			return ret;
+		}
+		/*
+		 * Set handles init'ed by this module as the complement of the
+		 * already initialized ones
+		 */
+		ctrlpriv->rng4_sh_init = ~ctrlpriv->rng4_sh_init & RDSTA_IFMASK;
+		/* Enable RDB bit so that RNG works faster */
+		clrsetbits_32(&ctrl->scfgr, 0, SCFGR_RDBENABLE);
+	}
+	return ret;
+}
+
+/*
+ * deinst_rng - RNG de-instantiation function
+ * @pdev - pointer to the device
+ */
+int deinst_rng(struct platform_device *pdev)
+{
+	struct device *ctrldev, *dev;
+	struct caam_drv_private *ctrlpriv;
+	int ret = 0;
+
+	dev = &pdev->dev;
+	ctrldev = pdev->dev.parent;
+	ctrlpriv = dev_get_drvdata(ctrldev);
+
+	ret = deinstantiate_rng(ctrlpriv->rng4_sh_init);
+	return ret;
+}
diff --git a/drivers/crypto/caam/inst_rng.h b/drivers/crypto/caam/inst_rng.h
new file mode 100644
index 000000000000..e0477262fe2a
--- /dev/null
+++ b/drivers/crypto/caam/inst_rng.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * CAAM Private/internal definitions between modules
+ *
+ * Copyright 2017-2018 NXP
+ */
+
+#ifndef INST_RNG_H
+#define INST_RNG_H
+
+#include <linux/platform_device.h>
+
+#define ENT_DELAY_STEP	(400)
+int inst_rng_imx(struct platform_device *pdev);
+
+int deinst_rng(struct platform_device *pdev);
+
+#endif /* INST_RNG_H */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ac5ae14be233..a94860bc21a1 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -15,6 +15,7 @@
 #include "jr.h"
 #include "desc.h"
 #include "intern.h"
+#include "inst_rng.h"
 
 struct jr_driver_data {
 	/* List of Physical JobR's with the Driver */
@@ -101,6 +102,12 @@ static int caam_jr_remove(struct platform_device *pdev)
 	jrdev = &pdev->dev;
 	jrpriv = dev_get_drvdata(jrdev);
 
+	/*
+	 * Deinstantiate RNG by first JR
+	 */
+	if (jrpriv->ridx == 0)
+		deinst_rng(pdev);
+
 	/*
 	 * Return EBUSY if job ring already allocated.
 	 */
@@ -542,7 +549,13 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	atomic_set(&jrpriv->tfm_count, 0);
 
-	return 0;
+	/*
+	 * Instantiate RNG by JR rather than DECO
+	 */
+	if (jrpriv->ridx == 0)
+		error = inst_rng_imx(pdev);
+
+	return error;
 }
 
 static const struct of_device_id caam_jr_match[] = {
-- 
2.17.1

