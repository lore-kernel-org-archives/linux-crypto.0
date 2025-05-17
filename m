Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8330415B135;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448718; cv=none; b=d4ujfF2fZX0DtrOOhk51YAKgYbb/QAbGaC3tUqP3n3vDcXUohDZWi1jGlTFzyB/bGKcTbl/vgTQ9ZjX1Ksm7momvauWkPEMfLUI6FB/HDHvAXGtVFu4WcMRKqhOchddSF/G4YZ5wpwT6cZtZtYhZhBfAvLdVU+AFXbKXk7lrklg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448718; c=relaxed/simple;
	bh=MQJYpC1dIjU+BppMsjIhJ5EZohiOBOMHzgF7MVI7/38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXRSYvHa8TfG3URG6XQLOZ8twr9bMTjSGMLVnkkSO4AdCe0q//HizTv6AgF8AKJDrb++SB+OT0JyM97NT+iDWeKmPjnZsLOzs4D1b1C+n5G88U6MhNLU592o6AvQ/8WbckOlAoAxi6t2/9EL9Vq/hwsKSnBbhvEGjDh6u13C5BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEuZHwQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEuZHwQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571B7C4CEF9;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448718;
	bh=MQJYpC1dIjU+BppMsjIhJ5EZohiOBOMHzgF7MVI7/38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEuZHwQQkEkvnz3EIPIZTvVxzLAZZ7mPVccjciQhCE/Jkoh7EI88DhZcs7n82EG8Y
	 8zt0dqtvNvA6tX7xTReehsFWWmjjMtt1quQETlilHWR5UG0bbQFhYLTwl2KO6zTR4j
	 lQx1uEB7kPHNtzukiThtM/aqFfzyuBb0hBWG8J7ObHqCrN8hgVpmyXWnscw/pel46O
	 E/puFsvxhxhOQOPyaHFzhxgQ6gTuDGKaF/DeAq3NaFamuoV8oARUgKcy4yV9u/e0W1
	 C6iMsQ+aqgyQS9I9cum9OERTZZHd83UHuOpL5txy4LrbdWc9b2rX4Fi407ItQKHU1T
	 XWo2HFKMVcvUQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Revert "crypto: sha256 - Use the partial block API for generic"
Date: Fri, 16 May 2025 19:24:27 -0700
Message-ID: <20250517022428.401622-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517022428.401622-1-ebiggers@kernel.org>
References: <20250517022428.401622-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This reverts commit ff8f037d394f0900597ba527388a6eb95cd02695 which got
pushed out despite being nacked.

The library API already has to handle partial blocks, and it makes a lot
more sense to just use that.

Keep sha256_block_init() since drivers/crypto/padlock-sha.c is using it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/sha256.c       | 79 ++++++++++++++++++++-----------------------
 include/crypto/sha2.h |  7 +---
 2 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index cf190114574ea..47ad7e4cc55f7 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -28,68 +28,48 @@ const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
 };
 EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
 static int crypto_sha256_init(struct shash_desc *desc)
 {
-	sha256_block_init(shash_desc_ctx(desc));
+	sha256_init(shash_desc_ctx(desc));
 	return 0;
 }
 
-static inline int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
-				       unsigned int len, bool force_generic)
-{
-	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
-	int remain = len % SHA256_BLOCK_SIZE;
-
-	sctx->count += len - remain;
-	sha256_choose_blocks(sctx->state, data, len / SHA256_BLOCK_SIZE,
-			     force_generic, !force_generic);
-	return remain;
-}
-
 static int crypto_sha256_update_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len)
 {
-	return crypto_sha256_update(desc, data, len, true);
+	sha256_update_generic(shash_desc_ctx(desc), data, len);
+	return 0;
 }
 
 static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
 				     unsigned int len)
 {
 	sha256_update(shash_desc_ctx(desc), data, len);
 	return 0;
 }
 
-static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
+static int crypto_sha256_final_generic(struct shash_desc *desc, u8 *out)
 {
-	sha256_final(shash_desc_ctx(desc), out);
+	sha256_final_generic(shash_desc_ctx(desc), out);
 	return 0;
 }
 
