Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94B377A89
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138083; cv=none; b=Vyou/ur9gB6FkqO1zcFkSb3aSXv5vH1W9NvsP879G6i2gmX1EWVDrOWIq4DxWWSuwUhWcuhSwH3QBz4cB274VFCjkaygs9xUk37tbDFl53WVhBT1dQ3zv+yufxjWRnmsVN8e7/ilfL6r4xNI+7Dw2GkXvIbLC+/EqwXKPjABesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138083; c=relaxed/simple;
	bh=ha41glkjxbdnBpBSGXtaurqxJnj6K9uw2o2F/Pr6kOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SfGUtVyNrCXzTrNRcTqYaNFJn2uFHpvFo4NYgwDtROmGglRq8nv/uCnN2xPwvT/kC3NzBn7O+xpRA2WZ3Tv2dD58MdKMLiq2shcogwNY28sgLHNAkg6kPKqze4usOPJx1hYMJmCExDUm38nBYCALYIiOI9gleph/0dPsehGGmwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Byj2zT7N; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Byj2zT7N"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 3B0024E401EF;
	Fri, 11 Sep 2026 14:47:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 100AE601DE;
	Fri, 11 Sep 2026 14:47:58 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EADFB11C7AFA9;
	Fri, 11 Sep 2026 16:47:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138073; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Ds7CboCKyNjQKBcnhEBujrTJegvmk3jB5j7vmWLRZoY=;
	b=Byj2zT7Nb3AB02KIKFYQaIBVUcW0mxNmDbdNSRaZFc5OBz0ylyMOqdgmblwEaPUp9S68m0
	xSmNfQBA2NuhAluwVISQdprcPllKT8yUgrLty8q+49aVWw+DDW40VPwYDh5tiVUrBiglFm
	yYwd/Ssx1N7RYMnV74VkxKkJC9cylWAFLKwt5NwgUPVnoDFdbVYc5Nvy6BlZ6+EQTovXMJ
	g644+/ZJnATloF8TYStHv+X+Gzb+VQcP9PAz2m5glMKUMv51EkhuTQyVWBw/GbFuAmQuxJ
	5tyFxtmWaXTjUy6/0/z6kk0W0CyU7ELeWjGpM7ET9V0Gu9kXZk1OxK5sCY2CiA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:35 +0200
Subject: [PATCH v6 18/19] crypto: talitos - Introduce per-SEC-version
 descriptor and pointer structures
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-18-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=24449;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=ha41glkjxbdnBpBSGXtaurqxJnj6K9uw2o2F/Pr6kOo=;
 b=Fbia+EASJ1nHdUB5eSuwp4PU+NMhbjnQb0Cv02FWFF9EhCkuNw7jvw6XdAvLictyhgdhPyEBa
 kuPNLmKWIa/CItTTjJ3bvhrrqa/KbRenjwVTiq5X8X3JYHp/F614LqK
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The SEC1 and SEC2 hardware descriptor and pointer formats differ in many
ways:

- SEC1 pointers have a 16-bit reserved field followed by a 16-bit length
  and 32-bit address, while SEC2 pointers pack a 16-bit length, 8-bit
  jump/extent, 8-bit extended address, and 32-bit address.

- SEC1 descriptors chain through a next_desc field absent from SEC2,
  while SEC2 has a hdr_lo field that SEC1 lacks.

In the current code, reading those structures and mapping them to the
documentation is not obvious.

Instead of using anonymous union members, define two separate structures
for hardware descriptor and pointer. The counterpart is that some added
helpers are needed.

