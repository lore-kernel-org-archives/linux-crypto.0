Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E57155759
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=tD5HhrKgVa/F0yBFqHHYQ8pkLKz71Fo7eLThZbnJbsEmJL2TWFpjH8c/EzrBjGx9VJeAdV/eiJiV9+Qk+fRSWUgO8/mZ+J/apZDsIdQvyEf6hlBaz3VAITwp1YiKEo177bXItHUdThn8WzarjFYCDM6G24MNGsLZAjW1uyDHFdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=D1txlg46hkHeEOfHNEpb4Zq5tuFo1uQusTc9AUkmA5A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD6FaK12ZcU4BtiyZj1W6idRMBhlkxar8HidYySycNCVU05ZOjqGaobQXQXr+LhXsrm4lciWK/BbgxBBubsz35FVUPXlUj5fh0pbvPAfmSWhWbJOS4kt+wNyO1+Xscfg5CKyfYGP4C38N+tMptcp4sGQcmdWZ3AckPg3aODT8hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuPt5ssJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuPt5ssJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDE0C4CEDF
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=D1txlg46hkHeEOfHNEpb4Zq5tuFo1uQusTc9AUkmA5A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kuPt5ssJ5f/giPmuKsaSLlbwr1nH5DI5MJajnk8hzvBR1H7Q+m2MoygfoL1mZeNup
	 5CFWD1t5QgDw6w/22TsvWltrsQsMbXEGMVHpdPYDjNrhtKfs82+UAQL9nOgBezwcyV
	 aeEy1/wOtgz4FFrPgPFMLiYjJ+JlgwrY0P1Sk18jpTaGETChoxYTojE48MyjdGuSGq
	 12yeaReEkVFBfz/Ifcbg9kWFt2vabUeYjbuCHV7DLuFNv5LBKU2FD09/dEu4x8w/pP
	 D9sEm/exr4To5og3V1gIjiWBWWu+qa4WoEmRBhZCcrD2KO8tLGTxFLZmGo08I+Z6oi
	 WChJBdFkBeYzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 4/8] crypto: khazad - stop using cra_alignmask
Date: Sat,  7 Dec 2024 11:57:48 -0800
Message-ID: <20241207195752.87654-5-ebiggers@kernel.org>
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
 crypto/khazad.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/crypto/khazad.c b/crypto/khazad.c
index 70cafe73f9740..7ad338ca2c18f 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -21,11 +21,11 @@
 
 #include <crypto/algapi.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
+#include <linux/unaligned.h>
 #include <linux/types.h>
 
 #define KHAZAD_KEY_SIZE		16
 #define KHAZAD_BLOCK_SIZE	8
 #define KHAZAD_ROUNDS		8
@@ -755,18 +755,16 @@ static const u64 c[KHAZAD_ROUNDS + 1] = {
 
 static int khazad_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {
 	struct khazad_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __be32 *key = (const __be32 *)in_key;
 	int r;
 	const u64 *S = T7;
 	u64 K2, K1;
 
-	/* key is supposed to be 32-bit aligned */
-	K2 = ((u64)be32_to_cpu(key[0]) << 32) | be32_to_cpu(key[1]);
-	K1 = ((u64)be32_to_cpu(key[2]) << 32) | be32_to_cpu(key[3]);
+	K2 = get_unaligned_be64(&in_key[0]);
+	K1 = get_unaligned_be64(&in_key[8]);
 
 	/* setup the encrypt key */
 	for (r = 0; r <= KHAZAD_ROUNDS; r++) {
 		ctx->E[r] = T0[(int)(K1 >> 56)       ] ^
 			    T1[(int)(K1 >> 48) & 0xff] ^
@@ -798,18 +796,16 @@ static int khazad_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 
 }
 
 static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
-		u8 *ciphertext, const u8 *plaintext)
+			 u8 *dst, const u8 *src)
 {
-	const __be64 *src = (const __be64 *)plaintext;
-	__be64 *dst = (__be64 *)ciphertext;
 	int r;
 	u64 state;
 
-	state = be64_to_cpu(*src) ^ roundKey[0];
+	state = get_unaligned_be64(src) ^ roundKey[0];
 
 	for (r = 1; r < KHAZAD_ROUNDS; r++) {
 		state = T0[(int)(state >> 56)       ] ^
 			T1[(int)(state >> 48) & 0xff] ^
 			T2[(int)(state >> 40) & 0xff] ^
@@ -829,11 +825,11 @@ static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
 		(T5[(int)(state >> 16) & 0xff] & 0x0000000000ff0000ULL) ^
 		(T6[(int)(state >>  8) & 0xff] & 0x000000000000ff00ULL) ^
 		(T7[(int)(state      ) & 0xff] & 0x00000000000000ffULL) ^
 		roundKey[KHAZAD_ROUNDS];
 
-	*dst = cpu_to_be64(state);
+	put_unaligned_be64(state, dst);
 }
 
 static void khazad_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct khazad_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -850,11 +846,10 @@ static struct crypto_alg khazad_alg = {
 	.cra_name		=	"khazad",
 	.cra_driver_name	=	"khazad-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	KHAZAD_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct khazad_ctx),
-	.cra_alignmask		=	7,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	KHAZAD_KEY_SIZE,
 	.cia_max_keysize	=	KHAZAD_KEY_SIZE,
 	.cia_setkey		= 	khazad_setkey,
-- 
2.47.1

