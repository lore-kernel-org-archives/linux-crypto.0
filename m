Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290521B0416
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163878; cv=none; b=K0hWE3Kxdfphr8VkoAZQ2nD7DvczJ8oZHYX54yXrRpU1P8FI2Dz2yiB0EqjNlgWIPBZEC5ArZX7rcC7GPNrE/w01EReUi/R9pGBGqk6vRfnbJPLmNkOuCQ7Umyejgc5Md7ekFf2RafGtRkhgeRNgvbGq1t+T1xIDx15gN7xFKdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163878; c=relaxed/simple;
	bh=43o5zrbYHn0Kq2HjIR3gKQJYASpR2YyGmCGuHIXgTYI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Fn+Q/W0QzCT/OUczePItG8l5kAAk+xyTbY1WuW9NBaiO8EhNARMBeJtg5E4VBbFnptUfmkDyt/VklDIOA7VSfFyGOzR7/EPrseOu97Y9ew5Rz5VBPS9tDHZiRGr2w2W+0/nRufA+580UwG+hYno8+r/sKiyy2o/tnxFNzjf3et8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ksZJtUYN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ksZJtUYN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PcQFojgLQOKSj7kyTBi9KHye2ZMSbXzCCib4AwnDghQ=; b=ksZJtUYNbrCObYF2Fril6oUgZ4
	2cPv5JPc2Dk0pLxnD/OshfVeQKIwJJ5dshV8bQPc7LJ9jEqFOFZvq3T9RjtXE7T+hfafkbskbCn+w
	J55sdyHJvvZT223GeMUWdH6fJFs3R9zst3ZYRfNVkLEZIFBi21xcMGI+SnGO84jgBXk8nTMXi0Hnv
	H26vPi2Czpw7K1IMMmo3BF6wjn/P5uC3ymEG1IHkcvPUc24rh+BjheQ4Z8+cWzDkI27HTmhMLqTDO
	TPaV8Qkcm0fi9Gl4Wct9d2rR9pPyuVg68q99LCJHfG70/44ccqPe1v/3jj8phX8YvLrHas/EyH0SF
	iGjFx0QA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizQ-002lLf-11;
	Fri, 02 May 2025 13:31:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:31:12 +0800
Date: Fri, 02 May 2025 13:31:12 +0800
Message-Id: <02900cbea8a00fe479f99b494b7d028ea7b9f119.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 9/9] crypto: sha256 - Use the partial block API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the shash partial block API by default.  Add a separate set
of lib shash algorithms to preserve testing coverage until lib/sha256
has its own tests.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sha256.c | 81 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 23 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index d6b90c6ea63d..a20c92098176 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -52,14 +52,20 @@ static int crypto_sha256_update_generic(struct shash_desc *desc, const u8 *data,
 	return crypto_sha256_update(desc, data, len, true);
 }
 
-static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
-				     unsigned int len)
+static int crypto_sha256_update_lib(struct shash_desc *desc, const u8 *data,
+				    unsigned int len)
 {
 	sha256_update(shash_desc_ctx(desc), data, len);
 	return 0;
 }
 
-static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
+static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
+				     unsigned int len)
+{
+	return crypto_sha256_update(desc, data, len, false);
+}
+
+static int crypto_sha256_final_lib(struct shash_desc *desc, u8 *out)
 {
 	sha256_final(shash_desc_ctx(desc), out);
 	return 0;
@@ -93,11 +99,7 @@ static int crypto_sha256_finup_generic(struct shash_desc *desc, const u8 *data,
 static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sha256_update(sctx, data, len);
-	sha256_final(sctx, out);
-	return 0;
+	return crypto_sha256_finup(desc, data, len, out, false);
 }
 
 static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
@@ -107,20 +109,27 @@ static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
 	return crypto_sha256_finup_generic(desc, data, len, out);
 }
 
-static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
-				     unsigned int len, u8 *out)
+static int crypto_sha256_digest_lib(struct shash_desc *desc, const u8 *data,
+				    unsigned int len, u8 *out)
 {
 	sha256(data, len, out);
 	return 0;
 }
 
