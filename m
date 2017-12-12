From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 17/24] staging: ccree: remove SSI_CC_HAS_ macros
Date: Tue, 12 Dec 2017 14:53:03 +0000
Message-ID: <1513090395-7938-18-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

Remove macro controlling build of various features. This
needs to happen dynamically in registration time.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       | 33 ---------------------------------
 drivers/staging/ccree/ssi_buffer_mgr.c |  4 ----
 drivers/staging/ccree/ssi_cipher.c     |  8 --------
 drivers/staging/ccree/ssi_driver.h     |  8 --------
 drivers/staging/ccree/ssi_hash.c       |  5 -----
 5 files changed, 58 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 112fba3..ac9961c 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -662,7 +662,6 @@ cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	return rc;
 }
 
-#if SSI_CC_HAS_AES_CCM
 static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 				 unsigned int keylen)
 {
@@ -676,7 +675,6 @@ static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	return cc_aead_setkey(tfm, key, keylen);
 }
-#endif /*SSI_CC_HAS_AES_CCM*/
 
 static int cc_aead_setauthsize(struct crypto_aead *authenc,
 			       unsigned int authsize)
@@ -696,7 +694,6 @@ static int cc_aead_setauthsize(struct crypto_aead *authenc,
 	return 0;
 }
 
-#if SSI_CC_HAS_AES_CCM
 static int cc_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
 				      unsigned int authsize)
 {
@@ -730,7 +727,6 @@ static int cc_ccm_setauthsize(struct crypto_aead *authenc,
 
 	return cc_aead_setauthsize(authenc, authsize);
 }
-#endif /*SSI_CC_HAS_AES_CCM*/
 
 static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 			      struct cc_hw_desc desc[], unsigned int *seq_size)
@@ -1374,7 +1370,6 @@ static int validate_data_size(struct cc_aead_ctx *ctx,
 	return -EINVAL;
 }
 
-#if SSI_CC_HAS_AES_CCM
 static unsigned int format_ccm_a0(u8 *pa0_buff, u32 header_size)
 {
 	unsigned int len = 0;
@@ -1623,9 +1618,6 @@ static void cc_proc_rfc4309_ccm(struct aead_request *req)
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= CCM_BLOCK_IV_SIZE;
 }
-#endif /*SSI_CC_HAS_AES_CCM*/
-
-#if SSI_CC_HAS_AES_GCM
 
 static void cc_set_ghash_desc(struct aead_request *req,
 			      struct cc_hw_desc desc[], unsigned int *seq_size)
@@ -1952,8 +1944,6 @@ static void cc_proc_rfc4_gcm(struct aead_request *req)
 	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
-#endif /*SSI_CC_HAS_AES_GCM*/
-
 static int cc_proc_aead(struct aead_request *req,
 			enum drv_crypto_direction direct)
 {
@@ -2020,7 +2010,6 @@ static int cc_proc_aead(struct aead_request *req,
 		areq_ctx->hw_iv_size = crypto_aead_ivsize(tfm);
 	}
 
-#if SSI_CC_HAS_AES_CCM
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
 		if (rc) {
@@ -2031,11 +2020,7 @@ static int cc_proc_aead(struct aead_request *req,
 	} else {
 		areq_ctx->ccm_hdr_size = ccm_header_size_null;
 	}
-#else
-	areq_ctx->ccm_hdr_size = ccm_header_size_null;
-#endif /*SSI_CC_HAS_AES_CCM*/
 
-#if SSI_CC_HAS_AES_GCM
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
 		if (rc) {
@@ -2044,7 +2029,6 @@ static int cc_proc_aead(struct aead_request *req,
 			goto exit;
 		}
 	}
-#endif /*SSI_CC_HAS_AES_GCM*/
 
 	rc = cc_map_aead_request(ctx->drvdata, req);
 	if (rc) {
@@ -2100,18 +2084,12 @@ static int cc_proc_aead(struct aead_request *req,
 	case DRV_HASH_XCBC_MAC:
 		cc_xcbc_authenc(req, desc, &seq_len);
 		break;
-#if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM)
 	case DRV_HASH_NULL:
-#if SSI_CC_HAS_AES_CCM
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			cc_ccm(req, desc, &seq_len);
-#endif /*SSI_CC_HAS_AES_CCM*/
-#if SSI_CC_HAS_AES_GCM
 		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
 			cc_gcm(req, desc, &seq_len);
-#endif /*SSI_CC_HAS_AES_GCM*/
 		break;
-#endif
 	default:
 		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
 		cc_unmap_aead_request(dev, req);
@@ -2151,7 +2129,6 @@ static int cc_aead_encrypt(struct aead_request *req)
 	return rc;
 }
 
-#if SSI_CC_HAS_AES_CCM
 static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 {
 	/* Very similar to cc_aead_encrypt() above. */
@@ -2180,7 +2157,6 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 out:
 	return rc;
 }
-#endif /* SSI_CC_HAS_AES_CCM */
 
 static int cc_aead_decrypt(struct aead_request *req)
 {
@@ -2201,7 +2177,6 @@ static int cc_aead_decrypt(struct aead_request *req)
 	return rc;
 }
 
-#if SSI_CC_HAS_AES_CCM
 static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -2229,9 +2204,6 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 out:
 	return rc;
 }
-#endif /* SSI_CC_HAS_AES_CCM */
-
-#if SSI_CC_HAS_AES_GCM
 
 static int cc_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 				 unsigned int keylen)
@@ -2429,7 +2401,6 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 
 	return rc;
 }
