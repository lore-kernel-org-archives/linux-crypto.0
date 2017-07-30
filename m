From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 6/6] staging: ccree: simplify resource release on error
Date: Sun, 30 Jul 2017 19:15:08 +0300
Message-ID: <1501431309-27705-7-git-send-email-gilad@benyossef.com>
References: <1501431309-27705-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501431309-27705-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The resource release on probe/init error was being handled
in an awkward manner and possibly leaking memory on certain
(unlikely) error path.

Fix it by simplifying the error resource release and making
it easier to track.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c   |   3 +-
 drivers/staging/ccree/ssi_cipher.c |   3 +-
 drivers/staging/ccree/ssi_driver.c | 102 ++++++++++++++++++++-----------------
 drivers/staging/ccree/ssi_hash.c   |   3 +-
 4 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index a8cb432..66eedbe 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2719,6 +2719,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 		goto fail0;
 	}
 
+	INIT_LIST_HEAD(&aead_handle->aead_list);
 	drvdata->aead_handle = aead_handle;
 
 	aead_handle->sram_workspace_addr = ssi_sram_mgr_alloc(
@@ -2729,8 +2730,6 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 		goto fail1;
 	}
 
-	INIT_LIST_HEAD(&aead_handle->aead_list);
-
 	/* Linux crypto */
 	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
 		t_alg = ssi_aead_create_alg(&aead_algs[alg]);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index d98178d..712b21d 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -1281,9 +1281,8 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 	if (!ablkcipher_handle)
 		return -ENOMEM;
 
-	drvdata->blkcipher_handle = ablkcipher_handle;
-
 	INIT_LIST_HEAD(&ablkcipher_handle->blkcipher_alg_list);
+	drvdata->blkcipher_handle = ablkcipher_handle;
 
 	/* Linux crypto */
 	SSI_LOG_DEBUG("Number of algorithms = %zu\n", ARRAY_SIZE(blkcipher_algs));
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index c18e7e3..1b95f90 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -233,16 +233,14 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (!new_drvdata) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
-		goto init_cc_res_err;
+		goto post_drvdata_err;
 	}
+	dev_set_drvdata(&plat_dev->dev, new_drvdata);
+	new_drvdata->plat_dev = plat_dev;
 
 	new_drvdata->clk = of_clk_get(np, 0);
 	new_drvdata->coherent = of_dma_is_coherent(np);
 
-	/*Initialize inflight counter used in dx_ablkcipher_secure_complete used for count of BYSPASS blocks operations*/
-	new_drvdata->inflight_counter = 0;
-
-	dev_set_drvdata(&plat_dev->dev, new_drvdata);
 	/* Get device resources */
 	/* First CC registers space */
 	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
@@ -250,38 +248,42 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
 						     req_mem_cc_regs);
 	if (IS_ERR(new_drvdata->cc_base)) {
+		SSI_LOG_ERR("Failed to ioremap registers");
 		rc = PTR_ERR(new_drvdata->cc_base);
-		goto init_cc_res_err;
+		goto post_drvdata_err;
 	}
+
 	SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
 		      req_mem_cc_regs->name,
 		      req_mem_cc_regs->start,
 		      req_mem_cc_regs->end);
 	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n",
 		      &req_mem_cc_regs->start, new_drvdata->cc_base);
+
 	cc_base = new_drvdata->cc_base;
+
 	/* Then IRQ */
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
 	if (new_drvdata->irq < 0) {
 		SSI_LOG_ERR("Failed getting IRQ resource\n");
 		rc = new_drvdata->irq;
-		goto init_cc_res_err;
+		goto post_drvdata_err;
 	}
+
 	rc = devm_request_irq(&plat_dev->dev, new_drvdata->irq, cc_isr,
 			      IRQF_SHARED, "arm_cc7x", new_drvdata);
 	if (rc) {
 		SSI_LOG_ERR("Could not register to interrupt %d\n",
 			    new_drvdata->irq);
-		goto init_cc_res_err;
+		goto post_drvdata_err;
 	}
-	init_completion(&new_drvdata->icache_setup_completion);
-
 	SSI_LOG_DEBUG("Registered to IRQ: %d\n", new_drvdata->irq);
-	new_drvdata->plat_dev = plat_dev;
+
+	init_completion(&new_drvdata->icache_setup_completion);
 
 	rc = cc_clk_on(new_drvdata);
 	if (rc)
-		goto init_cc_res_err;
+		goto post_drvdata_err;
 
 	if (!new_drvdata->plat_dev->dev.dma_mask)
 		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
@@ -295,7 +297,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		SSI_LOG_ERR("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
 			    signature_val, (u32)DX_DEV_SIGNATURE);
 		rc = -EINVAL;
-		goto init_cc_res_err;
+		goto post_clk_err;
 	}
 	SSI_LOG_DEBUG("CC SIGNATURE=0x%08X\n", signature_val);
 
