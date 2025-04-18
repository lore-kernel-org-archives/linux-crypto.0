Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A630268FEF
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945175; cv=none; b=THmrkn6ZD9k9SRjjqQhNs3Fl0pzty9QkJholHEkEvpZp5s7H8r2GPV29jhq6D+cRaWMDaJYid6YTOGzM2qOW/zWFxH5Y9MvVSUDCtbOkVlTA3XbxKvfA6gPTNi0PFEXHvwRGBW5ijaQPQj2PYvnI2PS1+TrmomGS1VUY2M0Gxao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945175; c=relaxed/simple;
	bh=WjGD+JKwDOWANozhCmmKJ1JnQwYcsU+oBj9fQ9n5okA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=qV/qFRJb7kevtOMsTX72vpkeMTp4ez8YUx5hcIBTkkV29LbNnhtOtxksDdjRPbaTJ/ML5vLCthPelFwncaVw361BLnfkfyBJGUcJuv2cF5iKl7AhOpw5LovQNKLpVFifIZFBYnT5nQhGg60FFd59ownH/DD9yhbGkWPgH1BwAcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=F2dg1Sd3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="F2dg1Sd3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P7mo4IQNb4w10SURP8Sq3erLDXmkSgq6c7S5BK2/wcA=; b=F2dg1Sd38RE9XevznkJx78hzMX
	DextVu0cTpwOeMDNZ5nI8yT/2FTIwi2gc2pZG5rxQumvMvRw/kndqE1CVAkRTDCmhMC+iGtbYz1uz
	VYx5DANGGmQILm/d0h6UhqLS65hhgQqp0QTrOB7ESnVeuIvWRXLwEXcvHbN2zpeoOvDfM8FEDfAPL
	avjrXy1ciK0IK0mCyA0nm7WCJxk8sy/WUZj9bMz2xtRwKXci5sBnTu+sRpHUI6XK9oV/3ZoBQ2oU/
	nhKCwRoSgW3tGL6h15rbpKAwwEi2kId61CQDx0V8PJpWgUArZ3LGgJ2CcYuSGpOB3uVfH6Px8693F
	qSr2GGBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwv-00Ge7Q-2D;
	Fri, 18 Apr 2025 10:59:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:29 +0800
Date: Fri, 18 Apr 2025 10:59:29 +0800
Message-Id: <29a245fb882f8edef2de2bac122de37a11b67851.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 22/67] crypto: powerpc/sha1 - Use API partial block
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
 arch/powerpc/crypto/sha1.c | 101 ++++++++-----------------------------
 1 file changed, 20 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/crypto/sha1.c b/arch/powerpc/crypto/sha1.c
index f283bbd3f121..4593946aa9b3 100644
--- a/arch/powerpc/crypto/sha1.c
+++ b/arch/powerpc/crypto/sha1.c
@@ -13,107 +13,46 @@
  * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  */
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
-void powerpc_sha_transform(u32 *state, const u8 *src);
+asmlinkage void powerpc_sha_transform(u32 *state, const u8 *src);
+
+static void powerpc_sha_block(struct sha1_state *sctx, const u8 *data,
+			      int blocks)
+{
+	do {
+		powerpc_sha_transform(sctx->state, data);
+		data += 64;
+	} while (--blocks);
+}
 
 static int powerpc_sha1_update(struct shash_desc *desc, const u8 *data,
 			       unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
-
-	partial = sctx->count & 0x3f;
-	sctx->count += len;
-	done = 0;
-	src = data;
-
-	if ((partial + len) > 63) {
-
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data, done + 64);
-			src = sctx->buffer;
-		}
-
-		do {
-			powerpc_sha_transform(sctx->state, src);
-			done += 64;
-			src = data + done;
-		} while (done + 63 < len);
-
-		partial = 0;
-	}
-	memcpy(sctx->buffer + partial, src, len - done);
-
-	return 0;
+	return sha1_base_do_update_blocks(desc, data, len, powerpc_sha_block);
 }
 
-
 /* Add padding and return the message digest. */
-static int powerpc_sha1_final(struct shash_desc *desc, u8 *out)
+static int powerpc_sha1_finup(struct shash_desc *desc, const u8 *src,
+			      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	u32 i, index, padlen;
-	__be64 bits;
-	static const u8 padding[64] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 */
-	index = sctx->count & 0x3f;
-	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	powerpc_sha1_update(desc, padding, padlen);
-
-	/* Append length */
-	powerpc_sha1_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof *sctx);
-
-	return 0;
-}
-
-static int powerpc_sha1_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int powerpc_sha1_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha1_base_do_finup(desc, src, len, powerpc_sha_block);
+	return sha1_base_finish(desc, out);
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	powerpc_sha1_update,
-	.final		=	powerpc_sha1_final,
-	.export		=	powerpc_sha1_export,
-	.import		=	powerpc_sha1_import,
-	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.finup		=	powerpc_sha1_finup,
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-powerpc",
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