-#endif /* SSI_CC_HAS_AES_GCM */
 
 /* DX Block aead alg */
 static struct ssi_alg_template aead_algs[] = {
@@ -2585,7 +2556,6 @@ static struct ssi_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_XCBC_MAC,
 	},
-#if SSI_CC_HAS_AES_CCM
 	{
 		.name = "ccm(aes)",
 		.driver_name = "ccm-aes-dx",
@@ -2624,8 +2594,6 @@ static struct ssi_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 	},
-#endif /*SSI_CC_HAS_AES_CCM*/
-#if SSI_CC_HAS_AES_GCM
 	{
 		.name = "gcm(aes)",
 		.driver_name = "gcm-aes-dx",
@@ -2683,7 +2651,6 @@ static struct ssi_alg_template aead_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
 	},
-#endif /*SSI_CC_HAS_AES_GCM*/
 };
 
 static struct ssi_crypto_alg *cc_create_aead_alg(struct ssi_alg_template *tmpl,
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 4ab76dc..c28ce7c 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -604,7 +604,6 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 				 MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
 	}
 
-#if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		if (areq_ctx->hkey_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
@@ -626,7 +625,6 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 	}
-#endif
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (areq_ctx->ccm_iv0_dma_addr) {
@@ -1269,7 +1267,6 @@ int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 		}
 	}
 
-#if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
 					  DMA_BIDIRECTIONAL);
@@ -1315,7 +1312,6 @@ int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 		}
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
 	}
-#endif /*SSI_CC_HAS_AES_GCM*/
 
 	size_to_map = req->cryptlen + req->assoclen;
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index a158213..299e73a 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -783,7 +783,6 @@ static int cc_cipher_decrypt(struct ablkcipher_request *req)
 
 /* DX Block cipher alg */
 static struct ssi_alg_template blkcipher_algs[] = {
-#if SSI_CC_HAS_AES_XTS
 	{
 		.name = "xts(aes)",
 		.driver_name = "xts-aes-dx",
@@ -833,8 +832,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
 	},
-#endif /*SSI_CC_HAS_AES_XTS*/
-#if SSI_CC_HAS_AES_ESSIV
 	{
 		.name = "essiv(aes)",
 		.driver_name = "essiv-aes-dx",
@@ -883,8 +880,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
 	},
-#endif /*SSI_CC_HAS_AES_ESSIV*/
-#if SSI_CC_HAS_AES_BITLOCKER
 	{
 		.name = "bitlocker(aes)",
 		.driver_name = "bitlocker-aes-dx",
@@ -933,7 +928,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
 	},
-#endif /*SSI_CC_HAS_AES_BITLOCKER*/
 	{
 		.name = "ecb(aes)",
 		.driver_name = "ecb-aes-dx",
@@ -982,7 +976,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
 	},
-#if SSI_CC_HAS_AES_CTS
 	{
 		.name = "cts1(cbc(aes))",
 		.driver_name = "cts1-cbc-aes-dx",
@@ -999,7 +992,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
 	},
-#endif
 	{
 		.name = "ctr(aes)",
 		.driver_name = "ctr-aes-dx",
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index a2de584..c9fdb89 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -54,14 +54,6 @@
 #define SSI_DEV_NAME_STR "cc715ree"
 #define CC_COHERENT_CACHE_PARAMS 0xEEE
 
-#define SSI_CC_HAS_AES_CCM 1
-#define SSI_CC_HAS_AES_GCM 1
-#define SSI_CC_HAS_AES_XTS 1
-#define SSI_CC_HAS_AES_ESSIV 1
-#define SSI_CC_HAS_AES_BITLOCKER 1
-#define SSI_CC_HAS_AES_CTS 1
-#define SSI_CC_HAS_CMAC 1
-
 #define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
 			  (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
 			  (1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 29c17f3..10c73ef 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1190,7 +1190,6 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 	return rc;
 }
 
-#if SSI_CC_HAS_CMAC
 static int cc_cmac_setkey(struct crypto_ahash *ahash,
 			  const u8 *key, unsigned int keylen)
 {
@@ -1230,7 +1229,6 @@ static int cc_cmac_setkey(struct crypto_ahash *ahash,
 
 	return 0;
 }
-#endif
 
 static void cc_free_ctx(struct cc_hash_ctx *ctx)
 {
@@ -1937,7 +1935,6 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_CIPHER_XCBC_MAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
 	},
-#if SSI_CC_HAS_CMAC
 	{
 		.mac_name = "cmac(aes)",
 		.mac_driver_name = "cmac-aes-dx",
@@ -1960,8 +1957,6 @@ static struct cc_hash_template driver_hash[] = {
 		.hw_mode = DRV_CIPHER_CMAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
 	},
-#endif
-
 };
 
 static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
-- 
2.7.4
