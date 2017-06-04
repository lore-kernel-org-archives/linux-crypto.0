From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 07/18] staging: ccree: remove cycle count debug support
Date: Sun,  4 Jun 2017 11:02:28 +0300
Message-ID: <1496563362-7954-8-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The ccree driver had support for rough performance debugging
via cycle counting which has bit rotted and can easily be
replcaed with perf. Remove it from the driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h |  14 ----
 drivers/staging/ccree/ssi_aead.c         |  33 ---------
 drivers/staging/ccree/ssi_cipher.c       |  20 ------
 drivers/staging/ccree/ssi_config.h       |   6 --
 drivers/staging/ccree/ssi_driver.c       |   8 ---
 drivers/staging/ccree/ssi_driver.h       |  25 -------
 drivers/staging/ccree/ssi_hash.c         |  28 --------
 drivers/staging/ccree/ssi_request_mgr.c  | 116 -------------------------------
 8 files changed, 250 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index c3f9d6a..e750817 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -29,8 +29,6 @@
 #define HW_DESC_SIZE_WORDS		6
 #define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
 
-#define _HW_DESC_MONITOR_KICK 0x7FFFC00
-
 #define CC_REG_NAME(word, name) DX_DSCRPTR_QUEUE_WORD ## word ## _ ## name
 
 #define CC_REG_LOW(word, name)  \
@@ -606,16 +604,4 @@ static inline void set_cipher_do(struct cc_hw_desc *pdesc,
 				(config & HW_KEY_MASK_CIPHER_DO));
 }
 
-/*!
- * This macro sets the DIN field of a HW descriptors to star/stop monitor descriptor.
- * Used for performance measurements and debug purposes.
- *
- * \param pDesc pointer HW descriptor struct
- */
-#define HW_DESC_SET_DIN_MONITOR_CNTR(pDesc)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR, VALUE, (pDesc)->word[1], _HW_DESC_MONITOR_KICK);	\
-	} while (0)
-
-
 #endif /*__CC_HW_QUEUE_DEFS_H__*/
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index a42bb49..e8936a3 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -217,9 +217,6 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	struct crypto_aead *tfm = crypto_aead_reqtfm(ssi_req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int err = 0;
-	DECL_CYCLE_COUNT_RESOURCES;
-
-	START_CYCLE_COUNT();
 
 	ssi_buffer_mgr_unmap_aead_request(dev, areq);
 
@@ -254,7 +251,6 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 		}
 	}
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_4);
 	aead_request_complete(areq, err);
 }
 
@@ -521,10 +517,6 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 		idx++;
 	}
 
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = STAT_OP_TYPE_SETKEY;
-#endif
-
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 	if (unlikely(rc != 0))
 		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
@@ -546,14 +538,12 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	struct crypto_authenc_key_param *param;
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
 	int seq_len = 0, rc = -EINVAL;
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. key=%p keylen=%u\n",
 		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* STAT_PHASE_0: Init and sanity checks */
-	START_CYCLE_COUNT();
 
 	if (ctx->auth_mode != DRV_HASH_NULL) { /* authenc() alg. */
 		if (!RTA_OK(rta, keylen))
@@ -592,9 +582,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	if (unlikely(rc != 0))
 		goto badkey;
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
 	/* STAT_PHASE_1: Copy key to ctx */
-	START_CYCLE_COUNT();
 
 	/* Get key material */
 	memcpy(ctx->enckey, key + ctx->auth_keylen, ctx->enc_keylen);
@@ -608,10 +596,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			goto badkey;
 	}
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
 
 	/* STAT_PHASE_2: Create sequence */
-	START_CYCLE_COUNT();
 
 	switch (ctx->auth_mode) {
 	case DRV_HASH_SHA1:
@@ -629,15 +615,10 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 		goto badkey;
 	}
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_2);
 
 	/* STAT_PHASE_3: Submit sequence to HW */
-	START_CYCLE_COUNT();
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
-#ifdef ENABLE_CYCLE_COUNT
-		ssi_req.op_type = STAT_OP_TYPE_SETKEY;
-#endif
 		rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 0);
 		if (unlikely(rc != 0)) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
@@ -646,7 +627,6 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	}
 
 	/* Update STAT_PHASE_3 */
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_3);
 	return rc;
 
 badkey:
