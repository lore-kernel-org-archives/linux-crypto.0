From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/7] crypto: ccree: introduce CryptoCell driver
Date: Mon, 22 Jan 2018 09:27:00 +0000
Message-ID: <1516613230-4524-3-git-send-email-gilad@benyossef.com>
References: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Introduce basic low level Arm TrustZone CryptoCell HW support.
This first patch doesn't actually register any Crypto API
transformations, these will follow up in the next patch.

This first revision supports the CC 712 REE component.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/Kconfig                  |  27 ++
 drivers/crypto/Makefile                 |   1 +
 drivers/crypto/ccree/Makefile           |   6 +
 drivers/crypto/ccree/cc_buffer_mgr.c    | 387 +++++++++++++++++
 drivers/crypto/ccree/cc_buffer_mgr.h    |  60 +++
 drivers/crypto/ccree/cc_crypto_ctx.h    | 170 ++++++++
 drivers/crypto/ccree/cc_debugfs.c       | 101 +++++
 drivers/crypto/ccree/cc_debugfs.h       |  32 ++
 drivers/crypto/ccree/cc_driver.c        | 417 +++++++++++++++++++
 drivers/crypto/ccree/cc_driver.h        | 186 +++++++++
 drivers/crypto/ccree/cc_host_regs.h     | 142 +++++++
 drivers/crypto/ccree/cc_hw_queue_defs.h | 590 ++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_ivgen.c         | 280 +++++++++++++
 drivers/crypto/ccree/cc_ivgen.h         |  55 +++
 drivers/crypto/ccree/cc_kernel_regs.h   | 167 ++++++++
 drivers/crypto/ccree/cc_lli_defs.h      |  59 +++
 drivers/crypto/ccree/cc_pm.c            | 118 ++++++
 drivers/crypto/ccree/cc_pm.h            |  57 +++
 drivers/crypto/ccree/cc_request_mgr.c   | 713 ++++++++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_request_mgr.h   |  51 +++
 drivers/crypto/ccree/cc_sram_mgr.c      | 107 +++++
 drivers/crypto/ccree/cc_sram_mgr.h      |  65 +++
 22 files changed, 3791 insertions(+)
 create mode 100644 drivers/crypto/ccree/Makefile
 create mode 100644 drivers/crypto/ccree/cc_buffer_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_buffer_mgr.h
 create mode 100644 drivers/crypto/ccree/cc_crypto_ctx.h
 create mode 100644 drivers/crypto/ccree/cc_debugfs.c
 create mode 100644 drivers/crypto/ccree/cc_debugfs.h
 create mode 100644 drivers/crypto/ccree/cc_driver.c
 create mode 100644 drivers/crypto/ccree/cc_driver.h
 create mode 100644 drivers/crypto/ccree/cc_host_regs.h
 create mode 100644 drivers/crypto/ccree/cc_hw_queue_defs.h
 create mode 100644 drivers/crypto/ccree/cc_ivgen.c
 create mode 100644 drivers/crypto/ccree/cc_ivgen.h
 create mode 100644 drivers/crypto/ccree/cc_kernel_regs.h
 create mode 100644 drivers/crypto/ccree/cc_lli_defs.h
 create mode 100644 drivers/crypto/ccree/cc_pm.c
 create mode 100644 drivers/crypto/ccree/cc_pm.h
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.h
 create mode 100644 drivers/crypto/ccree/cc_sram_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_sram_mgr.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 47ec920..ed912bf 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -731,4 +731,31 @@ config CRYPTO_DEV_ARTPEC6
 
 	  To compile this driver as a module, choose M here.
 
+config CRYPTO_DEV_CCREE
+	tristate "Support for ARM TrustZone CryptoCell family of security processors"
+	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
+	default n
+	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DES
+	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CTR
+	select CRYPTO_XTS
+	help
+	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell
+	  family of processors. Currently only the CryptoCell 712 REE
+	  is supported.
+	  Choose this if you wish to use hardware acceleration of
+	  cryptographic operations on the system REE.
+	  If unsure say Y.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 2513d13..ee5ec5c9 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
 obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
 obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
+obj-$(CONFIG_CRYPTO_DEV_CCREE) += ccree/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
 obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
 obj-$(CONFIG_CRYPTO_DEV_NITROX) += cavium/nitrox/
