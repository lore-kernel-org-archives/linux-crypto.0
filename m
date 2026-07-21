Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2313976A9;
	Tue, 21 Jul 2026 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642409; cv=none; b=UxKA8IlZajnKWnj2Kd6MlTJBy+9s3l59NlCLDekt+3euT9Q1iHP1IidN3QueIKyJL84BAtoSCklAh2DtbGlDOGD2oK4+dX8BQvVqngUP5p4eQubwmk2HGIrOKadaW8z+XZSdUbr0WzueFLWDTRaqyeK7Ntne9KUGMJshGqzOE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642409; c=relaxed/simple;
	bh=wOjqiaP/Ndr+TaLdqwDEnkQDZj4oHAvv0zOf2qC4i4A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pEYF5p/bAKwmQuhJ4AWkymGvi6M12kbM848ZcqctT+rQj0lT5k90aOha/3RF5U6mFcwD96IXuGtwqHe3vuZ+buKT8zU5R0B/NxOxWMehkfR4iwAjRmRcq7zU4VWfKVxXtfmUXkF7c201/jeJoPgNjc5IckoOSqwyvtBRAsBh6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=rkrha8CD; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="rkrha8CD"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D8FF24E40EA3;
	Tue, 21 Jul 2026 14:00:04 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AC48560368;
	Tue, 21 Jul 2026 14:00:04 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7464811BD3B77;
	Tue, 21 Jul 2026 16:00:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642404; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Oi32BiZrL6B6ohhvqtg+GKSoiSQ9tROQXg+lcHjFfbE=;
	b=rkrha8CD4I25MABFDEYwJkukBtNo9m5W6Ol2PAwilZeRD9D3/E7li/IfrEgg0y5SQcr7dB
	HKamNovQ5axgeBuhgcwk8Y5ttmIdMB8+YDPVEVRPRPrPZ5ELY4jH2t09Tzlif8mwFyIsOk
	6a2CVty7SfKjWFiNCivl6dhkgCJlOtlgw8bPVe7egOjD/M+qhprdBTMrgcQ9MRmyo8ed+o
	1Nt9A/2aNrUmECgPLnFcfpZtMuVPaam9UW/lbEv8AXSyp8k83qNnDJ5f+g8A/7fB267u5m
	1g3WJ0xqBwTgcXOoHQcnAaAM7WUxC+c3/OdkxcN/kxad7rs255bNia1DlU7pWg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:45 +0200
Subject: [PATCH v3 18/19] crypto: talitos - Introduce per-SEC-version
 descriptor and pointer structures
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-18-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=24147;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=wOjqiaP/Ndr+TaLdqwDEnkQDZj4oHAvv0zOf2qC4i4A=;
 b=39QJF2y8oes5WqTd/M/T8WGliY4ZMFVKyLM9f9YXqkBpSlb9c2NcWcsgIDwPp5wGo1IekWJ3j
 i3FSsyws95KDdGorWyjfVT+YGQH1XMrkxtYLeWfdSpgsHWq7ZKIbqvj
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
 drivers/crypto/talitos/talitos-hash.c     |  34 ++++----
 drivers/crypto/talitos/talitos-skcipher.c |  27 +++---
 drivers/crypto/talitos/talitos.c          |  20 ++---
 drivers/crypto/talitos/talitos.h          | 131 +++++++++++++++++++++++-------
 5 files changed, 162 insertions(+), 92 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index d9e27eddfd1d..667b99581702 100644
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
index c7a1a622c014..e214b6b3fb27 100644
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
@@ -132,7 +132,7 @@ static void talitos_handle_buggy_hash(struct talitos_ahash_req_ctx *req_ctx,
 	memcpy(&req_ctx->padding_buf[56], &len, sizeof(len));
 
 	pr_err_once("Bug in SEC1, padding ourself\n");
-	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
+	and_talitos_desc_hdr(&edesc->desc, ~DESC_HDR_MODE0_MDEU_PAD);
 	map_single_talitos_ptr(ctx->dev, ptr, sizeof(req_ctx->padding_buf),
 			       (char *)req_ctx->padding_buf, DMA_TO_DEVICE);
 }
@@ -153,7 +153,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* hash context in */
 	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
-		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
+		map_single_talitos_ptr_nosync(dev, from_talitos_desc_ptr(desc, 1),
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
 					      DMA_TO_DEVICE);
@@ -164,7 +164,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* HMAC key */
 	if (ctx->keylen)
-		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
+		to_talitos_ptr(from_talitos_desc_ptr(desc, 2), ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1() && sg_count > 1)
@@ -175,7 +175,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/*
 	 * data in
 	 */
-	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
+	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, from_talitos_desc_ptr(desc, 3),
 				  sg_count, 0, 0);
 	if (sg_count > 1)
 		sync_needed = true;
@@ -184,19 +184,19 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
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
@@ -243,19 +243,19 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
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
@@ -263,11 +263,11 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
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
index 2c34e2ffbf7e..79317fb7f47e 100644
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
index 8ea26422f449..1221eb9497fb 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -165,9 +165,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 
 	if (is_sec1()) {
 		while (edesc) {
-			edesc->desc.hdr1 = edesc->desc.hdr;
-
-			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+			dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
 						  TALITOS_DESC_SIZE,
 						  DMA_BIDIRECTIONAL);
 
@@ -178,7 +176,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 
 			/* Chain in any previous descriptors. */
 
-			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+			prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
 
 			dma_sync_single_for_device(dev, prev_dma_desc,
 						   TALITOS_DESC_SIZE,
@@ -262,20 +260,20 @@ static __be32 get_request_hdr(struct device *dev,
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
@@ -289,7 +287,7 @@ static void dma_unmap_request(struct device *dev,
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
 		while (edesc->next_desc) {
 			dma_unmap_single(dev,
-					 be32_to_cpu(edesc->desc.next_desc),
+					 be32_to_cpu(edesc->desc.sec1.next_desc),
 					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 			edesc = edesc->next_desc;
 		}
@@ -424,12 +422,12 @@ static __be32 search_desc_hdr_in_request(struct talitos_request *request,
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
index 9bbdd409da5a..2e2414ad1e03 100644
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

