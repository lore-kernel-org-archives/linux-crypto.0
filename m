Received: from mout-b-110.mailbox.org (mout-b-110.mailbox.org [195.10.208.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704F4A0F00;
	Tue, 15 Sep 2026 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472472; cv=none; b=oPKYi9zN88o1cuEp7IM8ytMccI6z7eO0dnqnDxLKIgXj5EjHnHGokHYt0+4xrWnrOx0YoJ1FJP1lRbR7ThN9oHqHXWSDxHLShCgIKagE+FzRptjce/zyXF74I76yT7V/MKwiyj8P6Rbwc5v0VvVZcTJ9peiygWf4qHy/6k9RtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472472; c=relaxed/simple;
	bh=Bpvd6uLkwQt0bg8JMOOK6CDGUxiAzVEi0ZvIeC5pHUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2t4n+MvqNLNqVLqkguVctUU3YNj8BsQ6kmibFR54t/WBqJjKV0RQSoR4OjJDRkIEnSdC3oLHlrchRP77CImJ2zOb49jcgMW7OQegDmLOfGyZ9TmECafg24Zshmt2yDtoVxwR2KLHvtFcugIz43potG07N22nZLgblBMnIFsNsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=v0cj60Xn; arc=none smtp.client-ip=195.10.208.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="v0cj60Xn"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-110.mailbox.org (Postfix) with ESMTPS id 4hkfy107MTzNlkW;
	Tue, 15 Sep 2026 13:32:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1789471945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWnkgdjy99kFHMs6Cwom6LtVrygjipYl+5iKxQcvIiQ=;
	b=v0cj60XnR/Cbe5mWN+4uWVQPPqb0b4j2hmLJQMwPyRlm6ObEyqyxHpGZnmAc7929ug1D0N
	ddfC2AypHRFfmXp4lj6DW7KnSe8ez4BnsndUQQuaqXhh3IeorlpeuD+Y7zVHHSK7K/C2I8
	yKg29Mzj9PZa86GUXEoodpis4ZmEDxSg7euzUguDhLLKXxztOBK+AOxlLSJLWZvADrIb2q
	yX2nryur0GVZj/zA17B7e4U/R1NTNgtv6r3AciuvGzZ9jZulWpPbbVi2xrZHlaiTE7Tux0
	SrNn1KV44YlLk/zCC5pDe5/SODiU0M8qa0m/v9jM616ZSO29UWDoP5q0+5vRKQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: linux-crypto@vger.kernel.org
Cc: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Tue, 15 Sep 2026 13:32:12 +0200
Message-ID: <7bd0c89dd32e9712d7d08393842498698148064b.1789469436.git.ralf@mandelbit.com>
In-Reply-To: <cover.1789469436.git.ralf@mandelbit.com>
References: <cover.1789469436.git.ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4hkfy107MTzNlkW

Safexcel maps every entry of an in-place AEAD request with
DMA_BIDIRECTIONAL and every entry of an out-of-place destination with
DMA_FROM_DEVICE. These directions are too broad: associated data is never
written, and an authentication tag is input-only during decryption.

On a non-coherent system, unmapping a small input-only entry as device
output can copy stale data back over valid accelerator output in a
neighboring part of the same cache line. The request still completes
successfully but its plaintext or ciphertext is corrupted afterwards.

Map AEAD entries separately according to their overlap with the logical
output range. Use DMA_TO_DEVICE for input-only entries, DMA_FROM_DEVICE for
pure out-of-place output entries, and DMA_BIDIRECTIONAL where an entry
contains both kinds of data or is updated in place.

This was validated on an MT7986 EIP97 with in-place and fragmented
out-of-place AES-GCM requests, for encryption and decryption, at queue
depths up to 400.

Fixes: f6beaea30487 ("crypto: inside-secure - authenc(hmac(sha256), cbc(aes)) support")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 149 ++++++++++++++++--
 1 file changed, 133 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 4982c64bf236..491fcd97ebdb 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -73,6 +73,8 @@ struct safexcel_cipher_req {
 	unsigned int rdescs;
 	bool needs_inv;
 	int  nr_src, nr_dst;
+	unsigned int output_offset;
+	unsigned int output_len;
 };
 
 static int safexcel_skcipher_iv(struct safexcel_cipher_ctx *ctx, u8 *iv,
@@ -608,6 +610,71 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	return 0;
 }
 
+/* classify each scatterlist entry by its overlap with the logical output */
+static enum dma_data_direction safexcel_aead_dma_dir(unsigned int offset,
+						     unsigned int len,
+						     unsigned int output_offset,
+						     unsigned int output_len,
+						     bool inplace)
+{
+	unsigned int end = offset + len;
+	unsigned int output_end = output_offset + output_len;
+
+	if (!output_len || offset >= output_end || output_offset >= end)
+		return DMA_TO_DEVICE;
+
+	if (inplace || offset < output_offset || end > output_end)
+		return DMA_BIDIRECTIONAL;
+
+	return DMA_FROM_DEVICE;
+}
+
+static void safexcel_unmap_aead(struct device *dev, struct scatterlist *sgl,
+				int nents, unsigned int output_offset,
+				unsigned int output_len, bool inplace)
+{
+	struct scatterlist *sg;
+	unsigned int offset = 0;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i) {
+		enum dma_data_direction dir;
+
+		dir = safexcel_aead_dma_dir(offset, sg->length, output_offset,
+					    output_len, inplace);
+		dma_unmap_page(dev, sg_dma_address(sg), sg_dma_len(sg), dir);
+		offset += sg->length;
+	}
+}
+
+static int safexcel_map_aead(struct device *dev, struct scatterlist *sgl,
+			     int nents, unsigned int output_offset,
+			     unsigned int output_len, bool inplace)
+{
+	struct scatterlist *sg;
+	unsigned int offset = 0;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i) {
+		enum dma_data_direction dir;
+
+		dir = safexcel_aead_dma_dir(offset, sg->length, output_offset,
+					    output_len, inplace);
+		sg_dma_address(sg) = dma_map_page(dev, sg_page(sg), sg->offset,
+						  sg->length, dir);
+		if (dma_mapping_error(dev, sg_dma_address(sg)))
+			goto err_unmap;
+		sg_dma_len(sg) = sg->length;
+		offset += sg->length;
+	}
+
+	return nents;
+
+err_unmap:
+	safexcel_unmap_aead(dev, sgl, i, output_offset, output_len, inplace);
+	return 0;
+}
+
 static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int ring,
 				      struct crypto_async_request *async,
 				      struct scatterlist *src,
