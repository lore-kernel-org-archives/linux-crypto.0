Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A31DDC1B
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785833; cv=none; b=ZNsnD9TfcGBbZnOdXoVhVTc+x3AZKZNoZsX9hY8vURhhlRH868j03tGsWte/afvRw1yLFWZwSOOFZdjWKBXOgJxISkvLtwVlEcP5TNSmMPaOn6THlL4pIfGdASyb5WH8UAZHzx64sDpqz9XVHZY5VBzWPaGqKzQ00NWCkXfAFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785833; c=relaxed/simple;
	bh=W1qg+gidWinFLhDwqnUdLrMzUi/pfmVJxwSn8AfBB50=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=SO1llVI9mHibNXvg6PVrp2PyIOsPPUYEs7d1eFbDc2VU5QMq1scrLyRzvxy2j4h/jN1EuayLIsMnONsisNWo8tYDP4gCMgyEELXNx0mEAKpaT1iTuXpAr10oFtAX8cxoxIPKLPyPurGctximQu3iBQTjMprQUqqNBSpPZRinJSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rnjwlGqc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rnjwlGqc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8TT4gNsP+QLmNyfqe1qKCPGdeGgbjC8y8dQSrHTaOoE=; b=rnjwlGqc2unXNaQ2T1yZWVvbk7
	dIWGbjrSHQSJYUpmUPVTSAHdai+/xOxa9jQSSLiad8A6Zw2SWmo35WMrag4ri++GR3Pr+WNa78j6Y
	MSSipIcqs9GtPOqDijqeE4DEMvnBbO98V7TfgTVTzSaaVrHeD7keWC/jFIE+X9dPqFGzGXwRTrvGd
	cyelnuN28vdTW4HXKxEjZ3a7ZSwGsJZOifLnizNalX5pb81kbfG/YFnxox9GgSVV1HVfojTZmP0q3
	y52Nu4yl+jgfbA7e5HYz7rKiXhzU4nvbPorAywkTgbWPY3ZIeBB4bD1R6B1qUlaDPYq5gbMbc88c2
	Ui/cl2tQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUt-00G6LJ-1I;
	Wed, 16 Apr 2025 14:43:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:47 +0800
Date: Wed, 16 Apr 2025 14:43:47 +0800
Message-Id: <26eb6134cc00ea3133cb0902bc28bbc0f7d3b3d5.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 28/67] crypto: mips/octeon-sha256 - Use API partial block
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
 .../mips/cavium-octeon/crypto/octeon-sha256.c | 161 ++++--------------
 1 file changed, 37 insertions(+), 124 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha256.c b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
index 435e4a6e7f13..8e85ea65387c 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-sha256.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
@@ -14,15 +14,12 @@
  * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
  */
 
-#include <linux/mm.h>
-#include <crypto/sha2.h>
-#include <crypto/sha256_base.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
 #include <crypto/internal/hash.h>
+#include <crypto/sha2.h>
+#include <crypto/sha256_base.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "octeon-crypto.h"
 
@@ -30,7 +27,7 @@
  * We pass everything as 64-bit. OCTEON can handle misaligned data.
  */
 
-static void octeon_sha256_store_hash(struct sha256_state *sctx)
+static void octeon_sha256_store_hash(struct crypto_sha256_state *sctx)
 {
 	u64 *hash = (u64 *)sctx->state;
 
@@ -40,7 +37,7 @@ static void octeon_sha256_store_hash(struct sha256_state *sctx)
 	write_octeon_64bit_hash_dword(hash[3], 3);
 }
 
-static void octeon_sha256_read_hash(struct sha256_state *sctx)
+static void octeon_sha256_read_hash(struct crypto_sha256_state *sctx)
 {
 	u64 *hash = (u64 *)sctx->state;
 
@@ -50,158 +47,72 @@ static void octeon_sha256_read_hash(struct sha256_state *sctx)
 	hash[3] = read_octeon_64bit_hash_dword(3);
 }
 
