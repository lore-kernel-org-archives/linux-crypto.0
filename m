Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C4B374730;
	Thu, 30 Apr 2026 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529356; cv=none; b=mmorx8wzwsd5kR1g+Vbdo7iie8OU7QOZd6mCd3B+lmhV9IrGPyXeyJJEYt3rflDbYHBP6W6xbIgwyuY63OpstTE5BbxXSfyjfCVPjCHbXy9lI2Uy39XXvTZgSb/3Pvufl5ysfhAoBYPVLAfEn/SXhyx2hpQCJyA12BiMWR/Qumk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529356; c=relaxed/simple;
	bh=WwVmN4uK4wR+y8M0twsw/OZjuTYqMarVaVxD1+XS3SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOLUMMXAyIg5O4qu4a5dnloG7GHp0zgnUIbIm/inn9++flQIh0ZG3u6h3bEFkPa0fPkiQABvfjbCIahkGtFV/BH3+f6JlGJjeg0IPi86NfD1olY0cmi9VS1mrsek10p2D7caQ9qPOyIZ6NjPgfg3EEUKZqpF29J9thSC/g0Lrc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKexESYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKexESYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E69C2BCC7;
	Thu, 30 Apr 2026 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777529356;
	bh=WwVmN4uK4wR+y8M0twsw/OZjuTYqMarVaVxD1+XS3SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKexESYb7uZJsEIZdXnBTc2NZdfncIwxDhM+KT0YDec6pfrpHyyYoNDkoD0Fp0fwW
	 K2vpFyG99CQJn7KobKdihzLQzm7nyiUpVVmdk3vSb/tPd5zqvuEEaB5AfS1uDOcA85
	 LyAw99VMQU1yXb106jeDF4BJtTrQ3WZcMHyc3AxZEN9/PNzoXHCnYieb4yIsuOBdmZ
	 cWEegnGSi2YcXIV8wQzDS5Sy7jIc25yZg59z890qgh0JBEy03ZtCB60pDTRuQylQ6B
	 OFaNUV36qBrYK2NLQWHeQtjeSM7SStk0trbxT9Aqatbpu+JfQGQt1z3mKmG2nnL2Lv
	 elrH1v0yIw6uw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taeyang Lee <0wn@theori.io>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 6/8] crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption
Date: Wed, 29 Apr 2026 23:07:00 -0700
Message-ID: <20260430060702.110091-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430060702.110091-1-ebiggers@kernel.org>
References: <20260430060702.110091-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit e02494114ebf7c8b42777c6cd6982f113bfdbec7 upstream.

When decrypting data that is not in-place (src != dst), there is
no need to save the high-order sequence bits in dst as it could
simply be re-copied from the source.

However, the data to be hashed need to be rearranged accordingly.

Reported-by: Taeyang Lee <0wn@theori.io>
Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/authencesn.c | 48 +++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index a5fbb638d9d7..257af38ac4de 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -205,34 +205,39 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 						  ctx->reqoff);
 	struct crypto_ahash *auth = ctx->auth;
 	u8 *ohash = areq_ctx->tail;
 	unsigned int cryptlen = req->cryptlen - authsize;
 	unsigned int assoclen = req->assoclen;
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	u32 tmp[2];
 
 	if (!authsize)
 		goto decrypt;
 
-	/* Move high-order bits of sequence number back. */
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	if (src == dst) {
+		/* Move high-order bits of sequence number back. */
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	} else
+		memcpy_sglist(dst, src, assoclen);
 
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
 
 decrypt:
 
-	sg_init_table(areq_ctx->dst, 2);
+	if (src != dst)
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
-	skcipher_request_set_crypt(skreq, dst, dst, cryptlen, req->iv);
+	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
 
 	return crypto_skcipher_decrypt(skreq);
 }
 
 static void authenc_esn_verify_ahash_done(void *data, int err)
@@ -253,35 +258,40 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	struct crypto_ahash *auth = ctx->auth;
 	u8 *ohash = areq_ctx->tail;
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 	int err;
 
 	if (assoclen < 8)
 		return -EINVAL;
 
-	cryptlen -= authsize;
-
-	if (req->src != dst)
-		memcpy_sglist(dst, req->src, assoclen + cryptlen);
+	if (!authsize)
+		goto tail;
 
+	cryptlen -= authsize;
 	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
 				 authsize, 0);
 
-	if (!authsize)
-		goto tail;
-
 	/* Move high-order bits of sequence number to the end. */
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
-
-	sg_init_table(areq_ctx->dst, 2);
-	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	scatterwalk_map_and_copy(tmp, src, 0, 8, 0);
+	if (src == dst) {
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	} else {
+		scatterwalk_map_and_copy(tmp, dst, 0, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen - 4, 4, 1);
+
+		src = scatterwalk_ffwd(areq_ctx->src, src, 8);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+		memcpy_sglist(dst, src, assoclen + cryptlen - 8);
+		dst = req->dst;
+	}
 
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, dst, ohash, assoclen + cryptlen);
 	ahash_request_set_callback(ahreq, aead_request_flags(req),
 				   authenc_esn_verify_ahash_done, req);
-- 
2.54.0

