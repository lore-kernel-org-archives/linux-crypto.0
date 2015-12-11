From: Zain Wang <zain.wang@rock-chips.com>
Subject: [RFC PATCH V3] Crypto: rockchip/crypto - add hash support for crypto engine in rk3288
Date: Fri, 11 Dec 2015 09:58:23 +0800
Message-ID: <1449799103-24221-1-git-send-email-zain.wang@rock-chips.com>
Cc: eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org, Zain Wang <zain.wang@rock-chips.com>
To: heiko@sntech.de, herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.135]:49370 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbLKB6a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 20:58:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add md5 sha1 sha256 support for crypto engine in rk3288.
This patch can't support multiple updatings because of limited of IC,
as result, it can't support import and export too.

Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
---

Changes in V3:
- add switch instead of multiple if.

Changes in V2:
- add some comments to code.
- fix some issues about zero message process.

 drivers/crypto/rockchip/Makefile                   |   1 +
 drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 394 +++++++++++++++++++++
 5 files changed, 480 insertions(+), 18 deletions(-)
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c

diff --git a/drivers/crypto/rockchip/Makefile b/drivers/crypto/rockchip/Makefile
index 7051c6c..30f9129 100644
--- a/drivers/crypto/rockchip/Makefile
+++ b/drivers/crypto/rockchip/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rk_crypto.o
 rk_crypto-objs := rk3288_crypto.o \
 		  rk3288_crypto_ablkcipher.o \
+		  rk3288_crypto_ahash.o
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 82f3044..67d69d2 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -190,7 +190,6 @@ static void rk_crypto_tasklet_cb(unsigned long data)
 {
 	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
 	struct crypto_async_request *async_req, *backlog;
-	struct rk_cipher_reqctx *ablk_reqctx;
 	int err = 0;
 	unsigned long flags;
 
@@ -207,10 +206,10 @@ static void rk_crypto_tasklet_cb(unsigned long data)
 		backlog = NULL;
 	}
 
-	if (crypto_tfm_alg_type(async_req->tfm) == CRYPTO_ALG_TYPE_ABLKCIPHER) {
+	if (crypto_tfm_alg_type(async_req->tfm) == CRYPTO_ALG_TYPE_ABLKCIPHER)
 		dev->ablk_req = ablkcipher_request_cast(async_req);
-		ablk_reqctx   = ablkcipher_request_ctx(dev->ablk_req);
-	}
+	else
+		dev->ahash_req = ahash_request_cast(async_req);
 	err = dev->start(dev);
 	if (err)
 		dev->complete(dev, err);
@@ -223,6 +222,9 @@ static struct rk_crypto_tmp *rk_cipher_algs[] = {
 	&rk_cbc_des_alg,
 	&rk_ecb_des3_ede_alg,
 	&rk_cbc_des3_ede_alg,
+	&rk_ahash_sha1,
+	&rk_ahash_sha256,
+	&rk_ahash_md5,
 };
 
 static int rk_crypto_register(struct rk_crypto_info *crypto_info)
@@ -232,15 +234,24 @@ static int rk_crypto_register(struct rk_crypto_info *crypto_info)
 
 	for (i = 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
 		rk_cipher_algs[i]->dev = crypto_info;
-		err = crypto_register_alg(&rk_cipher_algs[i]->alg);
+		if (rk_cipher_algs[i]->type == ALG_TYPE_CIPHER)
+			err = crypto_register_alg(
+					&rk_cipher_algs[i]->alg.crypto);
+		else
+			err = crypto_register_ahash(
+					&rk_cipher_algs[i]->alg.hash);
 		if (err)
 			goto err_cipher_algs;
 	}
 	return 0;
 
 err_cipher_algs:
