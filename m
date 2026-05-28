Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C93A9628;
	Thu, 28 May 2026 09:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959397; cv=none; b=U080FlWZlHeIr4+K7kM3SBBdAL68Ii0YDNR3dtpMDH8XZkWA5ZwxcOTEN81/yQLVVaPHKzgt7ZuG0REBQY8oLOCRzHTdvXt+uwP+PolGhKZi+kyXngMjLZuWZ7vQOpUnDO6aHQe1ccVZae9jDcGmYqbnoAprYL4lTPjS0WIjjuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959397; c=relaxed/simple;
	bh=O3nMGprxow/W8RPiJMzlZBmxcC5VWI3bexCBwQBeiSo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tM/LIPcgaoVr+8XtdXH/sq5LBI7L2h3B3SBB4H60rdxJ81RlZSLfuGRLv7hDW2yzM+ayljWGjxrMmYYVq49PGrL16kUBNjiMitOfBMNZpQnaDOLiykGVUefTR2PeMKrdBAJMqedJepANCpSajuWfKyBG+M3nwGhMpnhzQVzN9zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=sEz/oV/i; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="sEz/oV/i"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id E39784E42D79;
	Thu, 28 May 2026 09:09:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B8A9160495;
	Thu, 28 May 2026 09:09:52 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6BB2F1088877F;
	Thu, 28 May 2026 11:09:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959392; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ogAfMImEqTNegJvs4Lseq3VUA+KFZdj5xvSobayj+CA=;
	b=sEz/oV/iSlRflS5ChvyuDfQmqoLa8UalkFxXTcmEqS4Oi0cXU04lXQ/eo/wRubF9oAi4aQ
	PWfQw17GTIC7DxNvTigGuWDfdjQpcQVfHH2VfJJ0uY6lzkBgR4unAU6r5PGKTA+rQZVisE
	w5uU+ZzLrjADpb92Q7+Mfr7s98T/o5I2M5mI6rPlq+lt1pMWWGd71zjWEQmmITV2w5wTx4
	2Mk0zsbpeft3N5iy3bIK4vaQ/fG+Sl/ry1WzaZENlEqeBnfQAt3KWR+lGwygBdKbL1wQHm
	+pbLBdY8C0+YaZ+xIb0e2A4kN7vjVSc4tNRKYdjNm7qtfJ9GZsNz1LqM/2J5VQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:38 +0200
Subject: [PATCH 25/29] crypto: talitos - Dispatch pointer helpers through
 ptr_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-25-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=11035;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=O3nMGprxow/W8RPiJMzlZBmxcC5VWI3bexCBwQBeiSo=;
 b=DT0485l7oJgs4nSGqCnmIWIgypOmPGkHt9yEkQFmR4e6TMKbQpH1mt9iKY/8xGaGa7V1pr8zm
 5W3EzUVf756CfUaa2LRjPBwY1nO/SeZvLlg0gAeA+3F2I2cCxmqupXl
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace all direct calls to to_talitos_ptr(), copy_talitos_ptr(),
from_talitos_ptr_len(), to_talitos_ptr_ext_set() and
to_talitos_ptr_ext_or() with indirect calls through ctx->ptr_ops
or priv->ptr_ops.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c     | 18 ++++++------
 drivers/crypto/talitos/talitos-hash.c     | 24 ++++++++--------
 drivers/crypto/talitos/talitos-skcipher.c |  4 +--
 drivers/crypto/talitos/talitos.c          | 47 ++++++++++++++++---------------
 4 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index cd1b8e6d371b..b585abdd2275 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -216,7 +216,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
 
 	/* hmac key */
-	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
+	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -237,11 +237,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* cipher iv */
-	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
+	ctx->ptr_ops->to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize);
 
 	/* cipher key */
-	to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
-		       ctx->enckeylen, is_sec1);
+	ctx->ptr_ops->to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
+		       ctx->enckeylen);
 
 	/*
 	 * cipher in
@@ -281,15 +281,15 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		/* Add an entry to the link table for ICV data */
-		to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
-		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET, is_sec1);
+		ctx->ptr_ops->to_talitos_ptr_ext_set(tbl_ptr - 1, 0);
+		ctx->ptr_ops->to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET);
 
 		/* icv data follows link tables */
