Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF3262FC0;
	Thu, 11 Dec 2025 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416056; cv=none; b=fZUy8SSKGjW/u3m7W9MCX6XZsChXeGtxtsuQIjf6itfgSTwrWoYDGeI43WlTAqxlFrnzZHuWw0pw0bR35A5BIIcNkKJFyzecHL7A74YvQGjifFJKb2hYm1Wbm2hpSCVXLUIkYv5ySjAPl9yTGOnsgX1leKoFBU95B1M9BG7ZdxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416056; c=relaxed/simple;
	bh=onANQhEwtvrw+cy6TRC7cmRjkfIZ8qsWJbXDQ34RlFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DUcYqP/znBupraZ1dHEsDLLMSDeYVqVw4Uy//HV1S9YlazzrYITET0lOMTpqpvMAATm/j+r01gLZXDBSsmCXrF9kvRNQ3XNEDF0QzzSnDsca8JhqXlcDGLK7CFIhLsunwz3FUD9U4mo0LdXwTIaU0AJ8Ks7gIZyKvf2TXL7OmT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTNAoBZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTNAoBZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBEBC4CEF7;
	Thu, 11 Dec 2025 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416055;
	bh=onANQhEwtvrw+cy6TRC7cmRjkfIZ8qsWJbXDQ34RlFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTNAoBZQd2c+wa4Nq0ztoPr7lKhdWTsoBS9yHf06SVXxEeq58TfLq6Y4CC0ukBw71
	 kFDBv4X7IdLvrkgq884PSpUeTUMbSofy1yYYTQwvCnKyubE3hDlN0SJugJfwpGvpxd
	 VhWudBFqEgrHW5GbHbg8l9utmgpEcw3Rh97kZdkm+F2e02KlgeNICGo/chsM8ImNQe
	 idNguk/kP2WmW6IE3JKwEBYtqsaXrB8vXmFVioks6Aoa7kYfdrcCXtlftSi4T7Pls2
	 ZpsG+RBrzfl5ZGtvFK6ARpcpXX3dFwqJiPjS5+rMFDLlGo30W8N5CcyDFNCsoX2Wna
	 G0XAIHMlVP7GA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/12] crypto: adiantum - Use scatter_walk API instead of sg_miter
Date: Wed, 10 Dec 2025 17:18:39 -0800
Message-ID: <20251211011846.8179-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make adiantum_hash_message() use the scatter_walk API instead of
sg_miter.  scatter_walk is a bit simpler and also more efficient.  For
example, unlike sg_miter, scatter_walk doesn't require that the number
of scatterlist entries be calculated up-front.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/adiantum.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index bbe519fbd739..519e95228ad8 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -367,30 +367,27 @@ static void nhpoly1305_final(struct nhpoly1305_ctx *ctx,
  * evaluated as a polynomial in GF(2^{130}-5), like in the Poly1305 MAC.  Note
  * that the polynomial evaluation by itself would suffice to achieve the ε-∆U
  * property; NH is used for performance since it's much faster than Poly1305.
  */
 static void adiantum_hash_message(struct skcipher_request *req,
-				  struct scatterlist *sgl, unsigned int nents,
-				  le128 *out)
+				  struct scatterlist *sgl, le128 *out)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	struct sg_mapping_iter miter;
-	unsigned int i, n;
+	unsigned int len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	struct scatter_walk walk;
 
 	nhpoly1305_init(&rctx->u.hash_ctx);
+	scatterwalk_start(&walk, sgl);
+	while (len) {
+		unsigned int n = scatterwalk_next(&walk, len);
 
-	sg_miter_start(&miter, sgl, nents, SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	for (i = 0; i < bulk_len; i += n) {
-		sg_miter_next(&miter);
-		n = min_t(unsigned int, miter.length, bulk_len - i);
-		nhpoly1305_update(&rctx->u.hash_ctx, tctx, miter.addr, n);
+		nhpoly1305_update(&rctx->u.hash_ctx, tctx, walk.addr, n);
+		scatterwalk_done_src(&walk, n);
+		len -= n;
 	}
-	sg_miter_stop(&miter);
-
 	nhpoly1305_final(&rctx->u.hash_ctx, tctx, out);
 }
 
 /* Continue Adiantum encryption/decryption after the stream cipher step */
 static int adiantum_finish(struct skcipher_request *req)
@@ -398,11 +395,10 @@ static int adiantum_finish(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct scatterlist *dst = req->dst;
-	const unsigned int dst_nents = sg_nents(dst);
 	le128 digest;
 
 	/* If decrypting, decrypt C_M with the block cipher to get P_M */
 	if (!rctx->enc)
 		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
@@ -412,11 +408,12 @@ static int adiantum_finish(struct skcipher_request *req)
 	 * Second hash step
 	 *	enc: C_R = C_M - H_{K_H}(T, C_L)
 	 *	dec: P_R = P_M - H_{K_H}(T, P_L)
 	 */
 	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
-	if (dst_nents == 1 && dst->offset + req->cryptlen <= PAGE_SIZE) {
+	if (dst->length >= req->cryptlen &&
+	    dst->offset + req->cryptlen <= PAGE_SIZE) {
 		/* Fast path for single-page destination */
 		struct page *page = sg_page(dst);
 		void *virt = kmap_local_page(page) + dst->offset;
 
 		nhpoly1305_init(&rctx->u.hash_ctx);
@@ -426,11 +423,11 @@ static int adiantum_finish(struct skcipher_request *req)
 		memcpy(virt + bulk_len, &rctx->rbuf.bignum, sizeof(le128));
 		flush_dcache_page(page);
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any destination scatterlist */
-		adiantum_hash_message(req, dst, dst_nents, &digest);
+		adiantum_hash_message(req, dst, &digest);
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
 					 bulk_len, sizeof(le128), 1);
 	}
 	return 0;
@@ -451,11 +448,10 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct scatterlist *src = req->src;
-	const unsigned int src_nents = sg_nents(src);
 	unsigned int stream_len;
 	le128 digest;
 
 	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
 		return -EINVAL;
@@ -466,22 +462,23 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	 * First hash step
 	 *	enc: P_M = P_R + H_{K_H}(T, P_L)
 	 *	dec: C_M = C_R + H_{K_H}(T, C_L)
 	 */
 	adiantum_hash_header(req);
-	if (src_nents == 1 && src->offset + req->cryptlen <= PAGE_SIZE) {
+	if (src->length >= req->cryptlen &&
+	    src->offset + req->cryptlen <= PAGE_SIZE) {
 		/* Fast path for single-page source */
 		void *virt = kmap_local_page(sg_page(src)) + src->offset;
 
 		nhpoly1305_init(&rctx->u.hash_ctx);
 		nhpoly1305_update(&rctx->u.hash_ctx, tctx, virt, bulk_len);
 		nhpoly1305_final(&rctx->u.hash_ctx, tctx, &digest);
 		memcpy(&rctx->rbuf.bignum, virt + bulk_len, sizeof(le128));
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any source scatterlist */
-		adiantum_hash_message(req, src, src_nents, &digest);
+		adiantum_hash_message(req, src, &digest);
 		scatterwalk_map_and_copy(&rctx->rbuf.bignum, src,
 					 bulk_len, sizeof(le128), 0);
 	}
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
-- 
2.52.0