@@ -1977,7 +1957,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	struct ssi_crypto_req ssi_req = {};
 
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
 		((direct==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"), ctx, req, req->iv,
@@ -1985,7 +1964,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	/* STAT_PHASE_0: Init and sanity checks */
-	START_CYCLE_COUNT();
 
 	/* Check data length according to mode */
 	if (unlikely(validate_data_size(ctx, direct, req) != 0)) {
@@ -1999,19 +1977,13 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	ssi_req.user_cb = (void *)ssi_aead_complete;
 	ssi_req.user_arg = (void *)req;
 
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
-		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
-#endif
 	/* Setup request context */
 	areq_ctx->gen_ctx.op_type = direct;
 	areq_ctx->req_authsize = ctx->authsize;
 	areq_ctx->cipher_mode = ctx->cipher_mode;
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_0);
 
 	/* STAT_PHASE_1: Map buffers */
-	START_CYCLE_COUNT();
 
 	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
 		/* Build CTR IV - Copy nonce from last 4 bytes in
@@ -2095,10 +2067,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		ssi_req.ivgen_size = crypto_aead_ivsize(tfm);
 	}
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_1);
 
 	/* STAT_PHASE_2: Create sequence */
-	START_CYCLE_COUNT();
 
 	/* Load MLLI tables to SRAM if necessary */
 	ssi_aead_load_mlli_to_sram(req, desc, &seq_len);
@@ -2133,10 +2103,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		goto exit;
 	}
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_2);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
-	START_CYCLE_COUNT();
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 1);
 
@@ -2146,7 +2114,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	}
 
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
 exit:
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 56e441c..e16fd36 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -323,7 +323,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
 	u32 tmp[DES_EXPKEY_WORDS];
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. keylen=%u\n",
 		ctx_p, crypto_tfm_alg_name(tfm), keylen);
@@ -334,7 +333,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	SSI_LOG_DEBUG("ssi_blkcipher_setkey: after FIPS check");
 
 	/* STAT_PHASE_0: Init and sanity checks */
-	START_CYCLE_COUNT();
 
 #if SSI_CC_HAS_MULTI2
 	/*last byte of key buffer is round number and should not be a part of key size*/
@@ -379,7 +377,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		}
 
 		ctx_p->keylen = keylen;
-		END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
 		SSI_LOG_DEBUG("ssi_blkcipher_setkey: ssi_is_hw_key ret 0");
 
 		return 0;
@@ -407,10 +404,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	}
 
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_0);
 
 	/* STAT_PHASE_1: Copy key to ctx */
-	START_CYCLE_COUNT();
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
 #if SSI_CC_HAS_MULTI2
@@ -448,7 +443,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 					max_key_buf_size, DMA_TO_DEVICE);
 	ctx_p->keylen = keylen;
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
 
 	 SSI_LOG_DEBUG("ssi_blkcipher_setkey: return safely");
 	return 0;
