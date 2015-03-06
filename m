From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 15/17] crypto: talitos - Implementation of SEC1
Date: Fri,  6 Mar 2015 17:42:26 +0100 (CET)
Message-ID: <20150306164226.331B51A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54071 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbCFQm2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:42:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds talitos1.c and talitos1.h with all specificities needed
to handle the SEC1 security engine found in MPC885 and MPC8272.

The SEC1 has several differences with its younger brother SEC2:
* Several bits in registers have different locations
* Many bits are missing
* Some bits are in addition
* SEC1 doesn't support scatter/gather
* SEC1 has a different descriptor structure

We add a helper function for clearing the desc field in the descriptor as that field needs to be cleared on SEC1 and doesn't exist on SEC2.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/Kconfig    |   6 +-
 drivers/crypto/Makefile   |   1 +
 drivers/crypto/talitos.c  |   4 +
 drivers/crypto/talitos.h  |   5 +
 drivers/crypto/talitos1.c | 176 ++++++++++++++++++++++++
 drivers/crypto/talitos1.h | 339 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos2.h |   4 +
 7 files changed, 534 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/talitos1.c
 create mode 100644 drivers/crypto/talitos1.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4fd6d7e..f863cac 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -211,7 +211,8 @@ config CRYPTO_DEV_TALITOS
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
 	select HW_RANDOM
-	select CRYPTO_DEV_TALITOS2
+	select CRYPTO_DEV_TALITOS1 if PPC_8xx || PPC_82xx
+	select CRYPTO_DEV_TALITOS2 if !CRYPTO_DEV_TALITOS1
 	depends on FSL_SOC
 	help
 	  Say 'Y' here to use the Freescale Security Engine (SEC)
@@ -223,6 +224,9 @@ config CRYPTO_DEV_TALITOS
 	  To compile this driver as a module, choose M here: the module
 	  will be called talitos.
 
