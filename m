Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86A621C170
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 05:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750398487; cv=none; b=dm0cqW3IwqYkJJbjvXu+ZxV3XgI/gbBkirSHKMhEjDJCNOPArIUduNY5yJNGuZmXwUNfc3QH4itzcM1Vt9yE9Au/b6bzOXWJYHgn/82D1WokaLQXdvNsVZqog+8ObnKpiE9F8ufzgJQe4ML3xkA4HjX4x8VdOJnG4CgC44Rbxxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750398487; c=relaxed/simple;
	bh=/rJNvDQkmzXXc01UwRgwbKGynuk9hRE7MGmFb2/DsRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkXUYcmPSG0v6V9YcYHJM+3b50uFWUVWJGQoclYeWB4vHDcOFG7ex6fQSE2ouQVXov95rMkDbKg0rJAi1WE4DEyAKL/hLj3dazKhmXXk2ocSUgPZ0cjp0dTwgztSYxyFZxZlMmY6F1PVvoz8uQ//+Xh59vsrbQNoX5e1SBwSrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Od1Njtlt; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Od1Njtlt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tu/a+TElLlWUZK5ju6G8uq6CeYcRbSZe20AREVNtnYc=; b=Od1NjtltLvXVtYJOyLOY1hqYc2
	S7TDONxCxI/H/ELyViKfc1xHcD+J4b97S0Kl0Ri552qy0jRusUx1Q+w3SMZNn7Px0S9N7SJHvqi5S
	APRR/K9xtQXTeKRufFHZ5af0eqiJmmyJXYIGH2LbYW1uBFRz7PQIQ6zNoTNiIl8E0nd8HMbhzfhh/
	8OoKzC9fm+5OkpACDBj0KmW4x0ZeBKg5dtMIEMmOiy7GkLPxWaxydie3j8G26MN/0EmWL0zdaWRBt
	/0V4OvKjOWybkvDKAOxHD4xVvhax7LyBX1hRnz1JBBqcvpHK/ZDvsxk8tNOpMXx2ybUYyynZwaIOS
	5n1g2uXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSUMF-000UUR-1V;
	Fri, 20 Jun 2025 13:48:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jun 2025 13:47:59 +0800
Date: Fri, 20 Jun 2025 13:47:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <gmazyland@gmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: wp512 - Use API partial block handling
Message-ID: <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>

On Thu, Jun 19, 2025 at 11:18:13PM +0200, Milan Broz wrote:
>
> The bisect points to
> 
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu May 15 13:54:42 2025 +0800
> 
>     crypto: hmac - Add export_core and import_core
> 
>     Add export_import and import_core so that hmac can be used as a
>     fallback by block-only drivers.
> 
> Please let me know if you need more info.

Please try this patch:

---8<---
Use the Crypto API partial block handling.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/wp512.c b/crypto/wp512.c
index 41f13d490333..4aa9d2cbeab9 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -21,10 +21,10 @@
  */
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mm.h>
-#include <asm/byteorder.h>
-#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 #define WP512_DIGEST_SIZE 64
 #define WP384_DIGEST_SIZE 48
@@ -37,9 +37,6 @@
 
 struct wp512_ctx {
 	u8  bitLength[WP512_LENGTHBYTES];
-	u8  buffer[WP512_BLOCK_SIZE];
-	int bufferBits;
-	int bufferPos;
 	u64 hash[WP512_DIGEST_SIZE/8];
 };
 