diff --git a/drivers/crypto/ccree/Makefile b/drivers/crypto/ccree/Makefile
new file mode 100644
index 0000000..6b204ab
--- /dev/null
+++ b/drivers/crypto/ccree/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
+ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_ivgen.o cc_sram_mgr.o
+ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
+ccree-$(CONFIG_PM) += cc_pm.o
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
new file mode 100644
index 0000000..4c67579
--- /dev/null
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -0,0 +1,387 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+
+#include "cc_buffer_mgr.h"
+#include "cc_lli_defs.h"
+
+enum dma_buffer_type {
+	DMA_NULL_TYPE = -1,
+	DMA_SGL_TYPE = 1,
+	DMA_BUFF_TYPE = 2,
+};
+
+struct buff_mgr_handle {
+	struct dma_pool *mlli_buffs_pool;
+};
+
+union buffer_array_entry {
+	struct scatterlist *sgl;
+	dma_addr_t buffer_dma;
+};
+
+struct buffer_array {
+	unsigned int num_of_buffers;
+	union buffer_array_entry entry[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	unsigned int offset[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	int nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	int total_data_len[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	enum dma_buffer_type type[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	bool is_last[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+};
+
+static inline char *cc_dma_buf_type(enum cc_req_dma_buf_type type)
+{
+	switch (type) {
+	case CC_DMA_BUF_NULL:
+		return "BUF_NULL";
+	case CC_DMA_BUF_DLLI:
+		return "BUF_DLLI";
+	case CC_DMA_BUF_MLLI:
+		return "BUF_MLLI";
+	default:
+		return "BUF_INVALID";
+	}
+}
+
+/**
+ * cc_get_sgl_nents() - Get scatterlist number of entries.
+ *
+ * @sg_list: SG list
+ * @nbytes: [IN] Total SGL data bytes.
+ * @lbytes: [OUT] Returns the amount of bytes at the last entry
+ */
+static unsigned int cc_get_sgl_nents(struct device *dev,
+				     struct scatterlist *sg_list,
+				     unsigned int nbytes, u32 *lbytes,
+				     bool *is_chained)
+{
+	unsigned int nents = 0;
+
+	while (nbytes && sg_list) {
+		if (sg_list->length) {
+			nents++;
+			/* get the number of bytes in the last entry */
+			*lbytes = nbytes;
+			nbytes -= (sg_list->length > nbytes) ?
+					nbytes : sg_list->length;
+			sg_list = sg_next(sg_list);
+		} else {
+			sg_list = (struct scatterlist *)sg_page(sg_list);
+			if (is_chained)
+				*is_chained = true;
+		}
+	}
+	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
+	return nents;
+}
+
+/**
+ * cc_zero_sgl() - Zero scatter scatter list data.
+ *
+ * @sgl:
+ */
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
+{
+	struct scatterlist *current_sg = sgl;
+	int sg_index = 0;
+
+	while (sg_index <= data_len) {
+		if (!current_sg) {
+			/* reached the end of the sgl --> just return back */
+			return;
+		}
+		memset(sg_virt(current_sg), 0, current_sg->length);
+		sg_index += current_sg->length;
+		current_sg = sg_next(current_sg);
+	}
+}
+
+/**
+ * cc_copy_sg_portion() - Copy scatter list data,
+ * from to_skip to end, to dest and vice versa
+ *
+ * @dest:
+ * @sg:
+ * @to_skip:
+ * @end:
+ * @direct:
+ */
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
+{
+	u32 nents, lbytes;
+
+	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
+	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
+		       (direct == CC_SG_TO_BUF));
+}
+
+static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
+				  u32 buff_size, u32 *curr_nents,
+				  u32 **mlli_entry_pp)
+{
+	u32 *mlli_entry_p = *mlli_entry_pp;
+	u32 new_nents;
+
+	/* Verify there is no memory overflow*/
+	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES)
+		return -ENOMEM;
+
+	/*handle buffer longer than 64 kbytes */
+	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
+		cc_lli_set_addr(mlli_entry_p, buff_dma);
+		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
+		dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
+			*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
+			mlli_entry_p[LLI_WORD1_OFFSET]);
+		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
+		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
+		mlli_entry_p = mlli_entry_p + 2;
+		(*curr_nents)++;
+	}
+	/*Last entry */
+	cc_lli_set_addr(mlli_entry_p, buff_dma);
+	cc_lli_set_size(mlli_entry_p, buff_size);
+	dev_dbg(dev, "entry[%d]: single_buff=0x%08X size=%08X\n",
+		*curr_nents, mlli_entry_p[LLI_WORD0_OFFSET],
+		mlli_entry_p[LLI_WORD1_OFFSET]);
+	mlli_entry_p = mlli_entry_p + 2;
+	*mlli_entry_pp = mlli_entry_p;
+	(*curr_nents)++;
+	return 0;
+}
+
+static int cc_render_sg_to_mlli(struct device *dev, struct scatterlist *sgl,
+				u32 sgl_data_len, u32 sgl_offset,
+				u32 *curr_nents, u32 **mlli_entry_pp)
+{
+	struct scatterlist *curr_sgl = sgl;
+	u32 *mlli_entry_p = *mlli_entry_pp;
+	s32 rc = 0;
+
+	for ( ; (curr_sgl && sgl_data_len);
+	      curr_sgl = sg_next(curr_sgl)) {
+		u32 entry_data_len =
+			(sgl_data_len > sg_dma_len(curr_sgl) - sgl_offset) ?
+				sg_dma_len(curr_sgl) - sgl_offset :
+				sgl_data_len;
+		sgl_data_len -= entry_data_len;
+		rc = cc_render_buff_to_mlli(dev, sg_dma_address(curr_sgl) +
+					    sgl_offset, entry_data_len,
+					    curr_nents, &mlli_entry_p);
+		if (rc)
+			return rc;
+
+		sgl_offset = 0;
+	}
+	*mlli_entry_pp = mlli_entry_p;
+	return 0;
+}
+
+static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
+			    struct mlli_params *mlli_params, gfp_t flags)
+{
+	u32 *mlli_p;
+	u32 total_nents = 0, prev_total_nents = 0;
+	int rc = 0, i;
+
+	dev_dbg(dev, "NUM of SG's = %d\n", sg_data->num_of_buffers);
+
+	/* Allocate memory from the pointed pool */
+	mlli_params->mlli_virt_addr =
+		dma_pool_alloc(mlli_params->curr_pool, flags,
+			       &mlli_params->mlli_dma_addr);
+	if (!mlli_params->mlli_virt_addr) {
+		dev_err(dev, "dma_pool_alloc() failed\n");
+		rc = -ENOMEM;
+		goto build_mlli_exit;
+	}
+	/* Point to start of MLLI */
+	mlli_p = (u32 *)mlli_params->mlli_virt_addr;
+	/* go over all SG's and link it to one MLLI table */
+	for (i = 0; i < sg_data->num_of_buffers; i++) {
+		union buffer_array_entry *entry = &sg_data->entry[i];
+		u32 tot_len = sg_data->total_data_len[i];
+		u32 offset = sg_data->offset[i];
+
+		if (sg_data->type[i] == DMA_SGL_TYPE)
+			rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len,
+						  offset, &total_nents,
+						  &mlli_p);
+		else /*DMA_BUFF_TYPE*/
+			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
+						    tot_len, &total_nents,
+						    &mlli_p);
+		if (rc)
+			return rc;
+
+		/* set last bit in the current table */
+		if (sg_data->mlli_nents[i]) {
+			/*Calculate the current MLLI table length for the
+			 *length field in the descriptor
+			 */
+			*sg_data->mlli_nents[i] +=
+				(total_nents - prev_total_nents);
+			prev_total_nents = total_nents;
+		}
+	}
+
+	/* Set MLLI size for the bypass operation */
+	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
+
+	dev_dbg(dev, "MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+		mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
+		mlli_params->mlli_len);
+
+build_mlli_exit:
+	return rc;
+}
+
+static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
+			    unsigned int nents, struct scatterlist *sgl,
+			    unsigned int data_len, unsigned int data_offset,
+			    bool is_last_table, u32 *mlli_nents)
+{
+	unsigned int index = sgl_data->num_of_buffers;
+
+	dev_dbg(dev, "index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
+		index, nents, sgl, data_len, is_last_table);
+	sgl_data->nents[index] = nents;
+	sgl_data->entry[index].sgl = sgl;
+	sgl_data->offset[index] = data_offset;
+	sgl_data->total_data_len[index] = data_len;
+	sgl_data->type[index] = DMA_SGL_TYPE;
+	sgl_data->is_last[index] = is_last_table;
+	sgl_data->mlli_nents[index] = mlli_nents;
+	if (sgl_data->mlli_nents[index])
+		*sgl_data->mlli_nents[index] = 0;
+	sgl_data->num_of_buffers++;
+}
+
+static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
+			 enum dma_data_direction direction)
+{
+	u32 i, j;
+	struct scatterlist *l_sg = sg;
+
+	for (i = 0; i < nents; i++) {
+		if (!l_sg)
+			break;
+		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
+			dev_err(dev, "dma_map_page() sg buffer failed\n");
+			goto err;
+		}
+		l_sg = sg_next(l_sg);
+	}
+	return nents;
+
+err:
+	/* Restore mapped parts */
+	for (j = 0; j < i; j++) {
+		if (!sg)
+			break;
+		dma_unmap_sg(dev, sg, 1, direction);
+		sg = sg_next(sg);
+	}
+	return 0;
+}
+
+static int cc_map_sg(struct device *dev, struct scatterlist *sg,
+		     unsigned int nbytes, int direction, u32 *nents,
+		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
+{
+	bool is_chained = false;
+
+	if (sg_is_last(sg)) {
+		/* One entry only case -set to DLLI */
+		if (dma_map_sg(dev, sg, 1, direction) != 1) {
+			dev_err(dev, "dma_map_sg() single buffer failed\n");
+			return -ENOMEM;
+		}
+		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
+			sg->offset, sg->length);
+		*lbytes = nbytes;
+		*nents = 1;
+		*mapped_nents = 1;
+	} else {  /*sg_is_last*/
+		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
+					  &is_chained);
+		if (*nents > max_sg_nents) {
+			*nents = 0;
+			dev_err(dev, "Too many fragments. current %d max %d\n",
+				*nents, max_sg_nents);
+			return -ENOMEM;
+		}
+		if (!is_chained) {
+			/* In case of mmu the number of mapped nents might
+			 * be changed from the original sgl nents
+			 */
+			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
+			if (*mapped_nents == 0) {
+				*nents = 0;
+				dev_err(dev, "dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		} else {
+			/*In this case the driver maps entry by entry so it
+			 * must have the same nents before and after map
+			 */
+			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
+						      direction);
+			if (*mapped_nents != *nents) {
+				*nents = *mapped_nents;
+				dev_err(dev, "dma_map_sg() sg buffer failed\n");
+				return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	buff_mgr_handle = kmalloc(sizeof(*buff_mgr_handle), GFP_KERNEL);
+	if (!buff_mgr_handle)
+		return -ENOMEM;
+
+	drvdata->buff_mgr_handle = buff_mgr_handle;
+
+	buff_mgr_handle->mlli_buffs_pool =
+		dma_pool_create("dx_single_mlli_tables", dev,
+				MAX_NUM_OF_TOTAL_MLLI_ENTRIES *
+				LLI_ENTRY_BYTE_SIZE,
+				MLLI_TABLE_MIN_ALIGNMENT, 0);
+
+	if (!buff_mgr_handle->mlli_buffs_pool)
+		goto error;
+
+	return 0;
+
+error:
+	cc_buffer_mgr_fini(drvdata);
+	return -ENOMEM;
+}
+
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata)
+{
+	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
+
+	if (buff_mgr_handle) {
+		dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
+		kfree(drvdata->buff_mgr_handle);
+		drvdata->buff_mgr_handle = NULL;
+	}
+	return 0;
+}
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.h b/drivers/crypto/ccree/cc_buffer_mgr.h
new file mode 100644
index 0000000..93ef765
--- /dev/null
+++ b/drivers/crypto/ccree/cc_buffer_mgr.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_buffer_mgr.h
+ * Buffer Manager
+ */
+
+#ifndef __CC_BUFFER_MGR_H__
+#define __CC_BUFFER_MGR_H__
+
+#include <crypto/algapi.h>
+
+#include "cc_driver.h"
+
+enum cc_req_dma_buf_type {
+	CC_DMA_BUF_NULL = 0,
+	CC_DMA_BUF_DLLI,
+	CC_DMA_BUF_MLLI
+};
+
+enum cc_sg_cpy_direct {
+	CC_SG_TO_BUF = 0,
+	CC_SG_FROM_BUF = 1
+};
+
+struct cc_mlli {
+	cc_sram_addr_t sram_addr;
+	unsigned int nents; //sg nents
+	unsigned int mlli_nents; //mlli nents might be different than the above
+};
+
+struct mlli_params {
+	struct dma_pool *curr_pool;
+	u8 *mlli_virt_addr;
+	dma_addr_t mlli_dma_addr;
+	u32 mlli_len;
+};
+
+int cc_buffer_mgr_init(struct cc_drvdata *drvdata);
+
+int cc_buffer_mgr_fini(struct cc_drvdata *drvdata);
+
+int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
+			      struct scatterlist *src, unsigned int nbytes,
+			      bool do_update, gfp_t flags);
+
+int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
+			       struct scatterlist *src, unsigned int nbytes,
+			       unsigned int block_size, gfp_t flags);
+
+void cc_unmap_hash_request(struct device *dev, void *ctx,
+			   struct scatterlist *src, bool do_revert);
+
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct);
+
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
+
+#endif /*__BUFFER_MGR_H__*/
+
diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
new file mode 100644
index 0000000..eb16842
--- /dev/null
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef _CC_CRYPTO_CTX_H_
+#define _CC_CRYPTO_CTX_H_
+
+#include <linux/types.h>
+
+/* context size */
+#ifndef CC_CTX_SIZE_LOG2
+#if (CC_DEV_SHA_MAX > 256)
+#define CC_CTX_SIZE_LOG2 8
+#else
+#define CC_CTX_SIZE_LOG2 7
+#endif
+#endif
+#define CC_CTX_SIZE BIT(CC_CTX_SIZE_LOG2)
+#define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
+
+#define CC_DRV_DES_IV_SIZE 8
+#define CC_DRV_DES_BLOCK_SIZE 8
+
+#define CC_DRV_DES_ONE_KEY_SIZE 8
+#define CC_DRV_DES_DOUBLE_KEY_SIZE 16
+#define CC_DRV_DES_TRIPLE_KEY_SIZE 24
+#define CC_DRV_DES_KEY_SIZE_MAX CC_DRV_DES_TRIPLE_KEY_SIZE
+
+#define CC_AES_IV_SIZE 16
+#define CC_AES_IV_SIZE_WORDS (CC_AES_IV_SIZE >> 2)
+
+#define CC_AES_BLOCK_SIZE 16
+#define CC_AES_BLOCK_SIZE_WORDS 4
+
+#define CC_AES_128_BIT_KEY_SIZE 16
+#define CC_AES_128_BIT_KEY_SIZE_WORDS	(CC_AES_128_BIT_KEY_SIZE >> 2)
+#define CC_AES_192_BIT_KEY_SIZE 24
+#define CC_AES_192_BIT_KEY_SIZE_WORDS	(CC_AES_192_BIT_KEY_SIZE >> 2)
+#define CC_AES_256_BIT_KEY_SIZE 32
+#define CC_AES_256_BIT_KEY_SIZE_WORDS	(CC_AES_256_BIT_KEY_SIZE >> 2)
+#define CC_AES_KEY_SIZE_MAX			CC_AES_256_BIT_KEY_SIZE
+#define CC_AES_KEY_SIZE_WORDS_MAX		(CC_AES_KEY_SIZE_MAX >> 2)
+
+#define CC_MD5_DIGEST_SIZE	16
+#define CC_SHA1_DIGEST_SIZE	20
+#define CC_SHA224_DIGEST_SIZE	28
+#define CC_SHA256_DIGEST_SIZE	32
+#define CC_SHA256_DIGEST_SIZE_IN_WORDS 8
+#define CC_SHA384_DIGEST_SIZE	48
+#define CC_SHA512_DIGEST_SIZE	64
+
+#define CC_SHA1_BLOCK_SIZE 64
+#define CC_SHA1_BLOCK_SIZE_IN_WORDS 16
+#define CC_MD5_BLOCK_SIZE 64
+#define CC_MD5_BLOCK_SIZE_IN_WORDS 16
+#define CC_SHA224_BLOCK_SIZE 64
+#define CC_SHA256_BLOCK_SIZE 64
+#define CC_SHA256_BLOCK_SIZE_IN_WORDS 16
+#define CC_SHA1_224_256_BLOCK_SIZE 64
+#define CC_SHA384_BLOCK_SIZE 128
+#define CC_SHA512_BLOCK_SIZE 128
+
+#if (CC_DEV_SHA_MAX > 256)
+#define CC_DIGEST_SIZE_MAX CC_SHA512_DIGEST_SIZE
+#define CC_HASH_BLOCK_SIZE_MAX CC_SHA512_BLOCK_SIZE /*1024b*/
+#else /* Only up to SHA256 */
+#define CC_DIGEST_SIZE_MAX CC_SHA256_DIGEST_SIZE
+#define CC_HASH_BLOCK_SIZE_MAX CC_SHA256_BLOCK_SIZE /*512b*/
+#endif
+
+#define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
+
+#define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
+
+enum drv_engine_type {
+	DRV_ENGINE_NULL = 0,
+	DRV_ENGINE_AES = 1,
+	DRV_ENGINE_DES = 2,
+	DRV_ENGINE_HASH = 3,
+	DRV_ENGINE_RC4 = 4,
+	DRV_ENGINE_DOUT = 5,
+	DRV_ENGINE_RESERVE32B = S32_MAX,
+};
+
+enum drv_crypto_alg {
+	DRV_CRYPTO_ALG_NULL = -1,
+	DRV_CRYPTO_ALG_AES  = 0,
+	DRV_CRYPTO_ALG_DES  = 1,
+	DRV_CRYPTO_ALG_HASH = 2,
+	DRV_CRYPTO_ALG_C2   = 3,
+	DRV_CRYPTO_ALG_HMAC = 4,
+	DRV_CRYPTO_ALG_AEAD = 5,
+	DRV_CRYPTO_ALG_BYPASS = 6,
+	DRV_CRYPTO_ALG_NUM = 7,
+	DRV_CRYPTO_ALG_RESERVE32B = S32_MAX
+};
+
+enum drv_crypto_direction {
+	DRV_CRYPTO_DIRECTION_NULL = -1,
+	DRV_CRYPTO_DIRECTION_ENCRYPT = 0,
+	DRV_CRYPTO_DIRECTION_DECRYPT = 1,
+	DRV_CRYPTO_DIRECTION_DECRYPT_ENCRYPT = 3,
+	DRV_CRYPTO_DIRECTION_RESERVE32B = S32_MAX
+};
+
+enum drv_cipher_mode {
+	DRV_CIPHER_NULL_MODE = -1,
+	DRV_CIPHER_ECB = 0,
+	DRV_CIPHER_CBC = 1,
+	DRV_CIPHER_CTR = 2,
+	DRV_CIPHER_CBC_MAC = 3,
+	DRV_CIPHER_XTS = 4,
+	DRV_CIPHER_XCBC_MAC = 5,
+	DRV_CIPHER_OFB = 6,
+	DRV_CIPHER_CMAC = 7,
+	DRV_CIPHER_CCM = 8,
+	DRV_CIPHER_CBC_CTS = 11,
+	DRV_CIPHER_GCTR = 12,
+	DRV_CIPHER_ESSIV = 13,
+	DRV_CIPHER_BITLOCKER = 14,
+	DRV_CIPHER_RESERVE32B = S32_MAX
+};
+
+enum drv_hash_mode {
+	DRV_HASH_NULL = -1,
+	DRV_HASH_SHA1 = 0,
+	DRV_HASH_SHA256 = 1,
+	DRV_HASH_SHA224 = 2,
+	DRV_HASH_SHA512 = 3,
+	DRV_HASH_SHA384 = 4,
+	DRV_HASH_MD5 = 5,
+	DRV_HASH_CBC_MAC = 6,
+	DRV_HASH_XCBC_MAC = 7,
+	DRV_HASH_CMAC = 8,
+	DRV_HASH_MODE_NUM = 9,
+	DRV_HASH_RESERVE32B = S32_MAX
+};
+
+enum drv_hash_hw_mode {
+	DRV_HASH_HW_MD5 = 0,
+	DRV_HASH_HW_SHA1 = 1,
+	DRV_HASH_HW_SHA256 = 2,
+	DRV_HASH_HW_SHA224 = 10,
+	DRV_HASH_HW_SHA512 = 4,
+	DRV_HASH_HW_SHA384 = 12,
+	DRV_HASH_HW_GHASH = 6,
+	DRV_HASH_HW_RESERVE32B = S32_MAX
+};
+
+/* drv_crypto_key_type[1:0] is mapped to cipher_do[1:0] */
+/* drv_crypto_key_type[2] is mapped to cipher_config2 */
+enum drv_crypto_key_type {
+	DRV_NULL_KEY = -1,
+	DRV_USER_KEY = 0,		/* 0x000 */
+	DRV_ROOT_KEY = 1,		/* 0x001 */
+	DRV_PROVISIONING_KEY = 2,	/* 0x010 */
+	DRV_SESSION_KEY = 3,		/* 0x011 */
+	DRV_APPLET_KEY = 4,		/* NA */
+	DRV_PLATFORM_KEY = 5,		/* 0x101 */
+	DRV_CUSTOMER_KEY = 6,		/* 0x110 */
+	DRV_END_OF_KEYS = S32_MAX,
+};
+
+enum drv_crypto_padding_type {
+	DRV_PADDING_NONE = 0,
+	DRV_PADDING_PKCS7 = 1,
+	DRV_PADDING_RESERVE32B = S32_MAX
+};
+
+#endif /* _CC_CRYPTO_CTX_H_ */
+
diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
new file mode 100644
index 0000000..08f8db4
--- /dev/null
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/stringify.h>
+#include "cc_driver.h"
+#include "cc_crypto_ctx.h"
+#include "cc_debugfs.h"
+
+struct cc_debugfs_ctx {
+	struct dentry *dir;
+};
+
+#define CC_DEBUG_REG(_X) {	\
+	.name = __stringify(_X),\
+	.offset = CC_REG(_X)	\
+	}
+
+/*
+ * This is a global var for the dentry of the
+ * debugfs ccree/ dir. It is not tied down to
+ * a specific instance of ccree, hence it is
+ * global.
+ */
+static struct dentry *cc_debugfs_dir;
+
+static struct debugfs_reg32 debug_regs[] = {
+	CC_DEBUG_REG(HOST_SIGNATURE),
+	CC_DEBUG_REG(HOST_IRR),
+	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
+	CC_DEBUG_REG(AXIM_MON_ERR),
+	CC_DEBUG_REG(DSCRPTR_QUEUE_CONTENT),
+	CC_DEBUG_REG(HOST_IMR),
+	CC_DEBUG_REG(AXIM_CFG),
+	CC_DEBUG_REG(AXIM_CACHE_PARAMS),
+	CC_DEBUG_REG(HOST_VERSION),
+	CC_DEBUG_REG(GPR_HOST),
+	CC_DEBUG_REG(AXIM_MON_COMP),
+};
+
+int __init cc_debugfs_global_init(void)
+{
+	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
+
+	return !cc_debugfs_dir;
+}
+
+void __exit cc_debugfs_global_fini(void)
+{
+	debugfs_remove(cc_debugfs_dir);
+}
+
+int cc_debugfs_init(struct cc_drvdata *drvdata)
+{
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_debugfs_ctx *ctx;
+	struct debugfs_regset32 *regset;
+	struct dentry *file;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
+	if (!regset)
+		return -ENOMEM;
+
+	regset->regs = debug_regs;
+	regset->nregs = ARRAY_SIZE(debug_regs);
+	regset->base = drvdata->cc_base;
+
+	ctx->dir = debugfs_create_dir(drvdata->plat_dev->name, cc_debugfs_dir);
+	if (!ctx->dir)
+		return -ENFILE;
+
+	file = debugfs_create_regset32("regs", 0400, ctx->dir, regset);
+	if (!file) {
+		debugfs_remove(ctx->dir);
+		return -ENFILE;
+	}
+
+	file = debugfs_create_bool("coherent", 0400, ctx->dir,
+				   &drvdata->coherent);
+
+	if (!file) {
+		debugfs_remove_recursive(ctx->dir);
+		return -ENFILE;
+	}
+
+	drvdata->debugfs = ctx;
+
+	return 0;
+}
+
+void cc_debugfs_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_debugfs_ctx *ctx = (struct cc_debugfs_ctx *)drvdata->debugfs;
+
+	debugfs_remove_recursive(ctx->dir);
+}
diff --git a/drivers/crypto/ccree/cc_debugfs.h b/drivers/crypto/ccree/cc_debugfs.h
new file mode 100644
index 0000000..5b5320e
--- /dev/null
+++ b/drivers/crypto/ccree/cc_debugfs.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_DEBUGFS_H__
+#define __CC_DEBUGFS_H__
+
+#ifdef CONFIG_DEBUG_FS
+int cc_debugfs_global_init(void);
+void cc_debugfs_global_fini(void);
+
+int cc_debugfs_init(struct cc_drvdata *drvdata);
+void cc_debugfs_fini(struct cc_drvdata *drvdata);
+
+#else
+
+static inline int cc_debugfs_global_init(void)
+{
+	return 0;
+}
+
+static inline void cc_debugfs_global_fini(void) {}
+
+static inline int cc_debugfs_init(struct cc_drvdata *drvdata)
+{
+	return 0;
+}
+
+static inline void cc_debugfs_fini(struct cc_drvdata *drvdata) {}
+
+#endif
+
+#endif /*__CC_SYSFS_H__*/
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
new file mode 100644
index 0000000..62b902a
--- /dev/null
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -0,0 +1,417 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/crypto.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/of_address.h>
+
+#include "cc_driver.h"
+#include "cc_request_mgr.h"
+#include "cc_buffer_mgr.h"
+#include "cc_debugfs.h"
+#include "cc_ivgen.h"
+#include "cc_sram_mgr.h"
+#include "cc_pm.h"
+
+bool cc_dump_desc;
+module_param_named(dump_desc, cc_dump_desc, bool, 0600);
+MODULE_PARM_DESC(cc_dump_desc, "Dump descriptors to kernel log as debugging aid");
+
+bool cc_dump_bytes;
+module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
+MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
+
+void __dump_byte_array(const char *name, const u8 *buf, size_t len)
+{
+	char prefix[64];
+
+	if (!buf)
+		return;
+
+	snprintf(prefix, sizeof(prefix), "%s[%zu]: ", name, len);
+
+	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, buf,
+		       len, false);
+}
+
+static irqreturn_t cc_isr(int irq, void *dev_id)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)dev_id;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u32 irr;
+	u32 imr;
+
+	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
+
+	/* read the interrupt status */
+	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
+	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
+	if (irr == 0) { /* Probably shared interrupt line */
+		dev_err(dev, "Got interrupt with empty IRR\n");
+		return IRQ_NONE;
+	}
+	imr = cc_ioread(drvdata, CC_REG(HOST_IMR));
+
+	/* clear interrupt - must be before processing events */
+	cc_iowrite(drvdata, CC_REG(HOST_ICR), irr);
+
+	drvdata->irq = irr;
+	/* Completion interrupt - most probable */
+	if (irr & CC_COMP_IRQ_MASK) {
+		/* Mask AXI completion interrupt - will be unmasked in
+		 * Deferred service handler
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_COMP_IRQ_MASK);
+		irr &= ~CC_COMP_IRQ_MASK;
+		complete_request(drvdata);
+	}
+
+	/* AXI error interrupt */
+	if (irr & CC_AXI_ERR_IRQ_MASK) {
+		u32 axi_err;
+
+		/* Read the AXI error ID */
+		axi_err = cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
+		dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
+			axi_err);
+
+		irr &= ~CC_AXI_ERR_IRQ_MASK;
+	}
+
+	if (irr) {
+		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
+			irr);
+		/* Just warning */
+	}
+
+	return IRQ_HANDLED;
+}
+
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
+{
+	unsigned int val, cache_params;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* Unmask all AXI interrupt sources AXI_CFG1 register */
+	val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
+	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
+	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
+		cc_ioread(drvdata, CC_REG(AXIM_CFG)));
+
+	/* Clear all pending interrupts */
+	val = cc_ioread(drvdata, CC_REG(HOST_IRR));
+	dev_dbg(dev, "IRR=0x%08X\n", val);
+	cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
+
+	/* Unmask relevant interrupt cause */
+	val = (unsigned int)(~(CC_COMP_IRQ_MASK | CC_AXI_ERR_IRQ_MASK |
+			       CC_GPR0_IRQ_MASK));
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
+
+	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
+
+	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
+
+	if (is_probe)
+		dev_info(dev, "Cache params previous: 0x%08X\n", val);
+
+	cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), cache_params);
+	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
+
+	if (is_probe)
+		dev_info(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
+			 val, cache_params);
+
+	return 0;
+}
+
+static int init_cc_resources(struct platform_device *plat_dev)
+{
+	struct resource *req_mem_cc_regs = NULL;
+	struct cc_drvdata *new_drvdata;
+	struct device *dev = &plat_dev->dev;
+	struct device_node *np = dev->of_node;
+	u32 signature_val;
+	u64 dma_mask;
+	int rc = 0;
+
+	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
+	if (!new_drvdata)
+		return -ENOMEM;
+
+	platform_set_drvdata(plat_dev, new_drvdata);
+	new_drvdata->plat_dev = plat_dev;
+
+	new_drvdata->clk = of_clk_get(np, 0);
+	new_drvdata->coherent = of_dma_is_coherent(np);
+
+	/* Get device resources */
+	/* First CC registers space */
+	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	/* Map registers space */
+	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
+	if (IS_ERR(new_drvdata->cc_base)) {
+		dev_err(dev, "Failed to ioremap registers");
+		return PTR_ERR(new_drvdata->cc_base);
+	}
+
+	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
+		req_mem_cc_regs);
+	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
+		&req_mem_cc_regs->start, new_drvdata->cc_base);
+
+	/* Then IRQ */
+	new_drvdata->irq = platform_get_irq(plat_dev, 0);
+	if (new_drvdata->irq < 0) {
+		dev_err(dev, "Failed getting IRQ resource\n");
+		return new_drvdata->irq;
+	}
+
+	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
+			      IRQF_SHARED, "ccree", new_drvdata);
+	if (rc) {
+		dev_err(dev, "Could not register to interrupt %d\n",
+			new_drvdata->irq);
+		return rc;
+	}
+	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
+
+	init_completion(&new_drvdata->hw_queue_avail);
+
+	if (!plat_dev->dev.dma_mask)
+		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
+
+	dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+	while (dma_mask > 0x7fffffffUL) {
+		if (dma_supported(&plat_dev->dev, dma_mask)) {
+			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
+			if (!rc)
+				break;
+		}
+		dma_mask >>= 1;
+	}
+
+	if (rc) {
+		dev_err(dev, "Failed in dma_set_mask, mask=%pad\n", &dma_mask);
+		return rc;
+	}
+
+	rc = cc_clk_on(new_drvdata);
+	if (rc) {
+		dev_err(dev, "Failed to enable clock");
+		return rc;
+	}
+
+	/* Verify correct mapping */
+	signature_val = cc_ioread(new_drvdata, CC_REG(HOST_SIGNATURE));
+	if (signature_val != CC_DEV_SIGNATURE) {
+		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+			signature_val, (u32)CC_DEV_SIGNATURE);
+		rc = -EINVAL;
+		goto post_clk_err;
+	}
+	dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
+
+	/* Display HW versions */
+	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
+		 CC_DEV_NAME_STR,
+		 cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
+		 DRV_MODULE_VERSION);
+
+	rc = init_cc_regs(new_drvdata, true);
+	if (rc) {
+		dev_err(dev, "init_cc_regs failed\n");
+		goto post_clk_err;
+	}
+
+	rc = cc_debugfs_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "Failed registering debugfs interface\n");
+		goto post_regs_err;
+	}
+
+	rc = cc_sram_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_sram_mgr_init failed\n");
+		goto post_debugfs_err;
+	}
+
+	new_drvdata->mlli_sram_addr =
+		cc_sram_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
+	if (new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR) {
+		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
+		rc = -ENOMEM;
+		goto post_sram_mgr_err;
+	}
+
+	rc = cc_req_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_req_mgr_init failed\n");
+		goto post_sram_mgr_err;
+	}
+
+	rc = cc_buffer_mgr_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "buffer_mgr_init failed\n");
+		goto post_req_mgr_err;
+	}
+
+	rc = cc_pm_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_init failed\n");
+		goto post_buf_mgr_err;
+	}
+
+	rc = cc_ivgen_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "cc_ivgen_init failed\n");
+		goto post_power_mgr_err;
+	}
+
+	return 0;
+
+post_power_mgr_err:
+	cc_pm_fini(new_drvdata);
+post_buf_mgr_err:
+	 cc_buffer_mgr_fini(new_drvdata);
+post_req_mgr_err:
+	cc_req_mgr_fini(new_drvdata);
+post_sram_mgr_err:
+	cc_sram_mgr_fini(new_drvdata);
+post_debugfs_err:
+	cc_debugfs_fini(new_drvdata);
+post_regs_err:
+	fini_cc_regs(new_drvdata);
+post_clk_err:
+	cc_clk_off(new_drvdata);
+	return rc;
+}
+
+void fini_cc_regs(struct cc_drvdata *drvdata)
+{
+	/* Mask all interrupts */
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), 0xFFFFFFFF);
+}
+
+static void cleanup_cc_resources(struct platform_device *plat_dev)
+{
+	struct cc_drvdata *drvdata =
+		(struct cc_drvdata *)platform_get_drvdata(plat_dev);
+
+	cc_ivgen_fini(drvdata);
+	cc_pm_fini(drvdata);
+	cc_buffer_mgr_fini(drvdata);
+	cc_req_mgr_fini(drvdata);
+	cc_sram_mgr_fini(drvdata);
+	cc_debugfs_fini(drvdata);
+	fini_cc_regs(drvdata);
+	cc_clk_off(drvdata);
+}
+
+int cc_clk_on(struct cc_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+	int rc;
+
+	if (IS_ERR(clk))
+		/* Not all devices have a clock associated with CCREE  */
+		return 0;
+
+	rc = clk_prepare_enable(clk);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+void cc_clk_off(struct cc_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+
+	if (IS_ERR(clk))
+		/* Not all devices have a clock associated with CCREE */
+		return;
+
+	clk_disable_unprepare(clk);
+}
+
+static int ccree_probe(struct platform_device *plat_dev)
+{
+	int rc;
+	struct device *dev = &plat_dev->dev;
+
+	/* Map registers space */
+	rc = init_cc_resources(plat_dev);
+	if (rc)
+		return rc;
+
+	dev_info(dev, "ARM ccree device initialized\n");
+
+	return 0;
+}
+
+static int ccree_remove(struct platform_device *plat_dev)
+{
+	struct device *dev = &plat_dev->dev;
+
+	dev_dbg(dev, "Releasing ccree resources...\n");
+
+	cleanup_cc_resources(plat_dev);
+
+	dev_info(dev, "ARM ccree device terminated\n");
+
+	return 0;
+}
+
+static const struct of_device_id arm_ccree_dev_of_match[] = {
+	{.compatible = "arm,cryptocell-712-ree"},
+	{}
+};
+MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
+
+static struct platform_driver ccree_driver = {
+	.driver = {
+		   .name = "ccree",
+		   .of_match_table = arm_ccree_dev_of_match,
+#ifdef CONFIG_PM
+		   .pm = &ccree_pm,
+#endif
+	},
+	.probe = ccree_probe,
+	.remove = ccree_remove,
+};
+
+static int __init ccree_init(void)
+{
+	int ret;
+
+	ret = cc_debugfs_global_init();
+	if (ret)
+		return ret;
+
+	return platform_driver_register(&ccree_driver);
+}
+module_init(ccree_init);
+
+static void __exit ccree_exit(void)
+{
+	platform_driver_unregister(&ccree_driver);
+	cc_debugfs_global_fini();
+}
+module_exit(ccree_exit);
+
+/* Module description */
+MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
+MODULE_VERSION(DRV_MODULE_VERSION);
+MODULE_AUTHOR("ARM");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
new file mode 100644
index 0000000..839056c
--- /dev/null
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_driver.h
+ * ARM CryptoCell Linux Crypto Driver
+ */
+
+#ifndef __CC_DRIVER_H__
+#define __CC_DRIVER_H__
+
+#ifdef COMP_IN_WQ
+#include <linux/workqueue.h>
+#else
+#include <linux/interrupt.h>
+#endif
+#include <linux/dma-mapping.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/hash.h>
+#include <crypto/skcipher.h>
+#include <linux/version.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+/* Registers definitions from shared/hw/ree_include */
+#include "cc_host_regs.h"
+#define CC_DEV_SHA_MAX 512
+#include "cc_crypto_ctx.h"
+#include "cc_hw_queue_defs.h"
+#include "cc_sram_mgr.h"
+
+extern bool cc_dump_desc;
+extern bool cc_dump_bytes;
+
+#define DRV_MODULE_VERSION "3.0"
+
+#define CC_DEV_NAME_STR "ccree"
+#define CC_COHERENT_CACHE_PARAMS 0xEEE
+
+/* Maximum DMA mask supported by IP */
+#define DMA_BIT_MASK_LEN 48
+
+#define CC_DEV_SIGNATURE 0xDCC71200UL
+
+#define CC_AXI_IRQ_MASK ((1 << CC_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
+			  (1 << CC_AXIM_CFG_COMPMASK_BIT_SHIFT))
+
+#define CC_AXI_ERR_IRQ_MASK BIT(CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
+
+#define CC_COMP_IRQ_MASK BIT(CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
+
+#define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
+				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
+				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+
+/* Register name mangling macro */
+#define CC_REG(reg_name) CC_ ## reg_name ## _REG_OFFSET
+
+/* TEE FIPS status interrupt */
+#define CC_GPR0_IRQ_MASK BIT(CC_HOST_IRR_GPR0_BIT_SHIFT)
+
+#define CC_CRA_PRIO 400
+
+#define MIN_HW_QUEUE_SIZE 50 /* Minimum size required for proper function */
+
+#define MAX_REQUEST_QUEUE_SIZE 4096
+#define MAX_MLLI_BUFF_SIZE 2080
+#define MAX_ICV_NENTS_SUPPORTED 2
+
+/* Definitions for HW descriptors DIN/DOUT fields */
+#define NS_BIT 1
+#define AXI_ID 0
+/* AXI_ID is not actually the AXI ID of the transaction but the value of AXI_ID
+ * field in the HW descriptor. The DMA engine +8 that value.
+ */
+
+#define CC_MAX_IVGEN_DMA_ADDRESSES	3
+struct cc_crypto_req {
+	void (*user_cb)(struct device *dev, void *req, int err);
+	void *user_arg;
+	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
+	/* For the first 'ivgen_dma_addr_len' addresses of this array,
+	 * generated IV would be placed in it by send_request().
+	 * Same generated IV for all addresses!
+	 */
+	/* Amount of 'ivgen_dma_addr' elements to be filled. */
+	unsigned int ivgen_dma_addr_len;
+	/* The generated IV size required, 8/16 B allowed. */
+	unsigned int ivgen_size;
+	struct completion seq_compl; /* request completion */
+};
+
+/**
+ * struct cc_drvdata - driver private data context
+ * @cc_base:	virt address of the CC registers
+ * @irq:	device IRQ number
+ * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
+ * @fw_ver:	SeP loaded firmware version
+ */
+struct cc_drvdata {
+	void __iomem *cc_base;
+	int irq;
+	u32 irq_mask;
+	u32 fw_ver;
+	struct completion hw_queue_avail; /* wait for HW queue availability */
+	struct platform_device *plat_dev;
+	cc_sram_addr_t mlli_sram_addr;
+	void *buff_mgr_handle;
+	void *request_mgr_handle;
+	void *ivgen_handle;
+	void *sram_mgr_handle;
+	void *debugfs;
+	struct clk *clk;
+	bool coherent;
+};
+
+struct cc_crypto_alg {
+	struct list_head entry;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	struct cc_drvdata *drvdata;
+	struct crypto_alg crypto_alg;
+};
+
+struct cc_alg_template {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	u32 type;
+	union {
+		struct skcipher_alg skcipher;
+		struct aead_alg aead;
+	} template_u;
+	int cipher_mode;
+	int flow_mode; /* Note: currently, refers to the cipher mode only. */
+	int auth_mode;
+	struct cc_drvdata *drvdata;
+};
+
+struct async_gen_req_ctx {
+	dma_addr_t iv_dma_addr;
+	enum drv_crypto_direction op_type;
+};
+
+static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
+{
+	return &drvdata->plat_dev->dev;
+}
+
+void __dump_byte_array(const char *name, const u8 *buf, size_t len);
+static inline void dump_byte_array(const char *name, const u8 *the_array,
+				   size_t size)
+{
+	if (cc_dump_bytes)
+		__dump_byte_array(name, the_array, size);
+}
+
+int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
+void fini_cc_regs(struct cc_drvdata *drvdata);
+int cc_clk_on(struct cc_drvdata *drvdata);
+void cc_clk_off(struct cc_drvdata *drvdata);
+
+static inline void cc_iowrite(struct cc_drvdata *drvdata, u32 reg, u32 val)
+{
+	iowrite32(val, (drvdata->cc_base + reg));
+}
+
+static inline u32 cc_ioread(struct cc_drvdata *drvdata, u32 reg)
+{
+	return ioread32(drvdata->cc_base + reg);
+}
+
+static inline gfp_t cc_gfp_flags(struct crypto_async_request *req)
+{
+	return (req->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+}
+
+#endif /*__CC_DRIVER_H__*/
+
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
new file mode 100644
index 0000000..69ef2fa
--- /dev/null
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_HOST_H__
+#define __CC_HOST_H__
+
+// --------------------------------------
+// BLOCK: HOST_P
+// --------------------------------------
+#define CC_HOST_IRR_REG_OFFSET	0xA00UL
+#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SHIFT	0x2UL
+#define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT	0x8UL
+#define CC_HOST_IRR_AXI_ERR_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_GPR0_BIT_SHIFT	0xBUL
+#define CC_HOST_IRR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SHIFT	0x13UL
+#define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT	0x17UL
+#define CC_HOST_IRR_AXIM_COMP_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REG_OFFSET	0xA04UL
+#define CC_HOST_IMR_NOT_USED_MASK_BIT_SHIFT	0x1UL
+#define CC_HOST_IMR_NOT_USED_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SHIFT	0x2UL
+#define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SHIFT	0x8UL
+#define CC_HOST_IMR_AXI_ERR_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_GPR0_BIT_SHIFT	0xBUL
+#define CC_HOST_IMR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SHIFT	0x13UL
+#define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SHIFT	0x17UL
+#define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_REG_OFFSET	0xA08UL
+#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SHIFT	0x2UL
+#define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SHIFT	0x8UL
+#define CC_HOST_ICR_AXI_ERR_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SHIFT	0xBUL
+#define CC_HOST_ICR_GPR_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SHIFT	0x13UL
+#define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
+#define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_HOST_SIGNATURE_REG_OFFSET	0xA24UL
+#define CC_HOST_SIGNATURE_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_SIGNATURE_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_BOOT_REG_OFFSET	0xA28UL
+#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SHIFT	0x0UL
+#define CC_HOST_BOOT_SYNTHESIS_CONFIG_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SHIFT	0x1UL
+#define CC_HOST_BOOT_LARGE_RKEK_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SHIFT	0x2UL
+#define CC_HOST_BOOT_HASH_IN_FUSES_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SHIFT	0x3UL
+#define CC_HOST_BOOT_EXT_MEM_SECURED_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SHIFT	0x5UL
+#define CC_HOST_BOOT_RKEK_ECC_EXISTS_LOCAL_N_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SHIFT	0x6UL
+#define CC_HOST_BOOT_SRAM_SIZE_LOCAL_BIT_SIZE	0x3UL
+#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SHIFT	0x9UL
+#define CC_HOST_BOOT_DSCRPTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SHIFT	0xAUL
+#define CC_HOST_BOOT_PAU_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SHIFT	0xBUL
+#define CC_HOST_BOOT_RNG_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SHIFT	0xCUL
+#define CC_HOST_BOOT_PKA_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SHIFT	0xDUL
+#define CC_HOST_BOOT_RC4_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SHIFT	0xEUL
+#define CC_HOST_BOOT_SHA_512_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SHIFT	0xFUL
+#define CC_HOST_BOOT_SHA_256_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SHIFT	0x10UL
+#define CC_HOST_BOOT_MD5_PRSNT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SHIFT	0x11UL
+#define CC_HOST_BOOT_HASH_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SHIFT	0x12UL
+#define CC_HOST_BOOT_C2_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SHIFT	0x13UL
+#define CC_HOST_BOOT_DES_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SHIFT	0x14UL
+#define CC_HOST_BOOT_AES_XCBC_MAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SHIFT	0x15UL
+#define CC_HOST_BOOT_AES_CMAC_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SHIFT	0x16UL
+#define CC_HOST_BOOT_AES_CCM_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SHIFT	0x17UL
+#define CC_HOST_BOOT_AES_XEX_HW_T_CALC_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SHIFT	0x18UL
+#define CC_HOST_BOOT_AES_XEX_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SHIFT	0x19UL
+#define CC_HOST_BOOT_CTR_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SHIFT	0x1AUL
+#define CC_HOST_BOOT_AES_DIN_BYTE_RESOLUTION_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SHIFT	0x1BUL
+#define CC_HOST_BOOT_TUNNELING_ENB_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SHIFT	0x1CUL
+#define CC_HOST_BOOT_SUPPORT_256_192_KEY_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SHIFT	0x1DUL
+#define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SHIFT	0x1EUL
+#define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SIZE	0x1UL
+#define CC_HOST_VERSION_REG_OFFSET	0xA40UL
+#define CC_HOST_VERSION_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_VERSION_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_KFDE0_VALID_REG_OFFSET	0xA60UL
+#define CC_HOST_KFDE0_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE0_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE1_VALID_REG_OFFSET	0xA64UL
+#define CC_HOST_KFDE1_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE1_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE2_VALID_REG_OFFSET	0xA68UL
+#define CC_HOST_KFDE2_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE2_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_KFDE3_VALID_REG_OFFSET	0xA6CUL
+#define CC_HOST_KFDE3_VALID_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_KFDE3_VALID_VALUE_BIT_SIZE	0x1UL
+#define CC_HOST_GPR0_REG_OFFSET	0xA70UL
+#define CC_HOST_GPR0_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_GPR0_VALUE_BIT_SIZE	0x20UL
+#define CC_GPR_HOST_REG_OFFSET	0xA74UL
+#define CC_GPR_HOST_VALUE_BIT_SHIFT	0x0UL
+#define CC_GPR_HOST_VALUE_BIT_SIZE	0x20UL
+#define CC_HOST_POWER_DOWN_EN_REG_OFFSET	0xA78UL
+#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SHIFT	0x0UL
+#define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SIZE	0x1UL
+// --------------------------------------
+// BLOCK: HOST_SRAM
+// --------------------------------------
+#define CC_SRAM_DATA_REG_OFFSET	0xF00UL
+#define CC_SRAM_DATA_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_DATA_VALUE_BIT_SIZE	0x20UL
+#define CC_SRAM_ADDR_REG_OFFSET	0xF04UL
+#define CC_SRAM_ADDR_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_ADDR_VALUE_BIT_SIZE	0xFUL
+#define CC_SRAM_DATA_READY_REG_OFFSET	0xF08UL
+#define CC_SRAM_DATA_READY_VALUE_BIT_SHIFT	0x0UL
+#define CC_SRAM_DATA_READY_VALUE_BIT_SIZE	0x1UL
+
+#endif //__CC_HOST_H__
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
new file mode 100644
index 0000000..a79f28ce
--- /dev/null
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -0,0 +1,590 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_HW_QUEUE_DEFS_H__
+#define __CC_HW_QUEUE_DEFS_H__
+
+#include <linux/types.h>
+
+#include "cc_kernel_regs.h"
+#include <linux/bitfield.h>
+
+/******************************************************************************
+ *				DEFINITIONS
+ ******************************************************************************/
+
+#define HW_DESC_SIZE_WORDS		6
+/* Define max. available slots in HW queue */
+#define HW_QUEUE_SLOTS_MAX              15
+
+#define CC_REG_LOW(word, name)  \
+	(CC_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SHIFT)
+
+#define CC_REG_HIGH(word, name) \
+	(CC_REG_LOW(word, name) + \
+	 CC_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SIZE - 1)
+
+#define CC_GENMASK(word, name) \
+	GENMASK(CC_REG_HIGH(word, name), CC_REG_LOW(word, name))
+
+#define WORD0_VALUE		CC_GENMASK(0, VALUE)
+#define WORD1_DIN_CONST_VALUE	CC_GENMASK(1, DIN_CONST_VALUE)
+#define WORD1_DIN_DMA_MODE	CC_GENMASK(1, DIN_DMA_MODE)
+#define WORD1_DIN_SIZE		CC_GENMASK(1, DIN_SIZE)
+#define WORD1_NOT_LAST		CC_GENMASK(1, NOT_LAST)
+#define WORD1_NS_BIT		CC_GENMASK(1, NS_BIT)
+#define WORD2_VALUE		CC_GENMASK(2, VALUE)
+#define WORD3_DOUT_DMA_MODE	CC_GENMASK(3, DOUT_DMA_MODE)
+#define WORD3_DOUT_LAST_IND	CC_GENMASK(3, DOUT_LAST_IND)
+#define WORD3_DOUT_SIZE		CC_GENMASK(3, DOUT_SIZE)
+#define WORD3_HASH_XOR_BIT	CC_GENMASK(3, HASH_XOR_BIT)
+#define WORD3_NS_BIT		CC_GENMASK(3, NS_BIT)
+#define WORD3_QUEUE_LAST_IND	CC_GENMASK(3, QUEUE_LAST_IND)
+#define WORD4_ACK_NEEDED	CC_GENMASK(4, ACK_NEEDED)
+#define WORD4_AES_SEL_N_HASH	CC_GENMASK(4, AES_SEL_N_HASH)
+#define WORD4_BYTES_SWAP	CC_GENMASK(4, BYTES_SWAP)
+#define WORD4_CIPHER_CONF0	CC_GENMASK(4, CIPHER_CONF0)
+#define WORD4_CIPHER_CONF1	CC_GENMASK(4, CIPHER_CONF1)
+#define WORD4_CIPHER_CONF2	CC_GENMASK(4, CIPHER_CONF2)
+#define WORD4_CIPHER_DO		CC_GENMASK(4, CIPHER_DO)
+#define WORD4_CIPHER_MODE	CC_GENMASK(4, CIPHER_MODE)
+#define WORD4_CMAC_SIZE0	CC_GENMASK(4, CMAC_SIZE0)
+#define WORD4_DATA_FLOW_MODE	CC_GENMASK(4, DATA_FLOW_MODE)
+#define WORD4_KEY_SIZE		CC_GENMASK(4, KEY_SIZE)
+#define WORD4_SETUP_OPERATION	CC_GENMASK(4, SETUP_OPERATION)
+#define WORD5_DIN_ADDR_HIGH	CC_GENMASK(5, DIN_ADDR_HIGH)
+#define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
+
+/******************************************************************************
+ *				TYPE DEFINITIONS
+ ******************************************************************************/
+
+struct cc_hw_desc {
+	union {
+		u32 word[HW_DESC_SIZE_WORDS];
+		u16 hword[HW_DESC_SIZE_WORDS * 2];
+	};
+};
+
+enum cc_axi_sec {
+	AXI_SECURE = 0,
+	AXI_NOT_SECURE = 1
+};
+
+enum cc_desc_direction {
+	DESC_DIRECTION_ILLEGAL = -1,
+	DESC_DIRECTION_ENCRYPT_ENCRYPT = 0,
+	DESC_DIRECTION_DECRYPT_DECRYPT = 1,
+	DESC_DIRECTION_DECRYPT_ENCRYPT = 3,
+	DESC_DIRECTION_END = S32_MAX,
+};
+
+enum cc_dma_mode {
+	DMA_MODE_NULL		= -1,
+	NO_DMA			= 0,
+	DMA_SRAM		= 1,
+	DMA_DLLI		= 2,
+	DMA_MLLI		= 3,
+	DMA_MODE_END		= S32_MAX,
+};
+
+enum cc_flow_mode {
+	FLOW_MODE_NULL		= -1,
+	/* data flows */
+	BYPASS			= 0,
+	DIN_AES_DOUT		= 1,
+	AES_to_HASH		= 2,
+	AES_and_HASH		= 3,
+	DIN_DES_DOUT		= 4,
+	DES_to_HASH		= 5,
+	DES_and_HASH		= 6,
+	DIN_HASH		= 7,
+	DIN_HASH_and_BYPASS	= 8,
+	AESMAC_and_BYPASS	= 9,
+	AES_to_HASH_and_DOUT	= 10,
+	DIN_RC4_DOUT		= 11,
+	DES_to_HASH_and_DOUT	= 12,
+	AES_to_AES_to_HASH_and_DOUT	= 13,
+	AES_to_AES_to_HASH	= 14,
+	AES_to_HASH_and_AES	= 15,
+	DIN_AES_AESMAC		= 17,
+	HASH_to_DOUT		= 18,
+	/* setup flows */
+	S_DIN_to_AES		= 32,
+	S_DIN_to_AES2		= 33,
+	S_DIN_to_DES		= 34,
+	S_DIN_to_RC4		= 35,
+	S_DIN_to_HASH		= 37,
+	S_AES_to_DOUT		= 38,
+	S_AES2_to_DOUT		= 39,
+	S_RC4_to_DOUT		= 41,
+	S_DES_to_DOUT		= 42,
+	S_HASH_to_DOUT		= 43,
+	SET_FLOW_ID		= 44,
+	FLOW_MODE_END = S32_MAX,
+};
+
+enum cc_tunnel_op {
+	TUNNEL_OP_INVALID = -1,
+	TUNNEL_OFF = 0,
+	TUNNEL_ON = 1,
+	TUNNEL_OP_END = S32_MAX,
+};
+
+enum cc_setup_op {
+	SETUP_LOAD_NOP		= 0,
+	SETUP_LOAD_STATE0	= 1,
+	SETUP_LOAD_STATE1	= 2,
+	SETUP_LOAD_STATE2	= 3,
+	SETUP_LOAD_KEY0		= 4,
+	SETUP_LOAD_XEX_KEY	= 5,
+	SETUP_WRITE_STATE0	= 8,
+	SETUP_WRITE_STATE1	= 9,
+	SETUP_WRITE_STATE2	= 10,
+	SETUP_WRITE_STATE3	= 11,
+	SETUP_OP_END = S32_MAX,
+};
+
+enum cc_aes_mac_selector {
+	AES_SK = 1,
+	AES_CMAC_INIT = 2,
+	AES_CMAC_SIZE0 = 3,
+	AES_MAC_END = S32_MAX,
+};
+
+#define HW_KEY_MASK_CIPHER_DO	  0x3
+#define HW_KEY_SHIFT_CIPHER_CFG2  2
+
+/* HwCryptoKey[1:0] is mapped to cipher_do[1:0] */
+/* HwCryptoKey[2:3] is mapped to cipher_config2[1:0] */
+enum cc_hw_crypto_key {
+	USER_KEY = 0,			/* 0x0000 */
+	ROOT_KEY = 1,			/* 0x0001 */
+	PROVISIONING_KEY = 2,		/* 0x0010 */ /* ==KCP */
+	SESSION_KEY = 3,		/* 0x0011 */
+	RESERVED_KEY = 4,		/* NA */
+	PLATFORM_KEY = 5,		/* 0x0101 */
+	CUSTOMER_KEY = 6,		/* 0x0110 */
+	KFDE0_KEY = 7,			/* 0x0111 */
+	KFDE1_KEY = 9,			/* 0x1001 */
+	KFDE2_KEY = 10,			/* 0x1010 */
+	KFDE3_KEY = 11,			/* 0x1011 */
+	END_OF_KEYS = S32_MAX,
+};
+
+enum cc_hw_aes_key_size {
+	AES_128_KEY = 0,
+	AES_192_KEY = 1,
+	AES_256_KEY = 2,
+	END_OF_AES_KEYS = S32_MAX,
+};
+
+enum cc_hw_des_key_size {
+	DES_ONE_KEY = 0,
+	DES_TWO_KEYS = 1,
+	DES_THREE_KEYS = 2,
+	END_OF_DES_KEYS = S32_MAX,
+};
+
+enum cc_hash_conf_pad {
+	HASH_PADDING_DISABLED = 0,
+	HASH_PADDING_ENABLED = 1,
+	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
+	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
+};
+
+enum cc_hash_cipher_pad {
+	DO_NOT_PAD = 0,
+	DO_PAD = 1,
+	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
+};
+
+/*****************************/
+/* Descriptor packing macros */
+/*****************************/
+
+/*
+ * Init a HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void hw_desc_init(struct cc_hw_desc *pdesc)
+{
+	memset(pdesc, 0, sizeof(struct cc_hw_desc));
+}
+
+/*
+ * Indicates the end of current HW descriptors flow and release the HW engines.
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_queue_last_ind(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[3] |= FIELD_PREP(WORD3_QUEUE_LAST_IND, 1);
+}
+
+/*
+ * Set the DIN field of a HW descriptors
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @dma_mode: dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * @addr: dinAdr DIN address
+ * @size: Data size in bytes
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_din_type(struct cc_hw_desc *pdesc,
+				enum cc_dma_mode dma_mode, dma_addr_t addr,
+				u32 size, enum cc_axi_sec axi_sec)
+{
+	pdesc->word[0] = (u32)addr;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	pdesc->word[5] |= FIELD_PREP(WORD5_DIN_ADDR_HIGH, ((u16)(addr >> 32)));
+#endif
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_DMA_MODE, dma_mode) |
+				FIELD_PREP(WORD1_DIN_SIZE, size) |
+				FIELD_PREP(WORD1_NS_BIT, axi_sec);
+}
+
+/*
+ * Set the DIN field of a HW descriptors to NO DMA mode.
+ * Used for NOP descriptor, register patches and other special modes.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DIN address
+ * @size: Data size in bytes
+ */
+static inline void set_din_no_dma(struct cc_hw_desc *pdesc, u32 addr, u32 size)
+{
+	pdesc->word[0] = addr;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size);
+}
+
+/*
+ * Set the DIN field of a HW descriptors to SRAM mode.
+ * Note: No need to check SRAM alignment since host requests do not use SRAM and
+ * adaptor will enforce alignment check.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DIN address
+ * @size Data size in bytes
+ */
+static inline void set_din_sram(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				u32 size)
+{
+	pdesc->word[0] = (u32)addr;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size) |
+				FIELD_PREP(WORD1_DIN_DMA_MODE, DMA_SRAM);
+}
+
+/*
+ * Set the DIN field of a HW descriptors to CONST mode
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @val: DIN const value
+ * @size: Data size in bytes
+ */
+static inline void set_din_const(struct cc_hw_desc *pdesc, u32 val, u32 size)
+{
+	pdesc->word[0] = val;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_CONST_VALUE, 1) |
+			FIELD_PREP(WORD1_DIN_DMA_MODE, DMA_SRAM) |
+			FIELD_PREP(WORD1_DIN_SIZE, size);
+}
+
+/*
+ * Set the DIN not last input data indicator
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_din_not_last_indication(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[1] |= FIELD_PREP(WORD1_NOT_LAST, 1);
+}
+
+/*
+ * Set the DOUT field of a HW descriptors
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @dma_mode: The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_dout_type(struct cc_hw_desc *pdesc,
+				 enum cc_dma_mode dma_mode, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec)
+{
+	pdesc->word[2] = (u32)addr;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	pdesc->word[5] |= FIELD_PREP(WORD5_DOUT_ADDR_HIGH, ((u16)(addr >> 32)));
+#endif
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_DMA_MODE, dma_mode) |
+				FIELD_PREP(WORD3_DOUT_SIZE, size) |
+				FIELD_PREP(WORD3_NS_BIT, axi_sec);
+}
+
+/*
+ * Set the DOUT field of a HW descriptors to DLLI type
+ * The LAST INDICATION is provided by the user
+ *
+ * @pdesc pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @last_ind: The last indication bit
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_dout_dlli(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec,
+				 u32 last_ind)
+{
+	set_dout_type(pdesc, DMA_DLLI, addr, size, axi_sec);
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_LAST_IND, last_ind);
+}
+
+/*
+ * Set the DOUT field of a HW descriptors to DLLI type
+ * The LAST INDICATION is provided by the user
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @last_ind: The last indication bit
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_dout_mlli(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec,
+				 bool last_ind)
+{
+	set_dout_type(pdesc, DMA_MLLI, addr, size, axi_sec);
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_LAST_IND, last_ind);
+}
+
+/*
+ * Set the DOUT field of a HW descriptors to NO DMA mode.
+ * Used for NOP descriptor, register patches and other special modes.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @write_enable: Enables a write operation to a register
+ */
+static inline void set_dout_no_dma(struct cc_hw_desc *pdesc, u32 addr,
+				   u32 size, bool write_enable)
+{
+	pdesc->word[2] = addr;
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_SIZE, size) |
+			FIELD_PREP(WORD3_DOUT_LAST_IND, write_enable);
+}
+
+/*
+ * Set the word for the XOR operation.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @val: xor data value
+ */
+static inline void set_xor_val(struct cc_hw_desc *pdesc, u32 val)
+{
+	pdesc->word[2] = val;
+}
+
+/*
+ * Sets the XOR indicator bit in the descriptor
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_xor_active(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[3] |= FIELD_PREP(WORD3_HASH_XOR_BIT, 1);
+}
+
+/*
+ * Select the AES engine instead of HASH engine when setting up combined mode
+ * with AES XCBC MAC
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_aes_not_hash_mode(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_AES_SEL_N_HASH, 1);
+}
+
+/*
+ * Set the DOUT field of a HW descriptors to SRAM mode
+ * Note: No need to check SRAM alignment since host requests do not use SRAM and
+ * adaptor will enforce alignment check.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ */
+static inline void set_dout_sram(struct cc_hw_desc *pdesc, u32 addr, u32 size)
+{
+	pdesc->word[2] = addr;
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_DMA_MODE, DMA_SRAM) |
+			FIELD_PREP(WORD3_DOUT_SIZE, size);
+}
+
+/*
+ * Sets the data unit size for XEX mode in data_out_addr[15:0]
+ *
+ * @pdesc: pDesc pointer HW descriptor struct
+ * @size: data unit size for XEX mode
+ */
+static inline void set_xex_data_unit_size(struct cc_hw_desc *pdesc, u32 size)
+{
+	pdesc->word[2] = size;
+}
+
+/*
+ * Set the number of rounds for Multi2 in data_out_addr[15:0]
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @num: number of rounds for Multi2
+ */
+static inline void set_multi2_num_rounds(struct cc_hw_desc *pdesc, u32 num)
+{
+	pdesc->word[2] = num;
+}
+
+/*
+ * Set the flow mode.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_flow_mode(struct cc_hw_desc *pdesc,
+				 enum cc_flow_mode mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_DATA_FLOW_MODE, mode);
+}
+
+/*
+ * Set the cipher mode.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @mode:  Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
+				   enum drv_cipher_mode mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
+}
+
+/*
+ * Set the cipher configuration fields.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
+				      enum drv_crypto_direction mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
+}
+
+/*
+ * Set the cipher configuration fields.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_config1(struct cc_hw_desc *pdesc,
+				      enum cc_hash_conf_pad config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF1, config);
+}
+
+/*
+ * Set HW key configuration fields.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @hw_key: The HW key slot asdefined in enum cc_hw_crypto_key
+ */
+static inline void set_hw_crypto_key(struct cc_hw_desc *pdesc,
+				     enum cc_hw_crypto_key hw_key)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_DO,
+				     (hw_key & HW_KEY_MASK_CIPHER_DO)) |
+			FIELD_PREP(WORD4_CIPHER_CONF2,
+				   (hw_key >> HW_KEY_SHIFT_CIPHER_CFG2));
+}
+
+/*
+ * Set byte order of all setup-finalize descriptors.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_bytes_swap(struct cc_hw_desc *pdesc, bool config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_BYTES_SWAP, config);
+}
+
+/*
+ * Set CMAC_SIZE0 mode.
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_cmac_size0_mode(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CMAC_SIZE0, 1);
+}
+
+/*
+ * Set key size descriptor field.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size(struct cc_hw_desc *pdesc, u32 size)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_KEY_SIZE, size);
+}
+
+/*
+ * Set AES key size.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size_aes(struct cc_hw_desc *pdesc, u32 size)
+{
+	set_key_size(pdesc, ((size >> 3) - 2));
+}
+
+/*
+ * Set DES key size.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size_des(struct cc_hw_desc *pdesc, u32 size)
+{
+	set_key_size(pdesc, ((size >> 3) - 1));
+}
+
+/*
+ * Set the descriptor setup mode
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the setup modes defined in [CC7x-DESC]
+ */
+static inline void set_setup_mode(struct cc_hw_desc *pdesc,
+				  enum cc_setup_op mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_SETUP_OPERATION, mode);
+}
+
+/*
+ * Set the descriptor cipher DO
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the cipher do defined in [CC7x-DESC]
+ */
+static inline void set_cipher_do(struct cc_hw_desc *pdesc,
+				 enum cc_hash_cipher_pad config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_DO,
+				(config & HW_KEY_MASK_CIPHER_DO));
+}
+
+#endif /*__CC_HW_QUEUE_DEFS_H__*/
diff --git a/drivers/crypto/ccree/cc_ivgen.c b/drivers/crypto/ccree/cc_ivgen.c
new file mode 100644
index 0000000..7da4491
--- /dev/null
+++ b/drivers/crypto/ccree/cc_ivgen.c
@@ -0,0 +1,280 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <crypto/ctr.h>
+#include "cc_driver.h"
+#include "cc_ivgen.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_buffer_mgr.h"
+
+/* The max. size of pool *MUST* be <= SRAM total size */
+#define CC_IVPOOL_SIZE 1024
+/* The first 32B fraction of pool are dedicated to the
+ * next encryption "key" & "IV" for pool regeneration
+ */
+#define CC_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
+#define CC_IVPOOL_GEN_SEQ_LEN	4
+
+/**
+ * struct cc_ivgen_ctx -IV pool generation context
+ * @pool:          the start address of the iv-pool resides in internal RAM
+ * @ctr_key_dma:   address of pool's encryption key material in internal RAM
+ * @ctr_iv_dma:    address of pool's counter iv in internal RAM
+ * @next_iv_ofs:   the offset to the next available IV in pool
+ * @pool_meta:     virt. address of the initial enc. key/IV
+ * @pool_meta_dma: phys. address of the initial enc. key/IV
+ */
+struct cc_ivgen_ctx {
+	cc_sram_addr_t pool;
+	cc_sram_addr_t ctr_key;
+	cc_sram_addr_t ctr_iv;
+	u32 next_iv_ofs;
+	u8 *pool_meta;
+	dma_addr_t pool_meta_dma;
+};
+
+/*!
+ * Generates CC_IVPOOL_SIZE of random bytes by
+ * encrypting 0's using AES128-CTR.
+ *
+ * \param ivgen iv-pool context
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ */
+static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
+			  struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
+{
+	unsigned int idx = *iv_seq_len;
+
+	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > CC_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+	/* Setup key */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Setup cipher state */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_STATE1);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
+	idx++;
+
+	/* Perform dummy encrypt to skip first block */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, CC_AES_IV_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	/* Generate IV pool */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, CC_IVPOOL_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_IVPOOL_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
+	idx++;
+
+	*iv_seq_len = idx; /* Update sequence length */
+
+	/* queue ordering assures pool readiness */
+	ivgen_ctx->next_iv_ofs = CC_IVPOOL_META_SIZE;
+
+	return 0;
+}
+
+/*!
+ * Generates the initial pool in SRAM.
+ * This function should be invoked when resuming driver.
+ *
+ * \param drvdata
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_init_iv_sram(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
+	unsigned int iv_seq_len = 0;
+	int rc;
+
+	/* Generate initial enc. key/iv */
+	get_random_bytes(ivgen_ctx->pool_meta, CC_IVPOOL_META_SIZE);
+
+	/* The first 32B reserved for the enc. Key/IV */
+	ivgen_ctx->ctr_key = ivgen_ctx->pool;
+	ivgen_ctx->ctr_iv = ivgen_ctx->pool + AES_KEYSIZE_128;
+
+	/* Copy initial enc. key and IV to SRAM at a single descriptor */
+	hw_desc_init(&iv_seq[iv_seq_len]);
+	set_din_type(&iv_seq[iv_seq_len], DMA_DLLI, ivgen_ctx->pool_meta_dma,
+		     CC_IVPOOL_META_SIZE, NS_BIT);
+	set_dout_sram(&iv_seq[iv_seq_len], ivgen_ctx->pool,
+		      CC_IVPOOL_META_SIZE);
+	set_flow_mode(&iv_seq[iv_seq_len], BYPASS);
+	iv_seq_len++;
+
+	/* Generate initial pool */
+	rc = cc_gen_iv_pool(ivgen_ctx, iv_seq, &iv_seq_len);
+	if (rc)
+		return rc;
+
+	/* Fire-and-forget */
+	return send_request_init(drvdata, iv_seq, iv_seq_len);
+}
+
+/*!
+ * Free iv-pool and ivgen context.
+ *
+ * \param drvdata
+ */
+void cc_ivgen_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct device *device = &drvdata->plat_dev->dev;
+
+	if (!ivgen_ctx)
+		return;
+
+	if (ivgen_ctx->pool_meta) {
+		memset(ivgen_ctx->pool_meta, 0, CC_IVPOOL_META_SIZE);
+		dma_free_coherent(device, CC_IVPOOL_META_SIZE,
+				  ivgen_ctx->pool_meta,
+				  ivgen_ctx->pool_meta_dma);
+	}
+
+	ivgen_ctx->pool = NULL_SRAM_ADDR;
+
+	/* release "this" context */
+	kfree(ivgen_ctx);
+}
+
+/*!
+ * Allocates iv-pool and maps resources.
+ * This function generates the first IV pool.
+ *
+ * \param drvdata Driver's private context
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_ivgen_init(struct cc_drvdata *drvdata)
+{
+	struct cc_ivgen_ctx *ivgen_ctx;
+	struct device *device = &drvdata->plat_dev->dev;
+	int rc;
+
+	/* Allocate "this" context */
+	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
+	if (!ivgen_ctx)
+		return -ENOMEM;
+
+	/* Allocate pool's header for initial enc. key/IV */
+	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
+						  &ivgen_ctx->pool_meta_dma,
+						  GFP_KERNEL);
+	if (!ivgen_ctx->pool_meta) {
+		dev_err(device, "Not enough memory to allocate DMA of pool_meta (%u B)\n",
+			CC_IVPOOL_META_SIZE);
+		rc = -ENOMEM;
+		goto out;
+	}
+	/* Allocate IV pool in SRAM */
+	ivgen_ctx->pool = cc_sram_alloc(drvdata, CC_IVPOOL_SIZE);
+	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
+		dev_err(device, "SRAM pool exhausted\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	drvdata->ivgen_handle = ivgen_ctx;
+
+	return cc_init_iv_sram(drvdata);
+
+out:
+	cc_ivgen_fini(drvdata);
+	return rc;
+}
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ *
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements
+ *                       of iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
+{
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	unsigned int idx = *iv_seq_len;
+	struct device *dev = drvdata_to_dev(drvdata);
+	unsigned int t;
+
+	if (iv_out_size != CC_AES_IV_SIZE &&
+	    iv_out_size != CTR_RFC3686_IV_SIZE) {
+		return -EINVAL;
+	}
+	if ((iv_out_dma_len + 1) > CC_IVPOOL_SEQ_LEN) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	/* check that number of generated IV is limited to max dma address
+	 * iv buffer size
+	 */
+	if (iv_out_dma_len > CC_MAX_IVGEN_DMA_ADDRESSES) {
+		/* The sequence will be longer than allowed */
+		return -EINVAL;
+	}
+
+	for (t = 0; t < iv_out_dma_len; t++) {
+		/* Acquire IV from pool */
+		hw_desc_init(&iv_seq[idx]);
+		set_din_sram(&iv_seq[idx], (ivgen_ctx->pool +
+					    ivgen_ctx->next_iv_ofs),
+			     iv_out_size);
+		set_dout_dlli(&iv_seq[idx], iv_out_dma[t], iv_out_size,
+			      NS_BIT, 0);
+		set_flow_mode(&iv_seq[idx], BYPASS);
+		idx++;
+	}
+
+	/* Bypass operation is proceeded by crypto sequence, hence must
+	 *  assure bypass-write-transaction by a memory barrier
+	 */
+	hw_desc_init(&iv_seq[idx]);
+	set_din_no_dma(&iv_seq[idx], 0, 0xfffff0);
+	set_dout_no_dma(&iv_seq[idx], 0, 0, 1);
+	idx++;
+
+	*iv_seq_len = idx; /* update seq length */
+
+	/* Update iv index */
+	ivgen_ctx->next_iv_ofs += iv_out_size;
+
+	if ((CC_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
+		dev_dbg(dev, "Pool exhausted, regenerating iv-pool\n");
+		/* pool is drained -regenerate it! */
+		return cc_gen_iv_pool(ivgen_ctx, iv_seq, iv_seq_len);
+	}
+
+	return 0;
+}
+
diff --git a/drivers/crypto/ccree/cc_ivgen.h b/drivers/crypto/ccree/cc_ivgen.h
new file mode 100644
index 0000000..b6ac169
--- /dev/null
+++ b/drivers/crypto/ccree/cc_ivgen.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_IVGEN_H__
+#define __CC_IVGEN_H__
+
+#include "cc_hw_queue_defs.h"
+
+#define CC_IVPOOL_SEQ_LEN 8
+
+/*!
+ * Allocates iv-pool and maps resources.
+ * This function generates the first IV pool.
+ *
+ * \param drvdata Driver's private context
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_ivgen_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Free iv-pool and ivgen context.
+ *
+ * \param drvdata
+ */
+void cc_ivgen_fini(struct cc_drvdata *drvdata);
+
+/*!
+ * Generates the initial pool in SRAM.
+ * This function should be invoked when resuming DX driver.
+ *
+ * \param drvdata
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_init_iv_sram(struct cc_drvdata *drvdata);
+
+/*!
+ * Acquires 16 Bytes IV from the iv-pool
+ *
+ * \param drvdata Driver private context
+ * \param iv_out_dma Array of physical IV out addresses
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements of
+ *                       iv_out_dma array are ignore)
+ * \param iv_out_size May be 8 or 16 bytes long
+ * \param iv_seq IN/OUT array to the descriptors sequence
+ * \param iv_seq_len IN/OUT pointer to the sequence length
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_get_iv(struct cc_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
+
+#endif /*__CC_IVGEN_H__*/
diff --git a/drivers/crypto/ccree/cc_kernel_regs.h b/drivers/crypto/ccree/cc_kernel_regs.h
new file mode 100644
index 0000000..fa99440
--- /dev/null
+++ b/drivers/crypto/ccree/cc_kernel_regs.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_CRYS_KERNEL_H__
+#define __CC_CRYS_KERNEL_H__
+
+// --------------------------------------
+// BLOCK: DSCRPTR
+// --------------------------------------
+#define CC_DSCRPTR_COMPLETION_COUNTER_REG_OFFSET	0xE00UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_COMPLETION_COUNTER_BIT_SIZE	0x6UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SHIFT	0x6UL
+#define CC_DSCRPTR_COMPLETION_COUNTER_OVERFLOW_COUNTER_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_SW_RESET_REG_OFFSET	0xE40UL
+#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_SW_RESET_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_REG_OFFSET	0xE60UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_NUM_OF_DSCRPTR_BIT_SIZE	0xAUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SHIFT	0xAUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_DSCRPTR_SRAM_SIZE_BIT_SIZE	0xCUL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SHIFT	0x16UL
+#define CC_DSCRPTR_QUEUE_SRAM_SIZE_SRAM_SIZE_BIT_SIZE	0x3UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_REG_OFFSET	0xE64UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_SINGLE_ADDR_EN_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_MEASURE_CNTR_REG_OFFSET	0xE68UL
+#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_MEASURE_CNTR_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD0_REG_OFFSET	0xE80UL
+#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD1_REG_OFFSET	0xE84UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SHIFT	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SHIFT	0x1AUL
+#define CC_DSCRPTR_QUEUE_WORD1_NS_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SHIFT	0x1BUL
+#define CC_DSCRPTR_QUEUE_WORD1_DIN_CONST_VALUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SHIFT	0x1CUL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_LAST_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD1_LOCK_QUEUE_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD1_NOT_USED_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD2_REG_OFFSET	0xE88UL
+#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD2_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD3_REG_OFFSET	0xE8CUL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_DMA_MODE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SHIFT	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_SIZE_BIT_SIZE	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SHIFT	0x1AUL
+#define CC_DSCRPTR_QUEUE_WORD3_NS_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SHIFT	0x1BUL
+#define CC_DSCRPTR_QUEUE_WORD3_DOUT_LAST_IND_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD3_HASH_XOR_BIT_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD3_NOT_USED_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SHIFT	0x1FUL
+#define CC_DSCRPTR_QUEUE_WORD3_QUEUE_LAST_IND_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_REG_OFFSET	0xE90UL
+#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD4_DATA_FLOW_MODE_BIT_SIZE	0x6UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SHIFT	0x6UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_SEL_N_HASH_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SHIFT	0x7UL
+#define CC_DSCRPTR_QUEUE_WORD4_AES_XOR_CRYPTO_KEY_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SHIFT	0x8UL
+#define CC_DSCRPTR_QUEUE_WORD4_ACK_NEEDED_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SHIFT	0xAUL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_MODE_BIT_SIZE	0x4UL
+#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SHIFT	0xEUL
+#define CC_DSCRPTR_QUEUE_WORD4_CMAC_SIZE0_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SHIFT	0xFUL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_DO_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SHIFT	0x11UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF0_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SHIFT	0x13UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF1_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SHIFT	0x14UL
+#define CC_DSCRPTR_QUEUE_WORD4_CIPHER_CONF2_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SHIFT	0x16UL
+#define CC_DSCRPTR_QUEUE_WORD4_KEY_SIZE_BIT_SIZE	0x2UL
+#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SHIFT	0x18UL
+#define CC_DSCRPTR_QUEUE_WORD4_SETUP_OPERATION_BIT_SIZE	0x4UL
+#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SHIFT	0x1CUL
+#define CC_DSCRPTR_QUEUE_WORD4_DIN_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SHIFT	0x1DUL
+#define CC_DSCRPTR_QUEUE_WORD4_DOUT_SRAM_ENDIANNESS_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SHIFT	0x1EUL
+#define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT	0x1FUL
+#define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD5_REG_OFFSET	0xE94UL
+#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE	0x10UL
+#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SHIFT	0x10UL
+#define CC_DSCRPTR_QUEUE_WORD5_DOUT_ADDR_HIGH_BIT_SIZE	0x10UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_REG_OFFSET	0xE98UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_WATERMARK_VALUE_BIT_SIZE	0xAUL
+#define CC_DSCRPTR_QUEUE_CONTENT_REG_OFFSET	0xE9CUL
+#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SHIFT	0x0UL
+#define CC_DSCRPTR_QUEUE_CONTENT_VALUE_BIT_SIZE	0xAUL
+// --------------------------------------
+// BLOCK: AXI_P
+// --------------------------------------
+#define CC_AXIM_MON_INFLIGHT_REG_OFFSET	0xB00UL
+#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_INFLIGHT_VALUE_BIT_SIZE	0x8UL
+#define CC_AXIM_MON_INFLIGHTLAST_REG_OFFSET	0xB40UL
+#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SIZE	0x8UL
+#define CC_AXIM_MON_COMP_REG_OFFSET	0xB80UL
+#define CC_AXIM_MON_COMP_VALUE_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_COMP_VALUE_BIT_SIZE	0x10UL
+#define CC_AXIM_MON_ERR_REG_OFFSET	0xBC4UL
+#define CC_AXIM_MON_ERR_BRESP_BIT_SHIFT	0x0UL
+#define CC_AXIM_MON_ERR_BRESP_BIT_SIZE	0x2UL
+#define CC_AXIM_MON_ERR_BID_BIT_SHIFT	0x2UL
+#define CC_AXIM_MON_ERR_BID_BIT_SIZE	0x4UL
+#define CC_AXIM_MON_ERR_RRESP_BIT_SHIFT	0x10UL
+#define CC_AXIM_MON_ERR_RRESP_BIT_SIZE	0x2UL
+#define CC_AXIM_MON_ERR_RID_BIT_SHIFT	0x12UL
+#define CC_AXIM_MON_ERR_RID_BIT_SIZE	0x4UL
+#define CC_AXIM_CFG_REG_OFFSET	0xBE8UL
+#define CC_AXIM_CFG_BRESPMASK_BIT_SHIFT	0x4UL
+#define CC_AXIM_CFG_BRESPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_RRESPMASK_BIT_SHIFT	0x5UL
+#define CC_AXIM_CFG_RRESPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_INFLTMASK_BIT_SHIFT	0x6UL
+#define CC_AXIM_CFG_INFLTMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_CFG_COMPMASK_BIT_SHIFT	0x7UL
+#define CC_AXIM_CFG_COMPMASK_BIT_SIZE	0x1UL
+#define CC_AXIM_ACE_CONST_REG_OFFSET	0xBECUL
+#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SHIFT	0x0UL
+#define CC_AXIM_ACE_CONST_ARDOMAIN_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SHIFT	0x2UL
+#define CC_AXIM_ACE_CONST_AWDOMAIN_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_ARBAR_BIT_SHIFT	0x4UL
+#define CC_AXIM_ACE_CONST_ARBAR_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_AWBAR_BIT_SHIFT	0x6UL
+#define CC_AXIM_ACE_CONST_AWBAR_BIT_SIZE	0x2UL
+#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SHIFT	0x8UL
+#define CC_AXIM_ACE_CONST_ARSNOOP_BIT_SIZE	0x4UL
+#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SHIFT	0xCUL
+#define CC_AXIM_ACE_CONST_AWSNOOP_NOT_ALIGNED_BIT_SIZE	0x3UL
+#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SHIFT	0xFUL
+#define CC_AXIM_ACE_CONST_AWSNOOP_ALIGNED_BIT_SIZE	0x3UL
+#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SHIFT	0x12UL
+#define CC_AXIM_ACE_CONST_AWADDR_NOT_MASKED_BIT_SIZE	0x7UL
+#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SHIFT	0x19UL
+#define CC_AXIM_ACE_CONST_AWLEN_VAL_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_REG_OFFSET	0xBF0UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SHIFT	0x0UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_LAST_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SHIFT	0x4UL
+#define CC_AXIM_CACHE_PARAMS_AWCACHE_BIT_SIZE	0x4UL
+#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SHIFT	0x8UL
+#define CC_AXIM_CACHE_PARAMS_ARCACHE_BIT_SIZE	0x4UL
+#endif	// __CC_CRYS_KERNEL_H__
diff --git a/drivers/crypto/ccree/cc_lli_defs.h b/drivers/crypto/ccree/cc_lli_defs.h
new file mode 100644
index 0000000..64b15ac
--- /dev/null
+++ b/drivers/crypto/ccree/cc_lli_defs.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef _CC_LLI_DEFS_H_
+#define _CC_LLI_DEFS_H_
+
+#include <linux/types.h>
+
+/* Max DLLI size
+ *  AKA CC_DSCRPTR_QUEUE_WORD1_DIN_SIZE_BIT_SIZE
+ */
+#define DLLI_SIZE_BIT_SIZE	0x18
+
+#define CC_MAX_MLLI_ENTRY_SIZE 0xFFFF
+
+#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
+#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
+#define MLLI_TABLE_MIN_ALIGNMENT 4 /* 32 bit alignment */
+#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
+#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES \
+		(2 * LLI_MAX_NUM_OF_DATA_ENTRIES + \
+		 LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)
+
+/* Size of entry */
+#define LLI_ENTRY_WORD_SIZE 2
+#define LLI_ENTRY_BYTE_SIZE (LLI_ENTRY_WORD_SIZE * sizeof(u32))
+
+/* Word0[31:0] = ADDR[31:0] */
+#define LLI_WORD0_OFFSET 0
+#define LLI_LADDR_BIT_OFFSET 0
+#define LLI_LADDR_BIT_SIZE 32
+/* Word1[31:16] = ADDR[47:32]; Word1[15:0] = SIZE */
+#define LLI_WORD1_OFFSET 1
+#define LLI_SIZE_BIT_OFFSET 0
+#define LLI_SIZE_BIT_SIZE 16
+#define LLI_HADDR_BIT_OFFSET 16
+#define LLI_HADDR_BIT_SIZE 16
+
+#define LLI_SIZE_MASK GENMASK((LLI_SIZE_BIT_SIZE - 1), LLI_SIZE_BIT_OFFSET)
+#define LLI_HADDR_MASK GENMASK( \
+			       (LLI_HADDR_BIT_OFFSET + LLI_HADDR_BIT_SIZE - 1),\
+				LLI_HADDR_BIT_OFFSET)
+
+static inline void cc_lli_set_addr(u32 *lli_p, dma_addr_t addr)
+{
+	lli_p[LLI_WORD0_OFFSET] = (addr & U32_MAX);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	lli_p[LLI_WORD1_OFFSET] &= ~LLI_HADDR_MASK;
+	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_HADDR_MASK, (addr >> 32));
+#endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
+}
+
+static inline void cc_lli_set_size(u32 *lli_p, u16 size)
+{
+	lli_p[LLI_WORD1_OFFSET] &= ~LLI_SIZE_MASK;
+	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_SIZE_MASK, size);
+}
+
+#endif /*_CC_LLI_DEFS_H_*/
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
new file mode 100644
index 0000000..b2d35e0
--- /dev/null
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_pm.h"
+
+#define POWER_DOWN_ENABLE 0x01
+#define POWER_DOWN_DISABLE 0x00
+
+const struct dev_pm_ops ccree_pm = {
+	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
+};
+
+int cc_pm_suspend(struct device *dev)
+{
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+	int rc;
+
+	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
+	rc = cc_suspend_req_queue(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_suspend_req_queue (%x)\n", rc);
+		return rc;
+	}
+	fini_cc_regs(drvdata);
+	cc_clk_off(drvdata);
+	return 0;
+}
+
+int cc_pm_resume(struct device *dev)
+{
+	int rc;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+
+	rc = cc_clk_on(drvdata);
+	if (rc) {
+		dev_err(dev, "failed getting clock back on. We're toast.\n");
+		return rc;
+	}
+
+	rc = init_cc_regs(drvdata, false);
+	if (rc) {
+		dev_err(dev, "init_cc_regs (%x)\n", rc);
+		return rc;
+	}
+
+	rc = cc_resume_req_queue(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
+		return rc;
+	}
+
+	cc_init_iv_sram(drvdata);
+	return 0;
+}
+
+int cc_pm_get(struct device *dev)
+{
+	int rc = 0;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	if (cc_req_queue_suspended(drvdata))
+		rc = pm_runtime_get_sync(dev);
+	else
+		pm_runtime_get_noresume(dev);
+
+	return rc;
+}
+
+int cc_pm_put_suspend(struct device *dev)
+{
+	int rc = 0;
+	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+
+	if (!cc_req_queue_suspended(drvdata)) {
+		pm_runtime_mark_last_busy(dev);
+		rc = pm_runtime_put_autosuspend(dev);
+	} else {
+		/* Something wrong happens*/
+		dev_err(dev, "request to suspend already suspended queue");
+		rc = -EBUSY;
+	}
+	return rc;
+}
+
+int cc_pm_init(struct cc_drvdata *drvdata)
+{
+	int rc = 0;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* must be before the enabling to avoid resdundent suspending */
+	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(dev);
+	/* activate the PM module */
+	rc = pm_runtime_set_active(dev);
+	if (rc)
+		return rc;
+	/* enable the PM module*/
+	pm_runtime_enable(dev);
+
+	return rc;
+}
+
+void cc_pm_fini(struct cc_drvdata *drvdata)
+{
+	pm_runtime_disable(drvdata_to_dev(drvdata));
+}
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
new file mode 100644
index 0000000..aac8190
--- /dev/null
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_pm.h
+ */
+
+#ifndef __CC_POWER_MGR_H__
+#define __CC_POWER_MGR_H__
+
+#include "cc_driver.h"
+
+#define CC_SUSPEND_TIMEOUT 3000
+
+#if defined(CONFIG_PM)
+
+extern const struct dev_pm_ops ccree_pm;
+
+int cc_pm_init(struct cc_drvdata *drvdata);
+void cc_pm_fini(struct cc_drvdata *drvdata);
+int cc_pm_suspend(struct device *dev);
+int cc_pm_resume(struct device *dev);
+int cc_pm_get(struct device *dev);
+int cc_pm_put_suspend(struct device *dev);
+
+#else
+
+static inline int cc_pm_init(struct cc_drvdata *drvdata)
+{
+	return 0;
+}
+
+static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
+
+static inline int cc_pm_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_resume(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_get(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_put_suspend(struct device *dev)
+{
+	return 0;
+}
+
+#endif
+
+#endif /*__POWER_MGR_H__*/
+
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
new file mode 100644
index 0000000..cb51a25
--- /dev/null
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -0,0 +1,713 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_pm.h"
+
+#define CC_MAX_POLL_ITER	10
+/* The highest descriptor count in used */
+#define CC_MAX_DESC_SEQ_LEN	23
+
+struct cc_req_mgr_handle {
+	/* Request manager resources */
+	unsigned int hw_queue_size; /* HW capability */
+	unsigned int min_free_hw_slots;
+	unsigned int max_used_sw_slots;
+	struct cc_crypto_req req_queue[MAX_REQUEST_QUEUE_SIZE];
+	u32 req_queue_head;
+	u32 req_queue_tail;
+	u32 axi_completed;
+	u32 q_free_slots;
+	/* This lock protects access to HW register
+	 * that must be single request at a time
+	 */
+	spinlock_t hw_lock;
+	struct cc_hw_desc compl_desc;
+	u8 *dummy_comp_buff;
+	dma_addr_t dummy_comp_buff_dma;
+
+	/* backlog queue */
+	struct list_head backlog;
+	unsigned int bl_len;
+	spinlock_t bl_lock; /* protect backlog queue */
+
+#ifdef COMP_IN_WQ
+	struct workqueue_struct *workq;
+	struct delayed_work compwork;
+#else
+	struct tasklet_struct comptask;
+#endif
+	bool is_runtime_suspended;
+};
+
+struct cc_bl_item {
+	struct cc_crypto_req creq;
+	struct cc_hw_desc desc[CC_MAX_DESC_SEQ_LEN];
+	unsigned int len;
+	struct list_head list;
+	bool notif;
+};
+
+static void comp_handler(unsigned long devarg);
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work);
+#endif
+
+void cc_req_mgr_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	if (!req_mgr_h)
+		return; /* Not allocated */
+
+	if (req_mgr_h->dummy_comp_buff_dma) {
+		dma_free_coherent(dev, sizeof(u32), req_mgr_h->dummy_comp_buff,
+				  req_mgr_h->dummy_comp_buff_dma);
+	}
+
+	dev_dbg(dev, "max_used_hw_slots=%d\n", (req_mgr_h->hw_queue_size -
+						req_mgr_h->min_free_hw_slots));
+	dev_dbg(dev, "max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
+
+#ifdef COMP_IN_WQ
+	flush_workqueue(req_mgr_h->workq);
+	destroy_workqueue(req_mgr_h->workq);
+#else
+	/* Kill tasklet */
+	tasklet_kill(&req_mgr_h->comptask);
+#endif
+	memset(req_mgr_h, 0, sizeof(struct cc_req_mgr_handle));
+	kfree(req_mgr_h);
+	drvdata->request_mgr_handle = NULL;
+}
+
+int cc_req_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *req_mgr_h;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc = 0;
+
+	req_mgr_h = kzalloc(sizeof(*req_mgr_h), GFP_KERNEL);
+	if (!req_mgr_h) {
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+
+	drvdata->request_mgr_handle = req_mgr_h;
+
+	spin_lock_init(&req_mgr_h->hw_lock);
+	spin_lock_init(&req_mgr_h->bl_lock);
+	INIT_LIST_HEAD(&req_mgr_h->backlog);
+
+#ifdef COMP_IN_WQ
+	dev_dbg(dev, "Initializing completion workqueue\n");
+	req_mgr_h->workq = create_singlethread_workqueue("ccree");
+	if (!req_mgr_h->workq) {
+		dev_err(dev, "Failed creating work queue\n");
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
+#else
+	dev_dbg(dev, "Initializing completion tasklet\n");
+	tasklet_init(&req_mgr_h->comptask, comp_handler,
+		     (unsigned long)drvdata);
+#endif
+	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
+					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
+	dev_dbg(dev, "hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
+	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
+		dev_err(dev, "Invalid HW queue size = %u (Min. required is %u)\n",
+			req_mgr_h->hw_queue_size, MIN_HW_QUEUE_SIZE);
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+	req_mgr_h->min_free_hw_slots = req_mgr_h->hw_queue_size;
+	req_mgr_h->max_used_sw_slots = 0;
+
+	/* Allocate DMA word for "dummy" completion descriptor use */
+	req_mgr_h->dummy_comp_buff =
+		dma_alloc_coherent(dev, sizeof(u32),
+				   &req_mgr_h->dummy_comp_buff_dma,
+				   GFP_KERNEL);
+	if (!req_mgr_h->dummy_comp_buff) {
+		dev_err(dev, "Not enough memory to allocate DMA (%zu) dropped buffer\n",
+			sizeof(u32));
+		rc = -ENOMEM;
+		goto req_mgr_init_err;
+	}
+
+	/* Init. "dummy" completion descriptor */
+	hw_desc_init(&req_mgr_h->compl_desc);
+	set_din_const(&req_mgr_h->compl_desc, 0, sizeof(u32));
+	set_dout_dlli(&req_mgr_h->compl_desc, req_mgr_h->dummy_comp_buff_dma,
+		      sizeof(u32), NS_BIT, 1);
+	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
+	set_queue_last_ind(&req_mgr_h->compl_desc);
+
+	return 0;
+
+req_mgr_init_err:
+	cc_req_mgr_fini(drvdata);
+	return rc;
+}
+
+static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
+			unsigned int seq_len)
+{
+	int i, w;
+	void __iomem *reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/*
+	 * We do indeed write all 6 command words to the same
+	 * register. The HW supports this.
+	 */
+
+	for (i = 0; i < seq_len; i++) {
+		for (w = 0; w <= 5; w++)
+			writel_relaxed(seq[i].word[w], reg);
+
+		if (cc_dump_desc)
+			dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
+				i, seq[i].word[0], seq[i].word[1],
+				seq[i].word[2], seq[i].word[3],
+				seq[i].word[4], seq[i].word[5]);
+	}
+}
+
+/*!
+ * Completion will take place if and only if user requested completion
+ * by cc_send_sync_request().
+ *
+ * \param dev
+ * \param dx_compl_h The completion event to signal
+ */
+static void request_mgr_complete(struct device *dev, void *dx_compl_h,
+				 int dummy)
+{
+	struct completion *this_compl = dx_compl_h;
+
+	complete(this_compl);
+}
+
+static int cc_queues_status(struct cc_drvdata *drvdata,
+			    struct cc_req_mgr_handle *req_mgr_h,
+			    unsigned int total_seq_len)
+{
+	unsigned long poll_queue;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	/* SW queue is checked only once as it will not
+	 * be chaned during the poll because the spinlock_bh
+	 * is held by the thread
+	 */
+	if (((req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1)) ==
+	    req_mgr_h->req_queue_tail) {
+		dev_err(dev, "SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
+			req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
+		return -ENOSPC;
+	}
+
+	if (req_mgr_h->q_free_slots >= total_seq_len)
+		return 0;
+
+	/* Wait for space in HW queue. Poll constant num of iterations. */
+	for (poll_queue = 0; poll_queue < CC_MAX_POLL_ITER ; poll_queue++) {
+		req_mgr_h->q_free_slots =
+			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
+		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots)
+			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
+
+		if (req_mgr_h->q_free_slots >= total_seq_len) {
+			/* If there is enough place return */
+			return 0;
+		}
+
+		dev_dbg(dev, "HW FIFO is full. q_free_slots=%d total_seq_len=%d\n",
+			req_mgr_h->q_free_slots, total_seq_len);
+	}
+	/* No room in the HW queue try again later */
+	dev_dbg(dev, "HW FIFO full, timeout. req_queue_head=%d sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
+		req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE,
+		req_mgr_h->q_free_slots, total_seq_len);
+	return -ENOSPC;
+}
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ * Need to be called with HW lock held and PM running
+ *
+ * \param drvdata
+ * \param cc_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param add_comp If "true": add an artificial dout DMA to mark completion
+ *
+ * \return int Returns -EINPROGRESS or error code
+ */
+static int cc_do_send_request(struct cc_drvdata *drvdata,
+			      struct cc_crypto_req *cc_req,
+			      struct cc_hw_desc *desc, unsigned int len,
+				bool add_comp, bool ivgen)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int used_sw_slots;
+	unsigned int iv_seq_len = 0;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc;
+
+	if (ivgen) {
+		dev_dbg(dev, "Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
+			cc_req->ivgen_dma_addr_len,
+			&cc_req->ivgen_dma_addr[0],
+			&cc_req->ivgen_dma_addr[1],
+			&cc_req->ivgen_dma_addr[2],
+			cc_req->ivgen_size);
+
+		/* Acquire IV from pool */
+		rc = cc_get_iv(drvdata, cc_req->ivgen_dma_addr,
+			       cc_req->ivgen_dma_addr_len,
+			       cc_req->ivgen_size, iv_seq, &iv_seq_len);
+
+		if (rc) {
+			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
+			return rc;
+		}
+
+		total_seq_len += iv_seq_len;
+	}
+
+	used_sw_slots = ((req_mgr_h->req_queue_head -
+			  req_mgr_h->req_queue_tail) &
+			 (MAX_REQUEST_QUEUE_SIZE - 1));
+	if (used_sw_slots > req_mgr_h->max_used_sw_slots)
+		req_mgr_h->max_used_sw_slots = used_sw_slots;
+
+	/* Enqueue request - must be locked with HW lock*/
+	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *cc_req;
+	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
+				    (MAX_REQUEST_QUEUE_SIZE - 1);
+	/* TODO: Use circ_buf.h ? */
+
+	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
+
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
+
+	/* STAT_PHASE_4: Push sequence */
+	if (ivgen)
+		enqueue_seq(drvdata, iv_seq, iv_seq_len);
+
+	enqueue_seq(drvdata, desc, len);
+
+	if (add_comp) {
+		enqueue_seq(drvdata, &req_mgr_h->compl_desc, 1);
+		total_seq_len++;
+	}
+
+	if (req_mgr_h->q_free_slots < total_seq_len) {
+		/* This situation should never occur. Maybe indicating problem
+		 * with resuming power. Set the free slot count to 0 and hope
+		 * for the best.
+		 */
+		dev_err(dev, "HW free slot count mismatch.");
+		req_mgr_h->q_free_slots = 0;
+	} else {
+		/* Update the free slots in HW queue */
+		req_mgr_h->q_free_slots -= total_seq_len;
+	}
+
+	/* Operation still in process */
+	return -EINPROGRESS;
+}
+
+static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
+			       struct cc_bl_item *bli)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	spin_lock_bh(&mgr->bl_lock);
+	list_add_tail(&bli->list, &mgr->backlog);
+	++mgr->bl_len;
+	spin_unlock_bh(&mgr->bl_lock);
+	tasklet_schedule(&mgr->comptask);
+}
+
+static void cc_proc_backlog(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	struct cc_bl_item *bli;
+	struct cc_crypto_req *creq;
+	struct crypto_async_request *req;
+	bool ivgen;
+	unsigned int total_len;
+	struct device *dev = drvdata_to_dev(drvdata);
+	int rc;
+
+	spin_lock(&mgr->bl_lock);
+
+	while (mgr->bl_len) {
+		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
+		spin_unlock(&mgr->bl_lock);
+
+		creq = &bli->creq;
+		req = (struct crypto_async_request *)creq->user_arg;
+
+		/*
+		 * Notify the request we're moving out of the backlog
+		 * but only if we haven't done so already.
+		 */
+		if (!bli->notif) {
+			req->complete(req, -EINPROGRESS);
+			bli->notif = true;
+		}
+
+		ivgen = !!creq->ivgen_dma_addr_len;
+		total_len = bli->len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+
+		spin_lock(&mgr->hw_lock);
+
+		rc = cc_queues_status(drvdata, mgr, total_len);
+		if (rc) {
+			/*
+			 * There is still not room in the FIFO for
+			 * this request. Bail out. We'll return here
+			 * on the next completion irq.
+			 */
+			spin_unlock(&mgr->hw_lock);
+			return;
+		}
+
+		rc = cc_do_send_request(drvdata, &bli->creq, bli->desc,
+					bli->len, false, ivgen);
+
+		spin_unlock(&mgr->hw_lock);
+
+		if (rc != -EINPROGRESS) {
+			cc_pm_put_suspend(dev);
+			creq->user_cb(dev, req, rc);
+		}
+
+		/* Remove ourselves from the backlog list */
+		spin_lock(&mgr->bl_lock);
+		list_del(&bli->list);
+		--mgr->bl_len;
+	}
+
+	spin_unlock(&mgr->bl_lock);
+}
+
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req)
+{
+	int rc;
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	bool ivgen = !!cc_req->ivgen_dma_addr_len;
+	unsigned int total_len = len + (ivgen ? CC_IVPOOL_SEQ_LEN : 0);
+	struct device *dev = drvdata_to_dev(drvdata);
+	bool backlog_ok = req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG;
+	gfp_t flags = cc_gfp_flags(req);
+	struct cc_bl_item *bli;
+
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+
+	spin_lock_bh(&mgr->hw_lock);
+	rc = cc_queues_status(drvdata, mgr, total_len);
+
+#ifdef CC_DEBUG_FORCE_BACKLOG
+	if (backlog_ok)
+		rc = -ENOSPC;
+#endif /* CC_DEBUG_FORCE_BACKLOG */
+
+	if (rc == -ENOSPC && backlog_ok) {
+		spin_unlock_bh(&mgr->hw_lock);
+
+		bli = kmalloc(sizeof(*bli), flags);
+		if (!bli) {
+			cc_pm_put_suspend(dev);
+			return -ENOMEM;
+		}
+
+		memcpy(&bli->creq, cc_req, sizeof(*cc_req));
+		memcpy(&bli->desc, desc, len * sizeof(*desc));
+		bli->len = len;
+		bli->notif = false;
+		cc_enqueue_backlog(drvdata, bli);
+		return -EBUSY;
+	}
+
+	if (!rc)
+		rc = cc_do_send_request(drvdata, cc_req, desc, len, false,
+					ivgen);
+
+	spin_unlock_bh(&mgr->hw_lock);
+	return rc;
+}
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len)
+{
+	int rc;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+
+	init_completion(&cc_req->seq_compl);
+	cc_req->user_cb = request_mgr_complete;
+	cc_req->user_arg = &cc_req->seq_compl;
+
+	rc = cc_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		return rc;
+	}
+
+	while (true) {
+		spin_lock_bh(&mgr->hw_lock);
+		rc = cc_queues_status(drvdata, mgr, len + 1);
+
+		if (!rc)
+			break;
+
+		spin_unlock_bh(&mgr->hw_lock);
+		if (rc != -EAGAIN) {
+			cc_pm_put_suspend(dev);
+			return rc;
+		}
+		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
+		reinit_completion(&drvdata->hw_queue_avail);
+	}
+
+	rc = cc_do_send_request(drvdata, cc_req, desc, len, true, false);
+	spin_unlock_bh(&mgr->hw_lock);
+
+	if (rc != -EINPROGRESS) {
+		cc_pm_put_suspend(dev);
+		return rc;
+	}
+
+	wait_for_completion(&cc_req->seq_compl);
+	return 0;
+}
+
+/*!
+ * Enqueue caller request to crypto hardware during init process.
+ * assume this function is not called in middle of a flow,
+ * since we set QUEUE_LAST_IND flag in the last descriptor.
+ *
+ * \param drvdata
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ *
+ * \return int Returns "0" upon success
+ */
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len)
+{
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	unsigned int total_seq_len = len; /*initial sequence length*/
+	int rc = 0;
+
+	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT.
+	 */
+	rc = cc_queues_status(drvdata, req_mgr_h, total_seq_len);
+	if (rc)
+		return rc;
+
+	set_queue_last_ind(&desc[(len - 1)]);
+
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
+	enqueue_seq(drvdata, desc, len);
+
+	/* Update the free slots in HW queue */
+	req_mgr_h->q_free_slots =
+		cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
+
+	return 0;
+}
+
+void complete_request(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	complete(&drvdata->hw_queue_avail);
+#ifdef COMP_IN_WQ
+	queue_delayed_work(request_mgr_handle->workq,
+			   &request_mgr_handle->compwork, 0);
+#else
+	tasklet_schedule(&request_mgr_handle->comptask);
+#endif
+}
+
+#ifdef COMP_IN_WQ
+static void comp_work_handler(struct work_struct *work)
+{
+	struct cc_drvdata *drvdata =
+		container_of(work, struct cc_drvdata, compwork.work);
+
+	comp_handler((unsigned long)drvdata);
+}
+#endif
+
+static void proc_completions(struct cc_drvdata *drvdata)
+{
+	struct cc_crypto_req *cc_req;
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+	unsigned int *tail = &request_mgr_handle->req_queue_tail;
+	unsigned int *head = &request_mgr_handle->req_queue_head;
+
+	while (request_mgr_handle->axi_completed) {
+		request_mgr_handle->axi_completed--;
+
+		/* Dequeue request */
+		if (*head == *tail) {
+			/* We are supposed to handle a completion but our
+			 * queue is empty. This is not normal. Return and
+			 * hope for the best.
+			 */
+			dev_err(dev, "Request queue is empty head == tail %u\n",
+				*head);
+			break;
+		}
+
+		cc_req = &request_mgr_handle->req_queue[*tail];
+
+		if (cc_req->user_cb)
+			cc_req->user_cb(dev, cc_req->user_arg, 0);
+		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
+		dev_dbg(dev, "Request completed. axi_completed=%d\n",
+			request_mgr_handle->axi_completed);
+		cc_pm_put_suspend(dev);
+	}
+}
+
+static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
+{
+	return FIELD_GET(AXIM_MON_COMP_VALUE,
+			 cc_ioread(drvdata, CC_REG(AXIM_MON_COMP)));
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void comp_handler(unsigned long devarg)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	u32 irq;
+
+	irq = (drvdata->irq & CC_COMP_IRQ_MASK);
+
+	if (irq & CC_COMP_IRQ_MASK) {
+		/* To avoid the interrupt from firing as we unmask it,
+		 * we clear it now
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_ICR), CC_COMP_IRQ_MASK);
+
+		/* Avoid race with above clear: Test completion counter
+		 * once more
+		 */
+		request_mgr_handle->axi_completed +=
+				cc_axi_comp_count(drvdata);
+
+		while (request_mgr_handle->axi_completed) {
+			do {
+				proc_completions(drvdata);
+				/* At this point (after proc_completions()),
+				 * request_mgr_handle->axi_completed is 0.
+				 */
+				request_mgr_handle->axi_completed =
+						cc_axi_comp_count(drvdata);
+			} while (request_mgr_handle->axi_completed > 0);
+
+			cc_iowrite(drvdata, CC_REG(HOST_ICR),
+				   CC_COMP_IRQ_MASK);
+
+			request_mgr_handle->axi_completed +=
+					cc_axi_comp_count(drvdata);
+		}
+	}
+	/* after verifing that there is nothing to do,
+	 * unmask AXI completion interrupt
+	 */
+	cc_iowrite(drvdata, CC_REG(HOST_IMR),
+		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
+
+	cc_proc_backlog(drvdata);
+}
+
+/*
+ * resume the queue configuration - no need to take the lock as this happens
+ * inside the spin lock protection
+ */
+#if defined(CONFIG_PM)
+int cc_resume_req_queue(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+		drvdata->request_mgr_handle;
+
+	spin_lock_bh(&request_mgr_handle->hw_lock);
+	request_mgr_handle->is_runtime_suspended = false;
+	spin_unlock_bh(&request_mgr_handle->hw_lock);
+
+	return 0;
+}
+
+/*
+ * suspend the queue configuration. Since it is used for the runtime suspend
+ * only verify that the queue can be suspended.
+ */
+int cc_suspend_req_queue(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	/* lock the send_request */
+	spin_lock_bh(&request_mgr_handle->hw_lock);
+	if (request_mgr_handle->req_queue_head !=
+	    request_mgr_handle->req_queue_tail) {
+		spin_unlock_bh(&request_mgr_handle->hw_lock);
+		return -EBUSY;
+	}
+	request_mgr_handle->is_runtime_suspended = true;
+	spin_unlock_bh(&request_mgr_handle->hw_lock);
+
+	return 0;
+}
+
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
+{
+	struct cc_req_mgr_handle *request_mgr_handle =
+						drvdata->request_mgr_handle;
+
+	return	request_mgr_handle->is_runtime_suspended;
+}
+
+#endif
+
diff --git a/drivers/crypto/ccree/cc_request_mgr.h b/drivers/crypto/ccree/cc_request_mgr.h
new file mode 100644
index 0000000..573cb97
--- /dev/null
+++ b/drivers/crypto/ccree/cc_request_mgr.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+/* \file cc_request_mgr.h
+ * Request Manager
+ */
+
+#ifndef __REQUEST_MGR_H__
+#define __REQUEST_MGR_H__
+
+#include "cc_hw_queue_defs.h"
+
+int cc_req_mgr_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Enqueue caller request to crypto hardware.
+ *
+ * \param drvdata
+ * \param cc_req The request to enqueue
+ * \param desc The crypto sequence
+ * \param len The crypto sequence length
+ * \param is_dout If "true": completion is handled by the caller
+ *	  If "false": this function adds a dummy descriptor completion
+ *	  and waits upon completion signal.
+ *
+ * \return int Returns -EINPROGRESS or error
+ */
+int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
+		    struct cc_hw_desc *desc, unsigned int len,
+		    struct crypto_async_request *req);
+
+int cc_send_sync_request(struct cc_drvdata *drvdata,
+			 struct cc_crypto_req *cc_req, struct cc_hw_desc *desc,
+			 unsigned int len);
+
+int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len);
+
+void complete_request(struct cc_drvdata *drvdata);
+
+void cc_req_mgr_fini(struct cc_drvdata *drvdata);
+
+#if defined(CONFIG_PM)
+int cc_resume_req_queue(struct cc_drvdata *drvdata);
+
+int cc_suspend_req_queue(struct cc_drvdata *drvdata);
+
+bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
+#endif
+
+#endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/crypto/ccree/cc_sram_mgr.c b/drivers/crypto/ccree/cc_sram_mgr.c
new file mode 100644
index 0000000..d1f8a9c
--- /dev/null
+++ b/drivers/crypto/ccree/cc_sram_mgr.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include "cc_driver.h"
+#include "cc_sram_mgr.h"
+
+/**
+ * struct cc_sram_ctx -Internal RAM context manager
+ * @sram_free_offset:   the offset to the non-allocated area
+ */
+struct cc_sram_ctx {
+	cc_sram_addr_t sram_free_offset;
+};
+
+/**
+ * cc_sram_mgr_fini() - Cleanup SRAM pool.
+ *
+ * @drvdata: Associated device driver context
+ */
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
+{
+	/* Free "this" context */
+	kfree(drvdata->sram_mgr_handle);
+}
+
+/**
+ * cc_sram_mgr_init() - Initializes SRAM pool.
+ *      The pool starts right at the beginning of SRAM.
+ *      Returns zero for success, negative value otherwise.
+ *
+ * @drvdata: Associated device driver context
+ */
+int cc_sram_mgr_init(struct cc_drvdata *drvdata)
+{
+	struct cc_sram_ctx *ctx;
+
+	/* Allocate "this" context */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+
+	if (!ctx)
+		return -ENOMEM;
+
+	drvdata->sram_mgr_handle = ctx;
+
+	return 0;
+}
+
+/*!
+ * Allocated buffer from SRAM pool.
+ * Note: Caller is responsible to free the LAST allocated buffer.
+ * This function does not taking care of any fragmentation may occur
+ * by the order of calls to alloc/free.
+ *
+ * \param drvdata
+ * \param size The requested bytes to allocate
+ */
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size)
+{
+	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
+	cc_sram_addr_t p;
+
+	if ((size & 0x3)) {
+		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
+			size);
+		return NULL_SRAM_ADDR;
+	}
+	if (size > (CC_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
+		dev_err(dev, "Not enough space to allocate %u B (at offset %llu)\n",
+			size, smgr_ctx->sram_free_offset);
+		return NULL_SRAM_ADDR;
+	}
+
+	p = smgr_ctx->sram_free_offset;
+	smgr_ctx->sram_free_offset += size;
+	dev_dbg(dev, "Allocated %u B @ %u\n", size, (unsigned int)p);
+	return p;
+}
+
+/**
+ * cc_set_sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM.
+ * Note: each const value can't exceed word size.
+ *
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len)
+{
+	u32 i;
+	unsigned int idx = *seq_len;
+
+	for (i = 0; i < nelement; i++, idx++) {
+		hw_desc_init(&seq[idx]);
+		set_din_const(&seq[idx], src[i], sizeof(u32));
+		set_dout_sram(&seq[idx], dst + (i * sizeof(u32)), sizeof(u32));
+		set_flow_mode(&seq[idx], BYPASS);
+	}
+
+	*seq_len = idx;
+}
+
diff --git a/drivers/crypto/ccree/cc_sram_mgr.h b/drivers/crypto/ccree/cc_sram_mgr.h
new file mode 100644
index 0000000..d48649f
--- /dev/null
+++ b/drivers/crypto/ccree/cc_sram_mgr.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_SRAM_MGR_H__
+#define __CC_SRAM_MGR_H__
+
+#ifndef CC_CC_SRAM_SIZE
+#define CC_CC_SRAM_SIZE 4096
+#endif
+
+struct cc_drvdata;
+
+/**
+ * Address (offset) within CC internal SRAM
+ */
+
+typedef u64 cc_sram_addr_t;
+
+#define NULL_SRAM_ADDR ((cc_sram_addr_t)-1)
+
+/*!
+ * Initializes SRAM pool.
+ * The first X bytes of SRAM are reserved for ROM usage, hence, pool
+ * starts right after X bytes.
+ *
+ * \param drvdata
+ *
+ * \return int Zero for success, negative value otherwise.
+ */
+int cc_sram_mgr_init(struct cc_drvdata *drvdata);
+
+/*!
+ * Uninits SRAM pool.
+ *
+ * \param drvdata
+ */
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata);
+
+/*!
+ * Allocated buffer from SRAM pool.
+ * Note: Caller is responsible to free the LAST allocated buffer.
+ * This function does not taking care of any fragmentation may occur
+ * by the order of calls to alloc/free.
+ *
+ * \param drvdata
+ * \param size The requested bytes to allocate
+ */
+cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size);
+
+/**
+ * cc_set_sram_desc() - Create const descriptors sequence to
+ *	set values in given array into SRAM.
+ * Note: each const value can't exceed word size.
+ *
+ * @src:	  A pointer to array of words to set as consts.
+ * @dst:	  The target SRAM buffer to set into
+ * @nelements:	  The number of words in "src" array
+ * @seq:	  A pointer to the given IN/OUT descriptor sequence
+ * @seq_len:	  A pointer to the given IN/OUT sequence length
+ */
+void cc_set_sram_desc(const u32 *src, cc_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len);
+
+#endif /*__CC_SRAM_MGR_H__*/
-- 
2.7.4
