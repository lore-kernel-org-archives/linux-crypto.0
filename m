Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDBF236A6A
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785818; cv=none; b=MLOwFrTR3bsOc0qcC6mzf7PJ+mw3PM8CcfyrR8hB+hH3YE6eMiwNb0J+IkFJwYnostTCFKB/Yp1aM6dEH8fkIKUbGPWqhgZsP72ou6p2HZLy6bzQi7svSRSDYCHT8+yhQvKGjGFf0jdS46lK4yxZ4JLuF0YPtLdD5o7SbxDNB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785818; c=relaxed/simple;
	bh=WjGD+JKwDOWANozhCmmKJ1JnQwYcsU+oBj9fQ9n5okA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=N2KgwPczX/jHkS74yPnlwhWnDzTigwxYHOAygb6PQHWtTLDbXQO2jVQhiXGrgYSZT6xHF59cJU+/wICsSS9GTiSbjBTw0t+Q3zlBX4+kim+wzDt0Olv8rtm05yPc2RCoodaUQ6Y8U7o7XZH4ig8ZxTNCJkavTQzSjN6Ve/a0a+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=F0DIq/ga; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="F0DIq/ga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P7mo4IQNb4w10SURP8Sq3erLDXmkSgq6c7S5BK2/wcA=; b=F0DIq/gaDdj53nYbrF0toeaJ0z
	RmTGsaC4QNFdNBXIO+t/bqnZD8UUOVLYktFMWevBXxOUqq8sAZtW3/IsFhxUwO8X42LySdcOo7TzR
	ev1PlyUDE+saPPGg/ZS3mepd5GfnfpCmRdi+i/Psak3zcCKfOznQRmE+1++mwmyC7WsngnL3gKMwL
	sPn3ahcZRIa9pGTNVnvVKMApDBK8VJ0dVV9ShZbfLr0WZxnP7vyVuaMKLYCFJx4AuZTUnxOsK7inA
	Anx5FPxGvNeFoYBqOiKG6j7NruhSZlvbm4KA/vTiWeHFurmDKUWnikIo1NVSj+Sfncmj/blRZxyII
	kGY29fhw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUf-00G6KE-1s;
	Wed, 16 Apr 2025 14:43:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:33 +0800
Date: Wed, 16 Apr 2025 14:43:33 +0800
Message-Id: <25e990c507fe35fef1c24831596f92805efc4155.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 22/67] crypto: powerpc/sha1 - Use API partial block handling
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

