Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D7CC43218
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966B12077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfDYQZX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:23 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35736 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfDYQZW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:22 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EDB52003FB;
        Thu, 25 Apr 2019 18:25:17 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C6A32003F9;
        Thu, 25 Apr 2019 18:25:17 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C88142061F;
        Thu, 25 Apr 2019 18:25:16 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 3/7] crypto: caam - convert top level drivers to libraries
Date:   Thu, 25 Apr 2019 19:24:57 +0300
Message-Id: <20190425162501.4565-4-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently we allow top level code, i.e. that which sits between the
low level (HW-specific) drivers and crypto API, to be built as several
drivers: caamalg, caamhash, caam_pkc, caamrng, caamalg_qi.

There is no advantage in this, more it interferes with adding support
for deferred probing (there are no corresponding devices and thus
no bus).

Convert these drivers and call init() / exit() manually at the right
time.
Move algorithms initialization at JR probe / remove time:
-the first probed JR registers the crypto algs
-the last removed JR unregisters the crypto algs

Note: caam_qi_init() is called before JR platform devices creation
(of_populate_bus()), such that QI interface is initialized when
the caam/qi algorithms are registered in the JR driver (by calling
caam_qi_algapi_init().

While here, fix the Kconfig entries under CRYPTO_DEV_FSL_CAAM_JR
to be aligned.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/Kconfig      | 46 ++++++----------
 drivers/crypto/caam/Makefile     | 18 +++----
 drivers/crypto/caam/caamalg.c    | 41 ++------------
 drivers/crypto/caam/caamalg_qi.c | 45 ++--------------
 drivers/crypto/caam/caamhash.c   | 48 ++---------------
 drivers/crypto/caam/caampkc.c    | 50 ++---------------
 drivers/crypto/caam/caamrng.c    | 54 +++----------------
 drivers/crypto/caam/ctrl.c       | 45 +++++++++-------
 drivers/crypto/caam/intern.h     | 93 ++++++++++++++++++++++++++++++--
 drivers/crypto/caam/jr.c         | 43 +++++++++++++++
 10 files changed, 208 insertions(+), 275 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 577c9844b322..3720ddabb507 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -2,6 +2,12 @@
 config CRYPTO_DEV_FSL_CAAM_COMMON
 	tristate
 
+config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
+	tristate
+
+config CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
+	tristate
+
 config CRYPTO_DEV_FSL_CAAM
 	tristate "Freescale CAAM-Multicore platform driver backend"
 	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
@@ -25,7 +31,7 @@ config CRYPTO_DEV_FSL_CAAM_DEBUG
 	  Selecting this will enable printing of various debug
 	  information in the CAAM driver.
 
-config CRYPTO_DEV_FSL_CAAM_JR
+menuconfig CRYPTO_DEV_FSL_CAAM_JR
 	tristate "Freescale CAAM Job Ring driver backend"
 	default y
 	help
@@ -86,8 +92,9 @@ config CRYPTO_DEV_FSL_CAAM_INTC_TIME_THLD
 	  threshold. Range is 1-65535.
 
 config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
-	tristate "Register algorithm implementations with the Crypto API"
+	bool "Register algorithm implementations with the Crypto API"
 	default y
+	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
@@ -97,13 +104,11 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	  scatterlist crypto API (such as the linux native IPSec
 	  stack) to the SEC4 via job ring.
 
-	  To compile this as a module, choose M here: the module
-	  will be called caamalg.
-
 config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
-	tristate "Queue Interface as Crypto API backend"
+	bool "Queue Interface as Crypto API backend"
 	depends on FSL_DPAA && NET
 	default y
+	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	help
@@ -114,33 +119,26 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
 	  assigned to the kernel should also be more than the number of
 	  job rings.
 
-	  To compile this as a module, choose M here: the module
-	  will be called caamalg_qi.
-
 config CRYPTO_DEV_FSL_CAAM_AHASH_API
-	tristate "Register hash algorithm implementations with Crypto API"
+	bool "Register hash algorithm implementations with Crypto API"
 	default y
+	select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
 	select CRYPTO_HASH
 	help
 	  Selecting this will offload ahash for users of the
 	  scatterlist crypto API to the SEC4 via job ring.
 
-	  To compile this as a module, choose M here: the module
-	  will be called caamhash.
-
 config CRYPTO_DEV_FSL_CAAM_PKC_API
-        tristate "Register public key cryptography implementations with Crypto API"
+        bool "Register public key cryptography implementations with Crypto API"
         default y
         select CRYPTO_RSA
         help
           Selecting this will allow SEC Public key support for RSA.
           Supported cryptographic primitives: encryption, decryption,
           signature and verification.
-          To compile this as a module, choose M here: the module
-          will be called caam_pkc.
 
 config CRYPTO_DEV_FSL_CAAM_RNG_API
-	tristate "Register caam device for hwrng API"
+	bool "Register caam device for hwrng API"
 	default y
 	select CRYPTO_RNG
 	select HW_RANDOM
@@ -148,9 +146,6 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 	  Selecting this will register the SEC4 hardware rng to
 	  the hw_random API for suppying the kernel entropy pool.
 
-	  To compile this as a module, choose M here: the module
-	  will be called caamrng.
-
 endif # CRYPTO_DEV_FSL_CAAM_JR
 
 endif # CRYPTO_DEV_FSL_CAAM
@@ -160,6 +155,8 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	depends on FSL_MC_DPIO
 	depends on NETDEVICES
 	select CRYPTO_DEV_FSL_CAAM_COMMON
+	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
+	select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
 	select CRYPTO_AEAD
@@ -171,12 +168,3 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 
 	  To compile this as a module, choose M here: the module
 	  will be called dpaa2_caam.
-
-config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
-	def_tristate (CRYPTO_DEV_FSL_CAAM_CRYPTO_API || \
-		      CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI || \
-		      CRYPTO_DEV_FSL_DPAA2_CAAM)
-
-config CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
-	def_tristate (CRYPTO_DEV_FSL_CAAM_AHASH_API || \
-		      CRYPTO_DEV_FSL_DPAA2_CAAM)
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 7bbfd06a11ff..9ab4e81ea21e 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -11,20 +11,20 @@ ccflags-y += -DVERSION=\"\"
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += error.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC) += caamalg_desc.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC) += caamhash_desc.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caam_pkc.o
 
