Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9444BC63697
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 19:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B7D22263
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 19:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgKPS7S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:59:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:4394 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgKPS7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 13:59:17 -0500
IronPort-SDR: p/87bBvMW6CfSXEvfFqPtljM2Q9ewunQVTekWehSaewMP4nAuWQ82VMMN0j6I8ia6q3rJ+JP+0
 eBE8rDpdIk3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="255508853"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="255508853"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:14 -0800
IronPort-SDR: NAWURoRvpYzjXBoHYqHmb4QIYO2vlkq7XQNJwbtgxcVgPOBVt2OBfsJtrR99MqHRvsTK8ZQYVm
 1psI47a2jSNw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="543710008"
Received: from abarnicl-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.19.98])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:10 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v3 2/3] crypto: keembay: Add Keem Bay OCS HCU driver
Date:   Mon, 16 Nov 2020 18:58:45 +0000
Message-Id: <20201116185846.773464-3-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
References: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Declan Murphy <declan.murphy@intel.com>

Add support for the Hashing Control Unit (HCU) included in the Offload
Crypto Subsystem (OCS) of the Intel Keem Bay SoC, thus enabling
hardware-accelerated hashing on the Keem Bay SoC for the following
algorithms:
- sha224 and hmac(sha224)
- sha256 and hmac(sha256)
- sha384 and hmac(sha384)
- sha512 and hmac(sha512)
- sm3    and hmac(sm3)

The driver passes crypto manager self-tests, including the extra tests
(CRYPTO_MANAGER_EXTRA_TESTS=y).

Signed-off-by: Declan Murphy <declan.murphy@intel.com>
Co-developed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
---
 drivers/crypto/Kconfig                        |    2 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/keembay/Kconfig                |   20 +
 drivers/crypto/keembay/Makefile               |    5 +
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 1484 +++++++++++++++++
 drivers/crypto/keembay/ocs-hcu.c              |  593 +++++++
 drivers/crypto/keembay/ocs-hcu.h              |  115 ++
 7 files changed, 2220 insertions(+)
 create mode 100644 drivers/crypto/keembay/Kconfig
 create mode 100644 drivers/crypto/keembay/Makefile
 create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c2950127def6..e636be70b18d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -881,4 +881,6 @@ config CRYPTO_DEV_SA2UL
 	  used for crypto offload.  Select this if you want to use hardware
 	  acceleration for cryptographic algorithms on these devices.
 
