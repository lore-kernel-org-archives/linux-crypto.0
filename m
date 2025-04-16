Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5582023A99C
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785865; cv=none; b=pthJNU5aSIv5ODfst+0ZbddnNkP/WkUq/FycY8rqRKf8JoS48JIQDwHxyW8MlEA/0PEg75Y9SbXTmpwS2ge/HneLNAJzZijg8+n5GFZ0a8IrbC4miYpuz9kHPj3T3FfBZsf3B2BPo+w6AuXuvmEqnEQQ9afKoDBr/W1em3yAC3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785865; c=relaxed/simple;
	bh=nuPhh7eQ5XW4GwUj+End0MtFEcON+VVTbRv82bsrVVk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=WVUC+RuCSaFEhP8mg0Z4NyU5upfZEdKf1tbWs96QbQA30XL2j3mfY8X86q2v/toUr+9eHVNjx61ozPCBhJ8V18KCGgsWXeoKZvO2dIwPc7NTYXXrZDKrHVhqpoVLYlZWmLUtqLQOTzJCTogNFd78WVxM+1dJ9S5L3oWx1Wh3j38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nk1upeBJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nk1upeBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9yFqIiMvCsKvvzpu6cwAs+/+cq2XCDzg1Y4o9KGxuqk=; b=nk1upeBJh1IW6gIiYEKLaN0uyR
	+cvzeHzuFl65A4nENo++SSGI4gAh9GX6pC25BHt320WToNLsqcxVXq7JaJERXYQ0h5i14YtOUxCg/
	WfegMC0ysfvDnQCQ1ZFvFx7pWtn9bHNOcQV7ZXQp3KGYLVQxRdlGVk4gd0zuoiEAEcPVsZIadZEzS
	IsMOQziqmLwrD7CfnZi1ne26ZL8GqCQHfkQZQowRgtTKYqOefFIdcrFNtBcCoaWtJE3kG7xdxfqKl
	JTz6tg1ZJ/mgO3VCJhGUJfbpGoQ+blhL3fDtiD6V48IiuqQ/uL/WMFJZXMH5O7pT7hjn1R7J9T9xG
	ijpzBdfg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVP-00G6Og-2H;
	Wed, 16 Apr 2025 14:44:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:19 +0800
