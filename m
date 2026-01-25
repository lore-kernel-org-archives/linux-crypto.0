Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113823D7C7;
	Sun, 25 Jan 2026 03:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312161; cv=none; b=YqRruJCJs0aC9LupUqJ6oQBEWvl9DmxPKCRHNCgZzH/eqfmkaqgiqMDCPIhVXGW79SGgWlf31nsDP5aIXf2gs89iyhM6WNU7qqdj5Sh5eZrlvBcD9Ww8o6JI63e2QSjWmB0Uro6cpkl7QbVr3K+XQci10iw6pgrNTaJLRxGjXO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312161; c=relaxed/simple;
	bh=YwP8DJ47b+UJBaMfH+nHDscvFnvEPCpl4pZJKSv8MZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rPrN9zdXPawaFpT9N3cBlSaCAQwdWXlcXxXXXiSxXQFNOSIRP99CRJv9qZk2O7Se26gRXDKy0bs/1pWjiPu8pU3SUEAxTYOES13b6ZezE9ZCwqLlxLaDWyLzlAfRR+C8SDjnEZDO4oq700ubssztV9UeKlZgAg09ZeZawbhxNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KZ9osTc/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZ9osTc/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312157; x=1800848157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YwP8DJ47b+UJBaMfH+nHDscvFnvEPCpl4pZJKSv8MZw=;
  b=KZ9osTc/6+1m/g1xXW6yh7sKxDx4KkGPe3WSVKwgxlpYDMcqNyM0Hqmi
   YX+2oNLPG7GbQWAEW3mioWwjTB38hE3vpuXy0m7vWRT2tTxUyEgzw8UW5
   wM+gX0932yfU5lrbTIgziTUQrlIXwnYP1h7EXHOhgcXnT0i4Ki+SdgdNp
   8AY1YNhU1EJ+Rl3hqfVubxDMks5UMF9T+MguyQSp9JXVCZ75HlgE6xNAX
   WAI2rysD2QwV2XiXlxMwyGqRt1AfNPAfyQst2E6/jN6EWkQqRjBCFi10T
   8AUq0L7IpMtL8vDUQzpH+z3NtAj5WhAUX1cV9ZGikzEulIAYYVEzZuGuO
   w==;
X-CSE-ConnectionGUID: 7eN8PnnrTGKqSBA1phfe8g==
X-CSE-MsgGUID: arDGz8DFSLi5Uh6ajeRf9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887479"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887479"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:56 -0800
X-CSE-ConnectionGUID: 29TFFnDaSImLubnXmq0ivA==
X-CSE-MsgGUID: tvfbSViTSM2A7HX1648vHw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:55 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 12/26] crypto: iaa - Rearchitect iaa_crypto to have clean interfaces with crypto_acomp.
Date: Sat, 24 Jan 2026 19:35:23 -0800
Message-Id: <20260125033537.334628-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies the core functions in the iaa_crypto driver to be
independent of crypto_acomp, by adding a layer between the core driver
functionality and the crypto API. The core driver code is moved under
this layer that relies only on idxd, dma and scatterlist. This leads to
a cleaner interface.

We introduce a new "struct iaa_req" data structure, and light-weight
internal translation routines to/from crypto_acomp, namely,
acomp_to_iaa() and iaa_to_acomp().

The exception is that the driver defines a "static struct crypto_acomp
*deflate_crypto_comp" for the software decompress fall-back
path.

The acomp_alg .compress() and .decompress() interfaces call into
iaa_comp_acompress_main() and iaa_comp_adecompress_main(), which are
wrappers around the core crypto-independent driver functions.

These iaa_crypto interfaces will continue to be available through
crypto_acomp for use in zswap:

       int crypto_acomp_compress(struct acomp_req *req);
       int crypto_acomp_decompress(struct acomp_req *req);

Additionally, this patch resolves a race condition triggered when
IAA wqs and devices are continuously disabled/enabled when workloads are
using IAA for compression/decompression. This commit, in combination
with patches 0002 ("crypto: iaa - New architecture for IAA device WQ
comp/decomp usage & core mapping.) and 0005 (crypto: iaa - iaa_wq uses
percpu_refs for get/put reference counting.) in this series fix the race
condition. This has been verified using bisecting.

One other change made towards a cleaner architecture is the iaa_crypto
symbol namespace is changed from "IDXD" to "CRYPTO_DEV_IAA_CRYPTO".

Fixes: ea7a5cbb4369 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/Makefile          |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto.h      |  24 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 283 ++++++++++++++++-----
 3 files changed, 244 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/intel/iaa/Makefile b/drivers/crypto/intel/iaa/Makefile
