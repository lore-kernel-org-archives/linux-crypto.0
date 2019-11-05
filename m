Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47983C5DF60
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A6D214D8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3TqxC1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbfKEPOH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:07 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42822 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfKEPOG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id s23so11039564pgo.9;
        Tue, 05 Nov 2019 07:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1w3iW7NTvN7La5YhT9YPtWdscsba7Z3HfgTz1LRXGDw=;
        b=F3TqxC1rAGQKctXjsHfSdIQbCR2wkSeUBb/oHkQrDwsEzsk4XA/WuxlVJVvqWQ45Rw
         Csj2uvWnl035M9+SsTWJ7IkDYXwGYk/xwppR4HeIsHc6fRPC5Syg0nFAaWnUUUksLbbU
         EB9kqhE7scirGIDIIx4aGk2noRio4bwANMzQotiU4S/nHSQX1249tTw79EXJHTZ8GPCk
         zhZL5v5kzSp0eeTZ92n5fbZRED8Aqd5o+gSgJNYWF+i9pbqVnJZUnXZjLNrrdO6Wxc/q
         LbYCZvi9JXc1P8cGINHLL9u4lbdMWTIKeLp/X6d2XOG9eZvJhJdgI44T4fZKJlx7kwPD
         A3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1w3iW7NTvN7La5YhT9YPtWdscsba7Z3HfgTz1LRXGDw=;
        b=i0oWahxc2GmKZQh3J1TG2hQeNIqdEUe5cL3ZNyLswMMD+BqUbD2IonqC4RLTxOogBp
         1RvCVzLAWHrRuE9xR3CNRIGrRay0PeAuPj+0PfJNerLfiyjlandtsthBx3YxuI42VytM
         pDCG9K+TIui8YL9cGuI01+jR95YKJTJBdzAvUzD2NLxvH7tllQ0LrJvG9qlz6Vl+vPON
         dRudsINKIh/lQWf9O+8nZHzs8PcOWRMz/Ajsn9OZX8VPn9zFa2ueJDseA6jTXH1hQlea
         EqGu/cnKc/9Z2pBQ79SMsD35HtT/ARi2RiY8OvWUVlXL0sS9kyXN3cPgplyIQ3bHxnLj
         m6uA==
X-Gm-Message-State: APjAAAUKR/E6mR4z0bdwwF7471noUiNuKG9+NnAN/Q5WeN08yidiGGgm
        RX+2ilU2+1q+BzUT+B0eXl9EZ3em
X-Google-Smtp-Source: APXvYqx2xKUbqls/9/YgBoEYXCJJRh6/fOOjgxQbUr4rrJbFC/aRqLNcahk4/hSZ309+DnX0LsL7/w==
X-Received: by 2002:a63:d50a:: with SMTP id c10mr4633482pgg.327.1572966845062;
        Tue, 05 Nov 2019 07:14:05 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:14:04 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] crypto: caam - do not create a platform devices for JRs
Date:   Tue,  5 Nov 2019 07:13:52 -0800
Message-Id: <20191105151353.6522-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Job rings are an integral part of underlying CAAM IP and treating them
as independent devices means that we have to:

1. Properly maintain device reference counter
   via (get_device/put_device). Currently not implemented

2. Properly coordinate lifecycle of the underlying platform
   device (e.g. removal via 'unbind') with active users of that
   JR. Not implemented currently as well.

3. Have extra logic to initialize crypto algorithms after at least one
   JR has been registered (see register_algs() and related code)

Instead of adding extra code to deal with #1 and #2 above and open up
the possibility of simpliying #3, convert the driver to not create
platform devices for available JR and instead treat them as internal
implementation detail while providing same API to all of the original
users.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/Kconfig      |   5 +-
 drivers/crypto/caam/Makefile     |  15 ++--
 drivers/crypto/caam/caamalg.c    |  10 +--
 drivers/crypto/caam/caamalg_qi.c |   4 +-
 drivers/crypto/caam/caamhash.c   |   6 +-
 drivers/crypto/caam/ctrl.c       |  15 +++-
 drivers/crypto/caam/jr.c         | 136 +++++++------------------------
 drivers/crypto/caam/jr.h         |   1 +
 8 files changed, 62 insertions(+), 130 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 137ed3df0c74..86ab869e4176 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -32,7 +32,7 @@ config CRYPTO_DEV_FSL_CAAM_DEBUG
 	  information in the CAAM driver.
 
 menuconfig CRYPTO_DEV_FSL_CAAM_JR
