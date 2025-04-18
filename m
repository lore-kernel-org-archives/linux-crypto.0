Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D386A268C7C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945163; cv=none; b=O67BQvcp8LixKd9h9Se2LlHSYaanCb7q71isgU6lflXjtlHsk4VAoI3B+aDym5wb0m5uBFKOa5vUq9L/ETwT+RIDXVv3lyzqMnXZmahh4BPoAh3PJ2g54A6G4ZufArLSVgBoGhND0GNg7n9mURwVuCmWcpDWfSfFTOS9O58oLiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945163; c=relaxed/simple;
	bh=clqnAkTIh6ydPByeVeZ87ciE6YSAEhIiiY4Wt4fnemE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=WHn/jmMEpv52ccLB11qjLs17Ql6sMkIOv9J0eH4dQRi7tgILwf37q6Xoaz/JimojTaciGR15vpMQHUFCI7CMd6iWOBGLtx7+BVHT3B6iUGxobEsSKl3rp3Wsj9dhCNGANZtCiQ41Gw+EV8XcSm8VaN3Ldyj3aC+3YSAcTi1lROc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UrZriDv4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UrZriDv4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PDBmF/+h0s7vk22BK7y6sFER5TBdR/31rVBU1r+T7JY=; b=UrZriDv4qNUuu3b5vhGBHpQUEe
	gYn5fK2yAmb+lzXZjjQGsGBKijSdJ1HkJGXL3iNO2n7ipXcHA6FTL5ssUhwj+pFuap6MfZcz/I3rf
	L9+2ZDabpgXkFy5F9hO+UZ4GjcH353acD1ZkPZ12gWiS+YWxKjhXywgO1p/h2eP8jqCYNlPXhV/V/
	9+KdsG6hFOOtqOB5bi876/7ZdgckDJRa2DA+Fo1Lv1TqialA54etl9aK0kB3RLXJ4vOgtUM0umSJp
	402kRg4lZ95y3FiuWxDS/nGY0dBBj6xDQlpPPPWtOVlOsbkc8veFWwkaTMxnYz3aJW68h5BLt4XJ2
	OzU2jXkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwk-00Ge5N-0K;
	Fri, 18 Apr 2025 10:59:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:18 +0800
Date: Fri, 18 Apr 2025 10:59:18 +0800
Message-Id: <d0990c633839ba7f1a57e3179a44a2ddd04959cf.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 17/67] crypto: mips/octeon-sha1 - Use API partial block
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
 arch/mips/cavium-octeon/crypto/octeon-sha1.c | 136 ++++---------------
 1 file changed, 30 insertions(+), 106 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha1.c b/arch/mips/cavium-octeon/crypto/octeon-sha1.c
index 37a07b3c4568..e70f21a473da 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-sha1.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-sha1.c
@@ -13,15 +13,13 @@
  * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  */
 
-#include <linux/mm.h>
-#include <crypto/sha1.h>
-#include <crypto/sha1_base.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
 #include <crypto/internal/hash.h>
+#include <crypto/sha1.h>
+#include <crypto/sha1_base.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "octeon-crypto.h"
 
@@ -58,49 +56,23 @@ static void octeon_sha1_read_hash(struct sha1_state *sctx)
 	memzero_explicit(&hash_tail.dword, sizeof(hash_tail.dword));
 }
 
