From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] staging: ccree: don't break lines unnecessarily
Date: Thu, 11 Jan 2018 13:10:11 +0300
Message-ID: <20180111101010.lgvxpvcemde3xzr7@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These lines are less than 80 characters so we don't need to break them
up into chunks.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/ccree/cc_aead.c b/drivers/staging/ccree/cc_aead.c
index 265adffdab41..b58413172231 100644
--- a/drivers/staging/ccree/cc_aead.c
+++ b/drivers/staging/ccree/cc_aead.c
@@ -2600,8 +2600,7 @@ static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
 
 	alg = &tmpl->template_aead;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 tmpl->name);
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 tmpl->driver_name);
 	alg->base.cra_module = THIS_MODULE;
diff --git a/drivers/staging/ccree/cc_cipher.c b/drivers/staging/ccree/cc_cipher.c
index 8afdbc120b13..5c7e91f1cde7 100644
--- a/drivers/staging/ccree/cc_cipher.c
+++ b/drivers/staging/ccree/cc_cipher.c
@@ -127,8 +127,7 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 {
 	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     crypto_alg);
+		container_of(tfm->__crt_alg, struct cc_crypto_alg, crypto_alg);
 
 	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
 	    CRYPTO_ALG_TYPE_ABLKCIPHER)
@@ -391,8 +390,7 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 	unsigned int du_size = nbytes;
 
 	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     crypto_alg);
+		container_of(tfm->__crt_alg, struct cc_crypto_alg, crypto_alg);
 
 	if ((cc_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
 	    CRYPTO_ALG_BULK_DU_512)
@@ -611,8 +609,7 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 		kfree(req_ctx->backup_info);
 	} else if (!err) {
 		scatterwalk_map_and_copy(req->info, req->dst,
-					 (req->nbytes - ivsize),
-					 ivsize, 0);
+					 (req->nbytes - ivsize), ivsize, 0);
 	}
 
 	ablkcipher_request_complete(areq, err);
@@ -1096,8 +1093,7 @@ struct cc_crypto_alg *cc_cipher_create_alg(struct cc_alg_template *template,
 int cc_cipher_free(struct cc_drvdata *drvdata)
 {
 	struct cc_crypto_alg *t_alg, *n;
-	struct cc_cipher_handle *blkcipher_handle =
-						drvdata->blkcipher_handle;
+	struct cc_cipher_handle *blkcipher_handle = drvdata->blkcipher_handle;
 	if (blkcipher_handle) {
 		/* Remove registered algs */
 		list_for_each_entry_safe(t_alg, n,
diff --git a/drivers/staging/ccree/cc_driver.c b/drivers/staging/ccree/cc_driver.c
index 6682d9d93931..192b1759de45 100644
--- a/drivers/staging/ccree/cc_driver.c
+++ b/drivers/staging/ccree/cc_driver.c
@@ -216,8 +216,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	if (rc) {
-		dev_err(dev, "Failed in dma_set_mask, mask=%par\n",
-			&dma_mask);
+		dev_err(dev, "Failed in dma_set_mask, mask=%par\n", &dma_mask);
 		return rc;
 	}
 
diff --git a/drivers/staging/ccree/cc_fips.c b/drivers/staging/ccree/cc_fips.c
index b25c34e08717..de08af976b7f 100644
--- a/drivers/staging/ccree/cc_fips.c
+++ b/drivers/staging/ccree/cc_fips.c
@@ -53,8 +53,7 @@ void cc_fips_fini(struct cc_drvdata *drvdata)
 
 void fips_handler(struct cc_drvdata *drvdata)
 {
-	struct cc_fips_handle *fips_handle_ptr =
-		drvdata->fips_handle;
+	struct cc_fips_handle *fips_handle_ptr = drvdata->fips_handle;
 
 	tasklet_schedule(&fips_handle_ptr->tasklet);
 }
diff --git a/drivers/staging/ccree/cc_hash.c b/drivers/staging/ccree/cc_hash.c
index 86f9ec711edc..8afc39f10bb3 100644
--- a/drivers/staging/ccree/cc_hash.c
+++ b/drivers/staging/ccree/cc_hash.c
@@ -1858,9 +1858,8 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	hash_handle->larval_digest_sram_addr = sram_buff_ofs;
 
 	/* Copy-to-sram initial SHA* digests */
-	cc_set_sram_desc(md5_init, sram_buff_ofs,
-			 ARRAY_SIZE(md5_init), larval_seq,
-			 &larval_seq_len);
+	cc_set_sram_desc(md5_init, sram_buff_ofs, ARRAY_SIZE(md5_init),
+			 larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (rc)
 		goto init_digest_const_err;
@@ -2004,8 +2003,7 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 			kfree(t_alg);
 			goto fail;
 		} else {
-			list_add_tail(&t_alg->entry,
-				      &hash_handle->hash_list);
+			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
 		}
 
 		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
diff --git a/drivers/staging/ccree/cc_pm.c b/drivers/staging/ccree/cc_pm.c
index c7d6b863d3af..d990f472e89f 100644
--- a/drivers/staging/ccree/cc_pm.c
+++ b/drivers/staging/ccree/cc_pm.c
@@ -28,8 +28,7 @@ int cc_pm_suspend(struct device *dev)
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	rc = cc_suspend_req_queue(drvdata);
 	if (rc) {
-		dev_err(dev, "cc_suspend_req_queue (%x)\n",
-			rc);
+		dev_err(dev, "cc_suspend_req_queue (%x)\n", rc);
 		return rc;
 	}
 	fini_cc_regs(drvdata);
diff --git a/drivers/staging/ccree/cc_request_mgr.c b/drivers/staging/ccree/cc_request_mgr.c
index 8372410b4f14..8a7f83407410 100644
--- a/drivers/staging/ccree/cc_request_mgr.c
+++ b/drivers/staging/ccree/cc_request_mgr.c
@@ -275,8 +275,7 @@ static int cc_do_send_request(struct cc_drvdata *drvdata,
 		/* Acquire IV from pool */
 		rc = cc_get_iv(drvdata, cc_req->ivgen_dma_addr,
 			       cc_req->ivgen_dma_addr_len,
-			       cc_req->ivgen_size,
-			       iv_seq, &iv_seq_len);
+			       cc_req->ivgen_size, iv_seq, &iv_seq_len);
 
 		if (rc) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
