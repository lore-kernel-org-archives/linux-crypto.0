Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9471509A0
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=UWgVkW38HaH2ifIWW+sj8eEBO3irq/ewa/adnQ3btw65c4iYtjzxGejZwJ6guHWeObwzWD3CB7StCtedao2Bh5gBPqR92e09EXAVhnN7+zC+0mn8dosH2d6ijQrXQgWiggx96a1bQmkxqVyKY1hxn3AAXlk/v5ZUTJcJI7HdAwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=8lhj+o/gRgPEL5z+pB6QVmjTpedeQAH8kI7iIivYnJc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTTJElFoDNtHqYQ2JeCbXwzwde/rFq5yB0NCI6qD9e9qW7UDKcc+qAXGtxmVh8GcWyk0ulxNySDOsgIyDnUBnNWHxVtRlzvCP94JtJ1yI/vyrsyKyq0zCkAsL7gDFIRr+eJ+7epD6GNhm5lXqRrz1hzVb0bsERm6yvaxuc+GXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHjrRXdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHjrRXdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E6BC4CEDC
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601512;
	bh=8lhj+o/gRgPEL5z+pB6QVmjTpedeQAH8kI7iIivYnJc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QHjrRXdhqUgHEdj+uApzfz7gUZF/FItgGiMpe5UER3OQo53tDh66aLAB7/nP6Yzk8
	 mCu9rv2cGe4ko1vJ7eiZERIo+whRM07z3Kd1bnsDxRYhQE22npM34wF3YJR4Co+06K
	 VkwxT8cJB4EOmdvLR9YNupzKqcMMtSeTssU/qOclIT0zcbzks2CXN1MzJdZBI9Oa68
	 9975KQtU9M1U9SMvWbdm0PckeDzKDdxdUTxpG5EkOTS1+o2ie90neFWWwEZK52cP/p
	 h0IZHQHMrufNQ/Fh1fC6PfbuG+p+fDOpO4N3YT4Vwo0hlcn58ySvS4lg/cJ2mPRSJF
	 XwLvZkONd4O4g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 2/8] crypto: aria - stop using cra_alignmask
Date: Sat,  7 Dec 2024 11:57:46 -0800
Message-ID: <20241207195752.87654-3-ebiggers@kernel.org>
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
 crypto/aria_generic.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/crypto/aria_generic.c b/crypto/aria_generic.c
index d96dfc4fdde67..bd359d3313c22 100644
--- a/crypto/aria_generic.c
+++ b/crypto/aria_generic.c
@@ -13,10 +13,11 @@
  *
  * Public domain version is distributed above.
  */
 
 #include <crypto/aria.h>
+#include <linux/unaligned.h>
 
 static const u32 key_rc[20] = {
 	0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0,
 	0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0,
 	0xdb92371d, 0x2126e970, 0x03249775, 0x04e8c90e,
@@ -25,36 +26,35 @@ static const u32 key_rc[20] = {
 };
 
 static void aria_set_encrypt_key(struct aria_ctx *ctx, const u8 *in_key,
 				 unsigned int key_len)
 {
-	const __be32 *key = (const __be32 *)in_key;
 	u32 w0[4], w1[4], w2[4], w3[4];
 	u32 reg0, reg1, reg2, reg3;
 	const u32 *ck;
 	int rkidx = 0;
 
 	ck = &key_rc[(key_len - 16) / 2];
 
-	w0[0] = be32_to_cpu(key[0]);
-	w0[1] = be32_to_cpu(key[1]);
-	w0[2] = be32_to_cpu(key[2]);
-	w0[3] = be32_to_cpu(key[3]);
+	w0[0] = get_unaligned_be32(&in_key[0]);
+	w0[1] = get_unaligned_be32(&in_key[4]);
+	w0[2] = get_unaligned_be32(&in_key[8]);
+	w0[3] = get_unaligned_be32(&in_key[12]);
 
 	reg0 = w0[0] ^ ck[0];
 	reg1 = w0[1] ^ ck[1];
 	reg2 = w0[2] ^ ck[2];
 	reg3 = w0[3] ^ ck[3];
 
 	aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
 
 	if (key_len > 16) {
-		w1[0] = be32_to_cpu(key[4]);
-		w1[1] = be32_to_cpu(key[5]);
+		w1[0] = get_unaligned_be32(&in_key[16]);
+		w1[1] = get_unaligned_be32(&in_key[20]);
 		if (key_len > 24) {
-			w1[2] = be32_to_cpu(key[6]);
-			w1[3] = be32_to_cpu(key[7]);
+			w1[2] = get_unaligned_be32(&in_key[24]);
+			w1[3] = get_unaligned_be32(&in_key[28]);
 		} else {
 			w1[2] = 0;
 			w1[3] = 0;
 		}
 	} else {
@@ -193,21 +193,19 @@ int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key, unsigned int key_len)
 EXPORT_SYMBOL_GPL(aria_set_key);
 
 static void __aria_crypt(struct aria_ctx *ctx, u8 *out, const u8 *in,
 			 u32 key[][ARIA_RD_KEY_WORDS])
 {
-	const __be32 *src = (const __be32 *)in;
-	__be32 *dst = (__be32 *)out;
 	u32 reg0, reg1, reg2, reg3;
 	int rounds, rkidx = 0;
 
 	rounds = ctx->rounds;
 
-	reg0 = be32_to_cpu(src[0]);
-	reg1 = be32_to_cpu(src[1]);
-	reg2 = be32_to_cpu(src[2]);
-	reg3 = be32_to_cpu(src[3]);
+	reg0 = get_unaligned_be32(&in[0]);
+	reg1 = get_unaligned_be32(&in[4]);
+	reg2 = get_unaligned_be32(&in[8]);
+	reg3 = get_unaligned_be32(&in[12]);
 
 	aria_add_round_key(key[rkidx], &reg0, &reg1, &reg2, &reg3);
 	rkidx++;
 
 	aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
@@ -239,14 +237,14 @@ static void __aria_crypt(struct aria_ctx *ctx, u8 *out, const u8 *in,
 	reg3 = key[rkidx][3] ^ make_u32((u8)(x1[get_u8(reg3, 0)]),
 					(u8)(x2[get_u8(reg3, 1)] >> 8),
 					(u8)(s1[get_u8(reg3, 2)]),
 					(u8)(s2[get_u8(reg3, 3)]));
 
-	dst[0] = cpu_to_be32(reg0);
-	dst[1] = cpu_to_be32(reg1);
-	dst[2] = cpu_to_be32(reg2);
-	dst[3] = cpu_to_be32(reg3);
+	put_unaligned_be32(reg0, &out[0]);
+	put_unaligned_be32(reg1, &out[4]);
+	put_unaligned_be32(reg2, &out[8]);
+	put_unaligned_be32(reg3, &out[12]);
 }
 
 void aria_encrypt(void *_ctx, u8 *out, const u8 *in)
 {
 	struct aria_ctx *ctx = (struct aria_ctx *)_ctx;
@@ -282,11 +280,10 @@ static struct crypto_alg aria_alg = {
 	.cra_driver_name	=	"aria-generic",
 	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ARIA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct aria_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	ARIA_MIN_KEY_SIZE,
 			.cia_max_keysize	=	ARIA_MAX_KEY_SIZE,
-- 
2.47.1

