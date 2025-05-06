Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D88238D54
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 08:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746520580; cv=none; b=lmp6H/1hbeJtZlJxWBaymWPmmHzmtmAnQoB1fCEYxk0KoHIPNE2uK56ZxtMXfVlJ9BRgVtAfhBy64G1VQEOSFqRVlKQXI0z9LU/giY9w/W+4JBSoG1lfy+jYO2u5aMxeYaOCn0TqqBks1w88UIycd9/CKf5cU3JlGHQlo2/U5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746520580; c=relaxed/simple;
	bh=jO812zDcVtAnFibbdIkokEBwdywIyAx1JLUV+0GVhYI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aZXV/MhUtYCPt7grcLPiDX0G36HA8gKaDDzxpVXMlIEktLgpLgmrEd69BXX2eNaWuDrtJOUmvYEoWZjAy3yApwLrobcuMYLoBZA+jbx2u3CSGa73AabDmJHgTuPbFB7fFwS5Tiih6f21L2l79F+2525nJ+QPTEWWJ/rW7nLhMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QizR5MyG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QizR5MyG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rapQ0z16O7sVmudaIOku7Jn3Qcg91XPUsRehOMlhS/E=; b=QizR5MyGJYt6YEmH5FTo+2KK86
	L36Tsr+hGqlWG+jHMriEVWX8XzWdAZ/qCc22RXwrq4iTvuZRZ72WWyWuKJmh+J0o2IWVkGgbrUovR
	y8j4h8TP0hWF/sVgtslgR4YbgGnE46KdeY25oYQ50r/Pai4ruUfvmZUIh0bFs0u9sntqI6B0Ir+6m
	r9SmSrcqmGlVRw3IaAvQcm/B6wGfVidP4lgjannSNvukTkeqMLmaW1RXAIqQPOL3tDlqsb6cAYlSM
	5waPKb556lfPnnupQOBFX406j7F2mOQyRLlEQbcDphGF+FHr1/OR6nbey+NdW3j/idQkjdgPi1JGu
	hdGfJt4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCDmb-003tXs-35;
	Tue, 06 May 2025 16:36:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 May 2025 16:36:09 +0800
Date: Tue, 6 May 2025 16:36:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Neal Liu <neal_liu@aspeedtech.com>
Subject: [PATCH] crypto: aspeed/hash - Use API partial block handling
Message-ID: <aBnJ-fhTAuuf4Vfa@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch is based on

	https://patchwork.kernel.org/project/linux-crypto/list/?series=959772

---8<---
Use the Crypto API partial block handling.

Also switch to the generic export format.

Remove purely software hmac implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 805 ++++++-----------------
 drivers/crypto/aspeed/aspeed-hace.h      |  46 +-
 2 files changed, 220 insertions(+), 631 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 0b6e49c06eff..1409ecfa8c9a 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -5,7 +5,6 @@
 
 #include "aspeed-hace.h"
 #include <crypto/engine.h>
-#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
@@ -14,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/scatterlist.h>
 #include <linux/string.h>
 
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
@@ -59,6 +59,46 @@ static const __be64 sha512_iv[8] = {
 	cpu_to_be64(SHA512_H6), cpu_to_be64(SHA512_H7)
 };
 
+static int aspeed_sham_init(struct ahash_request *req);
+static int aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev);
+
+static int aspeed_sham_export(struct ahash_request *req, void *out)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+
+	memcpy(out, rctx->digest, rctx->ivsize);
+	p.u8 += rctx->ivsize;
+	put_unaligned(rctx->digcnt[0], p.u64++);
+	if (rctx->ivsize == 64)
+		put_unaligned(rctx->digcnt[1], p.u64);
+	return 0;
+}
+
+static int aspeed_sham_import(struct ahash_request *req, const void *in)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int err;
+
+	err = aspeed_sham_init(req);
+	if (err)
+		return err;
+
+	memcpy(rctx->digest, in, rctx->ivsize);
+	p.u8 += rctx->ivsize;
+	rctx->digcnt[0] = get_unaligned(p.u64++);
+	if (rctx->ivsize == 64)
+		rctx->digcnt[1] = get_unaligned(p.u64);
+	return 0;
+}
+
 /* The purpose of this padding is to ensure that the padded message is a
  * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits (SHA384/SHA512).
  * The bit "1" is appended at the end of the message followed by
@@ -74,9 +114,11 @@ static const __be64 sha512_iv[8] = {
  *  - if message length < 112 bytes then padlen = 112 - message length
  *  - else padlen = 128 + 112 - message length
  */
