From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v8 4/4] crypto: Add Allwinner Security System
 crypto accelerator
Date: Thu, 23 Apr 2015 08:45:23 +0200
Message-ID: <1429771523-2936-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1429771523-2936-1-git-send-email-clabbe.montjoie@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org,
	mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
	mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org,
	joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
	tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org,
	arnd-r2nGTMty4D4@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBGFK4KUQKGQERECD6MY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1429771523-2936-1-git-send-email-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Add support for the Security System included in Allwinner SoC A20.
The Security System is a hardware cryptographic accelerator that support:
- MD5 and SHA1 hash algorithms
- AES block cipher in CBC/ECB mode with 128/196/256bits keys.
- DES and 3DES block cipher in CBC/ECB mode

Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/Kconfig                    |  17 ++
 drivers/crypto/Makefile                   |   1 +
 drivers/crypto/sunxi-ss/Makefile          |   2 +
 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c | 432 +++++++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-core.c   | 411 +++++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-hash.c   | 481 ++++++++++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss.h        | 198 ++++++++++++
 7 files changed, 1542 insertions(+)
 create mode 100644 drivers/crypto/sunxi-ss/Makefile
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-core.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 800bf41..46eed08 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -458,4 +458,21 @@ config CRYPTO_DEV_IMGTEC_HASH
 	  hardware hash accelerator. Supporting MD5/SHA1/SHA224/SHA256
 	  hashing algorithms.
 
+config CRYPTO_DEV_SUNXI_SS
+	tristate "Support for Allwinner Security System cryptographic accelerator"
+	depends on ARCH_SUNXI
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  Some Allwinner SoC have a crypto accelerator named
+	  Security System. Select this if you want to use it.
+	  The Security System handle AES/DES/3DES ciphers in CBC mode
+	  and SHA1 and MD5 hash algorithms.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index fb84be7..bf7be82 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
 obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss/
diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
new file mode 100644
index 0000000..8bb287d
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss.o
+sunxi-ss-y += sunxi-ss-core.o sunxi-ss-hash.o sunxi-ss-cipher.o
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
new file mode 100644
index 0000000..30ff942
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
@@ -0,0 +1,432 @@
+/*
+ * sunxi-ss-cipher.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2015 Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * This file add support for AES cipher with 128,192,256 bits
+ * keysize in CBC mode.
+ * Add support also for DES and 3DES in CBC mode.
+ *
+ * You could find the datasheet in Documentation/arm/sunxi/README
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "sunxi-ss.h"
+
+/* CBC AES */
+int sunxi_ss_cbc_aes_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_AES | SS_CBC | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_aes_poll(areq, mode);
+}
+
+int sunxi_ss_cbc_aes_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_AES | SS_CBC | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_aes_poll(areq, mode);
+}
+
+/* ECB AES */
+int sunxi_ss_ecb_aes_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_AES | SS_ECB | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_aes_poll(areq, mode);
+}
+
+int sunxi_ss_ecb_aes_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_AES | SS_ECB | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_aes_poll(areq, mode);
+}
+
+/* CBC DES */
+int sunxi_ss_cbc_des_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_DES | SS_CBC | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+int sunxi_ss_cbc_des_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_DES | SS_CBC | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+/* ECB DES */
+int sunxi_ss_ecb_des_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_DES | SS_ECB | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+int sunxi_ss_ecb_des_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_DES | SS_ECB | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+/* CBC 3DES */
+int sunxi_ss_cbc_des3_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_3DES | SS_CBC | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+int sunxi_ss_cbc_des3_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_3DES | SS_CBC | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+/* ECB 3DES */
+int sunxi_ss_ecb_des3_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_3DES | SS_ECB | SS_ENABLED | SS_ENCRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+int sunxi_ss_ecb_des3_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	u32 mode;
+
+	mode = SS_OP_3DES | SS_ECB | SS_ENABLED | SS_DECRYPTION | op->keymode;
+	return sunxi_ss_des_poll(areq, mode);
+}
+
+int sunxi_ss_cipher_init(struct crypto_tfm *tfm)
+{
+	struct sunxi_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sunxi_ss_alg_template *algt;
+
+	memset(op, 0, sizeof(struct sunxi_tfm_ctx));
+
+	algt = container_of(alg, struct sunxi_ss_alg_template, alg.crypto);
+	op->ss = algt->ss;
+
+	return 0;
+}
+
+int sunxi_ss_cipher_des_init(struct crypto_tfm *tfm)
+{
+	const char *name = crypto_tfm_alg_name(tfm);
+	struct sunxi_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sunxi_ss_alg_template *algt;
+	struct sunxi_ss_ctx *ss;
+
+	memset(op, 0, sizeof(struct sunxi_tfm_ctx));
+
+	algt = container_of(alg, struct sunxi_ss_alg_template, alg.crypto);
+	ss = algt->ss;
+	op->ss = algt->ss;
+
+	op->fallback = crypto_alloc_ablkcipher(name, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(op->fallback)) {
+		dev_err(ss->dev, "ERROR: allocating fallback algo %s\n", name);
+		return PTR_ERR(op->fallback);
+	}
+	return 0;
+}
+
+void sunxi_ss_cipher_exit(struct crypto_tfm *tfm)
+{
+	struct sunxi_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_ablkcipher(ctx->fallback);
+	ctx->fallback = NULL;
+}
+
+int sunxi_ss_aes_poll(struct ablkcipher_request *areq, u32 mode)
+{
+	u32 spaces;
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sunxi_ss_ctx *ss = op->ss;
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
+	/* when activating SS, the default FIFO space is 32 */
+	u32 rx_cnt = 32;
+	u32 tx_cnt = 0;
+	u32 v;
+	int i, sgnum, err = 0;
+	unsigned int ileft = areq->nbytes;
+	unsigned int oleft = areq->nbytes;
+	unsigned int todo, miter_flag;
+	unsigned long flags;
+	struct sg_mapping_iter mi, mo;
+	unsigned int oi, oo; /* offset for in and out */
+
+	if (areq->nbytes == 0)
+		return 0;
+
+	if (areq->info == NULL) {
+		dev_err(ss->dev, "ERROR: Empty IV\n");
+		return -EINVAL;
+	}
+
+	if (areq->src == NULL || areq->dst == NULL) {
+		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ss->slock, flags);
+
+	for (i = 0; i < op->keylen; i += 4)
+		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+
+	if (areq->info != NULL) {
+		for (i = 0; i < 4 && i < ivsize / 4; i++) {
+			v = *(u32 *)(areq->info + i * 4);
+			writel(v, ss->base + SS_IV0 + i * 4);
+		}
+	}
+	writel(mode, ss->base + SS_CTL);
+
+	sgnum = sg_nents(areq->src);
+	if (sgnum == 1)
+		miter_flag = SG_MITER_FROM_SG | SG_MITER_ATOMIC;
+	else
+		miter_flag = SG_MITER_FROM_SG;
+	sg_miter_start(&mi, areq->src, sgnum, miter_flag);
+	sgnum = sg_nents(areq->dst);
+	if (sgnum == 1)
+		miter_flag = SG_MITER_TO_SG | SG_MITER_ATOMIC;
+	else
+		miter_flag = SG_MITER_TO_SG;
+	sg_miter_start(&mo, areq->dst, sgnum, miter_flag);
+	sg_miter_next(&mi);
+	sg_miter_next(&mo);
+	if (mi.addr == NULL || mo.addr == NULL) {
+		err = -EINVAL;
+		goto release_ss;
+	}
+
+	ileft = areq->nbytes / 4;
+	oleft = areq->nbytes / 4;
+	oi = 0;
+	oo = 0;
+	do {
+		todo = min3(rx_cnt, ileft, (mi.length - oi) / 4);
+		if (todo > 0) {
+			ileft -= todo;
+			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
+			oi += todo * 4;
+		}
+		if (oi == mi.length) {
+			sg_miter_next(&mi);
+			oi = 0;
+		}
+
+		spaces = readl_relaxed(ss->base + SS_FCSR);
+		rx_cnt = SS_RXFIFO_SPACES(spaces);
+		tx_cnt = SS_TXFIFO_SPACES(spaces);
+
+		todo = min3(tx_cnt, oleft, (mo.length - oo) / 4);
+		if (todo > 0) {
+			oleft -= todo;
+			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
+			oo += todo * 4;
+		}
+		if (oo == mo.length) {
+			sg_miter_next(&mo);
+			oo = 0;
+		}
+	} while (mo.length > 0);
+
+release_ss:
+	sg_miter_stop(&mi);
+	sg_miter_stop(&mo);
+	writel_relaxed(0, ss->base + SS_CTL);
+	spin_unlock_irqrestore(&ss->slock, flags);
+	return err;
+}
+
+/* Pure CPU driven way of doing DES/3DES with SS */
+int sunxi_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sunxi_ss_ctx *ss = op->ss;
+	int i, err = 0;
+	int no_chunk = 1;
+	struct scatterlist *in_sg = areq->src;
+	struct scatterlist *out_sg = areq->dst;
+	u8 kkey[256 / 8];
+
+	if (areq->nbytes == 0)
+		return 0;
+
+	if (areq->info == NULL) {
+		dev_err(ss->dev, "ERROR: Empty IV\n");
+		return -EINVAL;
+	}
+
+	if (areq->src == NULL || areq->dst == NULL) {
+		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * if we have only SGs with size multiple of 4,
+	 * we can use the SS AES function
+	 */
+	while (in_sg != NULL && no_chunk == 1) {
+		if ((in_sg->length % 4) != 0)
+			no_chunk = 0;
+		in_sg = sg_next(in_sg);
+	}
+	while (out_sg != NULL && no_chunk == 1) {
+		if ((out_sg->length % 4) != 0)
+			no_chunk = 0;
+		out_sg = sg_next(out_sg);
+	}
+
+	if (no_chunk == 1)
+		return sunxi_ss_aes_poll(areq, mode);
+
+	/*
+	 * if some SG are not multiple of 4bytes use a fallback
+	 * it is much easy and clean
+	 */
+	ablkcipher_request_set_tfm(areq, op->fallback);
+	for (i = 0; i < op->keylen; i++)
+		*(u32 *)(kkey + i * 4) = op->key[i];
+
+	err = crypto_ablkcipher_setkey(op->fallback, kkey, op->keylen);
+	if (err != 0) {
+		dev_err(ss->dev, "Cannot set key on fallback\n");
+		return -EINVAL;
+	}
+
+	if ((mode & SS_DECRYPTION) == SS_DECRYPTION)
+		err = crypto_ablkcipher_decrypt(areq);
+	else
+		err = crypto_ablkcipher_encrypt(areq);
+	ablkcipher_request_set_tfm(areq, tfm);
+	return err;
+}
+
+/* check and set the AES key, prepare the mode to be used */
+int sunxi_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sunxi_ss_ctx *ss = op->ss;
+
+	switch (keylen) {
+	case 128 / 8:
+		op->keymode = SS_AES_128BITS;
+		break;
+	case 192 / 8:
+		op->keymode = SS_AES_192BITS;
+		break;
+	case 256 / 8:
+		op->keymode = SS_AES_256BITS;
+		break;
+	default:
+		dev_err(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
+
+/* check and set the DES key, prepare the mode to be used */
+int sunxi_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sunxi_ss_ctx *ss = op->ss;
+	u32 flags;
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	if (unlikely(keylen != DES_KEY_SIZE)) {
+		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	flags = crypto_ablkcipher_get_flags(tfm);
+
+	ret = des_ekey(tmp, key);
+	if (unlikely(ret == 0) && (flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+		dev_dbg(ss->dev, "Weak key %u\n", keylen);
+		return -EINVAL;
+	}
+
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
+
+/* check and set the 3DES key, prepare the mode to be used */
+int sunxi_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sunxi_ss_ctx *ss = op->ss;
+
+	if (unlikely(keylen != 3 * DES_KEY_SIZE)) {
+		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-core.c b/drivers/crypto/sunxi-ss/sunxi-ss-core.c
new file mode 100644
index 0000000..1569be4
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-core.c
@@ -0,0 +1,411 @@
+/*
+ * sunxi-ss-core.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2015 Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * Core file which registers crypto algorithms supported by the SS.
+ *
+ * You could find a link for the datasheet in Documentation/arm/sunxi/README
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <crypto/scatterwalk.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#include "sunxi-ss.h"
+
+static struct sunxi_ss_alg_template driver_algs[] = {
+{       .type = CRYPTO_ALG_TYPE_AHASH,
+	.alg.hash = {
+		.init = sunxi_hash_init,
+		.update = sunxi_hash_update,
+		.final = sunxi_hash_final,
+		.finup = sunxi_hash_finup,
+		.digest = sunxi_hash_digest,
+		.export = sunxi_hash_export,
+		.import = sunxi_hash_import,
+		.halg = {
+			.digestsize = MD5_DIGEST_SIZE,
+			.base = {
+				.cra_name = "md5",
+				.cra_driver_name = "md5-sunxi-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC,
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_type = &crypto_ahash_type,
+				.cra_init = sunxi_hash_crainit
+			}
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_AHASH,
+	.alg.hash = {
+		.init = sunxi_hash_init,
+		.update = sunxi_hash_update,
+		.final = sunxi_hash_final,
+		.finup = sunxi_hash_finup,
+		.digest = sunxi_hash_digest,
+		.export = sunxi_hash_export,
+		.import = sunxi_hash_import,
+		.halg = {
+			.digestsize = SHA1_DIGEST_SIZE,
+			.base = {
+				.cra_name = "sha1",
+				.cra_driver_name = "sha1-sunxi-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC,
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_type = &crypto_ahash_type,
+				.cra_init = sunxi_hash_crainit
+			}
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+		.cra_name = "cbc(aes)",
+		.cra_driver_name = "cbc-aes-sunxi-ss",
+		.cra_priority = 300,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+			CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct sunxi_tfm_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sunxi_ss_cipher_init,
+		.cra_exit = sunxi_ss_cipher_exit,
+		.cra_ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey         = sunxi_ss_aes_setkey,
+			.encrypt        = sunxi_ss_cbc_aes_encrypt,
+			.decrypt        = sunxi_ss_cbc_aes_decrypt,
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+		.cra_name = "ecb(aes)",
+		.cra_driver_name = "ecb-aes-sunxi-ss",
+		.cra_priority = 300,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+			CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct sunxi_tfm_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sunxi_ss_cipher_init,
+		.cra_exit = sunxi_ss_cipher_exit,
+		.cra_ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey         = sunxi_ss_aes_setkey,
+			.encrypt        = sunxi_ss_ecb_aes_encrypt,
+			.decrypt        = sunxi_ss_ecb_aes_decrypt,
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+		.cra_name = "cbc(des)",
+		.cra_driver_name = "cbc-des-sunxi-ss",
+		.cra_priority = 300,
+		.cra_blocksize = DES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+			CRYPTO_ALG_NEED_FALLBACK,
+		.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sunxi_ss_cipher_des_init,
+		.cra_exit = sunxi_ss_cipher_exit,
+		.cra_u.ablkcipher = {
+			.min_keysize    = DES_KEY_SIZE,
+			.max_keysize    = DES_KEY_SIZE,
+			.ivsize         = DES_BLOCK_SIZE,
+			.setkey         = sunxi_ss_des_setkey,
+			.encrypt        = sunxi_ss_cbc_des_encrypt,
+			.decrypt        = sunxi_ss_cbc_des_decrypt,
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+		.cra_name = "ecb(des)",
+		.cra_driver_name = "ecb-des-sunxi-ss",
+		.cra_priority = 300,
+		.cra_blocksize = DES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+			CRYPTO_ALG_NEED_FALLBACK,
+		.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = sunxi_ss_cipher_des_init,
+		.cra_exit = sunxi_ss_cipher_exit,
+		.cra_u.ablkcipher = {
+			.min_keysize    = DES_KEY_SIZE,
+			.max_keysize    = DES_KEY_SIZE,
+			.setkey         = sunxi_ss_des_setkey,
+			.encrypt        = sunxi_ss_ecb_des_encrypt,
+			.decrypt        = sunxi_ss_ecb_des_decrypt,
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-des3-sunxi-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = sunxi_ss_cipher_des_init,
+			.cra_exit = sunxi_ss_cipher_exit,
+			.cra_u.ablkcipher = {
+				.min_keysize    = DES3_EDE_KEY_SIZE,
+				.max_keysize    = DES3_EDE_KEY_SIZE,
+				.ivsize         = DES3_EDE_BLOCK_SIZE,
+				.setkey         = sunxi_ss_des3_setkey,
+				.encrypt        = sunxi_ss_cbc_des3_encrypt,
+				.decrypt        = sunxi_ss_cbc_des3_decrypt,
+		}
+	}
+},
+{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.alg.crypto = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-des3-sunxi-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_init = sunxi_ss_cipher_des_init,
+			.cra_exit = sunxi_ss_cipher_exit,
+			.cra_u.ablkcipher = {
+				.min_keysize    = DES3_EDE_KEY_SIZE,
+				.max_keysize    = DES3_EDE_KEY_SIZE,
+				.ivsize         = DES3_EDE_BLOCK_SIZE,
+				.setkey         = sunxi_ss_des3_setkey,
+				.encrypt        = sunxi_ss_ecb_des3_encrypt,
+				.decrypt        = sunxi_ss_ecb_des3_decrypt,
+		}
+	}
+},
+};
+
+static int sunxi_ss_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	u32 v;
+	int err, i;
+	unsigned long cr;
+	const unsigned long cr_ahb = 24 * 1000 * 1000;
+	const unsigned long cr_mod = 150 * 1000 * 1000;
+	struct sunxi_ss_ctx *ss;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	ss = devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
+	if (ss == NULL)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ss->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ss->base)) {
+		dev_err(&pdev->dev, "Cannot request MMIO\n");
+		return PTR_ERR(ss->base);
+	}
+
+	ss->ssclk = devm_clk_get(&pdev->dev, "mod");
+	if (IS_ERR(ss->ssclk)) {
+		err = PTR_ERR(ss->ssclk);
+		dev_err(&pdev->dev, "Cannot get SS clock err=%d\n", err);
+		return err;
+	}
+	dev_dbg(&pdev->dev, "clock ss acquired\n");
+
+	ss->busclk = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(ss->busclk)) {
+		err = PTR_ERR(ss->busclk);
+		dev_err(&pdev->dev, "Cannot get AHB SS clock err=%d\n", err);
+		return err;
+	}
+	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
+
+	/* Enable both clocks */
+	err = clk_prepare_enable(ss->busclk);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
+		return err;
+	}
+	err = clk_prepare_enable(ss->ssclk);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
+		goto error_ssclk;
+	}
+
+	/*
+	 * Check that clock have the correct rates gived in the datasheet
+	 * Try to set the clock to the maximum allowed
+	 */
+	err = clk_set_rate(ss->ssclk, cr_mod);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
+		goto error_clk;
+	}
+
+	/*
+	 * The only impact on clocks below requirement are bad performance,
+	 * so do not print "errors"
+	 * warn on Overclocked clocks
+	 */
+	cr = clk_get_rate(ss->busclk);
+	if (cr >= cr_ahb)
+		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
+				cr, cr / 1000000, cr_ahb);
+	else
+		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
+				cr, cr / 1000000, cr_ahb);
+
+	cr = clk_get_rate(ss->ssclk);
+	if (cr <= cr_mod)
+		if (cr < cr_mod)
+			dev_warn(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
+					cr, cr / 1000000, cr_mod);
+		else
+			dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
+					cr, cr / 1000000, cr_mod);
+	else
+		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= %lu)\n",
+				cr, cr / 1000000, cr_mod);
+
+	/*
+	 * Datasheet named it "Die Bonding ID"
+	 * I expect to be a sort of Security System Revision number.
+	 * Since the A80 seems to have an other version of SS
+	 * this info could be useful
+	 */
+	writel(SS_ENABLED, ss->base + SS_CTL);
+	v = readl(ss->base + SS_CTL);
+	v >>= 16;
+	v &= 0x07;
+	dev_info(&pdev->dev, "Die ID %d\n", v);
+	writel(0, ss->base + SS_CTL);
+
+	ss->dev = &pdev->dev;
+
+	spin_lock_init(&ss->slock);
+
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		driver_algs[i].ss = ss;
+		switch (driver_algs[i].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			err = crypto_register_alg(&driver_algs[i].alg.crypto);
+			if (err != 0)
+				goto error_alg;
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			err = crypto_register_ahash(&driver_algs[i].alg.hash);
+			if (err != 0)
+				goto error_alg;
+			break;
+		}
+	}
+	platform_set_drvdata(pdev, ss);
+	return 0;
+error_alg:
+	i--;
+	for (; i >= 0; i--) {
+		switch (driver_algs[i].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			crypto_unregister_alg(&driver_algs[i].alg.crypto);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&driver_algs[i].alg.hash);
+			break;
+		}
+	}
+error_clk:
+	clk_disable_unprepare(ss->ssclk);
+error_ssclk:
+	clk_disable_unprepare(ss->busclk);
+	return err;
+}
+
+static int sunxi_ss_remove(struct platform_device *pdev)
+{
+	int i;
+	struct sunxi_ss_ctx *ss = platform_get_drvdata(pdev);
+
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		switch (driver_algs[i].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			crypto_unregister_alg(&driver_algs[i].alg.crypto);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&driver_algs[i].alg.hash);
+			break;
+		}
+	}
+
+	writel(0, ss->base + SS_CTL);
+	clk_disable_unprepare(ss->busclk);
+	clk_disable_unprepare(ss->ssclk);
+	return 0;
+}
+
+static const struct of_device_id a20ss_crypto_of_match_table[] = {
+	{ .compatible = "allwinner,sun7i-a20-crypto" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
+
+static struct platform_driver sunxi_ss_driver = {
+	.probe          = sunxi_ss_probe,
+	.remove         = sunxi_ss_remove,
+	.driver         = {
+		.name           = "sunxi-ss",
+		.of_match_table	= a20ss_crypto_of_match_table,
+	},
+};
+
+module_platform_driver(sunxi_ss_driver);
+
+MODULE_DESCRIPTION("Allwinner Security System cryptographic accelerator");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash.c b/drivers/crypto/sunxi-ss/sunxi-ss-hash.c
new file mode 100644
index 0000000..7087806
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash.c
@@ -0,0 +1,481 @@
+/*
+ * sunxi-ss-hash.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2015 Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * This file add support for MD5 and SHA1.
+ *
+ * You could find the datasheet in Documentation/arm/sunxi/README
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "sunxi-ss.h"
+
+/* This is a totaly arbitrary value */
+#define SS_TIMEOUT 100
+
+int sunxi_hash_crainit(struct crypto_tfm *tfm)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+			sizeof(struct sunxi_req_ctx));
+	return 0;
+}
+
+/* sunxi_hash_init: initialize request context */
+int sunxi_hash_init(struct ahash_request *areq)
+{
+	const char *hash_type;
+	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sunxi_ss_alg_template *algt;
+	struct sunxi_ss_ctx *ss;
+
+	memset(op, 0, sizeof(struct sunxi_req_ctx));
+
+	algt = container_of(alg, struct sunxi_ss_alg_template, alg.hash);
+	ss = algt->ss;
+	op->ss = algt->ss;
+
+	hash_type = crypto_tfm_alg_name(areq->base.tfm);
+
+	if (strcmp(hash_type, "sha1") == 0)
+		op->mode = SS_OP_SHA1;
+	else if (strcmp(hash_type, "md5") == 0)
+		op->mode = SS_OP_MD5;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+int sunxi_hash_export(struct ahash_request *areq, void *out)
+{
+	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
+
+	memcpy(out, op, sizeof(struct sunxi_req_ctx));
+	return 0;
+}
+
+int sunxi_hash_import(struct ahash_request *areq, const void *in)
+{
+	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
+
+	memcpy(op, in, sizeof(struct sunxi_req_ctx));
+	return 0;
+}
+
+/*
+ * sunxi_hash_update: update hash engine
+ *
+ * Could be used for both SHA1 and MD5
+ * Write data by step of 32bits and put then in the SS.
+ *
+ * Since we cannot leave partial data and hash state in the engine,
+ * we need to get the hash state at the end of this function.
+ * After some work, I have found that we can get the hash state every 64 bytes
+ *
+ * So the first work is to get the number of bytes to write to SS modulo 64
+ * The extra bytes will go to two different destination:
+ * op->wait for full 32bits word
+ * op->wb (waiting bytes) for partial 32 bits word
+ * So we can have up to (64/4)-1 op->wait words and 0/1/2/3 bytes in wb
+ *
+ * So at the begin of update()
+ * if op->nwait * 4 + areq->nbytes < 64
+ * => all data will be writen to wait buffers and end=0
+ * if not, write all nwait to the device and position end to complete to 64bytes
+ *
+ * example 1:
+ * update1 60o => nwait=15
+ * update2 60o => need one more word to have 64 bytes
+ * end=4
+ * so write all data in op->wait and one word of SGs
+ * write remaining data in op->wait
+ * final state op->nwait=14
+ */
+int sunxi_hash_update(struct ahash_request *areq)
+{
+	u32 v, ivmode = 0;
+	unsigned int i = 0;
+	/*
+	 * i is the total bytes read from SGs, to be compared to areq->nbytes
+	 * i is important because we cannot rely on SG length since the sum of
+	 * SG->length could be greater than areq->nbytes
+	 */
+
+	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
+	struct sunxi_ss_ctx *ss = op->ss;
+	struct scatterlist *in_sg;
+	unsigned int in_i = 0; /* advancement in the current SG */
+	unsigned int end;
+	/*
+	 * end is the position when we need to stop writing to the device,
+	 * to be compared to i
+	 * So end is always a multiple of 64
+	 * if end = 0 all data must be kept for later use and no write
+	 * on the device is done.
+	 */
+	int in_r, err = 0;
+	void *src_addr;
+	unsigned int todo;
+	u32 spaces, rx_cnt;
+	unsigned long flags = 0;
+
+	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x bw=%u ww=%u h0=%0x",
+			__func__, crypto_tfm_alg_name(areq->base.tfm),
+			op->byte_count, areq->nbytes, op->mode,
+			op->nbw, op->nwait, op->hash[0]);
+
+	if (areq->nbytes == 0)
+		return 0;
+
+	/* protect againt overflow */
+	if (areq->nbytes > UINT_MAX - op->nwait * 4 - op->nbw) {
+		dev_err(ss->dev, "Cannot process too large request\n");
+		return -EINVAL;
+	}
+
+	if (areq->nbytes + op->nwait * 4 + op->nbw < 64)
+		end = 0;
+	else
+		end = ((areq->nbytes + op->nwait * 4 + op->nbw) / 64) * 64
+			- op->nbw - op->nwait * 4;
+
+	if (end > areq->nbytes || areq->nbytes - end > 63) {
+		dev_err(ss->dev, "ERROR: Bound error %u %u\n",
+				end, areq->nbytes);
+		return -EINVAL;
+	}
+
+	if (end > 0) {
+		spin_lock_irqsave(&ss->slock, flags);
+
+		/*
+		 * if some data have been processed before,
+		 * we need to restore the partial hash state
+		 */
+		if (op->byte_count > 0) {
+			ivmode = SS_IV_ARBITRARY;
+			for (i = 0; i < 5; i++)
+				writel(op->hash[i], ss->base + SS_IV0 + i * 4);
+		}
+		/* Enable the device */
+		writel(op->mode | SS_ENABLED | ivmode, ss->base + SS_CTL);
+	}
+
+	rx_cnt = 32;
+	i = 0;
+
+	if (op->nwait > 0 && end > 0) {
+		/*
+		 * a precedent update was done
+		 * No test versus rx_cnt since op->nwait cannot be more than 15
+		 */
+		writesl(ss->base + SS_RXFIFO, op->wait, op->nwait);
+		op->byte_count += 4 * op->nwait;
+		op->nwait = 0;
+	}
+
+	in_sg = areq->src;
+	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
+	if (src_addr == NULL) {
+		dev_err(ss->dev, "ERROR: Cannot kmap source buffer\n");
+		err = -EFAULT;
+		goto hash_update_release_ss;
+	}
+	do {
+		/*
+		 * step 1, if some bytes remains from last SG,
+		 * try to complete them to 4 and send that word
+		 */
+		if (op->nbw > 0) {
+			while (op->nbw < 4 && i < areq->nbytes &&
+					in_i < in_sg->length) {
+				op->wb |= (*(u8 *)(src_addr + in_i))
+					<< (8 * op->nbw);
+				dev_dbg(ss->dev, "%s: Complete w=%d wb=%x\n",
+						__func__, op->nbw, op->wb);
+				i++;
+				in_i++;
+				op->nbw++;
+			}
+			if (op->nbw == 4) {
+				if (i <= end) {
+					writel(op->wb, ss->base + SS_RXFIFO);
+					rx_cnt--;
+					if (rx_cnt > 0) {
+						spaces = readl_relaxed(ss->base + SS_FCSR);
+						rx_cnt = SS_RXFIFO_SPACES(spaces);
+					}
+					op->byte_count += 4;
+				} else {
+					op->wait[op->nwait] = op->wb;
+					op->nwait++;
+					dev_dbg(ss->dev, "%s: Keep %u bytes after %u\n",
+						__func__, op->nwait, end);
+				}
+				op->nbw = 0;
+				op->wb = 0;
+			}
+		}
+		/* step 2, main loop, read data 4bytes at a time */
+		while (i < areq->nbytes && in_i < in_sg->length) {
+			/* how many bytes we can read from current SG */
+			in_r = min(in_sg->length - in_i, areq->nbytes - i);
+			if (in_r < 4) {
+				/* Not enough data to write to the device */
+				op->wb = 0;
+				while (in_r > 0) {
+					op->wb |= (*(u8 *)(src_addr + in_i))
+						<< (8 * op->nbw);
+					dev_dbg(ss->dev, "%s: ending bw=%d wb=%x\n",
+						__func__, op->nbw, op->wb);
+					in_r--;
+					i++;
+					in_i++;
+					op->nbw++;
+				}
+				goto nextsg;
+			}
+			v = *(u32 *)(src_addr + in_i);
+			if (i < end) {
+				todo = min3((u32)(end - i) / 4, rx_cnt, (u32)in_r / 4);
+				writesl(ss->base + SS_RXFIFO, src_addr + in_i, todo);
+				i += 4 * todo;
+				in_i += 4 * todo;
+				op->byte_count += 4 * todo;
+				rx_cnt -= todo;
+				if (rx_cnt == 0) {
+					spaces = readl_relaxed(ss->base + SS_FCSR);
+					rx_cnt = SS_RXFIFO_SPACES(spaces);
+				}
+			} else {
+				op->wait[op->nwait] = v;
+				i += 4;
+				in_i += 4;
+				op->nwait++;
+				dev_dbg(ss->dev, "%s: Keep word ww=%u after %u\n",
+						__func__, op->nwait, end);
+				if (op->nwait > 15) {
+					dev_err(ss->dev, "FATAL: Cannot enqueue more, bug?\n");
+					err = -EIO;
+					goto hash_update_release_ss;
+				}
+			}
+		}
+nextsg:
+		/* Nothing more to read in this SG */
+		if (in_i == in_sg->length) {
+			kunmap(sg_page(in_sg));
+			do {
+				in_sg = sg_next(in_sg);
+			} while (in_sg != NULL && in_sg->length == 0);
+			in_i = 0;
+			if (in_sg != NULL) {
+				src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
+				if (src_addr == NULL) {
+					dev_err(ss->dev, "ERROR: Cannot kmap source buffer\n");
+					err = -EFAULT;
+					goto hash_update_release_ss;
+				}
+			}
+		}
+	} while (in_sg != NULL && i < areq->nbytes);
+
+hash_update_release_ss:
+	/* the device was not used, so nothing to release */
+	if (end == 0)
+		return err;
+
+	if (err == 0) {
+		/* ask the device to finish the hashing */
+		writel(op->mode | SS_ENABLED | SS_DATA_END, ss->base + SS_CTL);
+		i = 0;
+		do {
+			v = readl(ss->base + SS_CTL);
+			i++;
+		} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
+		if (i >= SS_TIMEOUT) {
+			dev_err(ss->dev, "ERROR: %s: hash end timeout after %d loop, CTL=%x\n",
+					__func__, i, v);
+			err = -EIO;
+			goto hash_update_release_ss;
+			/*
+			 * this seems strange (to go backward)
+			 * but since err is set, it works
+			 * */
+		}
+
+		/* get the partial hash only if something was written */
+		if (op->mode == SS_OP_SHA1) {
+			for (i = 0; i < 5; i++)
+				op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
+		} else {
+			for (i = 0; i < 4; i++)
+				op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
+		}
+	}
+	writel(0, ss->base + SS_CTL);
+	spin_unlock_irqrestore(&ss->slock, flags);
+	return err;
+}
+
+/*
+ * sunxi_hash_final: finalize hashing operation
+ *
+ * If we have some remaining bytes, we write them.
+ * Then ask the SS for finalizing the hashing operation
+ *
+ * I do not check RX FIFO size in this function since the size is 32
+ * after each enabling and this function neither write more than 32 words.
+ */
+int sunxi_hash_final(struct ahash_request *areq)
+{
+	u32 v, ivmode = 0;
+	unsigned int i;
+	unsigned int j = 0;
+	int zeros;
+	unsigned int index, padlen;
+	__be64 bits;
+	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
+	struct sunxi_ss_ctx *ss = op->ss;
+	u32 bf[32];
+	unsigned long flags;
+
+	dev_dbg(ss->dev, "%s: byte=%llu len=%u mode=%x bw=%u %x h=%x ww=%u",
+			__func__, op->byte_count, areq->nbytes, op->mode,
+			op->nbw, op->wb, op->hash[0], op->nwait);
+
+	spin_lock_irqsave(&ss->slock, flags);
+
+	/*
+	 * if we have already writed something,
+	 * restore the partial hash state
+	 */
+	if (op->byte_count > 0) {
+		ivmode = SS_IV_ARBITRARY;
+		for (i = 0; i < 5; i++)
+			writel(op->hash[i], ss->base + SS_IV0 + i * 4);
+	}
+	writel(op->mode | SS_ENABLED | ivmode, ss->base + SS_CTL);
+
+	/* write the remaining words of the wait buffer */
+	if (op->nwait > 0) {
+		writesl(ss->base + SS_RXFIFO, op->wait, op->nwait);
+		op->byte_count += 4 * op->nwait;
+		op->nwait = 0;
+	}
+
+	/* write the remaining bytes of the nbw buffer */
+	if (op->nbw > 0) {
+		op->wb |= ((1 << 7) << (op->nbw * 8));
+		bf[j++] = op->wb;
+	} else {
+		bf[j++] = 1 << 7;
+	}
+
+	/*
+	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
+	 * I take the operations from other md5/sha1 implementations
+	 */
+
+	/* we have already send 4 more byte of which nbw data */
+	if (op->mode == SS_OP_MD5) {
+		index = (op->byte_count + 4) & 0x3f;
+		op->byte_count += op->nbw;
+		if (index > 56)
+			zeros = (120 - index) / 4;
+		else
+			zeros = (56 - index) / 4;
+	} else {
+		op->byte_count += op->nbw;
+		index = op->byte_count & 0x3f;
+		padlen = (index < 56) ? (56 - index) : ((64 + 56) - index);
+		zeros = (padlen - 1) / 4;
+	}
+
+	/*for (i = 0; i < zeros; i++)
+		bf[j++] = 0;*/
+	memset(bf + j, 0, 4 * zeros);
+	j += zeros;
+
+	/* write the length of data */
+	if (op->mode == SS_OP_SHA1) {
+		bits = cpu_to_be64(op->byte_count << 3);
+		bf[j++] = bits & 0xffffffff;
+		bf[j++] = (bits >> 32) & 0xffffffff;
+	} else {
+		bf[j++] = (op->byte_count << 3) & 0xffffffff;
+		bf[j++] = (op->byte_count >> 29) & 0xffffffff;
+	}
+	writesl(ss->base + SS_RXFIFO, bf, j);
+
+	/* Tell the SS to stop the hashing */
+	writel(op->mode | SS_ENABLED | SS_DATA_END, ss->base + SS_CTL);
+
+	/*
+	 * Wait for SS to finish the hash.
+	 * The timeout could happend only in case of bad overcloking
+	 * or driver bug.
+	 */
+	i = 0;
+	do {
+		v = readl(ss->base + SS_CTL);
+		i++;
+	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
+	if (i >= SS_TIMEOUT) {
+		dev_err(ss->dev, "ERROR: hash end timeout %d>%d ctl=%x len=%u\n",
+				i, SS_TIMEOUT, v, areq->nbytes);
+		writel(0, ss->base + SS_CTL);
+		spin_unlock_irqrestore(&ss->slock, flags);
+		return -EIO;
+	}
+
+	/* Get the hash from the device */
+	if (op->mode == SS_OP_SHA1) {
+		for (i = 0; i < 5; i++) {
+			v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
+			memcpy(areq->result + i * 4, &v, 4);
+		}
+	} else {
+		for (i = 0; i < 4; i++) {
+			v = readl(ss->base + SS_MD0 + i * 4);
+			memcpy(areq->result + i * 4, &v, 4);
+		}
+	}
+	writel(0, ss->base + SS_CTL);
+	spin_unlock_irqrestore(&ss->slock, flags);
+	return 0;
+}
+
+/* sunxi_hash_finup: finalize hashing operation after an update */
+int sunxi_hash_finup(struct ahash_request *areq)
+{
+	int err;
+
+	err = sunxi_hash_update(areq);
+	if (err != 0)
+		return err;
+
+	return sunxi_hash_final(areq);
+}
+
+/* combo of init/update/final functions */
+int sunxi_hash_digest(struct ahash_request *areq)
+{
+	int err;
+
+	err = sunxi_hash_init(areq);
+	if (err != 0)
+		return err;
+
+	err = sunxi_hash_update(areq);
+	if (err != 0)
+		return err;
+
+	return sunxi_hash_final(areq);
+}
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss.h b/drivers/crypto/sunxi-ss/sunxi-ss.h
new file mode 100644
index 0000000..f10c1e4
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss.h
@@ -0,0 +1,198 @@
+/*
+ * sunxi-ss.h - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2015 Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ *
+ * You could find the datasheet in Documentation/arm/sunxi/README
+ *
+ * Licensed under the GPL-2.
+ */
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <crypto/scatterwalk.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/internal/rng.h>
+
+#define SS_CTL            0x00
+#define SS_KEY0           0x04
+#define SS_KEY1           0x08
+#define SS_KEY2           0x0C
+#define SS_KEY3           0x10
+#define SS_KEY4           0x14
+#define SS_KEY5           0x18
+#define SS_KEY6           0x1C
+#define SS_KEY7           0x20
+
+#define SS_IV0            0x24
+#define SS_IV1            0x28
+#define SS_IV2            0x2C
+#define SS_IV3            0x30
+
+#define SS_FCSR           0x44
+
+#define SS_MD0            0x4C
+#define SS_MD1            0x50
+#define SS_MD2            0x54
+#define SS_MD3            0x58
+#define SS_MD4            0x5C
+
+#define SS_RXFIFO         0x200
+#define SS_TXFIFO         0x204
+
+/* SS_CTL configuration values */
+
+/* PRNG generator mode - bit 15 */
+#define SS_PRNG_ONESHOT		(0 << 15)
+#define SS_PRNG_CONTINUE	(1 << 15)
+
+/* IV mode for hash */
+#define SS_IV_ARBITRARY		(1 << 14)
+
+/* SS operation mode - bits 12-13 */
+#define SS_ECB			(0 << 12)
+#define SS_CBC			(1 << 12)
+#define SS_CTS			(3 << 12)
+
+/* Counter width for CNT mode - bits 10-11 */
+#define SS_CNT_16BITS		(0 << 10)
+#define SS_CNT_32BITS		(1 << 10)
+#define SS_CNT_64BITS		(2 << 10)
+
+/* Key size for AES - bits 8-9 */
+#define SS_AES_128BITS		(0 << 8)
+#define SS_AES_192BITS		(1 << 8)
+#define SS_AES_256BITS		(2 << 8)
+
+/* Operation direction - bit 7 */
+#define SS_ENCRYPTION		(0 << 7)
+#define SS_DECRYPTION		(1 << 7)
+
+/* SS Method - bits 4-6 */
+#define SS_OP_AES		(0 << 4)
+#define SS_OP_DES		(1 << 4)
+#define SS_OP_3DES		(2 << 4)
+#define SS_OP_SHA1		(3 << 4)
+#define SS_OP_MD5		(4 << 4)
+#define SS_OP_PRNG		(5 << 4)
+
+/* Data end bit - bit 2 */
+#define SS_DATA_END		(1 << 2)
+
+/* PRNG start bit - bit 1 */
+#define SS_PRNG_START		(1 << 1)
+
+/* SS Enable bit - bit 0 */
+#define SS_DISABLED		(0 << 0)
+#define SS_ENABLED		(1 << 0)
+
+/* SS_FCSR configuration values */
+/* RX FIFO status - bit 30 */
+#define SS_RXFIFO_FREE		(1 << 30)
+
+/* RX FIFO empty spaces - bits 24-29 */
+#define SS_RXFIFO_SPACES(val)	(((val) >> 24) & 0x3f)
+
+/* TX FIFO status - bit 22 */
+#define SS_TXFIFO_AVAILABLE	(1 << 22)
+
+/* TX FIFO available spaces - bits 16-21 */
+#define SS_TXFIFO_SPACES(val)	(((val) >> 16) & 0x3f)
+
+#define SS_RXFIFO_EMP_INT_PENDING	(1 << 10)
+#define SS_TXFIFO_AVA_INT_PENDING	(1 << 8)
+#define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
+#define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
+
+
+struct sunxi_ss_ctx {
+	void __iomem *base;
+	int irq;
+	struct clk *busclk;
+	struct clk *ssclk;
+	struct device *dev;
+	struct resource *res;
+	spinlock_t slock; /* control the use of the device */
+};
+
+struct sunxi_ss_alg_template {
+	u32 type;
+	union {
+		struct crypto_alg crypto;
+		struct ahash_alg hash;
+	} alg;
+	struct sunxi_ss_ctx *ss;
+};
+
+struct sunxi_tfm_ctx {
+	u32 key[AES_MAX_KEY_SIZE / 4];/* divided by sizeof(u32) */
+	u32 keylen;
+	u32 keymode;
+	struct crypto_ablkcipher *fallback;
+	struct sunxi_ss_ctx *ss;
+};
+
+struct sunxi_req_ctx {
+	u32 mode;
+	u64 byte_count; /* number of bytes "uploaded" to the device */
+	/* wb: partial word waiting to be completed and written to the device */
+	u32 wb;
+	/* number of bytes to be uploaded in the wb word */
+	unsigned int nbw;
+	u32 hash[5]; /* for storing SS_IVx register */
+	u32 wait[64];
+	unsigned int nwait;
+	struct sunxi_ss_ctx *ss;
+};
+
+int sunxi_hash_crainit(struct crypto_tfm *tfm);
+int sunxi_hash_init(struct ahash_request *areq);
+int sunxi_hash_update(struct ahash_request *areq);
+int sunxi_hash_final(struct ahash_request *areq);
+int sunxi_hash_finup(struct ahash_request *areq);
+int sunxi_hash_digest(struct ahash_request *areq);
+int sunxi_hash_export(struct ahash_request *areq, void *out);
+int sunxi_hash_import(struct ahash_request *areq, const void *in);
+
+int sunxi_ss_cbc_aes_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_cbc_aes_decrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_aes_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_aes_decrypt(struct ablkcipher_request *areq);
+
+int sunxi_ss_cbc_des_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_cbc_des_decrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_des_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_des_decrypt(struct ablkcipher_request *areq);
+
+int sunxi_ss_cbc_des3_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_cbc_des3_decrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_des3_encrypt(struct ablkcipher_request *areq);
+int sunxi_ss_ecb_des3_decrypt(struct ablkcipher_request *areq);
+
+int sunxi_ss_aes_poll(struct ablkcipher_request *areq, u32 mode);
+int sunxi_ss_des_poll(struct ablkcipher_request *areq, u32 mode);
+int sunxi_ss_cipher_init(struct crypto_tfm *tfm);
+int sunxi_ss_cipher_des_init(struct crypto_tfm *tfm);
+void sunxi_ss_cipher_exit(struct crypto_tfm *tfm);
+int sunxi_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen);
+int sunxi_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen);
+int sunxi_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen);
-- 
2.0.5
