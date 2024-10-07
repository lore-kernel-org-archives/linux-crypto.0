Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A0C1078B
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264296; cv=none; b=BIBFEGbKWZ++hHLjMrLg2uqoMPX4s9lsMG2GH/mh8KBnzN3Hq2VErdRej53bS5lkzNeSZlLxKc5zIvxSiuH1V3+RHhFGA0mu0lZnBcfv0he0sKked+vYIM7oTIsUDzrxtbWSQojV2LItL1B5uyDOYiYHaIfo8h9AqO9o5JFtt4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264296; c=relaxed/simple;
	bh=P8dQXy2eYS/6EZXuzq3z/fT3xjKCg0HAAYYIHO3D688=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6+ftaqhYuchgQCWq/SXVDXuZj7FKZ60fJSLdddmqNVBFq3p0pCTirPFpTff8TAEyV+NCX/wznLR8VrhgCqXgm9GFgG/dp5QiaWgBOwJUpH2udqdpD7of6fdWqzj0wR8xYQaKoFNs6AUh1texSWftiK6My23gAOZcsOA5EGsYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfM8xReo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfM8xReo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D71C4CED4;
	Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264296;
	bh=P8dQXy2eYS/6EZXuzq3z/fT3xjKCg0HAAYYIHO3D688=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfM8xReoj77S7wqHAHs7qBZRb319TsMavjx1Gmq6E0IBsEbN2vHDKyom1b56btWsj
	 nk4qABwSk30puSoLHVGqdaDgsAbl8QpcSTzV0cOgXB1cKKtUNkqjbxMYQ0cJRrMi+S
	 fR1cf6dn2meQNEewLLLi9eOHRfaWgDfRIDU0FcftjHprB3KTkEBBT13wMG2OiXyFm/
	 WitBPB+XPoUhIyc5B+vreobAUKIcoJFr8vxJV6fIJ2WHWHAGqZ26ov+O4EJTABnq8k
	 H8Kb8+cqv55zyft+ryD3GKHlfUgzV8vO48EsB6F+802umE0mldxttCJXMgHLjdtDRI
	 +3W/lfu60rvgA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 03/10] crypto: x86/aegis128 - eliminate some indirect calls
Date: Sun,  6 Oct 2024 18:24:23 -0700
Message-ID: <20241007012430.163606-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Instead of using a struct of function pointers to decide whether to call
the encryption or decryption assembly functions, use a conditional
branch on a bool.  Force-inline the functions to avoid actually
generating the branch.  This improves performance slightly since
indirect calls are slow.  Remove the now-unnecessary CFI stubs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S  |  9 ++--
 arch/x86/crypto/aegis128-aesni-glue.c | 74 +++++++++++++--------------
 2 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 2de859173940..1b57558548c7 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -5,11 +5,10 @@
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define STATE0	%xmm0
 #define STATE1	%xmm1
 #define STATE2	%xmm2
