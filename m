Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8523C368D46;
	Thu, 11 Jun 2026 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163419; cv=none; b=Z0SId7VdQkeMJdhpuzquWApKnBL4Jb+jq7uVq5cGM7Hqb1guDDlv2uGOCV0APvoJtVCYiht4TYUsHPc9BaDjQAC9S9JhnPMgml9ns6ZaZO6oJFbnkCpNXM9htjUiIERMF/FnYY30nrWuofB+rpuPI/AyX+ZuoCF/fkJy4a/hmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163419; c=relaxed/simple;
	bh=B41TJ5xVUQ1PFCc4uCE03x3JKY0vzdNQSQjd/JXOnZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kANpXuG17rYdpHE3DzrYroSboLckj5C5BB0L/fYTu3+fLvLc3myMx7+5CMBSzu1BpHF+YNjp6d9YoOIctrWgvwV/4MMbH2/IM77jUAE1mJeYZypklCTYhx7d0RzTXNTKqAhhWWFUUpvNeZM/n+oRG8oakOkfmOfOtZQuLcdRpaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=17u4ZApU; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="17u4ZApU"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 239F44E42E1A;
	Thu, 11 Jun 2026 07:36:50 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E6C565FF03;
	Thu, 11 Jun 2026 07:36:49 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7E71A106B9E1F;
	Thu, 11 Jun 2026 09:36:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163409; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=PddP2lK1teXZ+Po6svxIB4BMJ5Jc4AmN7t8SeXSJCgc=;
	b=17u4ZApUl51kn+R7/6jPEcc91JPQUK4k0jBjiurclZz3xeCenZ93Oma+YHAhdtjGQoBJTN
	C6mi820cGqRqQe7DSjtRWCCB3yIxTK8aFyNhmBPWYFcOrmACwi2ys8pZT4YAd2NL0FB3zi
	z4kRmzu1MIvpKxklYTNOCnEQfGB8zDEmViRhgJ14uaSAJhKWKA7Wsum6o/igKALjUbrXys
	7C2C1pJ/r5Zqm+X9HvssKsTp/pbR7ajg8R71QHlwjf5fwzI6KVag+z24SP1FpKYxqJjJqH
	MA+3TgmVJOv1ssoo/aICTm/yayAUye9OLC14q6v5c9m6D8asbAYVbocjb1ve3w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:36:00 +0200
Subject: [PATCH v2 06/19] crypto: talitos/hash - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-6-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=57667;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=B41TJ5xVUQ1PFCc4uCE03x3JKY0vzdNQSQjd/JXOnZQ=;
 b=Z+Mdf2KGGa+5CtfYsLgicNXggjzeHtPwTUdbhbLeTj/pFUHe7On8sxe43cnoYkQMHl0+oAfGz
 hJz2F4p8pRwDQRo26IQu2tC2eMvrdIHKoRYXDqmDdamPymqBxJGNtXq
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the ahash algorithm implementations from talitos.c into a dedicated
talitos-hash.c file.

Add a helper that will be called in each crypto implementation file for
registration.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile       |   2 +-
 drivers/crypto/talitos/talitos-hash.c | 830 ++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c      | 858 +++-------------------------------
 drivers/crypto/talitos/talitos.h      |   7 +
 4 files changed, 901 insertions(+), 796 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index 901ec681f010..40d37f9364ef 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 