@@ -779,16 +776,16 @@ static const u64 rc[WHIRLPOOL_ROUNDS] = {
  * The core Whirlpool transform.
  */
 
-static __no_kmsan_checks void wp512_process_buffer(struct wp512_ctx *wctx) {
+static __no_kmsan_checks void wp512_process_buffer(struct wp512_ctx *wctx,
+						   const u8 *buffer) {
 	int i, r;
 	u64 K[8];        /* the round key */
 	u64 block[8];    /* mu(buffer) */
 	u64 state[8];    /* the cipher state */
 	u64 L[8];
-	const __be64 *buffer = (const __be64 *)wctx->buffer;
 
 	for (i = 0; i < 8; i++)
-		block[i] = be64_to_cpu(buffer[i]);
+		block[i] = get_unaligned_be64(buffer + i * 8);
 
 	state[0] = block[0] ^ (K[0] = wctx->hash[0]);
 	state[1] = block[1] ^ (K[1] = wctx->hash[1]);
@@ -991,8 +988,6 @@ static int wp512_init(struct shash_desc *desc) {
 	int i;
 
 	memset(wctx->bitLength, 0, 32);
-	wctx->bufferBits = wctx->bufferPos = 0;
-	wctx->buffer[0] = 0;
 	for (i = 0; i < 8; i++) {
 		wctx->hash[i] = 0L;
 	}
@@ -1004,16 +999,11 @@ static int wp512_update(struct shash_desc *desc, const u8 *source,
 			 unsigned int len)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
-	int sourcePos    = 0;
-	unsigned int bits_len = len * 8; // convert to number of bits
-	int sourceGap    = (8 - ((int)bits_len & 7)) & 7;
-	int bufferRem    = wctx->bufferBits & 7;
+	unsigned int remain = len % WP512_BLOCK_SIZE;
+	unsigned int bits_len = (len - remain) * 8;
+	u32 carry;
 	int i;
-	u32 b, carry;
-	u8 *buffer       = wctx->buffer;
 	u8 *bitLength    = wctx->bitLength;
-	int bufferBits   = wctx->bufferBits;
-	int bufferPos    = wctx->bufferPos;
 
 	u64 value = bits_len;
 	for (i = 31, carry = 0; i >= 0 && (carry != 0 || value != 0ULL); i--) {
@@ -1022,62 +1012,31 @@ static int wp512_update(struct shash_desc *desc, const u8 *source,
 		carry >>= 8;
 		value >>= 8;
 	}
-	while (bits_len > 8) {
-		b = ((source[sourcePos] << sourceGap) & 0xff) |
-		((source[sourcePos + 1] & 0xff) >> (8 - sourceGap));
-		buffer[bufferPos++] |= (u8)(b >> bufferRem);
-		bufferBits += 8 - bufferRem;
-		if (bufferBits == WP512_BLOCK_SIZE * 8) {
-			wp512_process_buffer(wctx);
-			bufferBits = bufferPos = 0;
-		}
-		buffer[bufferPos] = b << (8 - bufferRem);
-		bufferBits += bufferRem;
-		bits_len -= 8;
-		sourcePos++;
-	}
-	if (bits_len > 0) {
-		b = (source[sourcePos] << sourceGap) & 0xff;
-		buffer[bufferPos] |= b >> bufferRem;
-	} else {
-		b = 0;
-	}
-	if (bufferRem + bits_len < 8) {
-		bufferBits += bits_len;
-	} else {
-		bufferPos++;
-		bufferBits += 8 - bufferRem;
-		bits_len -= 8 - bufferRem;
-		if (bufferBits == WP512_BLOCK_SIZE * 8) {
-			wp512_process_buffer(wctx);
-			bufferBits = bufferPos = 0;
-		}
-		buffer[bufferPos] = b << (8 - bufferRem);
-		bufferBits += (int)bits_len;
-	}
+	do {
+		wp512_process_buffer(wctx, source);
+		source += WP512_BLOCK_SIZE;
+		bits_len -= WP512_BLOCK_SIZE * 8;
+	} while (bits_len);
 
-	wctx->bufferBits   = bufferBits;
-	wctx->bufferPos    = bufferPos;
-
-	return 0;
+	return remain;
 }
 
-static int wp512_final(struct shash_desc *desc, u8 *out)
+static int wp512_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int bufferPos, u8 *out)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
-	u8 *buffer      = wctx->buffer;
 	u8 *bitLength   = wctx->bitLength;
-	int bufferBits  = wctx->bufferBits;
-	int bufferPos   = wctx->bufferPos;
 	__be64 *digest  = (__be64 *)out;
+	u8 buffer[WP512_BLOCK_SIZE];
 
-	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
+	memcpy(buffer, src, bufferPos);
+	buffer[bufferPos] |= 0x80U;
 	bufferPos++;
 	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
 		if (bufferPos < WP512_BLOCK_SIZE)
 			memset(&buffer[bufferPos], 0, WP512_BLOCK_SIZE - bufferPos);
-		wp512_process_buffer(wctx);
+		wp512_process_buffer(wctx, buffer);
 		bufferPos = 0;
 	}
 	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES)
@@ -1086,31 +1045,32 @@ static int wp512_final(struct shash_desc *desc, u8 *out)
 	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
 	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
 		   bitLength, WP512_LENGTHBYTES);
-	wp512_process_buffer(wctx);
+	wp512_process_buffer(wctx, buffer);
+	memzero_explicit(buffer, sizeof(buffer));
 	for (i = 0; i < WP512_DIGEST_SIZE/8; i++)
 		digest[i] = cpu_to_be64(wctx->hash[i]);
-	wctx->bufferBits   = bufferBits;
-	wctx->bufferPos    = bufferPos;
 
 	return 0;
 }
 
-static int wp384_final(struct shash_desc *desc, u8 *out)
+static int wp384_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *out)
 {
 	u8 D[64];
 
-	wp512_final(desc, D);
+	wp512_finup(desc, src, len, D);
 	memcpy(out, D, WP384_DIGEST_SIZE);
 	memzero_explicit(D, WP512_DIGEST_SIZE);
 
 	return 0;
 }
 
-static int wp256_final(struct shash_desc *desc, u8 *out)
+static int wp256_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *out)
 {
 	u8 D[64];
 
-	wp512_final(desc, D);
+	wp512_finup(desc, src, len, D);
 	memcpy(out, D, WP256_DIGEST_SIZE);
 	memzero_explicit(D, WP512_DIGEST_SIZE);
 
@@ -1121,11 +1081,12 @@ static struct shash_alg wp_algs[3] = { {
 	.digestsize	=	WP512_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
-	.final		=	wp512_final,
+	.finup		=	wp512_finup,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
 		.cra_name	 =	"wp512",
 		.cra_driver_name =	"wp512-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	WP512_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
@@ -1133,11 +1094,12 @@ static struct shash_alg wp_algs[3] = { {
 	.digestsize	=	WP384_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
-	.final		=	wp384_final,
+	.finup		=	wp384_finup,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
 		.cra_name	 =	"wp384",
 		.cra_driver_name =	"wp384-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	WP512_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
@@ -1145,11 +1107,12 @@ static struct shash_alg wp_algs[3] = { {
 	.digestsize	=	WP256_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
-	.final		=	wp256_final,
+	.finup		=	wp256_finup,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
 		.cra_name	 =	"wp256",
 		.cra_driver_name =	"wp256-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	WP512_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
