Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF91153573
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=fO+oLp+oNIgv+d46sU0orPp8mURbmD5a8lQXUWMmAg430XBdlfyRPcmIan/su/SpBZpsEf2Z/D02vkSWqRYQHE3Klht+2Tn5vkZpDrnTpkcaheqNdz/Ranpk0PfkKyVpRCjNY5Qg7bS4GbiiQAyYHjKVJ4QOSc371GMsaTVnQrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=VUa1mmLsSCRwI64/KwV+wAc3rjy9YU3dBQo80ZMq2TM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvmQv6ptZyi+4dHlg3hhgoQ46xfzPA44soAW+PENG/c9V5lUFMVetzUdR+Jj2ra3siS6NjnyKF1NIDFgf/vDYKugeiAjDsAJkitcmkXBOEh5ZZqCinsxAucCqIMENxkezLNsc0tsHYSrlfKYD9hbuBIiXaOo7ycKLhZgmaEoWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klK/72BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klK/72BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99953C4CEDD
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601512;
	bh=VUa1mmLsSCRwI64/KwV+wAc3rjy9YU3dBQo80ZMq2TM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=klK/72BZDm4CerH61JJbXqD6+eC7TNaQBwrlyw/xX0/Ox+AL9Dpef4/VNkRzFb65C
	 IgUNJmNzd0Ld2aPLKMrpj8N3VeUTcIo2DdNYb+HQu5XMi6NRm4URQUcSHR2+STxRM9
	 OdrOuOCvrXVzeioadWCdgkRQUV2cZd41SWlZalv9fmNaN4ClXcKzLnVq1poyvuJrxi
	 WID+O+QJjX+YfBax264dKeAMpTob0IdqNlyfyaF1W9tt9csPvM2LOlZC8X0yOltx+8
	 TWwh1uIL4JIfMDMoBkQrili4vSutAmgxseJ8qTTw3vSK6iQ11uQO9ryZW7g+eEY8aG
	 pfDz2cdsarMyw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 1/8] crypto: anubis - stop using cra_alignmask
Date: Sat,  7 Dec 2024 11:57:45 -0800
Message-ID: <20241207195752.87654-2-ebiggers@kernel.org>
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
 crypto/anubis.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/crypto/anubis.c b/crypto/anubis.c
index 9f0cf61bbc6e2..886e7c9136886 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -31,11 +31,11 @@
 
 #include <crypto/algapi.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
+#include <linux/unaligned.h>
 #include <linux/types.h>
 
 #define ANUBIS_MIN_KEY_SIZE	16
 #define ANUBIS_MAX_KEY_SIZE	40
 #define ANUBIS_BLOCK_SIZE	16
@@ -461,11 +461,10 @@ static const u32 rc[] = {
 
 static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {
 	struct anubis_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *key = (const __be32 *)in_key;
 	int N, R, i, r;
 	u32 kappa[ANUBIS_MAX_N];
 	u32 inter[ANUBIS_MAX_N];
 
 	switch (key_len) {
@@ -480,11 +479,11 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	N = ctx->key_len >> 5;
 	ctx->R = R = 8 + N;
 
 	/* * map cipher key to initial key state (mu): */
 	for (i = 0; i < N; i++)
-		kappa[i] = be32_to_cpu(key[i]);
+		kappa[i] = get_unaligned_be32(&in_key[4 * i]);
 
 	/*
 	 * generate R + 1 round keys:
 	 */
 	for (r = 0; r <= R; r++) {
@@ -568,24 +567,22 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 
 	return 0;
 }
 
 static void anubis_crypt(u32 roundKey[ANUBIS_MAX_ROUNDS + 1][4],
-		u8 *ciphertext, const u8 *plaintext, const int R)
+			 u8 *dst, const u8 *src, const int R)
 {
-	const __be32 *src = (const __be32 *)plaintext;
-	__be32 *dst = (__be32 *)ciphertext;
 	int i, r;
 	u32 state[4];
 	u32 inter[4];
 
 	/*
 	 * map plaintext block to cipher state (mu)
 	 * and add initial round key (sigma[K^0]):
 	 */
 	for (i = 0; i < 4; i++)
-		state[i] = be32_to_cpu(src[i]) ^ roundKey[0][i];
+		state[i] = get_unaligned_be32(&src[4 * i]) ^ roundKey[0][i];
 
 	/*
 	 * R - 1 full rounds:
 	 */
 
@@ -652,11 +649,11 @@ static void anubis_crypt(u32 roundKey[ANUBIS_MAX_ROUNDS + 1][4],
 	/*
 	 * map cipher state to ciphertext block (mu^{-1}):
 	 */
 
 	for (i = 0; i < 4; i++)
-		dst[i] = cpu_to_be32(inter[i]);
+		put_unaligned_be32(inter[i], &dst[4 * i]);
 }
 
 static void anubis_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct anubis_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -673,11 +670,10 @@ static struct crypto_alg anubis_alg = {
 	.cra_name		=	"anubis",
 	.cra_driver_name	=	"anubis-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ANUBIS_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct anubis_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	ANUBIS_MIN_KEY_SIZE,
 	.cia_max_keysize	=	ANUBIS_MAX_KEY_SIZE,
 	.cia_setkey		= 	anubis_setkey,
-- 
2.47.1