index 55bda7770fac..ebfa1a425f80 100644
--- a/drivers/crypto/intel/iaa/Makefile
+++ b/drivers/crypto/intel/iaa/Makefile
@@ -3,7 +3,7 @@
 # Makefile for IAA crypto device drivers
 #
 
-ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"IDXD"'
+ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_DEV_IAA_CRYPTO"'
 
 obj-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO) := iaa_crypto.o
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 9611f2518f42..4dfb65c88f83 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -7,6 +7,7 @@
 #include <linux/crypto.h>
 #include <linux/idxd.h>
 #include <uapi/linux/idxd.h>
+#include <linux/scatterlist.h>
 
 #define IDXD_SUBDRIVER_NAME		"crypto"
 
@@ -29,8 +30,6 @@
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
 #define IAA_ERROR_WATCHDOG_EXPIRED	0x24
 
-#define IAA_COMP_MODES_MAX		2
-
 #define FIXED_HDR			0x2
 #define FIXED_HDR_SIZE			3
 
@@ -42,6 +41,23 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
+#define IAA_COMP_MODES_MAX  IAA_MODE_NONE
+
+enum iaa_mode {
+	IAA_MODE_FIXED = 0,
+	IAA_MODE_NONE = 1,
+};
+
+struct iaa_req {
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int slen;
+	unsigned int dlen;
+	u32 flags;
+	u32 compression_crc;
+	void *drv_data; /* for driver internal use */
+};
+
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
@@ -138,10 +154,6 @@ int add_iaa_compression_mode(const char *name,
 
 void remove_iaa_compression_mode(const char *name);
 
-enum iaa_mode {
-	IAA_MODE_FIXED,
-};
-
 struct iaa_compression_ctx {
 	enum iaa_mode	mode;
 	u16		alloc_comp_desc_timeout;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index aafa8d4afcf4..d4b0c09bff21 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -52,6 +52,10 @@ static struct wq_table_entry **pkg_global_decomp_wqs;
 /* All comp wqs from IAAs on a package. */
 static struct wq_table_entry **pkg_global_comp_wqs;
 
+/* For software deflate fallback compress/decompress. */
+static struct crypto_acomp *deflate_crypto_acomp;
+DEFINE_MUTEX(deflate_crypto_acomp_lock);
+
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -94,9 +98,18 @@ static atomic_t iaa_crypto_enabled = ATOMIC_INIT(0);
 static struct idxd_wq *first_wq_found;
 DEFINE_MUTEX(first_wq_found_lock);
 
-static bool iaa_crypto_registered;
+const char *iaa_compression_mode_names[IAA_COMP_MODES_MAX] = {
+	"fixed",
+};
+
+const char *iaa_compression_alg_names[IAA_COMP_MODES_MAX] = {
+	"deflate-iaa",
+};
 
 static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+static struct iaa_compression_ctx *iaa_ctx[IAA_COMP_MODES_MAX];
+static bool iaa_mode_registered[IAA_COMP_MODES_MAX];
+static u8 num_iaa_modes_registered;
 
 /* Distribute decompressions across all IAAs on the package. */
 static bool iaa_distribute_decomps;
@@ -354,6 +367,20 @@ static struct iaa_compression_mode *find_iaa_compression_mode(const char *name,
 	return NULL;
 }
 
+static bool iaa_alg_is_registered(const char *name, int *idx)
+{
+	int i;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		if (!strcmp(name, iaa_compression_alg_names[i]) && iaa_mode_registered[i]) {
+			*idx = i;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void free_iaa_compression_mode(struct iaa_compression_mode *mode)
 {
 	kfree(mode->name);
@@ -467,6 +494,7 @@ int add_iaa_compression_mode(const char *name,
 		 mode->name, idx);
 
 	iaa_compression_modes[idx] = mode;
+	++num_iaa_modes_registered;
 
 	ret = 0;
 out:
@@ -1441,19 +1469,46 @@ static struct idxd_wq *comp_wq_table_next_wq(int cpu)
  * Core iaa_crypto compress/decompress functions.
  *************************************************/
 
-static int deflate_generic_decompress(struct acomp_req *req)
+static int deflate_generic_decompress(struct iaa_req *req)
 {
-	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	ACOMP_REQUEST_ON_STACK(fbreq, deflate_crypto_acomp);
 	int ret;
 
+	acomp_request_set_callback(fbreq, 0, NULL, NULL);
+	acomp_request_set_params(fbreq, req->src, req->dst, req->slen,
+				 PAGE_SIZE);
+
+	mutex_lock(&deflate_crypto_acomp_lock);
+
 	ret = crypto_acomp_decompress(fbreq);
 	req->dlen = fbreq->dlen;
 
+	mutex_unlock(&deflate_crypto_acomp_lock);
+
 	update_total_sw_decomp_calls();
 
 	return ret;
 }
 
+static __always_inline void acomp_to_iaa(struct acomp_req *areq,
+					 struct iaa_req *req,
+					 struct iaa_compression_ctx *ctx)
+{
+	req->src = areq->src;
+	req->dst = areq->dst;
+	req->slen = areq->slen;
+	req->dlen = areq->dlen;
+	req->flags = 0;
+	if (unlikely(ctx->use_irq))
+		req->drv_data = areq;
+}
+
+static __always_inline void iaa_to_acomp(int dlen, struct acomp_req *areq)
+{
+	areq->dst->length = dlen;
+	areq->dlen = dlen;
+}
+
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -1515,7 +1570,7 @@ static inline int check_completion(struct device *dev,
 }
 
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
+				struct iaa_req *req,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr)
 {
 	int ret = 0;
@@ -1554,13 +1609,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 	return ret;
 }
 
-static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_compress_verify(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1613,10 +1666,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	if (*compression_crc != idxd_desc->iax_completion->crc) {
+	if (req->compression_crc != idxd_desc->iax_completion->crc) {
 		ret = -EINVAL;
 		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", *compression_crc,
+			" comp=0x%x, decomp=0x%x\n", req->compression_crc,
 			idxd_desc->iax_completion->crc);
 		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
 			       8, 1, idxd_desc->iax_completion, 64, 0);
@@ -1642,6 +1695,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
 	struct device *dev;
+	struct iaa_req req;
 	int ret, err = 0;
 
 	compression_ctx = crypto_tfm_ctx(ctx->tfm);
@@ -1667,19 +1721,25 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(ctx->req);
+
+			acomp_to_iaa(ctx->req, &req, compression_ctx);
+			ret = deflate_generic_decompress(&req);
+
 			if (ret) {
 				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
 					__func__, ret);
 				err = -EIO;
 				goto err;
+			} else {
+				iaa_to_acomp(req.dlen, ctx->req);
+				goto verify;
 			}
 		} else {
 			err = -EIO;
 			goto err;
 		}
 	} else {
-		ctx->req->dlen = idxd_desc->iax_completion->output_size;
+		iaa_to_acomp(idxd_desc->iax_completion->output_size, ctx->req);
 	}
 
 	/* Update stats */
@@ -1691,21 +1751,24 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		update_wq_decomp_bytes(iaa_wq->wq, ctx->req->slen);
 	}
 
+verify:
 	if (ctx->compress && compression_ctx->verify_compress) {
-		u32 *compression_crc = acomp_request_ctx(ctx->req);
 		dma_addr_t src_addr, dst_addr;
 
-		*compression_crc = idxd_desc->iax_completion->crc;
+		acomp_to_iaa(ctx->req, &req, compression_ctx);
+		req.compression_crc = idxd_desc->iax_completion->crc;
+
+		ret = iaa_remap_for_verify(dev, iaa_wq, &req, &src_addr, &dst_addr);
 
-		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
 			pr_err("%s: compress verify remap failed ret=%d\n", __func__, ret);
 			err = -EIO;
 			goto out;
 		}
 
-		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
+		ret = iaa_compress_verify(compression_ctx, &req, iaa_wq->wq, src_addr,
 					  ctx->req->slen, dst_addr, ctx->req->dlen);
+
 		if (ret) {
 			pr_err("%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1720,9 +1783,11 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	dma_unmap_sg(dev, ctx->req->dst, 1, DMA_FROM_DEVICE);
 	dma_unmap_sg(dev, ctx->req->src, 1, DMA_TO_DEVICE);
 out:
-	if (ret != 0)
+	if (ret) {
+		iaa_to_acomp(ret, ctx->req);
 		dev_dbg(dev, "asynchronous %s failed ret=%d\n",
 			ctx->compress ? "compress":"decompress", ret);
+	}
 
 	if (ctx->req->base.complete)
 		acomp_request_complete(ctx->req, err);
@@ -1802,13 +1867,11 @@ static __always_inline void iaa_submit_desc_movdir64b(struct idxd_wq *wq,
 	iosubmit_cmds512(portal, desc->hw, 1);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1856,17 +1919,18 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		}
 
 		*dlen = idxd_desc->iax_completion->output_size;
+		req->compression_crc = idxd_desc->iax_completion->crc;
 
 		/* Update stats */
 		update_total_comp_bytes_out(*dlen);
 		update_wq_comp_bytes(wq, *dlen);
-
-		*compression_crc = idxd_desc->iax_completion->crc;
 	} else {
+		struct acomp_req *areq = req->drv_data;
+
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
-		idxd_desc->crypto.req = req;
-		idxd_desc->crypto.tfm = tfm;
+		idxd_desc->crypto.req = areq;
+		idxd_desc->crypto.tfm = areq->base.tfm;
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
@@ -1890,12 +1954,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	return ret;
 }
 
-static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1939,10 +2002,12 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
 	} else {
+		struct acomp_req *areq = req->drv_data;
+
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
-		idxd_desc->crypto.req = req;
-		idxd_desc->crypto.tfm = tfm;
+		idxd_desc->crypto.req = areq;
+		idxd_desc->crypto.tfm = areq->base.tfm;
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
@@ -1993,20 +2058,16 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	return ret;
 }
 
-static int iaa_comp_acompress(struct acomp_req *req)
+static int iaa_comp_acompress(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
-	struct iaa_compression_ctx *compression_ctx;
-	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
 	struct device *dev;
 
-	compression_ctx = crypto_tfm_ctx(tfm);
-
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not compressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid src/dst, not compressing\n");
 		return -EINVAL;
 	}
 
@@ -2042,19 +2103,19 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	dst_addr = sg_dma_address(req->dst);
 
-	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
+	ret = iaa_compress(ctx, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (!ret && compression_ctx->verify_compress) {
+	if (!ret && ctx->verify_compress) {
 		ret = iaa_remap_for_verify(dev, iaa_wq, req, &src_addr, &dst_addr);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
 			goto out;
 		}
 
-		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
+		ret = iaa_compress_verify(ctx, req, wq, src_addr, req->slen,
 					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
@@ -2077,9 +2138,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	return ret;
 }
 
-static int iaa_comp_adecompress(struct acomp_req *req)
+static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
-	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
@@ -2123,7 +2183,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	dst_addr = sg_dma_address(req->dst);
 
-	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
+	ret = iaa_decompress(ctx, req, wq, src_addr, req->slen,
 			     dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
@@ -2140,8 +2200,9 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	return ret;
 }
 
-static void compression_ctx_init(struct iaa_compression_ctx *ctx)
+static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
+	ctx->mode = mode;
 	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
 	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
@@ -2153,22 +2214,56 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
  * Interfaces to crypto_alg and crypto_acomp.
  *********************************************/
 
-static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
+static int iaa_crypto_acomp_acompress_main(struct acomp_req *areq)
+{
+	struct crypto_tfm *tfm = areq->base.tfm;
+	struct iaa_compression_ctx *ctx;
+	struct iaa_req parent_req;
+	int ret = -ENODEV, idx;
+
+	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
+		ctx = iaa_ctx[idx];
+
+		acomp_to_iaa(areq, &parent_req, ctx);
+		ret = iaa_comp_acompress(ctx, &parent_req);
+		iaa_to_acomp(unlikely(ret) ? ret : parent_req.dlen, areq);
+	}
+
+	return ret;
+}
+
+static int iaa_crypto_acomp_adecompress_main(struct acomp_req *areq)
+{
+	struct crypto_tfm *tfm = areq->base.tfm;
+	struct iaa_compression_ctx *ctx;
+	struct iaa_req parent_req;
+	int ret = -ENODEV, idx;
+
+	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
+		ctx = iaa_ctx[idx];
+
+		acomp_to_iaa(areq, &parent_req, ctx);
+		ret = iaa_comp_adecompress(ctx, &parent_req);
+		iaa_to_acomp(unlikely(ret) ? ret : parent_req.dlen, areq);
+	}
+
+	return ret;
+}
+
+static int iaa_crypto_acomp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->mode = IAA_MODE_FIXED;
-
-	compression_ctx_init(ctx);
+	ctx = iaa_ctx[IAA_MODE_FIXED];
 
 	return 0;
 }
 
 static struct acomp_alg iaa_acomp_fixed_deflate = {
-	.init			= iaa_comp_init_fixed,
-	.compress		= iaa_comp_acompress,
-	.decompress		= iaa_comp_adecompress,
+	.init			= iaa_crypto_acomp_init_fixed,
+	.compress		= iaa_crypto_acomp_acompress_main,
+	.decompress		= iaa_crypto_acomp_adecompress_main,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2180,29 +2275,76 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	}
 };
 
