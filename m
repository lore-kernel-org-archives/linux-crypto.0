Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A8182D2;
	Thu, 17 Oct 2024 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123335; cv=none; b=G8hV4Ta3R89PVgtYIUhIYsAUy2q1/wJaPsNm7UQ8hl9SWpI8pFZqGhQfcd7YyNn7sUIib2Jc6nPUQczNA14M6rVtyC7eTanare2RE7k2wl175QKpmGHts81IbjL9vBbtUPAfXs9bb9E90HATUtQHQ7oyevoksj6HPCg7zkOEUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123335; c=relaxed/simple;
	bh=STEao61qdOBFlm96DR2zxYNVqZ0pbmgKZZdE/wkRW1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW4Rjjm4yAXzDW15fR8feSMAN5SlT1UOLMpl3IOneZTQtxnz3f461aIqkL1Ufc5NCafXhnBBx3CDUQtX99IeGrhyTYtGYosxcWt8ghGX7B+eOyVWbztZalW4DDcDRteWv5Exyh7E+2ElV5f6JFFMy/Qt+s6ggV2B/PCseRc7yzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYJeYE1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYJeYE1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7037DC4CECF;
	Thu, 17 Oct 2024 00:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123334;
	bh=STEao61qdOBFlm96DR2zxYNVqZ0pbmgKZZdE/wkRW1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYJeYE1ImDoxqPK9bSjsfZDYHns6DbqLZKSthg2Obiw6c54xrGL8xnkjXEsT8vIc1
	 WULIOavByGbSdp3SQ2LpYPKyTGvieXyqzc+cdZV0FzpJDTg7h9Dro1knwCETMQwNl1
	 IkLem2dOIGU3s9KoQsFSrOFnfOqiKiUXgPL8gHLk4gO6mXTXWzTJ3hM3OeGUzU96DE
	 eb8vpCZhAtc+cOG7MmFtsH9PZJOQB8wiaw+R36S6LxSMBWUIfefG9WuUqoyUyLTP3T
	 AoslyZV+lRpriROmRYE8M1f+j+GyAPshyrZBKwzQ5TzVqj0eZsbQL5FNYxuAaCFmut
	 vPst+5QBmqvLg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] crypto: x86/aegis128 - improve assembly function prototypes
Date: Wed, 16 Oct 2024 17:00:47 -0700
Message-ID: <20241017000051.228294-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
References: <20241017000051.228294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Adjust the prototypes of the AEGIS assembly functions:

- Use proper types instead of 'void *', when applicable.

- Move the length parameter to after the buffers it describes rather
  than before, to match the usual convention.  Also shorten its name to
  just len (which is the name used in the assembly code).

- Declare register aliases at the beginning of each function rather than
  once per file.  This was necessary because len was moved, but also it
  allows adding some aliases where raw registers were used before.

- Put assoclen and cryptlen in the correct order when declaring the
  finalization function in the .c file.

- Remove the unnecessary "crypto_" prefix.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S  | 105 ++++++++++++++++----------
 arch/x86/crypto/aegis128-aesni-glue.c |  92 +++++++++++-----------
 2 files changed, 112 insertions(+), 85 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 6ed4bc452c292..9dfdbe0b1fb83 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -17,15 +17,10 @@
 #define KEY	%xmm5
 #define MSG	%xmm5
 #define T0	%xmm6
 #define T1	%xmm7
 
-#define STATEP	%rdi
-#define LEN	%esi
-#define SRC	%rdx
-#define DST	%rcx
-
 .section .rodata.cst16.aegis128_const, "aM", @progbits, 32
 .align 16
 .Laegis128_const_0:
 	.byte 0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d
 	.byte 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62
@@ -70,10 +65,12 @@
  *   T0
  *   %r8
  *   %r9
  */
 SYM_FUNC_START_LOCAL(__load_partial)
+	.set LEN, %ecx
+	.set SRC, %rsi
 	xor %r9d, %r9d
 	pxor MSG, MSG
 
 	mov LEN, %r8d
 	and $0x1, %r8
@@ -136,10 +133,12 @@ SYM_FUNC_END(__load_partial)
  *   %r8
  *   %r9
  *   %r10
  */
 SYM_FUNC_START_LOCAL(__store_partial)