Even if the structure is naturally aligned and no padding is added, add
the __packed attribute to hint that these structures are used by the
hardware.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c     |  42 +++++-----
 drivers/crypto/talitos/talitos-hash.c     |  36 ++++----
 drivers/crypto/talitos/talitos-skcipher.c |  27 +++---
 drivers/crypto/talitos/talitos.c          |  20 ++---
 drivers/crypto/talitos/talitos.h          | 131 +++++++++++++++++++++++-------
 5 files changed, 163 insertions(+), 93 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index d8058e75fb31..df0b4765986b 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -94,11 +94,11 @@ static void ipsec_esp_unmap(struct device *dev,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
-	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
-	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
+	bool is_ipsec_esp = from_talitos_desc_hdr(&edesc->desc) & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = from_talitos_desc_ptr(&edesc->desc, is_ipsec_esp ? 2 : 3);
 
 	if (is_ipsec_esp)
-		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
+		unmap_single_talitos_ptr(dev, from_talitos_desc_ptr(&edesc->desc, 6),
 					 DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
 
@@ -179,7 +179,7 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 	ipsec_esp_unmap(dev, edesc, req, false);
 
 	/* check ICV auth status */
-	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+	if (!err && ((from_talitos_desc_hdr_lo(desc) & DESC_HDR_LO_ICCR1_MASK) !=
 		     DESC_HDR_LO_ICCR1_PASS))
 		err = -EBADMSG;
 
@@ -208,13 +208,13 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	int sg_count, ret;
 	int elen = 0;
 	bool sync_needed = false;
-	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
-	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
-	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
+	bool is_ipsec_esp = from_talitos_desc_hdr(desc) & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = from_talitos_desc_ptr(desc, is_ipsec_esp ? 2 : 3);
+	struct talitos_ptr *ckey_ptr = from_talitos_desc_ptr(desc, is_ipsec_esp ? 3 : 2);
 	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
 
 	/* hmac key */
-	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen);
+	to_talitos_ptr(from_talitos_desc_ptr(desc, 0), ctx->dma_key, ctx->authkeylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1() && sg_count > 1)
@@ -227,7 +227,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 	/* hmac data */
 	ret = talitos_sg_map(dev, areq->src, areq->assoclen, edesc,
-			     &desc->ptr[1], sg_count, 0, tbl_off);
+			     from_talitos_desc_ptr(desc, 1), sg_count, 0, tbl_off);
 
 	if (ret > 1) {
 		tbl_off += ret;
@@ -247,10 +247,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
+	if (is_ipsec_esp && (from_talitos_desc_hdr(desc) & DESC_HDR_MODE1_MDEU_CICV))
 		elen = authsize;
 
-	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
+	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, from_talitos_desc_ptr(desc, 4),
 				 sg_count, areq->assoclen, tbl_off, elen,
 				 false, 1);
 
@@ -270,7 +270,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		elen = authsize;
 	else
 		elen = 0;
-	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
+	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, from_talitos_desc_ptr(desc, 5),
 				 sg_count, areq->assoclen, tbl_off, elen,
 				 is_ipsec_esp && !encrypt, 1);
 	tbl_off += ret;
@@ -284,19 +284,19 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 		/* icv data follows link tables */
 		to_talitos_ptr(tbl_ptr, dma_icv, authsize);
-		to_talitos_ptr_ext_or(&desc->ptr[5], authsize);
+		to_talitos_ptr_ext_or(from_talitos_desc_ptr(desc, 5), authsize);
 		sync_needed = true;
 	} else if (!encrypt) {
-		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize);
+		to_talitos_ptr(from_talitos_desc_ptr(desc, 6), dma_icv, authsize);
 		sync_needed = true;
 	} else if (!is_ipsec_esp) {
-		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
+		talitos_sg_map(dev, areq->dst, authsize, edesc, from_talitos_desc_ptr(desc, 6),
 			       sg_count, areq->assoclen + cryptlen, tbl_off);
 	}
 
 	/* iv out */
 	if (is_ipsec_esp)
-		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
+		map_single_talitos_ptr(dev, from_talitos_desc_ptr(desc, 6), ivsize, ctx->iv,
 				       DMA_FROM_DEVICE);
 
 	if (sync_needed)
@@ -339,7 +339,7 @@ static int aead_encrypt(struct aead_request *req)
 		return PTR_ERR(edesc);
 
 	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+	to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT);
 
 	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
 }
