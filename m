Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8F13C1402
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003646; cv=none; b=kQVqpzeg6BRB2Nm3MJJei3XUZoTtRSfGcEOxchzqNuNU8TcwS8BdIkyqjM4Tl1Q9rcrU74xpo9bJ8NNXq/QztAabrNWjLxRZTSxfGCALYkEph73snHiyTzU6Wvo0urwAVajJmY76sgkBDLvfyDPfd8YoCpyCcechmUXm0RqFBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003646; c=relaxed/simple;
	bh=QQNglrBCqsvBA+JE0KFjWjQktiFPfjkJoe1FpsUhSEU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WmQqaOqZcc5DLw5QHLlxkc7U5++QL8WL5myK6iYTDu7AzRzdH9AsB0qm5GKpkOFQ7F8OmH9tEH36Z0JXBrRSSpIeDjsKWRzDKYQaLW5xfU4+o3Rq26GfrYJTDz2Cg31kXp940EPllqGdNH2gXPnBNIZ1okH3J5s+FcFhsRWTc5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=yvabvQiu; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="yvabvQiu"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 7D210C5CD54;
	Tue,  5 May 2026 17:54:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 92ABE6053C;
	Tue,  5 May 2026 17:54:01 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1450A11AD0413;
	Tue,  5 May 2026 19:53:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003640; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=J7zPqnMSs9mlwkc+wn4TtW5erdxQn/42Qf6QhWQcUg0=;
	b=yvabvQiuNu6CoKUVw0Jnu9+JcaBnOqGy1oNnNAIjBCTJf8REZzTX0WHZkWcyx00LX8l9im
	b9yXGQOz7aH6+pO9LKNJYkdj8na+D0gxSSYs6HVST9bm8cM0UGI4Doox09sbKxAcH+lPFw
	D0kkFiEWtG4KhbLtv1dVMZXyGcCg7neL/FJeVakLl2HMix1UGAWCj1vCs2fQkxyhSblbOV
	k1iWWM6jp1WP4c3JT7UdKZJ9psunlGzbRVFEg/kCFzcfoDMoa6TQ+v0XKkbjQtJ6NV5gwV
	bdNqhlOdoVa/aJWTE7JbD6u3o4WaZQixDYmKVYa9t+txQ/Ncf9jLwvc0xU/fsA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:09 +0200
Subject: [PATCH v2 08/12] crypto: talitos/hash - drop workqueue mechanism
 for SEC1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-8-5818064bd190@bootlin.com>
References: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
In-Reply-To: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=5520;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=QQNglrBCqsvBA+JE0KFjWjQktiFPfjkJoe1FpsUhSEU=;
 b=frMl8E9eE6soBMc/FK+4aWWzGpJRa5DOTTMZnfhbSj6hZtfbN0W7dHiG7fJkJngGWGpL4cw7z
 PfASXBk3GkMAei4YEhxJEIH0YESCV297oPBuSGyAcYGIlWq1P5vUh0p
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that SEC1 hash uses hardware descriptor chaining instead of a
workqueue to process requests exceeding TALITOS1_MAX_DATA_LEN, the
workqueue code is no longer needed.

Remove sec1_ahash_process_remaining(), the related fields from
talitos_ahash_req_ctx (request_bufsl, areq, request_sl,
remaining_ahash_request_bytes, current_ahash_request_bytes,
sec1_ahash_process_remaining), the dead code in ahash_done(), and
simplify ahash_process_req() to call ahash_process_req_one() directly
with the original areq->src and areq->nbytes.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 81 +++++-------------------------------------------
 1 file changed, 7 insertions(+), 74 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 450f81fc0137..43c07d86f84c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -962,13 +962,6 @@ struct talitos_ahash_req_ctx {
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
 	struct list_head desc_list;
-
-	struct scatterlist request_bufsl[2];
-	struct ahash_request *areq;
-	struct scatterlist *request_sl;
-	unsigned int remaining_ahash_request_bytes;
-	unsigned int current_ahash_request_bytes;
-	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1853,18 +1846,6 @@ static void ahash_done(struct device *dev,
 						   struct talitos_edesc, node));
 
 	ahash_request_complete(areq, err);
-
-	return;
-
-	req_ctx->remaining_ahash_request_bytes -=
-		req_ctx->current_ahash_request_bytes;
-
-	if (!req_ctx->remaining_ahash_request_bytes) {
-		ahash_request_complete(areq, 0);
-		return;
-	}
-
-	schedule_work(&req_ctx->sec1_ahash_process_remaining);
 }
 
 /*
@@ -2059,12 +2040,12 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 
 	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -2091,18 +2072,18 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else
-		req_ctx->psrc = req_ctx->request_sl;
+		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
@@ -2124,56 +2105,9 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	return ret;
 }
 
-static void sec1_ahash_process_remaining(struct work_struct *work)
-{
-	struct talitos_ahash_req_ctx *req_ctx =
-		container_of(work, struct talitos_ahash_req_ctx,
-			     sec1_ahash_process_remaining);
-	int err = 0;
-
-	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
-					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
-
-	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
-		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
-	else {
-		req_ctx->current_ahash_request_bytes =
-			req_ctx->remaining_ahash_request_bytes;
-
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	err = ahash_process_req_one(req_ctx->areq,
-				    req_ctx->current_ahash_request_bytes);
-
-	if (err != -EINPROGRESS)
-		ahash_request_complete(req_ctx->areq, err);
-}
-
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	req_ctx->areq = areq;
-	req_ctx->request_sl = areq->src;
-	req_ctx->remaining_ahash_request_bytes = nbytes;
-
-	if (is_sec1) {
-		if (nbytes > TALITOS1_MAX_DATA_LEN)
-			nbytes = TALITOS1_MAX_DATA_LEN;
-		else if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	req_ctx->current_ahash_request_bytes = nbytes;
-
-	return ahash_process_req_one(req_ctx->areq, areq->nbytes);
+	return ahash_process_req_one(areq, nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -2196,7 +2130,6 @@ static int ahash_init(struct ahash_request *areq)
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
 	req_ctx->last_desc = 0;
-	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);

-- 
2.53.0

