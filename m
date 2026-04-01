Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C80EDDC5;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002069; cv=none; b=H7EWjzusvfo5kqryF5u4ZkCxVlM280hob5I2R6ojHx8Us3c4vudVYDFblvj9+r+yplVjXzeFsNJtwiaLim6o/6Y53GujBpZwtzYGK79DuiPQUsSjo891ucaqjC2Q16sKv79Ixm8Q0IluJmf/MuKT2Qz6zCCTfMz1JgWNNu38Uuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002069; c=relaxed/simple;
	bh=QQ5mFKI5+uBNS64ELsUrgq6oqh/+Q+BmfI0QIv2/GuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/ujE3VRO+KgzOi/LKqax6rH+tn0ilCijuT6aIeYUOonxiCLZfcXTjK/hKocSemYHdbFjmd5R73KV125PaPUXWbtJ6KKA/5jueOvHdn8zcSmIbrGIyYjmKPgq57d8ybHRHtTCunJVbvpqZdmWthf7LcVm3jIQkfy+ijRjPlq2fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqjb0dqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqjb0dqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A12C2BCB0;
	Wed,  1 Apr 2026 00:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002069;
	bh=QQ5mFKI5+uBNS64ELsUrgq6oqh/+Q+BmfI0QIv2/GuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqjb0dqGJVSdbX84cN3kcRLDWKnpsqEutYUmzk2VWkQ1HxO+/cWz7jD0nZ8R20CQi
	 /ai8DJSkK9Q7jCRTan2YBsl6kRpeW7Efc2O26yT9l9Zl8qn8Hd99kUiYnCOeNd4O0M
	 rGwLz4WeTTT4/9kixddS/iB/pHnXZUtlyy/wq01qwZd0pvpFj0Rw9NLP8TCHUA5vWe
	 P3/RqWKkvs8pCUUaLCUwWDOlJUzDrLkjjOXnivDXGDWSY5kRWngnaef8lfexYA/2dr
	 EghDBbuGLMCmrGkfQTe1SvFs93Cmc6Vth6toFWDyVgUBs80BLlvqo5bTF7WKUzphPc
	 /6BWsJhgQjTwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/9] lib/crypto: arm64/aes: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:40 -0700
Message-ID: <20260401000548.133151-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
NEON at context switch"), kernel-mode NEON sections have been
preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
restrict the preemption modes"), voluntary preemption is no longer
supported on arm64 either.  Therefore, there's no longer any need to
limit the length of kernel-mode NEON sections on arm64.

Simplify the AES-CBC-MAC code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 13 ++++-------
 include/crypto/aes.h                |  6 ++---
 lib/crypto/arm64/aes-modes.S        |  8 +++----
 lib/crypto/arm64/aes.h              | 35 +++++++++++------------------
 4 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 45aed0073283..a304375ce724 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -99,20 +99,15 @@ static u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
 
 	do {
 		u32 blocks = abytes / AES_BLOCK_SIZE;
 
 		if (macp == AES_BLOCK_SIZE || (!macp && blocks > 0)) {
-			u32 rem = ce_aes_mac_update(in, rk, rounds, blocks, mac,
-						    macp, enc_after);
-			u32 adv = (blocks - rem) * AES_BLOCK_SIZE;
-
+			ce_aes_mac_update(in, rk, rounds, blocks, mac, macp,
+					  enc_after);
 			macp = enc_after ? 0 : AES_BLOCK_SIZE;
-			in += adv;
-			abytes -= adv;
-
-			if (unlikely(rem))
-				macp = 0;
+			in += blocks * AES_BLOCK_SIZE;
+			abytes -= blocks * AES_BLOCK_SIZE;
 		} else {
 			u32 l = min(AES_BLOCK_SIZE - macp, abytes);
 
 			crypto_xor(&mac[macp], in, l);
 			in += l;
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 3feb4105c2a2..16fbfd93e2bd 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -228,13 +228,13 @@ asmlinkage void ce_aes_essiv_cbc_encrypt(u8 out[], u8 const in[],
 					 u32 const rk1[], int rounds,
 					 int blocks, u8 iv[], u32 const rk2[]);
 asmlinkage void ce_aes_essiv_cbc_decrypt(u8 out[], u8 const in[],
 					 u32 const rk1[], int rounds,
 					 int blocks, u8 iv[], u32 const rk2[]);
-asmlinkage size_t ce_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
-				    size_t blocks, u8 dg[], int enc_before,
-				    int enc_after);
+asmlinkage void ce_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+				  size_t blocks, u8 dg[], int enc_before,
+				  int enc_after);
 #elif defined(CONFIG_PPC)
 void ppc_expand_key_128(u32 *key_enc, const u8 *key);
 void ppc_expand_key_192(u32 *key_enc, const u8 *key);
 void ppc_expand_key_256(u32 *key_enc, const u8 *key);
 void ppc_generate_decrypt_key(u32 *key_dec, u32 *key_enc, unsigned int key_len);
