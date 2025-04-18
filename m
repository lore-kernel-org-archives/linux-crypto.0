Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D229D269808
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945177; cv=none; b=b4QgEESXr78qxHURHMU9Z6cCmSzPNmx80Ce5WRm3C53ZUmN+uzm8O5GqKHRF1wAFHPzQpR5LHrDb6waiw2UwKYmcsYiYq5ZtcRkOYxQ3t0BTg4nxwRckVi2vtuuDZIyUdi9/UNDzU3ShDK5EaGsF4oQNOEIIpqcLKlS3BqYg6/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945177; c=relaxed/simple;
	bh=Su9iK2YH88IBwQKXDeFvGX8es3oNEADGlva7VlPQ568=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=BrAPxhXMYN5itwAPTED18Xje5Z7CqrekDBol1hIllFhrN8K36/fbxrUDD0y1X4OgGIC3kUOV3v6JdRFvpnK4Qnt/Axit/l7/p7RP1JywdgV86RaK/6rOV2xT7CjIQCKNxG5S/t6zxVSAYMdqfPshn9p0vkO/+IdaZiJ5Xu5k4eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kWMB4ao8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kWMB4ao8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JvC5t14FIC1EOeuXrZIVKVJ/tLhw6JU+wozDQQgP25w=; b=kWMB4ao8J/gFCRwGY6JcoNZ4iX
	ZdUVM8cmG/vzFqjqPyE9/Tzx467UwneydhAQ9xwdxgU+Oyn/rfVA+G6PMpPQEIVDpxzZZYv4ZWriw
	Ube+AYy3YlmQfU0zJ8Q2AKAwZRJ06Jhr+q0HY+QFGXwhZVop4crqiDjbrkPyJwbxVbJzIwydOmzMb
	TAlJ0Vglpwx0cJ2JybQ32ixpmKdQjE8ee7fPYp8r4OVY0AALRrh3iBCKc9NPlUYZuMHtBDL8YbLnn
	6Zg93sp+GG+yMUm2QS1wSdGYrXbHI8nQastRNREg+JWDQMePF1JPzxBvR2kpb7WirRh4ikARbMFAR
	9nmXFE2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwy-00Ge7b-09;
	Fri, 18 Apr 2025 10:59:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:31 +0800
Date: Fri, 18 Apr 2025 10:59:31 +0800
Message-Id: <a1a5e860999d1df4d5b83aafb8e5353cb155c683.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 23/67] crypto: powerpc/sha1-spe - Use API partial block
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
 arch/powerpc/crypto/sha1-spe-glue.c | 132 +++++-----------------------
 1 file changed, 24 insertions(+), 108 deletions(-)

diff --git a/arch/powerpc/crypto/sha1-spe-glue.c b/arch/powerpc/crypto/sha1-spe-glue.c
index 9170892a8557..04c88e173ce1 100644
--- a/arch/powerpc/crypto/sha1-spe-glue.c
+++ b/arch/powerpc/crypto/sha1-spe-glue.c
@@ -7,16 +7,13 @@
  * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
  */
 
+#include <asm/switch_to.h>
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-#include <asm/byteorder.h>
-#include <asm/switch_to.h>
-#include <linux/hardirq.h>
+#include <linux/kernel.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
 
 /*
  * MAX_BYTES defines the number of bytes that are allowed to be processed
@@ -30,7 +27,7 @@
  */
 #define MAX_BYTES 2048
 
-extern void ppc_spe_sha1_transform(u32 *state, const u8 *src, u32 blocks);
+asmlinkage void ppc_spe_sha1_transform(u32 *state, const u8 *src, u32 blocks);
 
 static void spe_begin(void)
 {
@@ -46,126 +43,45 @@ static void spe_end(void)
 	preempt_enable();
 }
 