-talitos-y := talitos.o talitos-rng.o
+talitos-y := talitos.o talitos-rng.o talitos-hash.o
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
new file mode 100644
index 000000000000..76be6b6c6fcc
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -0,0 +1,830 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Freescale SEC (talitos) hash implementation
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ */
+
+#include <linux/scatterlist.h>
+
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha1.h>
+
+#include "talitos.h"
+
+#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
+
+struct talitos_ahash_req_ctx {
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	unsigned int hw_context_size;
+	unsigned int swinit;
+	unsigned int first_request;
+	unsigned int last_request;
+	unsigned int to_hash_later;
+};
+
+struct talitos_export_state {
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	unsigned int swinit;
+	unsigned int first_request;
+	unsigned int last_request;
+	unsigned int to_hash_later;
+};
+
+static void common_nonsnoop_hash_unmap(struct device *dev,
+				       struct talitos_edesc *edesc,
+				       struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	struct talitos_desc *desc = &edesc->desc;
+
+	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
+
+	if (edesc->last && req_ctx->last_request)
+		memcpy(areq->result, req_ctx->hw_context,
+		       crypto_ahash_digestsize(tfm));
+
+	if (edesc->src)
+		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
+
+	/* When using hashctx-in, must unmap it. */
+	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
+		unmap_single_talitos_ptr(dev, &desc->ptr[1],
+					 DMA_TO_DEVICE);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+}
+
+static void free_edesc_list_from(struct ahash_request *areq, struct talitos_edesc *edesc)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct talitos_edesc *next;
+
+	while (edesc) {
+		next = edesc->next_desc;
+		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
+		kfree(edesc);
+		edesc = next;
+	}
+}
+
+static void ahash_done(struct device *dev,
+		       struct talitos_desc *desc, void *context,
+		       int err)
+{
+	struct ahash_request *areq = context;
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(dev));
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_edesc *next;
+
+	if (is_sec1) {
+		free_edesc_list_from(areq, edesc);
+		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
+	} else {
+		next = edesc->next_desc;
+
+		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		kfree(edesc);
+
+		if (err)
+			goto out;
+
+		if (next) {
+			err = talitos_submit(dev, ctx->ch, &next->desc,
+					     ahash_done, areq);
+			if (err != -EINPROGRESS)
+				goto out;
+			return;
+		}
+out:
+		if (err && next)
+			free_edesc_list_from(areq, next);
+		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
+	}
+}
+
+/*
+ * SEC1 doesn't like hashing of 0 sized message, so we do the padding
+ * ourself and submit a padded block
+ */
+static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
+			       struct talitos_edesc *edesc,
+			       struct talitos_ptr *ptr)
+{
+	static u8 padded_hash[64] = {
+		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	};
+
+	pr_err_once("Bug in SEC1, padding ourself\n");
+	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
+	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
+			       (char *)padded_hash, DMA_TO_DEVICE);
+}
+
+static void common_nonsnoop_hash(struct talitos_edesc *edesc,
+				 struct ahash_request *areq,
+				 unsigned int length)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	bool sync_needed = false;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	int sg_count;
+
+	/* first DWORD empty */
+
+	/* hash context in */
+	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
+		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
+					      req_ctx->hw_context_size,
+					      req_ctx->hw_context,
+					      DMA_TO_DEVICE);
+		req_ctx->swinit = 0;
+	}
+	/* Indicate next op is not the first. */
+	req_ctx->first_request = 0;
+
+	/* HMAC key */
+	if (ctx->keylen)
+		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
+			       is_sec1);
+
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
+	else if (length)
+		sg_count = dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
+
+	/*
+	 * data in
+	 */
+	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
+				  sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
+
+	/* fifth DWORD empty */
+
+	/* hash/HMAC out -or- hash context out */
+	if (edesc->last && req_ctx->last_request)
+		map_single_talitos_ptr(dev, &desc->ptr[5],
+				       crypto_ahash_digestsize(tfm),
+				       req_ctx->hw_context, DMA_FROM_DEVICE);
+	else
+		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
+					      req_ctx->hw_context_size,
+					      req_ctx->hw_context,
+					      DMA_FROM_DEVICE);
+
+	/* last DWORD empty */
+
+	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
+		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
+
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+}
+
+static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
+					       struct scatterlist *src,
+					       unsigned int nbytes)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
+				   nbytes, 0, 0, 0, areq->base.flags, false);
+}
+
+static struct talitos_edesc *
+ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
+			  unsigned int blocksize, bool is_sec1)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
+				    TALITOS2_MAX_DATA_LEN;
+	struct scatterlist tmp[2];
+	size_t to_hash_this_desc;
+	struct scatterlist *src;
+	size_t offset = 0;
+
+	do {
+		src = scatterwalk_ffwd(tmp, areq->src, offset);
+
+		to_hash_this_desc =
+			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
+
+		/* Allocate extended descriptor */
+		edesc = ahash_edesc_alloc(areq, src, to_hash_this_desc);
+		if (IS_ERR(edesc)) {
+			if (first)
+				free_edesc_list_from(areq, first);
+			return edesc;
+		}
+
+		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
+		edesc->desc.hdr = ctx->desc_hdr_template;
+		edesc->first = offset == 0;
+		edesc->last = nbytes - to_hash_this_desc == 0;
+
+		/* On last one, request SEC to pad; otherwise continue */
+		if (req_ctx->last_request && edesc->last)
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
+		else
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
+
+		/* request SEC to INIT hash. */
+		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+
+		/*
+		 * When the tfm context has a keylen, it's an HMAC.
+		 * A first or last (ie. not middle) descriptor must request HMAC.
+		 */
+		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
+				    (req_ctx->last_request && edesc->last)))
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+
+		/* clear the DN bit  */
+		if (is_sec1 && !edesc->last)
+			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
+
+		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
+
+		offset += to_hash_this_desc;
+		nbytes -= to_hash_this_desc;
+
+		if (!prev_edesc)
+			first = edesc;
+		else
+			prev_edesc->next_desc = edesc;
+		prev_edesc = edesc;
+	} while (nbytes);
+
+	return first;
+}
+
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
+	unsigned int nbytes_to_hash;
+	unsigned int to_hash_later;
+	struct device *dev = ctx->dev;
+	int ret;
+
+	nbytes_to_hash = ALIGN_DOWN(nbytes, blocksize);
+	to_hash_later = nbytes - nbytes_to_hash;
+
+	if (req_ctx->last_request) {
+		nbytes_to_hash = nbytes;
+		to_hash_later = 0;
+	}
+
+	req_ctx->to_hash_later = to_hash_later;
+
+	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
+					  is_sec1);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
+	if (ret != -EINPROGRESS)
+		free_edesc_list_from(areq, edesc);
+
+	return ret;
+}
+
+static int ahash_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	unsigned int size;
+	dma_addr_t dma;
+
+	/* Initialize the context */
+	req_ctx->first_request = 1;
+	req_ctx->swinit = 0; /* assume h/w init of context */
+	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	req_ctx->hw_context_size = size;
+	req_ctx->last_request = 0;
+
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+/*
+ * on h/w without explicit sha224 support, we initialize h/w context
+ * manually with sha224 constants, and tell it to run sha256.
+ */
+static int ahash_init_sha224_swinit(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->hw_context[0] = SHA224_H0;
+	req_ctx->hw_context[1] = SHA224_H1;
+	req_ctx->hw_context[2] = SHA224_H2;
+	req_ctx->hw_context[3] = SHA224_H3;
+	req_ctx->hw_context[4] = SHA224_H4;
+	req_ctx->hw_context[5] = SHA224_H5;
+	req_ctx->hw_context[6] = SHA224_H6;
+	req_ctx->hw_context[7] = SHA224_H7;
+
+	/* init 64-bit count */
+	req_ctx->hw_context[8] = 0;
+	req_ctx->hw_context[9] = 0;
+
+	ahash_init(areq);
+	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
+
+	return 0;
+}
+
+static int ahash_update(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last_request = 0;
+
+	return ahash_process_req(areq, areq->nbytes);
+}
+
+static int ahash_final(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last_request = 1;
+
+	return ahash_process_req(areq, 0);
+}
+
+static int ahash_finup(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last_request = 1;
+
+	return ahash_process_req(areq, areq->nbytes);
+}
+
+static int ahash_digest(struct ahash_request *areq)
+{
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
+
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
+}
+
+static int ahash_export(struct ahash_request *areq, void *out)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_export_state *export = out;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	dma_addr_t dma;
+
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_FROM_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_FROM_DEVICE);
+
+	memcpy(export->hw_context, req_ctx->hw_context,
+	       req_ctx->hw_context_size);
+	export->swinit = req_ctx->swinit;
+	export->first_request = req_ctx->first_request;
+	export->last_request = req_ctx->last_request;
+	export->to_hash_later = req_ctx->to_hash_later;
+
+	return 0;
+}
+
+static int ahash_import(struct ahash_request *areq, const void *in)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	const struct talitos_export_state *export = in;
+	unsigned int size;
+	dma_addr_t dma;
+
+	memset(req_ctx, 0, sizeof(*req_ctx));
+	size = (crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	req_ctx->hw_context_size = size;
+	memcpy(req_ctx->hw_context, export->hw_context, size);
+	req_ctx->swinit = export->swinit;
+	req_ctx->first_request = export->first_request;
+	req_ctx->last_request = export->last_request;
+	req_ctx->to_hash_later = export->to_hash_later;
+
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
+		   u8 *hash)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+
+	struct scatterlist sg[1];
+	struct ahash_request *req;
+	struct crypto_wait wait;
+	int ret;
+
+	crypto_init_wait(&wait);
+
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	/* Keep tfm keylen == 0 during hash of the long key */
+	ctx->keylen = 0;
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &wait);
+
+	sg_init_one(&sg[0], key, keylen);
+
+	ahash_request_set_crypt(req, sg, hash, keylen);
+	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
+
+	ahash_request_free(req);
+
+	return ret;
+}
+
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct device *dev = ctx->dev;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	unsigned int keysize = keylen;
+	u8 hash[SHA512_DIGEST_SIZE];
+	int ret;
+
+	if (keylen <= blocksize)
+		memcpy(ctx->key, key, keysize);
+	else {
+		/* Must get the hash of the long key */
+		ret = keyhash(tfm, key, keylen, hash);
+
+		if (ret)
+			return -EINVAL;
+
+		keysize = digestsize;
+		memcpy(ctx->key, hash, digestsize);
+	}
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	ctx->keylen = keysize;
+	ctx->dma_key = dma_map_single(dev, ctx->key, keysize, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	talitos_alg = container_of(__crypto_ahash_alg(alg),
+				   struct talitos_crypto_alg,
+				   algt.alg.hash);
+
+	ctx->keylen = 0;
+
+	return talitos_init_common(ctx, talitos_alg);
+}
+
+static struct talitos_alg_template hash_driver_algs[] = {
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "md5",
+				.cra_driver_name = "md5-talitos",
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_MD5,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "sha1",
+				.cra_driver_name = "sha1-talitos",
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "sha224",
+				.cra_driver_name = "sha224-talitos",
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA224,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "sha256",
+				.cra_driver_name = "sha256-talitos",
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "sha384",
+				.cra_driver_name = "sha384-talitos",
+				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA384,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "sha512",
+				.cra_driver_name = "sha512-talitos",
+				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA512,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(md5)",
+				.cra_driver_name = "hmac-md5-talitos",
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_MD5,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(sha1)",
+				.cra_driver_name = "hmac-sha1-talitos",
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(sha224)",
+				.cra_driver_name = "hmac-sha224-talitos",
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA224,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-talitos",
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(sha384)",
+				.cra_driver_name = "hmac-sha384-talitos",
+				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA384,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct talitos_export_state),
+			.halg.base = {
+				.cra_name = "hmac(sha512)",
+				.cra_driver_name = "hmac-sha512-talitos",
+				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA512,
+	}
+};
+
+int talitos_register_hash(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct ahash_alg *ahash_alg;
+	struct crypto_alg *alg;
+	size_t i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(hash_driver_algs); i++) {
+		if (!talitos_hw_supports(dev,
+					 hash_driver_algs[i].desc_hdr_template))
+			continue;
+
+		ahash_alg = &hash_driver_algs[i].alg.hash;
+		alg = &ahash_alg->halg.base;
+
+		alg->cra_init = talitos_cra_init_ahash;
+		alg->cra_exit = talitos_cra_exit;
+		ahash_alg->init = ahash_init;
+		ahash_alg->update = ahash_update;
+		ahash_alg->final = ahash_final;
+		ahash_alg->finup = ahash_finup;
+		ahash_alg->digest = ahash_digest;
+		if (!strncmp(alg->cra_name, "hmac", 4))
+			ahash_alg->setkey = ahash_setkey;
+		ahash_alg->import = ahash_import;
+		ahash_alg->export = ahash_export;
+
+		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
+		    !strncmp(alg->cra_name, "hmac", 4)) {
+			/* not supported */
+			continue;
+		}
+
+		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
+		    (!strcmp(alg->cra_name, "sha224") ||
+		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
+			ahash_alg->init = ahash_init_sha224_swinit;
+			ahash_alg->digest = ahash_digest_sha224_swinit;
+			hash_driver_algs[i].desc_hdr_template =
+				DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				DESC_HDR_SEL0_MDEUA |
+				DESC_HDR_MODE0_MDEU_SHA256;
+		}
+
+		ret = talitos_register_common(dev, &hash_driver_algs[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 58e1e534dedd..2d5688b1c81e 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -738,25 +738,6 @@ DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
 
-#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
-
-struct talitos_ahash_req_ctx {
-	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
-	unsigned int hw_context_size;
-	unsigned int swinit;
-	unsigned int first_request;
-	unsigned int last_request;
-	unsigned int to_hash_later;
-};
-
-struct talitos_export_state {
-	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
-	unsigned int swinit;
-	unsigned int first_request;
-	unsigned int last_request;
-	unsigned int to_hash_later;
-};
-
 static int aead_setkey(struct crypto_aead *authenc,
 		       const u8 *key, unsigned int keylen)
 {
@@ -1565,501 +1546,6 @@ static int skcipher_decrypt(struct skcipher_request *areq)
 	return common_nonsnoop(edesc, areq, skcipher_done);
 }
 
-static void common_nonsnoop_hash_unmap(struct device *dev,
-				       struct talitos_edesc *edesc,
-				       struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-	struct talitos_desc *desc = &edesc->desc;
-
-	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
-
-	if (edesc->last && req_ctx->last_request)
-		memcpy(areq->result, req_ctx->hw_context,
-		       crypto_ahash_digestsize(tfm));
-
-	if (edesc->src)
-		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
-
-	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
-		unmap_single_talitos_ptr(dev, &desc->ptr[1],
-					 DMA_TO_DEVICE);
-
-	if (edesc->dma_len)
-		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
-				 DMA_BIDIRECTIONAL);
-}
-
-static void free_edesc_list_from(struct ahash_request *areq, struct talitos_edesc *edesc)
-{
-	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
-	struct talitos_edesc *next;
-
-	while (edesc) {
-		next = edesc->next_desc;
-		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
-		kfree(edesc);
-		edesc = next;
-	}
-}
-
-static void ahash_done(struct device *dev,
-		       struct talitos_desc *desc, void *context,
-		       int err)
-{
-	struct ahash_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(dev));
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct talitos_edesc *next;
-
-	if (is_sec1) {
-		free_edesc_list_from(areq, edesc);
-		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
-	} else {
-		next = edesc->next_desc;
-
-		common_nonsnoop_hash_unmap(dev, edesc, areq);
-		kfree(edesc);
-
-		if (err)
-			goto out;
-
-		if (next) {
-			err = talitos_submit(dev, ctx->ch, &next->desc,
-					     ahash_done, areq);
-			if (err != -EINPROGRESS)
-				goto out;
-			return;
-		}
-out:
-		if (err && next)
-			free_edesc_list_from(areq, next);
-		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
-	}
-}
-
-/*
- * SEC1 doesn't like hashing of 0 sized message, so we do the padding
- * ourself and submit a padded block
- */
-static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
-			       struct talitos_edesc *edesc,
-			       struct talitos_ptr *ptr)
-{
-	static u8 padded_hash[64] = {
-		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	};
-
-	pr_err_once("Bug in SEC1, padding ourself\n");
-	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
-			       (char *)padded_hash, DMA_TO_DEVICE);
-}
-
-static void common_nonsnoop_hash(struct talitos_edesc *edesc,
-				 struct ahash_request *areq,
-				 unsigned int length)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct device *dev = ctx->dev;
-	struct talitos_desc *desc = &edesc->desc;
-	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-	int sg_count;
-
-	/* first DWORD empty */
-
-	/* hash context in */
-	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
-		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
-					      req_ctx->hw_context_size,
-					      req_ctx->hw_context,
-					      DMA_TO_DEVICE);
-		req_ctx->swinit = 0;
-	}
-	/* Indicate next op is not the first. */
-	req_ctx->first_request = 0;
-
-	/* HMAC key */
-	if (ctx->keylen)
-		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
-			       is_sec1);
-
-	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
-	else if (length)
-		sg_count = dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
-
-	/*
-	 * data in
-	 */
-	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
-				  sg_count, 0, 0);
-	if (sg_count > 1)
-		sync_needed = true;
-
-	/* fifth DWORD empty */
-
-	/* hash/HMAC out -or- hash context out */
-	if (edesc->last && req_ctx->last_request)
-		map_single_talitos_ptr(dev, &desc->ptr[5],
-				       crypto_ahash_digestsize(tfm),
-				       req_ctx->hw_context, DMA_FROM_DEVICE);
-	else
-		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
-					      req_ctx->hw_context_size,
-					      req_ctx->hw_context,
-					      DMA_FROM_DEVICE);
-
-	/* last DWORD empty */
-
-	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
-		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
-
-	if (sync_needed)
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-}
-
-static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
-					       struct scatterlist *src,
-					       unsigned int nbytes)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-
-	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
-				   nbytes, 0, 0, 0, areq->base.flags, false);
-}
-
-static struct talitos_edesc *
-ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
-			  unsigned int blocksize, bool is_sec1)
-{
-	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
-	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
-				    TALITOS2_MAX_DATA_LEN;
-	struct scatterlist tmp[2];
-	size_t to_hash_this_desc;
-	struct scatterlist *src;
-	size_t offset = 0;
-
-	do {
-		src = scatterwalk_ffwd(tmp, areq->src, offset);
-
-		to_hash_this_desc =
-			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
-
-		/* Allocate extended descriptor */
-		edesc = ahash_edesc_alloc(areq, src, to_hash_this_desc);
-		if (IS_ERR(edesc)) {
-			if (first)
-				free_edesc_list_from(areq, first);
-			return edesc;
-		}
-
-		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
-		edesc->desc.hdr = ctx->desc_hdr_template;
-		edesc->first = offset == 0;
-		edesc->last = nbytes - to_hash_this_desc == 0;
-
-		/* On last one, request SEC to pad; otherwise continue */
-		if (req_ctx->last_request && edesc->last)
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
-		else
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
-
-		/* request SEC to INIT hash. */
-		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
-
-		/*
-		 * When the tfm context has a keylen, it's an HMAC.
-		 * A first or last (ie. not middle) descriptor must request HMAC.
-		 */
-		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
-				    (req_ctx->last_request && edesc->last)))
-			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
-
-		/* clear the DN bit  */
-		if (is_sec1 && !edesc->last)
-			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
-
-		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
-
-		offset += to_hash_this_desc;
-		nbytes -= to_hash_this_desc;
-
-		if (!prev_edesc)
-			first = edesc;
-		else
-			prev_edesc->next_desc = edesc;
-		prev_edesc = edesc;
-	} while (nbytes);
-
-	return first;
-}
-
-static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_edesc *edesc;
-	unsigned int blocksize =
-			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
-	unsigned int nbytes_to_hash;
-	unsigned int to_hash_later;
-	struct device *dev = ctx->dev;
-	int ret;
-
-	nbytes_to_hash = ALIGN_DOWN(nbytes, blocksize);
-	to_hash_later = nbytes - nbytes_to_hash;
-
-	if (req_ctx->last_request) {
-		nbytes_to_hash = nbytes;
-		to_hash_later = 0;
-	}
-
-	req_ctx->to_hash_later = to_hash_later;
-
-	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
-					  is_sec1);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
-	if (ret != -EINPROGRESS)
-		free_edesc_list_from(areq, edesc);
-
-	return ret;
-}
-
-static int ahash_init(struct ahash_request *areq)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	unsigned int size;
-	dma_addr_t dma;
-
-	/* Initialize the context */
-	req_ctx->first_request = 1;
-	req_ctx->swinit = 0; /* assume h/w init of context */
-	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
-			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
-			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
-	req_ctx->hw_context_size = size;
-	req_ctx->last_request = 0;
-
-	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
-			     DMA_TO_DEVICE);
-	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
-
-	return 0;
-}
-
-/*
- * on h/w without explicit sha224 support, we initialize h/w context
- * manually with sha224 constants, and tell it to run sha256.
- */
-static int ahash_init_sha224_swinit(struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-
-	req_ctx->hw_context[0] = SHA224_H0;
-	req_ctx->hw_context[1] = SHA224_H1;
-	req_ctx->hw_context[2] = SHA224_H2;
-	req_ctx->hw_context[3] = SHA224_H3;
-	req_ctx->hw_context[4] = SHA224_H4;
-	req_ctx->hw_context[5] = SHA224_H5;
-	req_ctx->hw_context[6] = SHA224_H6;
-	req_ctx->hw_context[7] = SHA224_H7;
-
-	/* init 64-bit count */
-	req_ctx->hw_context[8] = 0;
-	req_ctx->hw_context[9] = 0;
-
-	ahash_init(areq);
-	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
-
-	return 0;
-}
-
-static int ahash_update(struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-
-	req_ctx->last_request = 0;
-
-	return ahash_process_req(areq, areq->nbytes);
-}
-
-static int ahash_final(struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-
-	req_ctx->last_request = 1;
-
-	return ahash_process_req(areq, 0);
-}
-
-static int ahash_finup(struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-
-	req_ctx->last_request = 1;
-
-	return ahash_process_req(areq, areq->nbytes);
-}
-
-static int ahash_digest(struct ahash_request *areq)
-{
-	ahash_init(areq);
-	return ahash_finup(areq);
-}
-
-static int ahash_digest_sha224_swinit(struct ahash_request *areq)
-{
-	ahash_init_sha224_swinit(areq);
-	return ahash_finup(areq);
-}
-
-static int ahash_export(struct ahash_request *areq, void *out)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_export_state *export = out;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	dma_addr_t dma;
-
-	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
-			     DMA_FROM_DEVICE);
-	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_FROM_DEVICE);
-
-	memcpy(export->hw_context, req_ctx->hw_context,
-	       req_ctx->hw_context_size);
-	export->swinit = req_ctx->swinit;
-	export->first_request = req_ctx->first_request;
-	export->last_request = req_ctx->last_request;
-	export->to_hash_later = req_ctx->to_hash_later;
-
-	return 0;
-}
-
-static int ahash_import(struct ahash_request *areq, const void *in)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	const struct talitos_export_state *export = in;
-	unsigned int size;
-	dma_addr_t dma;
-
-	memset(req_ctx, 0, sizeof(*req_ctx));
-	size = (crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
-			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
-			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
-	req_ctx->hw_context_size = size;
-	memcpy(req_ctx->hw_context, export->hw_context, size);
-	req_ctx->swinit = export->swinit;
-	req_ctx->first_request = export->first_request;
-	req_ctx->last_request = export->last_request;
-	req_ctx->to_hash_later = export->to_hash_later;
-
-	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
-			     DMA_TO_DEVICE);
-	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
-
-	return 0;
-}
-
-static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
-		   u8 *hash)
-{
-	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-
-	struct scatterlist sg[1];
-	struct ahash_request *req;
-	struct crypto_wait wait;
-	int ret;
-
-	crypto_init_wait(&wait);
-
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
-
-	/* Keep tfm keylen == 0 during hash of the long key */
-	ctx->keylen = 0;
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &wait);
-
-	sg_init_one(&sg[0], key, keylen);
-
-	ahash_request_set_crypt(req, sg, hash, keylen);
-	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
-
-	ahash_request_free(req);
-
-	return ret;
-}
-
-static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
-			unsigned int keylen)
-{
-	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct device *dev = ctx->dev;
-	unsigned int blocksize =
-			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int digestsize = crypto_ahash_digestsize(tfm);
-	unsigned int keysize = keylen;
-	u8 hash[SHA512_DIGEST_SIZE];
-	int ret;
-
-	if (keylen <= blocksize)
-		memcpy(ctx->key, key, keysize);
-	else {
-		/* Must get the hash of the long key */
-		ret = keyhash(tfm, key, keylen, hash);
-
-		if (ret)
-			return -EINVAL;
-
-		keysize = digestsize;
-		memcpy(ctx->key, hash, digestsize);
-	}
-
-	if (ctx->keylen)
-		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
-
-	ctx->keylen = keysize;
-	ctx->dma_key = dma_map_single(dev, ctx->key, keysize, DMA_TO_DEVICE);
-
-	return 0;
-}
-
 static struct talitos_alg_template driver_algs[] = {
 	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
@@ -2643,235 +2129,6 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE0_DEU_CBC |
 		                     DESC_HDR_MODE0_DEU_3DES,
 	},
