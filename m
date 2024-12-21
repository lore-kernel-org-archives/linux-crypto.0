Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE25D1F237C
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=SAzqcCrKjdIKFwMN0bG5PHnihIUUjFsPu1KnkoeBdH7gaJ6+vd2HAYRqIKbv+zYV0kei3tp5hekmJ+IfB8P6A6RRNss/t0ijL2pQZqDkfx8oZo2tmLErRdDyS3TD7gdfDXomySYJrcjUsNEbDT/XQH7NbT8x5oY7mlwp4FvlrpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=Tid3uWR33zstKwWKrQjCdNjEr2JkFhqZE4IB1spq8hc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNK+t+3UMxo6nk4yiyYusprK/6vgaMouOge8CYE0KMaq7Dhab74n/xOSacmqoi7ea7nzKCaWL0Nxj11fizIlNgcBmtIadhcPOiCLW2b2KmMymuv1HFZJZ8RxSd6k2SFw+PfSYeuVfocsAk0M0NkIryVKho1OdbTxMJfLTko1UW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkzPDXJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkzPDXJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D8BC4CEDD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772294;
	bh=Tid3uWR33zstKwWKrQjCdNjEr2JkFhqZE4IB1spq8hc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FkzPDXJxo7GeSpcDcuxd3ohOIMj/pMgsrmdXVXtXXB9wP1P/bnA7sltQHWGUNJ+Ov
	 lJBXL83cSvLa3P9L9CtLwPWv00Mj4s8e6ldBG3LgIzNbQnQMxU1qmk+gc38W3xpnYP
	 8eNbR8FTVZ4ZKGVeoHYWD0hx8lM1YmlIuVYus/FbQkenhUdNl68RNd/L1IJg6aU36s
	 YfQtzT1HfG0KSFmcKIW08tE5PXumDaeGeZf9AnpeRjuWyIheAFIeSFAQvPqF9hsaB+
	 yUZD9M/1lQCyD5SS6/jD3y8dvWXmYBl0+9WxAaD7azqhxcTrnJwaL+0IJlR4p3OxxD
	 w2QQYZXHFdF4A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 19/29] crypto: keywrap - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:46 -0800
Message-ID: <20241221091056.282098-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Replace calls to the deprecated function scatterwalk_copychunks() with
memcpy_{from,to}_scatterwalk(), or just memcpy_{from,to}_sglist().

Since scatterwalk_copychunks() was incorrectly being called without
being followed by scatterwalk_done(), this also fixes a bug where the
dcache of the destination page(s) was not being flushed on architectures
that need that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/keywrap.c | 48 ++++++------------------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 5ec4f94d46bd..700b7b79a93d 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -92,37 +92,10 @@ struct crypto_kw_block {
 #define SEMIBSIZE 8
 	__be64 A;
 	__be64 R;
 };
 
-/*
- * Fast forward the SGL to the "end" length minus SEMIBSIZE.
- * The start in the SGL defined by the fast-forward is returned with
- * the walk variable
- */
-static void crypto_kw_scatterlist_ff(struct scatter_walk *walk,
-				     struct scatterlist *sg,
-				     unsigned int end)
-{
-	unsigned int skip = 0;
-
-	/* The caller should only operate on full SEMIBLOCKs. */
-	BUG_ON(end < SEMIBSIZE);
-
-	skip = end - SEMIBSIZE;
-	while (sg) {
-		if (sg->length > skip) {
-			scatterwalk_start(walk, sg);
-			scatterwalk_advance(walk, skip);
-			break;
-		}
-
-		skip -= sg->length;
-		sg = sg_next(sg);
-	}
-}
-
 static int crypto_kw_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	struct crypto_kw_block block;
@@ -148,34 +121,27 @@ static int crypto_kw_decrypt(struct skcipher_request *req)
 	 */
 	src = req->src;
 	dst = req->dst;
 
 	for (i = 0; i < 6; i++) {
-		struct scatter_walk src_walk, dst_walk;
 		unsigned int nbytes = req->cryptlen;
 
 		while (nbytes) {
-			/* move pointer by nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&src_walk, src, nbytes);
+			nbytes -= SEMIBSIZE;
+
 			/* get the source block */
-			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
-					       false);
+			memcpy_from_sglist(&block.R, src, nbytes, SEMIBSIZE);
 
 			/* perform KW operation: modify IV with counter */
 			block.A ^= cpu_to_be64(t);
 			t--;
 			/* perform KW operation: decrypt block */
 			crypto_cipher_decrypt_one(cipher, (u8 *)&block,
 						  (u8 *)&block);
 
-			/* move pointer by nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&dst_walk, dst, nbytes);
 			/* Copy block->R into place */
-			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
-					       true);
-
-			nbytes -= SEMIBSIZE;
+			memcpy_to_sglist(dst, nbytes, &block.R, SEMIBSIZE);
 		}
 
 		/* we now start to operate on the dst SGL only */
 		src = req->dst;
 		dst = req->dst;
@@ -229,23 +195,21 @@ static int crypto_kw_encrypt(struct skcipher_request *req)
 		scatterwalk_start(&src_walk, src);
 		scatterwalk_start(&dst_walk, dst);
 
 		while (nbytes) {
 			/* get the source block */
-			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
-					       false);
+			memcpy_from_scatterwalk(&block.R, &src_walk, SEMIBSIZE);
 
 			/* perform KW operation: encrypt block */
 			crypto_cipher_encrypt_one(cipher, (u8 *)&block,
 						  (u8 *)&block);
 			/* perform KW operation: modify IV with counter */
 			block.A ^= cpu_to_be64(t);
 			t++;
 
 			/* Copy block->R into place */
-			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
-					       true);
+			memcpy_to_scatterwalk(&dst_walk, &block.R, SEMIBSIZE);
 
 			nbytes -= SEMIBSIZE;
 		}
 
 		/* we now start to operate on the dst SGL only */
-- 
2.47.1