-caam-objs := ctrl.o
-caam_jr-objs := jr.o key_gen.o
-caam_pkc-y := caampkc.o pkc_desc.o
+caam-y := ctrl.o
+caam_jr-y := jr.o key_gen.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caampkc.o pkc_desc.o
+
+caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += qi.o
 ifneq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI),)
 	ccflags-y += -DCONFIG_CAAM_QI
-	caam-objs += qi.o
 endif
 
 obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) += dpaa2_caam.o
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ecb33644a085..05d22dae0ae1 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3466,7 +3466,7 @@ static void caam_aead_exit(struct crypto_aead *tfm)
 	caam_exit_common(crypto_aead_ctx(tfm));
 }
 
-static void __exit caam_algapi_exit(void)
+void caam_algapi_exit(void)
 {
 	int i;
 
@@ -3511,43 +3511,17 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->exit = caam_aead_exit;
 }
 
-static int __init caam_algapi_init(void)
+int caam_algapi_init(struct device *ctrldev)
 {
 	struct device_node *dev_node;
 	struct platform_device *pdev;
-	struct caam_drv_private *priv;
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
 	u32 arc4_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false, gcm_support;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev) {
-		of_node_put(dev_node);
-		return -ENODEV;
-	}
-
-	priv = dev_get_drvdata(&pdev->dev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
-
-
 	/*
 	 * Register crypto algorithms the device supports.
 	 * First, detect presence and attributes of DES, AES, and MD blocks.
@@ -3690,14 +3664,5 @@ static int __init caam_algapi_init(void)
 	if (registered)
 		pr_info("caam algorithms registered in /proc/crypto\n");
 
-out_put_dev:
-	put_device(&pdev->dev);
 	return err;
 }
-
-module_init(caam_algapi_init);
-module_exit(caam_algapi_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("FSL CAAM support for crypto API");
-MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index a1ed6a721834..b2e29be79d41 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2489,7 +2489,7 @@ static void caam_aead_exit(struct crypto_aead *tfm)
 	caam_exit_common(crypto_aead_ctx(tfm));
 }
 
-static void __exit caam_qi_algapi_exit(void)
+void caam_qi_algapi_exit(void)
 {
 	int i;
 
@@ -2534,45 +2534,17 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->exit = caam_aead_exit;
 }
 
-static int __init caam_qi_algapi_init(void)
+int caam_qi_algapi_init(struct device *ctrldev)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	of_node_put(dev_node);
-	if (!pdev)
-		return -ENODEV;
-
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv || !priv->qi_present) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
-
 	if (caam_dpaa2) {
 		dev_info(ctrldev, "caam/qi frontend driver not suitable for DPAA 2.x, aborting...\n");
-		err = -ENODEV;
-		goto out_put_dev;
+		return -ENODEV;
 	}
 
 	/*
@@ -2685,14 +2657,5 @@ static int __init caam_qi_algapi_init(void)
 	if (registered)
 		dev_info(priv->qidev, "algorithms registered in /proc/crypto\n");
 
-out_put_dev:
-	put_device(ctrldev);
 	return err;
 }
-
-module_init(caam_qi_algapi_init);
-module_exit(caam_qi_algapi_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Support for crypto API using CAAM-QI backend");
-MODULE_AUTHOR("Freescale Semiconductor");
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 200e533794c8..cf67d92793e2 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1934,7 +1934,7 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	caam_jr_free(ctx->jrdev);
 }
 
-static void __exit caam_algapi_hash_exit(void)
+void caam_algapi_hash_exit(void)
 {
 	struct caam_hash_alg *t_alg, *n;
 
@@ -1992,40 +1992,13 @@ caam_hash_alloc(struct caam_hash_template *template,
 	return t_alg;
 }
 
-static int __init caam_algapi_hash_init(void)
+int caam_algapi_hash_init(struct device *ctrldev)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
 	int i = 0, err = 0;
-	struct caam_drv_private *priv;
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	u32 md_inst, md_vid;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev) {
-		of_node_put(dev_node);
-		return -ENODEV;
-	}
-
-	priv = dev_get_drvdata(&pdev->dev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
-
 	/*
 	 * Register crypto algorithms the device supports.  First, identify
 	 * presence and attributes of MD block.
@@ -2046,10 +2019,8 @@ static int __init caam_algapi_hash_init(void)
 	 * Skip registration of any hashing algorithms if MD block
 	 * is not present.
 	 */
-	if (!md_inst) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
+	if (!md_inst)
+		return -ENODEV;
 
 	/* Limit digest size based on LP256 */
 	if (md_vid == CHA_VER_VID_MD_LP256)
@@ -2106,14 +2077,5 @@ static int __init caam_algapi_hash_init(void)
 			list_add_tail(&t_alg->entry, &hash_list);
 	}
 
