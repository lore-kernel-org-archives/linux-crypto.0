Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5428C230BD9
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785796; cv=none; b=LiK+fDXazpuCbHc952KnzWpqVNMjtc99DKbxKpmMbn8D8MPOEB0+lSIJ9ZdXr9HISqdgMw+VScP8PkLKpufev9YIwDgFSagX/jT/2VaT4woO6lCrVZcDVELYiJ/9LJyMtd/M4tpx8qG9Ebe9W+AAUeTU69Y7tJ4NiTw/Dx6RSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785796; c=relaxed/simple;
	bh=Twewc4fHyn9M9mzHZI2F3Gt+JXJLbUWF3vsd44ZAkvg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=WmdwI/rYjsqwaGyo/lM36k4OhMl5tD2Rn4EYLt4Sh+ebOC5XhzgFJoRJ98q/uOybY6ACqxMXrPLY2NFIXvBYzAKpeTVzR61Z0oRI6v5x02gpBRtX1Y6SLAyMB3zNURlERcrscbRhnkoZ/bbhOdG4EtoxenpPticeg4mVjoOW6yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dxtVpiWW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dxtVpiWW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dSlg1rZ27N56DAuVfpI/1V3H1J19I4hGBZYBTsc8gfY=; b=dxtVpiWWDS0vfV5T4HWnFcTwfr
	cAejZ/MCMiGdfH/vAfsePO/gtEnwfwmjqYrrVm6GUTbtpQOqHrjD2m3qRoOywHqx4G+PWCLn91jFL
	WEus0nmy4VbUMWRJYF5OtLShtAaDGa9d5EIihXB1TpleR3Ipj29PyWuZ+ZKpqhuhUnwTJcPmUNl0N
	S9uxzYZWh2Z5KKXKjMPi24/5EioAasBTyCojvD/qk5fEgD5r3pOIEExDmvNemRznMnA/hyZpTPGdV
	uOGW1mrvQZF5NeN006x7QCUrGJV8xQPAIdnvYoPrK+c8DzIrvoLuppgDhvJaPWXS9JQoAAiHegMN9
	Pi129PVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUI-00G6IR-1j;
	Wed, 16 Apr 2025 14:43:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:10 +0800
Date: Wed, 16 Apr 2025 14:43:10 +0800
Message-Id: <348f7934687cd69bb635f4a58c4dd02045ec15c4.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/67] crypto: mips/octeon-md5 - Use API partial block
 handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/mips/cavium-octeon/crypto/octeon-md5.c | 119 +++++++++++---------
 1 file changed, 63 insertions(+), 56 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-md5.c b/arch/mips/cavium-octeon/crypto/octeon-md5.c
index 5ee4ade99b99..fbc84eb7fedf 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-md5.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-md5.c
@@ -19,22 +19,26 @@
  * any later version.
  */
 
-#include <crypto/md5.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
 #include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 #include "octeon-crypto.h"
 
+struct octeon_md5_state {
+	__le32 hash[MD5_HASH_WORDS];
+	u64 byte_count;
+};
+
 /*
  * We pass everything as 64-bit. OCTEON can handle misaligned data.
  */
 
-static void octeon_md5_store_hash(struct md5_state *ctx)
+static void octeon_md5_store_hash(struct octeon_md5_state *ctx)
 {
 	u64 *hash = (u64 *)ctx->hash;
 
@@ -42,7 +46,7 @@ static void octeon_md5_store_hash(struct md5_state *ctx)
 	write_octeon_64bit_hash_dword(hash[1], 1);
 }
 
-static void octeon_md5_read_hash(struct md5_state *ctx)
+static void octeon_md5_read_hash(struct octeon_md5_state *ctx)
 {
 	u64 *hash = (u64 *)ctx->hash;
 
@@ -66,13 +70,12 @@ static void octeon_md5_transform(const void *_block)
 
 static int octeon_md5_init(struct shash_desc *desc)
 {
-	struct md5_state *mctx = shash_desc_ctx(desc);
+	struct octeon_md5_state *mctx = shash_desc_ctx(desc);
 
-	mctx->hash[0] = MD5_H0;
-	mctx->hash[1] = MD5_H1;
-	mctx->hash[2] = MD5_H2;
-	mctx->hash[3] = MD5_H3;
-	cpu_to_le32_array(mctx->hash, 4);
+	mctx->hash[0] = cpu_to_le32(MD5_H0);
+	mctx->hash[1] = cpu_to_le32(MD5_H1);
+	mctx->hash[2] = cpu_to_le32(MD5_H2);
+	mctx->hash[3] = cpu_to_le32(MD5_H3);
 	mctx->byte_count = 0;
 
 	return 0;
@@ -81,52 +84,38 @@ static int octeon_md5_init(struct shash_desc *desc)
 static int octeon_md5_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
-	struct md5_state *mctx = shash_desc_ctx(desc);
-	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
+	struct octeon_md5_state *mctx = shash_desc_ctx(desc);
 	struct octeon_cop2_state state;
 	unsigned long flags;
 
 	mctx->byte_count += len;
-
-	if (avail > len) {
-		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
-		       data, len);
-		return 0;
-	}
-
-	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail), data,
-	       avail);
-
 	flags = octeon_crypto_enable(&state);
 	octeon_md5_store_hash(mctx);
 
