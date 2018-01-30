From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH 2/3] crypto: hisilicon hacv1 driver
Date: Tue, 30 Jan 2018 15:29:52 +0000
Message-ID: <20180130152953.14068-3-jonathan.cameron@huawei.com>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linuxarm@huawei.com>, <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Xiongfeng Wang <xiongfeng.wang@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58734 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753047AbeA3PbA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 10:31:00 -0500
In-Reply-To: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

This accelerator is found inside hisilicon hip06 and hip07 SoCs.
Each instance provides a number of queues which feed a different number of
backend accleration units.

The queues are operating in an out of order mode in the interests of
throughput. The silicon does not do tracking of dependencies between
multiple 'messages' or update of the IVs as appropriate for training.
Hence where relevant we need to do this in software.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/crypto/Kconfig                  |    2 +
 drivers/crypto/Makefile                 |    1 +
 drivers/crypto/hisilicon/Kconfig        |   16 +
 drivers/crypto/hisilicon/Makefile       |    2 +
 drivers/crypto/hisilicon/sec/Makefile   |    3 +
 drivers/crypto/hisilicon/sec/sec_algs.c | 1082 +++++++++++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.c  | 1418 +++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.h  |  282 ++++++
 8 files changed, 2806 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 47ec920d5b71..ea85924427e9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -731,4 +731,6 @@ config CRYPTO_DEV_ARTPEC6
 
 	  To compile this driver as a module, choose M here.
 
