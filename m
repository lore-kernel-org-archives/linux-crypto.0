Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FD01C831A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945212; cv=none; b=enamjJtlObCtBRmEZppl+iFmpFNGO5bbASohgJHLMH47Oyeko/zWjB7+gRr1JO9DKEoEdnbW9L1y0em34VBUrAxtKWjJbZ0G+trgPMJIHeFlgYsNJGLROP5BpFIuXqtvI+XssMV/2D1AplkGszCDFkQKTNdVvcNWlrg7MW0CHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945212; c=relaxed/simple;
	bh=+d4CoQDdBddGoGLXVzH0k2ufKuE8P4zaCAzm4e5pQAg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=OMbpFipANPqUWPTufFz7QSwfTYwE5BNVGYmsNtd9/u+KpbdU+apIZ7qdb0MGZZEwZ7VaoRACl++yZGPZ39AQoyfqOzmg2C87PlM1Ltkg0oHfkFEG5wx7UyswL4u/DghlzsaFH8Omeq2W9Gwta6++VgcfsfyHvcfuV2ApTJQVfbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BczdVOL3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BczdVOL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VHnIoj5CKuxux0RXlMUTGZNZu5IkIpJmAwU+AzNvvYg=; b=BczdVOL3qmMxqqEPjy2Z7CLvol
	vgLR4MyDvmTQDjPgu4wE+S/5atI7UMEwcopWsFhS4vpozN299fXxK37A55bqzBRTMRKcO6var3qZC
	zU28FikLC6uOcqZLqQSaB6WVsKLuGIqrNTw353ZidHQ3PWKgPbCD5wHq7NpunHHkwrglpPJ3l4gLO
	MQ+njH8qViMH4cRv3UTgQBswJlJ+yyALLM5VImjjjSQgjEbKE2MfQIk/IWOioAhcF5KmVbWHt29/L
	nenJ8dUWJzrBZOapIuWs5fIVw0QsKS8MZZU9lMtRK8xNbS+SCZZsJugSVrEZhTq93p3xw/+1xCTPE
	UXKYfyuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxW-00GeAf-1c;
	Fri, 18 Apr 2025 11:00:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:06 +0800
Date: Fri, 18 Apr 2025 11:00:06 +0800
Message-Id: <67c78d4cde7f82fc2a1bbb9c1bb6864877a31388.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 38/67] crypto: sparc/sha256 - Use API partial block
 handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/sparc/crypto/sha256_glue.c | 121 ++++++--------------------------
 1 file changed, 20 insertions(+), 101 deletions(-)

diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
index 285561a1cde5..ddb250242faf 100644
--- a/arch/sparc/crypto/sha256_glue.c
+++ b/arch/sparc/crypto/sha256_glue.c
@@ -11,133 +11,50 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
+#include <asm/elf.h>
+#include <asm/pstate.h>
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-
-#include <asm/pstate.h>
-#include <asm/elf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "opcodes.h"
 
 asmlinkage void sha256_sparc64_transform(u32 *digest, const char *data,
 					 unsigned int rounds);
 
-static void __sha256_sparc64_update(struct sha256_state *sctx, const u8 *data,
-				    unsigned int len, unsigned int partial)
+static void sha256_block(struct crypto_sha256_state *sctx, const u8 *src,
+			 int blocks)
 {
-	unsigned int done = 0;
-
-	sctx->count += len;
-	if (partial) {
-		done = SHA256_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha256_sparc64_transform(sctx->state, sctx->buf, 1);
-	}
-	if (len - done >= SHA256_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
-
-		sha256_sparc64_transform(sctx->state, data + done, rounds);
-		done += rounds * SHA256_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
+	sha256_sparc64_transform(sctx->state, src, blocks);
 }
 
 static int sha256_sparc64_update(struct shash_desc *desc, const u8 *data,
 				 unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
-	} else
-		__sha256_sparc64_update(sctx, data, len, partial);
-
-	return 0;
+	return sha256_base_do_update_blocks(desc, data, len, sha256_block);
 }
 
-static int sha256_sparc64_final(struct shash_desc *desc, u8 *out)
+static int sha256_sparc64_finup(struct shash_desc *desc, const u8 *src,
+				unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA256_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56) - index);
-
-	/* We need to fill a whole block for __sha256_sparc64_update() */
-	if (padlen <= 56) {
-		sctx->count += padlen;
-		memcpy(sctx->buf + index, padding, padlen);
-	} else {
-		__sha256_sparc64_update(sctx, padding, padlen, index);
-	}
-	__sha256_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha224_sparc64_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_sparc64_final(desc, D);
-
-	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
-}
-
-static int sha256_sparc64_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int sha256_sparc64_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha256_base_do_finup(desc, src, len, sha256_block);
+	return sha256_base_finish(desc, out);
 }
 
 static struct shash_alg sha256_alg = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_sparc64_update,
-	.final		=	sha256_sparc64_final,
-	.export		=	sha256_sparc64_export,
-	.import		=	sha256_sparc64_import,
-	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.finup		=	sha256_sparc64_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-sparc64",
 		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -147,12 +64,14 @@ static struct shash_alg sha224_alg = {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	sha256_sparc64_update,
-	.final		=	sha224_sparc64_final,
-	.descsize	=	sizeof(struct sha256_state),
+	.finup		=	sha256_sparc64_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"sha224-sparc64",
 		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