-	/* AHASH algorithms. */
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = MD5_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "md5",
-				.cra_driver_name = "md5-talitos",
-				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_MD5,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha1",
-				.cra_driver_name = "sha1-talitos",
-				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA1,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA224_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha224",
-				.cra_driver_name = "sha224-talitos",
-				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA224,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha256",
-				.cra_driver_name = "sha256-talitos",
-				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA256,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA384_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha384",
-				.cra_driver_name = "sha384-talitos",
-				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA384,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA512_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "sha512",
-				.cra_driver_name = "sha512-talitos",
-				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA512,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = MD5_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(md5)",
-				.cra_driver_name = "hmac-md5-talitos",
-				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_MD5,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha1)",
-				.cra_driver_name = "hmac-sha1-talitos",
-				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA1,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA224_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha224)",
-				.cra_driver_name = "hmac-sha224-talitos",
-				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA224,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha256)",
-				.cra_driver_name = "hmac-sha256-talitos",
-				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUA |
-				     DESC_HDR_MODE0_MDEU_SHA256,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA384_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha384)",
-				.cra_driver_name = "hmac-sha384-talitos",
-				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA384,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AHASH,
-		.alg.hash = {
-			.halg.digestsize = SHA512_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct talitos_export_state),
-			.halg.base = {
-				.cra_name = "hmac(sha512)",
-				.cra_driver_name = "hmac-sha512-talitos",
-				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY |
-					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
-			}
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_MDEUB |
-				     DESC_HDR_MODE0_MDEUB_SHA512,
-	}
 };
 
 int talitos_init_common(struct talitos_ctx *ctx,
@@ -2920,21 +2177,6 @@ static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
-static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
-{
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	talitos_alg = container_of(__crypto_ahash_alg(alg),
-				   struct talitos_crypto_alg,
-				   algt.alg.hash);
-
-	ctx->keylen = 0;
-
-	return talitos_init_common(ctx, talitos_alg);
-}
-
 void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -3000,6 +2242,65 @@ static void talitos_remove(struct platform_device *ofdev)
 		tasklet_kill(&priv->done_task[1]);
 }
 