+source "drivers/crypto/hisilicon/Kconfig"
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 2513d13ea2c4..ed237414ca1b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -45,3 +45,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
+obj-$(CONFIG_CRYPTO_DEV_HISILICON) += hisilicon/
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
new file mode 100644
index 000000000000..cd9296687235
--- /dev/null
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config CRYPTO_DEV_HISILICON
+	bool
+
+config CRYPTO_DEV_HISI_SEC
+	tristate "Support for Hisilicon SEC crypto block cipher accelerator"
+	select CRYPTO_DEV_HISILICON
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_ALGAPI
+	depends on ARM64
+	help
+	  Support for Hisilicon SEC Engine in Hip06 and Hip07
+
+	  To compile this as a module, choose M here: the module
+	  will be called hisi_sec.
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
new file mode 100644
index 000000000000..463f46ace182
--- /dev/null
+++ b/drivers/crypto/hisilicon/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
diff --git a/drivers/crypto/hisilicon/sec/Makefile b/drivers/crypto/hisilicon/sec/Makefile
new file mode 100644
index 000000000000..a55b698e0c27
--- /dev/null
+++ b/drivers/crypto/hisilicon/sec/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += hisi_sec.o
+hisi_sec-y = sec_algs.o sec_drv.o
diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
new file mode 100644
index 000000000000..6b82636f7979
--- /dev/null
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -0,0 +1,1082 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2017 Hisilicon Limited. */
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/skcipher.h>
+#include <crypto/internal/skcipher.h>
+
+#include "sec_drv.h"
+
+enum sec_cipher_type {
+	SEC_CIPHER_NULL,
+	SEC_CIPHER_ENCRYPT,
+	SEC_CIPHER_DECRYPT,
+	SEC_CIPHER_PASS,
+	SEC_CIPHER_INVALID,
+};
+
+#define SEC_C_ALG_DES			0
+#define SEC_C_ALG_3DES			1
+#define SEC_C_ALG_AES			2
+
+#define SEC_C_MODE_ECB			0
+#define SEC_C_MODE_CBC			1
+#define SEC_C_MODE_CTR			4
+#define SEC_C_MODE_CCM			5
+#define SEC_C_MODE_GCM			6
+#define SEC_C_MODE_XTS			7
+
+#define SEC_KEY_LEN_AES_128		0
+#define SEC_KEY_LEN_AES_192		1
+#define SEC_KEY_LEN_AES_256		2
+#define SEC_KEY_LEN_DES			1
+#define SEC_KEY_LEN_3DES_3_KEY		1
+#define SEC_KEY_LEN_3DES_2_KEY		3
+
+#define SEC_C_WIDTH_AES_128BIT		0
+#define SEC_C_WIDTH_AES_8BIT		1
+#define SEC_C_WIDTH_AES_1BIT		2
+#define SEC_C_WIDTH_DES_64BIT		0
+#define SEC_C_WIDTH_DES_8BIT		1
+#define SEC_C_WIDTH_DES_1BIT		2
+
+enum sec_cipher_alg {
+	SEC_DES_ECB_64,
+	SEC_DES_CBC_64,
+
+	SEC_3DES_ECB_192_3KEY,
+	SEC_3DES_ECB_192_2KEY,
+
+	SEC_3DES_CBC_192_3KEY,
+	SEC_3DES_CBC_192_2KEY,
+
+	SEC_AES_ECB_128,
+	SEC_AES_ECB_192,
+	SEC_AES_ECB_256,
+
+	SEC_AES_CBC_128,
+	SEC_AES_CBC_192,
+	SEC_AES_CBC_256,
+
+	SEC_AES_CTR_128,
+	SEC_AES_CTR_192,
+	SEC_AES_CTR_256,
+
+	SEC_AES_XTS_128,
+	SEC_AES_XTS_256,
+};
+
+
+struct sec_c_alg_cfg {
+	unsigned c_alg		: 3;
+	unsigned c_mode		: 3;
+	unsigned key_len	: 2;
+	unsigned c_width	: 2;
+};
+
+static const struct sec_c_alg_cfg sec_c_alg_cfgs[] =  {
+	[SEC_DES_ECB_64] = {
+		.c_alg = SEC_C_ALG_DES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_DES,
+	},
+	[SEC_DES_CBC_64] = {
+		.c_alg = SEC_C_ALG_DES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_DES,
+	},
+	[SEC_3DES_ECB_192_3KEY] = {
+		.c_alg = SEC_C_ALG_3DES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_3DES_3_KEY,
+	},
+	[SEC_3DES_ECB_192_2KEY] = {
+		.c_alg = SEC_C_ALG_3DES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_3DES_2_KEY,
+	},
+	[SEC_3DES_CBC_192_3KEY] = {
+		.c_alg = SEC_C_ALG_3DES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_3DES_3_KEY,
+	},
+	[SEC_3DES_CBC_192_2KEY] = {
+		.c_alg = SEC_C_ALG_3DES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_3DES_2_KEY,
+	},
+	[SEC_AES_ECB_128] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_AES_128,
+	},
+	[SEC_AES_ECB_192] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_AES_192,
+	},
+	[SEC_AES_ECB_256] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_ECB,
+		.key_len = SEC_KEY_LEN_AES_256,
+	},
+	[SEC_AES_CBC_128] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_AES_128,
+	},
+	[SEC_AES_CBC_192] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_AES_192,
+	},
+	[SEC_AES_CBC_256] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CBC,
+		.key_len = SEC_KEY_LEN_AES_256,
+	},
+	[SEC_AES_CTR_128] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CTR,
+		.key_len = SEC_KEY_LEN_AES_128,
+	},
+	[SEC_AES_CTR_192] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CTR,
+		.key_len = SEC_KEY_LEN_AES_192,
+	},
+	[SEC_AES_CTR_256] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_CTR,
+		.key_len = SEC_KEY_LEN_AES_256,
+	},
+	[SEC_AES_XTS_128] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_XTS,
+		.key_len = SEC_KEY_LEN_AES_128,
+	},
+	[SEC_AES_XTS_256] = {
+		.c_alg = SEC_C_ALG_AES,
+		.c_mode = SEC_C_MODE_XTS,
+		.key_len = SEC_KEY_LEN_AES_256,
+	},
+};
+
+struct sec_alg_skcipher_ctx {
+	enum sec_cipher_alg cipher_alg;
+	u8 *enc_key;
+	u8 *dec_key;
+	dma_addr_t enc_pkey;
+	dma_addr_t dec_pkey;
+	struct sec_bd_info enc_req;
+	struct sec_bd_info dec_req;
+	struct skreq *current_request;
+	struct sec_queue *queue;
+	spinlock_t lock;
+	u8 *prev_iv_address;
+};
+
+/**
+ * struct sec_crypto_request - data associate with a single cryto request
+ * @req: hardware specific block descriptor corresponding to this request
+ * @skcipher_ctx: hardware specific context for block ciphers.
+ * @in: hardware sgl for input - virtual address
+ * @dma_in: hardware sgl for input - physical address
+ * @len_in: length of in sgl from upper layers
+ * @out: hardware sgl for output - virtual address
+ * @dma_out: hardware sgl for output - physical address
+ * @len_out: length of out sgl from upper layers
+ * @iv: initialization vector - virtual address
+ * @dma_iv: initialization vector - phsyical address
+ * @cb: completion callback.
+ */
+struct sec_crypto_request {
+	struct sec_bd_info req;
+	struct sec_alg_skcipher_ctx *skcipher_ctx;
+	struct sec_hw_sgl *in;
+	dma_addr_t dma_in;
+	int len_in;
+	struct sec_hw_sgl *out;
+	dma_addr_t dma_out;
+	int len_out;
+	u8 *iv;
+	dma_addr_t dma_iv;
+	void (*cb)(struct sec_bd_info *resp, struct skcipher_request *req);
+};
+
+static DEFINE_MUTEX(algs_lock);
+static unsigned int active_devs;
+
+static void sec_alg_skcipher_com_init(struct sec_alg_skcipher_ctx *ctx,
+				      struct sec_bd_info *req,
+				      enum sec_cipher_alg alg)
+{
+	const struct sec_c_alg_cfg *cfg = &sec_c_alg_cfgs[alg];
+
+	req->w0 &= ~SEC_BD_W0_DONE;
+	req->w0 &= ~SEC_BD_W0_C_MODE_M;
+	req->w0 |= (cfg->c_mode << SEC_BD_W0_C_MODE_S) & SEC_BD_W0_C_MODE_M;
+
+	req->w1 &= ~SEC_BD_W1_BD_INVALID;
+	req->w1 &= ~SEC_BD_W1_C_ALG_M;
+	req->w1 |= (cfg->c_alg << SEC_BD_W1_C_ALG_S) & SEC_BD_W1_C_ALG_M;
+
+	req->w3 &= ~SEC_BD_W3_C_KEY_LEN_M;
+	req->w3 |= (cfg->key_len << SEC_BD_W3_C_KEY_LEN_S) &
+		SEC_BD_W3_C_KEY_LEN_M;
+
+	req->w0 &= ~SEC_BD_W0_C_WIDTH_M;
+	req->w0 |= cfg->c_width & SEC_BD_W0_C_WIDTH_M;
+	req->w0 &= ~SEC_BD_W0_SEQ;
+
+	req->cipher_key_addr_lo = lower_32_bits(ctx->enc_pkey);
+	req->cipher_key_addr_hi = upper_32_bits(ctx->enc_pkey);
+}
+
+static void sec_alg_skcipher_init_enc(struct sec_alg_skcipher_ctx *ctx,
+				      int alg, const u8 *key,
+				      unsigned int keylen)
+{
+	ctx->enc_req.w0 &= SEC_BD_W0_CIPHER_M;
+	ctx->enc_req.w0 |= (SEC_CIPHER_ENCRYPT << SEC_BD_W0_CIPHER_S) &
+		SEC_BD_W0_CIPHER_M;
+	memcpy(ctx->enc_key, key, keylen);
+	sec_alg_skcipher_com_init(ctx, &ctx->enc_req, alg);
+}
+
+static void sec_alg_skcipher_init_dec(struct sec_alg_skcipher_ctx *ctx,
+				      int alg, const u8 *key,
+				      unsigned int keylen)
+{
+	ctx->dec_req.w0 &= SEC_BD_W0_CIPHER_M;
+	ctx->dec_req.w0 |= (SEC_CIPHER_DECRYPT << SEC_BD_W0_CIPHER_S) &
+		SEC_BD_W0_CIPHER_M;
+	memcpy(ctx->dec_key, key, keylen);
+	sec_alg_skcipher_com_init(ctx, &ctx->dec_req, alg);
+}
+
+static int sec_alg_skcipher_init_context(struct crypto_skcipher *atfm,
+					 const u8 *key,
+					 unsigned int keylen,
+					 enum sec_cipher_alg alg)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(atfm);
+	struct sec_alg_skcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->cipher_alg = alg;
+	sec_alg_skcipher_init_enc(ctx, ctx->cipher_alg, key, keylen);
+	sec_alg_skcipher_init_dec(ctx, ctx->cipher_alg, key, keylen);
+
+	return 0;
+}
+
+static struct sec_hw_sgl *sec_setup_sec_sgl(dma_addr_t *psecsgl,
+					    struct scatterlist *sgl,
+					    int sgl_len,
+					    struct sec_dev_info *info)
+{
+	struct sec_hw_sgl *temp = NULL;
+	struct sec_hw_sgl *sec_sgl = NULL;
+	struct sec_hw_sgl *temp1;
+	dma_addr_t temp1_dma;
+	dma_addr_t psec_sgl;
+	struct scatterlist *sg;
+	int n = sgl_len;
+	int i, ret, index_in_sge;
+	int count;
+
+	if (!n)
+		return ERR_PTR(-EINVAL);
+
+	/* Special path for single element SGLs with small packets. */
+	if (sg_is_last(sgl) && sgl->length <= SEC_SMALL_PACKET_SIZE) {
+		void *el;
+
+		sec_sgl = dma_pool_zalloc(info->hw_sgl_pool,
+					  GFP_ATOMIC,
+					  &psec_sgl);
+		if (!sec_sgl)
+			return ERR_PTR(-ENOMEM);
+
+		el = dma_pool_alloc(info->small_packets_pool, GFP_ATOMIC,
+				    &sec_sgl->sge_entries[0].buf);
+		if (!el) {
+			dma_pool_free(info->hw_sgl_pool,
+				      sec_sgl,
+				      psec_sgl);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		sec_sgl->sge_entries[0].len = sgl->length;
+		/*
+		 * The vaddr needs to be stashed somewhere for the free so
+		 * put it in the next element of the sgl.
+		 *
+		 * Note we are abusing a location we know will be untouched
+		 * hence the odd type casting.
+		 */
+		sec_sgl->sge_entries[1].buf = (dma_addr_t)el;
+		sg_copy_to_buffer(sgl, 1, el, sgl->length);
+		sec_sgl->entry_sum_in_chain = 1;
+		sec_sgl->entry_sum_in_sgl = 1;
+		sec_sgl->data_bytes_in_sgl = sgl->length;
+		*psecsgl = psec_sgl;
+
+		return sec_sgl;
+	}
+
+	count = dma_map_sg(info->dev, sgl, sgl_len, DMA_BIDIRECTIONAL);
+	if (!count)
+		return ERR_PTR(-EINVAL);
+
+	for_each_sg(sgl, sg, count, i) {
+		index_in_sge = i % SEC_MAX_SGE_NUM;
+		if (index_in_sge == 0) {
+			temp1 = dma_pool_zalloc(info->hw_sgl_pool, GFP_ATOMIC,
+						&temp1_dma);
+			if (!temp1) {
+				ret = -ENOMEM;
+				goto err_free_hw_sgls;
+			}
+
+			if (!temp) { /* First one */
+				psec_sgl = temp1_dma;
+				sec_sgl = temp1;
+			} else { /* Chained */
+				temp->entry_sum_in_sgl = SEC_MAX_SGE_NUM;
+				temp->next_sgl = temp1_dma;
+				temp->next = temp1;
+			}
+			temp = temp1;
+		}
+		temp->sge_entries[index_in_sge].buf = sg_dma_address(sg);
+		temp->sge_entries[index_in_sge].len = sg_dma_len(sg);
+		temp->data_bytes_in_sgl += sg_dma_len(sg);
+	}
+	temp->entry_sum_in_sgl = count % SEC_MAX_SGE_NUM;
+	temp->next_sgl = 0;
+	sec_sgl->entry_sum_in_chain = count;
+	*psecsgl = psec_sgl;
+
+	return sec_sgl;
+
+err_free_hw_sgls:
+	temp = sec_sgl;
+	while (temp) {
+		temp1 = temp->next;
+		dma_pool_free(info->hw_sgl_pool, temp, temp->next_sgl);
+		temp = temp1;
+	}
+	*psecsgl = 0;
+
+	return ERR_PTR(ret);
+}
+
+static void sec_destroy_sec_sgl(struct scatterlist *sgl,
+				int sgl_length,
+				struct sec_hw_sgl *hw_sgl,
+				dma_addr_t psec_sgl, struct sec_dev_info *info)
+{
+	struct sec_hw_sgl *temp, *temp1;
+
+	temp = hw_sgl;
+	/*
+	 * Here we may have fused two small sge during dma_map_sg sp need
+	 * to be careful.
+	 */
+	if (sg_is_last(sgl) && sgl->length <= SEC_SMALL_PACKET_SIZE &&
+	    hw_sgl->sge_entries[1].buf && !hw_sgl->sge_entries[1].len){
+		sg_copy_from_buffer(sgl, 1,
+				    (void *)(hw_sgl->sge_entries[1].buf),
+				    sgl->length);
+		dma_pool_free(info->small_packets_pool,
+			      (void *)(hw_sgl->sge_entries[1].buf),
+			      hw_sgl->sge_entries[0].buf);
+		dma_pool_free(info->hw_sgl_pool, hw_sgl, psec_sgl);
+		return;
+	}
+
+	while (temp->next) {
+		temp1 = temp->next;
+		dma_pool_free(info->hw_sgl_pool, temp, temp->next_sgl);
+		temp = temp1;
+	}
+	dma_pool_free(info->hw_sgl_pool, hw_sgl, psec_sgl);
+	dma_unmap_sg(info->dev, sgl, sgl_length, DMA_BIDIRECTIONAL);
+}
+
+static void sec_free_opdata(struct sec_queue *queue,
+			    struct scatterlist *sgl,
+			    struct scatterlist *sgl_out,
+			    struct skcipher_request *skreq)
+{
+	struct sec_crypto_request *sec_req = skcipher_request_ctx(skreq);
+
+	sec_destroy_sec_sgl(sgl, sec_req->len_in, sec_req->in, sec_req->dma_in,
+			    queue->dev_info);
+	sec_req->dma_in = 0;
+	if (skreq->src != skreq->dst) {
+		sec_destroy_sec_sgl(sgl_out, sec_req->len_out, sec_req->out,
+				    sec_req->dma_out, queue->dev_info);
+		sec_req->dma_out = 0;
+	}
+	dma_pool_free(queue->dev_info->iv_pool, sec_req->iv, sec_req->dma_iv);
+}
+
+static int sec_create_opdata(struct sec_queue *queue,
+			     struct scatterlist *sgl,
+			     struct scatterlist *sglout,
+			     struct skcipher_request *skreq)
+{
+	struct sec_crypto_request *sec_req = skcipher_request_ctx(skreq);
+	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
+	struct device *dev = queue->dev_info->dev;
+	struct sec_hw_sgl *inbufs, *outbufs;
+	dma_addr_t pinbufs, poutbufs;
+	int ret;
+
+	sec_req->iv = dma_pool_zalloc(queue->dev_info->iv_pool,
+				      GFP_ATOMIC, &sec_req->dma_iv);
+	if (!sec_req->iv)
+		return -ENOMEM;
+
+	memcpy(sec_req->iv, skreq->iv, crypto_skcipher_ivsize(atfm));
+	sec_req->len_in = sg_nents(sgl);
+	inbufs = sec_setup_sec_sgl(&pinbufs, sgl, sec_req->len_in,
+				   queue->dev_info);
+	if (IS_ERR(inbufs)) {
+		dev_err(dev, "Setup of sgl for input failed\n");
+		ret = PTR_ERR(inbufs);
+		goto err_free_iv;
+	}
+
+	sec_req->in = inbufs;
+	sec_req->dma_in = pinbufs;
+	if (sgl != sglout) {
+		sec_req->len_out = sg_nents(sglout);
+		outbufs = sec_setup_sec_sgl(&poutbufs, sglout, sec_req->len_out,
+					    queue->dev_info);
+		if (IS_ERR(outbufs)) {
+			dev_err(dev, "Setup of sgl for output failed\n");
+			ret = PTR_ERR(outbufs);
+			goto err_free_in_sgl;
+		}
+		sec_req->out = outbufs;
+		sec_req->dma_out = poutbufs;
+		sec_req->req.w0 |= SEC_BD_W0_DE;
+	} else {
+		sec_req->out = NULL;
+		sec_req->dma_out = 0;
+		sec_req->req.w0 &= ~SEC_BD_W0_DE;
+	}
+
+	return 0;
+
+err_free_in_sgl:
+	sec_destroy_sec_sgl(sgl, sec_req->len_in, sec_req->in,
+			    sec_req->dma_in, queue->dev_info);
+err_free_iv:
+	dma_pool_free(queue->dev_info->iv_pool, sec_req->iv, sec_req->dma_iv);
+
+	return ret;
+}
+
+static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
+				   const u8 *key, unsigned int keylen,
+				   enum sec_cipher_alg alg)
+{
+	struct sec_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct device *dev;
+
+	spin_lock(&ctx->lock);
+	if (ctx->enc_key) {
+		/* rekeying */
+		dev = SEC_Q_DEV(ctx->queue);
+		memset(ctx->enc_key, 0, SEC_MAX_CIPHER_KEY);
+		memset(ctx->dec_key, 0, SEC_MAX_CIPHER_KEY);
+		memset(&ctx->enc_req, 0, sizeof(ctx->enc_req));
+		memset(&ctx->dec_req, 0, sizeof(ctx->dec_req));
+	} else {
+		/* new key */
+		dev = SEC_Q_DEV(ctx->queue);
+		ctx->enc_key = dma_zalloc_coherent(dev, SEC_MAX_CIPHER_KEY,
+						   &ctx->enc_pkey, GFP_ATOMIC);
+		if (!ctx->enc_key) {
+			spin_unlock(&ctx->lock);
+			return -ENOMEM;
+		}
+		ctx->dec_key = dma_zalloc_coherent(dev, SEC_MAX_CIPHER_KEY,
+						   &ctx->dec_pkey, GFP_ATOMIC);
+		if (!ctx->dec_key) {
+			spin_unlock(&ctx->lock);
+			goto out_free_enc;
+		}
+	}
+	spin_unlock(&ctx->lock);
+	if (sec_alg_skcipher_init_context(tfm, key, keylen, alg))
+		goto out_free_all;
+
+	return 0;
+
+out_free_all:
+	memset(ctx->dec_key, 0, SEC_MAX_CIPHER_KEY);
+	dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
+			  ctx->dec_key, ctx->dec_pkey);
+	ctx->dec_key = NULL;
+out_free_enc:
+	memset(ctx->enc_key, 0, SEC_MAX_CIPHER_KEY);
+	dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
+			  ctx->enc_key, ctx->enc_pkey);
+	ctx->enc_key = NULL;
+
+	return -ENOMEM;
+}
+
+static int sec_alg_skcipher_setkey_aes_ecb(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	enum sec_cipher_alg alg;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		alg = SEC_AES_ECB_128;
+		break;
+	case AES_KEYSIZE_192:
+		alg = SEC_AES_ECB_192;
+		break;
+	case AES_KEYSIZE_256:
+		alg = SEC_AES_ECB_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
+}
+
+static int sec_alg_skcipher_setkey_aes_cbc(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	enum sec_cipher_alg alg;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		alg = SEC_AES_CBC_128;
+		break;
+	case AES_KEYSIZE_192:
+		alg = SEC_AES_CBC_192;
+		break;
+	case AES_KEYSIZE_256:
+		alg = SEC_AES_CBC_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
+}
+
+static int sec_alg_skcipher_setkey_aes_ctr(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	enum sec_cipher_alg alg;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		alg = SEC_AES_CTR_128;
+		break;
+	case AES_KEYSIZE_192:
+		alg = SEC_AES_CTR_192;
+		break;
+	case AES_KEYSIZE_256:
+		alg = SEC_AES_CTR_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
+}
+
+static int sec_alg_skcipher_setkey_aes_xts(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	enum sec_cipher_alg alg;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128 * 2:
+		alg = SEC_AES_XTS_128;
+		break;
+	case AES_KEYSIZE_256 * 2:
+		alg = SEC_AES_XTS_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
+}
+
+static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	if (keylen != DES_KEY_SIZE)
+		return -EINVAL;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_DES_ECB_64);
+}
+
+static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	if (keylen != DES_KEY_SIZE)
+		return -EINVAL;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_DES_CBC_64);
+}
+
+static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
+					    const u8 *key, unsigned int keylen)
+{
+	if (keylen != DES_KEY_SIZE * 3)
+		return -EINVAL;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_3DES_ECB_192_3KEY);
+}
+
+static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
+					    const u8 *key, unsigned int keylen)
+{
+	if (keylen != DES3_EDE_KEY_SIZE)
+		return -EINVAL;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_3DES_CBC_192_3KEY);
+}
+
+static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
+				      struct skcipher_request *skreq)
+{
+	struct sec_crypto_request *sec_req = skcipher_request_ctx(skreq);
+	struct sec_alg_skcipher_ctx *ctx = sec_req->skcipher_ctx;
+	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
+	struct crypto_async_request *nextrequest;
+	struct sec_crypto_request *nextsec_req;
+	struct skcipher_request *nextskreq;
+	int icv_or_skey_en;
+	int err = 0;
+
+	icv_or_skey_en = (sec_resp->w0 & SEC_BD_W0_ICV_OR_SKEY_EN_M) >>
+		SEC_BD_W0_ICV_OR_SKEY_EN_S;
+	if (sec_resp->w1 & SEC_BD_W1_BD_INVALID || icv_or_skey_en == 3) {
+		dev_err(ctx->queue->dev_info->dev,
+			"Got an invalid answer %lu %d\n",
+			sec_resp->w1 & SEC_BD_W1_BD_INVALID,
+			icv_or_skey_en);
+		err = -EINVAL;
+		/*
+		 * We need to muddle on to avoid getting stuck with elements
+		 * on the queue. Error will be reported so userspace should
+		 * know a mess has occurred.
+		 */
+	}
+
+	spin_lock(&ctx->queue->queuelock);
+	sec_free_opdata(ctx->queue, skreq->src, skreq->dst, skreq);
+	/* Put the IV in place for chained cases */
+	switch (ctx->cipher_alg) {
+	case SEC_AES_CBC_128:
+	case SEC_AES_CBC_192:
+	case SEC_AES_CBC_256:
+		if (sec_req->req.w0 & SEC_BD_W0_DE)
+			sg_pcopy_to_buffer(skreq->dst, sec_req->len_out,
+					   skreq->iv,
+					   crypto_skcipher_ivsize(atfm),
+					   skreq->cryptlen -
+					   crypto_skcipher_ivsize(atfm));
+		else
+			sg_pcopy_to_buffer(skreq->src, sec_req->len_in,
+					   skreq->iv,
+					   crypto_skcipher_ivsize(atfm),
+					   skreq->cryptlen - 16);
+		break;
+	case SEC_AES_CTR_128:
+	case SEC_AES_CTR_192:
+	case SEC_AES_CTR_256:
+		crypto_inc(skreq->iv, 16);
+		break;
+	default:
+		/* Do not update */
+		break;
+	}
+
+	if (ctx->queue->havesoftqueue &&
+	    !list_empty(&ctx->queue->softqueue.list) &&
+	    sec_queue_empty(ctx->queue)) {
+		nextrequest = crypto_dequeue_request(&ctx->queue->softqueue);
+		nextskreq = container_of(nextrequest, struct skcipher_request,
+					 base);
+		nextsec_req = skcipher_request_ctx(nextskreq);
+		/* We know there is space so this cannot fail */
+		sec_queue_send(ctx->queue, &nextsec_req->req, nextskreq);
+	}
+	spin_unlock(&ctx->queue->queuelock);
+
+	skreq->base.complete(&skreq->base, err);
+}
+
+void sec_alg_callback(struct sec_bd_info *resp, void *shadow)
+{
+	struct skcipher_request *skreq = shadow;
+	struct sec_crypto_request *sec_req = skcipher_request_ctx(skreq);
+
+	if (sec_req)
+		sec_req->cb(resp, skreq);
+}
+
+static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
+				   int direction)
+{
+	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(atfm);
+	struct sec_alg_skcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sec_crypto_request *sec_req = skcipher_request_ctx(skreq);
+	struct sec_bd_info *req = &sec_req->req;
+	int ret;
+
+	/*
+	 * The hardware engine can only cope with up to 32MB.
+	 * For now return an error if larger requests are made.
+	 */
+	if (skreq->cryptlen > SZ_32M)
+		return -EINVAL;
+
+	if (direction)
+		memcpy(req, &ctx->enc_req, sizeof(*req));
+	else
+		memcpy(req, &ctx->dec_req, sizeof(*req));
+
+	sec_req->skcipher_ctx = ctx;
+	sec_req->cb = sec_skcipher_alg_callback;
+
+	req->w0 &= ~SEC_BD_W0_GRAN_SIZE_MID_M;
+	req->w0 |= ((skreq->cryptlen >> 16) << SEC_BD_W0_GRAN_SIZE_MID_S) &
+		SEC_BD_W0_GRAN_SIZE_MID_M;
+
+	req->w0 &= ~SEC_BD_W0_F_OR_C_GRAN_SIZE_H_M;
+	req->w0 |= ((skreq->cryptlen >> 20) << SEC_BD_W0_F_OR_C_GRAN_SIZE_H_S) &
+		SEC_BD_W0_F_OR_C_GRAN_SIZE_H_M;
+
+	/* Writing whole u32 so no need to take care of masking */
+	req->w2 = ((1 << SEC_BD_W2_GRAN_NUM_S) & SEC_BD_W2_GRAN_NUM_M) |
+		((skreq->cryptlen << SEC_BD_W2_GRAN_SIZE_LOW_S) &
+		 SEC_BD_W2_GRAN_SIZE_LOW_M);
+
+	req->w3 &= ~SEC_BD_W3_CIPHER_LEN_OFFSET_M;
+	req->w1 |= SEC_BD_W1_ADDR_TYPE;
+
+	/*
+	 * What do we do if the incoming request is too large?
+	 * Split it but how. Is this a job for the hardware or higher layers?
+	 */
+
+	ret = sec_create_opdata(ctx->queue, skreq->src, skreq->dst, skreq);
+	if (ret)
+		return ret;
+
+	req->data_addr_lo = lower_32_bits(sec_req->dma_in);
+	req->data_addr_hi = upper_32_bits(sec_req->dma_in);
+	if (req->w0 & SEC_BD_W0_DE) {
+		req->cipher_destin_addr_lo = lower_32_bits(sec_req->dma_out);
+		req->cipher_destin_addr_hi = upper_32_bits(sec_req->dma_out);
+	} else {
+		req->cipher_destin_addr_lo = lower_32_bits(sec_req->dma_in);
+		req->cipher_destin_addr_hi = upper_32_bits(sec_req->dma_in);
+	}
+
+	req->cipher_iv_addr_lo = lower_32_bits(sec_req->dma_iv);
+	req->cipher_iv_addr_hi = upper_32_bits(sec_req->dma_iv);
+
+	spin_lock(&ctx->queue->queuelock);
+
+	/*
+	 * Add to hardware queue only under following circumstances
+	 * 1) Software and hardware queue empty so no chain dependencies
+	 * 2) No dependencies as new IV - (check software queue empty
+	 *    to maintain order)
+	 * 3) No dependencies because the mode does no chaining.
+	 *
+	 * In other cases first insert onto the software queue which is then
+	 * emptied as requests complete
+	 */
+	if (!ctx->queue->havesoftqueue ||
+	    (list_empty(&ctx->queue->softqueue.list) &&
+	     (sec_queue_empty(ctx->queue) ||
+	      ctx->prev_iv_address != skreq->iv))) {
+		ctx->prev_iv_address = skreq->iv;
+		ret = sec_queue_send(ctx->queue, req, skreq);
+	} else {
+		ctx->prev_iv_address = skreq->iv;
+		crypto_enqueue_request(&ctx->queue->softqueue, &skreq->base);
+		ret = 0;
+	}
+	spin_unlock(&ctx->queue->queuelock);
+	if (ret == -EAGAIN) {
+		/* Queue currently full so let caller know that */
+		sec_free_opdata(ctx->queue, skreq->src, skreq->dst, skreq);
+		return -EBUSY;
+	}
+	return -EINPROGRESS;
+}
+
+static int sec_alg_skcipher_encrypt(struct skcipher_request *req)
+{
+	return sec_alg_skcipher_crypto(req, 1);
+}
+
+static int sec_alg_skcipher_decrypt(struct skcipher_request *req)
+{
+	return sec_alg_skcipher_crypto(req, 0);
+}
+
+static int sec_alg_skcipher_init(struct crypto_skcipher *tfm)
+{
+	struct sec_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	spin_lock_init(&ctx->lock);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_crypto_request));
+
+	ctx->queue = sec_queue_alloc_start_safe();
+	if (!ctx->queue)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int sec_alg_skcipher_init_with_queue(struct crypto_skcipher *tfm)
+{
+	struct sec_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
+
+	ret = sec_alg_skcipher_init(tfm);
+	if (ret)
+		return ret;
+
+	crypto_init_queue(&ctx->queue->softqueue, 512);
+	spin_lock_init(&ctx->queue->queuelock);
+	ctx->queue->havesoftqueue = true;
+
+	return 0;
+}
+
+static void sec_alg_skcipher_exit(struct crypto_skcipher *tfm)
+{
+	struct sec_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct device *dev = SEC_Q_DEV(ctx->queue);
+
+	if (ctx->enc_key) {
+		memset(ctx->enc_key, 0, SEC_MAX_CIPHER_KEY);
+		dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
+				  ctx->enc_key, ctx->enc_pkey);
+	}
+	if (ctx->dec_key) {
+		memset(ctx->dec_key, 0, SEC_MAX_CIPHER_KEY);
+		dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
+				  ctx->dec_key, ctx->dec_pkey);
+	}
+	sec_queue_stop_release(ctx->queue);
+}
+
+static struct skcipher_alg sec_algs[] = {
+	{
+		.base = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "hisi_sec_aes_ecb",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_aes_ecb,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "hisi_sec_aes_cbc",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init_with_queue,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_aes_cbc,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "ctr(aes)",
+			.cra_driver_name = "hisi_sec_aes_ctr",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init_with_queue,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_aes_ctr,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "xts(aes)",
+			.cra_driver_name = "hisi_sec_aes_xts",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_aes_xts,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = 2 * AES_MIN_KEY_SIZE,
+		.max_keysize = 2 * AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+	}, {
+	/* Unable to find any test vectors so untested */
+		.base = {
+			.cra_name = "ecb(des)",
+			.cra_driver_name = "hisi_sec_des_ecb",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_des_ecb,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = DES_KEY_SIZE,
+		.max_keysize = DES_KEY_SIZE,
+		.ivsize = DES_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "cbc(des)",
+			.cra_driver_name = "hisi_sec_des_cbc",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init_with_queue,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_des_cbc,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = DES_KEY_SIZE,
+		.max_keysize = DES_KEY_SIZE,
+		.ivsize = DES_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "hisi_sec_3des_cbc",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init_with_queue,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_3des_cbc,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = DES3_EDE_KEY_SIZE,
+		.max_keysize = DES3_EDE_KEY_SIZE,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+	}, {
+		.base = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "hisi_sec_3des_ecb",
+			.cra_priority = 4001,
+			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sec_alg_skcipher_ctx),
+			.cra_alignmask = 0,
+			.cra_module = THIS_MODULE,
+		},
+		.init = sec_alg_skcipher_init,
+		.exit = sec_alg_skcipher_exit,
+		.setkey = sec_alg_skcipher_setkey_3des_ecb,
+		.decrypt = sec_alg_skcipher_decrypt,
+		.encrypt = sec_alg_skcipher_encrypt,
+		.min_keysize = DES3_EDE_KEY_SIZE,
+		.max_keysize = DES3_EDE_KEY_SIZE,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+	}
+};
+
+int sec_algs_register(void)
+{
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (++active_devs != 1)
+		goto unlock;
+
+	ret = crypto_register_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
+	if (ret)
+		--active_devs;
+
+unlock:
+	mutex_unlock(&algs_lock);
+
+	return ret;
+}
+
+void sec_algs_unregister(void)
+{
+	mutex_lock(&algs_lock);
+	if (--active_devs != 0)
+		goto unlock;
+
+	crypto_unregister_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
+
+unlock:
+	mutex_unlock(&algs_lock);
+}
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
new file mode 100644
index 000000000000..58b4e5b93cbb
--- /dev/null
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -0,0 +1,1418 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver for the Hisilicon SEC units found on Hip06 Hip07
+ *
+ * Copyright (c) 2016-2017 Hisilicon Limited.
+ */
+#include <linux/acpi.h>
+#include <linux/atomic.h>
+#include <linux/delay.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "sec_drv.h"
+
+#define SEC_DEV_NAME			"hisi_sec"
+
+#define SEC_QUEUE_AR_FROCE_ALLOC			0
+#define SEC_QUEUE_AR_FROCE_NOALLOC			1
+#define SEC_QUEUE_AR_FROCE_DIS				2
+
+#define SEC_QUEUE_AW_FROCE_ALLOC			0
+#define SEC_QUEUE_AW_FROCE_NOALLOC			1
+#define SEC_QUEUE_AW_FROCE_DIS				2
+
+/* SEC_ALGSUB registers */
+#define SEC_ALGSUB_CLK_EN_REG				0x03b8
+#define SEC_ALGSUB_CLK_DIS_REG				0x03bc
+#define SEC_ALGSUB_CLK_ST_REG				0x535c
+#define SEC_ALGSUB_RST_REQ_REG				0x0aa8
+#define SEC_ALGSUB_RST_DREQ_REG				0x0aac
+#define SEC_ALGSUB_RST_ST_REG				0x5a54
+#define   SEC_ALGSUB_RST_ST_IS_RST			BIT(0)
+
+#define SEC_ALGSUB_BUILD_RST_REQ_REG			0x0ab8
+#define SEC_ALGSUB_BUILD_RST_DREQ_REG			0x0abc
+#define SEC_ALGSUB_BUILD_RST_ST_REG			0x5a5c
+#define   SEC_ALGSUB_BUILD_RST_ST_IS_RST		BIT(0)
+
+#define SEC_SAA_BASE					0x00001000UL
+
+/* SEC_SAA registers */
+#define SEC_SAA_CTRL_REG(x)	((x) * SEC_SAA_ADDR_SIZE + 0x0000)
+#define   SEC_SAA_CTRL_GET_QM_EN			BIT(0)
+
+#define SEC_ST_INTMSK1_REG				0x0200
+#define SEC_ST_RINT1_REG				0x0400
+#define SEC_ST_INTSTS1_REG				0x0600
+#define SEC_BD_MNG_STAT_REG				0x0800
+#define SEC_PARSING_STAT_REG				0x0804
+#define SEC_LOAD_TIME_OUT_CNT_REG			0x0808
+#define SEC_CORE_WORK_TIME_OUT_CNT_REG			0x080C
+#define SEC_BACK_TIME_OUT_CNT_REG			0x0810
+#define SEC_BD1_PARSING_RD_TIME_OUT_CNT_REG		0x0814
+#define SEC_BD1_PARSING_WR_TIME_OUT_CNT_REG		0x0818
+#define SEC_BD2_PARSING_RD_TIME_OUT_CNT_REG		0x081C
+#define SEC_BD2_PARSING_WR_TIME_OUT_CNT_REG		0x0820
+#define SEC_SAA_ACC_REG					0x083C
+#define SEC_BD_NUM_CNT_IN_SEC_REG			0x0858
+#define SEC_LOAD_WORK_TIME_CNT_REG			0x0860
+#define SEC_CORE_WORK_WORK_TIME_CNT_REG			0x0864
+#define SEC_BACK_WORK_TIME_CNT_REG			0x0868
+#define SEC_SAA_IDLE_TIME_CNT_REG			0x086C
+#define SEC_SAA_CLK_CNT_REG				0x0870
+
+/* SEC_COMMON registers */
+#define SEC_CLK_EN_REG					0x0000
+#define SEC_CTRL_REG					0x0004
+
+#define SEC_COMMON_CNT_CLR_CE_REG			0x0008
+#define   SEC_COMMON_CNT_CLR_CE_CLEAR			BIT(0)
+#define   SEC_COMMON_CNT_CLR_CE_SNAP_EN			BIT(1)
+
+#define SEC_SECURE_CTRL_REG				0x000C
+#define SEC_AXI_CACHE_CFG_REG				0x0010
+#define SEC_AXI_QOS_CFG_REG				0x0014
+#define SEC_IPV4_MASK_TABLE_REG				0x0020
+#define SEC_IPV6_MASK_TABLE_X_REG(x)	(0x0024 + (x) * sizeof(u32))
+#define SEC_FSM_MAX_CNT_REG				0x0064
+
+#define SEC_CTRL2_REG					0x0068
+#define   SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M		GENMASK(3, 0)
+#define   SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_S		0
+#define   SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M		GENMASK(6, 4)
+#define   SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_S		4
+#define   SEC_CTRL2_CLK_GATE_EN				BIT(7)
+#define   SEC_CTRL2_ENDIAN_BD				BIT(8)
+#define   SEC_CTRL2_ENDIAN_BD_TYPE			BIT(9)
+
+#define SEC_CNT_PRECISION_CFG_REG			0x006C
+#define SEC_DEBUG_BD_CFG_REG				0x0070
+#define   SEC_DEBUG_BD_CFG_WB_NORMAL			BIT(0)
+#define   SEC_DEBUG_BD_CFG_WB_EN			BIT(1)
+
+#define SEC_Q_SIGHT_SEL					0x0074
+#define SEC_Q_SIGHT_HIS_CLR				0x0078
+#define SEC_Q_VMID_CFG_REG(q)		(0x0100 + (q) * sizeof(u32))
+#define SEC_Q_WEIGHT_CFG_REG(q)		(0x200 + (q) * sizeof(u32))
+#define SEC_STAT_CLR_REG				0x0A00
+#define SEC_SAA_IDLE_CNT_CLR_REG			0x0A04
+#define SEC_QM_CPL_Q_IDBUF_DFX_CFG_REG			0x0B00
+#define SEC_QM_CPL_Q_IDBUF_DFX_RESULT_REG		0x0B04
+#define SEC_QM_BD_DFX_CFG_REG				0x0B08
+#define SEC_QM_BD_DFX_RESULT_REG			0x0B0C
+#define SEC_QM_BDID_DFX_RESULT_REG			0x0B10
+#define SEC_QM_BD_DFIFO_STATUS_REG			0x0B14
+#define SEC_QM_BD_DFX_CFG2_REG				0x0B1C
+#define SEC_QM_BD_DFX_RESULT2_REG			0x0B20
+#define SEC_QM_BD_IDFIFO_STATUS_REG			0x0B18
+#define SEC_QM_BD_DFIFO_STATUS2_REG			0x0B28
+#define SEC_QM_BD_IDFIFO_STATUS2_REG			0x0B2c
+
+#define SEC_HASH_IPV4_MASK				0xfff00000
+#define SEC_MAX_SAA_NUM					0xa
+#define SEC_SAA_ADDR_SIZE				0x1000
+
+#define SEC_Q_INIT_REG					0x0
+
+#define SEC_Q_CFG_REG					0x8
+#define   SEC_Q_CFG_REORDER				BIT(0)
+
+#define SEC_Q_PROC_NUM_CFG_REG				0x10
+#define SEC_QUEUE_ENB_REG				0x18
+
+#define SEC_Q_DEPTH_CFG_REG				0x50
+#define   SEC_Q_DEPTH_CFG_DEPTH_M			GENMASK(11, 0)
+#define   SEC_Q_DEPTH_CFG_DEPTH_S			0
+
+#define SEC_Q_BASE_HADDR_REG				0x54
+#define SEC_Q_BASE_LADDR_REG				0x58
+#define SEC_Q_WR_PTR_REG				0x5C
+#define SEC_Q_OUTORDER_BASE_HADDR_REG			0x60
+#define SEC_Q_OUTORDER_BASE_LADDR_REG			0x64
+#define SEC_Q_OUTORDER_RD_PTR_REG			0x68
+#define SEC_Q_OT_TH_REG					0x6C
+
+#define SEC_Q_ARUSER_CFG_REG				0x70
+#define   SEC_Q_ARUSER_CFG_FA				BIT(0)
+#define   SEC_Q_ARUSER_CFG_FNA				BIT(1)
+#define   SEC_Q_ARUSER_CFG_RINVLD			BIT(2)
+#define   SEC_Q_ARUSER_CFG_PKG				BIT(3)
+
+#define SEC_Q_AWUSER_CFG_REG				0x74
+#define   SEC_Q_AWUSER_CFG_FA				BIT(0)
+#define   SEC_Q_AWUSER_CFG_FNA				BIT(1)
+#define   SEC_Q_AWUSER_CFG_PKG				BIT(2)
+
+#define SEC_Q_ERR_BASE_HADDR_REG			0x7C
+#define SEC_Q_ERR_BASE_LADDR_REG			0x80
+#define SEC_Q_CFG_VF_NUM_REG				0x84
+#define SEC_Q_SOFT_PROC_PTR_REG				0x88
+#define SEC_Q_FAIL_INT_MSK_REG				0x300
+#define SEC_Q_FLOW_INT_MKS_REG				0x304
+#define SEC_Q_FAIL_RINT_REG				0x400
+#define SEC_Q_FLOW_RINT_REG				0x404
+#define SEC_Q_FAIL_INT_STATUS_REG			0x500
+#define SEC_Q_FLOW_INT_STATUS_REG			0x504
+#define SEC_Q_STATUS_REG				0x600
+#define SEC_Q_RD_PTR_REG				0x604
+#define SEC_Q_PRO_PTR_REG				0x608
+#define SEC_Q_OUTORDER_WR_PTR_REG			0x60C
+#define SEC_Q_OT_CNT_STATUS_REG				0x610
+#define SEC_Q_INORDER_BD_NUM_ST_REG			0x650
+#define SEC_Q_INORDER_GET_FLAG_ST_REG			0x654
+#define SEC_Q_INORDER_ADD_FLAG_ST_REG			0x658
+#define SEC_Q_INORDER_TASK_INT_NUM_LEFT_ST_REG		0x65C
+#define SEC_Q_RD_DONE_PTR_REG				0x660
+#define SEC_Q_CPL_Q_BD_NUM_ST_REG			0x700
+#define SEC_Q_CPL_Q_PTR_ST_REG				0x704
+#define SEC_Q_CPL_Q_H_ADDR_ST_REG			0x708
+#define SEC_Q_CPL_Q_L_ADDR_ST_REG			0x70C
+#define SEC_Q_CPL_TASK_INT_NUM_LEFT_ST_REG		0x710
+#define SEC_Q_WRR_ID_CHECK_REG				0x714
+#define SEC_Q_CPLQ_FULL_CHECK_REG			0x718
+#define SEC_Q_SUCCESS_BD_CNT_REG			0x800
+#define SEC_Q_FAIL_BD_CNT_REG				0x804
+#define SEC_Q_GET_BD_CNT_REG				0x808
+#define SEC_Q_IVLD_CNT_REG				0x80C
+#define SEC_Q_BD_PROC_GET_CNT_REG			0x810
+#define SEC_Q_BD_PROC_DONE_CNT_REG			0x814
+#define SEC_Q_LAT_CLR_REG				0x850
+#define SEC_Q_PKT_LAT_MAX_REG				0x854
+#define SEC_Q_PKT_LAT_AVG_REG				0x858
+#define SEC_Q_PKT_LAT_MIN_REG				0x85C
+#define SEC_Q_ID_CLR_CFG_REG				0x900
+#define SEC_Q_1ST_BD_ERR_ID_REG				0x904
+#define SEC_Q_1ST_AUTH_FAIL_ID_REG			0x908
+#define SEC_Q_1ST_RD_ERR_ID_REG				0x90C
+#define SEC_Q_1ST_ECC2_ERR_ID_REG			0x910
+#define SEC_Q_1ST_IVLD_ID_REG				0x914
+#define SEC_Q_1ST_BD_WR_ERR_ID_REG			0x918
+#define SEC_Q_1ST_ERR_BD_WR_ERR_ID_REG			0x91C
+#define SEC_Q_1ST_BD_MAC_WR_ERR_ID_REG			0x920
+
+struct sec_debug_bd_info {
+#define SEC_DEBUG_BD_INFO_SOFT_ERR_CHECK_M	GENMASK(22, 0)
+	u32 soft_err_check;
+#define SEC_DEBUG_BD_INFO_HARD_ERR_CHECK_M	GENMASK(9, 0)
+	u32 hard_err_check;
+	u32 icv_mac1st_word;
+#define SEC_DEBUG_BD_INFO_GET_ID_M		GENMASK(19, 0)
+	u32 sec_get_id;
+	/* W4---W15 */
+	u32 reserv_left[12];
+};
+
+struct sec_out_bd_info	{
+#define SEC_OUT_BD_INFO_Q_ID_M			GENMASK(11, 0)
+#define SEC_OUT_BD_INFO_ECC_2BIT_ERR		BIT(14)
+	u16 data;
+};
+
+#define SEC_MAX_DEVICES				8
+static struct sec_dev_info *sec_devices[SEC_MAX_DEVICES];
+static struct mutex sec_id_lock;
+
+static int sec_queue_map_io(struct sec_queue *queue)
+{
+	struct device *dev = SEC_Q_DEV(queue);
+	struct resource *res;
+
+	res = platform_get_resource(to_platform_device(dev),
+				    IORESOURCE_MEM,
+				    2 + queue->queue_id);
+	if (!res) {
+		dev_err(dev, "Failed to get queue %d memory resource\n",
+			queue->queue_id);
+		return -ENOMEM;
+	}
+	queue->regs = ioremap(res->start, resource_size(res));
+	if (!queue->regs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void sec_queue_unmap_io(struct sec_queue *queue)
+{
+	 iounmap(queue->regs);
+}
+
+static int sec_queue_ar_pkgattr(struct sec_queue *queue, u32 ar_pkg)
+{
+	void __iomem *addr = queue->regs +  SEC_Q_ARUSER_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (ar_pkg)
+		regval |= SEC_Q_ARUSER_CFG_PKG;
+	else
+		regval &= ~SEC_Q_ARUSER_CFG_PKG;
+	writel_relaxed(regval, addr);
+
+	return 0;
+}
+
+static int sec_queue_aw_pkgattr(struct sec_queue *queue, u32 aw_pkg)
+{
+	void __iomem *addr = queue->regs + SEC_Q_AWUSER_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	regval |= SEC_Q_AWUSER_CFG_PKG;
+	writel_relaxed(regval, addr);
+
+	return 0;
+}
+
+static int sec_clk_en(struct sec_dev_info *info)
+{
+	void __iomem *base = info->regs[0];
+	u32 i = 0;
+
+	while (i < 10) {
+		writel_relaxed(0x7, base + SEC_ALGSUB_CLK_EN_REG);
+		mdelay(1);
+		if ((readl_relaxed(base + SEC_ALGSUB_CLK_ST_REG) & 0x7) == 0x7)
+			return 0;
+		i++;
+	}
+	dev_err(info->dev, "sec clock enable fail!\n");
+
+	return -EIO;
+}
+
+static int sec_clk_dis(struct sec_dev_info *info)
+{
+	void __iomem *base = info->regs[0];
+	u32 i = 0;
+
+	while (i < 10) {
+		writel_relaxed(0x7, base + SEC_ALGSUB_CLK_DIS_REG);
+		mdelay(1);
+		if ((readl_relaxed(base + SEC_ALGSUB_CLK_ST_REG) & 0x7) == 0)
+			return 0;
+		i++;
+	}
+	dev_err(info->dev, "sec clock disable fail!\n");
+
+	return -EIO;
+}
+
+static int sec_reset_whole_module(struct sec_dev_info *info)
+{
+	u32 i = 0;
+	void __iomem *base = info->regs[0];
+
+	while (1) {
+		writel_relaxed(1, base + SEC_ALGSUB_RST_REQ_REG);
+		writel_relaxed(1, base + SEC_ALGSUB_BUILD_RST_REQ_REG);
+		mdelay(1);
+		if ((readl_relaxed(base + SEC_ALGSUB_RST_ST_REG) &
+		     SEC_ALGSUB_RST_ST_IS_RST) &&
+		    (readl_relaxed(base + SEC_ALGSUB_BUILD_RST_ST_REG) &
+		     SEC_ALGSUB_BUILD_RST_ST_IS_RST))
+			break;
+		i++;
+		if (i > 10) {
+			dev_err(info->dev, "Reset req failed\n");
+			return -EIO;
+		}
+	}
+
+	i = 0;
+	while (1) {
+		writel_relaxed(1, base + SEC_ALGSUB_RST_DREQ_REG);
+		writel_relaxed(1, base + SEC_ALGSUB_BUILD_RST_DREQ_REG);
+		mdelay(1);
+		if (!(readl_relaxed(base + SEC_ALGSUB_RST_ST_REG) &
+		     SEC_ALGSUB_RST_ST_IS_RST) &&
+		    !(readl_relaxed(base + SEC_ALGSUB_BUILD_RST_ST_REG) &
+		      SEC_ALGSUB_BUILD_RST_ST_IS_RST))
+			break;
+
+		i++;
+		if (i > 10) {
+			dev_err(info->dev, "Reset dreq failed\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static void sec_saa_clk_en(struct sec_dev_info *info, u32 saa_mask)
+{
+	u32 saa_clk_en;
+
+	saa_clk_en = readl_relaxed(info->regs[1] + SEC_CLK_EN_REG);
+	saa_clk_en |= saa_mask;
+	writel_relaxed(saa_clk_en, info->regs[1] + SEC_CLK_EN_REG);
+}
+
+static void  sec_bd_endian(struct sec_dev_info *info, u32 endian)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL2_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (endian)
+		regval |= SEC_CTRL2_ENDIAN_BD;
+	else
+		regval &= ~SEC_CTRL2_ENDIAN_BD;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_bd_endian_type(struct sec_dev_info *info, u32 endian_type)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL2_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (endian_type)
+		regval |= SEC_CTRL2_ENDIAN_BD_TYPE;
+	else
+		regval &= ~SEC_CTRL2_ENDIAN_BD_TYPE;
+	writel_relaxed(regval, addr);
+}
+
+/*
+ * sec_cache_config - configure optimum cache placement
+ */
+static void sec_cache_config(struct sec_dev_info *info)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL_REG;
+
+	/* Ideally would identify if the iommu is being enabled as well */
+	if (info->dev->iommu_group)
+		writel_relaxed(0x44cf9e, addr);
+	else
+		writel_relaxed(0x4cfd9, addr);
+}
+
+static void sec_data_axiwr_otsd_cfg(struct sec_dev_info *info, u32 cfg)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL2_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	regval &= ~SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M;
+	regval |= (cfg << SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_S) &
+		SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_data_axird_otsd_cfg(struct sec_dev_info *info, u32 cfg)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL2_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	regval &= ~SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M;
+	regval |= (cfg << SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_S) &
+		SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_clk_gate_en(struct sec_dev_info *info, u32 clkgate)
+{
+	void __iomem *addr = info->regs[1] + SEC_CTRL2_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (clkgate)
+		regval |= SEC_CTRL2_CLK_GATE_EN;
+	else
+		regval &= ~SEC_CTRL2_CLK_GATE_EN;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_comm_cnt_cfg(struct sec_dev_info *info, u32 clr_ce)
+{
+	void __iomem *addr = info->regs[1] + SEC_COMMON_CNT_CLR_CE_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (clr_ce)
+		regval |= SEC_COMMON_CNT_CLR_CE_CLEAR;
+	else
+		regval &= ~SEC_COMMON_CNT_CLR_CE_CLEAR;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_commsnap_en(struct sec_dev_info *info, u32 snap_en)
+{
+	void __iomem *addr = info->regs[1] + SEC_COMMON_CNT_CLR_CE_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (snap_en)
+		regval |= SEC_COMMON_CNT_CLR_CE_SNAP_EN;
+	else
+		regval &= ~SEC_COMMON_CNT_CLR_CE_SNAP_EN;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_fsm_maxcnt(struct sec_dev_info *info, u32 cnt)
+{
+	writel_relaxed(cnt, info->regs[1] + SEC_FSM_MAX_CNT_REG);
+}
+
+static void sec_ipv6_hashmask(struct sec_dev_info *info, u32 hash_mask[])
+{
+	void __iomem *base = info->regs[1];
+	int i;
+
+	for (i = 0; i < 10; i++)
+		writel_relaxed(hash_mask[0],
+			       base + SEC_IPV6_MASK_TABLE_X_REG(i));
+}
+
+static int sec_ipv4_hashmask(struct sec_dev_info *info, u32 hash_mask)
+{
+	if (hash_mask & SEC_HASH_IPV4_MASK) {
+		dev_err(info->dev, "Sec Ipv4 Hash Mask Input Error!\n ");
+		return -EINVAL;
+	}
+
+	writel_relaxed(hash_mask, info->regs[1] + SEC_IPV4_MASK_TABLE_REG);
+
+	return 0;
+}
+
+static void sec_set_dbg_bd_cfg(struct sec_dev_info *info, u32 cfg)
+{
+	void __iomem *addr = info->regs[1] + SEC_DEBUG_BD_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	/* Always disable write back of normal bd */
+	regval &= ~SEC_DEBUG_BD_CFG_WB_NORMAL;
+
+	if (cfg)
+		regval &= ~SEC_DEBUG_BD_CFG_WB_EN;
+	else
+		regval |= SEC_DEBUG_BD_CFG_WB_EN;
+
+	writel_relaxed(regval, addr);
+}
+
+static void sec_saa_getqm_en(struct sec_dev_info *info, u32 saa_indx,
+				  u32 en)
+{
+	void __iomem *addr = info->regs[1] + SEC_SAA_BASE +
+		SEC_SAA_CTRL_REG(saa_indx);
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (en)
+		regval |= SEC_SAA_CTRL_GET_QM_EN;
+	else
+		regval &= ~SEC_SAA_CTRL_GET_QM_EN;
+	writel_relaxed(regval, addr);
+}
+
+static void sec_saa_int_mask(struct sec_dev_info *info, u32 saa_indx,
+				  u32 saa_int_mask)
+{
+	writel_relaxed(saa_int_mask,
+		       info->regs[1] + SEC_SAA_BASE + SEC_ST_INTMSK1_REG +
+		       saa_indx * SEC_SAA_ADDR_SIZE);
+}
+
+static void sec_streamid(struct sec_dev_info *info, int i)
+{
+	#define SEC_SID 0x600
+	#define SEC_VMID 0
+
+	writel_relaxed((SEC_VMID | ((SEC_SID & 0xffff) << 8)),
+		       info->regs[1] + SEC_Q_VMID_CFG_REG(i));
+}
+
+static void sec_weight(struct sec_dev_info *info, int i)
+{
+	writel_relaxed(0x3f, info->regs[1] + SEC_Q_WEIGHT_CFG_REG(i));
+}
+
+static void sec_queue_ar_alloc(struct sec_queue *queue, u32 alloc)
+{
+	void __iomem *addr = queue->regs + SEC_Q_ARUSER_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (alloc == SEC_QUEUE_AR_FROCE_ALLOC) {
+		regval |= SEC_Q_ARUSER_CFG_FA;
+		regval &= ~SEC_Q_ARUSER_CFG_FNA;
+	} else {
+		regval &= ~SEC_Q_ARUSER_CFG_FA;
+		regval |= SEC_Q_ARUSER_CFG_FNA;
+	}
+
+	writel_relaxed(regval, addr);
+}
+
+static void sec_queue_aw_alloc(struct sec_queue *queue, u32 alloc)
+{
+	void __iomem *addr = queue->regs + SEC_Q_AWUSER_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	if (alloc == SEC_QUEUE_AW_FROCE_ALLOC) {
+		regval |= SEC_Q_AWUSER_CFG_FA;
+		regval &= ~SEC_Q_AWUSER_CFG_FNA;
+	} else {
+		regval &= ~SEC_Q_AWUSER_CFG_FA;
+		regval |= SEC_Q_AWUSER_CFG_FNA;
+	}
+
+	writel_relaxed(regval, addr);
+}
+
+static void sec_queue_enable(struct sec_queue *queue, u32 en)
+{
+	writel_relaxed(en, queue->regs + SEC_QUEUE_ENB_REG);
+}
+
+static void sec_queue_reorder(struct sec_queue *queue, u32 reorder)
+{
+	void __iomem *base = queue->regs;
+	u32 regval;
+
+	regval = readl_relaxed(base + SEC_Q_CFG_REG);
+	if (reorder)
+		regval |= SEC_Q_CFG_REORDER;
+	else
+		regval &= ~SEC_Q_CFG_REORDER;
+	writel_relaxed(regval, base + SEC_Q_CFG_REG);
+}
+
+static void sec_queue_procnum_cfg(struct sec_queue *queue, u32 num)
+{
+	writel_relaxed(num, queue->regs + SEC_Q_PROC_NUM_CFG_REG);
+}
+
+static void sec_queue_depth(struct sec_queue *queue, u32 depth)
+{
+	void __iomem *addr = queue->regs + SEC_Q_DEPTH_CFG_REG;
+	u32 regval;
+
+	regval = readl_relaxed(addr);
+	regval &= ~SEC_Q_DEPTH_CFG_DEPTH_M;
+	regval |= (depth & SEC_Q_DEPTH_CFG_DEPTH_M) << SEC_Q_DEPTH_CFG_DEPTH_S;
+
+	writel_relaxed(regval, addr);
+}
+
+static void sec_queue_cmdbase_addr(struct sec_queue *queue, u64 addr)
+{
+	writel_relaxed(upper_32_bits(addr), queue->regs + SEC_Q_BASE_HADDR_REG);
+	writel_relaxed(lower_32_bits(addr), queue->regs + SEC_Q_BASE_LADDR_REG);
+}
+
+static void sec_queue_outorder_addr(struct sec_queue *queue, u64 addr)
+{
+	writel_relaxed(upper_32_bits(addr),
+		       queue->regs + SEC_Q_OUTORDER_BASE_HADDR_REG);
+	writel_relaxed(lower_32_bits(addr),
+		       queue->regs + SEC_Q_OUTORDER_BASE_LADDR_REG);
+}
+
+static void sec_queue_errbase_addr(struct sec_queue *queue, u64 addr)
+{
+	writel_relaxed(upper_32_bits(addr),
+		       queue->regs + SEC_Q_ERR_BASE_HADDR_REG);
+	writel_relaxed(lower_32_bits(addr),
+		       queue->regs + SEC_Q_ERR_BASE_LADDR_REG);
+}
+
+static void sec_queue_ovrtmth(struct sec_queue *queue, u32 value)
+{
+	writel_relaxed(value, queue->regs + SEC_Q_OT_TH_REG);
+}
+
+static void sec_queue_abnrml_int_mask(struct sec_queue *queue, u32 mask)
+{
+	writel_relaxed(mask, queue->regs + SEC_Q_FAIL_INT_MSK_REG);
+}
+
+static void sec_queue_proc_int_mask(struct sec_queue *queue, u32 mask)
+{
+	writel_relaxed(mask, queue->regs + SEC_Q_FLOW_INT_MKS_REG);
+}
+
+static void sec_queue_init(struct sec_queue *queue, u32 value)
+{
+	writel_relaxed(value, queue->regs + SEC_Q_INIT_REG);
+}
+
+static void sec_queue_irq_disable(struct sec_queue *queue)
+{
+	sec_queue_proc_int_mask(queue, 0xffffffff);
+}
+
+static void sec_queue_irq_enable(struct sec_queue *queue)
+{
+	sec_queue_proc_int_mask(queue, 0);
+}
+
+static void sec_queue_abn_irq_disable(struct sec_queue *queue)
+{
+	sec_queue_abnrml_int_mask(queue, 0xffffffff);
+}
+
+static void sec_queue_stop(struct sec_queue *queue)
+{
+	disable_irq(queue->task_irq);
+	sec_queue_irq_disable(queue);
+	sec_queue_enable(queue, 0x0);
+}
+
+static void sec_queue_start(struct sec_queue *queue)
+{
+	sec_queue_irq_enable(queue);
+	enable_irq(queue->task_irq);
+	queue->expected = 0;
+	sec_queue_init(queue, 0x03);
+	sec_queue_enable(queue, 0x1);
+}
+
+static int sec_queue_in_use_get(struct sec_queue *queue)
+{
+	return queue->status != SEC_Q_STATE_IDLE;
+}
+
+static void sec_queue_in_use(struct sec_queue *queue, int inuse)
+{
+	if (inuse)
+		queue->status = SEC_Q_STATE_USING;
+	else
+		queue->status = SEC_Q_STATE_IDLE;
+}
+
+static int sec_alloc_queue(struct sec_dev_info *info, const char *alg,
+			   struct sec_queue **q)
+{
+	int i;
+
+	spin_lock(&info->dev_lock);
+
+	/* Get the first idle queue in SEC device */
+	for (i = 0; i < SEC_Q_NUM; i++)
+		if (!sec_queue_in_use_get(&info->queues[i])) {
+			sec_queue_in_use(&info->queues[i], 1);
+			spin_unlock(&info->dev_lock);
+			*q = &info->queues[i];
+			return 0;
+		}
+	spin_unlock(&info->dev_lock);
+
+	return -ENODEV;
+}
+
+static int sec_count_queues_in_use(struct sec_dev_info *info)
+{
+	int i, count = 0;
+
+	spin_lock(&info->dev_lock);
+	for (i = 0; i < SEC_Q_NUM; i++)
+		if (sec_queue_in_use_get(&info->queues[i]))
+			count++;
+
+	spin_unlock(&info->dev_lock);
+
+	return count;
+}
+
+static int sec_queue_free(struct sec_queue *queue)
+{
+	struct sec_dev_info *info = queue->dev_info;
+	int i;
+
+	if (queue->queue_id >= SEC_Q_NUM) {
+		dev_err(info->dev, "No queue %d\n", queue->queue_id);
+		return -ENODEV;
+	}
+
+	if (!sec_queue_in_use_get(&info->queues[queue->queue_id])) {
+		dev_err(info->dev, "Queue %d is idle\n", queue->queue_id);
+		return -ENODEV;
+	}
+
+	spin_lock(&info->dev_lock);
+	for (i = 0; i < SEC_Q_NUM; i++) {
+		if (queue == &info->queues[i]) {
+			sec_queue_in_use(queue, 0);
+			spin_unlock(&info->dev_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&info->dev_lock);
+
+	return -ENODEV;
+}
+
+static irqreturn_t sec_isr_handle_th(int irq, void *q)
+{
+	sec_queue_irq_disable(q);
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t sec_isr_handle(int irq, void *q)
+{
+	struct sec_queue *queue = q;
+	struct sec_queue_ring *msg_ring = &queue->ring[SEC_CMD_RING];
+	struct sec_queue_ring *cq_ring = &queue->ring[SEC_OUTORDER_RING];
+	struct sec_out_bd_info *outorder_msg;
+	struct sec_bd_info *msg;
+
+	u32 ooo_read, ooo_write;
+	void __iomem *base = queue->regs;
+	int q_id;
+
+	ooo_read = readl(base + SEC_Q_OUTORDER_RD_PTR_REG);
+	ooo_write = readl(base + SEC_Q_OUTORDER_WR_PTR_REG);
+	outorder_msg = (struct sec_out_bd_info *)cq_ring->vaddr + ooo_read;
+	q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
+	msg = (struct sec_bd_info *)msg_ring->vaddr + q_id;
+
+try_again:
+	while ((ooo_write != ooo_read) && msg->w0 & SEC_BD_W0_DONE) {
+		/*
+		 * Must be before callback otherwise blocks adding other chained
+		 * elements
+		 */
+		atomic_dec(&msg_ring->used);
+		q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
+		if (q_id != queue->expected) {
+			/* Mark it as ready, but don't do anything yet */
+			set_bit(q_id, queue->unprocessed);
+		} else	{
+			msg_ring->callback(msg,
+					   queue->shadow[queue->expected]);
+			msg->w0 &= ~SEC_BD_W0_DONE;
+			queue->expected =
+				(queue->expected + 1) % msg_ring->depth;
+			while (test_bit(queue->expected, queue->unprocessed)) {
+				clear_bit(queue->expected, queue->unprocessed);
+				msg = (struct sec_bd_info *)msg_ring->vaddr +
+					queue->expected;
+
+				msg_ring->callback(msg,
+						queue->shadow[queue->expected]);
+				msg->w0 &= ~SEC_BD_W0_DONE;
+				queue->expected = (queue->expected + 1) %
+					msg_ring->depth;
+			}
+		}
+
+		ooo_read = (ooo_read + 1) % cq_ring->depth;
+		/* Memory barrier to ensure content is written before advance */
+		wmb();
+		writel(ooo_read, base + SEC_Q_OUTORDER_RD_PTR_REG);
+		ooo_write = readl(base + SEC_Q_OUTORDER_WR_PTR_REG);
+		outorder_msg =
+			(struct sec_out_bd_info *)cq_ring->vaddr + ooo_read;
+		q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
+		msg = (struct sec_bd_info *)msg_ring->vaddr + q_id;
+	}
+
+	sec_queue_irq_enable(queue);
+	ooo_write = readl(base + SEC_Q_OUTORDER_WR_PTR_REG);
+	q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
+	msg = (struct sec_bd_info *)(msg_ring->vaddr) + q_id;
+	if (ooo_write != ooo_read && msg->w0 & SEC_BD_W0_DONE) {
+		sec_queue_irq_disable(queue);
+		goto try_again;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int sec_queue_irq_init(struct sec_queue *queue)
+{
+	struct sec_dev_info *info = queue->dev_info;
+	int irq = queue->task_irq;
+	int ret;
+
+	ret = request_threaded_irq(irq, sec_isr_handle_th, sec_isr_handle,
+				   IRQF_TRIGGER_RISING, queue->name, queue);
+	if (ret) {
+		dev_err(info->dev, "request irq(%d) fail\n", irq);
+		return ret;
+	}
+	disable_irq(irq);
+
+	return 0;
+}
+
+static int sec_queue_irq_uninit(struct sec_queue *queue)
+{
+	irq_set_affinity_hint(queue->task_irq, NULL);
+	free_irq(queue->task_irq, queue);
+
+	return 0;
+}
+
+static struct sec_dev_info *sec_device_get(void)
+{
+	struct sec_dev_info *sec_dev = NULL;
+	struct sec_dev_info *this_sec_dev;
+	int least_busy_n = SEC_Q_NUM + 1;
+	int in_use, i;
+
+	/* Find which one is least busy and use that first */
+	for (i = 0; i < SEC_MAX_DEVICES; i++) {
+		this_sec_dev = sec_devices[i];
+		if (this_sec_dev) {
+			in_use = sec_count_queues_in_use(this_sec_dev);
+			if (in_use < least_busy_n) {
+				least_busy_n = in_use;
+				sec_dev = this_sec_dev;
+			}
+		}
+	}
+
+	return sec_dev;
+}
+
+static struct sec_queue *sec_queue_alloc_start(struct sec_dev_info *info)
+{
+	struct sec_queue *queue = NULL;
+	int ret;
+
+	ret = sec_alloc_queue(info, NULL, &queue);
+	if (ret) {
+		dev_err(info->dev, "alloc sec queue fai!\n");
+		return NULL;
+	}
+
+	sec_queue_start(queue);
+
+	return queue;
+}
+
+/**
+ * sec_queue_alloc_start_safe - get a hw queue from appropriate instance
+ *
+ * This function does extremely simplistic load balancing. It does not take into
+ * account NUMA locality of the accelerator, or which cpu has requested the
+ * queue.  Future work may focus on optimizing this in order to improve full
+ * machine throughput.
+ */
+struct sec_queue *sec_queue_alloc_start_safe(void)
+{
+	struct sec_dev_info *info;
+	struct sec_queue *queue = NULL;
+
+	mutex_lock(&sec_id_lock);
+	info = sec_device_get();
+	if (!info)
+		goto unlock;
+
+	queue = sec_queue_alloc_start(info);
+unlock:
+	mutex_unlock(&sec_id_lock);
+
+	return queue;
+}
+
+/**
+ * sec_queue_stop_release() - free up a hw queue for reuse
+ * @queue: The queue we are done with.
+ *
+ * This will stop the current queue, terminanting any transactions
+ * that are inflight an return it to the pool of available hw queuess
+ */
+int sec_queue_stop_release(struct sec_queue *queue)
+{
+	struct device *dev = queue->dev_info->dev;
+	int ret;
+
+	sec_queue_stop(queue);
+
+	ret = sec_queue_free(queue);
+	if (ret) {
+		dev_err(dev, "Releasing queue failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * sec_queue_empty() - Is this hardware queue currently empty.
+ *
+ * We need to know if we have an empty queue for some of the chaining modes
+ * as if it is not empty we may need to hold the message in a software queue
+ * until the hw queue is drained.
+ */
+bool sec_queue_empty(struct sec_queue *queue)
+{
+	struct sec_queue_ring *msg_ring = &queue->ring[SEC_CMD_RING];
+
+	return !atomic_read(&msg_ring->used);
+}
+
+/**
+ * sec_queue_send() - queue up a single operation in the hw queue
+ * @queue: The queue in which to put the message
+ * @msg: The message
+ * @ctx: Context to be put in the shadow array and passed back to cb on result.
+ *
+ * This function will return -EAGAIN if the queue is currently full.
+ */
+int sec_queue_send(struct sec_queue *queue, struct sec_bd_info *msg, void *ctx)
+{
+	struct sec_queue_ring *msg_ring = &queue->ring[SEC_CMD_RING];
+	void __iomem *base = queue->regs;
+	u32 write, read;
+
+	spin_lock_bh(&msg_ring->lock);
+	read = readl(base + SEC_Q_RD_PTR_REG);
+	write = readl(base + SEC_Q_WR_PTR_REG);
+	if (write == read && atomic_read(&msg_ring->used) == msg_ring->depth) {
+		spin_unlock_bh(&msg_ring->lock);
+		return -EAGAIN;
+	}
+	memcpy(msg_ring->vaddr + write * msg_ring->msg_size,
+	       msg, msg_ring->msg_size);
+	queue->shadow[write] = ctx;
+	write = (write + 1) % msg_ring->depth;
+
+	/* Ensure content updated before queue advance */
+	wmb();
+	writel(write, base + SEC_Q_WR_PTR_REG);
+
+	atomic_inc(&msg_ring->used);
+	spin_unlock_bh(&msg_ring->lock);
+
+	return 0;
+}
+
+static void sec_queue_hw_init(struct sec_queue *queue)
+{
+	sec_queue_ar_alloc(queue, SEC_QUEUE_AR_FROCE_NOALLOC);
+	sec_queue_aw_alloc(queue, SEC_QUEUE_AR_FROCE_NOALLOC);
+	sec_queue_ar_pkgattr(queue, 1);
+	sec_queue_aw_pkgattr(queue, 1);
+
+	/* Enable out of order queue */
+	sec_queue_reorder(queue, 1);
+
+	sec_queue_procnum_cfg(queue, 1);
+	sec_queue_depth(queue, queue->ring[SEC_CMD_RING].depth - 1);
+
+	sec_queue_cmdbase_addr(queue, queue->ring[SEC_CMD_RING].paddr);
+
+	sec_queue_outorder_addr(queue, queue->ring[SEC_OUTORDER_RING].paddr);
+
+	sec_queue_errbase_addr(queue, queue->ring[SEC_DBG_RING].paddr);
+
+	sec_queue_ovrtmth(queue, 0x100);
+	sec_queue_abn_irq_disable(queue);
+	sec_queue_irq_disable(queue);
+	sec_queue_init(queue, 0x3);
+}
+
+static int sec_hw_init(struct sec_dev_info *info)
+{
+	u32 sec_ipv4_mask = 0;
+	u32 sec_ipv6_mask[10] = {};
+	u32 i, ret;
+
+	/* Enable all processing unit clock */
+	if (info->dev->iommu_group)
+		/* Only the first cluster of processing units is usable with iommu */
+		sec_saa_clk_en(info, 0x01f);
+	else
+		sec_saa_clk_en(info, 0x3ff);
+
+	/* 32 bit little endian */
+	sec_bd_endian(info, 0);
+	sec_bd_endian_type(info, 0);
+
+	sec_cache_config(info);
+
+	/* Data axi port write and read outstanding config as per datasheet */
+	sec_data_axiwr_otsd_cfg(info, 0x7);
+	sec_data_axird_otsd_cfg(info, 0x7);
+
+	/* Enable clock gating */
+	sec_clk_gate_en(info, 1);
+
+	/* Set CNT_CYC register not read clear */
+	sec_comm_cnt_cfg(info, 0);
+
+	/* Enable CNT_CYC */
+	sec_commsnap_en(info, 0);
+
+	sec_fsm_maxcnt(info, 0xffffffff);
+
+	ret = sec_ipv4_hashmask(info, sec_ipv4_mask);
+	if (ret) {
+		dev_err(info->dev, "Failed to set ipv4 hasmask\n");
+		return -EIO;
+	}
+
+	sec_ipv6_hashmask(info, sec_ipv6_mask);
+
+	/*  do not use debug bd */
+	sec_set_dbg_bd_cfg(info, 0);
+
+	/* RFC: Check if the smmu is enabled */
+	if (info->dev->iommu_group)
+		for (i = 0; i < SEC_Q_NUM; i++) {
+			sec_streamid(info, i);
+			sec_weight(info, i);
+		}
+	for (i = 0; i < SEC_MAX_SAA_NUM; i++) {
+		sec_saa_getqm_en(info, i, 1);
+		sec_saa_int_mask(info, i, 0);
+	}
+
+	return 0;
+}
+
+static void sec_hw_exit(struct sec_dev_info *info)
+{
+	int i;
+
+	for (i = 0; i < SEC_MAX_SAA_NUM; i++) {
+		sec_saa_int_mask(info, i, 0xffffffff);
+		sec_saa_getqm_en(info, i, 0);
+	}
+}
+
+static void sec_queue_base_init(struct sec_dev_info *info,
+				struct sec_queue *queue, int queue_id)
+{
+	queue->dev_info = info;
+	queue->queue_id = queue_id;
+	snprintf(queue->name, sizeof(queue->name),
+		 "%s_%d", dev_name(info->dev), queue->queue_id);
+}
+
+static int sec_map_io(struct sec_dev_info *info, struct platform_device *pdev)
+{
+	struct resource *res;
+	int i;
+
+	for (i = 0; i < SEC_ADDR_REGION; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		info->regs[i] = devm_ioremap(info->dev, res->start,
+					     resource_size(res));
+		if (IS_ERR(info->regs[i])) {
+			dev_err(info->dev, "Memory resource %u not found\n", i);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int sec_base_init(struct sec_dev_info *info,
+			 struct platform_device *pdev)
+{
+	int ret;
+
+	ret = sec_map_io(info, pdev);
+	if (ret)
+		return ret;
+
+	ret = sec_clk_en(info);
+	if (ret)
+		return ret;
+
+	ret = sec_reset_whole_module(info);
+	if (ret)
+		goto sec_clk_disable;
+
+	ret = sec_hw_init(info);
+	if (ret)
+		goto sec_clk_disable;
+
+	return ret;
+
+sec_clk_disable:
+	sec_clk_dis(info);
+
+	return ret;
+}
+
+static void sec_base_exit(struct sec_dev_info *info)
+{
+	sec_hw_exit(info);
+	sec_clk_dis(info);
+}
+
+static const unsigned int sec_mem_size[SEC_HW_RING_NUM] = {
+	SEC_CMD_RING_SIZE,
+	SEC_OUTORDER_RING_SIZE,
+	SEC_DB_RING_SIZE,
+};
+
+static int sec_queue_res_cfg(struct sec_queue *queue)
+{
+	struct device *dev = SEC_Q_DEV(queue);
+	static const u32 msg_size[SEC_HW_RING_NUM] = {
+		sizeof(struct sec_bd_info),
+		sizeof(struct sec_out_bd_info),
+		sizeof(struct sec_debug_bd_info),
+	};
+	int i, j, ret;
+
+	for (i = 0; i < SEC_HW_RING_NUM; i++) {
+		queue->ring[i].vaddr =
+			dma_zalloc_coherent(dev, sec_mem_size[i],
+					    &queue->ring[i].paddr,
+					    GFP_KERNEL);
+		if (!queue->ring[i].vaddr) {
+			ret = -ENOMEM;
+			goto err_free_rings;
+		}
+		queue->ring[i].depth = SEC_QUEUE_LEN;
+		queue->ring[i].msg_size = msg_size[i];
+		atomic_set(&queue->ring[i].used, 0);
+		spin_lock_init(&queue->ring[i].lock);
+	}
+	queue->ring[SEC_CMD_RING].callback = sec_alg_callback;
+
+	queue->task_irq = platform_get_irq(to_platform_device(dev),
+					   queue->queue_id * 2 + 1);
+	if (queue->task_irq <= 0) {
+		ret = -EINVAL;
+		goto err_free_rings;
+	}
+
+	return 0;
+err_free_rings:
+	for (j = i - 1; j >= 0; j--)
+		dma_free_coherent(dev, sec_mem_size[j], queue->ring[j].vaddr,
+				  queue->ring[j].paddr);
+
+	return ret;
+}
+
+static void sec_queue_free_ring_pages(struct sec_queue *queue)
+{
+	struct device *dev = SEC_Q_DEV(queue);
+	int i;
+
+	for (i = 0; i < SEC_HW_RING_NUM; i++)
+		dma_free_coherent(dev, sec_mem_size[i], queue->ring[i].vaddr,
+				  queue->ring[i].paddr);
+}
+
+static int sec_queue_config(struct sec_dev_info *info, struct sec_queue *queue,
+			    int queue_id)
+{
+	int ret;
+
+	sec_queue_base_init(info, queue, queue_id);
+
+	ret = sec_queue_res_cfg(queue);
+	if (ret)
+		return ret;
+
+	ret = sec_queue_map_io(queue);
+	if (ret) {
+		dev_err(info->dev, "Queue map failed\n");
+		goto free_ring_pages;
+	}
+
+	sec_queue_hw_init(queue);
+
+	return 0;
+free_ring_pages:
+	sec_queue_free_ring_pages(queue);
+
+	return ret;
+}
+
+static void sec_queue_unconfig(struct sec_dev_info *info,
+				    struct sec_queue *queue)
+{
+	sec_queue_unmap_io(queue);
+	sec_queue_free_ring_pages(queue);
+}
+
+static int sec_id_alloc(struct sec_dev_info *info)
+{
+	int ret = 0;
+	int i;
+
+	mutex_lock(&sec_id_lock);
+
+	for (i = 0; i < SEC_MAX_DEVICES; i++)
+		if (!sec_devices[i])
+			break;
+	if (i == SEC_MAX_DEVICES) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	info->sec_id = i;
+	sec_devices[info->sec_id] = info;
+
+unlock:
+	mutex_unlock(&sec_id_lock);
+
+	return ret;
+}
+
+static void sec_id_free(struct sec_dev_info *info)
+{
+	mutex_lock(&sec_id_lock);
+	sec_devices[info->sec_id] = NULL;
+	mutex_unlock(&sec_id_lock);
+}
+
+static int sec_probe(struct platform_device *pdev)
+{
+	struct sec_dev_info *info;
+	struct device *dev = &pdev->dev;
+	int i, j;
+	int ret;
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(dev, "Failed to set 64 bit dma mask");
+		return -ENODEV;
+	}
+
+	info = devm_kzalloc(dev, (sizeof(*info)), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = dev;
+	spin_lock_init(&info->dev_lock);
+
+	info->hw_sgl_pool = dmam_pool_create("sgl", dev,
+					     sizeof(struct sec_hw_sgl), 64, 0);
+	if (!info->hw_sgl_pool) {
+		dev_err(dev, "Failed to create sec sgl dma pool\n");
+		return -ENOMEM;
+	}
+	info->iv_pool = dmam_pool_create("iv", dev, SEC_MAX_CIPHER_IV, 0,
+					 0);
+	if (!info->iv_pool) {
+		dev_err(dev, "Failed to create an IV dma pool\n");
+		return -ENOMEM;
+	}
+	info->small_packets_pool = dmam_pool_create("small", dev,
+						    SEC_SMALL_PACKET_SIZE,
+						    64, 0);
+	if (!info->small_packets_pool) {
+		dev_err(dev, "Failed to create the small packet dmapool\n");
+		return -ENOMEM;
+	}
+
+	ret = sec_base_init(info, pdev);
+	if (ret) {
+		dev_err(dev, "Base initialization fail!\n");
+		return ret;
+	}
+
+	for (i = 0; i < SEC_Q_NUM; i++) {
+		ret = sec_queue_config(info, &info->queues[i], i);
+		if (ret)
+			goto queues_unconfig;
+
+		ret = sec_queue_irq_init(&info->queues[i]);
+		if (ret) {
+			sec_queue_unconfig(info, &info->queues[i]);
+			goto queues_unconfig;
+		}
+	}
+
+	ret = sec_algs_register();
+	if (ret) {
+		dev_err(dev, "Failed to register algorithms with crypto\n");
+		goto queues_unconfig;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	ret = sec_id_alloc(info);
+	if (ret)
+		goto algs_unregister;
+
+	return 0;
+
+algs_unregister:
+	sec_algs_unregister();
+queues_unconfig:
+	for (j = i; j >= 0; j--)
+		sec_queue_unconfig(info, &info->queues[i]);
+	sec_base_exit(info);
+
+	return ret;
+}
+
+static int sec_remove(struct platform_device *pdev)
+{
+	struct sec_dev_info *info = platform_get_drvdata(pdev);
+	int i;
+
+	/* Unexpose as soon as possible, reuse during remove is fine */
+	sec_id_free(info);
+
+	sec_algs_unregister();
+
+	for (i = 0; i < SEC_Q_NUM; i++) {
+		sec_queue_irq_uninit(&info->queues[i]);
+		sec_queue_unconfig(info, &info->queues[i]);
+	}
+
+	sec_base_exit(info);
+
+	return 0;
+}
+
+static const struct of_device_id sec_match[] = {
+	{ .compatible = "hisilicon,hip06-sec" },
+	{ .compatible = "hisilicon,hip07-sec" },
+	{}
+};
+
+static const struct acpi_device_id sec_acpi_match[] = {
+	{ "HISI02C1", 0 },
+	{ }
+};
+
+static struct platform_driver sec_driver = {
+	.probe = sec_probe,
+	.remove = sec_remove,
+	.driver = {
+		.name = "hisi_sec_platform_driver",
+		.of_match_table = sec_match,
+		.acpi_match_table = ACPI_PTR(sec_acpi_match),
+	},
+};
+
+static int __init sec_mod_init(void)
+{
+	mutex_init(&sec_id_lock);
+	return platform_driver_register(&sec_driver);
+}
+module_init(sec_mod_init);
+
+static void __exit sec_mod_exit(void)
+{
+	platform_driver_unregister(&sec_driver);
+}
+module_exit(sec_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Hisilicon Security Accelerators");
+MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com");
+MODULE_AUTHOR("Jonathan Cameron <jonathan.cameron@huawei.com>");
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.h b/drivers/crypto/hisilicon/sec/sec_drv.h
new file mode 100644
index 000000000000..540233eae698
--- /dev/null
+++ b/drivers/crypto/hisilicon/sec/sec_drv.h
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2017 Hisilicon Limited. */
+
+#ifndef _SEC_DRV_H_
+#define _SEC_DRV_H_
+
+#include <crypto/algapi.h>
+
+/*
+ * An optimization tweak due to the very high performance penalty of
+ * small messages when an IOMMU is enabled.  This switches those cases
+ * to a dma_pool to reduce iommu tlb activity.
+ */
+#define SEC_SMALL_PACKET_SIZE		256
+
+#define SEC_MAX_CIPHER_KEY		64
+#define SEC_MAX_CIPHER_IV		32
+#define SEC_MAX_SGE_NUM			64
+#define SEC_HW_RING_NUM			3
+
+#define SEC_CMD_RING			0
+#define SEC_OUTORDER_RING		1
+#define SEC_DBG_RING			2
+
+#define SEC_QUEUE_LEN			512
+
+#define SEC_CMD_RING_SIZE \
+	round_up(SEC_QUEUE_LEN * sizeof(struct sec_bd_info), PAGE_SIZE)
+#define SEC_OUTORDER_RING_SIZE \
+	round_up(SEC_QUEUE_LEN * sizeof(struct sec_out_bd_info), PAGE_SIZE)
+#define SEC_DB_RING_SIZE \
+	round_up(SEC_QUEUE_LEN * sizeof(struct sec_debug_bd_info), \
+		 PAGE_SIZE)
+
+#define SEC_MAX_SGE_NUM   64
+
+struct sec_bd_info {
+#define SEC_BD_W0_T_LEN_M			GENMASK(4, 0)
+#define SEC_BD_W0_T_LEN_S			0
+#define SEC_BD_W0_C_WIDTH_M			GENMASK(6, 5)
+#define SEC_BD_W0_C_WIDTH_S			5
+#define SEC_BD_W0_C_MODE_M			GENMASK(9, 7)
+#define SEC_BD_W0_C_MODE_S			7
+#define SEC_BD_W0_SEQ				BIT(10)
+#define SEC_BD_W0_DE				BIT(11)
+#define SEC_BD_W0_DAT_SKIP_M			GENMASK(13, 12)
+#define SEC_BD_W0_DAT_SKIP_S			12
+#define SEC_BD_W0_GRAN_SIZE_MID_M		GENMASK(17, 14)
+#define SEC_BD_W0_GRAN_SIZE_MID_S		14
+#define SEC_BD_W0_CIPHER_M			GENMASK(19, 18)
+#define SEC_BD_W0_CIPHER_S			18
+#define SEC_BD_W0_AUTH_M			GENMASK(21, 20)
+#define SEC_BD_W0_AUTH_S			20
+#define SEC_BD_W0_AI_GEN			BIT(22)
+#define SEC_BD_W0_CI_GEN			BIT(23)
+#define SEC_BD_W0_NO_HPAD			BIT(24)
+#define SEC_BD_W0_HM_M				GENMASK(26, 25)
+#define SEC_BD_W0_HM_S				25
+#define SEC_BD_W0_ICV_OR_SKEY_EN_M		GENMASK(28, 27)
+#define SEC_BD_W0_ICV_OR_SKEY_EN_S		27
+#define SEC_BD_W0_F_OR_C_GRAN_SIZE_H_M		GENMASK(30, 29)
+#define SEC_BD_W0_F_OR_C_GRAN_SIZE_H_S		30
+#define SEC_BD_W0_DONE				BIT(31)
+	u32 w0;
+
+#define SEC_BD_W1_AUTH_GRAN_SZ_M		GENMASK(21, 0)
+#define SEC_BD_W1_AUTH_GRAN_SZ_S		0
+#define SEC_BD_W1_M_KEY_EN			BIT(22)
+#define SEC_BD_W1_BD_INVALID			BIT(23)
+#define SEC_BD_W1_ADDR_TYPE			BIT(24)
+#define SEC_BD_W1_A_ALG_M			GENMASK(28, 25)
+#define SEC_BD_W1_A_ALG_S			25
+#define SEC_BD_W1_C_ALG_M			GENMASK(31, 29)
+#define SEC_BD_W1_C_ALG_S			29
+	u32 w1;
+
+#define SEC_BD_W2_GRAN_SIZE_LOW_M		GENMASK(15, 0)
+#define SEC_BD_W2_GRAN_SIZE_LOW_S		0
+#define SEC_BD_W2_GRAN_NUM_M			GENMASK(31, 16)
+#define SEC_BD_W2_GRAN_NUM_S			16
+	u32 w2;
+
+#define SEC_BD_W3_AUTH_LEN_OFFSET_M		GENMASK(9, 0)
+#define SEC_BD_W3_AUTH_LEN_OFFSET_S		0
+#define SEC_BD_W3_CIPHER_LEN_OFFSET_M		GENMASK(19, 10)
+#define SEC_BD_W3_CIPHER_LEN_OFFSET_S		10
+#define SEC_BD_W3_CIPHER_MAC_LEN_M		GENMASK(24, 20)
+#define SEC_BD_W3_CIPHER_MAC_LEN_S		20
+#define SEC_BD_W3_A_KEY_LEN_M			GENMASK(29, 25)
+#define SEC_BD_W3_A_KEY_LEN_S			25
+#define SEC_BD_W3_C_KEY_LEN_M			GENMASK(31, 30)
+#define SEC_BD_W3_C_KEY_LEN_S			30
+	u32 w3;
+
+	/* W4,5 */
+	union {
+		u32 authkey_addr_lo;
+		u32 authiv_addr_lo;
+	};
+	union {
+		u32 authkey_addr_hi;
+		u32 authiv_addr_hi;
+	};
+
+	/* W6,7 */
+	u32 cipher_key_addr_lo;
+	u32 cipher_key_addr_hi;
+
+	/* W8,9 */
+	u32 cipher_iv_addr_lo;
+	u32 cipher_iv_addr_hi;
+
+	/* W10,11 */
+	u32 data_addr_lo;
+	u32 data_addr_hi;
+
+	/* W12,13 */
+	u32 mac_addr_lo;
+	u32 mac_addr_hi;
+
+	/* W14,15 */
+	u32 cipher_destin_addr_lo;
+	u32 cipher_destin_addr_hi;
+};
+
+enum sec_queue_status {
+	SEC_Q_STATE_IDLE,
+	SEC_Q_STATE_USING,
+};
+
+#define SEC_NAME_SIZE				64
+#define SEC_Q_NUM				16
+#define SEC_ADDR_REGION				2
+
+#define SEC_Q_DEV(Q)		(Q->dev_info->dev)
+#define SEC_DEV(SEC)		((SEC)->dev)
+
+/* cipher before auth */
+#define SEC_SEQ_CIPHER_AUTH				0x0
+/* auth before cipher */
+#define SEC_SEQ_AUTH_CIPHER				0x1
+
+/**
+ * struct sec_queue_ring - store information about a SEC HW ring
+ * @depth: Number of elements
+ * @used: Local counter used to cheaply establish if the ring is empty.
+ * @msg_size: Queue type dependent message size.
+ * @lock: Protect against simultaneous adjusting of the read and write pointers.
+ * @vaddr: Virtual address for the ram pages used for the ring.
+ * @paddr: Physical address of the dma mapped region of ram used for the ring.
+ * @size: Size of the dma mapped region of ram used for the ring.
+ * @callback: Callback function called on a ring element completing.
+ */
+struct sec_queue_ring {
+	u32 depth;
+	atomic_t used;
+	u32 msg_size;
+	spinlock_t lock;
+	void *vaddr;
+	dma_addr_t paddr;
+	u32 size;
+	void (*callback)(struct sec_bd_info *resp, void *ctx);
+};
+
+struct sec_dev_info;
+
+/**
+ * struct sec_queue - All the information about a HW queue
+ * @dev_info: The parent SEC device to which this queue belongs.
+ * @task_irq: Completion interrupt for the queue.
+ * @name: Human readable queue description also used as irq name.
+ * @ring: The several HW rings associated with one queue.
+ * @regs: The iomapped device registers
+ * @queue_id: Index of the queue used for naming and resource selection.
+ * @status: Flag to say if the queue is in use.
+ * @expected: The next expected element to finish assuming we were in order.
+ * @uprocessed: A bitmap to track which OoO elements are done but not handled.
+ * @softqueue: A software queue used when chaining requirements prevent direct
+ *   use of the hardware queues.
+ * @havesoftqueue: A flag to say we have a queues - as we may need one for the
+ *   current mode.
+ * @queuelock: Protect the soft queue from concurrent changes to avoid some
+ *   potential loss of data races.
+ * @shadow: Pointers back to the shaddow copy of the hardware ring element
+ *   need because we can't store any context reference in the bd element.
+ */
+struct sec_queue {
+	struct sec_dev_info *dev_info;
+	int task_irq;
+	char name[SEC_NAME_SIZE];
+	struct sec_queue_ring ring[SEC_HW_RING_NUM];
+	void __iomem *regs;
+	u32 queue_id;
+	enum sec_queue_status status;
+	int expected;
+
+	DECLARE_BITMAP(unprocessed, SEC_QUEUE_LEN);
+	struct crypto_queue softqueue;
+	bool havesoftqueue;
+	spinlock_t queuelock;
+	void *shadow[SEC_QUEUE_LEN];
+};
+
+/**
+ * struct sec_hw_sge: Track each of the 64 element SEC HW SGL entries
+ * @buf: The IOV dma address for this entry.
+ * @len: Length of this IOV.
+ * @pad: Reserved space.
+ */
+struct sec_hw_sge {
+	dma_addr_t buf;
+	unsigned int len;
+	unsigned int pad;
+};
+
+/**
+ * struct sec_hw_sgl: One hardware SGL entry.
+ * @next_sgl: The next entry if we need to chain dma address. Null if last.
+ * @entry_sum_in_chain: The full count of SGEs - only matters for first SGL.
+ * @entry_sum_in_sgl: The number of SGEs in this SGL element.
+ * @flag: Unused in skciphers.
+ * @serial_num: Unsued in skciphers.
+ * @cpuid: Currently unused.
+ * @data_bytes_in_sgl: Count of bytes from all SGEs in this SGL.
+ * @next: Virtual address used to stash the next sgl - useful in completion.
+ * @reserved: A reserved field not currently used.
+ * @sge_entries: The (up to) 64 Scatter Gather Entries, representing IOVs.
+ * @node: Currently unused.
+ */
+struct sec_hw_sgl {
+	dma_addr_t next_sgl;
+	u16 entry_sum_in_chain;
+	u16 entry_sum_in_sgl;
+	u32 flag;
+	u64 serial_num;
+	u32 cpuid;
+	u32 data_bytes_in_sgl;
+	struct sec_hw_sgl *next;
+	/* Reserved space in documentation - abused here */
+	u64 reserved;
+	struct sec_hw_sge  sge_entries[SEC_MAX_SGE_NUM];
+	u8 node[16];
+};
+
+struct dma_pool;
+
+/**
+ * struct sec_dev_info: The full SEC unit comprising queues and processors.
+ * @sec_id: Index used to track which SEC this is when more than one is present.
+ * @regs: iomapped register regions shared by whole SEC unit.
+ * @dev_lock: Protects concurrent queue allocation / freeing for the SEC.
+ * @queues: The 16 queues that this SEC instance provides.
+ * @dev: Device pointer.
+ * @hw_sgl_pool: DMA pool used to mimise mapping for the scatter gather lists.
+ * @iv_pool: DMA pool used to minise mapping for the Initialization Vectors.
+ * @small_packets_pool: DMA pool used to allocate bounce buffers to avoid
+ *   iommu setup costs for small packets.  It's cheaper to copy them.
+ */
+struct sec_dev_info {
+	int sec_id;
+	void __iomem *regs[SEC_ADDR_REGION];
+	spinlock_t dev_lock;
+
+	struct sec_queue queues[SEC_Q_NUM];
+	struct device *dev;
+	struct dma_pool *hw_sgl_pool;
+	struct dma_pool *iv_pool;
+	struct dma_pool *small_packets_pool;
+	bool ready;
+};
+
+int sec_queue_send(struct sec_queue *queue, struct sec_bd_info *msg, void *ctx);
+int sec_queue_stop_release(struct sec_queue *queue);
+struct sec_queue *sec_queue_alloc_start_safe(void);
+bool sec_queue_empty(struct sec_queue *queue);
+
+/* Algorithm specific elements from sec_algs.c */
+void sec_alg_callback(struct sec_bd_info *resp, void *ctx);
+int sec_algs_register(void);
+void sec_algs_unregister(void);
+
+#endif /* _SEC_DRV_H_ */
-- 
2.11.0
