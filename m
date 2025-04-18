Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C64267F6E
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945228; cv=none; b=rOr5fH4TCWn56V805HIVY9QKftcGWOFxNGNecsn7bZfEAdXVU3Wk4zFX7xZo2vDeO4QnIboWns7n8ZR+C9W5qcKdKZeohHZ+fVDIdlzDGSIv8n0NxzJ1MWKMl676OxMe5AWNQTapO0jWE0J1pqvKkgdinmBFP7GE700UJ72b5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945228; c=relaxed/simple;
	bh=aKizr4QM85eegn9lwWqWK93PIqAlICCda+52LGRMlWo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=F17bCxYcQlNpTl3pUsKEBIMcY67TaTe+/j4fUa19WNHjxTWvJWHA7g5dTjxwOoB3ZkfNKZNWLgE76UWb/r/DV4DHyijOA3vaQrL2/gKgLAkF+SuEQqxfOJIxVNjO7gNoT7Kbup3bgv8WWSk7czQjsneEOZkKmt81zhMGsiJWvv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=e8w1kUxb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="e8w1kUxb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/AnSWJWJLYN2EoqnshU0N4/bzL4fmyQmcG+XoLTEv2M=; b=e8w1kUxb2WY/dcjqENowEv+WtU
	cEm1jnjFWzY1CClHjDAXYTP/iRK36D930pR1JgaINh91mjDXVjMrhfhtio+mdeXQNeAKyAKBf1Rro
	jZNNUIBidCh0i8oAIes6gRRXXTf2oTsnVsF/KlcGl+yltaQT2T4By3WKhuTA5WXsa3HLWvEYOfmRK
	WIqXJX8i7PErybBYjWxRHabeFAVcUwdq2kpt1SDsNEzQpFayl2M/5XAybhgW9tSnSYf8a7Z0MdyES
	EkfzEe6GtFp8mxmpvNDfWaD8IPK7c58Nuvk4PXZ9PzKmhuOJm7ij2ZkKvWUc1nreBvk7xELskHUPY
	EfJEIKiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxm-00GeCQ-2O;
	Fri, 18 Apr 2025 11:00:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:22 +0800
Date: Fri, 18 Apr 2025 11:00:22 +0800
Message-Id: <aac053951ee6e19275bb143851e94ba0a0da0e60.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 45/67] crypto: mips/octeon-sha512 - Use API partial block
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
 .../mips/cavium-octeon/crypto/octeon-sha512.c | 155 +++++-------------
 1 file changed, 42 insertions(+), 113 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha512.c b/arch/mips/cavium-octeon/crypto/octeon-sha512.c
index 2dee9354e33f..215311053db3 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-sha512.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-sha512.c
@@ -13,15 +13,12 @@
  * Copyright (c) 2003 Kyle McMartin <kyle@debian.org>
  */
 
-#include <linux/mm.h>
-#include <crypto/sha2.h>
-#include <crypto/sha512_base.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
 #include <crypto/internal/hash.h>
+#include <crypto/sha2.h>
+#include <crypto/sha512_base.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "octeon-crypto.h"
 
@@ -53,60 +50,31 @@ static void octeon_sha512_read_hash(struct sha512_state *sctx)
 	sctx->state[7] = read_octeon_64bit_hash_sha512(7);
 }
 