-out_put_dev:
-	put_device(&pdev->dev);
 	return err;
 }
-
-module_init(caam_algapi_hash_init);
-module_exit(caam_algapi_hash_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("FSL CAAM support for ahash functions of crypto API");
-MODULE_AUTHOR("Freescale Semiconductor - NMG");
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index d97ffb03afc0..34e37f9bd828 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1013,41 +1013,12 @@ static struct akcipher_alg caam_rsa = {
 };
 
 /* Public Key Cryptography module initialization handler */
-static int __init caam_pkc_init(void)
+int caam_pkc_init(struct device *ctrldev)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	u32 pk_inst;
 	int err;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev) {
-		of_node_put(dev_node);
-		return -ENODEV;
-	}
-
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
-
 	/* Determine public key hardware accelerator presence. */
 	if (priv->era < 10)
 		pk_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
@@ -1056,10 +1027,8 @@ static int __init caam_pkc_init(void)
 		pk_inst = rd_reg32(&priv->ctrl->vreg.pkha) & CHA_VER_NUM_MASK;
 
 	/* Do not register algorithms if PKHA is not present. */
-	if (!pk_inst) {
-		err =  -ENODEV;
-		goto out_put_dev;
-	}
+	if (!pk_inst)
+		return 0;
 
 	err = crypto_register_akcipher(&caam_rsa);
 	if (err)
@@ -1068,19 +1037,10 @@ static int __init caam_pkc_init(void)
 	else
 		dev_info(ctrldev, "caam pkc algorithms registered in /proc/crypto\n");
 
-out_put_dev:
-	put_device(ctrldev);
 	return err;
 }
 
-static void __exit caam_pkc_exit(void)
+void caam_pkc_exit(void)
 {
 	crypto_unregister_akcipher(&caam_rsa);
 }
-
-module_init(caam_pkc_init);
-module_exit(caam_pkc_exit);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("FSL CAAM support for PKC functions of crypto API");
-MODULE_AUTHOR("Freescale Semiconductor");
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 95eb5402c59f..1ece4ed571a2 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for hw_random
  *
  * Copyright 2011 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018-2019 NXP
  *
  * Based on caamalg.c crypto API driver.
  *