-static void aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev,
-				      struct aspeed_sham_reqctx *rctx)
+static int aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev, u8 *buf)
 {
+	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
+	struct ahash_request *req = hash_engine->req;
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
 	unsigned int index, padlen;
 	__be64 bits[2];
 
@@ -87,24 +129,22 @@ static void aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev,
 	case SHA_FLAGS_SHA224:
 	case SHA_FLAGS_SHA256:
 		bits[0] = cpu_to_be64(rctx->digcnt[0] << 3);
-		index = rctx->bufcnt & 0x3f;
+		index = rctx->digcnt[0] & 0x3f;
 		padlen = (index < 56) ? (56 - index) : ((64 + 56) - index);
-		*(rctx->buffer + rctx->bufcnt) = 0x80;
-		memset(rctx->buffer + rctx->bufcnt + 1, 0, padlen - 1);
-		memcpy(rctx->buffer + rctx->bufcnt + padlen, bits, 8);
-		rctx->bufcnt += padlen + 8;
-		break;
+		buf[0] = 0x80;
+		memset(buf + 1, 0, padlen - 1);
+		memcpy(buf + padlen, bits, 8);
+		return padlen + 8;
 	default:
 		bits[1] = cpu_to_be64(rctx->digcnt[0] << 3);
 		bits[0] = cpu_to_be64(rctx->digcnt[1] << 3 |
 				      rctx->digcnt[0] >> 61);
-		index = rctx->bufcnt & 0x7f;
+		index = rctx->digcnt[0] & 0x7f;
 		padlen = (index < 112) ? (112 - index) : ((128 + 112) - index);
-		*(rctx->buffer + rctx->bufcnt) = 0x80;
-		memset(rctx->buffer + rctx->bufcnt + 1, 0, padlen - 1);
-		memcpy(rctx->buffer + rctx->bufcnt + padlen, bits, 16);
-		rctx->bufcnt += padlen + 16;
-		break;
+		buf[0] = 0x80;
+		memset(buf + 1, 0, padlen - 1);
+		memcpy(buf + padlen, bits, 16);
+		return padlen + 16;
 	}
 }
 
@@ -117,31 +157,29 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	int length, remain;
+	unsigned int length, remain;
+	bool final = false;
 
-	length = rctx->total + rctx->bufcnt;
-	remain = length % rctx->block_size;
+	length = rctx->total - rctx->offset;
+	remain = length - round_down(length, rctx->block_size);
 
 	AHASH_DBG(hace_dev, "length:0x%x, remain:0x%x\n", length, remain);
 
-	if (rctx->bufcnt)
-		memcpy(hash_engine->ahash_src_addr, rctx->buffer, rctx->bufcnt);
+	if (length > ASPEED_HASH_SRC_DMA_BUF_LEN)
+		length = ASPEED_HASH_SRC_DMA_BUF_LEN;
+	else if (rctx->flags & SHA_FLAGS_FINUP) {
+		unsigned int total;
 
-	if (rctx->total + rctx->bufcnt < ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
-		scatterwalk_map_and_copy(hash_engine->ahash_src_addr +
-					 rctx->bufcnt, rctx->src_sg,
-					 rctx->offset, rctx->total - remain, 0);
-		rctx->offset += rctx->total - remain;
+		total = round_up(length, rctx->block_size) + rctx->block_size;
+		if (total > ASPEED_HASH_SRC_DMA_BUF_LEN)
+			length -= rctx->block_size - remain;
+		else
+			final = true;
+	} else
+		length -= remain;
+	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
+				 rctx->offset, length, 0);
 