+	.set LEN, %ecx
+	.set DST, %rdx
 	mov LEN, %r8d
 	mov DST, %r9
 
 	movq T0, %r10
 
@@ -182,20 +181,25 @@ SYM_FUNC_START_LOCAL(__store_partial)
 .Lst_partial_1:
 	RET
 SYM_FUNC_END(__store_partial)
 
 /*
- * void crypto_aegis128_aesni_init(void *state, const void *key, const void *iv);
+ * void aegis128_aesni_init(struct aegis_state *state,
+ *			    const struct aegis_block *key,
+ *			    const u8 iv[AEGIS128_NONCE_SIZE]);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_init)
+SYM_FUNC_START(aegis128_aesni_init)
+	.set STATEP, %rdi
+	.set KEYP, %rsi
+	.set IVP, %rdx
 	FRAME_BEGIN
 
 	/* load IV: */
-	movdqu (%rdx), T1
+	movdqu (IVP), T1
 
 	/* load key: */
-	movdqa (%rsi), KEY
+	movdqa (KEYP), KEY
 	pxor KEY, T1
 	movdqa T1, STATE0
 	movdqa KEY, STATE3
 	movdqa KEY, STATE4
 
@@ -224,17 +228,20 @@ SYM_FUNC_START(crypto_aegis128_aesni_init)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
 
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_init)
+SYM_FUNC_END(aegis128_aesni_init)
 
 /*
- * void crypto_aegis128_aesni_ad(void *state, unsigned int length,
- *                               const void *data);
+ * void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
+ *			  unsigned int len);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_ad)
+SYM_FUNC_START(aegis128_aesni_ad)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set LEN, %edx
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
 	jb .Lad_out
 
@@ -332,11 +339,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	RET
 
 .Lad_out:
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_ad)
+SYM_FUNC_END(aegis128_aesni_ad)
 
 .macro encrypt_block s0 s1 s2 s3 s4 i
 	movdqu (\i * 0x10)(SRC), MSG
 	movdqa MSG, T0
 	pxor \s1, T0
@@ -353,14 +360,18 @@ SYM_FUNC_END(crypto_aegis128_aesni_ad)
 	cmp $0x10, LEN
 	jl .Lenc_out_\i
 .endm
 
 /*
- * void crypto_aegis128_aesni_enc(void *state, unsigned int length,
- *                                const void *src, void *dst);
+ * void aegis128_aesni_enc(struct aegis_state *state, const u8 *src, u8 *dst,
+ *			   unsigned int len);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc)
+SYM_FUNC_START(aegis128_aesni_enc)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set DST, %rdx
+	.set LEN, %ecx
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
 	jb .Lenc_out
 
@@ -430,17 +441,21 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	RET
 
 .Lenc_out:
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_enc)
+SYM_FUNC_END(aegis128_aesni_enc)
 
 /*
- * void crypto_aegis128_aesni_enc_tail(void *state, unsigned int length,
- *                                     const void *src, void *dst);
+ * void aegis128_aesni_enc_tail(struct aegis_state *state, const u8 *src,
+ *				u8 *dst, unsigned int len);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
+SYM_FUNC_START(aegis128_aesni_enc_tail)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set DST, %rdx
+	.set LEN, %ecx
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
@@ -470,11 +485,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
 
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
+SYM_FUNC_END(aegis128_aesni_enc_tail)
 
 .macro decrypt_block s0 s1 s2 s3 s4 i
 	movdqu (\i * 0x10)(SRC), MSG
 	pxor \s1, MSG
 	pxor \s4, MSG
@@ -490,14 +505,18 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
 	cmp $0x10, LEN
 	jl .Ldec_out_\i
 .endm
 
 /*
- * void crypto_aegis128_aesni_dec(void *state, unsigned int length,
- *                                const void *src, void *dst);
+ * void aegis128_aesni_dec(struct aegis_state *state, const u8 *src, u8 *dst,
+ *			   unsigned int len);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec)
+SYM_FUNC_START(aegis128_aesni_dec)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set DST, %rdx
+	.set LEN, %ecx
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
 	jb .Ldec_out
 
@@ -567,17 +586,21 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	RET
 
 .Ldec_out:
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_dec)
+SYM_FUNC_END(aegis128_aesni_dec)
 
 /*
- * void crypto_aegis128_aesni_dec_tail(void *state, unsigned int length,
- *                                     const void *src, void *dst);
+ * void aegis128_aesni_dec_tail(struct aegis_state *state, const u8 *src,
+ *				u8 *dst, unsigned int len);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
+SYM_FUNC_START(aegis128_aesni_dec_tail)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set DST, %rdx
+	.set LEN, %ecx
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
@@ -617,30 +640,34 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
 
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_dec_tail)
+SYM_FUNC_END(aegis128_aesni_dec_tail)
 
 /*
- * void crypto_aegis128_aesni_final(void *state, void *tag_xor,
- *                                  unsigned int assoclen,
- *                                  unsigned int cryptlen);
+ * void aegis128_aesni_final(struct aegis_state *state,
+ *			     struct aegis_block *tag_xor,
+ *			     unsigned int assoclen, unsigned int cryptlen);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_final)
+SYM_FUNC_START(aegis128_aesni_final)
+	.set STATEP, %rdi
+	.set TAG_XOR, %rsi
+	.set ASSOCLEN, %edx
+	.set CRYPTLEN, %ecx
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
 	/* prepare length block: */
