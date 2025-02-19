Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0121858A;
	Wed, 19 Feb 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989471; cv=none; b=CWi+9/9f7EIvcfayAbMl2YIfoI3d3pfRTFZoKk8elXeNVQjoZrKvIfr/dWpxxqFg4S+KRLBOgjbOuu1rcBIwR+DiiRAhfWmGYHtKm8Xa4WeAPPGAApPByzyOlKDxv3kvpdyyS8NuX6sRAUy9Aqt9QYtDnBUQQvRFafRPNWylLTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989471; c=relaxed/simple;
	bh=HOiG+O4t1HfyKMWrjgRzX33QT2jP4GmEeXBmoU0A50Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GblpZumGVTWtQV4sLnVPNZx6K2cl9+CEsu8bsRMbGm+tFgBYHT7fpIL/pNWHp8lwB9fJDJZli5b+vLkgFd7L5zLIjGsUjgbSGZhm1hLcWUqhpvjndqNK5gcDLt/TANJFOLrLLEb6g54vtumkK5GlvFwaaMStM4r9iCYel1adxIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPJrzJKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPJrzJKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A27C4CEE7;
	Wed, 19 Feb 2025 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989470;
	bh=HOiG+O4t1HfyKMWrjgRzX33QT2jP4GmEeXBmoU0A50Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPJrzJKyTjzzW5651CV6n/FmWiHbbrYHJPlpLGR8jJjga6vogmJH80C1lBCe9WRr7
	 taoB9Ut8ch1UHalGw161IFk3yGolguEinnhPeMhWbJtwKNdpcZOf03QY8v2VWCKy18
	 fl9Q/nm2nnPj0/DD/ZB4oR57O6iSB9SowtWLX0rIpnVgQ5y2xZtzJaEvBzspy0mDh3
	 rOiZ3dJvv+NI6cLgfUQdyvb9NY5PRGzCVQhXqFllHugz5unoeIhlQ2jRJT4KaQx+dw
	 WU+BFK+3dM71cjDW6FctN6r6mBtLf7y4Ef3xztvb9h3hbC1sWkUzoaBIapd+sobwoE
	 xDuzG1poSqe7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3 12/19] crypto: s5p-sss - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:34 -0800
Message-ID: <20250219182341.43961-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

s5p_sg_copy_buf() open-coded a copy from/to a scatterlist using
scatterwalk_* functions that are planned for removal.  Replace it with
the new functions memcpy_from_sglist() and memcpy_to_sglist() instead.
Also take the opportunity to replace calls to scatterwalk_map_and_copy()
in the same file; this eliminates the confusing 'out' argument.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/s5p-sss.c | 38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 57ab237e899e3..b4c3c14dafd5c 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -456,34 +456,21 @@ static void s5p_free_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist **sg)
 
 	kfree(*sg);
 	*sg = NULL;
 }
 
-static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
-			    unsigned int nbytes, int out)
-{
-	struct scatter_walk walk;
-
-	if (!nbytes)
-		return;
-
-	scatterwalk_start(&walk, sg);
-	scatterwalk_copychunks(buf, &walk, nbytes, out);
-	scatterwalk_done(&walk, out, 0);
-}
-
 static void s5p_sg_done(struct s5p_aes_dev *dev)
 {
 	struct skcipher_request *req = dev->req;
 	struct s5p_aes_reqctx *reqctx = skcipher_request_ctx(req);
 
 	if (dev->sg_dst_cpy) {
 		dev_dbg(dev->dev,
 			"Copying %d bytes of output data back to original place\n",
 			dev->req->cryptlen);
-		s5p_sg_copy_buf(sg_virt(dev->sg_dst_cpy), dev->req->dst,
-				dev->req->cryptlen, 1);
+		memcpy_to_sglist(dev->req->dst, 0, sg_virt(dev->sg_dst_cpy),
+				 dev->req->cryptlen);
 	}
 	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
 	s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
 	if (reqctx->mode & FLAGS_AES_CBC)
 		memcpy_fromio(req->iv, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), AES_BLOCK_SIZE);
@@ -524,11 +511,11 @@ static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
 		kfree(*dst);
 		*dst = NULL;
 		return -ENOMEM;
 	}
 
-	s5p_sg_copy_buf(pages, src, dev->req->cryptlen, 0);
+	memcpy_from_sglist(pages, src, 0, dev->req->cryptlen);
 
 	sg_init_table(*dst, 1);
 	sg_set_buf(*dst, pages, len);
 
 	return 0;
@@ -1033,12 +1020,11 @@ static int s5p_hash_copy_sgs(struct s5p_hash_reqctx *ctx,
 	}
 
 	if (ctx->bufcnt)
 		memcpy(buf, ctx->dd->xmit_buf, ctx->bufcnt);
 
-	scatterwalk_map_and_copy(buf + ctx->bufcnt, sg, ctx->skip,
-				 new_len, 0);
+	memcpy_from_sglist(buf + ctx->bufcnt, sg, ctx->skip, new_len);
 	sg_init_table(ctx->sgl, 1);
 	sg_set_buf(ctx->sgl, buf, len);
 	ctx->sg = ctx->sgl;
 	ctx->sg_len = 1;
 	ctx->bufcnt = 0;
@@ -1227,12 +1213,11 @@ static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
 		int len = BUFLEN - ctx->bufcnt % BUFLEN;
 
 		if (len > nbytes)
 			len = nbytes;
 
-		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
-					 0, len, 0);
+		memcpy_from_sglist(ctx->buffer + ctx->bufcnt, req->src, 0, len);
 		ctx->bufcnt += len;
 		nbytes -= len;
 		ctx->skip = len;
 	} else {
 		ctx->skip = 0;
@@ -1251,13 +1236,12 @@ static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
 			xmit_len -= xmit_len & (BUFLEN - 1);
 
 		hash_later = ctx->total - xmit_len;
 		/* copy hash_later bytes from end of req->src */
 		/* previous bytes are in xmit_buf, so no overwrite */
-		scatterwalk_map_and_copy(ctx->buffer, req->src,
-					 req->nbytes - hash_later,
-					 hash_later, 0);
+		memcpy_from_sglist(ctx->buffer, req->src,
+				   req->nbytes - hash_later, hash_later);
 	}
 
 	if (xmit_len > BUFLEN) {
 		ret = s5p_hash_prepare_sgs(ctx, req->src, nbytes - hash_later,
 					   final);
@@ -1265,12 +1249,12 @@ static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
 			return ret;
 	} else {
 		/* have buffered data only */
 		if (unlikely(!ctx->bufcnt)) {
 			/* first update didn't fill up buffer */
-			scatterwalk_map_and_copy(ctx->dd->xmit_buf, req->src,
-						 0, xmit_len, 0);
+			memcpy_from_sglist(ctx->dd->xmit_buf, req->src,
+					   0, xmit_len);
 		}
 
 		sg_init_table(ctx->sgl, 1);
 		sg_set_buf(ctx->sgl, ctx->dd->xmit_buf, xmit_len);
 
@@ -1504,12 +1488,12 @@ static int s5p_hash_update(struct ahash_request *req)
 
 	if (!req->nbytes)
 		return 0;
 
 	if (ctx->bufcnt + req->nbytes <= BUFLEN) {
-		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
-					 0, req->nbytes, 0);
+		memcpy_from_sglist(ctx->buffer + ctx->bufcnt, req->src,
+				   0, req->nbytes);
 		ctx->bufcnt += req->nbytes;
 		return 0;
 	}
 
 	return s5p_hash_enqueue(req, true); /* HASH_OP_UPDATE */
-- 
2.48.1