-	for (k = 0; k < i; k++)
-		crypto_unregister_alg(&rk_cipher_algs[k]->alg);
+	for (k = 0; k < i; k++) {
+		if (rk_cipher_algs[i]->type == ALG_TYPE_CIPHER)
+			crypto_unregister_alg(&rk_cipher_algs[k]->alg.crypto);
+		else
+			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
+	}
 	return err;
 }
 
@@ -248,8 +259,12 @@ static void rk_crypto_unregister(void)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(rk_cipher_algs); i++)
-		crypto_unregister_alg(&rk_cipher_algs[i]->alg);
+	for (i = 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
+		if (rk_cipher_algs[i]->type == ALG_TYPE_CIPHER)
+			crypto_unregister_alg(&rk_cipher_algs[i]->alg.crypto);
+		else
+			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
+	}
 }
 
 static void rk_crypto_action(void *data)
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 604ffe7..01d8299 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -6,6 +6,10 @@
 #include <crypto/algapi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <crypto/internal/hash.h>
+
+#include "crypto/md5.h"
+#include "crypto/sha.h"
 
 #define _SBF(v, f)			((v) << (f))
 
@@ -149,6 +153,28 @@
 #define RK_CRYPTO_TDES_KEY3_0		0x0130
 #define RK_CRYPTO_TDES_KEY3_1		0x0134
 
+/* HASH */
+#define RK_CRYPTO_HASH_CTRL		0x0180
+#define RK_CRYPTO_HASH_SWAP_DO		BIT(3)
+#define RK_CRYPTO_HASH_SWAP_DI		BIT(2)
+#define RK_CRYPTO_HASH_SHA1		_SBF(0x00, 0)
+#define RK_CRYPTO_HASH_MD5		_SBF(0x01, 0)
+#define RK_CRYPTO_HASH_SHA256		_SBF(0x02, 0)
+#define RK_CRYPTO_HASH_PRNG		_SBF(0x03, 0)
+
+#define RK_CRYPTO_HASH_STS		0x0184
+#define RK_CRYPTO_HASH_DONE		BIT(0)
+
+#define RK_CRYPTO_HASH_MSG_LEN		0x0188
+#define RK_CRYPTO_HASH_DOUT_0		0x018c
+#define RK_CRYPTO_HASH_DOUT_1		0x0190
+#define RK_CRYPTO_HASH_DOUT_2		0x0194
+#define RK_CRYPTO_HASH_DOUT_3		0x0198
+#define RK_CRYPTO_HASH_DOUT_4		0x019c
+#define RK_CRYPTO_HASH_DOUT_5		0x01a0
+#define RK_CRYPTO_HASH_DOUT_6		0x01a4
+#define RK_CRYPTO_HASH_DOUT_7		0x01a8
+
 #define CRYPTO_READ(dev, offset)		  \
 		readl_relaxed(((dev)->reg + (offset)))
 #define CRYPTO_WRITE(dev, offset, val)	  \
@@ -166,6 +192,7 @@ struct rk_crypto_info {
 	struct crypto_queue		queue;
 	struct tasklet_struct		crypto_tasklet;
 	struct ablkcipher_request	*ablk_req;
+	struct ahash_request		*ahash_req;
 	/* device lock */
 	spinlock_t			lock;
 
@@ -194,6 +221,12 @@ struct rk_crypto_info {
 			 struct scatterlist *sg_dst);
 	void (*unload_data)(struct rk_crypto_info *dev);
 };
