Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D69C238D2B
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785851; cv=none; b=OI/IVef6uaLUv4L1EEA5FpWNb2EueEwtPM1JJBKO7A0A/wE+ib5deXtjyOwKZVZEvZdWbrmddN+suZgXWqYUhgcSaiE7wCOc24pFV2oQ1kaczfUZo/gZTAnJNgrJ7vMvRuPCjJlrByY3kXpv5dqTAwxnDoLs2/yL+vI6rRmpYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785851; c=relaxed/simple;
	bh=eX6xV/nmDa0QcOCV6kZEhe57s6PCpXDkQA/O+TMM7aU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=elquZ/NJEpXm0QGlQs5HtlhMW3dJ356uP7hRgHY90mHK8pD6ITlSoYQZLK4I1wyL2AJJzlZm+jbpHznBSMlsldy2zcRw0yQsiUDJ0LJ9+/Zh4OYbkmVhPL6Zro6FQeZeEnUDh9EQppQJgK91ydKWq7IwxjWwKEAu2UR33+lcbxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j23Zt/cf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j23Zt/cf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Dx+yYrikgblWwrLGpIRzgewqSEQ86JJ2P/ebhOklqdE=; b=j23Zt/cfT0l4L0AzLgmjkiBvlY
	VYXCypSVJ3ppJ+arsD45qcXTAt+N/PEt5X8q7wb9UoOLZfLABGOCEsR2MwAAyZ0aMgd/VzePZy16r
	LEtHZfHcDpyAuSwRyST+2p2GCLRV/WoJNWgO63bqVcQDvaaOxCq2DTIKzXEocIhwdOjh9ldhqgCI7
	YBYC8Dso9X4MhpNhGFlVzYaE7/yo+mUbD9V43RcoZ29sqf0vp/sVj8NGjZat8bxy1EryXjsKnNscp
	KPHVcsXEm6G4IoQyAKd+9eww7jK4Ba60YUgUB6ZII74nxdVPEB6UNX5bayoi03cQ2MB2AFheBtYqe
	2CCTo7cg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVB-00G6N8-2g;
	Wed, 16 Apr 2025 14:44:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:05 +0800
Date: Wed, 16 Apr 2025 14:44:05 +0800
Message-Id: <d2693d3db53efea49089c72c7eefe3348583f07e.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 36/67] crypto: powerpc/sha256-spe - Use API partial block
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
 arch/powerpc/crypto/sha256-spe-glue.c | 167 +++++---------------------
 1 file changed, 30 insertions(+), 137 deletions(-)

diff --git a/arch/powerpc/crypto/sha256-spe-glue.c b/arch/powerpc/crypto/sha256-spe-glue.c
index 2997d13236e0..42c76bf8062d 100644
--- a/arch/powerpc/crypto/sha256-spe-glue.c
+++ b/arch/powerpc/crypto/sha256-spe-glue.c
@@ -8,16 +8,13 @@
  * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
  */
 
+#include <asm/switch_to.h>
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-#include <asm/byteorder.h>
-#include <asm/switch_to.h>
-#include <linux/hardirq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/preempt.h>
 
 /*
  * MAX_BYTES defines the number of bytes that are allowed to be processed
@@ -47,151 +44,48 @@ static void spe_end(void)
 	preempt_enable();
 }
 
-static inline void ppc_sha256_clear_context(struct sha256_state *sctx)
+static void ppc_spe_sha256_block(struct crypto_sha256_state *sctx,
+				 const u8 *src, int blocks)
 {
-	int count = sizeof(struct sha256_state) >> 2;
-	u32 *ptr = (u32 *)sctx;
+	do {
+		/* cut input data into smaller blocks */
+		int unit = min(blocks, MAX_BYTES / SHA256_BLOCK_SIZE);
 
-	/* make sure we can clear the fast way */
-	BUILD_BUG_ON(sizeof(struct sha256_state) % 4);
-	do { *ptr++ = 0; } while (--count);
+		spe_begin();
+		ppc_spe_sha256_transform(sctx->state, src, unit);
+		spe_end();
+
+		src += unit * SHA256_BLOCK_SIZE;
+		blocks -= unit;
+	} while (blocks);
 }
 
 static int ppc_spe_sha256_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->count & 0x3f;