@@ -358,15 +358,15 @@ static int aead_decrypt(struct aead_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
+	if ((from_talitos_desc_hdr(&edesc->desc) & DESC_HDR_TYPE_IPSEC_ESP) &&
 	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
 	    ((!edesc->src_nents && !edesc->dst_nents) ||
 	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
 
 		/* decrypt and check the ICV */
-		edesc->desc.hdr = ctx->desc_hdr_template |
+		to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template |
 				  DESC_HDR_DIR_INBOUND |
-				  DESC_HDR_MODE1_MDEU_CICV;
+				  DESC_HDR_MODE1_MDEU_CICV);
 
 		/* reset integrity check result bits */
 
@@ -375,7 +375,7 @@ static int aead_decrypt(struct aead_request *req)
 	}
 
 	/* Have to check the ICV with software */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+	to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND);
 
 	/* stash incoming ICV for later cmp with ICV generated by the h/w */
 	icvdata = edesc->buf + edesc->dma_len;
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index b938f0d4a901..edc6825228ab 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -46,7 +46,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_desc *desc = &edesc->desc;
 
-	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, from_talitos_desc_ptr(desc, 5), DMA_FROM_DEVICE);
 
 	if (edesc->last && req_ctx->last_request)
 		memcpy(areq->result, req_ctx->hw_context,
@@ -56,8 +56,8 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&desc->ptr[1]))
-		unmap_single_talitos_ptr(dev, &desc->ptr[1],
+	if (from_talitos_ptr_len(from_talitos_desc_ptr(desc, 1)))
+		unmap_single_talitos_ptr(dev, from_talitos_desc_ptr(desc, 1),
 					 DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
@@ -130,12 +130,12 @@ static void talitos_handle_buggy_hash(struct talitos_ahash_req_ctx *req_ctx,
 
 	memset(req_ctx->padding_buf, 0, sizeof(req_ctx->padding_buf));
 	req_ctx->padding_buf[0] = 0x80;
-	if (edesc->desc.hdr & DESC_HDR_MODE0_MDEU_MD5)
+	if (from_talitos_desc_hdr(&edesc->desc) & DESC_HDR_MODE0_MDEU_MD5)
 		memcpy(&req_ctx->padding_buf[56], &le_len, sizeof(le_len));
 	else
 		memcpy(&req_ctx->padding_buf[56], &be_len, sizeof(be_len));
 	pr_err_once("Bug in SEC1, padding ourself\n");
-	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
+	and_talitos_desc_hdr(&edesc->desc, ~DESC_HDR_MODE0_MDEU_PAD);
 	map_single_talitos_ptr(ctx->dev, ptr, sizeof(req_ctx->padding_buf),
 			       (char *)req_ctx->padding_buf, DMA_TO_DEVICE);
 }
@@ -156,7 +156,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* hash context in */
 	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
-		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
+		map_single_talitos_ptr_nosync(dev, from_talitos_desc_ptr(desc, 1),
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
 					      DMA_TO_DEVICE);
@@ -167,7 +167,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* HMAC key */
 	if (ctx->keylen)
-		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
+		to_talitos_ptr(from_talitos_desc_ptr(desc, 2), ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1() && sg_count > 1)
@@ -178,7 +178,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/*
 	 * data in
 	 */
-	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
+	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, from_talitos_desc_ptr(desc, 3),
 				  sg_count, 0, 0);
 	if (sg_count > 1)
 		sync_needed = true;
@@ -187,19 +187,19 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* hash/HMAC out -or- hash context out */
 	if (edesc->last && req_ctx->last_request)
-		map_single_talitos_ptr(dev, &desc->ptr[5],
+		map_single_talitos_ptr(dev, from_talitos_desc_ptr(desc, 5),
 				       crypto_ahash_digestsize(tfm),
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
 	else
-		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
+		map_single_talitos_ptr_nosync(dev, from_talitos_desc_ptr(desc, 5),
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
 					      DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
 
-	if (is_sec1() && from_talitos_ptr_len(&desc->ptr[3]) == 0)
-		talitos_handle_buggy_hash(req_ctx, ctx, edesc, &desc->ptr[3]);
+	if (is_sec1() && from_talitos_ptr_len(from_talitos_desc_ptr(desc, 3)) == 0)
+		talitos_handle_buggy_hash(req_ctx, ctx, edesc, from_talitos_desc_ptr(desc, 3));
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -246,19 +246,19 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 		}
 
 		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
-		edesc->desc.hdr = ctx->desc_hdr_template;
+		to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template);
 		edesc->first = offset == 0;
 		edesc->last = nbytes - to_hash_this_desc == 0;
 
 		/* On last one, request SEC to pad; otherwise continue */
 		if (req_ctx->last_request && edesc->last)
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
+			or_talitos_desc_hdr(&edesc->desc, DESC_HDR_MODE0_MDEU_PAD);
 		else
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
+			or_talitos_desc_hdr(&edesc->desc, DESC_HDR_MODE0_MDEU_CONT);
 
 		/* request SEC to INIT hash. */
 		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+			or_talitos_desc_hdr(&edesc->desc, DESC_HDR_MODE0_MDEU_INIT);
 
 		/*
 		 * When the tfm context has a keylen, it's an HMAC.
@@ -266,11 +266,11 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 		 */
 		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
 				    (req_ctx->last_request && edesc->last)))
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+			or_talitos_desc_hdr(&edesc->desc, DESC_HDR_MODE0_MDEU_HMAC);
 
 		/* clear the DN bit  */
 		if (is_sec1() && !edesc->last)
