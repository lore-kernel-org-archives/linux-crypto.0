Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F677268C7F
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945161; cv=none; b=EalPOhcmi1woPKwoUS4AVB9d7HkA371tyb9G9nJWAdxQ08WmwD7vUH5ZVAd4faNWKLhJUCUeGrzs+ouou5AXO9hY0eyM+MMqZZcwj5JKThCyp3kweFxBP7pFCh+INdpadRNEdnVDudbYfyXJp7KQuW7rzmijLG3XwVlBvHyoIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945161; c=relaxed/simple;
	bh=Yv1TStM5qFq8TpMfM6Z+N6vrmz6+NO7lkLyCu6CPkd4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=e/3yUoih6p96gSPVNVti8qaZcz8X1lJSJzZVT/W6ifDCqDarMS21+veaRRAgbHJlYH1xvTvbtjvNKWxO1TejVdRmq2tUjIYEy2FmxT7b638fWqahm4RTekmTpktqlifEJERvD+xIC3qAdnXbl1M9yyB41Ob9HpaqFSfYWUbX/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WSg0Flfg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WSg0Flfg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hnfVB+Rj7mD0zvjzpVYeiOaPqZ0w6vyNWu5t53OF54w=; b=WSg0FlfgsE2KnOvLJKRK4YDgYz
	6wpsvqhxnr1c2QE7q7uhc7fmTUnQWZekcuNUgFZdoVThiiVKBGpNsTIHHVdINEdXR5YApdKbsM2w1
	uyAqLG+IVb9rl4CnUrb7kUT+1vs/OZbwfiYiyfqHhp7A8LdX+AT0L+M20TDM+yXFbKTgITi0GF5v4
	YNyVJe/ByFOClexxsZP2Z0vVbhN+ZZIruybB4aNrzBo980dd5MQf1/GNX0JtNg0xPYpUqCUolMeOU
	WvlXVXf6VqulI1XZlnn0d7nvdnZAzduvzRZ4Choz9AXqZRR1110Qe6JEl9jTxaFAhGByvROwVjGHw
	i/05VO3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwh-00Ge5C-2a;
	Fri, 18 Apr 2025 10:59:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:15 +0800
Date: Fri, 18 Apr 2025 10:59:15 +0800
Message-Id: <91153261fcfcf1fbf4823c150f58ba4127b5d642.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 16/67] crypto: arm64/sha1 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha1-ce-glue.c | 66 ++++++++------------------------
 1 file changed, 17 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index cbd14f208f83..1f8c93fe1e64 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -7,14 +7,14 @@
 
 #include <asm/neon.h>
 #include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
@@ -56,79 +56,47 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!crypto_simd_usable())
-		return crypto_sha1_update(desc, data, len);
-
 	sctx->finalize = 0;
-	sha1_base_do_update(desc, data, len, sha1_ce_transform);
-
-	return 0;
+	return sha1_base_do_update_blocks(desc, data, len, sha1_ce_transform);
 }
 
 static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
-
-	if (!crypto_simd_usable())
-		return crypto_sha1_finup(desc, data, len, out);
+	bool finalized = false;
 
 	/*
 	 * Allow the asm code to perform the finalization if there is no
 	 * partial data and the input is a round multiple of the block size.
 	 */
-	sctx->finalize = finalize;
+	if (len >= SHA1_BLOCK_SIZE) {
+		unsigned int remain = len - round_down(len, SHA1_BLOCK_SIZE);
 
-	sha1_base_do_update(desc, data, len, sha1_ce_transform);
-	if (!finalize)
-		sha1_base_do_finalize(desc, sha1_ce_transform);
+		finalized = !remain;
+		sctx->finalize = finalized;
+		sha1_base_do_update_blocks(desc, data, len, sha1_ce_transform);
+		data += len - remain;
+		len = remain;
+	}
+	if (!finalized)
+		sha1_base_do_finup(desc, data, len, sha1_ce_transform);
 	return sha1_base_finish(desc, out);
 }
 
-static int sha1_ce_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable())
-		return crypto_sha1_finup(desc, NULL, 0, out);
-
-	sctx->finalize = 0;
-	sha1_base_do_finalize(desc, sha1_ce_transform);
-	return sha1_base_finish(desc, out);
-}
-
-static int sha1_ce_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, &sctx->sst, sizeof(struct sha1_state));
-	return 0;
-}
-
-static int sha1_ce_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(&sctx->sst, in, sizeof(struct sha1_state));
-	sctx->finalize = 0;
-	return 0;
-}
-
 static struct shash_alg alg = {
 	.init			= sha1_base_init,
 	.update			= sha1_ce_update,
-	.final			= sha1_ce_final,
 	.finup			= sha1_ce_finup,
-	.import			= sha1_ce_import,
-	.export			= sha1_ce_export,
 	.descsize		= sizeof(struct sha1_ce_state),
-	.statesize		= sizeof(struct sha1_state),
+	.statesize		= SHA1_STATE_SIZE,
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sha1-ce",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