+source "drivers/crypto/keembay/Kconfig"
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 53fc115cf459..fff9a70348e1 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += xilinx/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
+obj-y += keembay/
diff --git a/drivers/crypto/keembay/Kconfig b/drivers/crypto/keembay/Kconfig
new file mode 100644
index 000000000000..db8954dcd057
--- /dev/null
+++ b/drivers/crypto/keembay/Kconfig
@@ -0,0 +1,20 @@
+config CRYPTO_DEV_KEEMBAY_OCS_HCU
+	tristate "Support for Intel Keem Bay OCS HCU HW acceleration"
+	select CRYPTO_ENGINE
+	depends on OF || COMPILE_TEST
+	help
+	  Support for Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash
+	  Control Unit (HCU) hardware acceleration for use with Crypto API.
+
+	  Provides OCS HCU hardware acceleration of sha256, sha384, sha512, and
+	  sm3, as well as the HMAC variant of these algorithms.
+
+config CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	bool "Enable sha224 and hmac(sha224) support in Intel Keem Bay OCS HCU"
+	depends on CRYPTO_DEV_KEEMBAY_OCS_HCU
+	help
+	  Enables support for sha224 and hmac(sha224) algorithms in the Intel
+	  Keem Bay OCS HCU driver. Intel recommends not to use these
+	  algorithms.
+
+	  Provides OCS HCU hardware acceleration of sha224 and hmac(224).
diff --git a/drivers/crypto/keembay/Makefile b/drivers/crypto/keembay/Makefile
new file mode 100644
index 000000000000..2aa2647fab1b
--- /dev/null
+++ b/drivers/crypto/keembay/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for Keem Bay OCS Crypto API Linux drivers
+#
+obj-$(CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU) += keembay-ocs-hcu.o
+keembay-ocs-hcu-objs := keembay-ocs-hcu-core.o ocs-hcu.o
diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
new file mode 100644
index 000000000000..2c8f8f331501
--- /dev/null
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -0,0 +1,1484 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel Keem Bay OCS HCU Crypto Driver.
+ *
+ * Copyright (C) 2018-2020 Intel Corporation
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+
+#include <crypto/engine.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+#include <crypto/sm3.h>
+#include <crypto/hmac.h>
+#include <crypto/internal/hash.h>
+
+#include "ocs-hcu.h"
+
+#define DRV_NAME	"keembay-ocs-hcu"
+
+/* Flag marking a final request. */
+#define REQ_FINAL			BIT(0)
+/* Flag set when there is data to be processed by the HW. */
+#define REQ_FLAGS_DO_DATA		BIT(1)
+/* Flag set when there is intermediate data from a previous request. */
+#define REQ_FLAGS_INTERMEDIATE_DATA	BIT(2)
+/* Flag marking a HMAC request. */
+#define REQ_FLAGS_HMAC			BIT(3)
+/* Flag set when HW HMAC is being used. */
+#define REQ_FLAGS_HMAC_HW		BIT(4)
+/* Flag set when SW HMAC is being used. */
+#define REQ_FLAGS_HMAC_SW		BIT(5)
+/* Flag set when HW HMAC key has been already set (only used in HW HMAC). */
+#define REQ_FLAGS_HMAC_HW_KEY_SET	BIT(6)
+/* Flag set when OPAD computing is pending (only used in SW HMAC). */
+#define REQ_FLAGS_HMAC_SW_DO_OPAD	BIT(7)
+
+#define KMB_OCS_HCU_ALIGNMENT		8
+#define KMB_OCS_HCU_ALIGN_MASK		(KMB_OCS_HCU_ALIGNMENT - 1)
+
+/**
+ * struct ocs_hcu_ctx: OCS HCU Transform context.
+ * @engine_ctx:	 Crypto Engine context.
+ * @hcu_dev:	 The OCS HCU device used by the transformation.
+ * @key:	 The key (used only for HMAC transformations).
+ * @key_len:	 The length of the key.
+ * @is_sm3_tfm:  Whether or not this is an SM3 transformation.
+ * @is_hmac_tfm: Whether or not this is a HMAC transformation.
+ */
+struct ocs_hcu_ctx {
+	struct crypto_engine_ctx engine_ctx;
+	struct ocs_hcu_dev *hcu_dev;
+	u8 key[SHA512_BLOCK_SIZE];
+	size_t key_len;
+	bool is_sm3_tfm;
+	bool is_hmac_tfm;
+};
+
+/**
+ * struct dma_buf - DMA-able buffer.
+ * @dma_addr:	The DMA address of the buffer.
+ * @vaddr:	The Kernel virtual address of the buffer.
+ * @size:	The size of the buffer.
+ */
+struct dma_buf {
+	dma_addr_t dma_addr;
+	u8	   *vaddr;
+	size_t	   size;
+};
+
+/**
+ * struct ocs_dma_list - OCS-specific DMA linked list.
+ * @head:	The head of the list (points to the array backing the list).
+ * @tail:	The current tail of the list; NULL if the list is empty.
+ * @dma_addr:	The DMA address of @head (i.e., the DMA address of the backing
+ *		array).
+ * @nents:	Maximum number of entries in the list (i.e., number of elements
+ *		in the backing array).
+ *
+ * The OCS DMA list is an array-backed list of OCS DMA descriptors. The array
+ * backing the list is allocated with dma_alloc_coherent() and pointed by
+ * @head.
+ */
+struct ocs_dma_list {
+	struct ocs_dma_desc	*head;
+	struct ocs_dma_desc	*tail;
+	dma_addr_t		dma_addr;
+	size_t			nents;
+};
+
+/**
+ * struct ocs_hcu_rctx - Context for the request.
+ * @flags:	    Flags tracking request status.
+ * @algo:	    Algorithm to use for the request.
+ * @blk_sz:	    Block size of the transformation / request.
+ * @dig_sz:	    Digest size of the transformation / request.
+ * @dma_list:	    OCS DMA linked list.
+ * @hcu_dev:	    OCS HCU device to be used to service the request.
+ * @idata:	    Intermediate data (used to store intermediate results).
+ * @buffer:	    Buffer to store: partial block of data and SW HMAC
+ *		    artifacts (ipad, opad, etc.).
+ * @buf_cnt:	    Number of bytes currently stored in the buffer.
+ * @dma_buf:	    DMA-able copy of buffer.
+ * @sg:		    Head of the scatterlist entries containing data.
+ * @sg_data_total:  Total data in the SG list at any time.
+ * @sg_data_offset: Offset into the data of the current individual SG node.
+ * @sg_dma_nents:   Number of sg entries mapped in dma_list.
+ */
+struct ocs_hcu_rctx {
+	u32			flags;
+	u32			algo;
+	size_t			blk_sz;
+	size_t			dig_sz;
+	struct ocs_dma_list	dma_list;
+	struct ocs_hcu_dev	*hcu_dev;
+	struct ocs_hcu_idata	idata;
+	/*
+	 * Buffer is double the block size because we need space for SW HMAC
+	 * artifacts, i.e:
+	 * - ipad (1 block) + a possible partial block of data.
+	 * - opad (1 block) + digest of H(k ^ ipad || m)
+	 */
+	u8			buffer[2 * SHA512_BLOCK_SIZE];
+	size_t			buf_cnt;
+	struct dma_buf		dma_buf;
+	struct scatterlist	*sg;
+	unsigned int		sg_data_total;
+	unsigned int		sg_data_offset;
+	unsigned int		sg_dma_nents;
+};
+
+/**
+ * struct ocs_hcu_drv - Driver data
+ * @dev_list:	The list of HCU devices.
+ * @lock:	The lock protecting dev_list.
+ */
+struct ocs_hcu_drv {
+	struct list_head dev_list;
+	spinlock_t lock; /* Protects dev_list. */
+};
+
+static struct ocs_hcu_drv ocs_hcu = {
+	.dev_list = LIST_HEAD_INIT(ocs_hcu.dev_list),
+	.lock = __SPIN_LOCK_UNLOCKED(ocs_hcu.lock),
+};
+
+/*
+ * Return the total amount of data in the request; that is: the data in the
+ * request buffer + the data in the sg list.
+ */
+static inline unsigned int kmb_get_total_data(struct ocs_hcu_rctx *rctx)
+{
+	return rctx->sg_data_total + rctx->buf_cnt;
+}
+
+/* Move remaining content of scatter-gather list to context buffer. */
+static int flush_sg_to_ocs_buffer(struct ocs_hcu_rctx *rctx)
+{
+	size_t count;
+
+	if (rctx->sg_data_total > (sizeof(rctx->buffer) - rctx->buf_cnt)) {
+		WARN(1, "sg data does not fit in buffer\n");
+		return -EINVAL;
+	}
+
+	while (rctx->sg_data_total) {
+		if (!rctx->sg) {
+			WARN(1, "sg == NULL, but sg_data_total != 0\n");
+			return -EINVAL;
+		}
+		/*
+		 * If current sg has been fully processed, skip to the next
+		 * one.
+		 */
+		if (rctx->sg_data_offset == rctx->sg->length) {
+			rctx->sg = sg_next(rctx->sg);
+			rctx->sg_data_offset = 0;
+			continue;
+		}
+		/*
+		 * Determine the maximum data available to copy from the node.
+		 * Minimum of the length left in the sg node, or the total data
+		 * in the request.
+		 */
+		count = min(rctx->sg->length - rctx->sg_data_offset,
+			    rctx->sg_data_total);
+		/* Copy from scatter-list entry to context buffer. */
+		scatterwalk_map_and_copy(&rctx->buffer[rctx->buf_cnt],
+					 rctx->sg, rctx->sg_data_offset,
+					 count, 0);
+
+		rctx->sg_data_offset += count;
+		rctx->sg_data_total -= count;
+		rctx->buf_cnt += count;
+	}
+
+	return 0;
+}
+
+static struct ocs_hcu_dev *kmb_ocs_hcu_find_dev(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ocs_hcu_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	/* If the HCU device for the request was previously set, return it. */
+	if (tctx->hcu_dev)
+		return tctx->hcu_dev;
+
+	/*
+	 * Otherwise, get the first HCU device available (there should be one
+	 * and only one device).
+	 */
+	spin_lock_bh(&ocs_hcu.lock);
+	tctx->hcu_dev = list_first_entry_or_null(&ocs_hcu.dev_list,
+						 struct ocs_hcu_dev,
+						 list);
+	spin_unlock_bh(&ocs_hcu.lock);
+
+	WARN(!tctx->hcu_dev, "No HCU device available\n");
+
+	return tctx->hcu_dev;
+}
+
+/* Free OCS DMA linked list and DMA-able context buffer. */
+static void kmb_ocs_free_dma_list(struct ocs_hcu_rctx *rctx)
+{
+	struct ocs_hcu_dev *hcu_dev = rctx->hcu_dev;
+	struct device *dev = hcu_dev->dev;
+
+	/* Free DMA-able context buffer, if it was allocated. */
+	if (rctx->dma_buf.vaddr) {
+		memzero_explicit(rctx->dma_buf.vaddr, rctx->dma_buf.size);
+		dma_free_coherent(dev, rctx->dma_buf.size, rctx->dma_buf.vaddr,
+				  rctx->dma_buf.dma_addr);
+		memset(&rctx->dma_buf, 0, sizeof(rctx->dma_buf));
+	}
+
+	if (!rctx->dma_list.head)
+		return;
+
+	if (rctx->sg_dma_nents > 0)
+		dma_unmap_sg(dev, hcu_dev->req->src, rctx->sg_dma_nents,
+			     DMA_TO_DEVICE);
+
+	dma_free_coherent(dev,
+			  sizeof(*rctx->dma_list.head) * rctx->dma_list.nents,
+			  rctx->dma_list.head, rctx->dma_list.dma_addr);
+
+	memset(&rctx->dma_list, 0, sizeof(rctx->dma_list));
+}
+
+/* Add a new DMA entry at the end of the OCS DMA list. */
+static int kmb_ocs_add_dma_tail(struct ocs_hcu_rctx *rctx,
+				dma_addr_t addr, size_t len)
+{
+	struct ocs_hcu_dev *hcu_dev = rctx->hcu_dev;
+	struct device *dev = hcu_dev->dev;
+	struct ocs_dma_list *dma_list = &rctx->dma_list;
+	struct ocs_dma_desc *old_tail = dma_list->tail;
+	struct ocs_dma_desc *new_tail = old_tail ?
+					old_tail + 1 : dma_list->head;
+
+	if (!len)
+		return 0;
+
+	if (addr & ~OCS_HCU_DMA_BIT_MASK) {
+		dev_err(dev,
+			"Unexpected error: Invalid DMA address for OCS HCU\n");
+		return -EINVAL;
+	}
+
+	if (new_tail - dma_list->head >= dma_list->nents) {
+		dev_err(dev, "Unexpected error: OCS DMA list is full\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * If there was an old tail (i.e., this is not the first element we are
+	 * adding), un-terminate the old tail and make it point to the new one.
+	 */
+	if (old_tail) {
+		old_tail->ll_flags &= ~OCS_LL_DMA_FLAG_TERMINATE;
+		/*
+		 * The old tail 'nxt_desc' must point to the DMA address of the
+		 * new tail.
+		 */
+		old_tail->nxt_desc = dma_list->dma_addr +
+				     sizeof(*dma_list->tail) * (new_tail -
+								dma_list->head);
+	}
+
+	new_tail->src_adr = (u32)addr;
+	new_tail->src_len = (u32)len;
+	new_tail->ll_flags = OCS_LL_DMA_FLAG_TERMINATE;
+	new_tail->nxt_desc = 0;
+
+	/* Update list tail with new tail. */
+	dma_list->tail = new_tail;
+
+	return 0;
+}
+
+/*
+ * Initialize OCS DMA list:
+ * - Allocate DMA linked list (number of elements: SG entries to process +
+ *   context buffer, if not empty).
+ * - Allocate DMA-able context buffer (if needed) and add it to the DMA list.
+ * - Add SG entries to the DMA list.
+ *
+ * Note: if this is a final request, we process all the data in the SG list,
+ * otherwise we can only process up to the maximum amount of block-aligned data
+ * (the remainder will be put into the context buffer and processed in the next
+ * request).
+ */
+static int kmb_ocs_init_dma_list(struct ocs_hcu_dev *hcu_dev)
+{
+	struct ahash_request *req = hcu_dev->req;
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	struct device *dev = hcu_dev->dev;
+	struct scatterlist *sg = req->src;
+	unsigned int remainder = 0;
+	unsigned int total;
+	size_t nents;
+	size_t count;
+	int rc;
+	int i;
+
+	total = kmb_get_total_data(rctx);
+	if (!total)
+		return 0;
+
+	/*
+	 * If this is not a final DMA (terminated DMA), the data passed to the
+	 * HCU must be aligned to the block size; compute the remainder data to
+	 * be processed in the next request.
+	 */
+	if (!(rctx->flags & REQ_FINAL))
+		remainder = total % rctx->blk_sz;
+
+	/* Determine the number of scatter gather list nodes to process. */
+	nents = sg_nents_for_len(sg, rctx->sg_data_total - remainder);
+	rctx->sg_dma_nents = nents;
+
+	/* Add extra DMA entry for data in context buffer, if any. */
+	if (rctx->buf_cnt)
+		nents++;
+
+	/* Total size of the DMA list to allocate. */
+	rctx->dma_list.head =
+		dma_alloc_coherent(dev, sizeof(*rctx->dma_list.head) * nents,
+				   &rctx->dma_list.dma_addr, GFP_KERNEL);
+	if (!rctx->dma_list.head) {
+		dev_err(dev, "Failed to allocated DMA list\n");
+		return -ENOMEM;
+	}
+	rctx->dma_list.nents = nents;
+	rctx->dma_list.tail = NULL;
+
+	rc = dma_map_sg(hcu_dev->dev, req->src, rctx->sg_dma_nents,
+			DMA_TO_DEVICE);
+	if (rc != rctx->sg_dma_nents) {
+		dev_err(dev, "Failed to MAP SG\n");
+		rc = -ENOMEM;
+		goto cleanup;
+	}
+
+	/*
+	 * If context buffer is not empty, create DMA-able buffer for it, copy
+	 * context to new buffer and add it to the DMA list.
+	 */
+	if (rctx->buf_cnt) {
+		rctx->dma_buf.size = rctx->buf_cnt;
+		rctx->dma_buf.vaddr =
+			dma_alloc_coherent(dev, rctx->dma_buf.size,
+					   &rctx->dma_buf.dma_addr,
+					   GFP_KERNEL);
+		if (!rctx->dma_buf.vaddr) {
+			dev_err(dev, "Failed to allocate DMA Buf\n");
+			goto cleanup;
+		}
+		memcpy(rctx->dma_buf.vaddr, rctx->buffer, rctx->buf_cnt);
+		rc = kmb_ocs_add_dma_tail(rctx, rctx->dma_buf.dma_addr,
+					  rctx->dma_buf.size);
+		if (rc)
+			goto cleanup;
+		rctx->buf_cnt = 0;
+	}
+
+	/* Add the SG nodes to be processed to the DMA linked list. */
+	for_each_sg(req->src, rctx->sg, rctx->sg_dma_nents, i) {
+		count = min(rctx->sg_data_total - remainder,
+			    rctx->sg->length - rctx->sg_data_offset);
+		/*
+		 * Do not create a zero length DMA descriptor. Check in case of
+		 * zero length SG node.
+		 */
+		if (count == 0)
+			continue;
+		/* Add sg to HCU DMA list. */
+		rc = kmb_ocs_add_dma_tail(rctx, rctx->sg->dma_address,
+					  count);
+		if (rc)
+			goto cleanup;
+
+		/* Update amount of data remaining in SG list. */
+		rctx->sg_data_total -= count;
+
+		/*
+		 * If  remaining data is equal to remainder (note: 'less than'
+		 * case will never happen in practice), we are done: update
+		 * offset and exit the loop.
+		 */
+		if (rctx->sg_data_total <= remainder) {
+			rctx->sg_data_offset += count;
+			break;
+		}
+
+		/*
+		 * If we get here is because we need to process the next sg in
+		 * the list; set offset within the sg to 0.
+		 */
+		rctx->sg_data_offset = 0;
+	}
+
+	return 0;
+cleanup:
+	dev_err(dev, "Failed to map DMA buffer.\n");
+	kmb_ocs_free_dma_list(rctx);
+
+	return rc;
+}
+
+static void kmb_ocs_hcu_secure_cleanup(struct ocs_hcu_dev *hcu_dev)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+
+	/* Clear buffer of any data. */
+	memzero_explicit(rctx->buffer, sizeof(rctx->buffer));
+	/*
+	 * Clear the key in HW.
+	 *
+	 * NOTE: the key in the tfm context (ctx->key) is cleared in
+	 * kmb_ocs_hcu_hmac_cra_exit(), i.e., when tfm is de-initialized.
+	 */
+	ocs_hcu_clear_key(hcu_dev);
+}
+
+static void kmb_ocs_hcu_finish_request(struct ocs_hcu_dev *hcu_dev, int error)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+
+	if (error)
+		goto exit;
+
+	/* Get the intermediate data (including digest). */
+	error = ocs_hcu_get_intermediate_data(hcu_dev, &rctx->idata,
+					      rctx->algo);
+	if (error)
+		goto exit;
+	/*
+	 * If this is not the final request
+	 * - Set the intermediate data flag so that intermediate data will be
+	 *   written back to HW during the next request processing.
+	 * - Move remaining data in the SG list to the request buffer, so that
+	 *   it will be processed during the next request.
+	 */
+	if (!(rctx->flags & REQ_FINAL)) {
+		rctx->flags |= REQ_FLAGS_INTERMEDIATE_DATA;
+		error = flush_sg_to_ocs_buffer(rctx);
+		goto exit;
+	}
+
+	/*
+	 * If we get here, this was the final request and the digest in the
+	 * intermediate date is actually the final digest: copy it to the
+	 * request result field.
+	 */
+	memcpy(hcu_dev->req->result, rctx->idata.digest, rctx->dig_sz);
+
+exit:
+	if (error || rctx->flags & REQ_FINAL)
+		kmb_ocs_hcu_secure_cleanup(hcu_dev);
+	ocs_hcu_hw_disable(hcu_dev);
+	kmb_ocs_free_dma_list(rctx);
+	crypto_finalize_hash_request(hcu_dev->engine, hcu_dev->req, error);
+}
+
+static int kmb_ocs_hcu_set_hw(struct ocs_hcu_dev *hcu_dev, int algo)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(hcu_dev->req);
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = hcu_dev->dev;
+	int rc;
+
+	rc = ocs_hcu_wait_busy(hcu_dev);
+	if (rc) {
+		dev_err(hcu_dev->dev, "%s HW Busy, cannot continue.\n",
+			__func__);
+		return -EIO;
+	}
+
+	/* Configure the hardware for the current request. */
+	rc = ocs_hcu_hw_cfg(hcu_dev, algo);
+	if (rc)
+		return rc;
+
+	if (rctx->flags & REQ_FLAGS_INTERMEDIATE_DATA) {
+		ocs_hcu_set_intermediate_data(hcu_dev, &rctx->idata, algo);
+		rctx->flags &= ~REQ_FLAGS_INTERMEDIATE_DATA;
+	}
+
+	/*
+	 * Set key if all the following conditions are met:
+	 * 1. We are using HW HMAC
+	 * 2. Key has not been set already
+	 */
+	if (rctx->flags & REQ_FLAGS_HMAC_HW &&
+	    !(rctx->flags & REQ_FLAGS_HMAC_HW_KEY_SET)) {
+		if (ctx->key_len > HCU_HW_KEY_LEN) {
+			dev_err(dev,
+				"Unexpected error: key len > HCU_HW_KEY_LEN\n");
+			return -EINVAL;
+		}
+		/*
+		 * Hardware requires all the bytes of the HW Key vector to be
+		 * written. So pad with zero until we reach HCU_HW_KEY_LEN.
+		 */
+		memzero_explicit(&ctx->key[ctx->key_len],
+				 HCU_HW_KEY_LEN - ctx->key_len);
+		rc = ocs_hcu_write_key(hcu_dev, ctx->key, HCU_HW_KEY_LEN);
+		if (rc)
+			return rc;
+		rctx->flags |= REQ_FLAGS_HMAC_HW_KEY_SET;
+	}
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_hash_pio(struct ocs_hcu_dev *hcu_dev,
+				u8 *buf, u32 sz, u32 algo, bool term)
+{
+	int rc = 0;
+
+	/* Configure the hardware for the current request. */
+	rc = kmb_ocs_hcu_set_hw(hcu_dev, algo);
+
+	if (rc)
+		return rc;
+
+	if (sz != ocs_hcu_hash_cpu(hcu_dev, buf, sz, algo, term))
+		return -EIO;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_tx_dma(struct ocs_hcu_dev *hcu_dev)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+	bool term = !!(rctx->flags & REQ_FINAL);
+	int rc;
+
+	if (!rctx->dma_list.head)
+		return 0;
+
+	/* Configure the hardware for the current request. */
+	rc = kmb_ocs_hcu_set_hw(hcu_dev, rctx->algo);
+
+	if (rc)
+		return rc;
+
+	/* Start the DMA engine with the descriptor address stored. */
+	rc = ocs_hcu_ll_dma_start(hcu_dev, rctx->dma_list.dma_addr, term);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_handle_queue(struct ahash_request *req)
+{
+	struct ocs_hcu_dev *hcu_dev = kmb_ocs_hcu_find_dev(req);
+
+	if (!hcu_dev)
+		return -ENOENT;
+
+	return crypto_transfer_hash_request_to_engine(hcu_dev->engine,
+						      req);
+}
+
+static int kmb_ocs_hcu_prepare_request(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request,
+						 base);
+	struct ocs_hcu_dev *hcu_dev = kmb_ocs_hcu_find_dev(req);
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	int rc;
+
+	if (!hcu_dev)
+		return -ENOENT;
+
+	hcu_dev->req = req;
+
+	/*
+	 * If the request has no data (i.e., it's a final request without data),
+	 * we are done.
+	 */
+	if (kmb_get_total_data(rctx) == 0)
+		return 0;
+	/* Otherwise, move the data into the HCU DMA linked list. */
+	rc = kmb_ocs_init_dma_list(hcu_dev);
+	if (rc)
+		return rc;
+	/* Set the flag to notify of pending data. */
+	rctx->flags |= REQ_FLAGS_DO_DATA;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_do_final(struct ocs_hcu_dev *hcu_dev)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+	int rc;
+
+	rc = kmb_ocs_hcu_set_hw(hcu_dev, rctx->algo);
+	if (rc)
+		return rc;
+
+	ocs_hcu_tx_data_done(hcu_dev);
+
+	return 0;
+}
+
+static int prepare_ipad(struct ahash_request *req)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+	int i;
+
+	WARN(rctx->buf_cnt != 0, "rctx->buf_cnt = %zu\n", rctx->buf_cnt);
+	WARN(!(rctx->flags & REQ_FLAGS_HMAC_SW), "Not HMAC SW");
+	/*
+	 * Key length must be equal to block size. If key is shorter,
+	 * we pad it with zero (note: key cannot be longer, since
+	 * longer keys are hashed by kmb_ocs_hcu_setkey()).
+	 */
+	WARN_ON(ctx->key_len > rctx->blk_sz);
+	memzero_explicit(&ctx->key[ctx->key_len],
+			 rctx->blk_sz - ctx->key_len);
+	ctx->key_len = rctx->blk_sz;
+	/*
+	 * Prepare IPAD for HMAC. Only done for first block.
+	 * HMAC(k,m) = H(k ^ opad || H(k ^ ipad || m))
+	 * k ^ ipad will be first hashed block.
+	 * k ^ opad will be calculated in the final request.
+	 * Only needed if not using HW HMAC.
+	 */
+	for (i = 0; i < rctx->blk_sz; i++)
+		rctx->buffer[i] = ctx->key[i] ^ HMAC_IPAD_VALUE;
+	rctx->buf_cnt = rctx->blk_sz;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request,
+						 base);
+	struct ocs_hcu_dev *hcu_dev = kmb_ocs_hcu_find_dev(req);
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+
+	if (!hcu_dev)
+		return -ENOENT;
+
+	hcu_dev->req = req;
+
+	/* Initialize the hardware. */
+	ocs_hcu_hw_init(hcu_dev);
+
+	/*
+	 * If there is data to process (i.e., this is an update request or a
+	 * final request with data), process the data.
+	 */
+	if (rctx->flags & REQ_FLAGS_DO_DATA) {
+		rctx->flags &= ~REQ_FLAGS_DO_DATA;
+		return kmb_ocs_hcu_tx_dma(hcu_dev);
+	}
+	/* Otherwise, if this is a final request, finalize the hash. */
+	if (rctx->flags & REQ_FINAL)
+		return kmb_ocs_hcu_do_final(hcu_dev);
+	/* If we end up here, something was wrong with the request. */
+	return -EINVAL;
+}
+
+static int kmb_ocs_hcu_init(struct ahash_request *req)
+{
+	struct ocs_hcu_dev *hcu_dev = kmb_ocs_hcu_find_dev(req);
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	if (!hcu_dev)
+		return -ENOENT;
+
+	/* Initialize entire request context to zero. */
+	memset(rctx, 0, sizeof(*rctx));
+
+	rctx->hcu_dev = hcu_dev;
+	rctx->dig_sz = crypto_ahash_digestsize(tfm);
+
+	switch (rctx->dig_sz) {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	case SHA224_DIGEST_SIZE:
+		rctx->blk_sz = SHA224_BLOCK_SIZE;
+		rctx->algo = OCS_HCU_ALGO_SHA224;
+		break;
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
+	case SHA256_DIGEST_SIZE:
+		rctx->blk_sz = SHA256_BLOCK_SIZE;
+		/*
+		 * SHA256 and SM3 have the same digest size: use info from tfm
+		 * context to find out which one we should use.
+		 */
+		rctx->algo = ctx->is_sm3_tfm ? OCS_HCU_ALGO_SM3 :
+					       OCS_HCU_ALGO_SHA256;
+		break;
+	case SHA384_DIGEST_SIZE:
+		rctx->blk_sz = SHA384_BLOCK_SIZE;
+		rctx->algo = OCS_HCU_ALGO_SHA384;
+		break;
+	case SHA512_DIGEST_SIZE:
+		rctx->blk_sz = SHA512_BLOCK_SIZE;
+		rctx->algo = OCS_HCU_ALGO_SHA512;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Clear the intermediate data. */
+	memzero_explicit(&rctx->idata, sizeof(rctx->idata));
+	/* If this is not a HMAC request, we are done. */
+	if (!ctx->is_hmac_tfm)
+		return 0;
+
+	rctx->flags |= REQ_FLAGS_HMAC;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_update(struct ahash_request *req)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	int rc;
+
+	if (!req->nbytes)
+		return 0;
+
+	/* Check for overflow */
+	if (check_add_overflow(rctx->sg_data_total, req->nbytes,
+			       &rctx->sg_data_total))
+		return -EINVAL;
+
+	rctx->sg_data_offset = 0;
+	rctx->sg = req->src;
+
+	/*
+	 * If we are doing HMAC, then we must use SW-assisted HMAC, since HW
+	 * HMAC does not support context switching (so can only be used with
+	 * finup() or digest().
+	 */
+	if (rctx->flags & REQ_FLAGS_HMAC &&
+	    !(rctx->flags & REQ_FLAGS_HMAC_SW)) {
+		rctx->flags |= REQ_FLAGS_HMAC_SW;
+		rc = prepare_ipad(req);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * If remaining sg_data fits into ctx buffer, just copy it there; we'll
+	 * process it at the next update() or final().
+	 */
+	if (rctx->sg_data_total <= (sizeof(rctx->buffer) - rctx->buf_cnt))
+		return flush_sg_to_ocs_buffer(rctx);
+
+	return kmb_ocs_hcu_handle_queue(req);
+}
+
+static int kmb_ocs_hcu_final(struct ahash_request *req)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+	int rc;
+
+	rctx->sg = req->src;
+	rctx->sg_data_offset = 0;
+	rctx->flags |= REQ_FINAL;
+
+	/*
+	 * If this is a HMAC request and, so far, we didn't have to switch to
+	 * SW HMAC, check if we can use HW HMAC.
+	 */
+	if (rctx->flags & REQ_FLAGS_HMAC &&
+	    !(rctx->flags & REQ_FLAGS_HMAC_SW)) {
+		/*
+		 * If we are here, it means we never processed any data so far,
+		 * so we can use HW HMAC, but only if there is some data to
+		 * process (since OCS HW MAC does not support zero-length
+		 * messages) and the key length is supported by the hardware
+		 * (OCS HCU HW only supports length <= 64); if HW HMAC cannot
+		 * be used, fall back to SW-assisted HMAC.
+		 */
+		if (kmb_get_total_data(rctx) &&
+		    ctx->key_len <= HCU_HW_KEY_LEN) {
+			rctx->algo |= OCS_HCU_ALGO_HMAC_MASK;
+			rctx->flags |= REQ_FLAGS_HMAC_HW;
+		} else {
+			rctx->flags |= REQ_FLAGS_HMAC_SW;
+			rc = prepare_ipad(req);
+			if (rc)
+				return rc;
+		}
+	}
+	/*
+	 * If SW HMAC is being used, request OPAD computation (do in IRQ
+	 * thread, after the full message has been hashed).
+	 */
+	if (rctx->flags & REQ_FLAGS_HMAC_SW)
+		rctx->flags |= REQ_FLAGS_HMAC_SW_DO_OPAD;
+
+	return kmb_ocs_hcu_handle_queue(req);
+}
+
+static int kmb_ocs_hcu_finup(struct ahash_request *req)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+
+	/* Check for overflow */
+	if (check_add_overflow(rctx->sg_data_total, req->nbytes,
+			       &rctx->sg_data_total))
+		return -EINVAL;
+
+	return kmb_ocs_hcu_final(req);
+}
+
+static int kmb_ocs_hcu_digest(struct ahash_request *req)
+{
+	int rc = 0;
+	struct ocs_hcu_dev *hcu_dev = kmb_ocs_hcu_find_dev(req);
+
+	if (!hcu_dev)
+		return -ENOENT;
+
+	rc = kmb_ocs_hcu_init(req);
+	if (rc)
+		return rc;
+
+	rc = kmb_ocs_hcu_finup(req);
+
+	return rc;
+}
+
+static int kmb_ocs_hcu_export(struct ahash_request *req, void *out)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+
+	/* Intermediate data is always stored and applied per request. */
+	memcpy(out, rctx, sizeof(*rctx));
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_import(struct ahash_request *req, const void *in)
+{
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(req);
+
+	/* Intermediate data is always stored and applied per request. */
+	memcpy(rctx, in, sizeof(*rctx));
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_setkey(struct crypto_ahash *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+	unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	size_t blk_sz = crypto_ahash_blocksize(tfm);
+	struct crypto_ahash *ahash_tfm;
+	struct ahash_request *req;
+	struct crypto_wait wait;
+	struct scatterlist sg;
+	const char *alg_name;
+	u8 *buf;
+	int rc;
+
+	/*
+	 * Key length must be equal to block size:
+	 * - If key is shorter, we are done for now (the key will be padded
+	 *   later on); this is to maximize the use of HW HMAC (which works
+	 *   only for keys <= 64 bytes).
+	 * - If key is longer, we hash it.
+	 */
+	if (keylen <= blk_sz) {
+		memcpy(ctx->key, key, keylen);
+		ctx->key_len = keylen;
+		return 0;
+	}
+
+	switch (digestsize) {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	case SHA224_DIGEST_SIZE:
+		alg_name = "sha224-keembay-ocs";
+		break;
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
+	case SHA256_DIGEST_SIZE:
+		alg_name = ctx->is_sm3_tfm ? "sm3-keembay-ocs" :
+					     "sha256-keembay-ocs";
+		break;
+	case SHA384_DIGEST_SIZE:
+		alg_name = "sha384-keembay-ocs";
+		break;
+	case SHA512_DIGEST_SIZE:
+		alg_name = "sha512-keembay-ocs";
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
+	if (IS_ERR(ahash_tfm))
+		return PTR_ERR(ahash_tfm);
+
+	req = ahash_request_alloc(ahash_tfm, GFP_KERNEL);
+	if (!req) {
+		rc = -ENOMEM;
+		goto err_free_ahash;
+	}
+
+	crypto_init_wait(&wait);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &wait);
+	crypto_ahash_clear_flags(ahash_tfm, ~0);
+
+	buf = kzalloc(keylen, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto err_free_req;
+	}
+
+	memcpy(buf, key, keylen);
+	sg_init_one(&sg, buf, keylen);
+	ahash_request_set_crypt(req, &sg, ctx->key, keylen);
+
+	rc = crypto_wait_req(crypto_ahash_digest(req), &wait);
+	if (rc == 0)
+		ctx->key_len = digestsize;
+
+	kfree(buf);
+err_free_req:
+	ahash_request_free(req);
+err_free_ahash:
+	crypto_free_ahash(ahash_tfm);
+
+	return rc;
+}
+
+/* Set request size and initialize tfm context. */
+static void __cra_init(struct crypto_tfm *tfm, struct ocs_hcu_ctx *ctx)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct ocs_hcu_rctx));
+
+	/* Init context to 0. */
+	memzero_explicit(ctx, sizeof(*ctx));
+	/* Set engine ops. */
+	ctx->engine_ctx.op.do_one_request = kmb_ocs_hcu_do_one_request;
+	ctx->engine_ctx.op.prepare_request = kmb_ocs_hcu_prepare_request;
+}
+
+static int kmb_ocs_hcu_sha_cra_init(struct crypto_tfm *tfm)
+{
+	struct ocs_hcu_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__cra_init(tfm, ctx);
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct ocs_hcu_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__cra_init(tfm, ctx);
+
+	ctx->is_sm3_tfm = true;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_hmac_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct ocs_hcu_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__cra_init(tfm, ctx);
+
+	ctx->is_sm3_tfm = true;
+	ctx->is_hmac_tfm = true;
+
+	return 0;
+}
+
+static int kmb_ocs_hcu_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct ocs_hcu_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__cra_init(tfm, ctx);
+
+	ctx->is_hmac_tfm = true;
+
+	return 0;
+}
+
+/* Function called when 'tfm' is de-initialized. */
+static void kmb_ocs_hcu_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct ocs_hcu_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* Clear the key. */
+	memzero_explicit(ctx->key, sizeof(ctx->key));
+}
+
+static struct ahash_alg ocs_hcu_algs[] = {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sha224",
+			.cra_driver_name	= "sha224-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA224_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sha_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sha224)",
+			.cra_driver_name	= "hmac-sha224-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA224_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+},
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sha256",
+			.cra_driver_name	= "sha256-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sha_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sha256)",
+			.cra_driver_name	= "hmac-sha256-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SM3_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sm3",
+			.cra_driver_name	= "sm3-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SM3_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sm3_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SM3_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sm3)",
+			.cra_driver_name	= "hmac-sm3-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SM3_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_sm3_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SHA384_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sha384",
+			.cra_driver_name	= "sha384-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA384_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sha_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SHA384_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sha384)",
+			.cra_driver_name	= "hmac-sha384-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA384_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SHA512_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sha512",
+			.cra_driver_name	= "sha512-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA512_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sha_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SHA512_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sha512)",
+			.cra_driver_name	= "hmac-sha512-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA512_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= KMB_OCS_HCU_ALIGN_MASK,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+}
+
+};
+
+static irqreturn_t kmb_ocs_hcu_irq_thread(int irq, void *dev_id)
+{
+	struct ocs_hcu_dev *hcu_dev = (struct ocs_hcu_dev *)dev_id;
+	struct ocs_hcu_rctx *rctx = ahash_request_ctx(hcu_dev->req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(hcu_dev->req);
+	struct ocs_hcu_ctx *ctx = crypto_ahash_ctx(tfm);
+	int rc = 0;
+	int i;
+
+	if (hcu_dev->flags & HCU_FLAGS_HCU_ERROR_MASK) {
+		rc = -EIO;
+		goto finish;
+	}
+
+	/*
+	 * If the DO_OPAD flag is set, it means that we are finalizing a SW
+	 * HMAC request and we just computed the result of H(k ^ ipad || m).
+	 *
+	 * We now need to complete the HMAC calculation with the OPAD step,
+	 * that is, we need to compute H(k ^ opad || digest), where digest is
+	 * the digest we just obtained, i.e., H(k ^ ipad || m).
+	 */
+	if (rctx->flags & REQ_FLAGS_HMAC_SW_DO_OPAD) {
+		/* Gets the intermediate data (which includes the digest). */
+		rc = ocs_hcu_get_intermediate_data(hcu_dev, &rctx->idata,
+						   rctx->algo);
+		if (rc)
+			goto finish;
+		/*
+		 * Compute k ^ opad and store it in the request buffer (which
+		 * is not used anymore at this point).
+		 * Note: key has been padded / hashed already (so keylen ==
+		 * blksz) .
+		 */
+		WARN_ON(ctx->key_len != rctx->blk_sz);
+		for (i = 0; i < rctx->blk_sz; i++)
+			rctx->buffer[i] = ctx->key[i] ^ HMAC_OPAD_VALUE;
+		/* Now append the digest to the rest of the buffer. */
+		for (i = 0; (i < rctx->dig_sz); i++)
+			rctx->buffer[rctx->blk_sz + i] = rctx->idata.digest[i];
+		/*
+		 * Remove the DO_OPAD flag (so we won't end up here again after
+		 * final hash is computed).
+		 */
+		rctx->flags &= ~(REQ_FLAGS_HMAC_SW_DO_OPAD);
+		/* Now hash the buffer to obtain the final HMAC. */
+		rc = kmb_ocs_hcu_hash_pio(hcu_dev, rctx->buffer,
+					  rctx->blk_sz + rctx->dig_sz,
+					  rctx->algo, true);
+		if (rc)
+			goto finish;
+
+		return IRQ_HANDLED;
+	}
+
+finish:
+	kmb_ocs_hcu_finish_request(hcu_dev, rc);
+
+	return IRQ_HANDLED;
+}
+
+/* Device tree driver match. */
+static const struct of_device_id kmb_ocs_hcu_of_match[] = {
+	{
+		.compatible = "intel,keembay-ocs-hcu",
+	},
+	{}
+};
+
+static int kmb_ocs_hcu_remove(struct platform_device *pdev)
+{
+	struct ocs_hcu_dev *hcu_dev;
+	int rc;
+
+	hcu_dev = platform_get_drvdata(pdev);
+	if (!hcu_dev)
+		return -ENODEV;
+
+	crypto_unregister_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
+
+	spin_lock(&ocs_hcu.lock);
+	list_del(&hcu_dev->list);
+	spin_unlock(&ocs_hcu.lock);
+
+	rc = crypto_engine_exit(hcu_dev->engine);
+
+	ocs_hcu_hw_disable(hcu_dev);
+
+	return rc;
+}
+
+static int kmb_ocs_hcu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ocs_hcu_dev *hcu_dev;
+	struct resource *hcu_mem;
+	int rc;
+
+	hcu_dev = devm_kzalloc(dev, sizeof(*hcu_dev), GFP_KERNEL);
+	if (!hcu_dev)
+		return -ENOMEM;
+
+	hcu_dev->dev = dev;
+
+	platform_set_drvdata(pdev, hcu_dev);
+	rc = dma_set_mask_and_coherent(&pdev->dev, OCS_HCU_DMA_BIT_MASK);
+	if (rc)
+		return rc;
+
+	INIT_LIST_HEAD(&hcu_dev->list);
+
+	/* Get the memory address and remap. */
+	hcu_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!hcu_mem) {
+		dev_err(dev, "Could not retrieve io mem resource.\n");
+		rc = -ENODEV;
+		goto list_del;
+	}
+
+	hcu_dev->io_base = devm_ioremap_resource(dev, hcu_mem);
+	if (IS_ERR(hcu_dev->io_base)) {
+		dev_err(dev, "Could not io-remap mem resource.\n");
+		rc = PTR_ERR(hcu_dev->io_base);
+		goto list_del;
+	}
+
+	/* Get and request IRQ. */
+	hcu_dev->irq = platform_get_irq(pdev, 0);
+	if (hcu_dev->irq < 0) {
+		dev_err(dev, "Could not retrieve IRQ.\n");
+		rc = hcu_dev->irq;
+		goto list_del;
+	}
+
+	rc = devm_request_threaded_irq(&pdev->dev, hcu_dev->irq,
+				       ocs_hcu_irq_handler,
+				       kmb_ocs_hcu_irq_thread,
+				       0, "keembay-ocs-hcu", hcu_dev);
+	if (rc < 0) {
+		dev_err(dev, "Could not request IRQ.\n");
+		goto list_del;
+	}
+
+	spin_lock(&ocs_hcu.lock);
+	list_add_tail(&hcu_dev->list, &ocs_hcu.dev_list);
+	spin_unlock(&ocs_hcu.lock);
+
+	/* Initialize crypto engine */
+	hcu_dev->engine = crypto_engine_alloc_init(dev, 1);
+	if (!hcu_dev->engine)
+		goto list_del;
+
+	rc = crypto_engine_start(hcu_dev->engine);
+	if (rc) {
+		dev_err(dev, "Could not start engine.\n");
+		goto cleanup;
+	}
+
+	/* Security infrastructure guarantees OCS clock is enabled. */
+
+	rc = crypto_register_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
+	if (rc) {
+		dev_err(dev, "Could not register algorithms.\n");
+		goto cleanup;
+	}
+
+	return 0;
+cleanup:
+	crypto_engine_exit(hcu_dev->engine);
+list_del:
+	spin_lock(&ocs_hcu.lock);
+	list_del(&hcu_dev->list);
+	spin_unlock(&ocs_hcu.lock);
+
+	return rc;
+}
+
+/* The OCS driver is a platform device. */
+static struct platform_driver kmb_ocs_hcu_driver = {
+	.probe = kmb_ocs_hcu_probe,
+	.remove = kmb_ocs_hcu_remove,
+	.driver = {
+			.name = DRV_NAME,
+			.of_match_table = kmb_ocs_hcu_of_match,
+		},
+};
+
+module_platform_driver(kmb_ocs_hcu_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/keembay/ocs-hcu.c b/drivers/crypto/keembay/ocs-hcu.c
new file mode 100644
index 000000000000..5523a03975a7
--- /dev/null
+++ b/drivers/crypto/keembay/ocs-hcu.c
@@ -0,0 +1,593 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel Keem Bay OCS HCU Crypto Driver.
+ *
+ * Copyright (C) 2018-2020 Intel Corporation
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/iopoll.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+
+#include <crypto/sha.h>
+
+#include "ocs-hcu.h"
+
+#define OCS_HCU_MODE			0x00
+#define OCS_HCU_CHAIN			0x04
+#define OCS_HCU_OPERATION		0x08
+#define OCS_HCU_KEY_0			0x0C
+#define OCS_HCU_KEY_1			0x10
+#define OCS_HCU_KEY_2			0x14
+#define OCS_HCU_KEY_3			0x18
+#define OCS_HCU_KEY_4			0x1C
+#define OCS_HCU_KEY_5			0x20
+#define OCS_HCU_KEY_6			0x24
+#define OCS_HCU_KEY_7			0x28
+#define OCS_HCU_KEY_8			0x2C
+#define OCS_HCU_KEY_9			0x30
+#define OCS_HCU_KEY_10			0x34
+#define OCS_HCU_KEY_11			0x38
+#define OCS_HCU_KEY_12			0x3C
+#define OCS_HCU_KEY_13			0x40
+#define OCS_HCU_KEY_14			0x44
+#define OCS_HCU_KEY_15			0x48
+#define OCS_HCU_ISR			0x50
+#define OCS_HCU_IER			0x54
+#define OCS_HCU_STATUS			0x58
+#define OCS_HCU_MSG_LEN_LO		0x60
+#define OCS_HCU_MSG_LEN_HI		0x64
+#define OCS_HCU_KEY_BYTE_ORDER_CFG	0x80
+#define OCS_HCU_DMA_SRC_ADDR		0x400
+#define OCS_HCU_DMA_DST_ADDR		0x404
+#define OCS_HCU_DMA_SRC_SIZE		0x408
+#define OCS_HCU_DMA_DST_SIZE		0x40C
+#define OCS_HCU_DMA_DMA_MODE		0x410
+#define OCS_HCU_DMA_OTHER_MODE		0x414
+#define OCS_HCU_DMA_NEXT_SRC_DESCR	0x418
+#define OCS_HCU_DMA_NEXT_DST_DESCR	0x41C
+#define OCS_HCU_DMA_WHILE_ACTIVE_MODE	0x420
+#define OCS_HCU_DMA_LOG			0x424
+#define OCS_HCU_DMA_STATUS		0x428
+#define OCS_HCU_DMA_PERF_CNTR		0x42C
+#define OCS_HCU_DMA_VALID_SAI_31_0	0x440
+#define OCS_HCU_DMA_VALID_SAI_63_32	0x444
+#define OCS_HCU_DMA_VALID_SAI_95_64	0x448
+#define OCS_HCU_DMA_VALID_SAI_127_96	0x44C
+#define OCS_HCU_DMA_VALID_SAI_159_128	0x450
+#define OCS_HCU_DMA_VALID_SAI_191_160	0x454
+#define OCS_HCU_DMA_VALID_SAI_223_192	0x458
+#define OCS_HCU_DMA_VALID_SAI_255_224	0x45C
+#define OCS_HCU_DMA_MSI_ISR		0x480
+#define OCS_HCU_DMA_MSI_IER		0x484
+#define OCS_HCU_DMA_MSI_MASK		0x488
+#define OCS_HCU_DMA_MSI_MA		0x800
+#define OCS_HCU_DMA_MSI_DA		0x804
+#define OCS_HCU_DMA_MSI_EN		0x808
+#define OCS_HCU_DMA_INBUFFER_WRITE_FIFO	0x600
+#define OCS_HCU_DMA_OUTBUFFER_READ_FIFO	0x700
+
+/* Register bit definitions. */
+#define HCU_MODE_ALGO_SHIFT		16
+#define HCU_MODE_ALGO_MASK		(OCS_HCU_ALGO_MASK \
+					 << HCU_MODE_ALGO_SHIFT)
+
+#define HCU_STATUS_BUSY_MASK		BIT(0)
+
+#define HCU_BYTE_ORDER_SWAP		BIT(0)
+
+#define HCU_IRQ_HASH_DONE		BIT(2)
+#define HCU_IRQ_HASH_ERR		(BIT(3) | BIT(1) | BIT(0))
+
+#define HCU_DMA_IRQ_SRC_DONE		BIT(0)
+#define HCU_DMA_IRQ_DST_DONE		BIT(1)
+#define HCU_DMA_IRQ_SAI_ERR		BIT(2)
+#define HCU_DMA_IRQ_BAD_COMP_ERR	BIT(3)
+#define HCU_DMA_IRQ_INBUF_RD_ERR	BIT(4)
+#define HCU_DMA_IRQ_INBUF_WD_ERR	BIT(5)
+#define HCU_DMA_IRQ_OUTBUF_WR_ERR	BIT(6)
+#define HCU_DMA_IRQ_OUTBUF_RD_ERR	BIT(7)
+#define HCU_DMA_IRQ_CRD_ERR		BIT(8)
+#define HCU_DMA_IRQ_ERR_MASK		(HCU_DMA_IRQ_SAI_ERR | \
+					 HCU_DMA_IRQ_BAD_COMP_ERR | \
+					 HCU_DMA_IRQ_INBUF_RD_ERR | \
+					 HCU_DMA_IRQ_INBUF_WD_ERR | \
+					 HCU_DMA_IRQ_OUTBUF_WR_ERR | \
+					 HCU_DMA_IRQ_OUTBUF_RD_ERR | \
+					 HCU_DMA_IRQ_CRD_ERR)
+
+#define HCU_DMA_SNOOP_MASK		(0x7 << 28)
+#define HCU_DMA_SRC_LL_EN		BIT(25)
+#define HCU_DMA_EN			BIT(31)
+#define HCU_DMA_STAT_SRC_DONE		BIT(15)
+
+#define HCU_MODE_HMAC_SHIFT		22
+#define HCU_MODE_HMAC_MASK		BIT(HCU_MODE_HMAC_SHIFT)
+
+#define KMB_HCU_ENDIANNESS_VALUE	(0x2A)
+
+#define HCU_DMA_MSI_UNMASK		BIT(0)
+#define HCU_DMA_MSI_DISABLE		0
+#define HCU_IRQ_DISABLE			0
+
+#define OCS_HCU_START			BIT(0)
+#define OCS_HCU_TERMINATE		BIT(1)
+
+#define HCU_CHAIN_WRITE_ENDIANNESS_OFFSET	30
+#define HCU_CHAIN_READ_ENDIANNESS_OFFSET	28
+#define HCU_DATA_WRITE_ENDIANNESS_OFFSET	26
+
+#define OCS_HCU_NUM_CHAINS_SHA256_224_SM3	8
+#define OCS_HCU_NUM_CHAINS_SHA384_512		16
+
+#define OCS_HCU_HASH_FINAL_CPU_RETRIES		1000
+/*
+ * While polling on a busy HCU, wait maximum 200us between one check and the
+ * other.
+ */
+#define OCS_HCU_WAIT_BUSY_RETRY_DELAY_US	200
+/* Wait on a busy HCU for maximum 1 second. */
+#define OCS_HCU_WAIT_BUSY_TIMEOUT_US		1000000
+
+static inline u32 ocs_hcu_num_chains(u32 algo)
+{
+	switch (algo & OCS_HCU_ALGO_MASK) {
+	case OCS_HCU_ALGO_SHA224:
+	case OCS_HCU_ALGO_SHA256:
+	case OCS_HCU_ALGO_SM3:
+		return OCS_HCU_NUM_CHAINS_SHA256_224_SM3;
+	case OCS_HCU_ALGO_SHA384:
+	case OCS_HCU_ALGO_SHA512:
+		return OCS_HCU_NUM_CHAINS_SHA384_512;
+	default:
+		return 0;
+	};
+}
+
+static inline u32 ocs_hcu_block_size(u32 algo)
+{
+	switch (algo & OCS_HCU_ALGO_MASK) {
+	case OCS_HCU_ALGO_SHA224:
+		return SHA224_BLOCK_SIZE;
+	case OCS_HCU_ALGO_SHA256:
+	case OCS_HCU_ALGO_SM3:
+		/* SM3 shares the same block size. */
+		return SHA256_BLOCK_SIZE;
+	case OCS_HCU_ALGO_SHA384:
+		return SHA384_BLOCK_SIZE;
+	case OCS_HCU_ALGO_SHA512:
+		return SHA512_BLOCK_SIZE;
+	default:
+		return 0;
+	}
+}
+
+/**
+ * ocs_hcu_wait_busy() - Wait for HCU OCS hardware to became usable.
+ * @hcu_dev:	OCS HCU device to wait for.
+ *
+ * Return: 0 if device free, -ETIMEOUT if device busy and internal timeout has
+ *	   expired.
+ */
+int ocs_hcu_wait_busy(struct ocs_hcu_dev *hcu_dev)
+{
+	long val;
+
+	return readl_poll_timeout(hcu_dev->io_base + OCS_HCU_STATUS, val,
+				  !(val & HCU_STATUS_BUSY_MASK),
+				  OCS_HCU_WAIT_BUSY_RETRY_DELAY_US,
+				  OCS_HCU_WAIT_BUSY_TIMEOUT_US);
+}
+
+static void ocs_hcu_done_irq_en(struct ocs_hcu_dev *hcu_dev)
+{
+	/* Clear any pending interrupts. */
+	writel(0xFFFFFFFF, hcu_dev->io_base + OCS_HCU_ISR);
+	/* Enable error and HCU done interrupts. */
+	writel(HCU_IRQ_HASH_DONE | HCU_IRQ_HASH_ERR,
+	       hcu_dev->io_base + OCS_HCU_IER);
+}
+
+static void ocs_hcu_dma_irq_en(struct ocs_hcu_dev *hcu_dev)
+{
+	/* Clear any pending interrupts. */
+	writel(0xFFFFFFFF, hcu_dev->io_base + OCS_HCU_DMA_MSI_ISR);
+	/* Only operating on DMA source completion and error interrupts. */
+	writel(HCU_DMA_IRQ_ERR_MASK | HCU_DMA_IRQ_SRC_DONE,
+	       hcu_dev->io_base + OCS_HCU_DMA_MSI_IER);
+	/* Unmask */
+	writel(HCU_DMA_MSI_UNMASK, hcu_dev->io_base + OCS_HCU_DMA_MSI_MASK);
+}
+
+static void ocs_hcu_irq_dis(struct ocs_hcu_dev *hcu_dev)
+{
+	writel(HCU_IRQ_DISABLE, hcu_dev->io_base + OCS_HCU_IER);
+	writel(HCU_DMA_MSI_DISABLE, hcu_dev->io_base + OCS_HCU_DMA_MSI_IER);
+}
+
+/**
+ * ocs_hcu_get_intermediate_data() - Get intermediate data.
+ * @hcu_dev:	The target HCU device.
+ * @data:	Where to store the intermediate.
+ * @algo:	The algorithm being used.
+ *
+ * This function is used to save the current hashing process state in order to
+ * continue it in the future.
+ *
+ * Note: once all data has been processed, the intermediate data actually
+ * contains the hashing result. So this function is also used to retrieve the
+ * final result of a hashing process.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int ocs_hcu_get_intermediate_data(struct ocs_hcu_dev *hcu_dev,
+				  struct ocs_hcu_idata *data, u32 algo)
+{
+	const int n = ocs_hcu_num_chains(algo);
+	u32 *chain;
+	int busy;
+	int i;
+
+	/* Data not requested. */
+	if (!data)
+		return -EINVAL;
+
+	chain = (u32 *)data->digest;
+
+	/* Ensure that the OCS is no longer busy before reading the chains. */
+	busy = ocs_hcu_wait_busy(hcu_dev);
+
+	if (busy)
+		return -EBUSY;
+
+	for (i = 0; i < n; i++)
+		chain[i] = readl(hcu_dev->io_base + OCS_HCU_CHAIN);
+
+	data->msg_len_lo = readl(hcu_dev->io_base + OCS_HCU_MSG_LEN_LO);
+	data->msg_len_hi = readl(hcu_dev->io_base + OCS_HCU_MSG_LEN_HI);
+
+	return 0;
+}
+
+/**
+ * ocs_hcu_set_intermediate_data() - Set intermediate data.
+ * @hcu_dev:	The target HCU device.
+ * @data:	The intermediate data to be set.
+ * @algo:	The algorithm being used.
+ *
+ * This function is used to continue a previous hashing process.
+ */
+void ocs_hcu_set_intermediate_data(struct ocs_hcu_dev *hcu_dev,
+				   struct ocs_hcu_idata *data, u32 algo)
+{
+	const int n = ocs_hcu_num_chains(algo);
+	u32 *chain = (u32 *)data->digest;
+	int i;
+
+	for (i = 0; i < n; i++)
+		writel(chain[i], hcu_dev->io_base + OCS_HCU_CHAIN);
+
+	writel(data->msg_len_lo, hcu_dev->io_base + OCS_HCU_MSG_LEN_LO);
+	writel(data->msg_len_hi, hcu_dev->io_base + OCS_HCU_MSG_LEN_HI);
+}
+
+/**
+ * ocs_hcu_hw_init() - Initialize the HCU device.
+ * @hcu_dev:	The HCU device to initialize.
+ */
+void ocs_hcu_hw_init(struct ocs_hcu_dev *hcu_dev)
+{
+	u32 cfg = 0;
+
+	/* Return if HW is already initialized. */
+	if (hcu_dev->flags & HCU_FLAGS_HCU_INIT)
+		return;
+	/* Initialize hardware. */
+	cfg = KMB_HCU_ENDIANNESS_VALUE << HCU_DATA_WRITE_ENDIANNESS_OFFSET;
+	writel(cfg, hcu_dev->io_base + OCS_HCU_MODE);
+	hcu_dev->flags |= HCU_FLAGS_HCU_INIT;
+}
+
+/**
+ * ocs_hcu_hw_cfg() - Configure the HCU hardware.
+ * @hcu_dev:	The HCU device to configure.
+ * @algo:	The algorithm to be used by the HCU device.
+ *
+ * NOTE: This function must be called after ocs_hcu_hw_init().
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int ocs_hcu_hw_cfg(struct ocs_hcu_dev *hcu_dev, u32 algo)
+{
+	u32 cfg = readl(hcu_dev->io_base + OCS_HCU_MODE);
+	u32 ocs_algo = algo & OCS_HCU_ALGO_MASK;
+
+	if (ocs_algo != OCS_HCU_ALGO_SHA256 &&
+	    ocs_algo != OCS_HCU_ALGO_SHA224 &&
+	    ocs_algo != OCS_HCU_ALGO_SHA384 &&
+	    ocs_algo != OCS_HCU_ALGO_SHA512 &&
+	    ocs_algo != OCS_HCU_ALGO_SM3)
+		return -EINVAL;
+
+	if ((hcu_dev->flags & HCU_FLAGS_HCU_INIT) == 0)
+		return -EPERM;
+
+	cfg &= ~HCU_MODE_ALGO_MASK;
+	cfg |= ocs_algo << HCU_MODE_ALGO_SHIFT;
+	cfg &= ~HCU_MODE_HMAC_MASK;
+	if (algo & OCS_HCU_ALGO_HMAC_MASK)
+		cfg |= BIT(HCU_MODE_HMAC_SHIFT);
+
+	writel(cfg, hcu_dev->io_base + OCS_HCU_MODE);
+
+	return 0;
+}
+
+/**
+ * ocs_hcu_hw_disable() - Disable the HCU hardware.
+ * @hcu_dev:	The HCU device to disable.
+ */
+void ocs_hcu_hw_disable(struct ocs_hcu_dev *hcu_dev)
+{
+	if ((hcu_dev->flags & HCU_FLAGS_HCU_INIT) == HCU_FLAGS_HCU_INIT) {
+		/* Clear hardware. */
+		writel(0, hcu_dev->io_base + OCS_HCU_MODE);
+		ocs_hcu_irq_dis(hcu_dev);
+		hcu_dev->flags &= ~HCU_FLAGS_HCU_INIT;
+	}
+}
+
+/**
+ * ocs_hcu_tx_data_done() - Request the hardware to compute the final hash.
+ * @hcu_dev:	The HCU device to use.
+ */
+void ocs_hcu_tx_data_done(struct ocs_hcu_dev *hcu_dev)
+{
+	/*
+	 * Enable HCU interrupts, so that HCU_DONE will be triggered once the
+	 * final hash is computed.
+	 */
+	ocs_hcu_done_irq_en(hcu_dev);
+	writel(OCS_HCU_TERMINATE, hcu_dev->io_base + OCS_HCU_OPERATION);
+}
+
+static unsigned int ocs_hcu_hash_final_cpu(struct ocs_hcu_dev *hcu_dev,
+					   u8 *buf, u32 sz)
+{
+	int retries = OCS_HCU_HASH_FINAL_CPU_RETRIES;
+	u32 sz_32 = sz / sizeof(u32);
+	u32 *buf_32 = (u32 *)buf;
+	int i;
+
+	/* Write in using full register size. */
+	for (i = 0; i < sz_32; i++)
+		writel(buf_32[i], hcu_dev->io_base +
+		       OCS_HCU_DMA_INBUFFER_WRITE_FIFO);
+
+	/* Write final bytes into buffer. */
+	for (i = sz_32 * sizeof(u32); i < sz; i++)
+		writeb(buf[i], hcu_dev->io_base +
+		       OCS_HCU_DMA_INBUFFER_WRITE_FIFO);
+
+	/* Wait until the writes are complete. */
+	do {
+		if ((readl(hcu_dev->io_base + OCS_HCU_DMA_STATUS) &
+		    HCU_DMA_STAT_SRC_DONE))
+			break;
+
+		if ((readl(hcu_dev->io_base + OCS_HCU_DMA_MSI_ISR) &
+		    HCU_DMA_IRQ_ERR_MASK))
+			return 0;
+
+		usleep_range(100, 200);
+	} while (retries--);
+
+	return sz;
+}
+
+static unsigned int ocs_hcu_hash_block_aligned_cpu(struct ocs_hcu_dev *hcu_dev,
+						   u8 *buf, u32 sz, u32 algo)
+{
+	u32 blk_sz = ocs_hcu_block_size(algo);
+	u32 *buf_32 = (u32 *)buf;
+	u32 blk_sz_32;
+	u32 num_blks;
+	int i;
+
+	if (blk_sz == 0)
+		return 0;
+
+	blk_sz_32 = blk_sz / sizeof(u32);
+	num_blks = sz / blk_sz;
+
+	for (i = 0; i < (blk_sz_32 * num_blks); i++)
+		writel(buf_32[i], hcu_dev->io_base +
+			   OCS_HCU_DMA_INBUFFER_WRITE_FIFO);
+
+	if (readl(hcu_dev->io_base + OCS_HCU_DMA_MSI_ISR) &
+	    HCU_DMA_IRQ_ERR_MASK)
+		return 0;
+
+	return i * sizeof(u32);
+}
+
+static void ocs_hcu_start_hash(struct ocs_hcu_dev *hcu_dev)
+{
+	writel(OCS_HCU_START, hcu_dev->io_base + OCS_HCU_OPERATION);
+}
+
+/**
+ * ocs_hcu_hash_cpu() - Perform OCS HCU hashing without using DMA.
+ * @hcu_dev:	The OCS HCU device to use.
+ * @buf:	The data to hash.
+ * @sz:		The size of the data to hash.
+ * @algo:	The hashing algorithm to use.
+ * @finalize:	Whether or not this is the last hashing operation and therefore
+ *		the final hash should be compute even if data is not
+ *		block-aligned.
+ *
+ * Return: the number of bytes hashed.
+ */
+unsigned int ocs_hcu_hash_cpu(struct ocs_hcu_dev *hcu_dev,
+			      u8 *buf, u32 sz, u32 algo, bool finalize)
+{
+	unsigned int written;
+
+	if (!buf)
+		return 0;
+
+	written = ocs_hcu_hash_block_aligned_cpu(hcu_dev, buf, sz, algo);
+
+	if (finalize) {
+		sz -= written;
+		if (sz) {
+			buf += written;
+			written += ocs_hcu_hash_final_cpu(hcu_dev, buf, sz);
+		}
+		ocs_hcu_tx_data_done(hcu_dev);
+	}
+
+	return written;
+}
+
+/**
+ * ocs_hcu_ll_dma_start() - Start OCS HCU hashing via DMA
+ * @hcu_dev:	The OCS HCU device to use.
+ * @head:	The head of the OCS DMA list to hash.
+ * @finalize:	Whether or not this is the last hashing operation and therefore
+ *		the final hash should be compute even if data is not
+ *		block-aligned.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int ocs_hcu_ll_dma_start(struct ocs_hcu_dev *hcu_dev, dma_addr_t head,
+			 bool finalize)
+{
+	u32 cfg = HCU_DMA_SNOOP_MASK | HCU_DMA_SRC_LL_EN | HCU_DMA_EN;
+
+	if (head == DMA_MAPPING_ERROR || head & ~OCS_HCU_DMA_BIT_MASK)
+		return -EINVAL;
+
+	/*
+	 * For final requests we use HCU_DONE IRQ to be notified when all input
+	 * data has been processed by the HCU; however, we cannot do so for
+	 * non-final requests, because we don't get a HCU_DONE IRQ when we
+	 * don't terminate the operation.
+	 *
+	 * Therefore, for non-final requests, we use the DMA IRQ, which
+	 * triggers when DMA has finishing feeding all the input data to the
+	 * HCU, but the HCU may still be processing it. This is fine, since we
+	 * will wait for the HCU processing to be completed when we try to read
+	 * intermediate results, in ocs_hcu_get_intermediate_data().
+	 */
+	if (finalize)
+		ocs_hcu_done_irq_en(hcu_dev);
+	else
+		ocs_hcu_dma_irq_en(hcu_dev);
+
+	writel(head, hcu_dev->io_base + OCS_HCU_DMA_NEXT_SRC_DESCR);
+	writel(0, hcu_dev->io_base + OCS_HCU_DMA_SRC_SIZE);
+	writel(0, hcu_dev->io_base + OCS_HCU_DMA_DST_SIZE);
+	ocs_hcu_start_hash(hcu_dev);
+	writel(cfg, hcu_dev->io_base + OCS_HCU_DMA_DMA_MODE);
+
+	if (finalize)
+		writel(OCS_HCU_TERMINATE, hcu_dev->io_base + OCS_HCU_OPERATION);
+
+	return 0;
+}
+
+/**
+ * ocs_hcu_write_key() - Write key to OCS HMAC KEY registers.
+ * @hcu_dev:	The OCS HCU device the key should be written to.
+ * @key:	The key to be written.
+ * @len:	The size of the key to write. It must be HCU_HW_KEY_LEN.
+ *
+ * Return:	0 on success, negative error code otherwise.
+ */
+int ocs_hcu_write_key(struct ocs_hcu_dev *hcu_dev, u8 *key, size_t len)
+{
+	u32 *key_32 = (u32 *)key;
+	size_t len32;
+	int i = 0;
+
+	if (len != HCU_HW_KEY_LEN)
+		return -EINVAL;
+
+	/*
+	 * OCS hardware expects the MSB of the key to be written at the highest
+	 * address of the HCU Key vector; in other word, the key must be
+	 * written in reverse order.
+	 *
+	 * Therefore, we first enable byte swapping for the HCU key vector;
+	 * so that bytes of 32-bit word written to OCS_HCU_KEY_[0..15] will be
+	 * swapped:
+	 * 3 <---> 0, 2 <---> 1.
+	 */
+	writel(HCU_BYTE_ORDER_SWAP,
+	       hcu_dev->io_base + OCS_HCU_KEY_BYTE_ORDER_CFG);
+	/*
+	 * And then we write the 32-bit words composing the key starting from
+	 * the end of the key.
+	 */
+	len32 = HCU_HW_KEY_LEN / sizeof(u32);
+	for (i = 0; i < len32; i++)
+		writel(key_32[len32 - 1 - i],
+		       hcu_dev->io_base + OCS_HCU_KEY_0 + (sizeof(u32) * i));
+
+	return 0;
+}
+
+/**
+ * ocs_hcu_write_key() - Clear key stored in OCS HMAC KEY registers.
+ * @hcu_dev:	The OCS HCU device whose key registers should be cleared.
+ */
+void ocs_hcu_clear_key(struct ocs_hcu_dev *hcu_dev)
+{
+	int reg_off;
+
+	/* Clear OCS_HCU_KEY_[0..15] */
+	for (reg_off = 0; reg_off < HCU_HW_KEY_LEN; reg_off += sizeof(u32))
+		writel(0, hcu_dev->io_base + OCS_HCU_KEY_0 + reg_off);
+}
+
+irqreturn_t ocs_hcu_irq_handler(int irq, void *dev_id)
+{
+	struct ocs_hcu_dev *hcu_dev = dev_id;
+	u32 hcu_irq = readl(hcu_dev->io_base + OCS_HCU_ISR);
+	u32 dma_irq = readl(hcu_dev->io_base + OCS_HCU_DMA_MSI_ISR);
+	irqreturn_t rc = IRQ_NONE;
+
+	/* Check the HCU status. */
+	if (hcu_irq & HCU_IRQ_HASH_ERR) {
+		hcu_dev->flags |= HCU_FLAGS_HCU_ERR;
+		rc = IRQ_WAKE_THREAD;
+	} else if (hcu_irq & HCU_IRQ_HASH_DONE) {
+		rc = IRQ_WAKE_THREAD;
+	}
+	/* Clear the HCU interrupt. */
+	writel(hcu_irq, hcu_dev->io_base + OCS_HCU_ISR);
+
+	/* Check the DMA status. */
+	if (dma_irq & HCU_DMA_IRQ_ERR_MASK) {
+		hcu_dev->flags |= HCU_FLAGS_HCU_DMA_ERR;
+		rc = IRQ_WAKE_THREAD;
+		goto exit;
+	}
+	if (dma_irq & HCU_DMA_IRQ_SRC_DONE) {
+		/* DMA is complete, indicate that the HCU is done this
+		 * transaction.
+		 */
+		rc = IRQ_WAKE_THREAD;
+	}
+
+exit:
+	/* Clear the HCU DMA interrupt. */
+	writel(dma_irq, hcu_dev->io_base + OCS_HCU_DMA_MSI_ISR);
+
+	return rc;
+}
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/keembay/ocs-hcu.h b/drivers/crypto/keembay/ocs-hcu.h
new file mode 100644
index 000000000000..3c7e3881791c
--- /dev/null
+++ b/drivers/crypto/keembay/ocs-hcu.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Intel Keem Bay OCS HCU Crypto Driver.
+ *
+ * Copyright (C) 2018-2020 Intel Corporation
+ */
+
+#include <linux/dma-mapping.h>
+
+#ifndef _CRYPTO_OCS_HCU_H
+#define _CRYPTO_OCS_HCU_H
+
+#define OCS_LL_DMA_FLAG_TERMINATE	BIT(31)
+#define OCS_LL_DMA_FLAG_FREEZE		BIT(30)
+#define OCS_LL_DMA_FLAG_RESERVED	(BIT(30) - 1)
+
+#define OCS_HCU_ALGO_SHA256		2
+#define OCS_HCU_ALGO_SHA224		3
+#define OCS_HCU_ALGO_SHA384		4
+#define OCS_HCU_ALGO_SHA512		5
+#define OCS_HCU_ALGO_SM3		6
+
+#define OCS_HCU_ALGO_MASK		(BIT(3) - 1)
+
+#define OCS_HCU_ALGO_HMAC_SHIFT		4
+#define OCS_HCU_ALGO_HMAC_MASK		BIT(OCS_HCU_ALGO_HMAC_SHIFT)
+
+#define OCS_HCU_DMA_NO_SNOOP		1
+#define OCS_HCU_DMA_SNOOP		0
+#define OCS_HCU_DMA_BTF_SWAP		1
+#define OCS_HCU_DMA_BTF_NO_SWAP		0
+#define OCS_HCU_DMA_ADDR_MODE_FIXED	1
+#define OCS_HCU_DMA_ADDR_MODE_LINEAR	0
+#define OCS_HCU_DMA_BIT_MASK		DMA_BIT_MASK(32)
+
+#define OCS_HCU_MAX_CHAIN_NUM		16
+
+/* Device flags */
+#define HCU_FLAGS_HCU_INIT		BIT(0)
+#define HCU_FLAGS_HCU_ERR		BIT(17)
+#define HCU_FLAGS_HCU_DMA_ERR		BIT(18)
+#define HCU_FLAGS_HCU_ERROR_MASK	(HCU_FLAGS_HCU_DMA_ERR | \
+					 HCU_FLAGS_HCU_ERR)
+
+#define HCU_HW_KEY_LEN			64
+
+/**
+ * HCU device context.
+ * @list: List of device contexts.
+ * @dev: OCS HCU device.
+ * @irq: IRQ number.
+ * @io_base: IO Base of HCU.
+ * @flags: HW flags indicating state.
+ * @req: Request being operated on.
+ * @engine: Crypto engine for the device.
+ */
+struct ocs_hcu_dev {
+	struct list_head list;
+	struct device *dev;
+	int irq;
+	/* Base address of OCS HCU */
+	void __iomem *io_base;
+	/* Status of the OCS HCU device */
+	u32 flags;
+	/* Active request. */
+	struct ahash_request *req;
+	struct crypto_engine *engine;
+};
+
+/**
+ * struct ocs_dma_desc - OCS DMA linked list descriptor.
+ * @src_addr:	Source address of the data.
+ * @src_len:	Length of data to be fetched.
+ * @nxt_desc:	Next descriptor to fetch.
+ * @ll_flags:	Flags (Freeze @ terminate) for the DMA engine.
+ */
+struct ocs_dma_desc {
+	u32 src_adr;
+	u32 src_len;
+	u32 nxt_desc;
+	u32 ll_flags;
+};
+
+/**
+ * Structure to contain the intermediate data generated by the HCU.
+ * @msg_len_lo: Length of data the HCU has operated on in bits, low 32b.
+ * @msg_len_hi: Length of data the HCU has operated on in bits, high 32b.
+ * @digest: The digest read from the HCU. If the HCU is terminated, it will
+ *	    contain the actual hash digest. Otherwise it is the intermediate
+ *	    state.
+ */
+struct ocs_hcu_idata {
+	u32 msg_len_lo;
+	u32 msg_len_hi;
+	u8 digest[SHA512_DIGEST_SIZE] __aligned(sizeof(u32));
+};
+
+irqreturn_t ocs_hcu_irq_handler(int irq, void *dev_id);
+int ocs_hcu_get_intermediate_data(struct ocs_hcu_dev *hcu_dev,
+				  struct ocs_hcu_idata *data, u32 algo);
+void ocs_hcu_set_intermediate_data(struct ocs_hcu_dev *hcu_dev,
+				   struct ocs_hcu_idata *data, u32 algo);
+void ocs_hcu_hw_init(struct ocs_hcu_dev *hcu_dev);
+void ocs_hcu_hw_disable(struct ocs_hcu_dev *hcu_dev);
+int ocs_hcu_hw_cfg(struct ocs_hcu_dev *hcu_dev, u32 algo);
+unsigned int ocs_hcu_hash_cpu(struct ocs_hcu_dev *hcu_dev,
+			      u8 *buf, u32 sz, u32 algo, bool finalize);
+int ocs_hcu_ll_dma_start(struct ocs_hcu_dev *hcu_dev, dma_addr_t head,
+			 bool finalize);
+void ocs_hcu_tx_data_done(struct ocs_hcu_dev *hcu_dev);
+int ocs_hcu_wait_busy(struct ocs_hcu_dev *hcu_dev);
+int ocs_hcu_write_key(struct ocs_hcu_dev *hcu_dev, u8 *key, size_t len);
+void ocs_hcu_clear_key(struct ocs_hcu_dev *hcu_dev);
+
+#endif /* _CRYPTO_OCS_HCU_H */
-- 
2.26.2