Date: Wed, 16 Apr 2025 14:44:19 +0800
Message-Id: <a68092ff2be941f79bce60781292c01d01228d1a.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 42/67] crypto: sha3-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sha3_generic.c | 101 ++++++++++++++++++------------------------
 include/crypto/sha3.h |   7 +--
 2 files changed, 47 insertions(+), 61 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index b103642b56ea..41d1e506e6de 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -9,10 +9,10 @@
  *               Ard Biesheuvel <ard.biesheuvel@linaro.org>
  */
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/types.h>
 #include <crypto/sha3.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
 
 /*
@@ -161,68 +161,51 @@ static void keccakf(u64 st[25])
 int crypto_sha3_init(struct shash_desc *desc)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
-
-	sctx->rsiz = 200 - 2 * digest_size;
-	sctx->rsizw = sctx->rsiz / 8;
-	sctx->partial = 0;
 
 	memset(sctx->st, 0, sizeof(sctx->st));
 	return 0;
 }
 EXPORT_SYMBOL(crypto_sha3_init);
 
-int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
 {
+	unsigned int rsiz = crypto_shash_blocksize(desc->tfm);
 	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int done;
-	const u8 *src;
+	unsigned int rsizw = rsiz / 8;
 
-	done = 0;
-	src = data;
+	do {
+		int i;
 
-	if ((sctx->partial + len) > (sctx->rsiz - 1)) {
-		if (sctx->partial) {
-			done = -sctx->partial;
-			memcpy(sctx->buf + sctx->partial, data,
-			       done + sctx->rsiz);
-			src = sctx->buf;
-		}
+		for (i = 0; i < rsizw; i++)
+			sctx->st[i] ^= get_unaligned_le64(data + 8 * i);
+		keccakf(sctx->st);
 
-		do {
-			unsigned int i;
-
-			for (i = 0; i < sctx->rsizw; i++)
-				sctx->st[i] ^= get_unaligned_le64(src + 8 * i);
-			keccakf(sctx->st);
-
-			done += sctx->rsiz;
-			src = data + done;
-		} while (done + (sctx->rsiz - 1) < len);
-
-		sctx->partial = 0;
-	}
-	memcpy(sctx->buf + sctx->partial, src, len - done);
-	sctx->partial += (len - done);
-
-	return 0;
+		data += rsiz;
+		len -= rsiz;
+	} while (len >= rsiz);
+	return len;
 }
-EXPORT_SYMBOL(crypto_sha3_update);
 
-int crypto_sha3_final(struct shash_desc *desc, u8 *out)
+static int crypto_sha3_finup(struct shash_desc *desc, const u8 *src,
+			     unsigned int len, u8 *out)
 {
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, inlen = sctx->partial;
 	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	unsigned int rsiz = crypto_shash_blocksize(desc->tfm);
+	struct sha3_state *sctx = shash_desc_ctx(desc);
+	__le64 block[SHA3_224_BLOCK_SIZE / 8] = {};
 	__le64 *digest = (__le64 *)out;
+	unsigned int rsizw = rsiz / 8;
+	u8 *p;
+	int i;
 
-	sctx->buf[inlen++] = 0x06;
-	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
-	sctx->buf[sctx->rsiz - 1] |= 0x80;
+	p = memcpy(block, src, len);
+	p[len++] = 0x06;
+	p[rsiz - 1] |= 0x80;
 
-	for (i = 0; i < sctx->rsizw; i++)
-		sctx->st[i] ^= get_unaligned_le64(sctx->buf + 8 * i);
+	for (i = 0; i < rsizw; i++)
+		sctx->st[i] ^= le64_to_cpu(block[i]);
+	memzero_explicit(block, sizeof(block));
 
 	keccakf(sctx->st);
 
@@ -232,49 +215,51 @@ int crypto_sha3_final(struct shash_desc *desc, u8 *out)
 	if (digest_size & 4)
 		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
 
-	memset(sctx, 0, sizeof(*sctx));
 	return 0;
 }
-EXPORT_SYMBOL(crypto_sha3_final);
 
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= crypto_sha3_update,
-	.final			= crypto_sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= crypto_sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= crypto_sha3_update,
-	.final			= crypto_sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= crypto_sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= crypto_sha3_update,
-	.final			= crypto_sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= crypto_sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= crypto_sha3_update,
-	.final			= crypto_sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= crypto_sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
@@ -289,7 +274,7 @@ static void __exit sha3_generic_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-subsys_initcall(sha3_generic_mod_init);
+module_init(sha3_generic_mod_init);
 module_exit(sha3_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 661f196193cf..420b90c5f08a 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -5,6 +5,8 @@
 #ifndef __CRYPTO_SHA3_H__
 #define __CRYPTO_SHA3_H__
 
+#include <linux/types.h>
+
 #define SHA3_224_DIGEST_SIZE	(224 / 8)
 #define SHA3_224_BLOCK_SIZE	(200 - 2 * SHA3_224_DIGEST_SIZE)
 
@@ -19,6 +21,8 @@
 
 #define SHA3_STATE_SIZE		200
 
+struct shash_desc;
+
 struct sha3_state {
 	u64		st[SHA3_STATE_SIZE / 8];
 	unsigned int	rsiz;
@@ -29,8 +33,5 @@ struct sha3_state {
 };
 
 int crypto_sha3_init(struct shash_desc *desc);
-int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len);
-int crypto_sha3_final(struct shash_desc *desc, u8 *out);
 
 #endif
-- 
2.39.5

