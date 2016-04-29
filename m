From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v4 3/3] crypto: caam - add support for RSA algorithm
Date: Fri, 29 Apr 2016 16:10:21 +0300
Message-ID: <1461935421-31363-4-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1461935421-31363-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:40549
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753365AbcD2NKe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 09:10:34 -0400
In-Reply-To: <1461935421-31363-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add RSA support to caam driver.

Coauthored-by: Yashpal Dutta <yashpal.dutta@freescale.com>

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 drivers/crypto/caam/Kconfig    |  12 ++
 drivers/crypto/caam/Makefile   |   4 +
 drivers/crypto/caam/caampkc.c  | 470 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h  |  84 ++++++++
 drivers/crypto/caam/desc.h     |   2 +
 drivers/crypto/caam/pdb.h      |  16 +-
 drivers/crypto/caam/pkc_desc.c | 138 ++++++++++++
 7 files changed, 725 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 5652a53..44449ba 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -99,6 +99,18 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	  To compile this as a module, choose M here: the module
 	  will be called caamhash.
 
+config CRYPTO_DEV_FSL_CAAM_PKC_API
+        tristate "Register public key cryptography implementations with Crypto API"
+        depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
+        default y
+        select CRYPTO_RSA
+        help
+          Selecting this will allow SEC Public key support for RSA.
+          Supported cryptographic primitives: encryption, decryption,
+          signature and verification.
+          To compile this as a module, choose M here: the module
+          will be called caam_pkc.
+
 config CRYPTO_DEV_FSL_CAAM_RNG_API
 	tristate "Register caam device for hwrng API"
 	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 550758a..399ad55 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -5,11 +5,15 @@ ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
 	EXTRA_CFLAGS := -DDEBUG
 endif
 
+ccflags-y += -I$(srctree)/crypto
+
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caam_pkc.o
 
 caam-objs := ctrl.o
 caam_jr-objs := jr.o key_gen.o error.o