-	} else {
-		dev_warn(hace_dev->dev, "Hash data length is too large\n");
-		return -EINVAL;
-	}
-
-	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg,
-				 rctx->offset, remain, 0);
-
-	rctx->bufcnt = remain;
 	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
 					       SHA512_DIGEST_SIZE,
 					       DMA_BIDIRECTIONAL);
@@ -150,7 +188,15 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 		return -ENOMEM;
 	}
 
-	hash_engine->src_length = length - remain;
+	rctx->digcnt[0] += length;
+	if (rctx->digcnt[0] < length)
+		rctx->digcnt[1]++;
+	rctx->offset += length;
+
+	if (final)
+		length += aspeed_ahash_fill_padding(
+			hace_dev, hash_engine->ahash_src_addr + length);
+	hash_engine->src_length = length;
 	hash_engine->src_dma = hash_engine->ahash_src_dma_addr;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
@@ -166,18 +212,22 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	int remain, sg_len, i, max_sg_nents;
 	struct aspeed_sg_list *src_list;
+	unsigned int length, total;
 	struct scatterlist *s;
-	int length, remain, sg_len, i;
+	bool final = false;
 	int rc = 0;
 
-	remain = (rctx->total + rctx->bufcnt) % rctx->block_size;
-	length = rctx->total + rctx->bufcnt - remain;
+	length = rctx->total - rctx->offset;
 
-	AHASH_DBG(hace_dev, "%s:0x%x, %s:%zu, %s:0x%x, %s:0x%x\n",
-		  "rctx total", rctx->total, "bufcnt", rctx->bufcnt,
-		  "length", length, "remain", remain);
+	AHASH_DBG(hace_dev, "%s:0x%x, %s:0x%x\n",
+		  "rctx total", rctx->total,
+		  "length", length);
 
+	max_sg_nents = ASPEED_HASH_SRC_DMA_BUF_LEN / sizeof(*src_list) - 1;
+	rctx->src_sg = rctx->next_sg;
+	rctx->src_nents = min(sg_nents(rctx->src_sg), max_sg_nents);
 	sg_len = dma_map_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
 			    DMA_TO_DEVICE);
 	if (!sg_len) {
@@ -196,10 +246,53 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 		goto free_src_sg;
 	}
 
-	if (rctx->bufcnt != 0) {
-		u32 phy_addr;
-		u32 len;
+	total = 0;
+	for_each_sg(rctx->src_sg, s, sg_len, i) {
+		u32 phy_addr = sg_dma_address(s);
+		u32 len = sg_dma_len(s);
 
+		if (length > len) {
+			length -= len;
+			total += len;
+		} else {
+			/* Last sg list */
+			len = length;
+			total += len;
+			length = 0;
+		}
+
+		src_list[i].phy_addr = cpu_to_le32(phy_addr);
+		src_list[i].len = cpu_to_le32(len);
+
+		if (!length)
+			break;
+	}
+
+	remain = total - round_down(total, rctx->block_size);
+	total -= remain;
+
+	if (length)
+		i = sg_len - 1;
+	length += remain;
+
+	if (!(rctx->flags & SHA_FLAGS_FINUP) || length >= rctx->block_size)
+		src_list[i].len |= cpu_to_le32(HASH_SG_LAST_LIST);
+	else {
+		memcpy_from_sglist(rctx->buffer, rctx->src_sg, total, length);
+		total += length;
+		final = true;
+	}
+
+	rctx->next_sg = sg_next(s);
+	rctx->digcnt[0] += total;
+	if (rctx->digcnt[0] < total)
+		rctx->digcnt[1]++;
+	rctx->offset += total;
+
+	if (final) {
+		int len = aspeed_ahash_fill_padding(hace_dev, rctx->buffer);
+
+		total += len;
 		rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
 						       rctx->buffer,
 						       rctx->block_size * 2,
@@ -210,54 +303,17 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 			goto free_rctx_digest;
 		}
 
-		phy_addr = rctx->buffer_dma_addr;
-		len = rctx->bufcnt;
-		length -= len;
-
-		/* Last sg list */
-		if (length == 0)
-			len |= HASH_SG_LAST_LIST;
-
-		src_list[0].phy_addr = cpu_to_le32(phy_addr);
-		src_list[0].len = cpu_to_le32(len);
-		src_list++;
+		i++;
+		src_list[i].phy_addr = cpu_to_le32(rctx->buffer_dma_addr);
+		src_list[i].len = cpu_to_le32(len);
 	}
 