+static void talitos_alg_set_common(struct talitos_private *priv,
+				   struct crypto_alg *alg, u32 custom_priority,
+				   u32 type)
+{
+	alg->cra_module = THIS_MODULE;
+	if (custom_priority)
+		alg->cra_priority = custom_priority;
+	else
+		alg->cra_priority = TALITOS_CRA_PRIORITY;
+	if (has_ftr_sec1(priv) && type != CRYPTO_ALG_TYPE_AHASH)
+		alg->cra_alignmask = 3;
+	else
+		alg->cra_alignmask = 0;
+	alg->cra_ctxsize = sizeof(struct talitos_ctx);
+	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
+}
+
+int talitos_register_common(struct device *dev,
+			    struct talitos_alg_template *template)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct talitos_crypto_alg *t_alg;
+	struct crypto_alg *alg;
+	int ret;
+
+	t_alg = devm_kzalloc(dev, sizeof(struct talitos_crypto_alg),
+			     GFP_KERNEL);
+	if (!t_alg)
+		return -ENOMEM;
+
+	t_alg->algt = *template;
+
+	switch (t_alg->algt.type) {
+	case CRYPTO_ALG_TYPE_AHASH:
+		alg = &t_alg->algt.alg.hash.halg.base;
+		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
+				       t_alg->algt.type);
+		ret = crypto_register_ahash(&t_alg->algt.alg.hash);
+		break;
+	default:
+		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
+		devm_kfree(dev, t_alg);
+		return -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(dev, "%s alg registration failed\n",
+			alg->cra_driver_name);
+		devm_kfree(dev, t_alg);
+		return 0;
+	}
+
+	t_alg->dev = dev;
+
+	list_add_tail(&t_alg->entry, &priv->alg_list);
+
+	return 0;
+}
+
 static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 						    struct talitos_alg_template
 						           *template)