@@ -296,47 +296,20 @@ static struct hwrng caam_rng = {
 	.read		= caam_read,
 };
 
-static void __exit caam_rng_exit(void)
+void caam_rng_exit(void)
 {
 	caam_jr_free(rng_ctx->jrdev);
 	hwrng_unregister(&caam_rng);
 	kfree(rng_ctx);
 }
 
-static int __init caam_rng_init(void)
+int caam_rng_init(struct device *ctrldev)
 {
 	struct device *dev;
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct caam_drv_private *priv;
 	u32 rng_inst;
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev) {
-		of_node_put(dev_node);
-		return -ENODEV;
-	}
-
-	priv = dev_get_drvdata(&pdev->dev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
-
 	/* Check for an instantiated RNG before registration */
 	if (priv->era < 10)
 		rng_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
@@ -344,16 +317,13 @@ static int __init caam_rng_init(void)
 	else
 		rng_inst = rd_reg32(&priv->ctrl->vreg.rng) & CHA_VER_NUM_MASK;
 
-	if (!rng_inst) {
-		err = -ENODEV;
-		goto out_put_dev;
-	}
+	if (!rng_inst)
+		return 0;
 
 	dev = caam_jr_alloc();
 	if (IS_ERR(dev)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		err = PTR_ERR(dev);
-		goto out_put_dev;
+		return PTR_ERR(dev);
 	}
 	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
 	if (!rng_ctx) {
@@ -364,7 +334,6 @@ static int __init caam_rng_init(void)
 	if (err)
 		goto free_rng_ctx;
 
-	put_device(&pdev->dev);
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
 
@@ -372,14 +341,5 @@ static int __init caam_rng_init(void)
 	kfree(rng_ctx);
 free_caam_alloc:
 	caam_jr_free(dev);
-out_put_dev:
-	put_device(&pdev->dev);
 	return err;
 }
-
-module_init(caam_rng_init);
-module_exit(caam_rng_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("FSL CAAM support for hw_random API");
-MODULE_AUTHOR("Freescale Semiconductor - NMG");
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e2ba3d202da5..36c2f15100a4 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -3,7 +3,7 @@
  * Controller-level driver, kernel property detection, initialization
  *
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018-2019 NXP
  */
 
 #include <linux/device.h>
@@ -703,12 +703,6 @@ static int caam_probe(struct platform_device *pdev)
 
 	ctrlpriv->era = caam_get_era(ctrl);
 
-	ret = of_platform_populate(nprop, caam_match, NULL, dev);
-	if (ret) {
-		dev_err(dev, "JR platform devices creation error\n");
-		goto iounmap_ctrl;
-	}
-
 #ifdef CONFIG_DEBUG_FS
 	/*
 	 * FIXME: needs better naming distinction, as some amalgamation of
@@ -721,19 +715,6 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
 #endif
 
-	ring = 0;
-	for_each_available_child_of_node(nprop, np)
-		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
-		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
-			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
-					     ((__force uint8_t *)ctrl +
-					     (ring + JR_BLOCK_NUMBER) *
-					      BLOCK_OFFSET
-					     );
-			ctrlpriv->total_jobrs++;
-			ring++;
-		}
-
 	/* Check to see if (DPAA 1.x) QI present. If so, enable */
 	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
 	if (ctrlpriv->qi_present && !caam_dpaa2) {
@@ -752,6 +733,25 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 	}
 
+	ret = of_platform_populate(nprop, caam_match, NULL, dev);
+	if (ret) {
+		dev_err(dev, "JR platform devices creation error\n");
+		goto shutdown_qi;
+	}
+
+	ring = 0;
+	for_each_available_child_of_node(nprop, np)
+		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
+		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
+			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
+					     ((__force uint8_t *)ctrl +
+					     (ring + JR_BLOCK_NUMBER) *
+					      BLOCK_OFFSET
+					     );
+			ctrlpriv->total_jobrs++;
+			ring++;
+		}
+
 	/* If no QI and no rings specified, quit and go home */
 	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
 		dev_err(dev, "no queues configured, terminating\n");
@@ -898,6 +898,11 @@ static int caam_probe(struct platform_device *pdev)
 	caam_remove(pdev);
 	return ret;
 
+shutdown_qi:
+#ifdef CONFIG_CAAM_QI
+	if (ctrlpriv->qidev)
+		caam_qi_shutdown(ctrlpriv->qidev);
+#endif
 iounmap_ctrl:
 	iounmap(ctrl);
 disable_caam_emi_slow:
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 3392615dc91b..50e24ebc533b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -4,7 +4,7 @@
  * Private/internal definitions between modules
  *
  * Copyright 2008-2011 Freescale Semiconductor, Inc.
- *
+ * Copyright 2019 NXP
  */
 
 #ifndef INTERN_H
@@ -107,8 +107,95 @@ struct caam_drv_private {
 #endif
 };
 
-void caam_jr_algapi_init(struct device *dev);
-void caam_jr_algapi_remove(struct device *dev);
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API
+
+int caam_algapi_init(struct device *dev);
+void caam_algapi_exit(void);
+
+#else
+
+static inline int caam_algapi_init(struct device *dev)
+{
+	return 0;
+}
+
+static inline void caam_algapi_exit(void)
+{
+}
+
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API */
+
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API
+
+int caam_algapi_hash_init(struct device *dev);
+void caam_algapi_hash_exit(void);
+
+#else
+
+static inline int caam_algapi_hash_init(struct device *dev)
+{
+	return 0;
+}
+
+static inline void caam_algapi_hash_exit(void)
+{
+}
+
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API */
+
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API
+
+int caam_pkc_init(struct device *dev);
+void caam_pkc_exit(void);
+
+#else
+
+static inline int caam_pkc_init(struct device *dev)
+{
+	return 0;
+}
+
+static inline void caam_pkc_exit(void)
+{
+}
+
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API */
+
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API
+
+int caam_rng_init(struct device *dev);
+void caam_rng_exit(void);
+
+#else
+
+static inline int caam_rng_init(struct device *dev)
+{
+	return 0;
+}
+
+static inline void caam_rng_exit(void)
+{
+}
+
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API */
+
+#ifdef CONFIG_CAAM_QI
+
+int caam_qi_algapi_init(struct device *dev);
+void caam_qi_algapi_exit(void);
+
+#else
+
+static inline int caam_qi_algapi_init(struct device *dev)
+{
+	return 0;
+}
+
+static inline void caam_qi_algapi_exit(void)
+{
+}
+
+#endif /* CONFIG_CAAM_QI */
 
 #ifdef CONFIG_DEBUG_FS
 static int caam_debugfs_u64_get(void *data, u64 *val)
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 044a69b526f7..64f3bc458fdd 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -4,6 +4,7 @@
  * JobR backend functionality
  *
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
+ * Copyright 2019 NXP
  */
 
 #include <linux/of_irq.h>
@@ -23,6 +24,43 @@ struct jr_driver_data {
 } ____cacheline_aligned;
 
 static struct jr_driver_data driver_data;
+static DEFINE_MUTEX(algs_lock);
+static unsigned int active_devs;
+
+static void register_algs(struct device *dev)
+{
+	mutex_lock(&algs_lock);
+
+	if (++active_devs != 1)
+		goto algs_unlock;
+
+	caam_algapi_init(dev);
+	caam_algapi_hash_init(dev);
+	caam_pkc_init(dev);
+	caam_rng_init(dev);
+	caam_qi_algapi_init(dev);
+
+algs_unlock:
+	mutex_unlock(&algs_lock);
+}
+
+static void unregister_algs(void)
+{
+	mutex_lock(&algs_lock);
+
+	if (--active_devs != 0)
+		goto algs_unlock;
+
+	caam_qi_algapi_exit();
+
+	caam_rng_exit();
+	caam_pkc_exit();
+	caam_algapi_hash_exit();
+	caam_algapi_exit();
+
+algs_unlock:
+	mutex_unlock(&algs_lock);
+}
 
 static int caam_reset_hw_jr(struct device *dev)
 {
@@ -109,6 +147,9 @@ static int caam_jr_remove(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
+	/* Unregister JR-based RNG & crypto algorithms */
+	unregister_algs();
+
 	/* Remove the node from Physical JobR list maintained by driver */
 	spin_lock(&driver_data.jr_alloc_lock);
 	list_del(&jrpriv->list_node);
@@ -541,6 +582,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	atomic_set(&jrpriv->tfm_count, 0);
 
+	register_algs(jrdev->parent);
+
 	return 0;
 }
 
-- 
2.17.1