-static inline void ppc_sha1_clear_context(struct sha1_state *sctx)
+static void ppc_spe_sha1_block(struct sha1_state *sctx, const u8 *src,
+			       int blocks)
 {
-	int count = sizeof(struct sha1_state) >> 2;
-	u32 *ptr = (u32 *)sctx;
+	do {
+		int unit = min(blocks, MAX_BYTES / SHA1_BLOCK_SIZE);
 
-	/* make sure we can clear the fast way */
-	BUILD_BUG_ON(sizeof(struct sha1_state) % 4);
-	do { *ptr++ = 0; } while (--count);
+		spe_begin();
+		ppc_spe_sha1_transform(sctx->state, src, unit);
+		spe_end();
+
+		src += unit * SHA1_BLOCK_SIZE;
+		blocks -= unit;
+	} while (blocks);
 }
 
 static int ppc_spe_sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->count & 0x3f;
-	const unsigned int avail = 64 - offset;
-	unsigned int bytes;
-	const u8 *src = data;
-
-	if (avail > len) {
-		sctx->count += len;
-		memcpy((char *)sctx->buffer + offset, src, len);
-		return 0;
-	}
-
-	sctx->count += len;
-
-	if (offset) {
-		memcpy((char *)sctx->buffer + offset, src, avail);
-
-		spe_begin();
-		ppc_spe_sha1_transform(sctx->state, (const u8 *)sctx->buffer, 1);
-		spe_end();
-
-		len -= avail;
-		src += avail;
-	}
-
-	while (len > 63) {
-		bytes = (len > MAX_BYTES) ? MAX_BYTES : len;
-		bytes = bytes & ~0x3f;
-
-		spe_begin();
-		ppc_spe_sha1_transform(sctx->state, src, bytes >> 6);
-		spe_end();
-
-		src += bytes;
-		len -= bytes;
-	}
-
-	memcpy((char *)sctx->buffer, src, len);
-	return 0;
+	return sha1_base_do_update_blocks(desc, data, len, ppc_spe_sha1_block);
 }
 
-static int ppc_spe_sha1_final(struct shash_desc *desc, u8 *out)
+static int ppc_spe_sha1_finup(struct shash_desc *desc, const u8 *src,
+			      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->count & 0x3f;
-	char *p = (char *)sctx->buffer + offset;
-	int padlen;
-	__be64 *pbits = (__be64 *)(((char *)&sctx->buffer) + 56);
-	__be32 *dst = (__be32 *)out;
-
-	padlen = 55 - offset;
-	*p++ = 0x80;
-
-	spe_begin();
-
-	if (padlen < 0) {
-		memset(p, 0x00, padlen + sizeof (u64));
-		ppc_spe_sha1_transform(sctx->state, sctx->buffer, 1);
-		p = (char *)sctx->buffer;
-		padlen = 56;
-	}
-
-	memset(p, 0, padlen);
-	*pbits = cpu_to_be64(sctx->count << 3);
-	ppc_spe_sha1_transform(sctx->state, sctx->buffer, 1);
-
-	spe_end();
-
-	dst[0] = cpu_to_be32(sctx->state[0]);
-	dst[1] = cpu_to_be32(sctx->state[1]);
-	dst[2] = cpu_to_be32(sctx->state[2]);
-	dst[3] = cpu_to_be32(sctx->state[3]);
-	dst[4] = cpu_to_be32(sctx->state[4]);
-
-	ppc_sha1_clear_context(sctx);
-	return 0;
-}
-
-static int ppc_spe_sha1_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int ppc_spe_sha1_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha1_base_do_finup(desc, src, len, ppc_spe_sha1_block);
+	return sha1_base_finish(desc, out);
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	ppc_spe_sha1_update,
-	.final		=	ppc_spe_sha1_final,
-	.export		=	ppc_spe_sha1_export,
-	.import		=	ppc_spe_sha1_import,
-	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.finup		=	ppc_spe_sha1_finup,
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-ppc-spe",
 		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