@@ -3045,37 +2346,6 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 			return ERR_PTR(-ENOTSUPP);
 		}
 		break;
-	case CRYPTO_ALG_TYPE_AHASH:
-		alg = &t_alg->algt.alg.hash.halg.base;
-		alg->cra_init = talitos_cra_init_ahash;
-		alg->cra_exit = talitos_cra_exit;
-		t_alg->algt.alg.hash.init = ahash_init;
-		t_alg->algt.alg.hash.update = ahash_update;
-		t_alg->algt.alg.hash.final = ahash_final;
-		t_alg->algt.alg.hash.finup = ahash_finup;
-		t_alg->algt.alg.hash.digest = ahash_digest;
-		if (!strncmp(alg->cra_name, "hmac", 4))
-			t_alg->algt.alg.hash.setkey = ahash_setkey;
-		t_alg->algt.alg.hash.import = ahash_import;
-		t_alg->algt.alg.hash.export = ahash_export;
-
-		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
-		    !strncmp(alg->cra_name, "hmac", 4)) {
-			devm_kfree(dev, t_alg);
-			return ERR_PTR(-ENOTSUPP);
-		}
-		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
-		    (!strcmp(alg->cra_name, "sha224") ||
-		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
-			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
-			t_alg->algt.alg.hash.digest =
-				ahash_digest_sha224_swinit;
-			t_alg->algt.desc_hdr_template =
-					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-					DESC_HDR_SEL0_MDEUA |
-					DESC_HDR_MODE0_MDEU_SHA256;
-		}
-		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
 		devm_kfree(dev, t_alg);