-static __always_inline int crypto_sha256_finup(struct shash_desc *desc,
-					       const u8 *data,
-					       unsigned int len, u8 *out,
-					       bool force_generic)
+static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
 {
-	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int remain = len;
-	u8 *buf;
-
-	if (len >= SHA256_BLOCK_SIZE)
-		remain = crypto_sha256_update(desc, data, len, force_generic);
-	sctx->count += remain;
-	buf = memcpy(sctx + 1, data + len - remain, remain);
-	sha256_finup(sctx, buf, remain, out,
-		     crypto_shash_digestsize(desc->tfm), force_generic,
-		     !force_generic);
+	sha256_final(shash_desc_ctx(desc), out);
 	return 0;
 }
 
 static int crypto_sha256_finup_generic(struct shash_desc *desc, const u8 *data,
 				       unsigned int len, u8 *out)
 {
-	return crypto_sha256_finup(desc, data, len, out, true);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sha256_update_generic(sctx, data, len);
+	sha256_final_generic(sctx, out);
+	return 0;
 }
 
 static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
@@ -101,12 +81,16 @@ static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 }
 
 static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len, u8 *out)
 {
-	crypto_sha256_init(desc);
-	return crypto_sha256_finup_generic(desc, data, len, out);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sha256_init(sctx);
+	sha256_update_generic(sctx, data, len);
+	sha256_final_generic(sctx, out);
+	return 0;
 }
 
 static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
 				     unsigned int len, u8 *out)
 {
@@ -114,11 +98,17 @@ static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
 	return 0;
 }
 
 static int crypto_sha224_init(struct shash_desc *desc)
 {
-	sha224_block_init(shash_desc_ctx(desc));
+	sha224_init(shash_desc_ctx(desc));
+	return 0;
+}
+
+static int crypto_sha224_final_generic(struct shash_desc *desc, u8 *out)
+{
+	sha224_final_generic(shash_desc_ctx(desc), out);
 	return 0;
 }
 
 static int crypto_sha224_final_arch(struct shash_desc *desc, u8 *out)
 {
@@ -155,34 +145,39 @@ static int crypto_sha256_export_lib(struct shash_desc *desc, void *out)
 static struct shash_alg algs[] = {
 	{
 		.base.cra_name		= "sha256",
 		.base.cra_driver_name	= "sha256-generic",
 		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA256_DIGEST_SIZE,
 		.init			= crypto_sha256_init,
 		.update			= crypto_sha256_update_generic,
+		.final			= crypto_sha256_final_generic,
 		.finup			= crypto_sha256_finup_generic,
 		.digest			= crypto_sha256_digest_generic,
-		.descsize		= sizeof(struct crypto_sha256_state),
+		.descsize		= sizeof(struct sha256_state),
+		.statesize		= sizeof(struct crypto_sha256_state) +
+					  SHA256_BLOCK_SIZE + 1,
+		.import			= crypto_sha256_import_lib,
+		.export			= crypto_sha256_export_lib,
 	},
 	{
 		.base.cra_name		= "sha224",
 		.base.cra_driver_name	= "sha224-generic",
 		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA224_DIGEST_SIZE,
 		.init			= crypto_sha224_init,
 		.update			= crypto_sha256_update_generic,
-		.finup			= crypto_sha256_finup_generic,
-		.descsize		= sizeof(struct crypto_sha256_state),
+		.final			= crypto_sha224_final_generic,
+		.descsize		= sizeof(struct sha256_state),
+		.statesize		= sizeof(struct crypto_sha256_state) +
+					  SHA256_BLOCK_SIZE + 1,
+		.import			= crypto_sha256_import_lib,
+		.export			= crypto_sha256_export_lib,
 	},
 	{
 		.base.cra_name		= "sha256",
 		.base.cra_driver_name	= "sha256-" __stringify(ARCH),
 		.base.cra_priority	= 300,
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 4912572578dc2..f2df3bb90d11a 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -107,11 +107,11 @@ static inline void sha256_init(struct sha256_state *sctx)
 }
 void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len);
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE]);
 void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
 
-static inline void sha224_block_init(struct crypto_sha256_state *sctx)
+static inline void sha224_init(struct sha256_state *sctx)
 {
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
 	sctx->state[2] = SHA224_H2;
 	sctx->state[3] = SHA224_H3;
@@ -119,14 +119,9 @@ static inline void sha224_block_init(struct crypto_sha256_state *sctx)
 	sctx->state[5] = SHA224_H5;
 	sctx->state[6] = SHA224_H6;
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
 }
-
-static inline void sha224_init(struct sha256_state *sctx)
-{
-	sha224_block_init(&sctx->ctx);
-}
 /* Simply use sha256_update as it is equivalent to sha224_update. */
 void sha224_final(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE]);
 
 #endif /* _CRYPTO_SHA2_H */
-- 
2.49.0

