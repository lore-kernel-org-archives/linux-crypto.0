Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6872FC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 17:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38A6820850
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 17:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbfCARTt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:19:49 -0500
Received: from inva020.nxp.com ([92.121.34.13]:45504 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfCARTt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 12:19:49 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5A1781A00CD;
        Fri,  1 Mar 2019 18:19:47 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C2C71A0085;
        Fri,  1 Mar 2019 18:19:47 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 021DC204B1;
        Fri,  1 Mar 2019 18:19:46 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: [PATCH RESEND v3] crypto: caam - add missing put_device() call
Date:   Fri,  1 Mar 2019 19:19:25 +0200
Message-Id: <20190301171925.22650-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wen Yang <yellowriver2010@hotmail.com>

The of_find_device_by_node() takes a reference to the underlying device
structure, we should release that reference.

Fixes: 35af64038623 ("crypto: caam - Check for CAAM block presence before registering with crypto layer")
Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>
---

Looks like previous versions, for some unknown reason, did not reach
the mailing lists.

Resending v3 with the addition of a 2nd Fixes and Reviewed-by tags,
cf. https://lkml.org/lkml/2019/2/11/383

 drivers/crypto/caam/caamalg.c    | 12 +++++++-----
 drivers/crypto/caam/caamalg_qi.c | 11 ++++++++---
 drivers/crypto/caam/caamhash.c   | 18 +++++++++++-------
 drivers/crypto/caam/caampkc.c    | 14 ++++++++++----
 drivers/crypto/caam/caamrng.c    | 22 ++++++++++++++--------
 5 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 9eac5099098e..579578498deb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3455,7 +3455,6 @@ static int __init caam_algapi_init(void)
 {
 	struct device_node *dev_node;
 	struct platform_device *pdev;
-	struct device *ctrldev;
 	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
@@ -3476,16 +3475,17 @@ static int __init caam_algapi_init(void)
 		return -ENODEV;
 	}
 
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
+	priv = dev_get_drvdata(&pdev->dev);
 	of_node_put(dev_node);
 
 	/*
 	 * If priv is NULL, it's probably because the caam driver wasn't
 	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
 	 */
-	if (!priv)
-		return -ENODEV;
+	if (!priv) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 
 	/*
@@ -3626,6 +3626,8 @@ static int __init caam_algapi_init(void)
 	if (registered)
 		pr_info("caam algorithms registered in /proc/crypto\n");
 
+out_put_dev:
+	put_device(&pdev->dev);
 	return err;
 }
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index a15ce9213310..c61921d32489 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2492,12 +2492,15 @@ static int __init caam_qi_algapi_init(void)
 	 * If priv is NULL, it's probably because the caam driver wasn't
 	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
 	 */
-	if (!priv || !priv->qi_present)
-		return -ENODEV;
+	if (!priv || !priv->qi_present) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	if (caam_dpaa2) {
 		dev_info(ctrldev, "caam/qi frontend driver not suitable for DPAA 2.x, aborting...\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto out_put_dev;
 	}
 
 	/*
@@ -2610,6 +2613,8 @@ static int __init caam_qi_algapi_init(void)
 	if (registered)
 		dev_info(priv->qidev, "algorithms registered in /proc/crypto\n");
 
+out_put_dev:
+	put_device(ctrldev);
 	return err;
 }
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d7483e4d0ce2..b1eadc6652b5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1993,7 +1993,6 @@ static int __init caam_algapi_hash_init(void)
 {
 	struct device_node *dev_node;
 	struct platform_device *pdev;
-	struct device *ctrldev;
 	int i = 0, err = 0;
 	struct caam_drv_private *priv;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
@@ -2012,16 +2011,17 @@ static int __init caam_algapi_hash_init(void)
 		return -ENODEV;
 	}
 
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
+	priv = dev_get_drvdata(&pdev->dev);
 	of_node_put(dev_node);
 
 	/*
 	 * If priv is NULL, it's probably because the caam driver wasn't
 	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
 	 */
-	if (!priv)
-		return -ENODEV;
+	if (!priv) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	/*
 	 * Register crypto algorithms the device supports.  First, identify
@@ -2043,8 +2043,10 @@ static int __init caam_algapi_hash_init(void)
 	 * Skip registration of any hashing algorithms if MD block
 	 * is not present.
 	 */
-	if (!md_inst)
-		return -ENODEV;
+	if (!md_inst) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	/* Limit digest size based on LP256 */
 	if (md_vid == CHA_VER_VID_MD_LP256)
@@ -2101,6 +2103,8 @@ static int __init caam_algapi_hash_init(void)
 			list_add_tail(&t_alg->entry, &hash_list);
 	}
 
+out_put_dev:
+	put_device(&pdev->dev);
 	return err;
 }
 
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 77ab28a2811a..58285642306e 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1042,8 +1042,10 @@ static int __init caam_pkc_init(void)
 	 * If priv is NULL, it's probably because the caam driver wasn't
 	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
 	 */