-	movd %edx, MSG
-	pinsrd $2, %ecx, MSG
+	movd ASSOCLEN, MSG
+	pinsrd $2, CRYPTLEN, MSG
 	psllq $3, MSG /* multiply by 8 (to get bit count) */
 
 	pxor STATE3, MSG
 
 	/* update state: */
@@ -651,18 +678,18 @@ SYM_FUNC_START(crypto_aegis128_aesni_final)
 	aegis128_update; pxor MSG, STATE0
 	aegis128_update; pxor MSG, STATE4
 	aegis128_update; pxor MSG, STATE3
 
 	/* xor tag: */
-	movdqu (%rsi), MSG
+	movdqu (TAG_XOR), MSG
 
 	pxor STATE0, MSG
 	pxor STATE1, MSG
 	pxor STATE2, MSG
 	pxor STATE3, MSG
 	pxor STATE4, MSG
 
-	movdqu MSG, (%rsi)
+	movdqu MSG, (TAG_XOR)
 
 	FRAME_END
 	RET
-SYM_FUNC_END(crypto_aegis128_aesni_final)
+SYM_FUNC_END(aegis128_aesni_final)
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 4dd2d981a514f..9555958e4089d 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -21,31 +21,10 @@
 #define AEGIS128_STATE_BLOCKS 5
 #define AEGIS128_KEY_SIZE 16
 #define AEGIS128_MIN_AUTH_SIZE 8
 #define AEGIS128_MAX_AUTH_SIZE 16
 
