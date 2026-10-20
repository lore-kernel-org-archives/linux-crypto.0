Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792524331;
	b=kPCQsaU+LB1CWkbHnsm291FSx0YEXS8phdlsZEiP4as8i17+eadRgGT4wtrEhXbKyfMo
	 XHSShaBawko0/2H77KaSBvjBnQP00ds7ZF92L3/Xggp/QN4n9wZyLib966beyIuB5jZay
	 5bIRkZnCLxPVb9r6oTrT0y+D697RG+hAs355KcC0DKCjO2Lt3kPnY+7evgR0i3STPL4Ze
	 NBbGjw66tWvoEUnHl8x9P6GKIKPguxI2afIWLAZcXU5M9CHaufuDqVh+zUdT3I/NUqiNP
	 1Lh/7OCAQtfAU60Rs18FA5X4Fn+v0VBBbNaDrchfpQs2dBKw8e01JD7BeouMIM1/YHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792524331;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=mE/XSTsJsvB51KFu2rkBY8nKiAK9Jv2zTq/DgWy68zo=;
	b=yGxpZXQHiHvEBNUtvTosSpj1q/U9Qc/AIn1hUZtuqJwp23p1nAx6llcNQnse8xugKT7f
	 Q5abID00ypBeJv/AnYKByVXCOAfkMdUv8sziukBZlCaN2G65Dl0fqm+7x5OT8JmMZmeCA
	 57TPh4XDWNbdfWUCZnvdNavv1cQxn5VTlQ2/r4xyJfJds/adAm528zKwhEpQB5NQjAa+9
	 dOpAt1O6w1hJOTUyuDosh27OX9LPFckQlHLlxjKcBqV/OBNk/KV5wHvXGWScUb8d4/bJt
	 3FRU8b5p9o4lhgdSFhBbhfsya1eHERzlBJ79NCe5hL0f1JwzoudKxNV6QtKY0te7GaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=n3mTuePx;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1EC606A32D;
	Tue, 20 Oct 2026 19:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D1EC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=n3mTuePx
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.lan (unknown [52.177.6.131])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1422820B7168;
	Tue, 20 Oct 2026 12:25:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1422820B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792524318;
	bh=mE/XSTsJsvB51KFu2rkBY8nKiAK9Jv2zTq/DgWy68zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3mTuePx2o8FPnaXJRuS4KTk51fSoZX8uNlJan0Qzks1j7UKiSSMnziTJasGraNsT
	 yAM9+uZ/YSUyOnHijZEhYJD/4Hwmd6MuOzDaXooVug4ydSkKY2wVzodZk4BjkBhbih
	 yCGDTseQUBNsR8Z7PmDazVqfjFmjbChk8eDPfIBk=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Tue, 20 Oct 2026 15:25:11 -0400
Message-ID: <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
References: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
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

CAAM can receive RSA requests whose effective source and destination
scatterlists are identical. The driver currently maps the source with
DMA_TO_DEVICE and then maps the destination with DMA_FROM_DEVICE.

When both refer to the same scatterlist, the second dma_map_sg() can
overwrite the DMA metadata stored in the scatterlist by the first mapping.
On an IOMMU-backed non-coherent arm64 system, the two mappings can return
different DMA addresses. Completion then unmaps the destination mapping and
subsequently uses the overwritten scatterlist metadata while attempting to
unmap the source.

As a result, the destination mapping can be unmapped a second time while
the original source mapping is no longer represented by the scatterlist DMA
metadata.

This was observed during CAAM RSA crypto self-tests. One visible failure
was:

  alg: sig: sign test failed: invalid output
  alg: sig: test 1 failed for pkcs1(rsa-caam,sha256): err -22

The failures were accompanied by ARM-LPAE/IOMMU unmap warnings through
dma_unmap_sg_attrs(), originating from the CAAM RSA completion paths. The
warnings were observed through both rsa_pub_done() and rsa_priv_f_done().

Fix the DMA ownership problem by mapping an exact effective-head alias only
once using DMA_BIDIRECTIONAL, since CAAM both reads from and writes to the
shared payload. Retain the original scatterlist entry count passed to
dma_map_sg() and use that same count for the matching dma_unmap_sg().

Keep the existing DMA_TO_DEVICE and DMA_FROM_DEVICE ownership for requests
whose effective source and destination heads differ.

The source and destination can cover different logical byte extents of the
same scatterlist. For a shared mapping, therefore map the number of
original SG entries needed to cover the larger of the effective source
length and destination length.

A shared mapping for which dma_map_sg() returns one DMA segment can
continue using the existing direct hardware views. If the shared mapping
returns more than one DMA segment, however, the source and destination
require separately bounded SEC4 views.

The current SEC4/PDB bookkeeping cannot correctly represent every such
multi-segment request. In particular, for a short source the reserved
source view and the actual destination-table position can differ from the
offset reconstructed later by the PDB setup. Using the shared returned
segment count for source-table selection can also select a padding-
prefixed source view whose representation does not match the original
logical source length.

For this RFC, release a shared mapping that returns multiple DMA segments
and return -EOPNOTSUPP before allocating the extended descriptor,
constructing the SEC4/PDB representation, or submitting a job to CAAM. This
prevents a known-invalid representation from reaching hardware while
leaving the general multi-segment representation for further discussion.

The ownership fix was validated on an LX2160A arm64 system with CAAM Era 10
and an ARM SMMU. The existing single-segment exact-alias paths passed the
rsa-caam and pkcs1(rsa-caam,sha256) self-tests, including certificate
verification, with no recurrence of the ARM-LPAE/IOMMU unmap warnings.