@@ -736,11 +730,8 @@ static int ssi_blkcipher_complete(struct device *dev,
 {
 	int completion_error = 0;
 	u32 inflight_counter;
-	DECL_CYCLE_COUNT_RESOURCES;
 
-	START_CYCLE_COUNT();
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
-	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_4);
 
 
 	/*Set the inflight couter value to local variable*/
@@ -771,7 +762,6 @@ static int ssi_blkcipher_process(
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
 	int rc, seq_len = 0,cts_restore_flag = 0;
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("%s areq=%p info=%p nbytes=%d\n",
 		((direction==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
@@ -779,7 +769,6 @@ static int ssi_blkcipher_process(
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* STAT_PHASE_0: Init and sanity checks */
-	START_CYCLE_COUNT();
 
 	/* TODO: check data length according to mode */
 	if (unlikely(validate_data_size(ctx_p, nbytes))) {
@@ -811,10 +800,8 @@ static int ssi_blkcipher_process(
 	/* Setup request context */
 	req_ctx->gen_ctx.op_type = direction;
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_0);
 
 	/* STAT_PHASE_1: Map buffers */
-	START_CYCLE_COUNT();
 
 	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes, info, src, dst);
 	if (unlikely(rc != 0)) {
@@ -822,10 +809,8 @@ static int ssi_blkcipher_process(
 		goto exit_process;
 	}
 
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_1);
 
 	/* STAT_PHASE_2: Create sequence */
-	START_CYCLE_COUNT();
 
 	/* Setup processing */
 #if SSI_CC_HAS_MULTI2
@@ -860,10 +845,8 @@ static int ssi_blkcipher_process(
 		/* set the IV size (8/16 B long)*/
 		ssi_req.ivgen_size = ivsize;
 	}
-	END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_2);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
-	START_CYCLE_COUNT();
 
 	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL)? 0:1);
 	if(areq != NULL) {
@@ -872,13 +855,10 @@ static int ssi_blkcipher_process(
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 		}
 
-		END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
 	} else {
 		if (rc != 0) {
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
-			END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
 		} else {
-			END_CYCLE_COUNT(ssi_req.op_type, STAT_PHASE_3);
 			rc = ssi_blkcipher_complete(dev, ctx_p, req_ctx, dst,
 						    src, ivsize, NULL,
 						    ctx_p->drvdata->cc_base);
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index 9feb692..b7c0576 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -30,15 +30,9 @@
 // #define DX_DUMP_BYTES
 // #define CC_DEBUG
 #define ENABLE_CC_SYSFS		/* Enable sysfs interface for debugging REE driver */
-//#define ENABLE_CC_CYCLE_COUNT
 //#define DX_IRQ_DELAY 100000
 #define DMA_BIT_MASK_LEN	48	/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 
-#if defined ENABLE_CC_CYCLE_COUNT && defined ENABLE_CC_SYSFS
-#define CC_CYCLE_COUNT
-#endif
-
-
 #if defined (CONFIG_ARM64)	// TODO currently only this mode was test on Juno (which is ARM64), need to enable coherent also.
 #define DISABLE_COHERENT_DMA_OPS
 #endif
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 52c6984..1909229 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -118,10 +118,8 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	void __iomem *cc_base = drvdata->cc_base;
 	u32 irr;
 	u32 imr;
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
-	START_CYCLE_COUNT();
 
 	/* read the interrupt status */
 	irr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
@@ -168,9 +166,6 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		/* Just warning */
 	}
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_0);
-	START_CYCLE_COUNT_AT(drvdata->isr_exit_cycles);
-
 	return IRQ_HANDLED;
 }
 
@@ -509,9 +504,6 @@ static int cc7x_remove(struct platform_device *plat_dev)
 	cleanup_cc_resources(plat_dev);
 
 	SSI_LOG(KERN_INFO, "ARM cc7x_ree device terminated\n");
-#ifdef ENABLE_CYCLE_COUNT
-	display_all_stat_db();
-#endif
 
 	return 0;
 }
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index c0bb1a1..658a7ed 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -117,11 +117,6 @@ struct ssi_crypto_req {
 	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
 	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
 	struct completion seq_compl; /* request completion */
-#ifdef ENABLE_CYCLE_COUNT
-	enum stat_op op_type;
-	cycles_t submit_cycle;
-	bool is_monitored_p;
-#endif
 };
 
 /**
@@ -153,10 +148,6 @@ struct ssi_drvdata {
 	void *fips_handle;
 	void *ivgen_handle;
 	void *sram_mgr_handle;
-
-#ifdef ENABLE_CYCLE_COUNT
-	cycles_t isr_exit_cycles; /* Save for isr-to-tasklet latency */
-#endif
 	u32 inflight_counter;
 
 };
@@ -202,22 +193,6 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
 } while (0);
 #endif
 
-#ifdef ENABLE_CYCLE_COUNT
-#define DECL_CYCLE_COUNT_RESOURCES cycles_t _last_cycles_read
-#define START_CYCLE_COUNT() do { _last_cycles_read = get_cycles(); } while (0)
-#define END_CYCLE_COUNT(_stat_op_type, _stat_phase) update_host_stat(_stat_op_type, _stat_phase, get_cycles() - _last_cycles_read)
-#define GET_START_CYCLE_COUNT() _last_cycles_read
-#define START_CYCLE_COUNT_AT(_var) do { _var = get_cycles(); } while(0)
-#define END_CYCLE_COUNT_AT(_var, _stat_op_type, _stat_phase) update_host_stat(_stat_op_type, _stat_phase, get_cycles() - _var)
-#else
-#define DECL_CYCLE_COUNT_RESOURCES
-#define START_CYCLE_COUNT() do { } while (0)
-#define END_CYCLE_COUNT(_stat_op_type, _stat_phase) do { } while (0)
-#define GET_START_CYCLE_COUNT() 0
-#define START_CYCLE_COUNT_AT(_var) do { } while (0)
-#define END_CYCLE_COUNT_AT(_var, _stat_op_type, _stat_phase) do { } while (0)
-#endif /*ENABLE_CYCLE_COUNT*/
-
 int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct ssi_drvdata *drvdata);
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 66405e9..47bc496 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -460,9 +460,6 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		/* Setup DX request structure */
 		ssi_req.user_cb = (void *)ssi_hash_digest_complete;
 		ssi_req.user_arg = (void *)async_req;