-		to_talitos_ptr(tbl_ptr, dma_icv, authsize, is_sec1);
-		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
+		ctx->ptr_ops->to_talitos_ptr(tbl_ptr, dma_icv, authsize);
+		ctx->ptr_ops->to_talitos_ptr_ext_or(&desc->ptr[5], authsize);
 		sync_needed = true;
 	} else if (!encrypt) {
-		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize, is_sec1);
+		ctx->ptr_ops->to_talitos_ptr(&desc->ptr[6], dma_icv, authsize);
 		sync_needed = true;
 	} else if (!is_ipsec_esp) {
 		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 9e6d849c3123..026eebf037f5 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -36,32 +36,30 @@ struct talitos_export_state {
 	unsigned int to_hash_later;
 };
 
-static void common_nonsnoop_hash_unmap(struct device *dev,
+static void common_nonsnoop_hash_unmap(struct talitos_ctx *ctx,
 				       struct talitos_edesc *edesc,
 				       struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
 
-	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(ctx->dev, &desc->ptr[5], DMA_FROM_DEVICE);
 
 	if (edesc->last && req_ctx->last_request)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
 
 	if (edesc->src)
-		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
+		talitos_sg_unmap(ctx->dev, edesc, edesc->src, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
-		unmap_single_talitos_ptr(dev, &desc->ptr[1],
+	if (ctx->ptr_ops->from_talitos_ptr_len(&desc->ptr[1]))
+		unmap_single_talitos_ptr(ctx->dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
-		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+		dma_unmap_single(ctx->dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
 }
 
@@ -72,7 +70,7 @@ static void free_edesc_list_from(struct ahash_request *areq, struct talitos_edes
 
 	while (edesc) {
 		next = edesc->next_desc;
-		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
+		common_nonsnoop_hash_unmap(ctx, edesc, areq);
 		kfree(edesc);
 		edesc = next;
 	}
@@ -97,7 +95,7 @@ static void ahash_done(struct device *dev,
 	} else {
 		next = edesc->next_desc;
 
-		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		common_nonsnoop_hash_unmap(ctx, edesc, areq);
 		kfree(edesc);
 
 		if (err)
@@ -167,8 +165,8 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* HMAC key */
 	if (ctx->keylen)
-		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
-			       is_sec1);
+		ctx->ptr_ops->to_talitos_ptr(&desc->ptr[2], ctx->dma_key,
+					     ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -199,7 +197,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* last DWORD empty */
 
-	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
+	if (is_sec1 && ctx->ptr_ops->from_talitos_ptr_len(&desc->ptr[3]) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
 	if (sync_needed)
diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index b12191243aae..a96f827c7b93 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -67,10 +67,10 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
+	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize);
 
 	/* cipher key */
-	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen, is_sec1);
+	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 0e4bd130ac6d..ff88f3dc3869 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -97,9 +97,8 @@ static void __map_single_talitos_ptr(struct device *dev,
 {
 	dma_addr_t dma_addr = dma_map_single_attrs(dev, data, len, dir, attrs);
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
+	priv->ptr_ops->to_talitos_ptr(ptr, dma_addr, len);
 }
 
 void map_single_talitos_ptr(struct device *dev,
@@ -127,10 +126,9 @@ void unmap_single_talitos_ptr(struct device *dev,
 			      enum dma_data_direction dir)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
-			 from_talitos_ptr_len(ptr, is_sec1), dir);
+			 priv->ptr_ops->from_talitos_ptr_len(ptr), dir);
 }
 
 /*
@@ -455,7 +453,8 @@ void talitos_sg_unmap(struct device *dev,
  * convert scatterlist to SEC h/w link table format
  * stop at cryptlen bytes
  */
-static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
+static int sg_to_link_tbl_offset(const struct talitos_ptr_ops *ptr_ops,
+				 struct scatterlist *sg, int sg_count,
 				 unsigned int offset, int datalen, int elen,
 				 struct talitos_ptr *link_tbl_ptr, int align)
 {
@@ -478,16 +477,16 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 			len = cryptlen;
 
 		if (datalen > 0 && len > datalen) {
-			to_talitos_ptr(link_tbl_ptr + count,
-				       sg_dma_address(sg) + offset, datalen, 0);
-			to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
+			ptr_ops->to_talitos_ptr(link_tbl_ptr + count,
+				       sg_dma_address(sg) + offset, datalen);
+			ptr_ops->to_talitos_ptr_ext_set(link_tbl_ptr + count, 0);
 			count++;
 			len -= datalen;
 			offset += datalen;
 		}
-		to_talitos_ptr(link_tbl_ptr + count,
-			       sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding, 0);
-		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
+		ptr_ops->to_talitos_ptr(link_tbl_ptr + count,
+			       sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding);
+		ptr_ops->to_talitos_ptr_ext_set(link_tbl_ptr + count, 0);
 		count++;
 		cryptlen -= len;
 		datalen -= len;
@@ -499,8 +498,8 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 
 	/* tag end of link table */
 	if (count > 0)
-		to_talitos_ptr_ext_set(link_tbl_ptr + count - 1,
-				       DESC_PTR_LNKTBL_RET, 0);
+		ptr_ops->to_talitos_ptr_ext_set(link_tbl_ptr + count - 1,
+				       DESC_PTR_LNKTBL_RET);
 
 	return count;
 }
@@ -512,32 +511,34 @@ int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      bool force, int align)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	const struct talitos_ptr_ops *ptr_ops = priv->ptr_ops;
 	bool is_sec1 = has_ftr_sec1(priv);
 	int aligned_len = ALIGN(len, align);
 
 	if (!src) {
-		to_talitos_ptr(ptr, 0, 0, is_sec1);
+		ptr_ops->to_talitos_ptr(ptr, 0, 0);
 		return 1;
 	}
-	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
+	ptr_ops->to_talitos_ptr_ext_set(ptr, elen);
 	if (sg_count == 1 && !force) {
-		to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len, is_sec1);
+		ptr_ops->to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len);
 		return sg_count;
 	}
 	if (is_sec1) {
-		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len, is_sec1);
+		ptr_ops->to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len);
 		return sg_count;
 	}
-	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len, elen,
-					 &edesc->link_tbl[tbl_off], align);
+	sg_count = sg_to_link_tbl_offset(ptr_ops, src, sg_count, offset,
+					 len, elen, &edesc->link_tbl[tbl_off],
+					 align);
 	if (sg_count == 1 && !force) {
 		/* Only one segment now, so no link tbl needed*/
-		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
+		ptr_ops->copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off]);
 		return sg_count;
 	}
-	to_talitos_ptr(ptr, edesc->dma_link_tbl +
-			    tbl_off * sizeof(struct talitos_ptr), aligned_len, is_sec1);
-	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
+	ptr_ops->to_talitos_ptr(ptr, edesc->dma_link_tbl +
+			    tbl_off * sizeof(struct talitos_ptr), aligned_len);
+	ptr_ops->to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP);
 
 	return sg_count;
 }

-- 
2.54.0

