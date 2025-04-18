Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A81B269823
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945181; cv=none; b=UeVDkEGO411vWvE0spEvQ8cgntRIincijuw4vSvDfQMYtL1onItoDD+mPYQdcs5YojmPIb9TPejqplbxztpRxuG8zG7D1hTwPcXKJ6Cv6BoU+wcFmCPd09Gn0Jl3sXd+zvnuwCrUDmrygpvDNIdRNG4bSYulpKojnW4j9kOgRQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945181; c=relaxed/simple;
	bh=XieLnX3taPIQqQqWLbBMQZOWl996I9mJq/G95WcMlRk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=HyihKxCoCg8JpZurf/axwVxdDqO/2EWl7aYLizubTykHb74nHNnLhhS3tQd7cMMDioK2VuVmsPDFgLmXDPqBy1OGaVTPyxiNdOuC209t0UNnLfJCqOJGTRGwFUW2GqoIWwx5gPgMSi5s+Q1mf5YKxk+hrHjU9knt/pOyTETPibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FXg2/NpG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FXg2/NpG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SjXY8FwNyK9noWhnhKMektIaBGSUD2WzM1FAJnFhAZk=; b=FXg2/NpGlDhNFi5oIj9aoHnQVe
	6jnMjecqCX1/dO9MzfY32rXDilIwxegUVssAtIneMHLbXLwqki0qyUKqg8vIoBPd5JzWo7wdIF2Ek
	nCnzFA78pe9bLq6d541tmyHJmfjdJscJX8DFtqgenHbaCI8ermoty0VcvMCZsajQ28xA2vt7KA323
	7P7Y1vBKitb/edVsBpUFtdaW1avoANF3XqCjIZ9iqlMXjMWsvuA9OvToBC0FX/KOpRq6t9xGXsgLD
	jH1Bwx5AivvV2MNQ5O4Y8WbIabi9vAN9pkmruWiKgths4xBEy1yDrUUDimS/Ro6yqEH26mDEf8m2f
	/bw2l+qw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bx2-00Ge7x-22;
	Fri, 18 Apr 2025 10:59:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:36 +0800
Date: Fri, 18 Apr 2025 10:59:36 +0800
Message-Id: <45af3113f965cd5a68141d72afc5da083f0a02ed.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 25/67] crypto: sparc/sha1 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/sparc/crypto/sha1_glue.c | 109 +++++-----------------------------
 1 file changed, 15 insertions(+), 94 deletions(-)

diff --git a/arch/sparc/crypto/sha1_glue.c b/arch/sparc/crypto/sha1_glue.c
index 06b7becfcb21..ec5a06948e0d 100644
--- a/arch/sparc/crypto/sha1_glue.c
+++ b/arch/sparc/crypto/sha1_glue.c
@@ -11,124 +11,45 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
+#include <asm/elf.h>
+#include <asm/pstate.h>
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-
-#include <asm/pstate.h>
-#include <asm/elf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "opcodes.h"
 
-asmlinkage void sha1_sparc64_transform(u32 *digest, const char *data,
-				       unsigned int rounds);
-
-static void __sha1_sparc64_update(struct sha1_state *sctx, const u8 *data,
-				  unsigned int len, unsigned int partial)
-{
-	unsigned int done = 0;
-
-	sctx->count += len;
-	if (partial) {
-		done = SHA1_BLOCK_SIZE - partial;
-		memcpy(sctx->buffer + partial, data, done);
-		sha1_sparc64_transform(sctx->state, sctx->buffer, 1);
-	}
-	if (len - done >= SHA1_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
-
-		sha1_sparc64_transform(sctx->state, data + done, rounds);
-		done += rounds * SHA1_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buffer, data + done, len - done);
-}
+asmlinkage void sha1_sparc64_transform(struct sha1_state *digest,
+				       const u8 *data, int rounds);
 
 static int sha1_sparc64_update(struct shash_desc *desc, const u8 *data,
 			       unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA1_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buffer + partial, data, len);
-	} else
-		__sha1_sparc64_update(sctx, data, len, partial);
-
-	return 0;
+	return sha1_base_do_update_blocks(desc, data, len,
+					  sha1_sparc64_transform);
 }
 
 /* Add padding and return the message digest. */
-static int sha1_sparc64_final(struct shash_desc *desc, u8 *out)
+static int sha1_sparc64_finup(struct shash_desc *desc, const u8 *src,
+			      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA1_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA1_BLOCK_SIZE+56) - index);
-
-	/* We need to fill a whole block for __sha1_sparc64_update() */
-	if (padlen <= 56) {
-		sctx->count += padlen;
-		memcpy(sctx->buffer + index, padding, padlen);
-	} else {
-		__sha1_sparc64_update(sctx, padding, padlen, index);
-	}
-	__sha1_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha1_sparc64_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha1_sparc64_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
+	sha1_base_do_finup(desc, src, len, sha1_sparc64_transform);
+	return sha1_base_finish(desc, out);
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_sparc64_update,
-	.final		=	sha1_sparc64_final,
-	.export		=	sha1_sparc64_export,
-	.import		=	sha1_sparc64_import,
-	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.finup		=	sha1_sparc64_finup,
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-sparc64",
 		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

