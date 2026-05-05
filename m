Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB2F4ADD9D
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003643; cv=none; b=jUgG/WXBx7BtAXejw2TsufJOvO8BI53Chzh5PKC/taDKmJUGF4PYpL/0MX81C3PMQOcA/sCKYQsgSK12hXTkXzRrAJD2m+zxxmoSIhQ9rO1fQ/Xab3NWDdQ72Hr7742IfnOAq6fcoEHOVeq4uWsAubKtHr3xFFgPSvzXE5IybVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003643; c=relaxed/simple;
	bh=lUwaoZyOhwWcNlKyO9UaTsMvhhRZsx9trVQWggLqEug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tR598EnYSEwH/kRlr9tbFfLUAtihrL0YS/wV2pa+F5RF6pkG63Nh2eSxAu6JLvBfDrBxct2t9mricjP1fga7XJbey12p1f4AmQQYlh+CREzRwY/zh0f3lcvl2oXgcvOZHCrgZfNGwJ4f8EbwRUZxaUGxO/gbuANFWCdENfkxxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=hzCRQ2KA; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="hzCRQ2KA"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 48DBE1A3527;
	Tue,  5 May 2026 17:53:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1E7996053C;
	Tue,  5 May 2026 17:53:58 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 25A1D11AD03AB;
	Tue,  5 May 2026 19:53:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003637; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=m4tTkWuF5cQhPVTVJOXFS3q1CI0YIsrvC+jPdRl7Wts=;
	b=hzCRQ2KAfEjfeIi2VJVUYcf+iNot3Ubxzfzg5n2kGwnAztoopxqS1iMQYH9kJFMCHqyAwS
	dHbgXu3mUNpH3NxIL3VyEjOW6PmT+Fq17VBmQ9V+bBg5Aib8UGZgBvYjY8yeKjYlYjOiUH
	aSM7oFZ3ambM1+gQhF704FgOJQgIswQVSJue4xFQuUzFisMF2ejKc6zQtMez9LbEASXReh
	RG5ZlSJmRSjCldYdaNoSlaIkPHjtDyRPyNGLE0ll/HBQhO5D5LXXLvDdNq5x6X2LnEFHxT
	JlxIt/+vPwrS91H+F4A6dzBS4tTQ0xEiwfluAoNPTe8/Xu9TNd8hDc57/HM20g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:07 +0200
Subject: [PATCH v2 06/12] crypto: talitos/hash - prepare SEC1 descriptor
 chaining, remove additional descriptor
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-6-5818064bd190@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=6769;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=lUwaoZyOhwWcNlKyO9UaTsMvhhRZsx9trVQWggLqEug=;
 b=XUN7C0yLVmtsKCAh/BXdLEKFtp/ftbzNTHRP4YfNKibFXWtSihDQaf7fDM1EO8wtd1+d4UUpN
 y+72DPXGSSNBaGKPAmipN/8GvQcuFLuuxuXemSWtclfS78AdPqExfV7
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Currently, when SEC1 has buffered data (nbuf != 0), the ahash code
creates an additional descriptor on the fly inside
common_nonsnoop_hash() to handle the remainder of the data. This
approach is incompatible with the arbitrary-length descriptor chaining
that follows.

Remove the "additional descriptor" logic from common_nonsnoop_hash()
and common_nonsnoop_hash_unmap().

Also remove the nbytes adjustment for SEC1 in ahash_edesc_alloc()
that subtracted nbuf.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 100 +++--------------------------------------------
 1 file changed, 6 insertions(+), 94 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 376e21e06056..1f47424b93c7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1800,15 +1800,9 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2;
-
-	if (desc->next_desc)
-		desc2 = &list_next_entry(edesc, node)->desc;
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
-	if (desc->next_desc &&
-	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
+
 	if (req_ctx->last_desc)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
@@ -1820,13 +1814,6 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
 		unmap_single_talitos_ptr(dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
-	else if (desc->next_desc)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[1],
-					 DMA_TO_DEVICE);
-
-	if (is_sec1 && req_ctx->nbuf)
-		unmap_single_talitos_ptr(dev, &desc->ptr[3],
-					 DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -1937,9 +1924,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
 			       is_sec1);
 
-	if (is_sec1 && req_ctx->nbuf)
-		length -= req_ctx->nbuf;
-
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
 		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
@@ -1949,16 +1933,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/*
 	 * data in
 	 */
-	if (is_sec1 && req_ctx->nbuf) {
-		map_single_talitos_ptr(dev, &desc->ptr[3], req_ctx->nbuf,
-				       req_ctx->buf[req_ctx->buf_idx],
-				       DMA_TO_DEVICE);
-	} else {
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-	}
+	sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
+					&desc->ptr[3], sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
 
 	/* fifth DWORD empty */
 
@@ -1978,48 +1956,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
-	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_edesc *edesc2;
-		struct talitos_desc *desc2;
-
-		edesc2 = kzalloc(sizeof(*edesc2),
-				 areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-					 GFP_KERNEL :
-					 GFP_ATOMIC);
-		if (!edesc2)
-			return -ENOMEM;
-
-		list_add_tail(&edesc2->node, &req_ctx->desc_list);
-
-		desc2 = &edesc2->desc;
-
-		desc2->hdr = desc->hdr;
-		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
-		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
-		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
-
-		if (desc->ptr[1].ptr)
-			copy_talitos_ptr(&desc2->ptr[1], &desc->ptr[1],
-					 is_sec1);
-		else
-			map_single_talitos_ptr_nosync(dev, &desc2->ptr[1],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_TO_DEVICE);
-		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc2->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
-		if (req_ctx->last_desc)
-			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_FROM_DEVICE);
-	}
-
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -2038,11 +1974,6 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	if (is_sec1)
-		nbytes -= req_ctx->nbuf;
 
 	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
@@ -2061,8 +1992,6 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	unsigned int nsg;
 	int nents;
 	struct device *dev = ctx->dev;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
 	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
@@ -2094,30 +2023,13 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	}
 
 	/* Chain in any previously buffered data */
-	if (!is_sec1 && req_ctx->nbuf) {
+	if (req_ctx->nbuf) {
 		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
 			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
 		req_ctx->psrc = req_ctx->bufsl;
-	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
-		int offset;
-
-		if (nbytes_to_hash > blocksize)
-			offset = blocksize - req_ctx->nbuf;
-		else
-			offset = nbytes_to_hash - req_ctx->nbuf;
-		nents = sg_nents_for_len(req_ctx->request_sl, offset);
-		if (nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			return nents;
-		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
-				  ctx_buf + req_ctx->nbuf, offset);
-		req_ctx->nbuf += offset;
-		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, req_ctx->request_sl,
-						 offset);
 	} else
 		req_ctx->psrc = req_ctx->request_sl;
 

-- 
2.53.0