The RFC containment path was also exercised directly on the same hardware.
A full-width 2048-bit RSA request used the same two-entry scatterlist as
both source and destination, with two separately allocated 128-byte
entries. The shared DMA mapping returned multiple DMA segments and reached
the containment path.

The RSA operation returned -EOPNOTSUPP synchronously before CAAM
submission, with no completion callback. The test unloaded cleanly, and no
ARM-LPAE, IOMMU/DMA API, CAAM descriptor, invalid-output, WARN, Oops, or
panic message was observed during the test interval.

The runtime test establishes that the multi-segment containment path was
reached and returned synchronously without submitting the RSA operation.
The single matching dma_unmap_sg() of that mapping follows from the
reviewed control flow; the test did not independently instrument or count
DMA unmap calls.

Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
---
 drivers/crypto/caam/caampkc.c | 79 +++++++++++++++++++++++++++++------
 drivers/crypto/caam/caampkc.h |  3 ++
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..fed20a401712 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -51,8 +51,14 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 {
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 
-	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req_ctx->fixup_src, edesc->src_nents, DMA_TO_DEVICE);
+	if (edesc->shared_nents) {
+		dma_unmap_sg(dev, req_ctx->fixup_src, edesc->shared_nents,
+			     DMA_BIDIRECTIONAL);
+	} else {
+		dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req_ctx->fixup_src, edesc->src_nents,
+			     DMA_TO_DEVICE);
+	}
 
 	if (edesc->sec4_sg_bytes)
 		dma_unmap_single(dev, edesc->sec4_sg_dma, edesc->sec4_sg_bytes,
@@ -260,6 +266,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	int sg_flags = (flags == GFP_ATOMIC) ? SG_MITER_ATOMIC : 0;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	int src_nents, dst_nents;
+	int shared_nents = 0;
 	int mapped_src_nents, mapped_dst_nents;
 	unsigned int diff_size = 0;
 	int lzeros;
@@ -289,19 +296,59 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 
 	src_nents = sg_nents_for_len(req_ctx->fixup_src,
 				     req_ctx->fixup_src_len);
-	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
+	if (unlikely(src_nents < 0)) {
+		dev_err(dev, "Insufficient bytes (%u) in src S/G\n",
+			req_ctx->fixup_src_len);
+		return ERR_PTR(src_nents);
+	}
 
-	mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src, src_nents,
-				      DMA_TO_DEVICE);
-	if (unlikely(!mapped_src_nents)) {
-		dev_err(dev, "unable to map source\n");
-		return ERR_PTR(-ENOMEM);
+	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
+	if (unlikely(dst_nents < 0)) {
+		dev_err(dev, "Insufficient bytes (%u) in dst S/G\n",
+			req->dst_len);
+		return ERR_PTR(dst_nents);
 	}
-	mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
-				      DMA_FROM_DEVICE);
-	if (unlikely(!mapped_dst_nents)) {
-		dev_err(dev, "unable to map destination\n");
-		goto src_fail;
+
+	if (req_ctx->fixup_src == req->dst) {
+		shared_nents = sg_nents_for_len(req_ctx->fixup_src,
+						max(req_ctx->fixup_src_len,
+						    req->dst_len));
+		if (unlikely(shared_nents < 0)) {
+			dev_err(dev, "Invalid shared S/G extent\n");
+			return ERR_PTR(shared_nents);
+		}
+
+		mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src,
+					      shared_nents, DMA_BIDIRECTIONAL);
+		if (unlikely(!mapped_src_nents)) {
+			dev_err(dev, "unable to map shared S/G\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		if (mapped_src_nents > 1) {
+			/*
+			 * Multi-segment aliases need separately bounded source
+			 * and destination hardware views. The current SEC4/PDB
+			 * layout cannot represent all such requests; defer support.
+			 */
+			dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
+				     DMA_BIDIRECTIONAL);
+			dev_err(dev, "Multi-segment shared S/G is not supported\n");
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+		mapped_dst_nents = mapped_src_nents;
+	} else {
+		mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src, src_nents,
+					      DMA_TO_DEVICE);
+		if (unlikely(!mapped_src_nents)) {
+			dev_err(dev, "unable to map source\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
+					      DMA_FROM_DEVICE);
+		if (unlikely(!mapped_dst_nents)) {
+			dev_err(dev, "unable to map destination\n");
+			goto src_fail;
+		}
 	}
 
 	if (!diff_size && mapped_src_nents == 1)
@@ -338,6 +385,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	/* Save nents for later use in Job Descriptor */
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->shared_nents = shared_nents;
 
 	req_ctx->edesc = edesc;
 
@@ -365,6 +413,11 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 sec4_sg_fail:
 	kfree(edesc);
 dst_fail:
+	if (shared_nents) {
+		dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
+			     DMA_BIDIRECTIONAL);
+		return ERR_PTR(-ENOMEM);
+	}
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index 96d03704c9be..09b6aa5cee98 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -119,6 +119,8 @@ struct caam_rsa_req_ctx {
  * rsa_edesc - s/w-extended rsa descriptor
  * @src_nents     : number of segments in input s/w scatterlist
  * @dst_nents     : number of segments in output s/w scatterlist
+ * @shared_nents  : original count of a successful shared BIDIRECTIONAL mapping;
+ *                 zero for independent source and destination mappings
  * @mapped_src_nents: number of segments in input h/w link table
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes : length of h/w link table
@@ -131,6 +133,7 @@ struct caam_rsa_req_ctx {
 struct rsa_edesc {
 	int src_nents;
 	int dst_nents;
+	int shared_nents;
 	int mapped_src_nents;
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
-- 
2.43.0