-	tristate "Freescale CAAM Job Ring driver backend"
+	bool "Freescale CAAM Job Ring driver backend"
 	default y
 	help
 	  Enables the driver module for Job Rings which are part of
@@ -40,9 +40,6 @@ menuconfig CRYPTO_DEV_FSL_CAAM_JR
 	  and Assurance Module (CAAM). This module adds a job ring operation
 	  interface.
 
-	  To compile this driver as a module, choose M here: the module
-	  will be called caam_jr.
-
 if CRYPTO_DEV_FSL_CAAM_JR
 
 config CRYPTO_DEV_FSL_CAAM_RINGSIZE
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 68d5cc0f28e2..ab6c094f8bd8 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -10,17 +10,18 @@ ccflags-y += -DVERSION=\"\"
 
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += error.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC) += caamalg_desc.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC) += caamhash_desc.o
 
 caam-y := ctrl.o
-caam_jr-y := jr.o key_gen.o
-caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
-caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
-caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
-caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
-caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caampkc.o pkc_desc.o
+ifneq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_JR),)
+caam-y += jr.o key_gen.o
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caampkc.o pkc_desc.o
+endif
 
 caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += qi.o
 ifneq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI),)
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4cb7d5b281cc..f2230256ef9f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -118,7 +118,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jr->dev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - AEAD_DESC_JOB_IO_LEN -
 			ctx->adata.keylen_pad;
@@ -171,7 +171,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jr->dev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	u32 ctx1_iv_off = 0;
 	u32 *desc, *nonce = NULL;
 	u32 inl_mask;
@@ -564,7 +564,7 @@ static int aead_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jr->dev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	struct crypto_authenc_keys keys;
 	int ret = 0;
 
@@ -1223,7 +1223,7 @@ static void init_authenc_job(struct aead_request *req,
 						 struct caam_aead_alg, aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jr->dev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jr->dev);
 	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
@@ -3421,7 +3421,7 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 		return PTR_ERR(ctx->jr);
 	}
 
-	priv = dev_get_drvdata(ctx->jr->dev->parent);
+	priv = dev_get_drvdata(ctx->jr->dev);
 	if (priv->era >= 6 && uses_dkp)
 		ctx->dir = DMA_BIDIRECTIONAL;
 	else
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 31bee401f9e5..b8905e3a9c80 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -82,7 +82,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev);
 
 	if (!ctx->cdata.keylen || !ctx->authsize)
 		return 0;
@@ -189,7 +189,7 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	struct crypto_authenc_keys keys;
 	int ret = 0;
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 6e4fd5eb833a..94ecad06a120 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -224,7 +224,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct device *jrdev = ctx->jr->dev;
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	u32 *desc;
 
 	ctx->adata.key_virt = ctx->key;
@@ -447,7 +447,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 	struct device *jrdev = ctx->jr->dev;
 	int blocksize = crypto_tfm_alg_blocksize(&ahash->base);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev);
 	int ret;
 	u8 *hashed_key = NULL;
 
@@ -1839,7 +1839,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 		return PTR_ERR(ctx->jr);
 	}
 
-	priv = dev_get_drvdata(ctx->jr->dev->parent);
+	priv = dev_get_drvdata(ctx->jr->dev);
 
 	if (is_xcbc_aes(caam_hash->alg_type)) {
 		ctx->dir = DMA_TO_DEVICE;
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d7c3c3805693..0fb39bcf638a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -900,9 +900,18 @@ static int caam_probe(struct platform_device *pdev)
 			    &ctrlpriv->ctl_tdsk_wrap);
 #endif
 