-	if (length != 0) {
-		for_each_sg(rctx->src_sg, s, sg_len, i) {
-			u32 phy_addr = sg_dma_address(s);
-			u32 len = sg_dma_len(s);
-
-			if (length > len)
-				length -= len;
-			else {
-				/* Last sg list */
-				len = length;
-				len |= HASH_SG_LAST_LIST;
-				length = 0;
-			}
-
-			src_list[i].phy_addr = cpu_to_le32(phy_addr);
-			src_list[i].len = cpu_to_le32(len);
-		}
-	}
-
-	if (length != 0) {
-		rc = -EINVAL;
-		goto free_rctx_buffer;
-	}
-
-	rctx->offset = rctx->total - remain;
-	hash_engine->src_length = rctx->total + rctx->bufcnt - remain;
+	hash_engine->src_length = total;
 	hash_engine->src_dma = hash_engine->ahash_src_dma_addr;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
 	return 0;
 
-free_rctx_buffer:
-	if (rctx->bufcnt != 0)
-		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-				 rctx->block_size * 2, DMA_TO_DEVICE);
 free_rctx_digest:
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
@@ -272,37 +328,28 @@ static int aspeed_ahash_complete(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
+	struct aspeed_sham_reqctx *rctx;
 
 	AHASH_DBG(hace_dev, "\n");
 
-	hash_engine->flags &= ~CRYPTO_FLAGS_BUSY;
-
-	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req, 0);
-
-	return 0;
-}
-
-/*
- * Copy digest to the corresponding request result.
- * This function will be called at final() stage.
- */
-static int aspeed_ahash_transfer(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	AHASH_DBG(hace_dev, "\n");
-
+	rctx = ahash_request_ctx(req);
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
 
-	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-			 rctx->block_size * 2, DMA_TO_DEVICE);
+	if (rctx->total - rctx->offset >= rctx->block_size ||
+	    (rctx->total != rctx->offset && rctx->flags & SHA_FLAGS_FINUP))
+		return aspeed_ahash_req_update(hace_dev);
 
-	memcpy(req->result, rctx->digest, rctx->digsize);
+	hash_engine->flags &= ~CRYPTO_FLAGS_BUSY;
 
-	return aspeed_ahash_complete(hace_dev);
+	if (rctx->flags & SHA_FLAGS_FINUP)
+		memcpy(req->result, rctx->digest, rctx->digsize);
+
+	rctx = ahash_request_ctx(req);
+	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req,
+				     rctx->total - rctx->offset);
+
+	return 0;
 }
 
 /*
@@ -338,118 +385,6 @@ static int aspeed_hace_ahash_trigger(struct aspeed_hace_dev *hace_dev,
 	return -EINPROGRESS;
 }
 
-/*
- * HMAC resume aims to do the second pass produces
- * the final HMAC code derived from the inner hash
- * result and the outer key.
- */
-static int aspeed_ahash_hmac_resume(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-	int rc = 0;
-
-	AHASH_DBG(hace_dev, "\n");
-
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
-	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-			 rctx->block_size * 2, DMA_TO_DEVICE);
-
-	/* o key pad + hash sum 1 */
-	memcpy(rctx->buffer, bctx->opad, rctx->block_size);
-	memcpy(rctx->buffer + rctx->block_size, rctx->digest, rctx->digsize);
-
-	rctx->bufcnt = rctx->block_size + rctx->digsize;
-	rctx->digcnt[0] = rctx->block_size + rctx->digsize;
-
-	aspeed_ahash_fill_padding(hace_dev, rctx);
-	memcpy(rctx->digest, rctx->sha_iv, rctx->ivsize);
-
-	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
-					       SHA512_DIGEST_SIZE,
-					       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
-		rc = -ENOMEM;
-		goto end;
-	}
-
-	rctx->buffer_dma_addr = dma_map_single(hace_dev->dev, rctx->buffer,
-					       rctx->block_size * 2,
-					       DMA_TO_DEVICE);
-	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
-		rc = -ENOMEM;
-		goto free_rctx_digest;
-	}
-
-	hash_engine->src_dma = rctx->buffer_dma_addr;
-	hash_engine->src_length = rctx->bufcnt;
-	hash_engine->digest_dma = rctx->digest_dma_addr;
-
-	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
-
-free_rctx_digest:
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-end:
-	return rc;
-}
-
-static int aspeed_ahash_req_final(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	int rc = 0;
-
-	AHASH_DBG(hace_dev, "\n");
-
-	aspeed_ahash_fill_padding(hace_dev, rctx);
-
-	rctx->digest_dma_addr = dma_map_single(hace_dev->dev,
-					       rctx->digest,
-					       SHA512_DIGEST_SIZE,
-					       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
-		rc = -ENOMEM;
-		goto end;
-	}
-
-	rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
-					       rctx->buffer,
-					       rctx->block_size * 2,
-					       DMA_TO_DEVICE);
-	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
-		rc = -ENOMEM;
-		goto free_rctx_digest;
-	}
-
-	hash_engine->src_dma = rctx->buffer_dma_addr;
-	hash_engine->src_length = rctx->bufcnt;
-	hash_engine->digest_dma = rctx->digest_dma_addr;
-
-	if (rctx->flags & SHA_FLAGS_HMAC)
-		return aspeed_hace_ahash_trigger(hace_dev,
-						 aspeed_ahash_hmac_resume);
-
-	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
-
-free_rctx_digest:
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-end:
-	return rc;
-}
-
 static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