-static void octeon_sha1_transform(const void *_block)
+static void octeon_sha1_transform(struct sha1_state *sctx, const u8 *src,
+				  int blocks)
 {
-	const u64 *block = _block;
+	do {
+		const u64 *block = (const u64 *)src;
 
-	write_octeon_64bit_block_dword(block[0], 0);
-	write_octeon_64bit_block_dword(block[1], 1);
-	write_octeon_64bit_block_dword(block[2], 2);
-	write_octeon_64bit_block_dword(block[3], 3);
-	write_octeon_64bit_block_dword(block[4], 4);
-	write_octeon_64bit_block_dword(block[5], 5);
-	write_octeon_64bit_block_dword(block[6], 6);
-	octeon_sha1_start(block[7]);
-}
+		write_octeon_64bit_block_dword(block[0], 0);
+		write_octeon_64bit_block_dword(block[1], 1);
+		write_octeon_64bit_block_dword(block[2], 2);
+		write_octeon_64bit_block_dword(block[3], 3);
+		write_octeon_64bit_block_dword(block[4], 4);
+		write_octeon_64bit_block_dword(block[5], 5);
+		write_octeon_64bit_block_dword(block[6], 6);
+		octeon_sha1_start(block[7]);
 
-static void __octeon_sha1_update(struct sha1_state *sctx, const u8 *data,
-				 unsigned int len)
-{
-	unsigned int partial;
-	unsigned int done;
-	const u8 *src;
-
-	partial = sctx->count % SHA1_BLOCK_SIZE;
-	sctx->count += len;
-	done = 0;
-	src = data;
-
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data,
-			       done + SHA1_BLOCK_SIZE);
-			src = sctx->buffer;
-		}
-
-		do {
-			octeon_sha1_transform(src);
-			done += SHA1_BLOCK_SIZE;
-			src = data + done;
-		} while (done + SHA1_BLOCK_SIZE <= len);
-
-		partial = 0;
-	}
-	memcpy(sctx->buffer + partial, src, len - done);
+		src += SHA1_BLOCK_SIZE;
+	} while (--blocks);
 }
 
 static int octeon_sha1_update(struct shash_desc *desc, const u8 *data,
@@ -109,95 +81,47 @@ static int octeon_sha1_update(struct shash_desc *desc, const u8 *data,
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 	struct octeon_cop2_state state;
 	unsigned long flags;
-
-	/*
-	 * Small updates never reach the crypto engine, so the generic sha1 is
-	 * faster because of the heavyweight octeon_crypto_enable() /
-	 * octeon_crypto_disable().
-	 */
-	if ((sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
-		return crypto_sha1_update(desc, data, len);
+	int remain;
 
 	flags = octeon_crypto_enable(&state);
 	octeon_sha1_store_hash(sctx);
 
-	__octeon_sha1_update(sctx, data, len);
+	remain = sha1_base_do_update_blocks(desc, data, len,
+					    octeon_sha1_transform);
 
 	octeon_sha1_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	return 0;
+	return remain;
 }
 
-static int octeon_sha1_final(struct shash_desc *desc, u8 *out)
+static int octeon_sha1_finup(struct shash_desc *desc, const u8 *src,
+			     unsigned int len, u8 *out)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	static const u8 padding[64] = { 0x80, };
 	struct octeon_cop2_state state;
-	__be32 *dst = (__be32 *)out;
-	unsigned int pad_len;
 	unsigned long flags;
-	unsigned int index;
-	__be64 bits;
-	int i;
-
-	/* Save number of bits. */
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64. */
-	index = sctx->count & 0x3f;
-	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
 
 	flags = octeon_crypto_enable(&state);
 	octeon_sha1_store_hash(sctx);
 
-	__octeon_sha1_update(sctx, padding, pad_len);
-
-	/* Append length (before padding). */
-	__octeon_sha1_update(sctx, (const u8 *)&bits, sizeof(bits));
+	sha1_base_do_finup(desc, src, len, octeon_sha1_transform);
 
 	octeon_sha1_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int octeon_sha1_export(struct shash_desc *desc, void *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int octeon_sha1_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	return sha1_base_finish(desc, out);
 }
 
 static struct shash_alg octeon_sha1_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	octeon_sha1_update,
-	.final		=	octeon_sha1_final,
-	.export		=	octeon_sha1_export,
-	.import		=	octeon_sha1_import,
-	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.finup		=	octeon_sha1_finup,
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"octeon-sha1",
 		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