-			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
+			and_talitos_desc_hdr(&edesc->desc, ~DESC_HDR_DONE_NOTIFY);
 
 		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
 
diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index d4762873d0cd..8318d28aea39 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -15,10 +15,10 @@ static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct skcipher_request *areq)
 {
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, from_talitos_desc_ptr(&edesc->desc, 5), DMA_FROM_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, from_talitos_desc_ptr(&edesc->desc, 1), DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -59,16 +59,18 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
 	int sg_count, ret;
 	bool sync_needed = false;
-	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
-		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
+	bool is_ctr = (from_talitos_desc_hdr(desc) & DESC_HDR_SEL0_MASK) ==
+			      DESC_HDR_SEL0_AESU &&
+		      (from_talitos_desc_hdr(desc) &
+		       DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
 
 	/* first DWORD empty */
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize);
+	to_talitos_ptr(from_talitos_desc_ptr(desc, 1), edesc->iv_dma, ivsize);
 
 	/* cipher key */
-	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
+	to_talitos_ptr(from_talitos_desc_ptr(desc, 2), ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1() && sg_count > 1)
@@ -81,8 +83,9 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/*
 	 * cipher in
 	 */
-	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
-				      sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
+	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc,
+				      from_talitos_desc_ptr(desc, 3), sg_count,
+				      0, 0, 0, false, is_ctr ? 16 : 1);
 	if (sg_count > 1)
 		sync_needed = true;
 
@@ -93,13 +96,13 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
 	}
 
-	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[4],
+	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, from_talitos_desc_ptr(desc, 4),
 			     sg_count, 0, (edesc->src_nents + 1));
 	if (ret > 1)
 		sync_needed = true;
 
 	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
+	map_single_talitos_ptr(dev, from_talitos_desc_ptr(desc, 5), ivsize, ctx->iv,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
@@ -189,7 +192,7 @@ static int skcipher_encrypt(struct skcipher_request *areq)
 		return PTR_ERR(edesc);
 
 	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+	to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT);
 
 	return common_nonsnoop(edesc, areq, skcipher_done);
 }