@@ -461,40 +396,12 @@ static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev *hace_dev)
 	dma_unmap_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
 		     DMA_TO_DEVICE);
 
-	if (rctx->bufcnt != 0)
+	if (rctx->flags & SHA_FLAGS_FINUP && rctx->total == rctx->offset)
 		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-				 rctx->block_size * 2,
-				 DMA_TO_DEVICE);
+				 rctx->block_size * 2, DMA_TO_DEVICE);
 
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
-	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg, rctx->offset,
-				 rctx->total - rctx->offset, 0);
-
-	rctx->bufcnt = rctx->total - rctx->offset;
 	rctx->cmd &= ~HASH_CMD_HASH_SRC_SG_CTRL;
 
-	if (rctx->flags & SHA_FLAGS_FINUP)
-		return aspeed_ahash_req_final(hace_dev);
-
-	return aspeed_ahash_complete(hace_dev);
-}
-
-static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	AHASH_DBG(hace_dev, "\n");
-
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
-	if (rctx->flags & SHA_FLAGS_FINUP)
-		return aspeed_ahash_req_final(hace_dev);
-
 	return aspeed_ahash_complete(hace_dev);
 }
 
@@ -513,7 +420,7 @@ static int aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev)
 		resume = aspeed_ahash_update_resume_sg;
 
 	} else {
-		resume = aspeed_ahash_update_resume;
+		resume = aspeed_ahash_complete;
 	}
 
 	ret = hash_engine->dma_prepare(hace_dev);
@@ -543,13 +450,32 @@ static int aspeed_ahash_do_request(struct crypto_engine *engine, void *areq)
 	hash_engine = &hace_dev->hash_engine;
 	hash_engine->flags |= CRYPTO_FLAGS_BUSY;
 
-	if (rctx->op == SHA_OP_UPDATE)
-		ret = aspeed_ahash_req_update(hace_dev);
-	else if (rctx->op == SHA_OP_FINAL)
-		ret = aspeed_ahash_req_final(hace_dev);
+	ret = aspeed_ahash_req_update(hace_dev);
 
