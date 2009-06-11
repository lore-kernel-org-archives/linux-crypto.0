From: arm-kernel@ml.breakpoint.cc
Subject: [PATCH] crypto: add support for Orion5X crypto engine
Date: Thu, 11 Jun 2009 16:03:18 +0200
Message-ID: <1244728999-8103-3-git-send-email-arm-kernel@ml.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, nico@cam.org,
	herbert@gondor.apana.org.au,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52135 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbZFKODU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 10:03:20 -0400
In-Reply-To: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This adds support for Marvell's Cryptographic Engines and Security
Accelerator (CESA) which can be found on a few SoC.
Tested with dm-crypt.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/crypto/Kconfig   |   13 +
 drivers/crypto/Makefile  |    1 +
 drivers/crypto/mv_cesa.c |  610 ++++++++++++++++++++++++++++++++++++++=
++++++++
 drivers/crypto/mv_cesa.h |  120 +++++++++
 4 files changed, 744 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/mv_cesa.c
 create mode 100644 drivers/crypto/mv_cesa.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 01afd75..0320187 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -157,6 +157,19 @@ config S390_PRNG
 	  ANSI X9.17 standard. The PRNG is usable via the char device
 	  /dev/prandom.
=20
+config CRYPTO_DEV_MV_CESA
+	tristate "Marvell's Cryptographic Engine"
+	depends on PLAT_ORION
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER2
+	help
+	  This driver allows you utilize the Cryptographic Engines and Securi=
ty
+	  Accelerator (CESA) which can be found on certain SoC like QNAP's
+	  TS-209.
+
+	  Currently the driver supports AES in ECB and CBC mode without DMA.
+
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_DES
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 9bf4a2b..6ffcb3f 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) +=3D padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) +=3D padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) +=3D ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) +=3D amcc/
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
new file mode 100644
index 0000000..22ea1b1
--- /dev/null
+++ b/drivers/crypto/mv_cesa.c
@@ -0,0 +1,610 @@
+/*
+ * Support for Marvell's crypto engine which can be found on some Orio=
n5X
+ * boards.
+ *
+ * Author: Sebastian Andrzej Siewior < sebastian at breakpoint dot cc =
>
+ * License: GPL
+ *
+ */
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <linux/crypto.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/io.h>
+#include <linux/kthread.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+
+#include <asm/cacheflush.h>
+#include "mv_cesa.h"
+/*
+ * STM:
+ *   /---------------------------------------\
+ *   |					     | request complete
+ *  \./					     |
+ * IDLE -> new request -> BUSY -> done -> DEQUEUE
+ *                         /=C2=B0\               |
+ *			    |		     | more scatter entries
+ *			    \________________/
+ */
+enum engine_status {
+	ENGINE_IDLE,
+	ENGINE_BUSY,
+	ENGINE_W_DEQUEUE,
+};
+
+/**
+ * struct req_progress - used for every crypt request
+ * @src_sg_it:		sg iterator for src
+ * @dst_sg_it:		sg iterator for dst
+ * @sg_src_left:	bytes left in src to process (scatter list)
+ * @src_start:		offset to add to src start position (scatter list)
+ * @crypt_len:		length of current crypt process
+ * @sg_dst_left:	bytes left dst to process in this scatter list
+ * @dst_start:		offset to add to dst start position (scatter list)
+ * @total_req_bytes:	total number of bytes processed (request).
+ *
+ * sg helper are used to iterate over the scatterlist. Since the size =
of the
+ * SRAM may be less than the scatter size, this struct struct is used =
to keep
+ * track of progress within current scatterlist.
+ */
+struct req_progress {
+	struct sg_mapping_iter src_sg_it;
+	struct sg_mapping_iter dst_sg_it;
+
+	/* src mostly */
+	int sg_src_left;
+	int src_start;
+	int crypt_len;
+	/* dst mostly */
+	int sg_dst_left;
+	int dst_start;
+	int total_req_bytes;
+};
+
+struct crypto_priv {
+	void __iomem *reg;
+	void __iomem *sram;
+	int irq;
+	struct task_struct *queue_th;
+
+	/* the lock protects queue and eng_st */
+	spinlock_t lock;
+	struct crypto_queue queue;
+	enum engine_status eng_st;
+	struct ablkcipher_request *cur_req;
+	struct req_progress p;
+};
+
+static struct crypto_priv *cpg;
+
+struct mv_ctx {
+	u8 aes_enc_key[AES_KEY_LEN];
+	u32 aes_dec_key[8];
+	int key_len;
+	u32 need_calc_aes_dkey;
+};
+
+enum crypto_op {
+	COP_AES_ECB,
+	COP_AES_CBC,
+};
+
+struct mv_req_ctx {
+	enum crypto_op op;
+	int decrypt;
+};
+
+static void compute_aes_dec_key(struct mv_ctx *ctx)
+{
+	struct crypto_aes_ctx gen_aes_key;
+	int key_pos;
+
+	if (!ctx->need_calc_aes_dkey)
+		return;
+
+	crypto_aes_expand_key(&gen_aes_key, ctx->aes_enc_key, ctx->key_len);
+
+	key_pos =3D ctx->key_len + 24;
+	memcpy(ctx->aes_dec_key, &gen_aes_key.key_enc[key_pos], 4 * 4);
+	switch (ctx->key_len) {
+	case AES_KEYSIZE_256:
+		key_pos -=3D 2;
+		/* fall */
+	case AES_KEYSIZE_192:
+		key_pos -=3D 2;
+		memcpy(&ctx->aes_dec_key[4], &gen_aes_key.key_enc[key_pos],
+				4 * 4);
+		break;
+	}
+	ctx->need_calc_aes_dkey =3D 0;
+}
+
+static int mv_setkey_aes(struct crypto_ablkcipher *cipher, const u8 *k=
ey,
+		unsigned int len)
+{
+	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
+	struct mv_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	switch (len) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	ctx->key_len =3D len;
+	ctx->need_calc_aes_dkey =3D 1;
+
+	memcpy(ctx->aes_enc_key, key, AES_KEY_LEN);
+	return 0;
+}
+
+static void setup_data_in(struct ablkcipher_request *req)
+{
+	int ret;
+	void *buf;
+
+	if (!cpg->p.sg_src_left) {
+		ret =3D sg_miter_next(&cpg->p.src_sg_it);
+		BUG_ON(!ret);
+		cpg->p.sg_src_left =3D cpg->p.src_sg_it.length;
+		cpg->p.src_start =3D 0;
+	}
+
+	cpg->p.crypt_len =3D min(cpg->p.sg_src_left, MAX_REQ_SIZE);
+
+	buf =3D cpg->p.src_sg_it.addr;
+	buf +=3D cpg->p.src_start;
+
+	memcpy(cpg->sram + SRAM_DATA_IN_START, buf, cpg->p.crypt_len);
+
+	cpg->p.sg_src_left -=3D cpg->p.crypt_len;
+	cpg->p.src_start +=3D cpg->p.crypt_len;
+}
+
+static void mv_process_current_q(int first_block)
+{
+	struct ablkcipher_request *req =3D cpg->cur_req;
+	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+	struct sec_accel_config op;
+
+	switch (req_ctx->op) {
+	case COP_AES_ECB:
+		op.config =3D CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
+		break;
+	case COP_AES_CBC:
+		op.config =3D CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
+		op.enc_iv =3D ENC_IV_POINT(SRAM_DATA_IV) |
+			ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);
+		if (first_block)
+			memcpy(cpg->sram + SRAM_DATA_IV, req->info, 16);
+		break;
+	}
+	if (req_ctx->decrypt) {
+		op.config |=3D CFG_DIR_DEC;
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key,
+				AES_KEY_LEN);
+	} else {
+		op.config |=3D CFG_DIR_ENC;
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key,
+				AES_KEY_LEN);
+	}
+
+	switch (ctx->key_len) {
+	case AES_KEYSIZE_128:
+		op.config |=3D CFG_AES_LEN_128;
+		break;
+	case AES_KEYSIZE_192:
+		op.config |=3D CFG_AES_LEN_192;
+		break;
+	case AES_KEYSIZE_256:
+		op.config |=3D CFG_AES_LEN_256;
+		break;
+	}
+	op.enc_p =3D ENC_P_SRC(SRAM_DATA_IN_START) |
+		ENC_P_DST(SRAM_DATA_OUT_START);
+	op.enc_key_p =3D SRAM_DATA_KEY_P;
+
+	setup_data_in(req);
+	op.enc_len =3D cpg->p.crypt_len;
+	memcpy(cpg->sram + SRAM_CONFIG, &op,
+			sizeof(struct sec_accel_config));
+
+	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
+	/* GO */
+	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
+
+	/*
+	 * XXX: add timer if the interrupt does not occur for some mystery
+	 * reason
+	 */
+}
+
+static void mv_crypto_algo_completion(void)
+{
+	struct ablkcipher_request *req =3D cpg->cur_req;
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+
+	if (req_ctx->op !=3D COP_AES_CBC)
+		return ;
+
+	memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
+}
+
+static void dequeue_complete_req(void)
+{
+	struct ablkcipher_request *req =3D cpg->cur_req;
+	void *buf;
+	int ret;
+
+	cpg->p.total_req_bytes +=3D cpg->p.crypt_len;
+	do {
+		int dst_copy;
+
+		if (!cpg->p.sg_dst_left) {
+			ret =3D sg_miter_next(&cpg->p.dst_sg_it);
+			BUG_ON(!ret);
+			cpg->p.sg_dst_left =3D cpg->p.dst_sg_it.length;
+			cpg->p.dst_start =3D 0;
+		}
+
+		buf =3D cpg->p.dst_sg_it.addr;
+		buf +=3D cpg->p.dst_start;
+
+		dst_copy =3D min(cpg->p.crypt_len, cpg->p.sg_dst_left);
+
+		memcpy(buf, cpg->sram + SRAM_DATA_OUT_START, dst_copy);
+		/*
+		 * XXX This is a temporary hack to flush data from cache back
+		 * into phys ram so user space sees correct data. This goes
+		 * away as soon as DMA support is added to this driver
+		 */
+		dmac_flush_range(buf, buf + dst_copy);
+
+		cpg->p.sg_dst_left -=3D dst_copy;
+		cpg->p.crypt_len -=3D dst_copy;
+		cpg->p.dst_start +=3D dst_copy;
+	} while (cpg->p.crypt_len > 0);
+
+	BUG_ON(cpg->eng_st !=3D ENGINE_W_DEQUEUE);
+	if (cpg->p.total_req_bytes < req->nbytes) {
+		/* process next scatter list entry */
+		cpg->eng_st =3D ENGINE_BUSY;
+		mv_process_current_q(0);
+	} else {
+		sg_miter_stop(&cpg->p.src_sg_it);
+		sg_miter_stop(&cpg->p.dst_sg_it);
+		mv_crypto_algo_completion();
+		cpg->eng_st =3D ENGINE_IDLE;
+		req->base.complete(&req->base, 0);
+	}
+}
+
+static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
+{
+	int i =3D 0;
+
+	do {
+		total_bytes -=3D sl[i].length;
+		i++;
+
+	} while (total_bytes > 0);
+
+	return i;
+}
+
+static void mv_enqueue_new_req(struct ablkcipher_request *req)
+{
+	int num_sgs;
+
+	cpg->cur_req =3D req;
+	memset(&cpg->p, 0, sizeof(struct req_progress));
+
+	num_sgs =3D count_sgs(req->src, req->nbytes);
+	sg_miter_start(&cpg->p.src_sg_it, req->src, num_sgs, 0);
+
+	num_sgs =3D count_sgs(req->dst, req->nbytes);
+	sg_miter_start(&cpg->p.dst_sg_it, req->dst, num_sgs, 0);
+	mv_process_current_q(1);
+}
+
+static int queue_manag(void *data)
+{
+	cpg->eng_st =3D ENGINE_IDLE;
+	do {
+		struct ablkcipher_request *req;
+		struct crypto_async_request *async_req =3D NULL;
+		struct crypto_async_request *backlog;
+
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		if (cpg->eng_st =3D=3D ENGINE_W_DEQUEUE)
+			dequeue_complete_req();
+
+		spin_lock_irq(&cpg->lock);
+		if (cpg->eng_st =3D=3D ENGINE_IDLE) {
+			backlog =3D crypto_get_backlog(&cpg->queue);
+			async_req =3D crypto_dequeue_request(&cpg->queue);
+			if (async_req) {
+				BUG_ON(cpg->eng_st !=3D ENGINE_IDLE);
+				cpg->eng_st =3D ENGINE_BUSY;
+			}
+		}
+		spin_unlock_irq(&cpg->lock);
+
+		if (backlog) {
+			backlog->complete(backlog, -EINPROGRESS);
+			backlog =3D NULL;
+		}
+
+		if (async_req) {
+			req =3D container_of(async_req,
+					struct ablkcipher_request, base);
+			mv_enqueue_new_req(req);
+			async_req =3D NULL;
+		}
+
+		schedule();
+
+	} while (!kthread_should_stop());
+	return 0;
+}
+
+static int mv_handle_req(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&cpg->lock, flags);
+	ret =3D ablkcipher_enqueue_request(&cpg->queue, req);
+	spin_unlock_irqrestore(&cpg->lock, flags);
+	wake_up_process(cpg->queue_th);
+	return ret;
+}
+
+static int mv_enc_aes_ecb(struct ablkcipher_request *req)
+{
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+
+	req_ctx->op =3D COP_AES_ECB;
+	req_ctx->decrypt =3D 0;
+
+	return mv_handle_req(req);
+}
+
+static int mv_dec_aes_ecb(struct ablkcipher_request *req)
+{
+	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+
+	req_ctx->op =3D COP_AES_ECB;
+	req_ctx->decrypt =3D 1;
+
+	compute_aes_dec_key(ctx);
+	return mv_handle_req(req);
+}
+
+static int mv_enc_aes_cbc(struct ablkcipher_request *req)
+{
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+
+	req_ctx->op =3D COP_AES_CBC;
+	req_ctx->decrypt =3D 0;
+
+	return mv_handle_req(req);
+}
+
+static int mv_dec_aes_cbc(struct ablkcipher_request *req)
+{
+	struct mv_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	struct mv_req_ctx *req_ctx =3D ablkcipher_request_ctx(req);
+
+	req_ctx->op =3D COP_AES_CBC;
+	req_ctx->decrypt =3D 1;
+
+	compute_aes_dec_key(ctx);
+	return mv_handle_req(req);
+}
+
+static int mv_cra_init(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize =3D sizeof(struct mv_req_ctx);
+	return 0;
+}
+
+irqreturn_t crypto_int(int irq, void *priv)
+{
+	u32 val;
+
+	val =3D readl(cpg->reg + SEC_ACCEL_INT_STATUS);
+	if (!(val & SEC_INT_ACCEL0_DONE))
+		return IRQ_NONE;
+
+	val &=3D ~SEC_INT_ACCEL0_DONE;
+	writel(val, cpg->reg + FPGA_INT_STATUS);
+	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
+	BUG_ON(cpg->eng_st !=3D ENGINE_BUSY);
+	cpg->eng_st =3D ENGINE_W_DEQUEUE;
+	wake_up_process(cpg->queue_th);
+	return IRQ_HANDLED;
+}
+
+struct crypto_alg mv_aes_alg_ecb =3D {
+	.cra_name		=3D "ecb(aes)",
+	.cra_driver_name	=3D "mv-ecb-aes",
+	.cra_priority	=3D 300,
+	.cra_flags	=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize	=3D 16,
+	.cra_ctxsize	=3D sizeof(struct mv_ctx),
+	.cra_alignmask	=3D 0,
+	.cra_type	=3D &crypto_ablkcipher_type,
+	.cra_module	=3D THIS_MODULE,
+	.cra_init	=3D mv_cra_init,
+	.cra_u		=3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D	AES_MIN_KEY_SIZE,
+			.max_keysize	=3D	AES_MAX_KEY_SIZE,
+			.setkey		=3D	mv_setkey_aes,
+			.encrypt	=3D	mv_enc_aes_ecb,
+			.decrypt	=3D	mv_dec_aes_ecb,
+		},
+	},
+};
+
+struct crypto_alg mv_aes_alg_cbc =3D {
+	.cra_name		=3D "cbc(aes)",
+	.cra_driver_name	=3D "mv-cbc-aes",
+	.cra_priority	=3D 300,
+	.cra_flags	=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize	=3D AES_BLOCK_SIZE,
+	.cra_ctxsize	=3D sizeof(struct mv_ctx),
+	.cra_alignmask	=3D 0,
+	.cra_type	=3D &crypto_ablkcipher_type,
+	.cra_module	=3D THIS_MODULE,
+	.cra_init	=3D mv_cra_init,
+	.cra_u		=3D {
+		.ablkcipher =3D {
+			.ivsize		=3D	AES_BLOCK_SIZE,
+			.min_keysize	=3D	AES_MIN_KEY_SIZE,
+			.max_keysize	=3D	AES_MAX_KEY_SIZE,
+			.setkey		=3D	mv_setkey_aes,
+			.encrypt	=3D	mv_enc_aes_cbc,
+			.decrypt	=3D	mv_dec_aes_cbc,
+		},
+	},
+};
+
+static int m_probe(struct platform_device *pdev)
+{
+	struct crypto_priv *cp;
+	struct resource *res;
+	int irq;
+	int ret;
+
+	if (cpg) {
+		printk(KERN_ERR "Second crypto dev?\n");
+		return -EEXIST;
+	}
+
+	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	if (!res)
+		return -ENXIO;
+
+	cp =3D kzalloc(sizeof(*cp), GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	spin_lock_init(&cp->lock);
+	crypto_init_queue(&cp->queue, 50);
+	cp->reg =3D ioremap(res->start, res->end - res->start + 1);
+	if (!cp->reg) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
+	if (!res) {
+		ret =3D -ENXIO;
+		goto err_unmap_reg;
+	}
+
+	cp->sram =3D ioremap(res->start, res->end - res->start + 1);
+	if (!cp->sram) {
+		ret =3D -ENOMEM;
+		goto err_unmap_reg;
+	}
+
+	irq =3D platform_get_irq(pdev, 0);
+	if (irq < 0 || irq =3D=3D NO_IRQ) {
+		ret =3D irq;
+		goto err_unmap_sram;
+	}
+	cp->irq =3D irq;
+
+	platform_set_drvdata(pdev, cp);
+	cpg =3D cp;
+
+	cp->queue_th =3D kthread_run(queue_manag, cp, "mv_crypto");
+	if (IS_ERR(cp->queue_th)) {
+		ret =3D PTR_ERR(cp->queue_th);
+		goto err_thread;
+	}
+
+	ret =3D request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->d=
ev),
+			cp);
+	if (ret)
+		goto err_unmap_sram;
+
+	writel(SEC_INT_ACCEL0_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
+	writel(SEC_CFG_STOP_DIG_ERR, cpg->reg + SEC_ACCEL_CFG);
+
+	ret =3D crypto_register_alg(&mv_aes_alg_ecb);
+	if (ret)
+		goto err_reg;
+
+	ret =3D crypto_register_alg(&mv_aes_alg_cbc);
+	if (ret)
+		goto err_unreg_ecb;
+	return 0;
+err_unreg_ecb:
+	crypto_unregister_alg(&mv_aes_alg_ecb);
+err_thread:
+	free_irq(irq, cp);
+err_reg:
+	kthread_stop(cp->queue_th);
+err_unmap_sram:
+	iounmap(cp->sram);
+err_unmap_reg:
+	iounmap(cp->reg);
+err:
+	kfree(cp);
+	cpg =3D NULL;
+	platform_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+static int m_remove(struct platform_device *pdev)
+{
+	struct crypto_priv *cp =3D platform_get_drvdata(pdev);
+
+	crypto_unregister_alg(&mv_aes_alg_ecb);
+	crypto_unregister_alg(&mv_aes_alg_cbc);
+	kthread_stop(cp->queue_th);
+	free_irq(cp->irq, cp);
+	memset(cp->sram, 0, 8 * 1024);
+	iounmap(cp->sram);
+	iounmap(cp->reg);
+	kfree(cp);
+	cpg =3D NULL;
+	return 0;
+}
+
+static struct platform_driver marvell_crypto =3D {
+	.probe          =3D m_probe,
+	.remove         =3D m_remove,
+	.driver         =3D {
+		.owner  =3D THIS_MODULE,
+		.name   =3D "mv,orion5x-crypto",
+	},
+};
+
+static int __init crypto_init(void)
+{
+	return platform_driver_register(&marvell_crypto);
+}
+module_init(crypto_init);
+
+static void __exit crypto_exit(void)
+{
+	platform_driver_unregister(&marvell_crypto);
+}
+module_exit(crypto_exit);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior <sebastian@breakpoint.cc>");
+MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
new file mode 100644
index 0000000..7198be9
--- /dev/null
+++ b/drivers/crypto/mv_cesa.h
@@ -0,0 +1,120 @@
+#ifndef __MV_CRYPTO_H__
+
+#define DIGEST_INITIAL_VAL_A	0xdd00
+#define DES_CMD_REG		0xdd58
+
+#define SEC_ACCEL_CMD		0xde00
+#define SEC_CMD_EN_SEC_ACCL0	(1 << 0)
+#define SEC_CMD_EN_SEC_ACCL1	(1 << 1)
+#define SEC_CMD_DISABLE_SEC	(1 << 2)
+
+#define SEC_ACCEL_DESC_P0	0xde04
+#define SEC_DESC_P0_PTR(x)	(x)
+
+#define SEC_ACCEL_DESC_P1	0xde14
+#define SEC_DESC_P1_PTR(x)	(x)
+
+#define SEC_ACCEL_CFG		0xde08
+#define SEC_CFG_STOP_DIG_ERR	(1 << 0)
+#define SEC_CFG_CH0_W_IDMA	(1 << 7)
+#define SEC_CFG_CH1_W_IDMA	(1 << 8)
+#define SEC_CFG_ACT_CH0_IDMA	(1 << 9)
+#define SEC_CFG_ACT_CH1_IDMA	(1 << 10)
+
+#define SEC_ACCEL_STATUS	0xde0c
+#define SEC_ST_ACT_0		(1 << 0)
+#define SEC_ST_ACT_1		(1 << 1)
+
+/*
+ * FPGA_INT_STATUS looks like a FPGA leftover and is undocumented. I a=
summe
+ * that it was part of an IRQ-controller in FPGA and someone forgot to=
 remove
+ * it while switching to the core and moving to SEC_ACCEL_INT_STATUS.
+ */
+#define FPGA_INT_STATUS		0xdd68
+#define SEC_ACCEL_INT_STATUS	0xde20
+#define SEC_INT_AUTH_DONE	(1 << 0)
+#define SEC_INT_DES_E_DONE	(1 << 1)
+#define SEC_INT_AES_E_DONE	(1 << 2)
+#define SEC_INT_AES_D_DONE	(1 << 3)
+#define SEC_INT_ENC_DONE	(1 << 4)
+#define SEC_INT_ACCEL0_DONE	(1 << 5)
+#define SEC_INT_ACCEL1_DONE	(1 << 6)
+#define SEC_INT_ACC0_IDMA_DONE	(1 << 7)
+#define SEC_INT_ACC1_IDMA_DONE	(1 << 8)
+
+#define SEC_ACCEL_INT_MASK	0xde24
+
+#define AES_KEY_LEN	(8 * 4)
+
+struct sec_accel_config {
+
+	u32 config;
+#define CFG_OP_MAC_ONLY		0
+#define CFG_OP_CRYPT_ONLY	1
+#define CFG_OP_MAC_CRYPT	2
+#define CFG_OP_CRYPT_MAC	3
+#define CFG_MACM_MD5		(4 << 4)
+#define CFG_MACM_SHA1		(5 << 4)
+#define CFG_MACM_HMAC_MD5	(6 << 4)
+#define CFG_MACM_HMAC_SHA1	(7 << 4)
+#define CFG_ENCM_DES		(1 << 8)
+#define CFG_ENCM_3DES		(2 << 8)
+#define CFG_ENCM_AES		(3 << 8)
+#define CFG_DIR_ENC		(0 << 12)
+#define CFG_DIR_DEC		(1 << 12)
+#define CFG_ENC_MODE_ECB	(0 << 16)
+#define CFG_ENC_MODE_CBC	(1 << 16)
+#define CFG_3DES_EEE		(0 << 20)
+#define CFG_3DES_EDE		(1 << 20)
+#define CFG_AES_LEN_128		(0 << 24)
+#define CFG_AES_LEN_192		(1 << 24)
+#define CFG_AES_LEN_256		(2 << 24)
+
+	u32 enc_p;
+#define ENC_P_SRC(x)		(x)
+#define ENC_P_DST(x)		((x) << 16)
+
+	u32 enc_len;
+#define ENC_LEN(x)		(x)
+
+	u32 enc_key_p;
+#define ENC_KEY_P(x)		(x)
+
+	u32 enc_iv;
+#define ENC_IV_POINT(x)		((x) << 0)
+#define ENC_IV_BUF_POINT(x)	((x) << 16)
+
+	u32 mac_src_p;
+#define MAC_SRC_DATA_P(x)	(x)
+#define MAC_SRC_TOTAL_LEN(x)	((x) << 16)
+
+	u32 mac_digest;
+	u32 mac_iv;
+}__attribute__ ((packed));
+	/*
+	 * /-----------\ 0
+	 * | ACCEL CFG |	4 * 8
+	 * |-----------| 0x20
+	 * | CRYPT KEY |	8 * 4
+	 * |-----------| 0x40
+	 * |  IV   IN  |	4 * 4
+	 * |-----------| 0x40 (inplace)
+	 * |  IV BUF   |	4 * 4
+	 * |-----------| 0x50
+	 * |  DATA IN  |	16 * x (max MAX_REQ_SIZE)
+	 * |-----------| 0x50 (inplace operation)
+	 * |  DATA OUT |	16 * x (max MAX_REQ_SIZE)
+	 * |-----------| 0x1f90
+	 * |   nuttin  |
+	 * \-----------/ 0x2000
+	 */
+#define SRAM_CONFIG		0x00
+#define SRAM_DATA_KEY_P		0x20
+#define SRAM_DATA_IV		0x40
+#define SRAM_DATA_IV_BUF	0x40
+#define SRAM_DATA_IN_START	0x50
+#define SRAM_DATA_OUT_START	0x50
+
+#define MAX_REQ_SIZE	(8000)
+
+#endif
--=20
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
