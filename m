Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B18155C8A
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=c6suHhDyIXhMkxzNfJGYgMtk4fyGUdH2ZA16Jpn7+zvIPikO35pTjH7w6K0+ho53W+D8gNvflS4dnEzE5OI7DyD8/o+ykOQlncfsFLH+/OFTzrDS0tsXMY5LrhcP3bMp7MzBo3OkG2IozUS7NvbeHtX99Qt+vF/OGemYCNQqxlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=UNHNRsH+im+c/Y6QT61D//yFTFTLE3czbw4Sb8srj+o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssPOD+79w4BMSe/RBDfOVKDCa82bW4G8+x0wKfDCjGnDqmbaLsGfx29qFzOShfZFah/q0rq0UJhPG9v1GkQvgSCN62KGQzqIgP7XxQ70IGiY7CWUXvLzdFViX7iJTcNYQXONQ5fgFZFJEZqc6NyoftKHzQ8La02JOoU/e4fFZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kb8sEuGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kb8sEuGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589CCC4CECD
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=UNHNRsH+im+c/Y6QT61D//yFTFTLE3czbw4Sb8srj+o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kb8sEuGUwA1QVetXlJOucc9J1q4hYiRAq3Xlpf0Y/BaqssXv7ARTg3i4PLsUN3xNl
	 WvlU9J1+Lziy0vFogy1LdcqtdO9knne2O3zVQPlkss81B8iDyShCWIFD7ryXV5FKpT
	 zzvz2CwvePZqtHrdCSPHMnXi5K5ZAbakWhWpxwpfAbR787YNrIQVsblfyJ08YPSBYx
	 vtmlj+0QFc4wt4dJIm/4/n9Zqprebl7J4b6K5IVf/CQ4izIsLx5MmiDJywWNO6dV0v
	 gO9eHRW7gGT8XU5nx8yX9WhoZJrK4AusFln6tDljJG0YYEqfpaFiPkKtP7ZQxwuPqc
	 pXkmOL1kTjBbw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 5/8] crypto: seed - stop using cra_alignmask
Date: Sat,  7 Dec 2024 11:57:49 -0800
Message-ID: <20241207195752.87654-6-ebiggers@kernel.org>
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
 crypto/seed.c | 48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/crypto/seed.c b/crypto/seed.c
index d0506ade2a5f8..d05d8ed909fa7 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -11,11 +11,11 @@
 #include <crypto/algapi.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <asm/byteorder.h>
+#include <linux/unaligned.h>
 
 #define SEED_NUM_KCONSTANTS	16
 #define SEED_KEY_SIZE		16
 #define SEED_BLOCK_SIZE		16
 #define SEED_KEYSCHED_LEN	32
@@ -327,17 +327,16 @@ static const u32 KC[SEED_NUM_KCONSTANTS] = {
 static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		        unsigned int key_len)
 {
 	struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *keyout = ctx->keysched;
-	const __be32 *key = (const __be32 *)in_key;
 	u32 i, t0, t1, x1, x2, x3, x4;
 
-	x1 = be32_to_cpu(key[0]);
-	x2 = be32_to_cpu(key[1]);
-	x3 = be32_to_cpu(key[2]);
-	x4 = be32_to_cpu(key[3]);
+	x1 = get_unaligned_be32(&in_key[0]);
+	x2 = get_unaligned_be32(&in_key[4]);
+	x3 = get_unaligned_be32(&in_key[8]);
+	x4 = get_unaligned_be32(&in_key[12]);
 
 	for (i = 0; i < SEED_NUM_KCONSTANTS; i++) {
 		t0 = x1 + x3 - KC[i];
 		t1 = x2 + KC[i] - x4;
 		*(keyout++) = SS0[byte(t0, 0)] ^ SS1[byte(t0, 1)] ^
@@ -362,19 +361,17 @@ static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 /* encrypt a block of text */
 
 static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *src = (const __be32 *)in;
-	__be32 *dst = (__be32 *)out;
 	u32 x1, x2, x3, x4, t0, t1;
 	const u32 *ks = ctx->keysched;
 
-	x1 = be32_to_cpu(src[0]);
-	x2 = be32_to_cpu(src[1]);
-	x3 = be32_to_cpu(src[2]);
-	x4 = be32_to_cpu(src[3]);
+	x1 = get_unaligned_be32(&in[0]);
+	x2 = get_unaligned_be32(&in[4]);
+	x3 = get_unaligned_be32(&in[8]);
+	x4 = get_unaligned_be32(&in[12]);
 
 	OP(x1, x2, x3, x4, 0);
 	OP(x3, x4, x1, x2, 2);
 	OP(x1, x2, x3, x4, 4);
 	OP(x3, x4, x1, x2, 6);
@@ -389,30 +386,28 @@ static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	OP(x1, x2, x3, x4, 24);
 	OP(x3, x4, x1, x2, 26);
 	OP(x1, x2, x3, x4, 28);
 	OP(x3, x4, x1, x2, 30);
 
-	dst[0] = cpu_to_be32(x3);
-	dst[1] = cpu_to_be32(x4);
-	dst[2] = cpu_to_be32(x1);
-	dst[3] = cpu_to_be32(x2);
+	put_unaligned_be32(x3, &out[0]);
+	put_unaligned_be32(x4, &out[4]);
+	put_unaligned_be32(x1, &out[8]);
+	put_unaligned_be32(x2, &out[12]);
 }
 
 /* decrypt a block of text */
 
 static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *src = (const __be32 *)in;
-	__be32 *dst = (__be32 *)out;
 	u32 x1, x2, x3, x4, t0, t1;
 	const u32 *ks = ctx->keysched;
 
-	x1 = be32_to_cpu(src[0]);
-	x2 = be32_to_cpu(src[1]);
-	x3 = be32_to_cpu(src[2]);
-	x4 = be32_to_cpu(src[3]);
+	x1 = get_unaligned_be32(&in[0]);
+	x2 = get_unaligned_be32(&in[4]);
+	x3 = get_unaligned_be32(&in[8]);
+	x4 = get_unaligned_be32(&in[12]);
 
 	OP(x1, x2, x3, x4, 30);
 	OP(x3, x4, x1, x2, 28);
 	OP(x1, x2, x3, x4, 26);
 	OP(x3, x4, x1, x2, 24);
@@ -427,25 +422,24 @@ static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	OP(x1, x2, x3, x4, 6);
 	OP(x3, x4, x1, x2, 4);
 	OP(x1, x2, x3, x4, 2);
 	OP(x3, x4, x1, x2, 0);
 
-	dst[0] = cpu_to_be32(x3);
-	dst[1] = cpu_to_be32(x4);
-	dst[2] = cpu_to_be32(x1);
-	dst[3] = cpu_to_be32(x2);
+	put_unaligned_be32(x3, &out[0]);
+	put_unaligned_be32(x4, &out[4]);
+	put_unaligned_be32(x1, &out[8]);
+	put_unaligned_be32(x2, &out[12]);
 }
 
 
 static struct crypto_alg seed_alg = {
 	.cra_name		=	"seed",
 	.cra_driver_name	=	"seed-generic",
 	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	SEED_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct seed_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	SEED_KEY_SIZE,
 			.cia_max_keysize	=	SEED_KEY_SIZE,
-- 
2.47.1

