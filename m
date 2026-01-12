Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B18B38A2AB;
	Mon, 12 Jan 2026 19:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245811; cv=none; b=LT0aUcPdj0+YDUIskp1nDAAZPWH2nqFmFUvC8HoL2hvlVvs8UHpkNeQIBW+9D9tIAGcCKJy3TaQaxAczCjpDZUFop6wlqBPCDIvMJQp7B1aIuWjLi/CGynH5Bx6yLlV1ZC0b8s1osopwysXX7F1xuaeqYTH1ItgHAFOSDqPG9CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245811; c=relaxed/simple;
	bh=NltvZkewEHgk0OxV2OlqHClzS++fArO+KBZ7L9kUlbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDzr0QshJOJskrZi5mqHvHiQq2ffKttTkqDZwMQ+URjVOyYD41eCEKXfkZzfBnyOhNzaMzpRZjsrHiY1FhRg6xlVfG8f9/wQ6TU+o3HaQKlqefG+MaHlGkF0YJ6jMh6oqpmhtoJ1dNtQixWAguRfRvPnVlxGzdbgebYNC2/wKMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyrNjcdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyrNjcdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F1FC2BC9E;
	Mon, 12 Jan 2026 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245811;
	bh=NltvZkewEHgk0OxV2OlqHClzS++fArO+KBZ7L9kUlbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyrNjcdd2UgBnDotjEXY8qII9iGNu1uEWirOyLRGsPUKHPRmLRsgrQYJZfK17EFOT
	 Jjmq4w+utco9K5dko0xzOYNRvHThKn5H4/AzH0lvIa19igg/yEDaSoVVv0SEtNMe+E
	 XSL1UzonfD7FtxVxqTjWkIT9zWnw19PISlMGaCOs9Ro7UEMdlMOZD/wId2NdVT1IqP
	 yD6n1DPoVEl4eDRd4NEovQLTRJa1HSn+1iQ9HkrnviY85iMQyaDiYspDFfsvSgjk77
	 FezNcc7WxWghb/T1QHeymsQNN3jPz/6MgE1q6Al5w6cr8a9181ylkwZWI9A5uMbQuY
	 lQVtTc+2DGfZg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 24/35] crypto: arm64/ghash - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:22 -0800
Message-ID: <20260112192035.10427-25-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index ef249d06c92c..63bb9e062251 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -38,11 +38,11 @@ struct ghash_key {
 struct arm_ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
 };
 
 struct gcm_aes_ctx {
-	struct crypto_aes_ctx	aes_key;
+	struct aes_enckey	aes_key;
 	u8			nonce[RFC4106_NONCE_SIZE];
 	struct ghash_key	ghash_key;
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
@@ -184,31 +184,19 @@ static struct shash_alg ghash_alg = {
 	.import			= ghash_import,
 	.descsize		= sizeof(struct arm_ghash_desc_ctx),
 	.statesize		= sizeof(struct ghash_desc_ctx),
 };
 
-static int num_rounds(struct crypto_aes_ctx *ctx)
-{
-	/*
-	 * # of rounds specified by AES:
-	 * 128 bit key		10 rounds
-	 * 192 bit key		12 rounds
-	 * 256 bit key		14 rounds
-	 * => n byte key	=> 6 + (n/4) rounds
-	 */
-	return 6 + ctx->key_length / 4;
-}
-
 static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *inkey,
 			  unsigned int keylen)
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
 	u8 key[GHASH_BLOCK_SIZE];
 	be128 h;
 	int ret;
 
-	ret = aes_expandkey(&ctx->aes_key, inkey, keylen);
+	ret = aes_prepareenckey(&ctx->aes_key, inkey, keylen);
 	if (ret)
 		return -EINVAL;
 
 	aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
 
@@ -294,11 +282,10 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 
 static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
-	int nrounds = num_rounds(&ctx->aes_key);
 	struct skcipher_walk walk;
 	u8 buf[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
 	be128 lengths;
 	u8 *tag;
@@ -329,12 +316,12 @@ static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 			tag = NULL;
 		}
 
 		scoped_ksimd()
 			pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
-					  dg, iv, ctx->aes_key.key_enc, nrounds,
-					  tag);
+					  dg, iv, ctx->aes_key.k.rndkeys,
+					  ctx->aes_key.nrounds, tag);
 
 		if (unlikely(!nbytes))
 			break;
 
 		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
@@ -357,11 +344,10 @@ static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 static int gcm_decrypt(struct aead_request *req, char *iv, int assoclen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
-	int nrounds = num_rounds(&ctx->aes_key);
 	struct skcipher_walk walk;
 	u8 otag[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
 	be128 lengths;
@@ -399,12 +385,13 @@ static int gcm_decrypt(struct aead_request *req, char *iv, int assoclen)
 		}
 
 		scoped_ksimd()
 			ret = pmull_gcm_decrypt(nbytes, dst, src,
 						ctx->ghash_key.h,
-						dg, iv, ctx->aes_key.key_enc,
-						nrounds, tag, otag, authsize);
+						dg, iv, ctx->aes_key.k.rndkeys,
+						ctx->aes_key.nrounds, tag, otag,
+						authsize);
 
 		if (unlikely(!nbytes))
 			break;
 
 		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
-- 
2.52.0

