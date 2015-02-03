From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 1/5] crypto: ccp - Updates for checkpatch warnings/errors
Date: Tue, 3 Feb 2015 13:07:05 -0600
Message-ID: <20150203190705.15045.40139.stgit@tlendack-t1.amdoffice.net>
References: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:45712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965959AbbBCTVR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:21:17 -0500
In-Reply-To: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes to address warnings and errors reported by the checkpatch
script.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   12 +++++++-----
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |    4 +---
 drivers/crypto/ccp/ccp-crypto-aes.c      |    3 +--
 drivers/crypto/ccp/ccp-crypto-main.c     |    5 ++---
 drivers/crypto/ccp/ccp-crypto-sha.c      |   12 +++++++-----
 drivers/crypto/ccp/ccp-crypto.h          |    3 ---
 drivers/crypto/ccp/ccp-dev.c             |    5 +----
 drivers/crypto/ccp/ccp-dev.h             |   12 ++++--------
 drivers/crypto/ccp/ccp-ops.c             |   24 ++++++++++++------------
 drivers/crypto/ccp/ccp-pci.c             |    2 +-
 drivers/crypto/ccp/ccp-platform.c        |    1 -
 11 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 8e162ad..ea7e844 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -23,7 +23,6 @@
 
 #include "ccp-crypto.h"
 
-
 static int ccp_aes_cmac_complete(struct crypto_async_request *async_req,
 				 int ret)
 {
@@ -38,11 +37,13 @@ static int ccp_aes_cmac_complete(struct crypto_async_request *async_req,
 	if (rctx->hash_rem) {
 		/* Save remaining data to buffer */
 		unsigned int offset = rctx->nbytes - rctx->hash_rem;
+
 		scatterwalk_map_and_copy(rctx->buf, rctx->src,
 					 offset, rctx->hash_rem, 0);
 		rctx->buf_count = rctx->hash_rem;
-	} else
+	} else {
 		rctx->buf_count = 0;
+	}
 
 	/* Update result area if supplied */
 	if (req->result)
@@ -202,7 +203,7 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
 }
 
 static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