-	if (!priv)
-		return -ENODEV;
+	if (!priv) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	/* Determine public key hardware accelerator presence. */
 	if (priv->era < 10)
@@ -1053,8 +1055,10 @@ static int __init caam_pkc_init(void)
 		pk_inst = rd_reg32(&priv->ctrl->vreg.pkha) & CHA_VER_NUM_MASK;
 
 	/* Do not register algorithms if PKHA is not present. */
-	if (!pk_inst)
-		return -ENODEV;
+	if (!pk_inst) {
+		err =  -ENODEV;
+		goto out_put_dev;
+	}
 
 	err = crypto_register_akcipher(&caam_rsa);
 	if (err)
@@ -1063,6 +1067,8 @@ static int __init caam_pkc_init(void)
 	else
 		dev_info(ctrldev, "caam pkc algorithms registered in /proc/crypto\n");
 
+out_put_dev:
+	put_device(ctrldev);
 	return err;
 }
 
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index a387c8d49a62..95eb5402c59f 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -308,7 +308,6 @@ static int __init caam_rng_init(void)
 	struct device *dev;
 	struct device_node *dev_node;
 	struct platform_device *pdev;
-	struct device *ctrldev;
 	struct caam_drv_private *priv;
 	u32 rng_inst;
 	int err;
@@ -326,16 +325,17 @@ static int __init caam_rng_init(void)
 		return -ENODEV;
 	}
 
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
+	priv = dev_get_drvdata(&pdev->dev);
 	of_node_put(dev_node);
 
 	/*
 	 * If priv is NULL, it's probably because the caam driver wasn't
 	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
 	 */
-	if (!priv)
-		return -ENODEV;
+	if (!priv) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	/* Check for an instantiated RNG before registration */
 	if (priv->era < 10)
@@ -344,13 +344,16 @@ static int __init caam_rng_init(void)
 	else
 		rng_inst = rd_reg32(&priv->ctrl->vreg.rng) & CHA_VER_NUM_MASK;
 
-	if (!rng_inst)
-		return -ENODEV;
+	if (!rng_inst) {
+		err = -ENODEV;
+		goto out_put_dev;
+	}
 
 	dev = caam_jr_alloc();
 	if (IS_ERR(dev)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(dev);
+		err = PTR_ERR(dev);
+		goto out_put_dev;
 	}
 	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
 	if (!rng_ctx) {
@@ -361,6 +364,7 @@ static int __init caam_rng_init(void)
 	if (err)
 		goto free_rng_ctx;
 
+	put_device(&pdev->dev);
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
 
@@ -368,6 +372,8 @@ static int __init caam_rng_init(void)
 	kfree(rng_ctx);
 free_caam_alloc:
 	caam_jr_free(dev);
+out_put_dev:
+	put_device(&pdev->dev);
 	return err;
 }
 
-- 
2.17.1