-asmlinkage void crypto_aegis128_aesni_init(void *state, void *key, void *iv);
-
-asmlinkage void crypto_aegis128_aesni_ad(
-		void *state, unsigned int length, const void *data);
-
-asmlinkage void crypto_aegis128_aesni_enc(
-		void *state, unsigned int length, const void *src, void *dst);
-
-asmlinkage void crypto_aegis128_aesni_dec(
-		void *state, unsigned int length, const void *src, void *dst);
-
-asmlinkage void crypto_aegis128_aesni_enc_tail(
-		void *state, unsigned int length, const void *src, void *dst);
-
-asmlinkage void crypto_aegis128_aesni_dec_tail(
-		void *state, unsigned int length, const void *src, void *dst);
-
-asmlinkage void crypto_aegis128_aesni_final(
-		void *state, void *tag_xor, unsigned int cryptlen,
-		unsigned int assoclen);
-
 struct aegis_block {
 	u8 bytes[AEGIS128_BLOCK_SIZE] __aligned(AEGIS128_BLOCK_ALIGN);
 };
 
 struct aegis_state {
@@ -54,10 +33,36 @@ struct aegis_state {
 
 struct aegis_ctx {
 	struct aegis_block key;
 };
 
+asmlinkage void aegis128_aesni_init(struct aegis_state *state,
+				    const struct aegis_block *key,
+				    const u8 iv[AEGIS128_NONCE_SIZE]);
+
+asmlinkage void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
+				  unsigned int len);
+
+asmlinkage void aegis128_aesni_enc(struct aegis_state *state, const u8 *src,
+				   u8 *dst, unsigned int len);
+
+asmlinkage void aegis128_aesni_dec(struct aegis_state *state, const u8 *src,
+				   u8 *dst, unsigned int len);
+
+asmlinkage void aegis128_aesni_enc_tail(struct aegis_state *state,
+					const u8 *src, u8 *dst,
+					unsigned int len);
+
+asmlinkage void aegis128_aesni_dec_tail(struct aegis_state *state,
+					const u8 *src, u8 *dst,
+					unsigned int len);
+
+asmlinkage void aegis128_aesni_final(struct aegis_state *state,
+				     struct aegis_block *tag_xor,
+				     unsigned int assoclen,
+				     unsigned int cryptlen);
+
 static void crypto_aegis128_aesni_process_ad(
 		struct aegis_state *state, struct scatterlist *sg_src,
 		unsigned int assoclen)
 {
 	struct scatter_walk walk;
@@ -73,19 +78,18 @@ static void crypto_aegis128_aesni_process_ad(
 
 		if (pos + size >= AEGIS128_BLOCK_SIZE) {
 			if (pos > 0) {
 				unsigned int fill = AEGIS128_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
-				crypto_aegis128_aesni_ad(state,
-							 AEGIS128_BLOCK_SIZE,
-							 buf.bytes);
+				aegis128_aesni_ad(state, buf.bytes,
+						  AEGIS128_BLOCK_SIZE);
 				pos = 0;
 				left -= fill;
 				src += fill;
 			}
 
-			crypto_aegis128_aesni_ad(state, left, src);
+			aegis128_aesni_ad(state, src, left);
 
 			src += left & ~(AEGIS128_BLOCK_SIZE - 1);
 			left &= AEGIS128_BLOCK_SIZE - 1;
 		}
 
@@ -98,45 +102,41 @@ static void crypto_aegis128_aesni_process_ad(
 		scatterwalk_done(&walk, 0, assoclen);
 	}
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
-		crypto_aegis128_aesni_ad(state, AEGIS128_BLOCK_SIZE, buf.bytes);
+		aegis128_aesni_ad(state, buf.bytes, AEGIS128_BLOCK_SIZE);
 	}
 }
 
 static __always_inline void
 crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 				    struct skcipher_walk *walk, bool enc)
 {
 	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
 		if (enc)
-			crypto_aegis128_aesni_enc(
-					state,
-					round_down(walk->nbytes,
-						   AEGIS128_BLOCK_SIZE),
-					walk->src.virt.addr,
-					walk->dst.virt.addr);
+			aegis128_aesni_enc(state, walk->src.virt.addr,
+					   walk->dst.virt.addr,
+					   round_down(walk->nbytes,
+						      AEGIS128_BLOCK_SIZE));
 		else
-			crypto_aegis128_aesni_dec(
-					state,
-					round_down(walk->nbytes,
-						   AEGIS128_BLOCK_SIZE),
-					walk->src.virt.addr,
-					walk->dst.virt.addr);
+			aegis128_aesni_dec(state, walk->src.virt.addr,
+					   walk->dst.virt.addr,
+					   round_down(walk->nbytes,
+						      AEGIS128_BLOCK_SIZE));
 		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
 	}
 
 	if (walk->nbytes) {
 		if (enc)
-			crypto_aegis128_aesni_enc_tail(state, walk->nbytes,
-						       walk->src.virt.addr,
-						       walk->dst.virt.addr);
+			aegis128_aesni_enc_tail(state, walk->src.virt.addr,
+						walk->dst.virt.addr,
+						walk->nbytes);
 		else
-			crypto_aegis128_aesni_dec_tail(state, walk->nbytes,
-						       walk->src.virt.addr,
-						       walk->dst.virt.addr);
+			aegis128_aesni_dec_tail(state, walk->src.virt.addr,
+						walk->dst.virt.addr,
+						walk->nbytes);
 		skcipher_walk_done(walk, 0);
 	}
 }
 
 static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
@@ -184,14 +184,14 @@ crypto_aegis128_aesni_crypt(struct aead_request *req,
 	else
 		skcipher_walk_aead_decrypt(&walk, req, true);
 
 	kernel_fpu_begin();
 
-	crypto_aegis128_aesni_init(&state, ctx->key.bytes, req->iv);
+	aegis128_aesni_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
 	crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
-	crypto_aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
+	aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 
 	kernel_fpu_end();
 }
 
 static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
-- 
2.47.0