-static void octeon_sha256_transform(const void *_block)
+static void octeon_sha256_transform(struct crypto_sha256_state *sctx,
+				    const u8 *src, int blocks)
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
-	octeon_sha256_start(block[7]);
-}
+		write_octeon_64bit_block_dword(block[0], 0);
+		write_octeon_64bit_block_dword(block[1], 1);
+		write_octeon_64bit_block_dword(block[2], 2);
+		write_octeon_64bit_block_dword(block[3], 3);
+		write_octeon_64bit_block_dword(block[4], 4);
+		write_octeon_64bit_block_dword(block[5], 5);
+		write_octeon_64bit_block_dword(block[6], 6);
+		octeon_sha256_start(block[7]);
 
-static void __octeon_sha256_update(struct sha256_state *sctx, const u8 *data,
-				   unsigned int len)
-{
-	unsigned int partial;
-	unsigned int done;
-	const u8 *src;
-
-	partial = sctx->count % SHA256_BLOCK_SIZE;
-	sctx->count += len;
-	done = 0;
-	src = data;
-
-	if ((partial + len) >= SHA256_BLOCK_SIZE) {
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buf + partial, data,
-			       done + SHA256_BLOCK_SIZE);
-			src = sctx->buf;
-		}
-
-		do {
-			octeon_sha256_transform(src);
-			done += SHA256_BLOCK_SIZE;
-			src = data + done;
-		} while (done + SHA256_BLOCK_SIZE <= len);
-
-		partial = 0;
-	}
-	memcpy(sctx->buf + partial, src, len - done);
+		src += SHA256_BLOCK_SIZE;
+	} while (--blocks);
 }
 
 static int octeon_sha256_update(struct shash_desc *desc, const u8 *data,
 				unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
 	struct octeon_cop2_state state;
 	unsigned long flags;
-
-	/*
-	 * Small updates never reach the crypto engine, so the generic sha256 is
-	 * faster because of the heavyweight octeon_crypto_enable() /
-	 * octeon_crypto_disable().
-	 */
-	if ((sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
-		return crypto_sha256_update(desc, data, len);
+	int remain;
 
 	flags = octeon_crypto_enable(&state);
 	octeon_sha256_store_hash(sctx);
 
-	__octeon_sha256_update(sctx, data, len);
+	remain = sha256_base_do_update_blocks(desc, data, len,
+					      octeon_sha256_transform);
 
 	octeon_sha256_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	return 0;
+	return remain;
 }
 
-static int octeon_sha256_final(struct shash_desc *desc, u8 *out)
+static int octeon_sha256_finup(struct shash_desc *desc, const u8 *src,
+			       unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	static const u8 padding[64] = { 0x80, };
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
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
 	octeon_sha256_store_hash(sctx);
 
-	__octeon_sha256_update(sctx, padding, pad_len);
-
-	/* Append length (before padding). */
-	__octeon_sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
+	sha256_base_do_finup(desc, src, len, octeon_sha256_transform);
 
 	octeon_sha256_read_hash(sctx);
 	octeon_crypto_disable(&state, flags);
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int octeon_sha224_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[SHA256_DIGEST_SIZE];
-
-	octeon_sha256_final(desc, D);
-
-	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
-}
-
-static int octeon_sha256_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int octeon_sha256_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	return sha256_base_finish(desc, out);
 }
 
 static struct shash_alg octeon_sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	octeon_sha256_update,
-	.final		=	octeon_sha256_final,
-	.export		=	octeon_sha256_export,
-	.import		=	octeon_sha256_import,
-	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.finup		=	octeon_sha256_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"octeon-sha256",
 		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -209,11 +120,13 @@ static struct shash_alg octeon_sha256_algs[2] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	octeon_sha256_update,
-	.final		=	octeon_sha224_final,
-	.descsize	=	sizeof(struct sha256_state),
+	.finup		=	octeon_sha256_finup,
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"octeon-sha224",
+		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