-	ret = devm_of_platform_populate(dev);
-	if (ret)
-		dev_err(dev, "JR platform devices creation error\n");
+	for_each_available_child_of_node(nprop, np) {
+		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
+		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
+			ret = caam_jr_probe(dev, np);
+			if (ret) {
+				dev_err(dev,
+				       "JR platform devices creation error\n");
+				of_node_put(np);
+				break;
+			}
+		}
+	}
 
 	return ret;
 }
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1e2929b7c6b9..7f0d192b9276 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -65,9 +65,9 @@ static void unregister_algs(void)
 	mutex_unlock(&algs_lock);
 }
 
-static int caam_reset_hw_jr(struct device *dev)
+static int caam_reset_hw_jr(struct caam_drv_private_jr *jrp)
 {
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct device *dev = jrp->dev;
 	unsigned int timeout = 100000;
 
 	/*
@@ -105,37 +105,11 @@ static int caam_reset_hw_jr(struct device *dev)
 	return 0;
 }
 
-/*
- * Shutdown JobR independent of platform property code
- */
-static int caam_jr_shutdown(struct device *dev)
-{
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	int ret;
-
-	ret = caam_reset_hw_jr(dev);
-
-	tasklet_kill(&jrp->irqtask);
-
-	return ret;
-}
-
-static int caam_jr_remove(struct platform_device *pdev)
+static void caam_jr_remove(void *data)
 {
 	int ret;
-	struct device *jrdev;
-	struct caam_drv_private_jr *jrpriv;
-
-	jrdev = &pdev->dev;
-	jrpriv = dev_get_drvdata(jrdev);
-
-	/*
-	 * Return EBUSY if job ring already allocated.
-	 */
-	if (atomic_read(&jrpriv->tfm_count)) {
-		dev_err(jrdev, "Device is busy\n");
-		return -EBUSY;
-	}
+	struct caam_drv_private_jr *jrpriv = data;
+	struct device *jrdev = jrpriv->dev;
 
 	/* Unregister JR-based RNG & crypto algorithms */
 	unregister_algs();
@@ -146,18 +120,18 @@ static int caam_jr_remove(struct platform_device *pdev)
 	spin_unlock(&driver_data.jr_alloc_lock);
 
 	/* Release ring */
-	ret = caam_jr_shutdown(jrdev);
+	ret = caam_reset_hw_jr(jrpriv);
 	if (ret)
 		dev_err(jrdev, "Failed to shut down job ring\n");
 
-	return ret;
+	tasklet_kill(&jrpriv->irqtask);
 }
 
 /* Main per-ring interrupt handler */
 static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 {
-	struct device *dev = st_dev;
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp = st_dev;
+	struct device *dev = jrp->dev;
 	u32 irqstate;
 
 	/*
@@ -195,8 +169,8 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 static void caam_jr_dequeue(unsigned long devarg)
 {
 	int hw_idx, sw_idx, i, head, tail;
-	struct device *dev = (struct device *)devarg;
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp = (void *)devarg;
+	struct device *dev = jrp->dev;
 	caam_jr_cbk usercall;
 	u32 *userdesc, userstatus;
 	void *userarg;
@@ -418,15 +392,13 @@ EXPORT_SYMBOL(caam_jr_enqueue);
 /*
  * Init JobR independent of platform property detection
  */
-static int caam_jr_init(struct device *dev)
+static int caam_jr_init(struct caam_drv_private_jr *jrp)
 {
-	struct caam_drv_private_jr *jrp;
+	struct device *dev = jrp->dev;
 	dma_addr_t inpbusaddr, outbusaddr;
 	int i, error;
 
-	jrp = dev_get_drvdata(dev);
-
-	error = caam_reset_hw_jr(dev);
+	error = caam_reset_hw_jr(jrp);
 	if (error)
 		return error;
 
@@ -469,11 +441,11 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)jrp);
 
 	/* Connect job ring interrupt handler. */
 	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-				 dev_name(dev), dev);
+				 dev_name(dev), jrp);
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
@@ -491,36 +463,29 @@ static void caam_jr_irq_dispose_mapping(void *data)
 /*
  * Probe routine for each detected JobR subsystem.
  */
