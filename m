Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C4322DFBF
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785798; cv=none; b=qWwlzb8yl7SCwSC6RNSX4ze4JdazKvgGmQj+Q9DkeL6AKu3emmzBoDhOmEhK5nuytE6X8uacix0mbMZJ53mf5Z59Qg+BNABL1+Ftx+IUz3usLQzOE9RF2SIvVBZXxYgnvNTC7YE7BHgdTJFnEsg+a89N+aSFSEDDOB1GMyoEcPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785798; c=relaxed/simple;
	bh=vSgcwwsmZFBK83Lh5ZfJPmmkprfMOsVcYMVmb5Mtr4w=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=CqerVbPXqBaoseN/PfF1rNE7CSIfWWeBPYg8T6k3NcPsTyLFZHf211AkWG1OcGWQf5U6682V4rVHBQK729qs6KZ3MJHOp2Nyc8LepoJ0xbh/8jgfHJpnQPxaKTFmugYlTCzpIaS+kYLnnwqsT4RA+7nRZJGMOM+KGg51Xw+Q68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=krJ/d6L/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="krJ/d6L/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IZz/B1z3l0dYu5k7EBMEMikrHJNp518PW263qFxRvYE=; b=krJ/d6L/eWiqVtWgiJ9UJ/oQ63
	pI8JgLyd1+YQemoyI1+fezWAW/N2nFwABd1e3PU+tIoowT0NfUSRfSP4c8MCAjM1xv98RTounZS6L
	BuA1uCZaAqrwbw6u55w+aMvqdaAus5ghfIkAJUDXihDJKhuXmvjLo2hy7mVqTjGC9JDEs9mZ2mVI4
	GJkiYiPBk+n1nOeBhdC1So6AMSY+JHrw2EzsY5OPbvXihbnFTsSn2qPBjXUTcrBLYaS/TLHF9AWDb
	IbjCbUXeMjn1SXaXKylIO6Sz/B4tUw8vfzxd3Xin8E3QNlmaugX6wpVnfd8FOO+vzJibzsL9kcQUw
	nYLBBEvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUK-00G6Ic-2j;
	Wed, 16 Apr 2025 14:43:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:12 +0800
Date: Wed, 16 Apr 2025 14:43:12 +0800
Message-Id: <96989c73d3f132e0c3f595937642b73162d40ba5.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/67] crypto: powerpc/md5 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/powerpc/crypto/md5-glue.c | 99 +++++++---------------------------
 1 file changed, 20 insertions(+), 79 deletions(-)

diff --git a/arch/powerpc/crypto/md5-glue.c b/arch/powerpc/crypto/md5-glue.c
index c24f605033bd..204440a90cd8 100644
--- a/arch/powerpc/crypto/md5-glue.c
+++ b/arch/powerpc/crypto/md5-glue.c
@@ -8,25 +8,13 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/md5.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 extern void ppc_md5_transform(u32 *state, const u8 *src, u32 blocks);
 
-static inline void ppc_md5_clear_context(struct md5_state *sctx)
-{
-	int count = sizeof(struct md5_state) >> 2;
-	u32 *ptr = (u32 *)sctx;
-
-	/* make sure we can clear the fast way */
-	BUILD_BUG_ON(sizeof(struct md5_state) % 4);
-	do { *ptr++ = 0; } while (--count);
-}
-
 static int ppc_md5_init(struct shash_desc *desc)
 {
 	struct md5_state *sctx = shash_desc_ctx(desc);
@@ -44,79 +32,34 @@ static int ppc_md5_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	struct md5_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->byte_count & 0x3f;
-	unsigned int avail = 64 - offset;
-	const u8 *src = data;
 
-	sctx->byte_count += len;
-
-	if (avail > len) {
-		memcpy((char *)sctx->block + offset, src, len);
-		return 0;
-	}
-
-	if (offset) {
-		memcpy((char *)sctx->block + offset, src, avail);
-		ppc_md5_transform(sctx->hash, (const u8 *)sctx->block, 1);
-		len -= avail;
-		src += avail;
-	}
-
-	if (len > 63) {
-		ppc_md5_transform(sctx->hash, src, len >> 6);
-		src += len & ~0x3f;
-		len &= 0x3f;
-	}
-
-	memcpy((char *)sctx->block, src, len);
-	return 0;
+	sctx->byte_count += round_down(len, MD5_HMAC_BLOCK_SIZE);
+	ppc_md5_transform(sctx->hash, data, len >> 6);
+	return len - round_down(len, MD5_HMAC_BLOCK_SIZE);
 }
 
-static int ppc_md5_final(struct shash_desc *desc, u8 *out)
+static int ppc_md5_finup(struct shash_desc *desc, const u8 *src,
+			 unsigned int offset, u8 *out)
 {
 	struct md5_state *sctx = shash_desc_ctx(desc);
-	const unsigned int offset = sctx->byte_count & 0x3f;
-	const u8 *src = (const u8 *)sctx->block;
-	u8 *p = (u8 *)src + offset;
-	int padlen = 55 - offset;
-	__le64 *pbits = (__le64 *)((char *)sctx->block + 56);
+	__le64 block[MD5_BLOCK_WORDS] = {};
+	u8 *p = memcpy(block, src, offset);
 	__le32 *dst = (__le32 *)out;
+	__le64 *pbits;
 
+	src = p;
+	p += offset;
 	*p++ = 0x80;
-
-	if (padlen < 0) {
-		memset(p, 0x00, padlen + sizeof (u64));
-		ppc_md5_transform(sctx->hash, src, 1);
-		p = (char *)sctx->block;
-		padlen = 56;
-	}
-
-	memset(p, 0, padlen);
+	sctx->byte_count += offset;
+	pbits = &block[(MD5_BLOCK_WORDS / (offset > 55 ? 1 : 2)) - 1];
 	*pbits = cpu_to_le64(sctx->byte_count << 3);
-	ppc_md5_transform(sctx->hash, src, 1);
+	ppc_md5_transform(sctx->hash, src, (pbits - block + 1) / 8);
+	memzero_explicit(block, sizeof(block));
 
 	dst[0] = cpu_to_le32(sctx->hash[0]);
 	dst[1] = cpu_to_le32(sctx->hash[1]);
 	dst[2] = cpu_to_le32(sctx->hash[2]);
 	dst[3] = cpu_to_le32(sctx->hash[3]);
-
-	ppc_md5_clear_context(sctx);
-	return 0;
-}
-
-static int ppc_md5_export(struct shash_desc *desc, void *out)
-{
-	struct md5_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int ppc_md5_import(struct shash_desc *desc, const void *in)
-{
-	struct md5_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
 	return 0;
 }
 
@@ -124,15 +67,13 @@ static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	ppc_md5_init,
 	.update		=	ppc_md5_update,
-	.final		=	ppc_md5_final,
-	.export		=	ppc_md5_export,
-	.import		=	ppc_md5_import,
-	.descsize	=	sizeof(struct md5_state),
-	.statesize	=	sizeof(struct md5_state),
+	.finup		=	ppc_md5_finup,
+	.descsize	=	MD5_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"md5",
 		.cra_driver_name=	"md5-ppc",
 		.cra_priority	=	200,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