@@ -306,21 +308,26 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	rc = init_cc_regs(new_drvdata, true);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("init_cc_regs failed\n");
-		goto init_cc_res_err;
+		goto post_clk_err;
 	}
 
 #ifdef ENABLE_CC_SYSFS
 	rc = ssi_sysfs_init(&plat_dev->dev.kobj, new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("init_stat_db failed\n");
-		goto init_cc_res_err;
+		goto post_regs_err;
 	}
 #endif
 
+	rc = ssi_fips_init(new_drvdata);
+	if (unlikely(rc != 0)) {
+		SSI_LOG_ERR("SSI_FIPS_INIT failed 0x%x\n", rc);
+		goto post_sysfs_err;
+	}
 	rc = ssi_sram_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_sram_mgr_init failed\n");
-		goto init_cc_res_err;
+		goto post_fips_init_err;
 	}
 
 	new_drvdata->mlli_sram_addr =
@@ -328,57 +335,51 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
 		SSI_LOG_ERR("Failed to alloc MLLI Sram buffer\n");
 		rc = -ENOMEM;
-		goto init_cc_res_err;
+		goto post_sram_mgr_err;
 	}
 
 	rc = request_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("request_mgr_init failed\n");
-		goto init_cc_res_err;
+		goto post_sram_mgr_err;
 	}
 
 	rc = ssi_buffer_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("buffer_mgr_init failed\n");
-		goto init_cc_res_err;
+		goto post_req_mgr_err;
 	}
 
 	rc = ssi_power_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_power_mgr_init failed\n");
-		goto init_cc_res_err;
-	}
-
-	rc = ssi_fips_init(new_drvdata);
-	if (unlikely(rc != 0)) {
-		SSI_LOG_ERR("SSI_FIPS_INIT failed 0x%x\n", rc);
-		goto init_cc_res_err;
+		goto post_buf_mgr_err;
 	}
 
 	rc = ssi_ivgen_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_ivgen_init failed\n");
-		goto init_cc_res_err;
+		goto post_power_mgr_err;
 	}
 
 	/* Allocate crypto algs */
 	rc = ssi_ablkcipher_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_ablkcipher_alloc failed\n");
-		goto init_cc_res_err;
+		goto post_ivgen_err;
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
 	rc = ssi_hash_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_hash_alloc failed\n");
-		goto init_cc_res_err;
+		goto post_cipher_err;
 	}
 
 	rc = ssi_aead_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("ssi_aead_alloc failed\n");
-		goto init_cc_res_err;
+		goto post_hash_err;
 	}
 
 	/* If we got here and FIPS mode is enabled
@@ -389,24 +390,33 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	return 0;
 
-init_cc_res_err:
-	SSI_LOG_ERR("Freeing CC HW resources!\n");
-
-	if (new_drvdata) {
-		ssi_aead_free(new_drvdata);
-		ssi_hash_free(new_drvdata);
-		ssi_ablkcipher_free(new_drvdata);
-		ssi_ivgen_fini(new_drvdata);
-		ssi_power_mgr_fini(new_drvdata);
-		ssi_buffer_mgr_fini(new_drvdata);
-		request_mgr_fini(new_drvdata);
-		ssi_sram_mgr_fini(new_drvdata);
-		ssi_fips_fini(new_drvdata);
+post_hash_err:
+	ssi_hash_free(new_drvdata);
+post_cipher_err:
+	ssi_ablkcipher_free(new_drvdata);
+post_ivgen_err:
+	ssi_ivgen_fini(new_drvdata);
+post_power_mgr_err:
+	ssi_power_mgr_fini(new_drvdata);
+post_buf_mgr_err:
+	 ssi_buffer_mgr_fini(new_drvdata);
+post_req_mgr_err:
+	request_mgr_fini(new_drvdata);
+post_sram_mgr_err:
+	ssi_sram_mgr_fini(new_drvdata);
+post_fips_init_err:
+	ssi_fips_fini(new_drvdata);
+post_sysfs_err:
 #ifdef ENABLE_CC_SYSFS
-		ssi_sysfs_fini();
+	ssi_sysfs_fini();
 #endif
-		dev_set_drvdata(&plat_dev->dev, NULL);
-	}
+post_regs_err:
+	fini_cc_regs(new_drvdata);
+post_clk_err:
+	cc_clk_off(new_drvdata);
+post_drvdata_err:
+	SSI_LOG_ERR("ccree init error occurred!\n");
+	dev_set_drvdata(&plat_dev->dev, NULL);
 	return rc;
 }
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 6c08b1d..3e7873c 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2229,6 +2229,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		goto fail;
 	}
 
+	INIT_LIST_HEAD(&hash_handle->hash_list);
 	drvdata->hash_handle = hash_handle;
 
 	sram_size_to_alloc = sizeof(digest_len_init) +
@@ -2259,8 +2260,6 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		goto fail;
 	}
 
-	INIT_LIST_HEAD(&hash_handle->hash_list);
-
 	/* ahash registration */
 	for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
 		struct ssi_hash_alg *t_alg;
-- 
2.1.4
