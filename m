Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565F154BE2
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=rVh2DvFfC6vbAmlabalmc4WfYADOH+oRHDnuCHhdBCQg4YpW54jPoZKsJhMqpcvdDFDhWJhJRoDnM2C/iaP5iof77XIKt/xqpN5+2KSgQsS173256zZCVOW9K1XEoWgpj3YorGYzV3c6DpdZ8+LUTZOqTm+4c6VD9ww5FzFLvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=n9ioLaUCO2ycI9rs6WceJ1E88jmO8gnY6BMnmtBj3yE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7qHbr3RVFxrj6xcnWAyY6tWvSmWG8pv0xGlvEKhgoys/gpFb/m655yPvhvLukf2SZhLFQy2CXOQMQYZ/rsaNZnPJ0yq66TZXCaVVBHz4LZsy5cQs+TikPK4vwhniRC6jowlC02QdjJKe6yH7xDtaAeMvJc51z8zwFHZzA2o6Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1wuKhbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1wuKhbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36AAC4CEE0
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=n9ioLaUCO2ycI9rs6WceJ1E88jmO8gnY6BMnmtBj3yE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=c1wuKhbAru/HdlRvmZN8oqfSEYy+7GedF4wPRQ/5iQc6ZGBu+82D5C2a3P6Yc+hHm
	 keqVRoH2IJ29MRRw5nak4v0AgreCH7pGxLciGo2yy9SqRRDz0xzV7QwmjT6hajFMra
	 rSKWJLCvGrUW1UtHsh0ZeTecguyGQVrrzZx2Hjqj83/d3dI7oQwbYW1oYq3goW2Ryn
	 0+cZ5RQUXFCGoWtteUcN+A42ORxSyR9sdEyuCRM3aFJgmk2ghPrxSSEaZrzRu9LPHz
	 Zoa/f1bOcCHPnoEwgzz/nlhLJ5vEb+M/wXTiLDyQ0avY1IovZ9ArBDoiLg3cdC0EHM
	 RyDggBslbg9Fg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 3/8] crypto: tea - stop using cra_alignmask
Date: Sat,  7 Dec 2024 11:57:47 -0800
Message-ID: <20241207195752.87654-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
References: <20241207195752.87654-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Instead of specifying a nonzero alignmask, use the unaligned access
helpers.  This eliminates unnecessary alignment operations on most CPUs,
which can handle unaligned accesses efficiently, and brings us a step
closer to eventually removing support for the alignmask field.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/tea.c | 83 +++++++++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 50 deletions(-)

diff --git a/crypto/tea.c b/crypto/tea.c
index 896f863f3067c..b315da8c89ebc 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -16,11 +16,11 @@
 
 #include <crypto/algapi.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
+#include <linux/unaligned.h>
 #include <linux/types.h>
 
 #define TEA_KEY_SIZE		16
 #define TEA_BLOCK_SIZE		8
 #define TEA_ROUNDS		32
@@ -41,31 +41,28 @@ struct xtea_ctx {
 
 static int tea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		      unsigned int key_len)
 {
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *key = (const __le32 *)in_key;
 
-	ctx->KEY[0] = le32_to_cpu(key[0]);
-	ctx->KEY[1] = le32_to_cpu(key[1]);
-	ctx->KEY[2] = le32_to_cpu(key[2]);
-	ctx->KEY[3] = le32_to_cpu(key[3]);
+	ctx->KEY[0] = get_unaligned_le32(&in_key[0]);
+	ctx->KEY[1] = get_unaligned_le32(&in_key[4]);
+	ctx->KEY[2] = get_unaligned_le32(&in_key[8]);
+	ctx->KEY[3] = get_unaligned_le32(&in_key[12]);
 
 	return 0; 
 
 }
 
 static void tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, n, sum = 0;
 	u32 k0, k1, k2, k3;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	k0 = ctx->KEY[0];
 	k1 = ctx->KEY[1];
 	k2 = ctx->KEY[2];
 	k3 = ctx->KEY[3];