-#ifdef ENABLE_CYCLE_COUNT
-		ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 	}
 
 	/* If HMAC then load hash IPAD xor key, if HASH then load initial digest */
@@ -630,9 +627,6 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		/* Setup DX request structure */
 		ssi_req.user_cb = (void *)ssi_hash_update_complete;
 		ssi_req.user_arg = async_req;
-#ifdef ENABLE_CYCLE_COUNT
-		ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 	}
 
 	/* Restore hash digest */
@@ -725,9 +719,6 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		/* Setup DX request structure */
 		ssi_req.user_cb = (void *)ssi_hash_complete;
 		ssi_req.user_arg = async_req;
-#ifdef ENABLE_CYCLE_COUNT
-		ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 	}
 
 	/* Restore hash digest */
@@ -866,9 +857,6 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		/* Setup DX request structure */
 		ssi_req.user_cb = (void *)ssi_hash_complete;
 		ssi_req.user_arg = async_req;
-#ifdef ENABLE_CYCLE_COUNT
-		ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 	}
 
 	/* Restore hash digest */
@@ -1308,7 +1296,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	DECL_CYCLE_COUNT_RESOURCES;
 	SSI_LOG_DEBUG("===== setkey (%d) ====\n", keylen);
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
@@ -1326,7 +1313,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	ctx->key_params.keylen = keylen;
 
 	/* STAT_PHASE_1: Copy key to ctx */
-	START_CYCLE_COUNT();
 
 	dma_sync_single_for_cpu(&ctx->drvdata->plat_dev->dev,
 				ctx->opad_tmp_keys_dma_addr,
@@ -1342,7 +1328,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 
 	ctx->key_params.keylen = keylen;
 
-	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
 
 	return 0;
 }