@@ -3304,6 +2574,10 @@ static int talitos_probe(struct platform_device *ofdev)
 			dev_info(dev, "hwrng\n");
 	}
 
+	err = talitos_register_hash(dev);
+	if (err)
+		goto err_out;
+
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		if (talitos_hw_supports(dev,
@@ -3331,12 +2605,6 @@ static int talitos_probe(struct platform_device *ofdev)
 					&t_alg->algt.alg.aead);
 				alg = &t_alg->algt.alg.aead.base;
 				break;
-
-			case CRYPTO_ALG_TYPE_AHASH:
-				err = crypto_register_ahash(
-						&t_alg->algt.alg.hash);
-				alg = &t_alg->algt.alg.hash.halg.base;
-				break;
 			}
 			if (err) {
 				dev_err(dev, "%s alg registration failed\n",
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 81331914801b..e59c85e3196c 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -599,7 +599,14 @@ int talitos_init_common(struct talitos_ctx *ctx,
 			struct talitos_crypto_alg *talitos_alg);
 void talitos_cra_exit(struct crypto_tfm *tfm);
 
+int talitos_register_common(struct device *dev,
+			    struct talitos_alg_template *template);
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);
 void talitos_unregister_rng(struct device *dev);
+
+/* Hash */
+
+int talitos_register_hash(struct device *dev);

-- 
2.54.0

