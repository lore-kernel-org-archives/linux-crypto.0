Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795118411;
	b=TK/GLd0SZottl2+P933grnc+nuU9wKXGhofRZO9m+2sBnHf42uRkwdy2ODLfOME9bqA6
	 9QzZ5kXWbHGjPWNU7NLdh/+jXQ4iYrj7WJy5OcJmBAGfM13oIqMtonoocUKhcBNP07hw3
	 M8g8mhYEZd5Now6Em0jam7kn+6xWxqQxhDo6lVSxgmvDHpeeJ1aMmi58DIsQIimzMKAOc
	 HIeXorHQiDa6b05xw1EJ+UubBfXUISxtaXwVv8NarVKNb6XrKbgp2HA18UGPbqJ2oPzLu
	 OCdEzN0aG72ekBhZHlMqoClZ+qGN50yymI9oRbYaEPSqypatdhgldle1KFWlewWTiDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118411;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=u3T49TBcuW+GWQFGmUjcIxddkpdG8L2Kbk0SKYBY3ZI=;
	b=GLtrX1bffpbxFokGPp2FoD4LIWgjYz4a+nKHUkX1Av+6KOOv9ZZcLnkWsDvAn625BrBC
	 Hq5GV+IMZM5WUgCssMwaaSWwm1uxwqN6C8foVzUZXnYXZd4EzO+KSj2gxZ2krHhU4avDl
	 Nkkpjr5A1d+m7hIb/oiNOTwRpF7Q3regArawV4nLPySsDIeZPGSe6R60uoZC4d/Z4Ga/4
	 vXZ+bHSfiepAsizFZQj+c9n/1F4ZnamG098UE4GEsXWkpScAnsqM8T0ye7DUeqsIUXqVT
	 /x/tywYHIyXOiKNI7Opks+AucjFvRJ6Gm/nGxiblYqKHgwL4VpptaITmraCB717JznQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jogMBtKA;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C249606A339;
	Thu, 19 Nov 2026 20:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C249606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jogMBtKA
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.177.6.190])
	by linux.microsoft.com (Postfix) with ESMTPSA id BC65D20B7169;
	Thu, 19 Nov 2026 12:00:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC65D20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795118407;
	bh=u3T49TBcuW+GWQFGmUjcIxddkpdG8L2Kbk0SKYBY3ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jogMBtKAAFGGwzKgpwxKh1AFo4QOD9D8p1pKBU63ojuzNcRS5tG1CY4umIV+8Ve9G
	 AFCpBO0PLvrOk1KDQ7QnK7Fn+ux6DluQUWLDj+e0xT0h5eXNIBTAiU+zFoKEzAVAtC
	 3BbUER/ReP//r+vRKA4hNu6rjkYbzOXABNLKz1PM=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	meenakshi.aggarwal@nxp.com,
	tudor-dan.ambarus@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: caam - fix in-place RSA payload DMA mapping
Date: Thu, 19 Nov 2026 14:59:48 -0500
Message-ID: <20261119195948.816661-3-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119195948.816661-1-jeffbarnes@linux.microsoft.com>
References: <20261119195948.816661-1-jeffbarnes@linux.microsoft.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CAAM maps the effective RSA source DMA_TO_DEVICE and the destination
DMA_FROM_DEVICE independently. When both use the same scatterlist,
the second mapping can overwrite the DMA metadata needed to release
the first. On an arm64 system with CAAM behind an SMMU this caused
ARM-LPAE/IOMMU unmap warnings and RSA signature self-test failures.

For an aligned exact effective-head alias, map the entries covering the
larger source/destination extent once with DMA_BIDIRECTIONAL. If this
returns a single DMA segment, retain that mapping and release it once
with the original entry count on completion or allocation failure.

If the shared mapping returns multiple DMA segments, release it before
mapping either hardware view independently. Use the existing destination
bounce buffer, mapping the source DMA_TO_DEVICE and the distinct bounce
buffer DMA_FROM_DEVICE. This avoids separate bounded SEC4 views without
rejecting requests that previously worked on dma-direct systems.

Detect the original req->src == req->dst relationship before stripping
leading zeros. If stripping advances the effective source, force the
destination bounce path even though the effective heads differ. This
avoids overlapping streaming mappings through different SG metadata.
Arbitrary overlapping buffers described by otherwise distinct original
and effective SG heads are outside the scope of this fix.

Reuse the fixup_dst and bounce-buffer lifetime handling from Changwei's
unaligned-destination fix. In particular, unmap the payload before
copy-back, copy only the RSA output on successful completion, and retain
the bounce buffer across job-ring retries and accepted backlog requests.
Non-aliased requests retain their existing mapping directions.

Unlike the RFC, multi-segment aliases no longer return -EOPNOTSUPP.