-static int caam_jr_probe(struct platform_device *pdev)
+int caam_jr_probe(struct device *jrdev, struct device_node *nprop)
 {
-	struct device *jrdev;
-	struct device_node *nprop;
 	struct caam_job_ring __iomem *ctrl;
 	struct caam_drv_private_jr *jrpriv;
 	static int total_jobrs;
-	struct resource *r;
+	struct resource r;
 	int error;
 
-	jrdev = &pdev->dev;
 	jrpriv = devm_kmalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
-	dev_set_drvdata(jrdev, jrpriv);
-
 	/* save ring identity relative to detection */
 	jrpriv->ridx = total_jobrs++;
+	jrpriv->dev = jrdev;
 
-	nprop = pdev->dev.of_node;
-	/* Get configuration properties from device tree */
-	/* First, get register page */
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(jrdev, "platform_get_resource() failed\n");
-		return -ENOMEM;
+	error = of_address_to_resource(nprop, 0, &r);
+	if (error) {
+		dev_err(jrdev, "of_address_to_resource() failed\n");
+		return error;
 	}
 
-	ctrl = devm_ioremap(jrdev, r->start, resource_size(r));
+	ctrl = devm_ioremap(jrdev, r.start, resource_size(&r));
 	if (!ctrl) {
 		dev_err(jrdev, "devm_ioremap() failed\n");
 		return -ENOMEM;
@@ -528,13 +493,6 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
 
-	error = dma_set_mask_and_coherent(jrdev, caam_get_dma_mask(jrdev));
-	if (error) {
-		dev_err(jrdev, "dma_set_mask_and_coherent failed (%d)\n",
-			error);
-		return error;
-	}
-
 	/* Identify the interrupt */
 	jrpriv->irq = irq_of_parse_and_map(nprop, 0);
 	if (!jrpriv->irq) {
@@ -548,55 +506,21 @@ static int caam_jr_probe(struct platform_device *pdev)
 		return error;
 
 	/* Now do the platform independent part */
-	error = caam_jr_init(jrdev); /* now turn on hardware */
+	error = caam_jr_init(jrpriv); /* now turn on hardware */
 	if (error)
 		return error;
 
-	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);
 	list_add_tail(&jrpriv->list_node, &driver_data.jr_list);
 	spin_unlock(&driver_data.jr_alloc_lock);
 
 	atomic_set(&jrpriv->tfm_count, 0);
 
-	register_algs(jrdev->parent);
-
-	return 0;
-}
-
-static const struct of_device_id caam_jr_match[] = {
-	{
-		.compatible = "fsl,sec-v4.0-job-ring",
-	},
-	{
-		.compatible = "fsl,sec4.0-job-ring",
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, caam_jr_match);
-
-static struct platform_driver caam_jr_driver = {
-	.driver = {
-		.name = "caam_jr",
-		.of_match_table = caam_jr_match,
-	},
-	.probe       = caam_jr_probe,
-	.remove      = caam_jr_remove,
-};
+	error = devm_add_action_or_reset(jrdev, caam_jr_remove, jrpriv);
+	if (error)
+		return error;
 
-static int __init jr_driver_init(void)
-{
-	return platform_driver_register(&caam_jr_driver);
-}
+	register_algs(jrdev);
 
-static void __exit jr_driver_exit(void)
-{
-	platform_driver_unregister(&caam_jr_driver);
+	return 0;
 }
-
-module_init(jr_driver_init);
-module_exit(jr_driver_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("FSL CAAM JR request backend");
-MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index f49caa0ac0ff..ee2aa1798605 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -18,5 +18,6 @@ struct caam_drv_private_jr *caam_jr_alloc(void);
 void caam_jr_free(struct caam_drv_private_jr *jr);
 int caam_jr_enqueue(struct caam_drv_private_jr *jr, u32 *desc, caam_jr_cbk cbk,
 		    void *areq);
+int caam_jr_probe(struct device *jrdev, struct device_node *nprop);
 
 #endif /* JR_H */
-- 
2.21.0