+/* the private variable of hash */
+struct rk_ahash_ctx {
+	struct rk_crypto_info		*dev;
+	int				flag_finup;
+	int				first_op;
+};
 
 /* the private variable of cipher */
 struct rk_cipher_ctx {
@@ -201,9 +234,18 @@ struct rk_cipher_ctx {
 	unsigned int			keylen;
 };
 
+enum alg_type {
+	ALG_TYPE_HASH,
+	ALG_TYPE_CIPHER,
+};
+
 struct rk_crypto_tmp {
-	struct rk_crypto_info *dev;
-	struct crypto_alg alg;
+	struct rk_crypto_info		*dev;
+	union {
+		struct crypto_alg	crypto;
+		struct ahash_alg	hash;
+	} alg;
+	enum alg_type			type;
 };
 
 extern struct rk_crypto_tmp rk_ecb_aes_alg;
@@ -213,4 +255,8 @@ extern struct rk_crypto_tmp rk_cbc_des_alg;
 extern struct rk_crypto_tmp rk_ecb_des3_ede_alg;
 extern struct rk_crypto_tmp rk_cbc_des3_ede_alg;
 
+extern struct rk_crypto_tmp rk_ahash_sha1;
+extern struct rk_crypto_tmp rk_ahash_sha256;
+extern struct rk_crypto_tmp rk_ahash_md5;
+
 #endif
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 3624080..a260203 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -322,7 +322,7 @@ static int rk_ablk_cra_init(struct crypto_tfm *tfm)
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct rk_crypto_tmp *algt;
 
-	algt = container_of(alg, struct rk_crypto_tmp, alg);
+	algt = container_of(alg, struct rk_crypto_tmp, alg.crypto);
 
 	ctx->dev = algt->dev;
 	ctx->dev->align_size = crypto_tfm_alg_alignmask(tfm) + 1;
@@ -343,7 +343,8 @@ static void rk_ablk_cra_exit(struct crypto_tfm *tfm)
 }
 
 struct rk_crypto_tmp rk_ecb_aes_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "ecb(aes)",
 		.cra_driver_name	= "ecb-aes-rk",
 		.cra_priority		= 300,
@@ -367,7 +368,8 @@ struct rk_crypto_tmp rk_ecb_aes_alg = {
 };
 
 struct rk_crypto_tmp rk_cbc_aes_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "cbc(aes)",
 		.cra_driver_name	= "cbc-aes-rk",
 		.cra_priority		= 300,
@@ -392,7 +394,8 @@ struct rk_crypto_tmp rk_cbc_aes_alg = {
 };
 
 struct rk_crypto_tmp rk_ecb_des_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "ecb(des)",
 		.cra_driver_name	= "ecb-des-rk",
 		.cra_priority		= 300,
@@ -416,7 +419,8 @@ struct rk_crypto_tmp rk_ecb_des_alg = {
 };
 
 struct rk_crypto_tmp rk_cbc_des_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "cbc(des)",
 		.cra_driver_name	= "cbc-des-rk",
 		.cra_priority		= 300,
@@ -441,7 +445,8 @@ struct rk_crypto_tmp rk_cbc_des_alg = {
 };
 
 struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "ecb(des3_ede)",
 		.cra_driver_name	= "ecb-des3-ede-rk",
 		.cra_priority		= 300,