-	const unsigned int avail = 64 - offset;
-	unsigned int bytes;
-	const u8 *src = data;
-
-	if (avail > len) {
-		sctx->count += len;
-		memcpy((char *)sctx->buf + offset, src, len);
-		return 0;
-	}
-
-	sctx->count += len;
-
-	if (offset) {
-		memcpy((char *)sctx->buf + offset, src, avail);
-
-		spe_begin();
-		ppc_spe_sha256_transform(sctx->state, (const u8 *)sctx->buf, 1);
-		spe_end();
-
-		len -= avail;
-		src += avail;
-	}
-
-	while (len > 63) {
-		/* cut input data into smaller blocks */
-		bytes = (len > MAX_BYTES) ? MAX_BYTES : len;
-		bytes = bytes & ~0x3f;
-
-		spe_begin();
-		ppc_spe_sha256_transform(sctx->state, src, bytes >> 6);
-		spe_end();
-
-		src += bytes;
-		len -= bytes;
-	}
-
-	memcpy((char *)sctx->buf, src, len);
-	return 0;
+	return sha256_base_do_update_blocks(desc, data, len,
+					    ppc_spe_sha256_block);
 }
 
-static int ppc_spe_sha256_final(struct shash_desc *desc, u8 *out)
+static int ppc_spe_sha256_finup(struct shash_desc *desc, const u8 *src,
+				unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->count & 0x3f;
-	char *p = (char *)sctx->buf + offset;
-	int padlen;
-	__be64 *pbits = (__be64 *)(((char *)&sctx->buf) + 56);
-	__be32 *dst = (__be32 *)out;
-
-	padlen = 55 - offset;
-	*p++ = 0x80;
-
-	spe_begin();
-
-	if (padlen < 0) {
-		memset(p, 0x00, padlen + sizeof (u64));
-		ppc_spe_sha256_transform(sctx->state, sctx->buf, 1);
-		p = (char *)sctx->buf;
-		padlen = 56;
-	}
-
-	memset(p, 0, padlen);
-	*pbits = cpu_to_be64(sctx->count << 3);
-	ppc_spe_sha256_transform(sctx->state, sctx->buf, 1);
-
-	spe_end();
-
-	dst[0] = cpu_to_be32(sctx->state[0]);
-	dst[1] = cpu_to_be32(sctx->state[1]);
-	dst[2] = cpu_to_be32(sctx->state[2]);
-	dst[3] = cpu_to_be32(sctx->state[3]);
-	dst[4] = cpu_to_be32(sctx->state[4]);
-	dst[5] = cpu_to_be32(sctx->state[5]);
-	dst[6] = cpu_to_be32(sctx->state[6]);
-	dst[7] = cpu_to_be32(sctx->state[7]);
-
-	ppc_sha256_clear_context(sctx);
-	return 0;
-}
-
-static int ppc_spe_sha224_final(struct shash_desc *desc, u8 *out)
-{
-	__be32 D[SHA256_DIGEST_SIZE >> 2];
-	__be32 *dst = (__be32 *)out;
-
-	ppc_spe_sha256_final(desc, (u8 *)D);
-
-	/* avoid bytewise memcpy */
-	dst[0] = D[0];
-	dst[1] = D[1];
-	dst[2] = D[2];
-	dst[3] = D[3];
-	dst[4] = D[4];
-	dst[5] = D[5];
-	dst[6] = D[6];
-
-	/* clear sensitive data */
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-	return 0;
-}
-
-static int ppc_spe_sha256_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int ppc_spe_sha256_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha256_base_do_finup(desc, src, len, ppc_spe_sha256_block);
+	return sha256_base_finish(desc, out);
 }
 
 static struct shash_alg algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	ppc_spe_sha256_update,
-	.final		=	ppc_spe_sha256_final,
-	.export		=	ppc_spe_sha256_export,
-	.import		=	ppc_spe_sha256_import,
-	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.finup		=	ppc_spe_sha256_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-ppc-spe",
 		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -199,15 +93,14 @@ static struct shash_alg algs[2] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	ppc_spe_sha256_update,
-	.final		=	ppc_spe_sha224_final,
-	.export		=	ppc_spe_sha256_export,
-	.import		=	ppc_spe_sha256_import,
-	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.finup		=	ppc_spe_sha256_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"sha224-ppc-spe",
 		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

