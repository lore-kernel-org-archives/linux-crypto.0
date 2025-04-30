Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691DA2D0ABF;
	Wed, 30 Apr 2025 20:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046397; cv=none; b=Gn3mVtkJN79vFV2r3AEbon/To8YpgAxaMTcpWo2YFfN1GRGIjYfNAHNX4urkd174HzgL9v/wGNmYf3p+F4wP7cgFLkqPIVF48iD8JfVLUYGPPZTDL6OFjFamUp9EgdgXv0oUyjIUV7flqg1LjXXCJhT5SGUa+OeroZH+dBd3jIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046397; c=relaxed/simple;
	bh=ZmGjviUpJ+c+Is95YFL01k3D2zJB4AA9yt94lFpXChk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G/g0mvb8TeX2J0cqACGzu2Zh4g8iWvFnACGvPgW0IHgUtumc/06iyvsOXECK0t6p7/bioNJFvD6etngcJqHgTHz/xxJIMsoaT+HH8497aaG5XC36X3QeRlR1U9iabp4/IQYYjkxk47LUtunlsJ+NQ5h79ozE66nS1q731KDYKgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVZqyck6; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVZqyck6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046396; x=1777582396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZmGjviUpJ+c+Is95YFL01k3D2zJB4AA9yt94lFpXChk=;
  b=FVZqyck61gZrjpNvcriGyDXUOwVPjPAYT/IQpFU1Q/3Xp+SAO7bSRV39
   dytOcmDbfDQdai91JxP9AWISuYVt6Tb+b8s/p5l9Js/bKfE7j2tYvrpoL
   6IfsXWisSpjNruII9oRXTsXytomt1utFvDDi2p5zErl2L75ZtF30VX7ec
   X9lZUf1VBDQ9X4zthaoml9Bq8DYVK2e1IkXRBpnBH9oimNtDHGFjF00kp
   hDgXw76YP8w7nElEM4ICGENOrk3jJhwEdX36cwmCsozGkOdpWXO/TDCsy
   1jfccKRYOJyj1mcI943MOZUK0229DRy1IayqeFsJXopmZKmohxVVgfI+7
   g==;
X-CSE-ConnectionGUID: GsjnCkdUTRu59NuVN7L2zQ==
X-CSE-MsgGUID: BsnQYkbNS426u3XJWPounQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388600"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388600"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:15 -0700
X-CSE-ConnectionGUID: WuvCvmlHRBWlt04qC1yzXw==
X-CSE-MsgGUID: qe7sYLJxThKdFJCF6h2u1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248912"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:13 -0700
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
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v9 09/19] crypto: iaa - CRYPTO_ACOMP_REQ_POLL acomp_req flag for sequential vs. parallel.
Date: Wed, 30 Apr 2025 13:52:55 -0700
Message-Id: <20250430205305.22844-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The purpose of this commit is to allow kernel users of iaa_crypto, such
as zswap, to be able to invoke the crypto_acomp_compress() API in fully
synchronous mode for non-batching use cases (i.e. today's status-quo),
where zswap calls crypto_wait_req(crypto_acomp_compress(req), wait);
and to non-instrusively invoke the fully asynchronous batch
compress/decompress API that will be introduced in subsequent
patches. Both use cases need to reuse same code paths in the driver to
interface with hardware: the CRYPTO_ACOMP_REQ_POLL flag allows this
shared code to determine whether we need to process an acomp_req
synchronously/asynchronously. The idea is to simplify the crypto_acomp
sequential/batching interfaces for use by zswap.

Thus, regardless of the iaa_crypto driver's 'sync_mode' setting, it
can still be forced to use synchronous mode by turning
off the CRYPTO_ACOMP_REQ_POLL flag in req->base.flags (the default to
support sequential use cases in zswap today).

IAA batching functionality will be implemented in subsequent patches,
that will set the CRYPTO_ACOMP_REQ_POLL flag for the acomp_reqs in a
batch. This enables the iaa_crypto driver to implement true
async "submit-polling" for parallel compressions and decompressions in
the IAA hardware accelerator.

In other words, all three of the following need to be true for a request
to be processed in fully async submit-poll mode:

 1) async_mode should be "true"
 2) use_irq should be "false"
 3) req->base.flags & CRYPTO_ACOMP_REQ_POLL should be "true"

Subsequent patches will:
  - Set (1) and (2) as iaa_crypto defaults once async submit-poll is
    implemented.
  - Enable (3) for iaa_crypto batching, and clear the
    CRYPTO_ACOMP_REQ_POLL flags before exiting from the batching
    routines since the assumption is that the acomp_reqs are
    created/managed by a higher level kernel user such as zswap, and are
    reused for both, sequential and batching use cases from zswap's
    perspective.

This patch also removes "disable_async" from iaa_decompress().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 15 +++++++--------
 include/crypto/acompress.h                 |  6 ++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7dab340c4a34..52fe68606f4d 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1785,7 +1785,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode) {
+	} else if (ctx->async_mode && (req->base.flags & CRYPTO_ACOMP_REQ_POLL)) {
 		req->data = idxd_desc;
 	}
 
@@ -1807,7 +1807,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	update_total_comp_calls();
 	update_wq_comp_calls(wq);
 
-	if (ctx->async_mode) {
+	if (ctx->async_mode && (req->base.flags & CRYPTO_ACOMP_REQ_POLL)) {
 		ret = -EINPROGRESS;
 		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
@@ -1836,8 +1836,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
-			  dma_addr_t dst_addr, unsigned int *dlen,
-			  bool disable_async)
+			  dma_addr_t dst_addr, unsigned int *dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1886,7 +1885,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq && !disable_async) {
+	if (ctx->use_irq) {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1899,7 +1898,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async) {
+	} else if (ctx->async_mode && (req->base.flags & CRYPTO_ACOMP_REQ_POLL)) {
 		req->data = idxd_desc;
 	}
 
@@ -1921,7 +1920,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	update_total_decomp_calls();
 	update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode && !disable_async) {
+	if (ctx->async_mode && (req->base.flags & CRYPTO_ACOMP_REQ_POLL)) {
 		ret = -EINPROGRESS;
 		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
@@ -2127,7 +2126,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen, false);
+			     dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 01389fd7055f..939e51d122b0 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -20,6 +20,12 @@
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 
+/*
+ * If set, the driver must have a way to submit the req, then
+ * poll its completion status for success/error.
+ */
+#define CRYPTO_ACOMP_REQ_POLL		0x00000001
+
 /* Set this bit if source is virtual address instead of SG list. */
 #define CRYPTO_ACOMP_REQ_SRC_VIRT	0x00000002
 
-- 
2.27.0

