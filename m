Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7D1377ECE;
	Thu, 30 Apr 2026 06:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531076; cv=none; b=U0niPKWxkmmBjnmLZJfNP8HdHujTahnpjhM+v6wk5dSSjS0o8WpL958kgteuE3BuijjFKxiEcw0YNH6GAGuda/lUxBcCWy+B/4xD/zrpn6F/RYRRXoz30hoi5gxSxAEBROR68d+qslBVFO++IkUkAuLgJnVeCXgBRrn7oRABcOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531076; c=relaxed/simple;
	bh=NfI1N+paMOEo3f7FDWUMfzB5wyqiHQOHRmOt9fCK6/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1DW5JiroEv70pm9v6GeIK2GpnhSoAa9K2Yh08NmGG8u+HRW7ZlvF6MrHFKnKt4jmAJyd9UYLO1ck0K6B/Q0pqmh4AKuiRv8AT9FSx/nV8LXtsCwGIWaBhJBg4/PQpDS/oREKci1G39GN1xFoT4oo2mXxRlmOB5xFuzBTrOUTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2e8vZPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2e8vZPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925E7C2BCC4;
	Thu, 30 Apr 2026 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531075;
	bh=NfI1N+paMOEo3f7FDWUMfzB5wyqiHQOHRmOt9fCK6/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2e8vZPWOrNlOMIubuXYY4+u6XWz/+k/Z12uBSKZaoNfNQMPxIaBmRBGSvSF0vGzT
	 3giKIuAkVbEWbY2R8kNduZVWUUDVPRpnRHu/4F7wZdTGHkmeqX6Wxt5edZykR3Yf+M
	 63k0DhhQ+2teEfAZMyB0bjc4tjuuHAmoouWK3ZfzGa6H1eeuqCqBE5hduz6zHI4ZGE
	 bt04EOZnOgo9kihRm01f3YGMgPY8BGei3V48r/fgkYuuNhQuemZ1MloTnHHcbpXfC1
	 CjwSiRJTOi3ojjVu+yrBaTeDfMNl47IgRjmdKE9ri4N27qxbmlNqej1qbiq/V7XOOf
	 QJa9KxujL+qJw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taeyang Lee <0wn@theori.io>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 6/9] crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption
Date: Wed, 29 Apr 2026 23:36:01 -0700
Message-ID: <20260430063604.173525-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430063604.173525-1-ebiggers@kernel.org>
References: <20260430063604.173525-1-ebiggers@kernel.org>
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
index fceee6d67d34..5dc057cb0cdf 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -212,34 +212,39 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	struct crypto_ahash *auth = ctx->auth;
 	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
 			      crypto_ahash_alignmask(auth) + 1);
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
 
 static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
@@ -262,35 +267,40 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
 			      crypto_ahash_alignmask(auth) + 1);
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