+/*******************************************
+ * Implement idxd_device_driver interfaces.
+ *******************************************/
+
+static void iaa_unregister_compression_device(void)
+{
+	unsigned int i;
+
+	atomic_set(&iaa_crypto_enabled, 0);
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		iaa_mode_registered[i] = false;
+		kfree(iaa_ctx[i]);
+		iaa_ctx[i] = NULL;
+	}
+
+	num_iaa_modes_registered = 0;
+}
+
 static int iaa_register_compression_device(void)
 {
-	int ret;
+	struct iaa_compression_mode *mode;
+	int i, idx;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		iaa_mode_registered[i] = false;
+		mode = find_iaa_compression_mode(iaa_compression_mode_names[i], &idx);
+		if (mode) {
+			iaa_ctx[i] = kmalloc(sizeof(struct iaa_compression_ctx), GFP_KERNEL);
+			if (!iaa_ctx[i])
+				goto err;
+
+			compression_ctx_init(iaa_ctx[i], (enum iaa_mode)i);
+			iaa_mode_registered[i] = true;
+		}
+	}
+
+	if (iaa_mode_registered[IAA_MODE_FIXED])
+		return 0;
+
+	pr_err("%s: IAA_MODE_FIXED is not registered.", __func__);
+
+err:
+	iaa_unregister_compression_device();
+	return -ENODEV;
+}
+
+static int iaa_register_acomp_compression_device(void)
+{
+	int ret = -ENOMEM;
 
 	ret = crypto_register_acomp(&iaa_acomp_fixed_deflate);
 	if (ret) {
 		pr_err("deflate algorithm acomp fixed registration failed (%d)\n", ret);
-		goto out;
+		goto err_fixed;
 	}
 
-	iaa_crypto_registered = true;
-out:
+	return 0;
+
+err_fixed:
+	iaa_unregister_compression_device();
 	return ret;
 }
 
