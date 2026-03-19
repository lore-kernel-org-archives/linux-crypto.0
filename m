Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B56359A7A;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901159; cv=none; b=pNLPQ0yuKzYYlhC8rwm3buFvZhbAvwUrMxZEqiI5C+9mxesYsN74L7L7RIgfK1+LUfT5XCvTbIC5Hk1AdsvLynrQWd9PxilOF781HdNziNGK+q5DEPrBxW5O4m7GqhJd3RUAswyevWYb3uG0UXTS1HUAJ01mbsgbW0fLSJyAv/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901159; c=relaxed/simple;
	bh=g4HC7CR5REgRhpaC7W+TZS5hRJ5IjsLa0h/bTCy9m6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK4ITbSM57sITtDs7qAEUIGgcDPAH4vw5sticNhOgs2ZfVHEqjI4fZ23lxniBzwLloyt/uz7NzvSN45ZwSpNqDnAhDN25jOrAwxE/tiLo4kBtUX05r8PZXIGGsAApFGKhrym763Puck7ImO+3T9o3eUjxFbIbuEmfTzDyZpm/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0/qBsme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0/qBsme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C688C2BCAF;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901159;
	bh=g4HC7CR5REgRhpaC7W+TZS5hRJ5IjsLa0h/bTCy9m6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0/qBsme+JzpcNbY/maKCWAZlEYHcGW3FJEAde5UvPs1AUj87gYJjDHtePlBYTO6U
	 5hkY81O0L87uiuAeSxqFIj5g0A+yCnwrN9XuTOtUNoSm+Rl5TxmOX3iLj2+/GYDZZr
	 RwL/KZcHD3V61g5HYxIeXsb0blIgF647GTQayQDTob3pavHtLMNWp+NnlxAfzhxNEa
	 Y//XSF8cE8wG2iJEeRz/q6Lv5XxPfCWcMMrgHyV1JxN1VkFgZ5Ib4+DDBsSd3KFFn2
	 JsNmiLclTDgj9zCx4vQxwbHyYg9VfxFws8xnWfXE95Su1tTZX5Ko/M2kGtJQKv8rGq
	 X22oPsRM/tPDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/19] crypto: arm64/aes-gcm - Rename struct ghash_key and make fixed-sized
Date: Wed, 18 Mar 2026 23:17:11 -0700
Message-ID: <20260319061723.1140720-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the 'struct ghash_key' in arch/arm64/crypto/ghash-ce-glue.c to
prevent a naming conflict with the library 'struct ghash_key'.  In
addition, declare the 'h' field with an explicit size, now that there's
no longer any reason for it to be a flexible array.

Update the comments in the assembly file to match the C code.  Note that
some of these were out-of-date.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 15 ++++++++-------
 arch/arm64/crypto/ghash-ce-glue.c | 20 +++++++++-----------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index a01f136f4fb2..33772d8fe6b5 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -62,11 +62,11 @@
 	pmull		XL.1q, XL.1d, MASK.1d
 	.endm
 
 	/*
 	 * void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
-	 *			       u64 const h[][2], const char *head)
+	 *			       u64 const h[4][2], const char *head)
 	 */
 SYM_FUNC_START(pmull_ghash_update_p64)
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
 
@@ -411,22 +411,23 @@ CPU_LE(	rev		w8, w8		)
 	.endif
 	b		3b
 	.endm
 
 	/*
-	 * void pmull_gcm_encrypt(int blocks, u8 dst[], const u8 src[],
-	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
-	 *			  int rounds, u8 tag)
+	 * void pmull_gcm_encrypt(int bytes, u8 dst[], const u8 src[],
+	 *			  u64 const h[4][2], u64 dg[], u8 ctr[],
+	 *			  u32 const rk[], int rounds, u8 tag[])
 	 */
 SYM_FUNC_START(pmull_gcm_encrypt)
 	pmull_gcm_do_crypt	1
 SYM_FUNC_END(pmull_gcm_encrypt)
 
 	/*
-	 * void pmull_gcm_decrypt(int blocks, u8 dst[], const u8 src[],
-	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
-	 *			  int rounds, u8 tag)
+	 * int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
+	 *			 u64 const h[4][2], u64 dg[], u8 ctr[],
+	 *			 u32 const rk[], int rounds, const u8 l[],
+	 *			 const u8 tag[], u64 authsize)
 	 */
 SYM_FUNC_START(pmull_gcm_decrypt)
 	pmull_gcm_do_crypt	0
 SYM_FUNC_END(pmull_gcm_decrypt)
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 42fb46bdc124..c74066d430fa 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -28,38 +28,38 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("gcm(aes)");
 MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 
 #define RFC4106_NONCE_SIZE	4
 
-struct ghash_key {
+struct arm_ghash_key {
 	be128			k;
-	u64			h[][2];
+	u64			h[4][2];
 };
 
 struct arm_ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
 };
 
 struct gcm_aes_ctx {
 	struct aes_enckey	aes_key;
 	u8			nonce[RFC4106_NONCE_SIZE];
-	struct ghash_key	ghash_key;
+	struct arm_ghash_key	ghash_key;
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
-				       u64 const h[][2], const char *head);
+				       u64 const h[4][2], const char *head);
 
 asmlinkage void pmull_gcm_encrypt(int bytes, u8 dst[], const u8 src[],
-				  u64 const h[][2], u64 dg[], u8 ctr[],
+				  u64 const h[4][2], u64 dg[], u8 ctr[],
 				  u32 const rk[], int rounds, u8 tag[]);
 asmlinkage int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
-				 u64 const h[][2], u64 dg[], u8 ctr[],
+				 u64 const h[4][2], u64 dg[], u8 ctr[],
 				 u32 const rk[], int rounds, const u8 l[],
 				 const u8 tag[], u64 authsize);
 
 static void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
-				 struct ghash_key *key, const char *head)
+				 struct arm_ghash_key *key, const char *head)
 {
 	scoped_ksimd()
 		pmull_ghash_update_p64(blocks, dg, src, key->h, head);
 }
 
@@ -365,12 +365,11 @@ static struct aead_alg gcm_aes_algs[] = {{
 
 	.base.cra_name		= "gcm(aes)",
 	.base.cra_driver_name	= "gcm-aes-ce",
 	.base.cra_priority	= 300,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx) +
-				  4 * sizeof(u64[2]),
+	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.ivsize			= GCM_RFC4106_IV_SIZE,
 	.chunksize		= AES_BLOCK_SIZE,
 	.maxauthsize		= AES_BLOCK_SIZE,
@@ -381,12 +380,11 @@ static struct aead_alg gcm_aes_algs[] = {{
 
 	.base.cra_name		= "rfc4106(gcm(aes))",
 	.base.cra_driver_name	= "rfc4106-gcm-aes-ce",
 	.base.cra_priority	= 300,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx) +
-				  4 * sizeof(u64[2]),
+	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
 }};
 
 static int __init ghash_ce_mod_init(void)
 {
-- 
2.53.0