+config CRYPTO_DEV_TALITOS1
+	bool
+
 config CRYPTO_DEV_TALITOS2
 	bool
 
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index f26159f..ef16f7b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+obj-$(CONFIG_CRYPTO_DEV_TALITOS1) += talitos1.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS2) += talitos2.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c27051c..82a5181 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -653,6 +653,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
+	to_talitos_next_desc_clear(desc);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_unmap(dev, edesc, areq);
@@ -811,6 +813,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
+	to_talitos_next_desc_clear(desc);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index f0ffbb0..e937c05 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -370,4 +370,9 @@ static inline int sg_count(struct scatterlist *sg_list, int nbytes,
 #define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	cpu_to_be32(2 << 3)
 #define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	cpu_to_be32(4 << 3)
 
+#ifdef CONFIG_CRYPTO_DEV_TALITOS1
+#include "talitos1.h"
+#endif
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
 #include "talitos2.h"
+#endif
diff --git a/drivers/crypto/talitos1.c b/drivers/crypto/talitos1.c
new file mode 100644
index 0000000..c1a8e9e
--- /dev/null
+++ b/drivers/crypto/talitos1.c
@@ -0,0 +1,176 @@
+/*
+ * talitos1 - Freescale Integrated Security Engine (SEC1) device driver
+ *
+ * Copyright (c) 2008-2011 Freescale Semiconductor, Inc.
+ *
+ * Copyright (c) 2014-2015 CS Systemes d'Information.
+ *
+ * Scatterlist Crypto API glue code copied from files with the following:
+ * Copyright (c) 2006-2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * Crypto algorithm registration code copied from hifn driver:
+ * 2007+ Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/crypto.h>
+#include <linux/hw_random.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+
+#include "talitos.h"
+
+void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out)
+{
+	if (edesc->ptr_in) {
+		unmap_single_talitos_ptr(dev, ptr_in, DMA_TO_DEVICE);
+		kfree(edesc->ptr_in);
+	} else {
+		dma_unmap_sg(dev, src, 1, dst != src ? DMA_TO_DEVICE
+						     : DMA_BIDIRECTIONAL);
+	}
+	if (dst && edesc->ptr_out) {
+		sg_copy_from_buffer(dst, edesc->dst_nents ? : 1, edesc->ptr_out,
+				    len);
+		unmap_single_talitos_ptr(dev, ptr_out, DMA_FROM_DEVICE);
+		kfree(edesc->ptr_out);
+	} else if (dst && dst != src) {
+		dma_unmap_sg(dev, dst, 1, DMA_FROM_DEVICE);
+	}
+}
+
+int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr)
+{
+	int sg_count = edesc->src_nents ? : 1;
+
+	ptr->len = cpu_to_be16(len);
+
+	if (sg_count == 1) {
+		edesc->ptr_in = NULL;
+		dma_map_sg(dev, src, 1, dir);
+		to_talitos_ptr(ptr, sg_dma_address(src));
+	} else {
+		edesc->ptr_in = kzalloc(len, GFP_DMA);
+		sg_copy_to_buffer(src, sg_count, edesc->ptr_in, len);
+		map_single_talitos_ptr(dev, ptr, len, (char *)edesc->ptr_in,
+				       0, dir);
+	}
+	return sg_count;
+}
+
+void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count)
+{
+	ptr->len = cpu_to_be16(len);
+
+	if (dir != DMA_NONE)
+		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
+					  dir, edesc->dst_chained);
+
+	if (sg_count == 1) {
+		edesc->ptr_out = NULL;
+		if (dir != DMA_NONE)
+			dma_map_sg(dev, dst, 1, dir);
+		to_talitos_ptr(ptr, sg_dma_address(dst));
+	} else {
+		edesc->ptr_out = kzalloc(len, GFP_DMA);
+		map_single_talitos_ptr(dev, ptr, len, (char *)edesc->ptr_out,
+				       0, DMA_FROM_DEVICE);
+	}
+}
+
+/*
+ * recover from error interrupts
+ */
+void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int ch, error, reset_dev = 0;
+	u32 v, v_lo;
+
+	for (ch = 0; ch < priv->num_channels; ch++) {
+		/* skip channels without errors */
+
+		/* bits 29, 31, 17, 19 */
+		if (!(isr & (1 << (29 + (ch & 1) * 2 - (ch & 2) * 6))))
+			continue;
+
+		error = -EINVAL;
+
+		v = in_be32(priv->chan[ch].reg + TALITOS_CCPSR);
+		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
+
+		if (v_lo & TALITOS_CCPSR_LO_TEA)
+			dev_err(dev, "master data transfer error\n");
+		if (v_lo & TALITOS_CCPSR_LO_PNC)
+			dev_err(dev, "pointeur not complete error\n");
+		if (v_lo & TALITOS_CCPSR_LO_PAR)
+			dev_err(dev, "parity error\n");
+		if (v_lo & TALITOS_CCPSR_LO_IDH)
+			dev_err(dev, "illegal descriptor header error\n");
+		if (v_lo & TALITOS_CCPSR_LO_SA)
+			dev_err(dev, "static assignment error\n");
+		if (v_lo & TALITOS_CCPSR_LO_EU)
+			talitos_report_eu_error(dev, ch);
+
+		talitos_flush_channel(dev, ch, error, 1);
+
+		talitos_reset_channel(dev, ch);
+	}
+	if (reset_dev || isr & ~TALITOS_ISR_4CHERR || isr_lo) {
+		if (isr_lo & TALITOS_ISR_TEA_ERR)
+			dev_err(dev, "TEA error: ISR 0x%08x_%08x\n",
+				isr, isr_lo);
+		else
+			dev_err(dev, "done overflow, internal time out, or "
+				"rngu error: ISR 0x%08x_%08x\n", isr, isr_lo);
+
+		/* purge request queues */
+		for (ch = 0; ch < priv->num_channels; ch++)
+			talitos_flush_channel(dev, ch, -EIO, 1);
+
+		/* reset and reinitialize the device */
+		talitos_init_device(dev);
+	}
+}
diff --git a/drivers/crypto/talitos1.h b/drivers/crypto/talitos1.h
new file mode 100644
index 0000000..f78d89d
--- /dev/null
+++ b/drivers/crypto/talitos1.h
@@ -0,0 +1,339 @@
+/*
+ * Freescale SEC1 (talitos) device register and descriptor header defines
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ *
+ * Copyright (c) 2014-2015 CS Systemes d'Information.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#define TALITOS_MAX_DATA_LEN 32768
+
+/* descriptor pointer entry */
+struct talitos_ptr {
+	__be16 res;	/* reserved */
+	__be16 len;     /* length */
+	__be32 ptr;     /* address */
+};
+
+static const struct talitos_ptr zero_entry = {
+	.len = 0,
+	.res = 0,
+	.ptr = 0
+};
+
+/* descriptor */
+struct talitos_desc {
+	__be32 hdr;                     /* header high bits */
+	struct talitos_ptr ptr[7];      /* ptr/len pair array */
+	__be32 next_desc;
+};
+
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ * @ptr_in: temporary buffer for data in if scatterlist has more than 1 segment
+ * @ptr_out: temporary buffer for data out if scatterlist has more than 1 seg.
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	bool assoc_chained;
+	bool src_chained;
+	bool dst_chained;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	struct talitos_ptr link_tbl[0];
+	/* pointeurs for sg_copy as SEC1 doesn't support scatter/gather */
+	u8 *ptr_in;
+	u8 *ptr_out;
+};
+
+static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->res = 0;
+}
+
+static inline void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
+{
+}
+
+static inline void to_talitos_next_desc_clear(struct talitos_desc *desc)
+{
+	desc->next_desc = 0;
+}
+
+/*
+ * map virtual single (contiguous) pointer to h/w descriptor pointer
+ */
+static inline void map_single_talitos_ptr(struct device *dev,
+				   struct talitos_ptr *talitos_ptr,
+				   unsigned short len, void *data,
+				   unsigned char extent,
+				   enum dma_data_direction dir)
+{
+	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
+
+	talitos_ptr->len = cpu_to_be16(len);
+	to_talitos_ptr(talitos_ptr, dma_addr);
+	talitos_ptr->res = 0;
+}
+
+/*
+ * unmap bus single (contiguous) h/w descriptor pointer
+ */
+static inline void unmap_single_talitos_ptr(struct device *dev,
+				     struct talitos_ptr *talitos_ptr,
+				     enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
+			 be16_to_cpu(talitos_ptr->len), dir);
+}
+
+static inline int talitos_map_sg(struct device *dev, struct scatterlist *sg,
+			  unsigned int nents, enum dma_data_direction dir,
+			  bool chained)
+{
+	if (unlikely(chained))
+		while (sg) {
+			dma_map_sg(dev, sg, 1, dir);
+			sg = sg_next(sg);
+		}
+	else
+		dma_map_sg(dev, sg, nents, dir);
+	return nents;
+}
+
+static inline void talitos_unmap_sg_chain(struct device *dev,
+					  struct scatterlist *sg,
+					  enum dma_data_direction dir)
+{
+	while (sg) {
+		dma_unmap_sg(dev, sg, 1, dir);
+		sg = sg_next(sg);
+	}
+}
+
+extern void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out);
+extern int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr);
+extern void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count);
+
+
+static inline int talitos_alg_alloc_aead(struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+
+#define ISR_FORMAT(x)			(((x) << 28) | ((x) << 16))
+
+/* global register offset addresses */
+#define   TALITOS_MCR_SWR		0x1     /* s/w reset */
+
+#define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
+#define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
+
+#define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
+
+#define   TALITOS_ISR_TEA_ERR		0x00000040
+
+/* channel register address stride */
+#define TALITOS_CH_STRIDE		0x1000
+
+/* channel configuration register  */
+#define   TALITOS_CCCR_LO_RESET		0x1    /* channel reset */
+
+/* CCPSR: channel pointer status register */
+#define   TALITOS_CCPSR_LO_TEA		0x2000 /* master data transfer error */
+#define   TALITOS_CCPSR_LO_PNC		0x1000 /* pointeur not complete error */
+#define   TALITOS_CCPSR_LO_PAR		0x0800 /* parity error */
+#define   TALITOS_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
+#define   TALITOS_CCPSR_LO_SA		0x0200 /* static assignment error */
+#define   TALITOS_CCPSR_LO_EU		0x0100 /* EU error detected */
+
+/* execution unit registers base */
+#ifdef CONFIG_PPC_8xx
+#define TALITOS_AESU			0x4000
+#define TALITOS_DEU			0x5000
+#define TALITOS_MDEU			0x6000
+#define TALITOS_RNGU			0
+#define TALITOS_PKEU			0
+#define TALITOS_AFEU			0
+#else
+#define TALITOS_AFEU			0x8000
+#define TALITOS_DEU			0xa000
+#define TALITOS_MDEU			0xc000
+#define TALITOS_RNGU			0xe000
+#define TALITOS_PKEU			0x10000
+#define TALITOS_AESU			0x12000
+#endif
+#define TALITOS_KEU			0
+#define TALITOS_CRCU			0
+
+#define   TALITOS_DEUICR_KPE		0x00200000 /* Key Parity Error */
+
+static inline unsigned int do_reset_channel(struct talitos_private *priv,
+					    int ch)
+{
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_RESET);
+	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO)
+		& TALITOS_CCCR_LO_RESET)
+	       && --timeout)
+		cpu_relax();
+
+	return timeout;
+}
+
+static inline void do_init_device(struct talitos_private *priv)
+{
+	clrbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
+	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
+	/* disable parity error check in DEU because of erroneous? test vect. */
+	setbits32(priv->reg + TALITOS_DEUICR, TALITOS_DEUICR_KPE);
+}
+
+#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
+#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
+
+struct talitos_ahash_req_ctx {
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	unsigned int hw_context_size;
+	u8 buf[4096];
+	u8 bufnext[HASH_MAX_BLOCK_SIZE];
+	unsigned int swinit;
+	unsigned int first;
+	unsigned int last;
+	unsigned int to_hash_later;
+	u64 nbuf;
+	struct scatterlist bufsl[2];
+	struct scatterlist *psrc;
+};
+
+static inline void ahash_process_chain(struct scatterlist *src, int nbytes,
+				bool *chained,
+				struct talitos_ahash_req_ctx *req_ctx,
+				int nbytes_to_hash)
+{
+	int nents = sg_count(src, nbytes, chained);
+
+	if (nents > 1 || req_ctx->nbuf) {
+		sg_copy_to_buffer(src, nents, req_ctx->buf + req_ctx->nbuf,
+				  nbytes_to_hash - req_ctx->nbuf);
+		sg_init_one(req_ctx->bufsl, req_ctx->buf, nbytes_to_hash);
+		req_ctx->psrc = req_ctx->bufsl;
+	} else {
+		req_ctx->psrc = src;
+	}
+}
+
+#define DEF_TALITOS_DONE(name, ch_done_mask)				\
+static void talitos_done_##name(unsigned long data)			\
+{									\
+	struct device *dev = (struct device *)data;			\
+	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	unsigned long flags;						\
+									\
+	if (ch_done_mask & 0x10000000)					\
+		talitos_flush_channel(dev, 0, 0, 0);			\
+	if (priv->num_channels == 1)					\
+		goto out;						\
+	if (ch_done_mask & 0x40000000)					\
+		talitos_flush_channel(dev, 1, 0, 0);			\
+	if (ch_done_mask & 0x00010000)					\
+		talitos_flush_channel(dev, 2, 0, 0);			\
+	if (ch_done_mask & 0x00040000)					\
+		talitos_flush_channel(dev, 3, 0, 0);			\
+									\
+out:									\
+	/* At this point, all completed channels have been processed */	\
+	/* Unmask done interrupts for channels completed later on. */	\
+	spin_lock_irqsave(&priv->reg_lock, flags);			\
+	clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
+	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);	\
+	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
+}
+
+#define DEF_TALITOS_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
+static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
+{									       \
+	struct device *dev = data;					       \
+	struct talitos_private *priv = dev_get_drvdata(dev);		       \
+	u32 isr, isr_lo;						       \
+	unsigned long flags;						       \
+									       \
+	spin_lock_irqsave(&priv->reg_lock, flags);			       \
+	isr = in_be32(priv->reg + TALITOS_ISR);				       \
+	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
+	/* Acknowledge interrupt */					       \
+	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
+	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
+	if (unlikely(isr & ch_err_mask || isr_lo & TALITOS_IMR_LO_INIT)) {     \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+	}								       \
+	else {								       \
+		if (likely(isr & ch_done_mask)) {			       \
+			/* mask further done interrupts. */		       \
+			setbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
+			/* done_task will unmask done interrupts at exit */    \
+			tasklet_schedule(&priv->done_task[tlet]);	       \
+		}							       \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
+	}								       \
+									       \
+	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
+								IRQ_NONE;      \
+}
+
+#define TALITOS_OF_COMPATIBLE	{.compatible = "fsl,sec1.0",}
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index 6f98b12..2715c72 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -95,6 +95,10 @@ static inline void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
 	ptr->j_extent = 0;
 }
 
+static inline void to_talitos_next_desc_clear(struct talitos_desc *desc)
+{
+}
+
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
-- 
2.1.0
