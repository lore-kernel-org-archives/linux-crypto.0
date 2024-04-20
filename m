Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664377F
	for <linux-crypto@vger.kernel.org>; Sat, 20 Apr 2024 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713637271; cv=none; b=hcb4oyIp6Vs189m4n85ysH5gj8WkMpkBPyelX3B9+7CtfYzG9j4/MOR0aGQNPrfYrJ4XTsXkS4lnsdLUggXOIFSY4dsRo/3KZs6IpSUhvKmr0AvkbV8zLLa5tmZ2ntoOMfOlYlSJA2fRr8SpBIAkPp1v4l4eVBSIMxKIwfvhhlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713637271; c=relaxed/simple;
	bh=e1IAU92KdhkgArW6lttIIjoPSxON78AGdXlGCpSU+4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iSGnGGL3CMvTSQHjFINV8wwid/kXJgiKOYNt1mn1JUbeHZ6NBO5dl/4UpIZO/MdgfmSk0Dw95H3tVbGUI6ZlacYXosOJADxe4iL0J/Yic+fSRx9uS4HMCBMlqw8XPyZKjy5m4F9Fffer1FLBjHupikd2BegCcr+Y9x9xrxQEMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kpl51H7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kpl51H7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30200C072AA;
	Sat, 20 Apr 2024 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713637271;
	bh=e1IAU92KdhkgArW6lttIIjoPSxON78AGdXlGCpSU+4I=;
	h=From:To:Cc:Subject:Date:From;
	b=Kpl51H7XJIuWxrlSER3nNNhfvockhmztVEIZxhxrDR7gvLv2P4FUlCCXOaMx7iPRT
	 HmN3ebpOAWGQ7LVasgkpcg+qkn+tOf8Pw4GIhPQ5aatoOvLW4BHq5vunZl/RCji+/Z
	 YOPv4gWgrBkVREc4kaGW6BIsUrmGLUoRlYRBPbktQBd04lZ/UIFWS4hkYXdAUwQLRm
	 1+n1vIgGWqX07/z7Im94W8XxkNFCUk5tULt+6ZzPIsZ3aaD0Gi33KnHICXwSSxbrnK
	 yknZ/r8igUjWnK1EtqnZ3YlxvL34zz6lu7aEx16ElsMX37oiAy09EU1ODOyWU8BG09
	 aKBPwwpVyuvWA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2] crypto: x86/aes-gcm - simplify GCM hash subkey derivation
Date: Sat, 20 Apr 2024 11:20:16 -0700
Message-ID: <20240420182016.28159-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove a redundant expansion of the AES key, and use rodata for zeroes.
Also rename rfc4106_set_hash_subkey() to aes_gcm_derive_hash_subkey()
because it's used for both versions of AES-GCM, not just RFC4106.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 110b3282a1f2..e582506306b1 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -38,11 +38,10 @@
 
 
 #define AESNI_ALIGN	16
 #define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE - 1))
-#define RFC4106_HASH_SUBKEY_SIZE 16
 #define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
 #define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
 /* This data is stored at the end of the crypto_tfm struct.
@@ -588,27 +587,16 @@ static int xctr_crypt(struct skcipher_request *req)
 		err = skcipher_walk_done(&walk, nbytes);
 	}
 	return err;
 }
 
-static int
-rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
+static int aes_gcm_derive_hash_subkey(const struct crypto_aes_ctx *aes_key,
+				      u8 hash_subkey[AES_BLOCK_SIZE])
 {
-	struct crypto_aes_ctx ctx;
-	int ret;
+	static const u8 zeroes[AES_BLOCK_SIZE];
 
-	ret = aes_expandkey(&ctx, key, key_len);
-	if (ret)
-		return ret;
-
-	/* Clear the data in the hash sub key container to zero.*/
-	/* We want to cipher all zeros to create the hash sub key. */
-	memset(hash_subkey, 0, RFC4106_HASH_SUBKEY_SIZE);
-
-	aes_encrypt(&ctx, hash_subkey, hash_subkey);
-
-	memzero_explicit(&ctx, sizeof(ctx));
+	aes_encrypt(aes_key, hash_subkey, zeroes);
 	return 0;
 }
 
 static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 				  unsigned int key_len)
@@ -622,11 +610,12 @@ static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 	key_len -= 4;
 
 	memcpy(ctx->nonce, key + key_len, sizeof(ctx->nonce));
 
 	return aes_set_key_common(&ctx->aes_key_expanded, key, key_len) ?:
-	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
+	       aes_gcm_derive_hash_subkey(&ctx->aes_key_expanded,
+					  ctx->hash_subkey);
 }
 
 /* This is the Integrity Check Value (aka the authentication tag) length and can
  * be 8, 12 or 16 bytes long. */
 static int common_rfc4106_set_authsize(struct crypto_aead *aead,
@@ -1328,11 +1317,12 @@ static int generic_gcmaes_set_key(struct crypto_aead *aead, const u8 *key,
 				  unsigned int key_len)
 {
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(aead);
 
 	return aes_set_key_common(&ctx->aes_key_expanded, key, key_len) ?:
-	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
+	       aes_gcm_derive_hash_subkey(&ctx->aes_key_expanded,
+					  ctx->hash_subkey);
 }
 
 static int generic_gcmaes_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);

base-commit: 543ea178fbfadeaf79e15766ac989f3351349f02
-- 
2.44.0