-static int iaa_unregister_compression_device(void)
+static void iaa_unregister_acomp_compression_device(void)
 {
 	atomic_set(&iaa_crypto_enabled, 0);
 
-	if (iaa_crypto_registered)
+	if (iaa_mode_registered[IAA_MODE_FIXED])
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
-
-	return 0;
 }
 
 static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
@@ -2272,6 +2414,12 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 			goto err_register;
 		}
 
+		ret = iaa_register_acomp_compression_device();
+		if (ret != 0) {
+			dev_dbg(dev, "IAA compression device acomp registration failed\n");
+			goto err_register;
+		}
+
 		if (!rebalance_wq_table()) {
 			dev_dbg(dev, "%s: Rerun after registration: IAA rebalancing device wq tables failed\n", __func__);
 			goto err_register;
@@ -2348,6 +2496,8 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 		pkg_global_wqs_dealloc();
 		free_wq_tables();
 		WARN_ON(!list_empty(&iaa_devices));
+		iaa_unregister_acomp_compression_device();
+		iaa_unregister_compression_device();
 		INIT_LIST_HEAD(&iaa_devices);
 		module_put(THIS_MODULE);
 
@@ -2389,6 +2539,13 @@ static int __init iaa_crypto_init_module(void)
 	nr_cpus_per_package = topology_num_cores_per_package();
 	nr_packages = topology_max_packages();
 
+	/* Software fallback compressor */
+	deflate_crypto_acomp = crypto_alloc_acomp("deflate", 0, 0);
+	if (IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		ret = -ENODEV;
+		goto err_deflate_acomp;
+	}
+
 	ret = iaa_aecs_init_fixed();
 	if (ret < 0) {
 		pr_debug("IAA fixed compression mode init failed\n");
@@ -2460,14 +2617,19 @@ static int __init iaa_crypto_init_module(void)
 err_driver_reg:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
+err_deflate_acomp:
 
 	goto out;
 }
 
 static void __exit iaa_crypto_cleanup_module(void)
 {
-	if (iaa_unregister_compression_device())
-		pr_debug("IAA compression device unregister failed\n");
+	iaa_unregister_acomp_compression_device();
+	iaa_unregister_compression_device();
 
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
@@ -2483,6 +2645,11 @@ static void __exit iaa_crypto_cleanup_module(void)
 	idxd_driver_unregister(&iaa_crypto_driver);
 	iaa_aecs_cleanup_fixed();
 
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
+
 	pr_debug("cleaned up\n");
 }
 
-- 
2.27.0

