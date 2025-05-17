Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DE136A;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448717; cv=none; b=qGQ9s5RcMaMSfh4/oT8f+UmWz+XFGaU7x2bFhO9ruHt+nf5ayup23qzRqeBKL6oqflSrh1GOUwyoTHjo/K1qUpHAe6WGWDCNSFXvfmnWL1ZOZ7D3vo9R3rtq1M/nhLU6L+HLoyVptCIsVbi8Hx9F7esu2fdqXAZgqPA3BAcZKOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448717; c=relaxed/simple;
	bh=rxExDmAR8OpsxVyOb93D2F15CH0EPCc4/kwgbjLbV9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAhs4sA4K/X/AxWFgpIlc6ln49ZjyaFq+C3aq/fvUi+R40RgVW0WF2U5DTSFEG7HgI6lLv3r00QES6U8bNYuL0KV81RoNZ+w9nszHEf8srEzUFHb65A87vdbj/RHVr2r8EQttbfUZCLyMBXWjXP/nW60bBagNJhcofjbrZVXbtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/l/zeea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/l/zeea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1674EC4CEED;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448717;
	bh=rxExDmAR8OpsxVyOb93D2F15CH0EPCc4/kwgbjLbV9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/l/zeeaXlGjk85ozjkiv28mbQYM7Eywozk64Ge4ByotlQz/Ay52oeNxkTuhNQ0Xs
	 0c1HUsfX8sbbds48bccgUqdXM9ET90XngyZ3FFa08krugskvGIL7AfLQHb/M9LhegA
	 +lvnwjclZhv3Ppy+s8egKJGviQPxBfb9g/5ZemZQfiOEGN8mmJh5T49jzcp51DXR7A
	 saT45Gbtey7sO3XQxvASua+4Ekpr7YlRTtQ45vhgu9X2UNEf7B1DAlmZ3WIleVTr/5
	 2ejbGtRYpPcMIkAt2tY7IKGdkm+oBjX/nonENKohJDyYd7Gmq3V+HJtEpoTN0cfvDF
	 tZ7YaQIazksZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Revert "crypto: sha256 - Use the partial block API"
Date: Fri, 16 May 2025 19:24:21 -0700
Message-ID: <20250517022428.401622-2-ebiggers@kernel.org>
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

This reverts commit 3bf5337879101166dfacfbc2a780d1a379c288ba which got
pushed out despite being nacked.

The library API already has to handle partial blocks, and it makes a lot
more sense to just use that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/sha256.c | 81 ++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 58 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index 4aeb213bab117..cf190114574ea 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -50,24 +50,18 @@ static int crypto_sha256_update_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len)
 {
 	return crypto_sha256_update(desc, data, len, true);
 }
 
-static int crypto_sha256_update_lib(struct shash_desc *desc, const u8 *data,
-				    unsigned int len)
-{
-	sha256_update(shash_desc_ctx(desc), data, len);
-	return 0;
-}
-
 static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
 				     unsigned int len)
 {
-	return crypto_sha256_update(desc, data, len, false);
+	sha256_update(shash_desc_ctx(desc), data, len);
+	return 0;
 }
 
-static int crypto_sha256_final_lib(struct shash_desc *desc, u8 *out)
+static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
 {
 	sha256_final(shash_desc_ctx(desc), out);
 	return 0;
 }
 
@@ -97,41 +91,38 @@ static int crypto_sha256_finup_generic(struct shash_desc *desc, const u8 *data,
 }
 
 static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
-	return crypto_sha256_finup(desc, data, len, out, false);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sha256_update(sctx, data, len);
+	sha256_final(sctx, out);
+	return 0;
 }
 
 static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len, u8 *out)
 {
 	crypto_sha256_init(desc);
 	return crypto_sha256_finup_generic(desc, data, len, out);
 }
 
-static int crypto_sha256_digest_lib(struct shash_desc *desc, const u8 *data,
-				    unsigned int len, u8 *out)
-{
-	sha256(data, len, out);
-	return 0;
-}
-
 static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
 				     unsigned int len, u8 *out)
 {
-	crypto_sha256_init(desc);
-	return crypto_sha256_finup_arch(desc, data, len, out);
+	sha256(data, len, out);
+	return 0;
 }
 
 static int crypto_sha224_init(struct shash_desc *desc)
 {
 	sha224_block_init(shash_desc_ctx(desc));
 	return 0;
 }
 