+caam_pkc-y := caampkc.o pkc_desc.o
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
new file mode 100644
index 0000000..613bb14
--- /dev/null
+++ b/drivers/crypto/caam/caampkc.c
@@ -0,0 +1,470 @@
+/*
+ * caam - Freescale FSL CAAM support for Public Key Cryptography
+ *
+ * Copyright 2016 Freescale Semiconductor, Inc.
+ *
+ * There is no Shared Descriptor for PKC so that the Job Descriptor must carry
+ * all the desired key parameters, input and output pointers.
+ */
+#include <linux/dma-mapping.h>
+#include <linux/fips.h>
+#include "compat.h"
+#include "caampkc.h"
+#include "sg_sw_sec4.h"
+#include "regs.h"
+#include "intern.h"
+#include "jr.h"
+#include "error.h"
+
+static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
+			 struct akcipher_request *req)
+{
+	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
+}
+
+static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edesc,
+			  struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct rsa_pub_desc *hw_desc = (struct rsa_pub_desc *)edesc->hw_desc;
+
+	dma_unmap_single(dev, hw_desc->n_dma, key->n_sz, DMA_TO_DEVICE);
+	dma_unmap_single(dev, hw_desc->e_dma, key->e_sz, DMA_TO_DEVICE);
+}
+
+static void rsa_priv_f1_unmap(struct device *dev, struct rsa_edesc *edesc,
+			      struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct rsa_priv_f1_desc *hw_desc =
+			(struct rsa_priv_f1_desc *)edesc->hw_desc;
+
+	dma_unmap_single(dev, hw_desc->n_dma, key->n_sz, DMA_TO_DEVICE);
+	dma_unmap_single(dev, hw_desc->d_dma, key->n_sz, DMA_TO_DEVICE);
+}
+
+static size_t skip_to_nonzero(u8 *ptr, size_t nbytes)
+{
+	size_t nr_zeros = 0;
+
+	while (!(*ptr) && nbytes) {
+		nbytes--;
+		ptr++;
+		nr_zeros++;
+	}
+
+	return nr_zeros;
+}
+
+static size_t scatterwalk_skip_zeros(struct scatter_walk *walk, size_t nbytes)
+{
+	size_t len_this_page, nr_zeros, cnt = 0;
+	u8 *vaddr, *ptr;
+
+	for (;;) {
+		nr_zeros = 0;
+		len_this_page = scatterwalk_pagelen(walk);
+
+		if (len_this_page > nbytes)
+			len_this_page = nbytes;
+
+		vaddr = scatterwalk_map(walk);
+		ptr = vaddr;
+		nr_zeros = skip_to_nonzero(ptr, len_this_page);
+		scatterwalk_unmap(vaddr);
+
+		/* count total number of zeros */
+		cnt += nr_zeros;
+
+		/* advance scatterwalk to the nonzero data */
+		scatterwalk_advance(walk, nr_zeros);
+
+		if (nr_zeros < len_this_page || nbytes == len_this_page)
+			break;
+
+		nbytes -= len_this_page;
+
+		scatterwalk_pagedone(walk, 0, 1);
+	}
+
+	return cnt;
+}
+
+/*
+ * This function drops the leading zeros and copies the data to the initial
+ * pointer so that it can be freed later on. Returns the updated data length.
+ */
+static size_t drop_leading_zeros(struct scatterlist *sg, size_t nbytes)
+{
+	struct scatter_walk walk_src, walk_dst;
+	size_t nr_zeros = 0;
+
+	scatterwalk_start(&walk_src, sg);
+	nr_zeros = scatterwalk_skip_zeros(&walk_src, nbytes);
+
+	if (nr_zeros) {
+		nbytes = nbytes - nr_zeros;
+
+		scatterwalk_start(&walk_dst, sg);
+		scatterwalk_sg_copychunks(&walk_dst, &walk_src, nbytes);
+		scatterwalk_done(&walk_dst, 0, 0);
+	}
+
+	scatterwalk_done(&walk_src, 0, 0);
+
+	return nbytes;
+}
+
+/* RSA Job Completion handler */
+static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
+{
+	struct akcipher_request *req = context;
+	struct rsa_edesc *edesc;
+
+	if (err)
+		caam_jr_strstatus(dev, err);
+
+	/*
+	 * RSA's output is expected to be a big integer. Drop the leading
+	 * zeros since they are not meaningful in the world of numbers.
+	 */
+	req->dst_len = drop_leading_zeros(req->dst, req->dst_len);
+
+	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
+
+	rsa_pub_unmap(dev, edesc, req);
+	rsa_io_unmap(dev, edesc, req);
+	kfree(edesc);
+
+	akcipher_request_complete(req, err);
+}
+
+static void rsa_priv_f1_done(struct device *dev, u32 *desc, u32 err,
+			     void *context)
+{
+	struct akcipher_request *req = context;
+	struct rsa_edesc *edesc;
+
+	if (err)
+		caam_jr_strstatus(dev, err);
+
+	/*
+	 * RSA's output is expected to be a big integer. Drop the leading
+	 * zeros since they are not meaningful in the world of numbers.
+	 */
+	req->dst_len = drop_leading_zeros(req->dst, req->dst_len);
+
+	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
+
+	rsa_priv_f1_unmap(dev, edesc, req);
+	rsa_io_unmap(dev, edesc, req);
+	kfree(edesc);
+
+	akcipher_request_complete(req, err);
+}
+
+static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
+					 size_t desclen)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct device *dev = ctx->dev;
+	struct rsa_edesc *edesc;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	int sgc;
+	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
+	int src_nents, dst_nents;
+
+	src_nents = sg_nents_for_len(req->src, req->src_len);
+	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
+
+	if (src_nents > 1)
+		sec4_sg_len = src_nents;
+	if (dst_nents > 1)
+		sec4_sg_len += dst_nents;
+
+	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
+
+	/* allocate space for base edesc, hw desc commands and link tables */
+	edesc = kzalloc(sizeof(*edesc) + desclen + sec4_sg_bytes,
+			GFP_DMA | flags);
+	if (!edesc)
+		return ERR_PTR(-ENOMEM);
+
+	sgc = dma_map_sg(dev, req->src, src_nents, DMA_TO_DEVICE);
+	if (unlikely(!sgc)) {
+		dev_err(dev, "unable to map source\n");
+		goto src_fail;
+	}
+
+	sgc = dma_map_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
+	if (unlikely(!sgc)) {
+		dev_err(dev, "unable to map destination\n");
+		goto dst_fail;
+	}
+
+	edesc->sec4_sg = (void *)edesc + sizeof(*edesc) + desclen;
+
+	sec4_sg_index = 0;
+	if (src_nents > 1) {
+		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		sec4_sg_index += src_nents;
+	}
+	if (dst_nents > 1) {
+		sg_to_sec4_sg_last(req->dst, dst_nents,
+				   edesc->sec4_sg + sec4_sg_index, 0);
+	}
+
+	/* Save nents for later use in Job Descriptor. */
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+
+	if (!sec4_sg_bytes)
+		return edesc;
+
+	edesc->sec4_sg_dma = dma_map_single(dev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {
+		dev_err(dev, "unable to map S/G table\n");
+		goto sec4_sg_fail;
+	}
+
+	return edesc;
+
+sec4_sg_fail:
+	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
+dst_fail:
+	dma_unmap_sg(dev, req->src, src_nents, DMA_TO_DEVICE);
+src_fail:
+	kfree(edesc);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int caam_rsa_enc(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct device *jrdev = ctx->dev;
+	struct rsa_edesc *edesc = NULL;
+	size_t desclen = sizeof(struct rsa_pub_desc);
+	int ret;
+
+	if (unlikely(!key->n || !key->e))
+		return -EINVAL;
+
+	if (req->dst_len < key->n_sz) {
+		req->dst_len = key->n_sz;
+		dev_err(jrdev, "Output buffer length less than parameter n\n");
+		return -EOVERFLOW;
+	}
+
+	/* Allocate extended descriptor. */
+	edesc = rsa_edesc_alloc(req, desclen);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Initialize Job Descriptor. */
+	ret = init_rsa_pub_desc(req, edesc);
+	if (ret)
+		goto init_fail;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
+	if (!ret)
+		return -EINPROGRESS;
+
+	rsa_pub_unmap(jrdev, edesc, req);
+
+init_fail:
+	rsa_io_unmap(jrdev, edesc, req);
+	kfree(edesc);
+	return ret;
+}
+
+static int caam_rsa_dec(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct device *jrdev = ctx->dev;
+	struct rsa_edesc *edesc = NULL;
+	size_t desclen = sizeof(struct rsa_priv_f1_desc);
+	int ret;
+
+	if (unlikely(!key->n || !key->d))
+		return -EINVAL;
+
+	if (req->dst_len < key->n_sz) {
+		req->dst_len = key->n_sz;
+		return -EOVERFLOW;
+	}
+
+	/* Allocate extended descriptor. */
+	edesc = rsa_edesc_alloc(req, desclen);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Initialize Job Descriptor. */
+	ret = init_rsa_priv_f1_desc(req, edesc);
+	if (ret)
+		goto init_fail;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f1_done, req);
+	if (!ret)
+		return -EINPROGRESS;
+
+	rsa_priv_f1_unmap(jrdev, edesc, req);
+
+init_fail:
+	rsa_io_unmap(jrdev, edesc, req);
+	kfree(edesc);
+	return ret;
+}
+
+static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+				unsigned int keylen)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int ret;
+
+	ret = rsa_parse_pub_key(ctx, key, keylen);
+
+	return ret;
+}
+
+static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+				 unsigned int keylen)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int ret;
+
+	ret = rsa_parse_priv_key(ctx, key, keylen);
+
+	return ret;
+}
+
+static int caam_rsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+
+	return (key->n) ? key->n_sz : -EINVAL;
+}
+
+/* Per session pkc's driver context creation function */
+static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+
+	ctx->dev = caam_jr_alloc();
+
+	if (IS_ERR(ctx->dev)) {
+		dev_err(ctx->dev, "Job Ring Device allocation for transform failed\n");
+		return PTR_ERR(ctx->dev);
+	}
+
+	key->flags = GFP_DMA | GFP_KERNEL;
+	return 0;
+}
+
+/* Per session pkc's driver context cleanup function */
+static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+
+	rsa_free_key(ctx->dev, key);
+	caam_jr_free(ctx->dev);
+}
+
+static struct akcipher_alg caam_rsa = {
+	.encrypt = caam_rsa_enc,
+	.decrypt = caam_rsa_dec,
+	.sign = caam_rsa_dec,
+	.verify = caam_rsa_enc,
+	.set_pub_key = caam_rsa_set_pub_key,
+	.set_priv_key = caam_rsa_set_priv_key,
+	.max_size = caam_rsa_max_size,
+	.init = caam_rsa_init_tfm,
+	.exit = caam_rsa_exit_tfm,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-caam",
+		.cra_priority = 3000,
+		.cra_module = THIS_MODULE,
+		.cra_alignmask = 0,
+		.cra_ctxsize = sizeof(struct rsa_ctx),
+	},
+};
+
+/* Public Key Cryptography module initialization handler */
+static int __init caam_pkc_init(void)
+{
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	struct caam_drv_private *priv;
+	u32 cha_inst, pk_inst;
+	int err = 0;
+
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
+	/* Determine public key hardware accelerator presence. */
+	cha_inst = rd_reg32(&priv->ctrl->perfmon.cha_num_ls);
+	pk_inst = (cha_inst & CHA_ID_LS_PK_MASK) >> CHA_ID_LS_PK_SHIFT;
+
+	/* Do not register algorithms if PKHA is not present. */
+	if (!pk_inst)
+		return -ENODEV;
+
+	caam_rsa.base.cra_flags = 0;
+	err = crypto_register_akcipher(&caam_rsa);
+	if (err)
+		dev_warn(ctrldev, "%s alg registration failed\n",
+			 caam_rsa.base.cra_driver_name);
+	else
+		dev_info(ctrldev, "caam algorithms registered in /proc/crypto\n");
+
+	return err;
+}
+
+static void __exit caam_pkc_exit(void)
+{
+	crypto_unregister_akcipher(&caam_rsa);
+}
+
+module_init(caam_pkc_init);
+module_exit(caam_pkc_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("FSL CAAM support for PKC functions of crypto API");
+MODULE_AUTHOR("Freescale Semiconductor");
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
new file mode 100644
index 0000000..a49d7da
--- /dev/null
+++ b/drivers/crypto/caam/caampkc.h
@@ -0,0 +1,84 @@
+/*
+ * caam - Freescale FSL CAAM support for Public Key Cryptography descriptors
+ *
+ * Copyright 2016 Freescale Semiconductor, Inc.
+ *
+ * There is no Shared Descriptor for PKC so that the Job Descriptor must carry
+ * all the desired key parameters, input and output pointers.
+ */
+
+#ifndef _PKC_DESC_H_
+#define _PKC_DESC_H_
+
+#include <crypto/internal/rsa.h>
+#include <crypto/akcipher.h>
+#include <crypto/internal/akcipher.h>
+#include "desc_constr.h"
+#include "pdb.h"
+#include "rsapubkey-asn1.h"
+#include "rsaprivkey-asn1.h"
+
+/**
+ * RSA Pub_Key Descriptor
+ * @desc_hdr: Job Descriptor Header command
+ * @sgf: scatter-gather field
+ * @f_dma: dma address of input data
+ * @g_dma: dma address of ecrypted output data
+ * @n_dma: dma address of RSA public exponent
+ * @dma_e: dma address of RSA public exponent
+ * @f_len: length in octets of the input data
+ * @op: RSA Operation command
+ */
+struct rsa_pub_desc {
+	u32		desc_hdr;
+	u32		sgf;
+	dma_addr_t	f_dma;
+	dma_addr_t	g_dma;
+	dma_addr_t	n_dma;
+	dma_addr_t	e_dma;
+	u32		f_len;
+	u32		op;
+} __packed;
+
+/**
+ * Form1 Priv_key Decryption Descriptor.
+ * Private key is represented by (n,d).
+ * @desc_hdr: Job Descriptor Header command
+ * @sgf: scatter-gather field
+ * @g_dma: dma address of ecrypted input data
+ * @f_dma: dma address of output data
+ * @n_dma: dma address of RSA public exponent
+ * @dma_d: dma address of RSA private exponent
+ * @op: RSA Operation command
+ */
+struct rsa_priv_f1_desc {
+	u32		desc_hdr;
+	u32		sgf;
+	dma_addr_t	g_dma;
+	dma_addr_t	f_dma;
+	dma_addr_t	n_dma;
+	dma_addr_t	d_dma;
+	u32		op;
+} __packed;
+
+/**
+ * rsa_edesc - s/w-extended rsa descriptor
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @sec4_sg_dma: dma address of h/w link table
+ * @sec4_sg: pointer to h/w link table
+ * @hw_desc: descriptor followed by link tables if any
+ */
+struct rsa_edesc {
+	int src_nents;
+	int dst_nents;
+	dma_addr_t sec4_sg_dma;
+	struct sec4_sg_entry *sec4_sg;
+	u32 hw_desc[];
+};
+
+/* Descriptor construction primitives. */
+int init_rsa_pub_desc(struct akcipher_request *req, struct rsa_edesc *edesc);
+int init_rsa_priv_f1_desc(struct akcipher_request *req,
+			  struct rsa_edesc *edesc);
+#endif
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 1e93c6a..7e5c027 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -454,6 +454,8 @@ struct sec4_sg_entry {
 #define OP_PCLID_PUBLICKEYPAIR	(0x14 << OP_PCLID_SHIFT)
 #define OP_PCLID_DSASIGN	(0x15 << OP_PCLID_SHIFT)
 #define OP_PCLID_DSAVERIFY	(0x16 << OP_PCLID_SHIFT)
+#define OP_PCLID_RSAENC_PUBKEY  (0x18 << OP_PCLID_SHIFT)
+#define OP_PCLID_RSADEC_PRVKEY  (0x19 << OP_PCLID_SHIFT)
 
 /* Assuming OP_TYPE = OP_TYPE_DECAP_PROTOCOL/ENCAP_PROTOCOL */
 #define OP_PCLID_IPSEC		(0x01 << OP_PCLID_SHIFT)
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 3a87c0c..1c68d7b 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -1,7 +1,7 @@
 /*
  * CAAM Protocol Data Block (PDB) definition header file
  *
- * Copyright 2008-2012 Freescale Semiconductor, Inc.
+ * Copyright 2008-2016 Freescale Semiconductor, Inc.
  *
  */
 
@@ -399,4 +399,18 @@ struct dsa_verify_pdb {
 	u8 *ab; /* only used if ECC processing */
 };
 
+/* RSA Protocol Data Block */
+#define RSA_PDB_SGF_SHIFT       28
+#define RSA_PDB_E_SHIFT         12
+#define RSA_PDB_E_MASK          (0xFFF << RSA_PDB_E_SHIFT)
+#define RSA_PDB_D_SHIFT         12
+#define RSA_PDB_D_MASK          (0xFFF << RSA_PDB_D_SHIFT)
+
+#define RSA_PDB_SGF_F           (0x8 << RSA_PDB_SGF_SHIFT)
+#define RSA_PDB_SGF_G           (0x4 << RSA_PDB_SGF_SHIFT)
+#define RSA_PRIV_PDB_SGF_F      (0x4 << RSA_PDB_SGF_SHIFT)
+#define RSA_PRIV_PDB_SGF_G      (0x8 << RSA_PDB_SGF_SHIFT)
+
+#define RSA_PRIV_KEY_FRM_1      0
+
 #endif
diff --git a/drivers/crypto/caam/pkc_desc.c b/drivers/crypto/caam/pkc_desc.c
new file mode 100644
index 0000000..ba94096
--- /dev/null
+++ b/drivers/crypto/caam/pkc_desc.c
@@ -0,0 +1,138 @@
+/*
+ * caam - Freescale FSL CAAM support for Public Key Cryptography descriptors
+ *
+ * Copyright 2016 Freescale Semiconductor, Inc.
+ *
+ * There is no Shared Descriptor for PKC so that the Job Descriptor must carry
+ * all the desired key parameters, input and output pointers.
+ */
+#include "caampkc.h"
+
+/* Descriptor for RSA Public operation */
+int init_rsa_pub_desc(struct akcipher_request *req, struct rsa_edesc *edesc)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct device *dev = ctx->dev;
+	struct rsa_pub_desc *desc = (struct rsa_pub_desc *)edesc->hw_desc;
+	u32 start_idx, desc_size;
+	int sec4_sg_index = 0;
+
+	/*
+	 * The PDB has static fields and can be initialized before writing
+	 * a specific command. Map the memory first, since it can be a point
+	 * of failure.
+	 */
+	desc->n_dma = dma_map_single(dev, key->n, key->n_sz, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc->n_dma)) {
+		dev_err(dev, "Unable to map  modulus memory\n");
+		goto n_fail;
+	}
+
+	desc->e_dma = dma_map_single(dev, key->e, key->e_sz, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc->e_dma)) {
+		dev_err(dev, "Unable to map exponent memory\n");
+		goto e_fail;
+	}
+
+	desc_size = sizeof(*desc) / CAAM_CMD_SZ;
+	start_idx = (desc_size - 1) & HDR_START_IDX_MASK;
+	init_job_desc(edesc->hw_desc, (start_idx << HDR_START_IDX_SHIFT) |
+		      (start_idx & HDR_DESCLEN_MASK) | HDR_ONE);
+
+	sec4_sg_index = 0;
+	if (edesc->src_nents > 1) {
+		desc->sgf |= RSA_PDB_SGF_F;
+		desc->f_dma = edesc->sec4_sg_dma;
+		sec4_sg_index += edesc->src_nents;
+	} else {
+		desc->f_dma = sg_dma_address(req->src);
+	}
+
+	if (edesc->dst_nents > 1) {
+		desc->sgf |= RSA_PDB_SGF_G;
+		desc->g_dma = edesc->sec4_sg_dma +
+			sec4_sg_index * sizeof(struct sec4_sg_entry);
+	} else {
+		desc->g_dma = sg_dma_address(req->dst);
+	}
+
+	desc->sgf |= (key->e_sz << RSA_PDB_E_SHIFT) | key->n_sz;
+	desc->f_len = req->src_len;
+	desc->op = CMD_OPERATION | OP_TYPE_UNI_PROTOCOL |
+		   OP_PCLID_RSAENC_PUBKEY;
+	return 0;
+
+e_fail:
+	dma_unmap_single(dev, desc->n_dma, key->n_sz, DMA_TO_DEVICE);
+n_fail:
+	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
+	kfree(edesc);
+	return -ENOMEM;
+}
+
+/* Descriptor for RSA Private operation */
+int init_rsa_priv_f1_desc(struct akcipher_request *req, struct rsa_edesc *edesc)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_key *key = &ctx->key;
+	struct device *dev = ctx->dev;
+	struct rsa_priv_f1_desc *desc =
+			(struct rsa_priv_f1_desc *)edesc->hw_desc;
+	int sec4_sg_index = 0;
+	u32 start_idx, desc_size;
+
+	/*
+	 * The PDB has static fields and can be initialized before writing
+	 * a specific command. Map the memory first, since it can be a point
+	 * of failure.
+	 */
+	desc->n_dma = dma_map_single(dev, key->n, key->n_sz, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc->n_dma)) {
+		dev_err(dev, "Unable to map  modulus memory\n");
+		goto n_fail;
+	}
+
+	desc->d_dma = dma_map_single(dev, key->d, key->n_sz, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc->d_dma)) {
+		dev_err(dev, "Unable to map exponent memory\n");
+		goto d_fail;
+	}
+
+	desc_size = sizeof(*desc) / CAAM_CMD_SZ;
+	start_idx = (desc_size - 1) & HDR_START_IDX_MASK;
+	init_job_desc(edesc->hw_desc, (start_idx << HDR_START_IDX_SHIFT) |
+		      (start_idx & HDR_DESCLEN_MASK) | HDR_ONE);
+
+	if (edesc->src_nents > 1) {
+		desc->sgf |= RSA_PRIV_PDB_SGF_G;
+		desc->g_dma = edesc->sec4_sg_dma;
+		sec4_sg_index += edesc->src_nents;
+	} else {
+		desc->g_dma = sg_dma_address(req->src);
+	}
+
+	if (edesc->dst_nents > 1) {
+		desc->sgf |= RSA_PRIV_PDB_SGF_F;
+		desc->f_dma = edesc->sec4_sg_dma +
+			sec4_sg_index * sizeof(struct sec4_sg_entry);
+	} else {
+		desc->f_dma = sg_dma_address(req->dst);
+	}
+
+	desc->sgf |= (key->n_sz << RSA_PDB_D_SHIFT) | key->n_sz;
+	desc->op = CMD_OPERATION | OP_TYPE_UNI_PROTOCOL |
+		   OP_PCLID_RSADEC_PRVKEY | RSA_PRIV_KEY_FRM_1;
+	return 0;
+
+d_fail:
+	dma_unmap_single(dev, desc->n_dma, key->n_sz, DMA_TO_DEVICE);
+n_fail:
+	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
+	kfree(edesc);
+	return -ENOMEM;
+}
-- 
1.8.3.1
