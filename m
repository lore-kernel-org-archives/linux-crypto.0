Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4E01E7660
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993208; cv=none; b=RvNKdcVDKoJVri3mJvusLqKtn5CYN5mLjXknviKt/6SAhdSDQuiJfWniDNyszWoey2k/mx6XcI1agFZn8RchCqgdVhCbL/iXIOFlIhpQ3n6oL02WfkoovFyTE38zidGf07lqa/GYk9rpNI3ZJL8BdahsmR+0/0waQsyUZEqVFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993208; c=relaxed/simple;
	bh=UG1ngoy9akYffSkrF9EMpWTo/p8az7qk5jexmXJ9W6A=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=ZR7n+PRR3/h7NWv26XQVWYd7NSblU+h46EEXHfNa+T6jU+25DzIfYu7Uex9ecW5gXomK4i8jabjYPbWqrqcqh4WbyFCjbdbpRsvk1hn/svdRKCIBQBpTNIK83XINZ9F94X3HSC/Ex4wMxEbTGA4ElyNFAK4JsikZ5wdFLA1Dzt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b2WzfWCP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b2WzfWCP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o/wNV86mISqaniQogxnq4SngQGpowScqNCsplOPFbg8=; b=b2WzfWCPkDqev0nBTHP5ewnE15
	5OfQvKg1N4RF4JpIeb2e38gpH2cB0B5n8/nGt4lx/JbC/x/fs2BI8KMI8UjEMdL6lx1lKbd5+Fevc
	MWLxkaoVj1JT+53U7HM3Dr4K5gGB9gkzcmxdPFs3lPgRUMBDykSc3xsKeUx9pGcpTEGu3Byz/5WvO
	bvv/3j7e9qxRR187USqvJGPPO5/brgZgfBPfv/FPBvs2NtjhhyUdqBt6UdWvYd6wxV7u7opPOm/TK
	XEzBD7ijFXSAfQN8FXKpKYNqHi6WdrcwpUT3stu3CpfyhW+tPVzfyySGlUfB8hEGFArfLvgrDo8B2
	1SvvRW7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0ag-002Ac1-2n;
	Wed, 30 Apr 2025 14:06:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:42 +0800
Date: Wed, 30 Apr 2025 14:06:42 +0800
Message-Id: <70168abce2f7d9cb07bcb4e5b3d6dbc4b1265963.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/12] crypto: sha256 - Use the partial block API
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
 crypto/sha256.c | 90 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index 9463c06ea39c..1068c206247f 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -45,14 +45,26 @@ static int crypto_sha256_update_generic(struct shash_desc *desc, const u8 *data,
 	return remain;
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
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
+	int remain = len - round_down(len, SHA256_BLOCK_SIZE);
+
+	sctx->count += len - remain;
+	sha256_choose_blocks(sctx->state, data, len / SHA256_BLOCK_SIZE,
+			     false, true);
+	return remain;
+}
+
+static int crypto_sha256_final_lib(struct shash_desc *desc, u8 *out)
 {
 	sha256_final(shash_desc_ctx(desc), out);
 	return 0;
@@ -74,10 +86,13 @@ static int crypto_sha256_finup_generic(struct shash_desc *desc, const u8 *data,
 static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
+	int remain = len;
 
-	sha256_update(sctx, data, len);
-	sha256_final(sctx, out);
+	if (remain >= SHA256_BLOCK_SIZE)
+		remain = crypto_sha256_update_arch(desc, data, remain);
+	sha256_finup(sctx, data + len - remain, remain, out,
+		     crypto_shash_digestsize(desc->tfm), false, true);
 	return 0;
 }
 
@@ -88,20 +103,27 @@ static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
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
@@ -165,16 +187,14 @@ static struct shash_alg algs[] = {
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
@@ -183,20 +203,48 @@ static struct shash_alg algs[] = {
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
@@ -205,9 +253,9 @@ static int __init crypto_sha256_mod_init(void)
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