-	octeon_md5_transform(mctx->block);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(mctx->block)) {
+	do {
 		octeon_md5_transform(data);
-		data += sizeof(mctx->block);
-		len -= sizeof(mctx->block);
-	}
+		data += MD5_HMAC_BLOCK_SIZE;
+		len -= MD5_HMAC_BLOCK_SIZE;
+	} while (len >= MD5_HMAC_BLOCK_SIZE);
 
 	octeon_md5_read_hash(mctx);
 	octeon_crypto_disable(&state, flags);
-
-	memcpy(mctx->block, data, len);
-
-	return 0;
+	mctx->byte_count -= len;
+	return len;
 }
 
-static int octeon_md5_final(struct shash_desc *desc, u8 *out)
+static int octeon_md5_finup(struct shash_desc *desc, const u8 *src,
+			    unsigned int offset, u8 *out)
 {
-	struct md5_state *mctx = shash_desc_ctx(desc);
-	const unsigned int offset = mctx->byte_count & 0x3f;
-	char *p = (char *)mctx->block + offset;
+	struct octeon_md5_state *mctx = shash_desc_ctx(desc);
 	int padding = 56 - (offset + 1);
 	struct octeon_cop2_state state;
+	u32 block[MD5_BLOCK_WORDS];
 	unsigned long flags;
+	char *p;
 
+	p = memcpy(block, src, offset);
+	p += offset;
 	*p++ = 0x80;
 
 	flags = octeon_crypto_enable(&state);
@@ -134,39 +123,56 @@ static int octeon_md5_final(struct shash_desc *desc, u8 *out)
 
 	if (padding < 0) {
 		memset(p, 0x00, padding + sizeof(u64));
-		octeon_md5_transform(mctx->block);
-		p = (char *)mctx->block;
+		octeon_md5_transform(block);
+		p = (char *)block;
 		padding = 56;
 	}
 
 	memset(p, 0, padding);
-	mctx->block[14] = mctx->byte_count << 3;
-	mctx->block[15] = mctx->byte_count >> 29;
-	cpu_to_le32_array(mctx->block + 14, 2);
-	octeon_md5_transform(mctx->block);
+	mctx->byte_count += offset;
+	block[14] = mctx->byte_count << 3;
+	block[15] = mctx->byte_count >> 29;
+	cpu_to_le32_array(block + 14, 2);
+	octeon_md5_transform(block);
 
 	octeon_md5_read_hash(mctx);
 	octeon_crypto_disable(&state, flags);
 
+	memzero_explicit(block, sizeof(block));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
-	memset(mctx, 0, sizeof(*mctx));
 
 	return 0;
 }
 
 static int octeon_md5_export(struct shash_desc *desc, void *out)
 {
-	struct md5_state *ctx = shash_desc_ctx(desc);
+	struct octeon_md5_state *ctx = shash_desc_ctx(desc);
+	union {
+		u8 *u8;
+		u32 *u32;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
-	memcpy(out, ctx, sizeof(*ctx));
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		put_unaligned(le32_to_cpu(ctx->hash[i]), p.u32++);
+	put_unaligned(ctx->byte_count, p.u64);
 	return 0;
 }
 
 static int octeon_md5_import(struct shash_desc *desc, const void *in)
 {
-	struct md5_state *ctx = shash_desc_ctx(desc);
+	struct octeon_md5_state *ctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u32 *u32;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
-	memcpy(ctx, in, sizeof(*ctx));
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		ctx->hash[i] = cpu_to_le32(get_unaligned(p.u32++));
+	ctx->byte_count = get_unaligned(p.u64);
 	return 0;
 }
 
@@ -174,15 +180,16 @@ static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	octeon_md5_init,
 	.update		=	octeon_md5_update,
-	.final		=	octeon_md5_final,
+	.finup		=	octeon_md5_finup,
 	.export		=	octeon_md5_export,
 	.import		=	octeon_md5_import,
-	.descsize	=	sizeof(struct md5_state),
-	.statesize	=	sizeof(struct md5_state),
+	.statesize	=	MD5_STATE_SIZE,
+	.descsize	=	sizeof(struct octeon_md5_state),
 	.base		=	{
 		.cra_name	=	"md5",
 		.cra_driver_name=	"octeon-md5",
 		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

