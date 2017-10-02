From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 4/4] staging: ccree: simplify OOM handling
Date: Mon,  2 Oct 2017 10:03:25 +0100
Message-ID: <1506935008-14240-5-git-send-email-gilad@benyossef.com>
References: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Simplify handling of memory allocation failures and remove
redundant log messages

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c   | 11 ++++------
 drivers/staging/ccree/ssi_driver.c   |  1 -
 drivers/staging/ccree/ssi_hash.c     | 42 +++++++++++++-----------------------
 drivers/staging/ccree/ssi_ivgen.c    |  9 +++-----
 drivers/staging/ccree/ssi_sram_mgr.c | 20 ++++++-----------
 5 files changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index cceaee8..3a74856 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -194,10 +194,9 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
-	if (!ctx_p->user.key) {
-		dev_dbg(dev, "Allocating key buffer in context failed\n");
-		rc = -ENOMEM;
-	}
+	if (!ctx_p->user.key)
+		return -ENOMEM;
+
 	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
 		ctx_p->user.key);
 
@@ -1245,10 +1244,8 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template
 	struct crypto_alg *alg;
 
 	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg) {
-		dev_dbg(dev, "failed to allocate t_alg\n");
+	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	alg = &t_alg->crypto_alg;
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 43f2301..aada60e 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -212,7 +212,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
 	if (!new_drvdata) {
-		dev_dbg(dev, "Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto post_drvdata_err;
 	}
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index cb4980a..8984a5b 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -157,34 +157,28 @@ static int ssi_hash_map_request(struct device *dev,
 	int rc = -ENOMEM;
 
 	state->buff0 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
-	if (!state->buff0) {
-		dev_err(dev, "Allocating buff0 in context failed\n");
+	if (!state->buff0)
 		goto fail0;
-	}
+
 	state->buff1 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
-	if (!state->buff1) {
-		dev_err(dev, "Allocating buff1 in context failed\n");
+	if (!state->buff1)
 		goto fail_buff0;
-	}
+
 	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE, GFP_KERNEL | GFP_DMA);
-	if (!state->digest_result_buff) {
-		dev_err(dev, "Allocating digest_result_buff in context failed\n");
+	if (!state->digest_result_buff)
 		goto fail_buff1;
-	}
+
 	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
-	if (!state->digest_buff) {
-		dev_err(dev, "Allocating digest-buffer in context failed\n");
+	if (!state->digest_buff)
 		goto fail_digest_result_buff;
-	}
 
 	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
 		state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
 		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL | GFP_DMA);
-		if (!state->digest_bytes_len) {
-			dev_err(dev, "Allocating digest-bytes-len in context failed\n");
+		if (!state->digest_bytes_len)
 			goto fail1;
-		}
+
 		dev_dbg(dev, "Allocated digest-bytes-len in context state->>digest_bytes_len=@%p\n",
 			state->digest_bytes_len);
 	} else {
@@ -192,10 +186,9 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
-	if (!state->opad_digest_buff) {
-		dev_err(dev, "Allocating opad-digest-buffer in context failed\n");
+	if (!state->opad_digest_buff)
 		goto fail2;
-	}
+
 	dev_dbg(dev, "Allocated opad-digest-buffer in context state->digest_bytes_len=@%p\n",
 		state->opad_digest_buff);
 
@@ -2057,10 +2050,9 @@ ssi_hash_create_alg(struct ssi_hash_template *template, struct device *dev,
 	struct ahash_alg *halg;
 
 	t_crypto_alg = kzalloc(sizeof(*t_crypto_alg), GFP_KERNEL);
-	if (!t_crypto_alg) {
-		dev_dbg(dev, "failed to allocate t_crypto_alg\n");
+	if (!t_crypto_alg)
 		return ERR_PTR(-ENOMEM);
-	}
+
 
 	t_crypto_alg->ahash_alg = template->template_ahash;
 	halg = &t_crypto_alg->ahash_alg;
@@ -2225,12 +2217,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	int alg;
 
 	hash_handle = kzalloc(sizeof(*hash_handle), GFP_KERNEL);
-	if (!hash_handle) {
-		dev_err(dev, "kzalloc failed to allocate %zu B\n",
-			sizeof(*hash_handle));
-		rc = -ENOMEM;
-		goto fail;
-	}
+	if (!hash_handle)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&hash_handle->hash_list);
 	drvdata->hash_handle = hash_handle;
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 245d6ad..7c2e99d 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -193,12 +193,9 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	/* Allocate "this" context */
 	drvdata->ivgen_handle = kzalloc(sizeof(*drvdata->ivgen_handle),
 					GFP_KERNEL);
-	if (!drvdata->ivgen_handle) {
-		dev_err(device, "Not enough memory to allocate IVGEN context (%zu B)\n",
-			sizeof(*drvdata->ivgen_handle));
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!drvdata->ivgen_handle)
+		return -ENOMEM;
+
 	ivgen_ctx = drvdata->ivgen_handle;
 
 	/* Allocate pool's header for intial enc. key/IV */
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index df51a2a..4b99704 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -51,28 +51,20 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
 int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
 {
 	struct ssi_sram_mgr_ctx *smgr_ctx;
-	struct device *dev = DEV(drvdata);
-	int rc;
 
 	/* Allocate "this" context */
-	drvdata->sram_mgr_handle = kzalloc(
-			sizeof(struct ssi_sram_mgr_ctx), GFP_KERNEL);
-	if (!drvdata->sram_mgr_handle) {
-		dev_err(dev, "Not enough memory to allocate SRAM_MGR ctx (%zu)\n",
-			sizeof(struct ssi_sram_mgr_ctx));
-		rc = -ENOMEM;
-		goto out;
-	}
+	drvdata->sram_mgr_handle = kzalloc(sizeof(struct ssi_sram_mgr_ctx),
+					   GFP_KERNEL);
+
+	if (!drvdata->sram_mgr_handle)
+		return -ENOMEM;
+
 	smgr_ctx = drvdata->sram_mgr_handle;
 
 	/* Pool starts at start of SRAM */
 	smgr_ctx->sram_free_offset = 0;
 
 	return 0;
-
-out:
-	ssi_sram_mgr_fini(drvdata);
-	return rc;
 }
 
 /*!
-- 
2.7.4