@@ -213,7 +216,7 @@ static int skcipher_decrypt(struct skcipher_request *areq)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+	to_talitos_desc_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND);
 
 	return common_nonsnoop(edesc, areq, skcipher_done);
 }
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index fd4ccbe4f504..0d227d3777e9 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -167,9 +167,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 
 	if (is_sec1()) {
 		while (edesc) {
-			edesc->desc.hdr1 = edesc->desc.hdr;
-
-			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+			dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
 						  TALITOS_DESC_SIZE,
 						  DMA_BIDIRECTIONAL);
 
@@ -180,7 +178,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 
 			/* Chain in any previous descriptors. */
 
-			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+			prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
 
 			dma_sync_single_for_device(dev, prev_dma_desc,
 						   TALITOS_DESC_SIZE,
@@ -264,20 +262,20 @@ static __be32 get_request_hdr(struct device *dev,
 		dma_sync_single_for_cpu(dev, request->dma_desc,
 					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 
-		return request->desc->hdr;
+		return request->desc->sec2.hdr;
 	}
 
 	edesc = container_of(request->desc, struct talitos_edesc, desc);
 	dma_desc = request->dma_desc;
 	while (edesc->next_desc) {
-		dma_desc = be32_to_cpu(edesc->desc.next_desc);
+		dma_desc = be32_to_cpu(edesc->desc.sec1.next_desc);
 		edesc = edesc->next_desc;
 	}
 
 	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
 				DMA_BIDIRECTIONAL);
 
-	return edesc->desc.hdr1;
+	return edesc->desc.sec1.hdr;
 }
 
 static void dma_unmap_request(struct device *dev,
@@ -291,7 +289,7 @@ static void dma_unmap_request(struct device *dev,
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
 		while (edesc->next_desc) {
 			dma_unmap_single(dev,
-					 be32_to_cpu(edesc->desc.next_desc),
+					 be32_to_cpu(edesc->desc.sec1.next_desc),
 					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 			edesc = edesc->next_desc;
 		}
@@ -426,12 +424,12 @@ static __be32 search_desc_hdr_in_request(struct talitos_request *request,
 	struct talitos_edesc *edesc;
 
 	if (request->dma_desc == cur_desc) {
-		return request->desc->hdr;
+		return from_talitos_desc_hdr(request->desc);
 	} else if (is_sec1()) {
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
 		while (edesc->next_desc) {
-			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
-				return edesc->next_desc->desc.hdr1;
+			if (edesc->desc.sec1.next_desc == cpu_to_be32(cur_desc))
+				return edesc->next_desc->desc.sec1.hdr;
 			edesc = edesc->next_desc;
 		}
 	}
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index a639c2f75d35..d720b8b4759c 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -36,33 +36,49 @@
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 /* descriptor pointer entry */
+
+struct sec1_talitos_ptr {
+	__be16 res;
+	__be16 len;
+	__be32 ptr;
+} __packed;
+
+struct sec2_talitos_ptr {
+	__be16 len;
+	u8 j_extent;
+	u8 eptr;
+	__be32 ptr;
+} __packed;
+
 struct talitos_ptr {
 	union {
-		struct {		/* SEC2 format */
-			__be16 len;     /* length */
-			u8 j_extent;    /* jump to sg link table and/or extent*/
-			u8 eptr;        /* extended address */
-		};
-		struct {			/* SEC1 format */
-			__be16 res;
-			__be16 len1;	/* length */
-		};
+		struct sec1_talitos_ptr sec1;
+		struct sec2_talitos_ptr sec2;
 	};
-	__be32 ptr;     /* address */
 };
 
-/* descriptor */
+/* descriptor format */
+
+struct sec1_talitos_desc {
+	__be32 hdr;
+	struct sec1_talitos_ptr ptr[7];
+	__be32 next_desc;
+} __packed;
+
+struct sec2_talitos_desc {
+	__be32 hdr;
+	__be32 hdr_lo;
+	struct sec2_talitos_ptr ptr[7];
+} __packed;
+
 struct talitos_desc {
-	__be32 hdr;                     /* header high bits */
 	union {
-		__be32 hdr_lo;		/* header low bits */
-		__be32 hdr1;		/* header for SEC1 */
+		struct sec1_talitos_desc sec1;
+		struct sec2_talitos_desc sec2;
 	};
-	struct talitos_ptr ptr[7];      /* ptr/len pair array */
-	__be32 next_desc;		/* next descriptor (SEC1) */
 };
 
-#define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
+#define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc))
 
 /*
  * talitos_edesc - s/w-extended descriptor
@@ -488,48 +504,101 @@ static inline void talitos_init_branch(bool sec1)
 #define DESC_PTR_LNKTBL_RET			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
 
+static inline __be32 from_talitos_ptr(struct talitos_ptr *ptr)
+{
+	if (is_sec1())
+		return ptr->sec1.ptr;
+	return ptr->sec2.ptr;
+}
+
+static inline __be32 from_talitos_desc_hdr(struct talitos_desc *desc)
+{
+	if (is_sec1())
+		return desc->sec1.hdr;
+	return desc->sec2.hdr;
+}
+
+static inline void to_talitos_desc_hdr(struct talitos_desc *desc, __be32 val)
+{
+	if (is_sec1())
+		desc->sec1.hdr = val;
+	else
+		desc->sec2.hdr = val;
+}
+
+static inline void or_talitos_desc_hdr(struct talitos_desc *desc, __be32 val)
+{
+	if (is_sec1())
+		desc->sec1.hdr |= val;
+	else
+		desc->sec2.hdr |= val;
+}
+
+static inline void and_talitos_desc_hdr(struct talitos_desc *desc, __be32 val)
+{
+	if (is_sec1())
+		desc->sec1.hdr &= val;
+	else
+		desc->sec2.hdr &= val;
+}
+
+static inline __be32 from_talitos_desc_hdr_lo(struct talitos_desc *desc)
+{
+	return desc->sec2.hdr_lo;
+}
+
+static inline struct talitos_ptr *
+from_talitos_desc_ptr(struct talitos_desc *desc, int idx)
+{
+	if (is_sec1())
+		return (struct talitos_ptr *)&desc->sec1.ptr[idx];
+	return (struct talitos_ptr *)&desc->sec2.ptr[idx];
+}
+
 static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
 				  unsigned int len)
 {
-	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
 	if (is_sec1()) {
-		ptr->len1 = cpu_to_be16(len);
+		ptr->sec1.ptr = cpu_to_be32(lower_32_bits(dma_addr));
+		ptr->sec1.len = cpu_to_be16(len);
 	} else {
-		ptr->len = cpu_to_be16(len);
-		ptr->eptr = upper_32_bits(dma_addr);
+		ptr->sec2.ptr = cpu_to_be32(lower_32_bits(dma_addr));
+		ptr->sec2.len = cpu_to_be16(len);
+		ptr->sec2.eptr = upper_32_bits(dma_addr);
 	}
 }
 
 static inline void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
 				    struct talitos_ptr *src_ptr)
 {
-	dst_ptr->ptr = src_ptr->ptr;
 	if (is_sec1()) {
-		dst_ptr->len1 = src_ptr->len1;
+		dst_ptr->sec1.ptr = src_ptr->sec1.ptr;
+		dst_ptr->sec1.len = src_ptr->sec1.len;
 	} else {
-		dst_ptr->len = src_ptr->len;
-		dst_ptr->eptr = src_ptr->eptr;
+		dst_ptr->sec2.ptr = src_ptr->sec2.ptr;
+		dst_ptr->sec2.len = src_ptr->sec2.len;
+		dst_ptr->sec2.eptr = src_ptr->sec2.eptr;
 	}
 }
 
 static inline unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr)
 {
 	if (is_sec1())
-		return be16_to_cpu(ptr->len1);
+		return be16_to_cpu(ptr->sec1.len);
 	else
-		return be16_to_cpu(ptr->len);
+		return be16_to_cpu(ptr->sec2.len);
 }
 
 static inline void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
 {
 	if (!is_sec1())
-		ptr->j_extent = val;
+		ptr->sec2.j_extent = val;
 }
 
 static inline void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
 {
 	if (!is_sec1())
-		ptr->j_extent |= val;
+		ptr->sec2.j_extent |= val;
 }
 
 /*
@@ -569,8 +638,8 @@ static inline void unmap_single_talitos_ptr(struct device *dev,
 					    struct talitos_ptr *ptr,
 					    enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, be32_to_cpu(ptr->ptr), from_talitos_ptr_len(ptr),
-			 dir);
+	dma_unmap_single(dev, be32_to_cpu(from_talitos_ptr(ptr)),
+			 from_talitos_ptr_len(ptr), dir);
 }
 
 int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,

-- 
2.55.0