+static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
+				     unsigned int len, u8 *out)
+{
+	crypto_sha256_init(desc);
+	return crypto_sha256_finup_arch(desc, data, len, out);
+}
+
 static int crypto_sha224_init(struct shash_desc *desc)
 {
 	sha224_block_init(shash_desc_ctx(desc));
 	return 0;
 }
 
-static int crypto_sha224_final_arch(struct shash_desc *desc, u8 *out)
+static int crypto_sha224_final_lib(struct shash_desc *desc, u8 *out)
 {
 	sha224_final(shash_desc_ctx(desc), out);
 	return 0;
@@ -184,16 +193,14 @@ static struct shash_alg algs[] = {
 	},
 	{
 		.base.cra_name		= "sha256",
-		.base.cra_driver_name	= "sha256-" __stringify(ARCH),
-		.base.cra_priority	= 300,
+		.base.cra_driver_name	= "sha256-lib",
 		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA256_DIGEST_SIZE,
 		.init			= crypto_sha256_init,
-		.update			= crypto_sha256_update_arch,
-		.final			= crypto_sha256_final_arch,
-		.finup			= crypto_sha256_finup_arch,
-		.digest			= crypto_sha256_digest_arch,
+		.update			= crypto_sha256_update_lib,
+		.final			= crypto_sha256_final_lib,
+		.digest			= crypto_sha256_digest_lib,
 		.descsize		= sizeof(struct sha256_state),
 		.statesize		= sizeof(struct crypto_sha256_state) +
 					  SHA256_BLOCK_SIZE + 1,
@@ -202,20 +209,48 @@ static struct shash_alg algs[] = {
 	},
 	{
 		.base.cra_name		= "sha224",
-		.base.cra_driver_name	= "sha224-" __stringify(ARCH),
-		.base.cra_priority	= 300,
+		.base.cra_driver_name	= "sha224-lib",
 		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA224_DIGEST_SIZE,
 		.init			= crypto_sha224_init,
-		.update			= crypto_sha256_update_arch,
-		.final			= crypto_sha224_final_arch,
+		.update			= crypto_sha256_update_lib,
+		.final			= crypto_sha224_final_lib,
 		.descsize		= sizeof(struct sha256_state),
 		.statesize		= sizeof(struct crypto_sha256_state) +
 					  SHA256_BLOCK_SIZE + 1,
 		.import			= crypto_sha256_import_lib,
 		.export			= crypto_sha256_export_lib,
 	},
+	{
+		.base.cra_name		= "sha256",
+		.base.cra_driver_name	= "sha256-" __stringify(ARCH),
+		.base.cra_priority	= 300,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
+		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
+		.base.cra_module	= THIS_MODULE,
+		.digestsize		= SHA256_DIGEST_SIZE,
+		.init			= crypto_sha256_init,
+		.update			= crypto_sha256_update_arch,
+		.finup			= crypto_sha256_finup_arch,
+		.digest			= crypto_sha256_digest_arch,
+		.descsize		= sizeof(struct crypto_sha256_state),
+	},
+	{
+		.base.cra_name		= "sha224",
+		.base.cra_driver_name	= "sha224-" __stringify(ARCH),
+		.base.cra_priority	= 300,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
+		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
+		.base.cra_module	= THIS_MODULE,
+		.digestsize		= SHA224_DIGEST_SIZE,
+		.init			= crypto_sha224_init,
+		.update			= crypto_sha256_update_arch,
+		.finup			= crypto_sha256_finup_arch,
+		.descsize		= sizeof(struct crypto_sha256_state),
+	},
 };
 
 static unsigned int num_algs;
@@ -224,9 +259,9 @@ static int __init crypto_sha256_mod_init(void)
 {
 	/* register the arch flavours only if they differ from generic */
 	num_algs = ARRAY_SIZE(algs);
-	BUILD_BUG_ON(ARRAY_SIZE(algs) % 2 != 0);
+	BUILD_BUG_ON(ARRAY_SIZE(algs) <= 2);
 	if (!sha256_is_arch_optimized())
-		num_algs /= 2;
+		num_algs -= 2;
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 subsys_initcall(crypto_sha256_mod_init);
-- 
2.39.5

