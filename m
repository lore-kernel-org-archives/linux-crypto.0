Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A31F2FFF99;
	Thu, 19 Mar 2026 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901157; cv=none; b=XTsnT7XlRhLYEi/8A59UTBFzIpwZmDzUKyzEukJX1ATu+F1JGqWMQQ5IAEV9eUzYC1+KFqspnmLphAXjCUYCYcpj+x1/bIkWSK2NwQziqs7GStJpH4qjDPupZb6zZIybhFL6tDDtlpvtGs6+zJyXzO1IfddJ1bpm+He+GSEzuF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901157; c=relaxed/simple;
	bh=kMhXMfUw7a3oxO5oBok+3qNaUgBLXU92TQEyaKkUMGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq+U5XoAiTX8XD7WIE5c/VAb3oqzlc6dnANV8IatoFhdy64cFMkw54ZDUc/4fjaEKV0RNbjEIPG4s1EbuC27VMJ7hJuBOcMnphFczp9wHHNL9QRW+ELZh53aENEv+FD5Hbr497JT2QfFBqGIKqjoqbAHZVfSCAPQsGKIyGAWRjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlqFKpbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlqFKpbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40D8C19425;
	Thu, 19 Mar 2026 06:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901157;
	bh=kMhXMfUw7a3oxO5oBok+3qNaUgBLXU92TQEyaKkUMGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlqFKpbdFAY4Pcu1e0H3TJvAM5+Z2cLF5fmtHa514Z/v0t5GLEqlRilbtxuv5DjQ6
	 spY4I+vncBblbT6ugst4CEbOSsJ6dyzLOSKb2bScLfRZx4lkxcgozT4YmL3s7lDrg/
	 ULs0u7RLPlEoSTSxrp8rXth/FYpDFEGkuxsgbGnN/CeixwPe4JqhZOsTTc5eN+wpWe
	 JWB6aD+U4OHZIhDW0o4kbcJ2keEMvmVEuxw1udP92hcWXQvCwiARe91aZlF+EYKm8A
	 eaF4bHuTU+Crd5B3yStX34+sjjm5j/MT4MMaHBVdrAmIfsSfSN4OSt+4vN7GHQZf70
	 R9TZKEXDlwy8g==
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
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/19] crypto: arm/ghash - Make the "ghash" crypto_shash NEON-only
Date: Wed, 18 Mar 2026 23:17:06 -0700
Message-ID: <20260319061723.1140720-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arch/arm/crypto/ghash-ce-glue.c originally provided only a "ghash"
crypto_shash algorithm using PMULL if available, else NEON.

Significantly later, it was updated to also provide a full AES-GCM
implementation using PMULL.

This made the PMULL support in the "ghash" crypto_shash largely
obsolete.  Indeed, the arm64 equivalent of this file unconditionally
uses only ASIMD in its "ghash" crypto_shash.

Given that inconsistency and the fact that the NEON-only code is more
easily separable into the GHASH library than the PMULL based code is,
let's align with arm64 and just support NEON-only for the pure GHASH.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 454adcc62cc6..d7d787de7dd3 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -34,11 +34,11 @@ MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 
 #define RFC4106_NONCE_SIZE	4
 
 struct ghash_key {
 	be128	k;
-	u64	h[][2];
+	u64	h[1][2];
 };
 
 struct gcm_key {
 	u64	h[4][2];
 	u32	rk[AES_MAX_KEYLENGTH_U32];
@@ -49,16 +49,14 @@ struct gcm_key {
 struct arm_ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
-				       u64 const h[][2], const char *head);
+				       u64 const h[4][2], const char *head);
 
 asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-				      u64 const h[][2], const char *head);
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_p64);
+				      u64 const h[1][2], const char *head);
 
 static int ghash_init(struct shash_desc *desc)
 {
 	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
 
@@ -68,14 +66,11 @@ static int ghash_init(struct shash_desc *desc)
 
 static void ghash_do_update(int blocks, u64 dg[], const char *src,
 			    struct ghash_key *key, const char *head)
 {
 	kernel_neon_begin();
-	if (static_branch_likely(&use_p64))
-		pmull_ghash_update_p64(blocks, dg, src, key->h, head);
-	else
-		pmull_ghash_update_p8(blocks, dg, src, key->h, head);
+	pmull_ghash_update_p8(blocks, dg, src, key->h, head);
 	kernel_neon_end();
 }
 
 static int ghash_update(struct shash_desc *desc, const u8 *src,
 			unsigned int len)
@@ -145,23 +140,10 @@ static int ghash_setkey(struct crypto_shash *tfm,
 		return -EINVAL;
 
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
 	ghash_reflect(key->h[0], &key->k);
-
-	if (static_branch_likely(&use_p64)) {
-		be128 h = key->k;
-
-		gf128mul_lle(&h, &key->k);
-		ghash_reflect(key->h[1], &h);
-
-		gf128mul_lle(&h, &key->k);
-		ghash_reflect(key->h[2], &h);
-
-		gf128mul_lle(&h, &key->k);
-		ghash_reflect(key->h[3], &h);
-	}
 	return 0;
 }
 
 static struct shash_alg ghash_alg = {
 	.digestsize		= GHASH_DIGEST_SIZE,
@@ -173,15 +155,15 @@ static struct shash_alg ghash_alg = {
 	.import			= ghash_import,
 	.descsize		= sizeof(struct arm_ghash_desc_ctx),
 	.statesize		= sizeof(struct ghash_desc_ctx),
 
 	.base.cra_name		= "ghash",
-	.base.cra_driver_name	= "ghash-ce",
+	.base.cra_driver_name	= "ghash-neon",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
+	.base.cra_ctxsize	= sizeof(struct ghash_key),
 	.base.cra_module	= THIS_MODULE,
 };
 
 void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
 		       struct gcm_key const *k, char *dst,
@@ -569,12 +551,10 @@ static int __init ghash_ce_mod_init(void)
 	if (elf_hwcap2 & HWCAP2_PMULL) {
 		err = crypto_register_aeads(gcm_aes_algs,
 					    ARRAY_SIZE(gcm_aes_algs));
 		if (err)
 			return err;
-		ghash_alg.base.cra_ctxsize += 3 * sizeof(u64[2]);
-		static_branch_enable(&use_p64);
 	}
 
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
 		goto err_aead;
-- 
2.53.0