diff --git a/lib/crypto/arm64/aes-modes.S b/lib/crypto/arm64/aes-modes.S
index fc89cd02b642..10e537317eaf 100644
--- a/lib/crypto/arm64/aes-modes.S
+++ b/lib/crypto/arm64/aes-modes.S
@@ -815,13 +815,13 @@ AES_FUNC_START(aes_xts_decrypt)
 	b		.Lxtsdecctsout
 AES_FUNC_END(aes_xts_decrypt)
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC_MACS)
 	/*
-	 * size_t aes_mac_update(u8 const in[], u32 const rk[], int rounds,
-	 *			 size_t blocks, u8 dg[], int enc_before,
-	 *			 int enc_after);
+	 * void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+	 *		       size_t blocks, u8 dg[], int enc_before,
+	 *		       int enc_after);
 	 */
 AES_FUNC_START(aes_mac_update)
 	ld1		{v0.16b}, [x4]			/* get dg */
 	enc_prepare	w2, x1, x7
 	cbz		w5, .Lmacloop4x
@@ -842,11 +842,10 @@ AES_FUNC_START(aes_mac_update)
 	cmp		x3, xzr
 	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
-	cond_yield	.Lmacout, x7, x8
 	b		.Lmacloop4x
 .Lmac1x:
 	add		x3, x3, #4
 .Lmacloop:
 	cbz		x3, .Lmacout
@@ -861,9 +860,8 @@ AES_FUNC_START(aes_mac_update)
 	encrypt_block	v0, w2, x1, x7, w8
 	b		.Lmacloop
 
 .Lmacout:
 	st1		{v0.16b}, [x4]			/* return dg */
-	mov		x0, x3
 	ret
 AES_FUNC_END(aes_mac_update)
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC_MACS */
diff --git a/lib/crypto/arm64/aes.h b/lib/crypto/arm64/aes.h
index 135d3324a30a..9e9e45a6f787 100644
--- a/lib/crypto/arm64/aes.h
+++ b/lib/crypto/arm64/aes.h
@@ -27,13 +27,13 @@ asmlinkage void __aes_ce_encrypt(const u32 rk[], u8 out[AES_BLOCK_SIZE],
 asmlinkage void __aes_ce_decrypt(const u32 inv_rk[], u8 out[AES_BLOCK_SIZE],
 				 const u8 in[AES_BLOCK_SIZE], int rounds);
 asmlinkage u32 __aes_ce_sub(u32 l);
 asmlinkage void __aes_ce_invert(struct aes_block *out,
 				const struct aes_block *in);
-asmlinkage size_t neon_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
-				      size_t blocks, u8 dg[], int enc_before,
-				      int enc_after);
+asmlinkage void neon_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+				    size_t blocks, u8 dg[], int enc_before,
+				    int enc_after);
 
 /*
  * Expand an AES key using the crypto extensions if supported and usable or
  * generic code otherwise.  The expanded key format is compatible between the
  * two cases.  The outputs are @rndkeys (required) and @inv_rndkeys (optional).
@@ -190,29 +190,20 @@ static bool aes_cbcmac_blocks_arch(u8 h[AES_BLOCK_SIZE],
 				   const struct aes_enckey *key, const u8 *data,
 				   size_t nblocks, bool enc_before,
 				   bool enc_after)
 {
 	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		do {
-			size_t rem;
-
-			scoped_ksimd() {
-				if (static_branch_likely(&have_aes))
-					rem = ce_aes_mac_update(
-						data, key->k.rndkeys,
-						key->nrounds, nblocks, h,
-						enc_before, enc_after);
-				else
-					rem = neon_aes_mac_update(
-						data, key->k.rndkeys,
-						key->nrounds, nblocks, h,
-						enc_before, enc_after);
-			}
-			data += (nblocks - rem) * AES_BLOCK_SIZE;
-			nblocks = rem;
-			enc_before = false;
-		} while (nblocks);
+		scoped_ksimd() {
+			if (static_branch_likely(&have_aes))
+				ce_aes_mac_update(data, key->k.rndkeys,
+						  key->nrounds, nblocks, h,
+						  enc_before, enc_after);
+			else
+				neon_aes_mac_update(data, key->k.rndkeys,
+						    key->nrounds, nblocks, h,
+						    enc_before, enc_after);
+		}
 		return true;
 	}
 	return false;
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC_MACS */
-- 
2.53.0

