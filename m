Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD09205E26
	for <linux-crypto@vger.kernel.org>; Sat, 20 Apr 2024 06:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713592870; cv=none; b=KhvXAZntSJU29SeEhPH22GFTgr0Bz3UDoWtF578alXQv14yTp6mY7+Pjil/T4yRaT8C+40+O3oUN4ptGoYiKhijtZgHYUpmdx0RwupxfRHmUeR5D4ZKSNrJviC0eem7epokPlHdCWXx/AD4NqIXqsRFYs/VUbumfxuBWFU+aMeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713592870; c=relaxed/simple;
	bh=nVCFnkdCM4jYahGEDbNGoUEOh5dARqC0bUdtLGNjuLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eT5MVxvvUNvJrERmlGO4LUFzqh+nj/xMFqSEGTFfFl1vb3crPuZfyJubZ9NaLXEDqS2T+99zpXnvybxEDvlAodApPogjBhu9g6oQN7zRnj8S3oxt9Zf9/I7wwXCX/Su9ZLDuM5ppO75VU2XLWBN02zhHGgugMclhECZCSXHWbdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esL7vgt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esL7vgt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991A6C072AA;
	Sat, 20 Apr 2024 06:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713592869;
	bh=nVCFnkdCM4jYahGEDbNGoUEOh5dARqC0bUdtLGNjuLk=;
	h=From:To:Cc:Subject:Date:From;
	b=esL7vgt6qRC/hn3imzW6UhFutiPNE+3yYhlUkjEDzXx3HGY0Uun9C27Zd2jl5fDJw
	 QICjzd3lTEkYoefZOSb6TBkrEtWq8imRtdOEUP92qcHOzcdDwJxMxSQLl1cDG6s/EV
	 IgbiVYkNDr5v4jg4Isvkj6J4gebIB0dTSut5zqLAVVIkX+IBsp6I6R95TWwz1W7fn1
	 ey3jtEnN0z+Poz2GhZF/f6lMo6yh8dBqrTQjDJsRxpH0fn3uHtDuhJrVPAcOjHMjSx
	 eaSXeob8CuUITZVbR3h2Idj56WntGQp5nJH2TWq2nO4j2OIolbtjaIRuKP6J5Akcxq
	 n+igs81panCYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] crypto: x86/aes-gcm - simplify GCM hash subkey derivation
Date: Fri, 19 Apr 2024 23:00:37 -0700
Message-ID: <20240420060037.26014-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove a redundant expansion of the AES key, and utilize the zero page.
Also rename rfc4106_set_hash_subkey() to aes_gcm_derive_hash_subkey()
because it's used for both versions of AES-GCM, not just RFC4106.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 110b3282a1f2..b4058c3d410d 100644
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
@@ -588,27 +587,14 @@ static int xctr_crypt(struct skcipher_request *req)
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
-
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
+	aes_encrypt(aes_key, hash_subkey, page_address(ZERO_PAGE(0)));
 	return 0;
 }
 
 static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 				  unsigned int key_len)
@@ -622,11 +608,12 @@ static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
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
@@ -1328,11 +1315,12 @@ static int generic_gcmaes_set_key(struct crypto_aead *aead, const u8 *key,
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