-	if (ret != -EINPROGRESS)
+	if (ret && ret != -EINPROGRESS) {
+		HASH_FBREQ_ON_STACK(fbreq, areq);
+		u8 state[SHA512_STATE_SIZE];
+		struct scatterlist sg[2];
+		struct scatterlist *ssg;
+
+		ssg = scatterwalk_ffwd(sg, req->src, rctx->offset);
+		ahash_request_set_crypt(fbreq, ssg, req->result,
+					rctx->total - rctx->offset);
+
+		ret = aspeed_sham_export(req, state) ?:
+		      crypto_ahash_import_core(fbreq, state);
+
+		if (rctx->flags & SHA_FLAGS_FINUP) {
+			ret = ret ?: crypto_ahash_finup(fbreq);
+			goto out_zero_state;
+		}
+		ret = ret ?: crypto_ahash_update(fbreq);
+			     crypto_ahash_export_core(fbreq, state) ?:
+			     aspeed_sham_import(req, state);
+out_zero_state:
+		memzero_explicit(state, sizeof(state));
 		return ret;
+	}
 
 	return 0;
 }
@@ -588,47 +514,8 @@ static int aspeed_sham_update(struct ahash_request *req)
 	AHASH_DBG(hace_dev, "req->nbytes: %d\n", req->nbytes);
 
 	rctx->total = req->nbytes;
-	rctx->src_sg = req->src;
+	rctx->next_sg = req->src;
 	rctx->offset = 0;
-	rctx->src_nents = sg_nents(req->src);
-	rctx->op = SHA_OP_UPDATE;
-
-	rctx->digcnt[0] += rctx->total;
-	if (rctx->digcnt[0] < rctx->total)
-		rctx->digcnt[1]++;
-
-	if (rctx->bufcnt + rctx->total < rctx->block_size) {
-		scatterwalk_map_and_copy(rctx->buffer + rctx->bufcnt,
-					 rctx->src_sg, rctx->offset,
-					 rctx->total, 0);
-		rctx->bufcnt += rctx->total;
-
-		return 0;
-	}
-
-	return aspeed_hace_hash_handle_queue(hace_dev, req);
-}
-
-static int aspeed_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
-				    const u8 *data, unsigned int len, u8 *out)
-{
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, data, len, out);
-}
-
-static int aspeed_sham_final(struct ahash_request *req)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-
-	AHASH_DBG(hace_dev, "req->nbytes:%d, rctx->total:%d\n",
-		  req->nbytes, rctx->total);
-	rctx->op = SHA_OP_FINAL;
 
 	return aspeed_hace_hash_handle_queue(hace_dev, req);
 }
@@ -639,23 +526,11 @@ static int aspeed_sham_finup(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	int rc1, rc2;
 
 	AHASH_DBG(hace_dev, "req->nbytes: %d\n", req->nbytes);
 
 	rctx->flags |= SHA_FLAGS_FINUP;
-
-	rc1 = aspeed_sham_update(req);
-	if (rc1 == -EINPROGRESS || rc1 == -EBUSY)
-		return rc1;
-
-	/*
-	 * final() has to be always called to cleanup resources
-	 * even if update() failed, except EINPROGRESS
-	 */
-	rc2 = aspeed_sham_final(req);
-
-	return rc1 ? : rc2;
+	return aspeed_sham_update(req);
 }
 
 static int aspeed_sham_init(struct ahash_request *req)
@@ -664,7 +539,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
 
 	AHASH_DBG(hace_dev, "%s: digest size:%d\n",
 		  crypto_tfm_alg_name(&tfm->base),
@@ -679,7 +553,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA1;
 		rctx->digsize = SHA1_DIGEST_SIZE;
 		rctx->block_size = SHA1_BLOCK_SIZE;
-		rctx->sha_iv = sha1_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha1_iv, rctx->ivsize);
 		break;
@@ -688,7 +561,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA224;
 		rctx->digsize = SHA224_DIGEST_SIZE;
 		rctx->block_size = SHA224_BLOCK_SIZE;
-		rctx->sha_iv = sha224_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha224_iv, rctx->ivsize);
 		break;
@@ -697,7 +569,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA256;
 		rctx->digsize = SHA256_DIGEST_SIZE;
 		rctx->block_size = SHA256_BLOCK_SIZE;
-		rctx->sha_iv = sha256_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha256_iv, rctx->ivsize);
 		break;
@@ -707,7 +578,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA384;
 		rctx->digsize = SHA384_DIGEST_SIZE;
 		rctx->block_size = SHA384_BLOCK_SIZE;