@@ -401,11 +400,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_ad)
 
 /*
  * void crypto_aegis128_aesni_enc(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc)
+SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
 	jb .Lenc_out
 
@@ -498,11 +497,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc)
 
 /*
  * void crypto_aegis128_aesni_enc_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc_tail)
+SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
@@ -555,11 +554,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
 
 /*
  * void crypto_aegis128_aesni_dec(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec)
+SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
 	jb .Ldec_out
 
@@ -652,11 +651,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_dec)
 
 /*
  * void crypto_aegis128_aesni_dec_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
+SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 96586470154e..deb39cef0be1 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -54,20 +54,10 @@ struct aegis_state {
 
 struct aegis_ctx {
 	struct aegis_block key;
 };
 
-struct aegis_crypt_ops {
-	int (*skcipher_walk_init)(struct skcipher_walk *walk,
-				  struct aead_request *req, bool atomic);
-
-	void (*crypt_blocks)(void *state, unsigned int length, const void *src,
-			     void *dst);
-	void (*crypt_tail)(void *state, unsigned int length, const void *src,
-			   void *dst);
-};
-
 static void crypto_aegis128_aesni_process_ad(
 		struct aegis_state *state, struct scatterlist *sg_src,
 		unsigned int assoclen)
 {
 	struct scatter_walk walk;
@@ -112,24 +102,41 @@ static void crypto_aegis128_aesni_process_ad(
 		memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
 		crypto_aegis128_aesni_ad(state, AEGIS128_BLOCK_SIZE, buf.bytes);
 	}
 }
 
-static void crypto_aegis128_aesni_process_crypt(
-		struct aegis_state *state, struct skcipher_walk *walk,
-		const struct aegis_crypt_ops *ops)
+static __always_inline void
+crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
+				    struct skcipher_walk *walk, bool enc)
 {
 	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
-		ops->crypt_blocks(state,
-				  round_down(walk->nbytes, AEGIS128_BLOCK_SIZE),
-				  walk->src.virt.addr, walk->dst.virt.addr);
+		if (enc)
+			crypto_aegis128_aesni_enc(
+					state,
+					round_down(walk->nbytes,
+						   AEGIS128_BLOCK_SIZE),
+					walk->src.virt.addr,
+					walk->dst.virt.addr);
+		else
+			crypto_aegis128_aesni_dec(
+					state,
+					round_down(walk->nbytes,
+						   AEGIS128_BLOCK_SIZE),
+					walk->src.virt.addr,
+					walk->dst.virt.addr);
 		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
 	}
 
 	if (walk->nbytes) {
-		ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
-				walk->dst.virt.addr);
+		if (enc)
+			crypto_aegis128_aesni_enc_tail(state, walk->nbytes,
+						       walk->src.virt.addr,
+						       walk->dst.virt.addr);
+		else
+			crypto_aegis128_aesni_dec_tail(state, walk->nbytes,
+						       walk->src.virt.addr,
+						       walk->dst.virt.addr);
 		skcipher_walk_done(walk, 0);
 	}
 }
 
 static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
@@ -160,71 +167,62 @@ static int crypto_aegis128_aesni_setauthsize(struct crypto_aead *tfm,
 	if (authsize < AEGIS128_MIN_AUTH_SIZE)
 		return -EINVAL;
 	return 0;
 }
 
-static void crypto_aegis128_aesni_crypt(struct aead_request *req,
-					struct aegis_block *tag_xor,
-					unsigned int cryptlen,
-					const struct aegis_crypt_ops *ops)
+static __always_inline void
+crypto_aegis128_aesni_crypt(struct aead_request *req,
+			    struct aegis_block *tag_xor,
+			    unsigned int cryptlen, bool enc)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
 	struct skcipher_walk walk;
 	struct aegis_state state;
 
-	ops->skcipher_walk_init(&walk, req, true);
+	if (enc)
+		skcipher_walk_aead_encrypt(&walk, req, true);
+	else
+		skcipher_walk_aead_decrypt(&walk, req, true);
 
 	kernel_fpu_begin();
 
 	crypto_aegis128_aesni_init(&state, ctx->key.bytes, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128_aesni_process_crypt(&state, &walk, ops);
+	crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
 	crypto_aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
 }
 
 static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
 {
-	static const struct aegis_crypt_ops OPS = {
-		.skcipher_walk_init = skcipher_walk_aead_encrypt,
-		.crypt_blocks = crypto_aegis128_aesni_enc,
-		.crypt_tail = crypto_aegis128_aesni_enc_tail,
-	};
-
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_block tag = {};
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, &OPS);
+	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst,
 				 req->assoclen + cryptlen, authsize, 1);
 	return 0;
 }
 
 static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
 {
 	static const struct aegis_block zeros = {};
 
-	static const struct aegis_crypt_ops OPS = {
-		.skcipher_walk_init = skcipher_walk_aead_decrypt,
-		.crypt_blocks = crypto_aegis128_aesni_dec,
-		.crypt_tail = crypto_aegis128_aesni_dec_tail,
-	};
-
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_block tag;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen - authsize;
 
 	scatterwalk_map_and_copy(tag.bytes, req->src,
 				 req->assoclen + cryptlen, authsize, 0);
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, &OPS);
+	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
 
 	return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG : 0;
 }
 
 static struct aead_alg crypto_aegis128_aesni_alg = {
-- 
2.46.2