Fixes: 8c419778ab57 ("crypto: caam - add support for RSA algorithm")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-crypto/20261114060032.872141-1-changwei.zou@canonical.com/
Link: https://lore.kernel.org/linux-crypto/20261020192511.3389133-1-jeffbarnes@linux.microsoft.com/
Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
---
 drivers/crypto/caam/caampkc.c | 84 ++++++++++++++++++++++++++---------
 drivers/crypto/caam/caampkc.h |  3 ++
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index d81ef97861c0c..bffd499164436 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -51,8 +51,15 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 {
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 
-	dma_unmap_sg(dev, req_ctx->fixup_dst, edesc->dst_nents, DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req_ctx->fixup_src, edesc->src_nents, DMA_TO_DEVICE);
+	if (edesc->shared_nents) {
+		dma_unmap_sg(dev, req_ctx->fixup_src, edesc->shared_nents,
+			     DMA_BIDIRECTIONAL);
+	} else {
+		dma_unmap_sg(dev, req_ctx->fixup_dst, edesc->dst_nents,
+			     DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req_ctx->fixup_src, edesc->src_nents,
+			     DMA_TO_DEVICE);
+	}
 
 	if (edesc->sec4_sg_bytes)
 		dma_unmap_single(dev, edesc->sec4_sg_dma, edesc->sec4_sg_bytes,
@@ -330,14 +337,18 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct caam_rsa_key *key = &ctx->key;
 	struct rsa_edesc *edesc;
+	struct scatterlist *sg;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int sg_flags = (flags == GFP_ATOMIC) ? SG_MITER_ATOMIC : 0;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	int src_nents, dst_nents;
+	int shared_nents = 0;
 	int mapped_src_nents, mapped_dst_nents;
 	unsigned int diff_size = 0;
-	int lzeros;
+	bool in_place = req->src == req->dst;
+	bool bounce;
+	int lzeros, i;
 
 	if (req->src_len > key->n_sz) {
 		/*
@@ -373,26 +384,48 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 
 	req_ctx->bounce_buf = NULL;
 	req_ctx->fixup_dst = req->dst;
-	if (req->dst_len > 0) {
-		struct scatterlist *sg;
-		int i;
-
-		for_each_sg(req->dst, sg, dst_nents, i) {
-			if (!sg_is_dma_aligned(sg)) {
-				unsigned int bounce_len =
-					ALIGN(req->dst_len,
-					      dma_get_cache_alignment());
-
-				req_ctx->bounce_buf = kzalloc(bounce_len, flags);
-				if (!req_ctx->bounce_buf)
-					return ERR_PTR(-ENOMEM);
-				sg_init_one(&req_ctx->dst, req_ctx->bounce_buf,
-					    bounce_len);
-				req_ctx->fixup_dst = &req_ctx->dst;
-				dst_nents = 1;
-				break;
-			}
+	bounce = in_place && req_ctx->fixup_src != req->src;
+	for_each_sg(req->dst, sg, dst_nents, i) {
+		if (!sg_is_dma_aligned(sg)) {
+			bounce = true;
+			break;
+		}
+	}
+
+	if (!bounce && req_ctx->fixup_src == req_ctx->fixup_dst) {
+		shared_nents = max(src_nents, dst_nents);
+		mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src,
+					      shared_nents, DMA_BIDIRECTIONAL);
+		if (unlikely(!mapped_src_nents)) {
+			dev_err(dev, "unable to map shared S/G\n");
+			goto bounce_fail;
+		}
+
+		if (mapped_src_nents == 1) {
+			mapped_dst_nents = mapped_src_nents;
+			goto alloc_edesc;
 		}
+
+		/*
+		 * Distinct DMA segments need independently bounded hardware
+		 * views. Bounce the destination instead of sharing SEC4 tables.
+		 */
+		dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
+			     DMA_BIDIRECTIONAL);
+		shared_nents = 0;
+		bounce = true;
+	}
+
+	if (bounce) {
+		unsigned int bounce_len = ALIGN(req->dst_len,
+						dma_get_cache_alignment());
+
+		req_ctx->bounce_buf = kzalloc(bounce_len, flags);
+		if (!req_ctx->bounce_buf)
+			goto bounce_fail;
+		sg_init_one(&req_ctx->dst, req_ctx->bounce_buf, bounce_len);
+		req_ctx->fixup_dst = &req_ctx->dst;
+		dst_nents = 1;
 	}
 
 	mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src, src_nents,
@@ -408,6 +441,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 		goto src_fail;
 	}
 
+alloc_edesc:
 	if (!diff_size && mapped_src_nents == 1)
 		sec4_sg_len = 0; /* no need for an input hw s/g table */
 	else
@@ -442,6 +476,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	/* Save nents for later use in Job Descriptor */
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->shared_nents = shared_nents;
 
 	req_ctx->edesc = edesc;
 
@@ -469,6 +504,11 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 sec4_sg_fail:
 	kfree(edesc);
 dst_fail:
+	if (shared_nents) {
+		dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
+			     DMA_BIDIRECTIONAL);
+		goto bounce_fail;
+	}
 	dma_unmap_sg(dev, req_ctx->fixup_dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index 8810bcc435ccd..5ec93d8973347 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -126,6 +126,8 @@ struct caam_rsa_req_ctx {
  * rsa_edesc - s/w-extended rsa descriptor
  * @src_nents     : number of segments in input s/w scatterlist
  * @dst_nents     : number of segments in output s/w scatterlist
+ * @shared_nents  : original shared DMA_BIDIRECTIONAL map/unmap count,
+ *                 or zero for independent source and destination mappings
  * @mapped_src_nents: number of segments in input h/w link table
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes : length of h/w link table
@@ -138,6 +140,7 @@ struct caam_rsa_req_ctx {
 struct rsa_edesc {
 	int src_nents;
 	int dst_nents;
+	int shared_nents;
 	int mapped_src_nents;
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
-- 
2.43.0