-		rctx->sha_iv = (const __be32 *)sha384_iv;
 		rctx->ivsize = 64;
 		memcpy(rctx->digest, sha384_iv, rctx->ivsize);
 		break;
@@ -717,7 +587,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA512;
 		rctx->digsize = SHA512_DIGEST_SIZE;
 		rctx->block_size = SHA512_BLOCK_SIZE;
-		rctx->sha_iv = (const __be32 *)sha512_iv;
 		rctx->ivsize = 64;
 		memcpy(rctx->digest, sha512_iv, rctx->ivsize);
 		break;
@@ -727,19 +596,10 @@ static int aspeed_sham_init(struct ahash_request *req)
 		return -EINVAL;
 	}
 
-	rctx->bufcnt = 0;
 	rctx->total = 0;
 	rctx->digcnt[0] = 0;
 	rctx->digcnt[1] = 0;
 
-	/* HMAC init */
-	if (tctx->flags & SHA_FLAGS_HMAC) {
-		rctx->digcnt[0] = rctx->block_size;
-		rctx->bufcnt = rctx->block_size;
-		memcpy(rctx->buffer, bctx->ipad, rctx->block_size);
-		rctx->flags |= SHA_FLAGS_HMAC;
-	}
-
 	return 0;
 }
 
@@ -748,102 +608,14 @@ static int aspeed_sham_digest(struct ahash_request *req)
 	return aspeed_sham_init(req) ? : aspeed_sham_finup(req);
 }
 
-static int aspeed_sham_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
+static int aspeed_sham_cra_init(struct crypto_ahash *tfm)
 {
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-	int ds = crypto_shash_digestsize(bctx->shash);
-	int bs = crypto_shash_blocksize(bctx->shash);
-	int err = 0;
-	int i;
-
-	AHASH_DBG(hace_dev, "%s: keylen:%d\n", crypto_tfm_alg_name(&tfm->base),
-		  keylen);
-
-	if (keylen > bs) {
-		err = aspeed_sham_shash_digest(bctx->shash,
-					       crypto_shash_get_flags(bctx->shash),
-					       key, keylen, bctx->ipad);
-		if (err)
-			return err;
-		keylen = ds;
-
-	} else {
-		memcpy(bctx->ipad, key, keylen);
-	}
-
-	memset(bctx->ipad + keylen, 0, bs - keylen);
-	memcpy(bctx->opad, bctx->ipad, bs);
-
-	for (i = 0; i < bs; i++) {
-		bctx->ipad[i] ^= HMAC_IPAD_VALUE;
-		bctx->opad[i] ^= HMAC_OPAD_VALUE;
-	}
-
-	return err;
-}
-
-static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
-{
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
-	struct aspeed_sham_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct aspeed_hace_alg *ast_alg;
 
 	ast_alg = container_of(alg, struct aspeed_hace_alg, alg.ahash.base);
 	tctx->hace_dev = ast_alg->hace_dev;
-	tctx->flags = 0;
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct aspeed_sham_reqctx));
-
-	if (ast_alg->alg_base) {
-		/* hmac related */
-		struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-
-		tctx->flags |= SHA_FLAGS_HMAC;
-		bctx->shash = crypto_alloc_shash(ast_alg->alg_base, 0,
-						 CRYPTO_ALG_NEED_FALLBACK);
-		if (IS_ERR(bctx->shash)) {
-			dev_warn(ast_alg->hace_dev->dev,
-				 "base driver '%s' could not be loaded.\n",
-				 ast_alg->alg_base);
-			return PTR_ERR(bctx->shash);
-		}
-	}
-
-	return 0;
-}
-
-static void aspeed_sham_cra_exit(struct crypto_tfm *tfm)
-{
-	struct aspeed_sham_ctx *tctx = crypto_tfm_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-
-	AHASH_DBG(hace_dev, "%s\n", crypto_tfm_alg_name(tfm));
-
-	if (tctx->flags & SHA_FLAGS_HMAC) {
-		struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-
-		crypto_free_shash(bctx->shash);
-	}
-}
-
-static int aspeed_sham_export(struct ahash_request *req, void *out)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	memcpy(out, rctx, sizeof(*rctx));
-
-	return 0;
-}
-
-static int aspeed_sham_import(struct ahash_request *req, const void *in)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	memcpy(rctx, in, sizeof(*rctx));
 
 	return 0;
 }