-			   unsigned int key_len)
+			       unsigned int key_len)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct ccp_crypto_ahash_alg *alg =
@@ -292,7 +293,8 @@ static int ccp_aes_cmac_cra_init(struct crypto_tfm *tfm)
 	crypto_ahash_set_reqsize(ahash, sizeof(struct ccp_aes_cmac_req_ctx));
 
 	cipher_tfm = crypto_alloc_cipher("aes", 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+					 CRYPTO_ALG_ASYNC |
+					 CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(cipher_tfm)) {
 		pr_warn("could not load aes cipher driver\n");
 		return PTR_ERR(cipher_tfm);
@@ -354,7 +356,7 @@ int ccp_register_aes_cmac_algs(struct list_head *head)
 	ret = crypto_register_ahash(alg);
 	if (ret) {
 		pr_err("%s ahash algorithm registration error (%d)\n",
-			base->cra_name, ret);
+		       base->cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 0cc5594..52c7395 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -21,7 +21,6 @@
 
 #include "ccp-crypto.h"
 
-
 struct ccp_aes_xts_def {
 	const char *name;
 	const char *drv_name;
@@ -216,7 +215,6 @@ static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
 	ctx->u.aes.tfm_ablkcipher = NULL;
 }
 
-
 static int ccp_register_aes_xts_alg(struct list_head *head,
 				    const struct ccp_aes_xts_def *def)
 {
@@ -255,7 +253,7 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 	ret = crypto_register_alg(alg);
 	if (ret) {
 		pr_err("%s ablkcipher algorithm registration error (%d)\n",
-			alg->cra_name, ret);
+		       alg->cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index e46490d..7984f91 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -22,7 +22,6 @@
 
 #include "ccp-crypto.h"
 
-
 static int ccp_aes_complete(struct crypto_async_request *async_req, int ret)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
@@ -345,7 +344,7 @@ static int ccp_register_aes_alg(struct list_head *head,
 	ret = crypto_register_alg(alg);
 	if (ret) {
 		pr_err("%s ablkcipher algorithm registration error (%d)\n",
-			alg->cra_name, ret);
+		       alg->cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 4d4e016..bdec01e 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -33,7 +33,6 @@ static unsigned int sha_disable;
 module_param(sha_disable, uint, 0444);
 MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
 
-
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
 static LIST_HEAD(cipher_algs);
@@ -48,6 +47,7 @@ struct ccp_crypto_queue {
 	struct list_head *backlog;
 	unsigned int cmd_count;
 };
+
 #define CCP_CRYPTO_MAX_QLEN	100
 
 static struct ccp_crypto_queue req_queue;
@@ -77,7 +77,6 @@ struct ccp_crypto_cpu {
 	int err;
 };
 
-
 static inline bool ccp_crypto_success(int err)
 {
 	if (err && (err != -EINPROGRESS) && (err != -EBUSY))
@@ -143,7 +142,7 @@ static void ccp_crypto_complete(void *data, int err)
 	int ret;
 
 	if (err == -EINPROGRESS) {
-		/* Only propogate the -EINPROGRESS if necessary */
+		/* Only propagate the -EINPROGRESS if necessary */
 		if (crypto_cmd->ret == -EBUSY) {
 			crypto_cmd->ret = -EINPROGRESS;
 			req->complete(req, -EINPROGRESS);
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 9653157..507b34e 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -23,7 +23,6 @@
 
 #include "ccp-crypto.h"
 
-
 static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 {
 	struct ahash_request *req = ahash_request_cast(async_req);
@@ -37,11 +36,13 @@ static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 	if (rctx->hash_rem) {
 		/* Save remaining data to buffer */
 		unsigned int offset = rctx->nbytes - rctx->hash_rem;
+
 		scatterwalk_map_and_copy(rctx->buf, rctx->src,
 					 offset, rctx->hash_rem, 0);
 		rctx->buf_count = rctx->hash_rem;
-	} else
+	} else {
 		rctx->buf_count = 0;
+	}
 
 	/* Update result area if supplied */
 	if (req->result)
@@ -227,8 +228,9 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 		}
 
 		key_len = digest_size;
-	} else
+	} else {
 		memcpy(ctx->u.sha.key, key, key_len);
+	}
 
 	for (i = 0; i < block_size; i++) {
 		ctx->u.sha.ipad[i] = ctx->u.sha.key[i] ^ 0x36;
@@ -355,7 +357,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
 	ret = crypto_register_ahash(alg);
 	if (ret) {
 		pr_err("%s ahash algorithm registration error (%d)\n",
-			base->cra_name, ret);
+		       base->cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
@@ -410,7 +412,7 @@ static int ccp_register_sha_alg(struct list_head *head,
 	ret = crypto_register_ahash(alg);
 	if (ret) {
 		pr_err("%s ahash algorithm registration error (%d)\n",
-			base->cra_name, ret);
+		       base->cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 9aa4ae1..76a96f0 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -13,7 +13,6 @@
 #ifndef __CCP_CRYPTO_H__
 #define __CCP_CRYPTO_H__
 
-
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/pci.h>
@@ -25,7 +24,6 @@
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 
-
 #define CCP_CRA_PRIORITY	300
 
 struct ccp_crypto_ablkcipher_alg {
@@ -68,7 +66,6 @@ static inline struct ccp_crypto_ahash_alg *
 	return container_of(ahash_alg, struct ccp_crypto_ahash_alg, alg);
 }
 
-
 /***** AES related defines *****/
 struct ccp_aes_ctx {
 	/* Fallback cipher for XTS with unsupported unit sizes */
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index ca29c12..68c637a 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -37,7 +37,6 @@ struct ccp_tasklet_data {
 	struct ccp_cmd *cmd;
 };
 
-
 static struct ccp_device *ccp_dev;
 static inline struct ccp_device *ccp_get_device(void)
 {
@@ -297,10 +296,8 @@ struct ccp_device *ccp_alloc_struct(struct device *dev)
 	struct ccp_device *ccp;
 
 	ccp = kzalloc(sizeof(*ccp), GFP_KERNEL);
-	if (ccp == NULL) {
-		dev_err(dev, "unable to allocate device struct\n");
+	if (!ccp)
 		return NULL;
-	}
 	ccp->dev = dev;
 
 	INIT_LIST_HEAD(&ccp->cmd);
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 62ff35a..6ff8903 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -21,7 +21,7 @@
 #include <linux/wait.h>
 #include <linux/dmapool.h>
 #include <linux/hw_random.h>
-
+#include <linux/bitops.h>
 
 #define MAX_DMAPOOL_NAME_LEN		32
 
@@ -33,7 +33,6 @@
 #define CACHE_NONE			0x00
 #define CACHE_WB_NO_ALLOC		0xb7
 
-
 /****** Register Mappings ******/
 #define Q_MASK_REG			0x000
 #define TRNG_OUT_REG			0x00c
@@ -54,8 +53,8 @@
 #define CMD_Q_CACHE_BASE		0x228
 #define CMD_Q_CACHE_INC			0x20
 
-#define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f);
-#define CMD_Q_DEPTH(__qs)		(((__qs) >> 12) & 0x0000000f);
+#define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f)
+#define CMD_Q_DEPTH(__qs)		(((__qs) >> 12) & 0x0000000f)
 
 /****** REQ0 Related Values ******/
 #define REQ0_WAIT_FOR_WRITE		0x00000004
@@ -103,7 +102,6 @@
 /****** REQ6 Related Values ******/
 #define REQ6_MEMTYPE_SHIFT		16
 
-
 /****** Key Storage Block ******/
 #define KSB_START			77
 #define KSB_END				127
@@ -114,7 +112,7 @@
 #define CCP_JOBID_MASK			0x0000003f
 
 #define CCP_DMAPOOL_MAX_SIZE		64
-#define CCP_DMAPOOL_ALIGN		(1 << 5)
+#define CCP_DMAPOOL_ALIGN		BIT(5)
 
 #define CCP_REVERSE_BUF_SIZE		64
 
@@ -142,7 +140,6 @@
 #define CCP_ECC_RESULT_OFFSET		60
 #define CCP_ECC_RESULT_SUCCESS		0x0001
 
-
 struct ccp_device;
 struct ccp_cmd;
 
@@ -261,7 +258,6 @@ struct ccp_device {
 	unsigned int axcache;
 };
 
-
 int ccp_pci_init(void);
 void ccp_pci_exit(void);
 
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 8729364..71f2e3c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -27,7 +27,6 @@
 
 #include "ccp-dev.h"
 
-
 enum ccp_memtype {
 	CCP_MEMTYPE_SYSTEM = 0,
 	CCP_MEMTYPE_KSB,
@@ -515,7 +514,6 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 	if (!wa->dma_count)
 		return -ENOMEM;
 
-
 	return 0;
 }
 
@@ -763,8 +761,9 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
 		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
 		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
 		op_len = min(sg_src_len, sg_dst_len);
-	} else
+	} else {
 		op_len = sg_src_len;
+	}
 
 	/* The data operation length will be at least block_size in length
 	 * or the smaller of available sg room remaining for the source or
@@ -1131,9 +1130,9 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_ctx;
 
-	if (in_place)
+	if (in_place) {
 		dst = src;
-	else {
+	} else {
 		ret = ccp_init_data(&dst, cmd_q, aes->dst, aes->src_len,
 				    AES_BLOCK_SIZE, DMA_FROM_DEVICE);
 		if (ret)
@@ -1304,9 +1303,9 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	if (ret)
 		goto e_ctx;
 
-	if (in_place)
+	if (in_place) {
 		dst = src;
-	else {
+	} else {
 		ret = ccp_init_data(&dst, cmd_q, xts->dst, xts->src_len,
 				    unit_size, DMA_FROM_DEVICE);
 		if (ret)
@@ -1451,8 +1450,9 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			goto e_ctx;
 		}
 		memcpy(ctx.address, init, CCP_SHA_CTXSIZE);
-	} else
+	} else {
 		ccp_set_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
+	}
 
 	ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
 			      CCP_PASSTHRU_BYTESWAP_256BIT);
@@ -1732,9 +1732,9 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 	if (ret)
 		goto e_mask;
 
-	if (in_place)
+	if (in_place) {
 		dst = src;
-	else {
+	} else {
 		ret = ccp_init_data(&dst, cmd_q, pt->dst, pt->src_len,
 				    CCP_PASSTHRU_MASKSIZE, DMA_FROM_DEVICE);
 		if (ret)
@@ -1974,7 +1974,7 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Set the first point Z coordianate to 1 */
-	*(src.address) = 0x01;
+	*src.address = 0x01;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
@@ -1989,7 +1989,7 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		/* Set the second point Z coordianate to 1 */
-		*(src.address) = 0x01;
+		*src.address = 0x01;
 		src.address += CCP_ECC_OPERAND_SIZE;
 	} else {
 		/* Copy the Domain "a" parameter */
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 7f89c94..1980f77 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -204,7 +204,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = -EIO;
 	ccp->io_map = pci_iomap(pdev, bar, 0);
-	if (ccp->io_map == NULL) {
+	if (!ccp->io_map) {
 		dev_err(dev, "pci_iomap failed\n");
 		goto e_device;
 	}
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 8c50bad..9e09c50 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -26,7 +26,6 @@
 
 #include "ccp-dev.h"
 
-
 static int ccp_get_irq(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