-static int crypto_sha224_final_lib(struct shash_desc *desc, u8 *out)
+static int crypto_sha224_final_arch(struct shash_desc *desc, u8 *out)
 {
 	sha224_final(shash_desc_ctx(desc), out);
 	return 0;
 }
 
@@ -191,79 +182,53 @@ static struct shash_alg algs[] = {
 		.finup			= crypto_sha256_finup_generic,
 		.descsize		= sizeof(struct crypto_sha256_state),
 	},
 	{
 		.base.cra_name		= "sha256",
-		.base.cra_driver_name	= "sha256-lib",
+		.base.cra_driver_name	= "sha256-" __stringify(ARCH),
+		.base.cra_priority	= 300,
 		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA256_DIGEST_SIZE,
 		.init			= crypto_sha256_init,
-		.update			= crypto_sha256_update_lib,
-		.final			= crypto_sha256_final_lib,
-		.digest			= crypto_sha256_digest_lib,
+		.update			= crypto_sha256_update_arch,
+		.final			= crypto_sha256_final_arch,
+		.finup			= crypto_sha256_finup_arch,
+		.digest			= crypto_sha256_digest_arch,
 		.descsize		= sizeof(struct sha256_state),
 		.statesize		= sizeof(struct crypto_sha256_state) +
 					  SHA256_BLOCK_SIZE + 1,
 		.import			= crypto_sha256_import_lib,
 		.export			= crypto_sha256_export_lib,
 	},
 	{
 		.base.cra_name		= "sha224",
-		.base.cra_driver_name	= "sha224-lib",
+		.base.cra_driver_name	= "sha224-" __stringify(ARCH),
+		.base.cra_priority	= 300,
 		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA224_DIGEST_SIZE,
 		.init			= crypto_sha224_init,
-		.update			= crypto_sha256_update_lib,
-		.final			= crypto_sha224_final_lib,
+		.update			= crypto_sha256_update_arch,
+		.final			= crypto_sha224_final_arch,
 		.descsize		= sizeof(struct sha256_state),
 		.statesize		= sizeof(struct crypto_sha256_state) +
 					  SHA256_BLOCK_SIZE + 1,
 		.import			= crypto_sha256_import_lib,
 		.export			= crypto_sha256_export_lib,
 	},
-	{
-		.base.cra_name		= "sha256",
-		.base.cra_driver_name	= "sha256-" __stringify(ARCH),
-		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_AHASH_ALG_FINUP_MAX,
-		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= SHA256_DIGEST_SIZE,
-		.init			= crypto_sha256_init,
-		.update			= crypto_sha256_update_arch,
-		.finup			= crypto_sha256_finup_arch,
-		.digest			= crypto_sha256_digest_arch,
-		.descsize		= sizeof(struct crypto_sha256_state),
-	},
-	{
-		.base.cra_name		= "sha224",
-		.base.cra_driver_name	= "sha224-" __stringify(ARCH),
-		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_AHASH_ALG_FINUP_MAX,
-		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= SHA224_DIGEST_SIZE,
-		.init			= crypto_sha224_init,
-		.update			= crypto_sha256_update_arch,
-		.finup			= crypto_sha256_finup_arch,
-		.descsize		= sizeof(struct crypto_sha256_state),
-	},
 };
 
 static unsigned int num_algs;
 
 static int __init crypto_sha256_mod_init(void)
 {
 	/* register the arch flavours only if they differ from generic */
 	num_algs = ARRAY_SIZE(algs);
-	BUILD_BUG_ON(ARRAY_SIZE(algs) <= 2);
+	BUILD_BUG_ON(ARRAY_SIZE(algs) % 2 != 0);
 	if (!sha256_is_arch_optimized())
-		num_algs -= 2;
+		num_algs /= 2;
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 module_init(crypto_sha256_mod_init);
 
 static void __exit crypto_sha256_mod_exit(void)

-- 
2.49.0