@@ -853,11 +625,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -867,13 +639,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA1_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -885,11 +657,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -899,13 +671,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA256_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -917,11 +689,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -931,118 +703,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA224_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha1",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA1_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha1)",
-					.cra_driver_name	= "aspeed-hmac-sha1",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA1_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha224",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha224)",
-					.cra_driver_name	= "aspeed-hmac-sha224",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA224_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha256",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha256)",
-					.cra_driver_name	= "aspeed-hmac-sha256",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA256_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -1057,11 +724,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -1071,13 +738,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA384_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -1089,11 +756,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
 			.import	= aspeed_sham_import,
+			.init_tfm = aspeed_sham_cra_init,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
 				.statesize = sizeof(struct aspeed_sham_reqctx),
@@ -1103,83 +770,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA512_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
+					.cra_reqsize		= sizeof(struct aspeed_sham_reqctx),
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha384",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha384)",
-					.cra_driver_name	= "aspeed-hmac-sha384",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA384_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha512",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA512_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha512)",
-					.cra_driver_name	= "aspeed-hmac-sha512",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index 68f70e01fccb..b7fc8433e021 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -119,7 +119,6 @@
 #define SHA_FLAGS_SHA512		BIT(4)
 #define SHA_FLAGS_SHA512_224		BIT(5)
 #define SHA_FLAGS_SHA512_256		BIT(6)
-#define SHA_FLAGS_HMAC			BIT(8)
 #define SHA_FLAGS_FINUP			BIT(9)
 #define SHA_FLAGS_MASK			(0xff)
 
@@ -161,44 +160,37 @@ struct aspeed_engine_hash {
 	aspeed_hace_fn_t		dma_prepare;
 };
 
-struct aspeed_sha_hmac_ctx {
-	struct crypto_shash *shash;
-	u8 ipad[SHA512_BLOCK_SIZE];
-	u8 opad[SHA512_BLOCK_SIZE];
-};
-
 struct aspeed_sham_ctx {
 	struct aspeed_hace_dev		*hace_dev;
-	unsigned long			flags;	/* hmac flag */
-
-	struct aspeed_sha_hmac_ctx	base[];
 };
 
 struct aspeed_sham_reqctx {
-	unsigned long		flags;		/* final update flag should no use*/
-	unsigned long		op;		/* final or update */
-	u32			cmd;		/* trigger cmd */
+	/* DMA buffer written by hardware */
+	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
 
-	/* walk state */
-	struct scatterlist	*src_sg;
-	int			src_nents;
-	unsigned int		offset;		/* offset in current sg */
-	unsigned int		total;		/* per update length */
+	/* Software state */
+	u64			digcnt[2];
+
+	dma_addr_t		digest_dma_addr;
+	dma_addr_t              buffer_dma_addr;
 
 	size_t			digsize;
 	size_t			block_size;
 	size_t			ivsize;
-	const __be32		*sha_iv;
 
-	/* remain data buffer */
-	u8			buffer[SHA512_BLOCK_SIZE * 2];
-	dma_addr_t		buffer_dma_addr;
-	size_t			bufcnt;		/* buffer counter */
+	unsigned long		flags;		/* final update flag should no use*/
 
-	/* output buffer */
-	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
-	dma_addr_t		digest_dma_addr;
-	u64			digcnt[2];
+	/* walk state */
+	struct scatterlist	*src_sg;
+	struct scatterlist	*next_sg;
+	int			src_nents;
+	unsigned int		offset;		/* offset in current sg */
+	unsigned int		total;		/* per update length */
+
+	u32			cmd;		/* trigger cmd */
+
+	/* This is DMA too but read-only for hardware. */
+	u8			buffer[SHA512_BLOCK_SIZE];
 };
 
 struct aspeed_engine_crypto {
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