-static void octeon_sha512_transform(const void *_block)
+static void octeon_sha512_transform(struct sha512_state *sctx,
+				    const u8 *src, int blocks)
 {
-	const u64 *block = _block;
+	do {
+		const u64 *block = (const u64 *)src;
 
-	write_octeon_64bit_block_sha512(block[0], 0);
-	write_octeon_64bit_block_sha512(block[1], 1);
-	write_octeon_64bit_block_sha512(block[2], 2);
-	write_octeon_64bit_block_sha512(block[3], 3);
-	write_octeon_64bit_block_sha512(block[4], 4);
-	write_octeon_64bit_block_sha512(block[5], 5);
-	write_octeon_64bit_block_sha512(block[6], 6);
-	write_octeon_64bit_block_sha512(block[7], 7);
-	write_octeon_64bit_block_sha512(block[8], 8);
-	write_octeon_64bit_block_sha512(block[9], 9);
-	write_octeon_64bit_block_sha512(block[10], 10);
-	write_octeon_64bit_block_sha512(block[11], 11);
-	write_octeon_64bit_block_sha512(block[12], 12);
-	write_octeon_64bit_block_sha512(block[13], 13);
-	write_octeon_64bit_block_sha512(block[14], 14);
-	octeon_sha512_start(block[15]);
-}
+		write_octeon_64bit_block_sha512(block[0], 0);
+		write_octeon_64bit_block_sha512(block[1], 1);
+		write_octeon_64bit_block_sha512(block[2], 2);
+		write_octeon_64bit_block_sha512(block[3], 3);
+		write_octeon_64bit_block_sha512(block[4], 4);
+		write_octeon_64bit_block_sha512(block[5], 5);
+		write_octeon_64bit_block_sha512(block[6], 6);
+		write_octeon_64bit_block_sha512(block[7], 7);
+		write_octeon_64bit_block_sha512(block[8], 8);
+		write_octeon_64bit_block_sha512(block[9], 9);
+		write_octeon_64bit_block_sha512(block[10], 10);
+		write_octeon_64bit_block_sha512(block[11], 11);
+		write_octeon_64bit_block_sha512(block[12], 12);
+		write_octeon_64bit_block_sha512(block[13], 13);
+		write_octeon_64bit_block_sha512(block[14], 14);
+		octeon_sha512_start(block[15]);
 
-static void __octeon_sha512_update(struct sha512_state *sctx, const u8 *data,
-				   unsigned int len)
-{
-	unsigned int part_len;
-	unsigned int index;
-	unsigned int i;
-
-	/* Compute number of bytes mod 128. */
-	index = sctx->count[0] % SHA512_BLOCK_SIZE;
-
-	/* Update number of bytes. */
-	if ((sctx->count[0] += len) < len)
-		sctx->count[1]++;
-
-	part_len = SHA512_BLOCK_SIZE - index;
-
-	/* Transform as many times as possible. */
-	if (len >= part_len) {
-		memcpy(&sctx->buf[index], data, part_len);
-		octeon_sha512_transform(sctx->buf);
-
-		for (i = part_len; i + SHA512_BLOCK_SIZE <= len;
-			i += SHA512_BLOCK_SIZE)
-			octeon_sha512_transform(&data[i]);
-
-		index = 0;
-	} else {
-		i = 0;
-	}
-
-	/* Buffer remaining input. */
-	memcpy(&sctx->buf[index], &data[i], len - i);
+		src += SHA512_BLOCK_SIZE;
+	} while (--blocks);
 }
 
 static int octeon_sha512_update(struct shash_desc *desc, const u8 *data,
@@ -115,89 +83,48 @@ static int octeon_sha512_update(struct shash_desc *desc, const u8 *data,
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 	struct octeon_cop2_state state;
 	unsigned long flags;
-
-	/*
-	 * Small updates never reach the crypto engine, so the generic sha512 is
-	 * faster because of the heavyweight octeon_crypto_enable() /
-	 * octeon_crypto_disable().
-	 */
-	if ((sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
-		return crypto_sha512_update(desc, data, len);
+	int remain;
 
 	flags = octeon_crypto_enable(&state);
 	octeon_sha512_store_hash(sctx);
 
-	__octeon_sha512_update(sctx, data, len);
+	remain = sha512_base_do_update_blocks(desc, data, len,
+					      octeon_sha512_transform);
 
 	octeon_sha512_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	return 0;
+	return remain;
 }
 
-static int octeon_sha512_final(struct shash_desc *desc, u8 *hash)
+static int octeon_sha512_finup(struct shash_desc *desc, const u8 *src,
+			       unsigned int len, u8 *hash)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
-	static u8 padding[128] = { 0x80, };
 	struct octeon_cop2_state state;
-	__be64 *dst = (__be64 *)hash;
-	unsigned int pad_len;
 	unsigned long flags;
-	unsigned int index;
-	__be64 bits[2];
-	int i;
-
-	/* Save number of bits. */
-	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
-
-	/* Pad out to 112 mod 128. */
-	index = sctx->count[0] & 0x7f;
-	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
 
 	flags = octeon_crypto_enable(&state);
 	octeon_sha512_store_hash(sctx);
 
-	__octeon_sha512_update(sctx, padding, pad_len);
-
-	/* Append length (before padding). */
-	__octeon_sha512_update(sctx, (const u8 *)bits, sizeof(bits));
+	sha512_base_do_finup(desc, src, len, octeon_sha512_transform);
 
 	octeon_sha512_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	/* Store state in digest. */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be64(sctx->state[i]);
-
-	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(struct sha512_state));
-
-	return 0;
-}
-
-static int octeon_sha384_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[64];
-
-	octeon_sha512_final(desc, D);
-
-	memcpy(hash, D, 48);
-	memzero_explicit(D, 64);
-
-	return 0;
+	return sha512_base_finish(desc, hash);
 }
 
 static struct shash_alg octeon_sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	octeon_sha512_update,
-	.final		=	octeon_sha512_final,
-	.descsize	=	sizeof(struct sha512_state),
+	.finup		=	octeon_sha512_finup,
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name=	"octeon-sha512",
 		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -205,12 +132,14 @@ static struct shash_alg octeon_sha512_algs[2] = { {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_base_init,
 	.update		=	octeon_sha512_update,
-	.final		=	octeon_sha384_final,
-	.descsize	=	sizeof(struct sha512_state),
+	.finup		=	octeon_sha512_finup,
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name=	"octeon-sha384",
 		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