@@ -76,24 +73,22 @@ static void tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		sum += TEA_DELTA;
 		y += ((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1);
 		z += ((y << 4) + k2) ^ (y + sum) ^ ((y >> 5) + k3);
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 static void tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, n, sum;
 	u32 k0, k1, k2, k3;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	k0 = ctx->KEY[0];
 	k1 = ctx->KEY[1];
 	k2 = ctx->KEY[2];
 	k3 = ctx->KEY[3];
@@ -106,123 +101,113 @@ static void tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		z -= ((y << 4) + k2) ^ (y + sum) ^ ((y >> 5) + k3);
 		y -= ((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1);
 		sum -= TEA_DELTA;
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 static int xtea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
 	struct xtea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *key = (const __le32 *)in_key;
 
-	ctx->KEY[0] = le32_to_cpu(key[0]);
-	ctx->KEY[1] = le32_to_cpu(key[1]);
-	ctx->KEY[2] = le32_to_cpu(key[2]);
-	ctx->KEY[3] = le32_to_cpu(key[3]);
+	ctx->KEY[0] = get_unaligned_le32(&in_key[0]);
+	ctx->KEY[1] = get_unaligned_le32(&in_key[4]);
+	ctx->KEY[2] = get_unaligned_le32(&in_key[8]);
+	ctx->KEY[3] = get_unaligned_le32(&in_key[12]);
 
 	return 0; 
 
 }
 
 static void xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum = 0;
 	u32 limit = XTEA_DELTA * XTEA_ROUNDS;
 	struct xtea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	while (sum != limit) {
 		y += ((z << 4 ^ z >> 5) + z) ^ (sum + ctx->KEY[sum&3]); 
 		sum += XTEA_DELTA;
 		z += ((y << 4 ^ y >> 5) + y) ^ (sum + ctx->KEY[sum>>11 &3]); 
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 static void xtea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	sum = XTEA_DELTA * XTEA_ROUNDS;
 
 	while (sum) {
 		z -= ((y << 4 ^ y >> 5) + y) ^ (sum + ctx->KEY[sum>>11 & 3]);
 		sum -= XTEA_DELTA;
 		y -= ((z << 4 ^ z >> 5) + z) ^ (sum + ctx->KEY[sum & 3]);
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 
 static void xeta_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum = 0;
 	u32 limit = XTEA_DELTA * XTEA_ROUNDS;
 	struct xtea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	while (sum != limit) {
 		y += (z << 4 ^ z >> 5) + (z ^ sum) + ctx->KEY[sum&3];
 		sum += XTEA_DELTA;
 		z += (y << 4 ^ y >> 5) + (y ^ sum) + ctx->KEY[sum>>11 &3];
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *in = (const __le32 *)src;
-	__le32 *out = (__le32 *)dst;
 
-	y = le32_to_cpu(in[0]);
-	z = le32_to_cpu(in[1]);
+	y = get_unaligned_le32(&src[0]);
+	z = get_unaligned_le32(&src[4]);
 
 	sum = XTEA_DELTA * XTEA_ROUNDS;
 
 	while (sum) {
 		z -= (y << 4 ^ y >> 5) + (y ^ sum) + ctx->KEY[sum>>11 & 3];
 		sum -= XTEA_DELTA;
 		y -= (z << 4 ^ z >> 5) + (z ^ sum) + ctx->KEY[sum & 3];
 	}
 	
-	out[0] = cpu_to_le32(y);
-	out[1] = cpu_to_le32(z);
+	put_unaligned_le32(y, &dst[0]);
+	put_unaligned_le32(z, &dst[4]);
 }
 
 static struct crypto_alg tea_algs[3] = { {
 	.cra_name		=	"tea",
 	.cra_driver_name	=	"tea-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct tea_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	TEA_KEY_SIZE,
 	.cia_max_keysize	=	TEA_KEY_SIZE,
 	.cia_setkey		= 	tea_setkey,
@@ -232,11 +217,10 @@ static struct crypto_alg tea_algs[3] = { {
 	.cra_name		=	"xtea",
 	.cra_driver_name	=	"xtea-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	XTEA_KEY_SIZE,
 	.cia_max_keysize	=	XTEA_KEY_SIZE,
 	.cia_setkey		= 	xtea_setkey,
@@ -246,11 +230,10 @@ static struct crypto_alg tea_algs[3] = { {
 	.cra_name		=	"xeta",
 	.cra_driver_name	=	"xeta-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	XTEA_KEY_SIZE,
 	.cia_max_keysize	=	XTEA_KEY_SIZE,
 	.cia_setkey		= 	xtea_setkey,
-- 
2.47.1