@@ -645,16 +712,30 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 
 	if (src == dst) {
-		if (sreq->nr_src > 0)
-			dma_unmap_sg(priv->dev, src, sreq->nr_src,
-				     DMA_BIDIRECTIONAL);
+		if (sreq->nr_src > 0) {
+			if (ctx->aead)
+				safexcel_unmap_aead(priv->dev, src,
+						    sreq->nr_src,
+						    sreq->output_offset,
+						    sreq->output_len, true);
+			else
+				dma_unmap_sg(priv->dev, src, sreq->nr_src,
+					     DMA_BIDIRECTIONAL);
+		}
 	} else {
 		if (sreq->nr_src > 0)
 			dma_unmap_sg(priv->dev, src, sreq->nr_src,
 				     DMA_TO_DEVICE);
-		if (sreq->nr_dst > 0)
-			dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
-				     DMA_FROM_DEVICE);
+		if (sreq->nr_dst > 0) {
+			if (ctx->aead)
+				safexcel_unmap_aead(priv->dev, dst,
+						    sreq->nr_dst,
+						    sreq->output_offset,
+						    sreq->output_len, false);
+			else
+				dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+					     DMA_FROM_DEVICE);
+		}
 	}
 
 	/*
@@ -737,6 +818,10 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	 */
 	totlen = totlen_src;
 	queued = totlen_src;
+	if (ctx->aead) {
+		sreq->output_offset = assoclen;
+		sreq->output_len = totlen_dst - assoclen;
+	}
 
 	if (src == dst) {
 		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
@@ -748,8 +833,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			return -EINVAL;
 		}
 		if (sreq->nr_src > 0) {
-			src_mapped = dma_map_sg(priv->dev, src, sreq->nr_src,
-						DMA_BIDIRECTIONAL);
+			if (ctx->aead)
+				src_mapped =
+					safexcel_map_aead(priv->dev, src,
+							  sreq->nr_src,
+							  sreq->output_offset,
+							  sreq->output_len,
+							  true);
+			else
+				src_mapped = dma_map_sg(priv->dev, src,
+							sreq->nr_src,
+							DMA_BIDIRECTIONAL);
 			if (!src_mapped)
 				return -EIO;
 		}
@@ -775,8 +869,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		}
 
 		if (sreq->nr_dst > 0) {
-			dst_mapped = dma_map_sg(priv->dev, dst, sreq->nr_dst,
-						DMA_FROM_DEVICE);
+			if (ctx->aead)
+				dst_mapped =
+					safexcel_map_aead(priv->dev, dst,
+							  sreq->nr_dst,
+							  sreq->output_offset,
+							  sreq->output_len,
+							  false);
+			else
+				dst_mapped = dma_map_sg(priv->dev, dst,
+							sreq->nr_dst,
+							DMA_FROM_DEVICE);
 			if (!dst_mapped) {
 				ret = -EIO;
 				goto unmap;
@@ -913,16 +1016,30 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
 unmap:
 	if (src == dst) {
-		if (src_mapped)
-			dma_unmap_sg(priv->dev, src, sreq->nr_src,
-				     DMA_BIDIRECTIONAL);
+		if (src_mapped) {
+			if (ctx->aead)
+				safexcel_unmap_aead(priv->dev, src,
+						    sreq->nr_src,
+						    sreq->output_offset,
+						    sreq->output_len, true);
+			else
+				dma_unmap_sg(priv->dev, src, sreq->nr_src,
+					     DMA_BIDIRECTIONAL);
+		}
 	} else {
 		if (src_mapped)
 			dma_unmap_sg(priv->dev, src, sreq->nr_src,
 				     DMA_TO_DEVICE);
-		if (dst_mapped)
-			dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
-				     DMA_FROM_DEVICE);
+		if (dst_mapped) {
+			if (ctx->aead)
+				safexcel_unmap_aead(priv->dev, dst,
+						    sreq->nr_dst,
+						    sreq->output_offset,
+						    sreq->output_len, false);
+			else
+				dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+					     DMA_FROM_DEVICE);
+		}
 	}
 
 	return ret;
-- 
2.55.0