@@ -466,7 +471,8 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 };
 
 struct rk_crypto_tmp rk_cbc_des3_ede_alg = {
-	.alg = {
+	.type = ALG_TYPE_CIPHER,
+	.alg.crypto = {
 		.cra_name		= "cbc(des3_ede)",
 		.cra_driver_name	= "cbc-des3-ede-rk",
 		.cra_priority		= 300,
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
new file mode 100644
index 0000000..a5795f6
--- /dev/null
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -0,0 +1,394 @@
+/*
+ * Crypto acceleration support for Rockchip RK3288
+ *
+ * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author: Zain Wang <zain.wang@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
+ */
+#include "rk3288_crypto.h"
+
+/*
+ * IC can not process zero message hash,
+ * so we put the fixed hash out when met zero message.
+ */
+const static u8 *sha1_zero_message_hash = {
+	"\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
+	"\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09"
+};
+
+const static u8 *sha256_zero_message_hash = {
+	"\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
+	"\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
+	"\x27\xae\x41\xe4\x64\x9b\x93\x4c"
+	"\xa4\x95\x99\x1b\x78\x52\xb8\x55"
+};
+
+const static u8 *md5_zero_message_hash = {
+	"\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
+	"\xe9\x80\x09\x98\xec\xf8\x42\x7e"
+};
+
+
+static int zero_message_process(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	switch (crypto_ahash_digestsize(tfm)) {
+	case SHA1_DIGEST_SIZE:
+		memcpy(req->result, sha1_zero_message_hash, SHA1_DIGEST_SIZE);
+		break;
+	case SHA256_DIGEST_SIZE:
+		memcpy(req->result, sha256_zero_message_hash,
+		       SHA256_DIGEST_SIZE);
+		break;
+	case MD5_DIGEST_SIZE:
+		memcpy(req->result, md5_zero_message_hash, MD5_DIGEST_SIZE);
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	return 0;
+
+}
+
+static void rk_ahash_crypto_complete(struct rk_crypto_info *dev, int err)
+{
+	if (dev->ahash_req->base.complete)
+		dev->ahash_req->base.complete(&dev->ahash_req->base, err);
+}
+
+static void rk_ahash_hw_init(struct rk_crypto_info *dev)
+{
+	int reg_status = 0;
+
+	reg_status = CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
+		     RK_CRYPTO_HASH_FLUSH | _SBF(0xffff, 16);
+	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
+
+	reg_status = CRYPTO_READ(dev, RK_CRYPTO_CTRL);
+	reg_status &= (~RK_CRYPTO_HASH_FLUSH);
+	reg_status |= _SBF(0xffff, 16);
+	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
+
+	memset_io(dev->reg + RK_CRYPTO_HASH_DOUT_0, 0, 32);
+}
+
+static void rk_ahash_reg_init(struct rk_crypto_info *dev)
+{
+	rk_ahash_hw_init(dev);
+
+	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA, RK_CRYPTO_HRDMA_ERR_ENA |
+					    RK_CRYPTO_HRDMA_DONE_ENA);
+
+	CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, RK_CRYPTO_HRDMA_ERR_INT |
+					    RK_CRYPTO_HRDMA_DONE_INT);
+
+	CRYPTO_WRITE(dev, RK_CRYPTO_HASH_CTRL, dev->mode |
+					       RK_CRYPTO_HASH_SWAP_DO);
+
+	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, RK_CRYPTO_BYTESWAP_HRFIFO |
+					  RK_CRYPTO_BYTESWAP_BRFIFO |
+					  RK_CRYPTO_BYTESWAP_BTFIFO);
+}
+
+static int rk_ahash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct rk_crypto_info *dev = NULL;
+
+	dev = tctx->dev;
+	dev->left_bytes = 0;
+	dev->aligned = 0;
+	dev->ahash_req = req;
+	dev->mode = 0;
+	dev->align_size = 4;
+	dev->sg_dst = NULL;
+
+	tctx->first_op = 1;
+
+	switch (crypto_ahash_digestsize(tfm)) {
+	case SHA1_DIGEST_SIZE:
+		dev->mode = RK_CRYPTO_HASH_SHA1;
+		break;
+	case SHA256_DIGEST_SIZE:
+		dev->mode = RK_CRYPTO_HASH_SHA256;
+		break;
+	case MD5_DIGEST_SIZE:
+		dev->mode = RK_CRYPTO_HASH_MD5;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	rk_ahash_reg_init(dev);
+	return 0;
+}
+
+static int rk_ahash_update(struct ahash_request *req)
+{
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct rk_crypto_info *dev = tctx->dev;
+	unsigned long flags;
+	int ret;
+
+	dev->total = req->nbytes;
+	dev->left_bytes = req->nbytes;
+	dev->sg_src = req->src;
+	dev->first = req->src;
+	dev->nents = sg_nents(req->src);
+
+	/* IC can calculate 0 message hash, so it should finish update here */
+	if (!dev->total) {
+		return 0;
+	}
+
+	if (tctx->first_op) {
+		tctx->first_op = 0;
+		CRYPTO_WRITE(dev, RK_CRYPTO_HASH_MSG_LEN, dev->total);
+	} else {
+		/*
+		 * IC must know the length of total data at first,
+		 * multiple updatings cannot support this variable.
+		 */
+		dev_warn(dev->dev, "Cannot carry multiple updatings!\n");
+		return 0;
+	}
+	spin_lock_irqsave(&dev->lock, flags);
+	ret = crypto_enqueue_request(&dev->queue, &req->base);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	tasklet_schedule(&dev->crypto_tasklet);
+
+	return ret;
+}
+
+static int rk_ahash_final(struct ahash_request *req)
+{
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct rk_crypto_info *dev = tctx->dev;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	/* If met 0 message, put the fixed hash out.*/
+	if (!dev->total)
+		return zero_message_process(req);
+
+	/*
+	 * IC should process the result again after last dma interrupt.
+	 * And the last processing is very quick so than it may entry
+	 * interrupt before finishing last interrupt.
+	 * So I don't use interrupt finished hash.
+	 */
+	while (!CRYPTO_READ(dev, RK_CRYPTO_HASH_STS))
+		usleep_range(50, 100);
+
+	memcpy_fromio(req->result, dev->reg + RK_CRYPTO_HASH_DOUT_0,
+		      crypto_ahash_digestsize(tfm));
+	return 0;
+}
+
+static int rk_ahash_finup(struct ahash_request *req)
+{
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	int err;
+
+	/*
+	 * finup should process one updating and final.
+	 * and we have to wait for updating in finup so that we can
+	 * fetching result by calling rk_ahash_final in finup.
+	 */
+	tctx->flag_finup = 1;
+	err = rk_ahash_update(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		while (tctx->flag_finup)
+			/*
+			 * waiting time is relative with the last date len,
+			 * so here cannot get a fixed time.
+			 * 50-100 makes system not call here frequently wasting
+			 * efficiency, and make it response quickly when dma
+			 * complete.
+			 */
+			usleep_range(50, 100);
+
+	return rk_ahash_final(req);
+}
+
+static int rk_ahash_digest(struct ahash_request *req)
+{
+	return rk_ahash_init(req) ? -EINVAL : rk_ahash_finup(req);
+}
+
+static void crypto_ahash_dma_start(struct rk_crypto_info *dev)
+{
+	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAS, dev->addr_in);
+	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAL, (dev->count + 3) / 4);
+	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, RK_CRYPTO_HASH_START |
+					  (RK_CRYPTO_HASH_START << 16));
+}
+
+static int rk_ahash_set_data_start(struct rk_crypto_info *dev)
+{
+	int err;
+
+	err = dev->load_data(dev, dev->sg_src, NULL);
+	if (!err)
+		crypto_ahash_dma_start(dev);
+	return err;
+}
+
+static int rk_ahash_start(struct rk_crypto_info *dev)
+{
+	return rk_ahash_set_data_start(dev);
+}
+
+/*
+ * return:
+ * true: some err was occurred
+ * fault: no err, please continue
+ */
+static int rk_ahash_crypto_rx(struct rk_crypto_info *dev)
+{
+	int err = 0;
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(dev->ahash_req->base.tfm);
+
+	dev->unload_data(dev);
+	if (dev->left_bytes) {
+		if (dev->aligned) {
+			if (sg_is_last(dev->sg_src)) {
+				dev_warn(dev->dev, "[%s:%d], Lack of data\n",
+					 __func__, __LINE__);
+				err = -ENOMEM;
+				goto out_rx;
+			}
+			dev->sg_src = sg_next(dev->sg_src);
+		}
+		err = rk_ahash_set_data_start(dev);
+	} else {
+		tctx->flag_finup = 0;
+		dev->complete(dev, 0);
+	}
+
+out_rx:
+	return err;
+}
+
+static int rk_cra_hash_init(struct crypto_tfm *tfm)
+{
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct rk_crypto_tmp *algt;
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
+
+	algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
+
+	tctx->dev = algt->dev;
+	tctx->dev->addr_vir = (void *)__get_free_page(GFP_KERNEL);
+	if (!tctx->dev->addr_vir) {
+		dev_err(tctx->dev->dev, "failed to kmalloc for addr_vir\n");
+		return -ENOMEM;
+	}
+	tctx->dev->start = rk_ahash_start;
+	tctx->dev->update = rk_ahash_crypto_rx;
+	tctx->dev->complete = rk_ahash_crypto_complete;
+	return tctx->dev->enable_clk(tctx->dev);
+}
+
+static void rk_cra_hash_exit(struct crypto_tfm *tfm)
+{
+	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	free_page((unsigned long)tctx->dev->addr_vir);
+	return tctx->dev->disable_clk(tctx->dev);
+}
+
+struct rk_crypto_tmp rk_ahash_sha1 = {
+	.type = ALG_TYPE_HASH,
+	.alg.hash = {
+		.init = rk_ahash_init,
+		.update = rk_ahash_update,
+		.final = rk_ahash_final,
+		.finup = rk_ahash_finup,
+		.digest = rk_ahash_digest,
+		.halg = {
+			 .digestsize = SHA1_DIGEST_SIZE,
+			 .statesize = sizeof(struct sha1_state),
+			 .base = {
+				  .cra_name = "sha1",
+				  .cra_driver_name = "rk-sha1",
+				  .cra_priority = 300,
+				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_FALLBACK,
+				  .cra_blocksize = SHA1_BLOCK_SIZE,
+				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
+				  .cra_alignmask = 3,
+				  .cra_init = rk_cra_hash_init,
+				  .cra_exit = rk_cra_hash_exit,
+				  .cra_module = THIS_MODULE,
+				  }
+			 }
+	}
+};
+
+struct rk_crypto_tmp rk_ahash_sha256 = {
+	.type = ALG_TYPE_HASH,
+	.alg.hash = {
+	.init = rk_ahash_init,
+	.update = rk_ahash_update,
+	.final = rk_ahash_final,
+	.finup = rk_ahash_finup,
+	.digest = rk_ahash_digest,
+		.halg = {
+			 .digestsize = SHA256_DIGEST_SIZE,
+			 .statesize = sizeof(struct sha256_state),
+			 .base = {
+				  .cra_name = "sha256",
+				  .cra_driver_name = "rk-sha256",
+				  .cra_priority = 300,
+				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_FALLBACK,
+				  .cra_blocksize = SHA256_BLOCK_SIZE,
+				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
+				  .cra_alignmask = 0,
+				  .cra_init = rk_cra_hash_init,
+				  .cra_exit = rk_cra_hash_exit,
+				  .cra_module = THIS_MODULE,
+				  }
+			 }
+	}
+};
+
+struct rk_crypto_tmp rk_ahash_md5 = {
+	.type = ALG_TYPE_HASH,
+	.alg.hash = {
+		.init = rk_ahash_init,
+		.update = rk_ahash_update,
+		.final = rk_ahash_final,
+		.finup = rk_ahash_finup,
+		.digest = rk_ahash_digest,
+		.halg = {
+			 .digestsize = MD5_DIGEST_SIZE,
+			 .statesize = sizeof(struct md5_state),
+			 .base = {
+				  .cra_name = "md5",
+				  .cra_driver_name = "rk-md5",
+				  .cra_priority = 300,
+				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_FALLBACK,
+				  .cra_blocksize = SHA1_BLOCK_SIZE,
+				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
+				  .cra_alignmask = 0,
+				  .cra_init = rk_cra_hash_init,
+				  .cra_exit = rk_cra_hash_exit,
+				  .cra_module = THIS_MODULE,
+				  }
+			}
+	}
+};
-- 
1.9.1