@@ -1510,9 +1495,6 @@ static int ssi_mac_update(struct ahash_request *req)
 	/* Setup DX request structure */
 	ssi_req.user_cb = (void *)ssi_hash_update_complete;
 	ssi_req.user_arg = (void *)req;
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (unlikely(rc != -EINPROGRESS)) {
@@ -1563,9 +1545,6 @@ static int ssi_mac_final(struct ahash_request *req)
 	/* Setup DX request structure */
 	ssi_req.user_cb = (void *)ssi_hash_complete;
 	ssi_req.user_arg = (void *)req;
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 
 	if (state->xcbc_count && (rem_cnt == 0)) {
 		/* Load key for ECB decryption */
@@ -1671,9 +1650,6 @@ static int ssi_mac_finup(struct ahash_request *req)
 	/* Setup DX request structure */
 	ssi_req.user_cb = (void *)ssi_hash_complete;
 	ssi_req.user_arg = (void *)req;
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_len = CC_AES_128_BIT_KEY_SIZE;
@@ -1747,10 +1723,6 @@ static int ssi_mac_digest(struct ahash_request *req)
 	/* Setup DX request structure */
 	ssi_req.user_cb = (void *)ssi_hash_digest_complete;
 	ssi_req.user_arg = (void *)req;
-#ifdef ENABLE_CYCLE_COUNT
-	ssi_req.op_type = STAT_OP_TYPE_ENCODE; /* Use "Encode" stats */
-#endif
-
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		keyLen = CC_AES_128_BIT_KEY_SIZE;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2ec296c..2382f32 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -37,74 +37,6 @@
 
 #define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
 
-#ifdef CC_CYCLE_COUNT
-
-#define MONITOR_CNTR_BIT 0
-
-/**
- * Monitor descriptor.
- * Used to measure CC performance.
- */
-#define INIT_CC_MONITOR_DESC(desc_p) \
-do { \
-	hw_desc_init(desc_p); \
-	HW_DESC_SET_DIN_MONITOR_CNTR(desc_p); \
-} while (0)
-
-/**
- * Try adding monitor descriptor BEFORE enqueuing sequence.
- */
-#define CC_CYCLE_DESC_HEAD(cc_base_addr, desc_p, lock_p, is_monitored_p) \
-do { \
-	if (!test_and_set_bit(MONITOR_CNTR_BIT, (lock_p))) { \
-		enqueue_seq((cc_base_addr), (desc_p), 1); \
-		*(is_monitored_p) = true; \
-	} else { \
-		*(is_monitored_p) = false; \
-	} \
-} while (0)
-
-/**
- * If CC_CYCLE_DESC_HEAD was successfully added:
- * 1. Add memory barrier descriptor to ensure last AXI transaction.
- * 2. Add monitor descriptor to sequence tail AFTER enqueuing sequence.
- */
-#define CC_CYCLE_DESC_TAIL(cc_base_addr, desc_p, is_monitored) \
-do { \
-	if ((is_monitored) == true) { \
-		struct cc_hw_desc barrier_desc; \
-		hw_desc_init(&barrier_desc); \
-		set_din_no_dma(&barrier_desc, 0, 0xfffff0); \
-		set_dout_no_dma(&barrier_desc, 0, 0, 1); \
-		enqueue_seq((cc_base_addr), &barrier_desc, 1); \
-		enqueue_seq((cc_base_addr), (desc_p), 1); \
-	} \
-} while (0)
-
-/**
- * Try reading CC monitor counter value upon sequence complete.
- * Can only succeed if the lock_p is taken by the owner of the given request.
- */
-#define END_CC_MONITOR_COUNT(cc_base_addr, stat_op_type, stat_phase, monitor_null_cycles, lock_p, is_monitored) \
-do { \
-	u32 elapsed_cycles; \
-	if ((is_monitored) == true) { \
-		elapsed_cycles = READ_REGISTER((cc_base_addr) + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR)); \
-		clear_bit(MONITOR_CNTR_BIT, (lock_p)); \
-		if (elapsed_cycles > 0) \
-			update_cc_stat(stat_op_type, stat_phase, (elapsed_cycles - monitor_null_cycles)); \
-	} \
-} while (0)
-
-#else /*CC_CYCLE_COUNT*/
-
-#define INIT_CC_MONITOR_DESC(desc_p) do { } while (0)
-#define CC_CYCLE_DESC_HEAD(cc_base_addr, desc_p, lock_p, is_monitored_p) do { } while (0)
-#define CC_CYCLE_DESC_TAIL(cc_base_addr, desc_p, is_monitored) do { } while (0)
-#define END_CC_MONITOR_COUNT(cc_base_addr, stat_op_type, stat_phase, monitor_null_cycles, lock_p, is_monitored) do { } while (0)
-#endif /*CC_CYCLE_COUNT*/
-
-
 struct ssi_request_mgr_handle {
 	/* Request manager resources */
 	unsigned int hw_queue_size; /* HW capability */
@@ -168,10 +100,6 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 
 int request_mgr_init(struct ssi_drvdata *drvdata)
 {
-#ifdef CC_CYCLE_COUNT
-	struct cc_hw_desc monitor_desc[2];
-	struct ssi_crypto_req monitor_req = {0};
-#endif
 	struct ssi_request_mgr_handle *req_mgr_h;
 	int rc = 0;
 
@@ -228,24 +156,6 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
 	set_queue_last_ind(&req_mgr_h->compl_desc);
 
-#ifdef CC_CYCLE_COUNT
-	/* For CC-HW cycle performance trace */
-	INIT_CC_MONITOR_DESC(&req_mgr_h->monitor_desc);
-	set_bit(MONITOR_CNTR_BIT, &req_mgr_h->monitor_lock);
-	monitor_desc[0] = req_mgr_h->monitor_desc;
-	monitor_desc[1] = req_mgr_h->monitor_desc;
-
-	rc = send_request(drvdata, &monitor_req, monitor_desc, 2, 0);
-	if (unlikely(rc != 0))
-		goto req_mgr_init_err;
-
-	drvdata->monitor_null_cycles = READ_REGISTER(drvdata->cc_base +
-		CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_MEASURE_CNTR));
-	SSI_LOG_ERR("Calibration time=0x%08x\n", drvdata->monitor_null_cycles);
-
-	clear_bit(MONITOR_CNTR_BIT, &req_mgr_h->monitor_lock);
-#endif
-
 	return 0;
 
 req_mgr_init_err:
@@ -367,7 +277,6 @@ int send_request(
 					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
 					SSI_IVPOOL_SEQ_LEN ) +
 					((is_dout == 0 )? 1 : 0));
-	DECL_CYCLE_COUNT_RESOURCES;
 
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
 	rc = ssi_power_mgr_runtime_get(&drvdata->plat_dev->dev);
@@ -446,12 +355,8 @@ int send_request(
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
 	}
 
-	CC_CYCLE_DESC_HEAD(cc_base, &req_mgr_h->monitor_desc,
-			&req_mgr_h->monitor_lock, &ssi_req->is_monitored_p);
-
 	/* Enqueue request - must be locked with HW lock*/
 	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *ssi_req;
-	START_CYCLE_COUNT_AT(req_mgr_h->req_queue[req_mgr_h->req_queue_head].submit_cycle);
 	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 	/* TODO: Use circ_buf.h ? */
 
@@ -462,13 +367,9 @@ int send_request(
 #endif
 
 	/* STAT_PHASE_4: Push sequence */
-	START_CYCLE_COUNT();
 	enqueue_seq(cc_base, iv_seq, iv_seq_len);
 	enqueue_seq(cc_base, desc, len);
 	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
-	END_CYCLE_COUNT(ssi_req->op_type, STAT_PHASE_4);
-
-	CC_CYCLE_DESC_TAIL(cc_base, &req_mgr_h->monitor_desc, ssi_req->is_monitored_p);
 
 	if (unlikely(req_mgr_h->q_free_slots < total_seq_len)) {
 		/*This means that there was a problem with the resume*/
@@ -558,7 +459,6 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
 	int rc = 0;
 #endif
-	DECL_CYCLE_COUNT_RESOURCES;
 
 	while(request_mgr_handle->axi_completed) {
 		request_mgr_handle->axi_completed--;
@@ -570,9 +470,6 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		}
 
 		ssi_req = &request_mgr_handle->req_queue[request_mgr_handle->req_queue_tail];
-		END_CYCLE_COUNT_AT(ssi_req->submit_cycle, ssi_req->op_type, STAT_PHASE_5); /* Seq. Comp. */
-		END_CC_MONITOR_COUNT(drvdata->cc_base, ssi_req->op_type, STAT_PHASE_6,
-			drvdata->monitor_null_cycles, &request_mgr_handle->monitor_lock, ssi_req->is_monitored_p);
 
 #ifdef FLUSH_CACHE_ALL
 		flush_cache_all();
@@ -591,9 +488,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 #endif /* COMPLETION_DELAY */
 
 		if (likely(ssi_req->user_cb != NULL)) {
-			START_CYCLE_COUNT();
 			ssi_req->user_cb(&plat_dev->dev, ssi_req->user_arg, drvdata->cc_base);
-			END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_3);
 		}
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
@@ -617,9 +512,7 @@ static void comp_handler(unsigned long devarg)
 
 	u32 irq;
 
-	DECL_CYCLE_COUNT_RESOURCES;
 
-	START_CYCLE_COUNT();
 
 	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
 
@@ -631,14 +524,6 @@ static void comp_handler(unsigned long devarg)
 		request_mgr_handle->axi_completed += CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE,
 			CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
 
-		/* ISR-to-Tasklet latency */
-		if (request_mgr_handle->axi_completed) {
-			/* Only if actually reflects ISR-to-completion-handling latency, i.e.,
-			 * not duplicate as a result of interrupt after AXIM_MON_ERR clear, before end of loop
-			 */
-			END_CYCLE_COUNT_AT(drvdata->isr_exit_cycles, STAT_OP_TYPE_GENERIC, STAT_PHASE_1);
-		}
-
 		while (request_mgr_handle->axi_completed) {
 			do {
 				proc_completions(drvdata);
@@ -662,7 +547,6 @@ static void comp_handler(unsigned long devarg)
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
 		CC_HAL_READ_REGISTER(
 		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
-	END_CYCLE_COUNT(STAT_OP_TYPE_GENERIC, STAT_PHASE_2);
 }
 
 /*
-- 
2.1.4
