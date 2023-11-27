Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lg6b3Grf"
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF890
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-db40b699d0fso4531980276.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701087802; x=1701692602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3Tct0MAFLzfpIwnBhpG04Rsq9x9oCOBU/4NJUxRL5g=;
        b=lg6b3Grf2URKARVskxiRnAhfBugrUQzr/BPv2rPD8QuH0kBTx6CsYW77xoIOigqGlb
         T0jLY6pQkXJDPadkU32mCdnQ1rat33RjB35kYKrg5ie3zu3NfwBUJ1nZBPqO7ju9hDNQ
         G8Zw0JIcPDeqRLTek5xZ+CmTcDfRXYDh4cST2iwllPHKW9vK5YB46r01pC9CKIh9CMx2
         x6L181XaAPJFoJ1gbBFKJ6UCkpeEQ3wfVpHzKm8M82hgFibyAlYf0yalLkF9EJy3EKyV
         fCK7LZTPo/oxA6Bc5kmOiWxGkUlQb2jGZN5EaAsmZoRDY69wnr/IbCW2xKba4vMveXhL
         hhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701087802; x=1701692602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3Tct0MAFLzfpIwnBhpG04Rsq9x9oCOBU/4NJUxRL5g=;
        b=wsuY/brPMfplVC0T+dGgW5sRAZIDHTmI/jrF3QvSjJyhtVW7mYutLnl9LppctE8Wg9
         6oL2mnfTW0UnEWORDhl/wBaDNy/HItGU4hUPWoFP0egxPT2QkKYr1lRzyNk6ZC3IkqSy
         PPqW93ILehFRaOFspvX3HypvKmmUzUU9aTCOzzSvSd+YZRUYAN5UviIqAnzTMVbaY2tX
         GocvBwfxWjxGZ9KVUbNgGF4p+kPTZsvKRdoxFktfbB+tdUlSGYq6U3C0sene8q0LE8/C
         yiUCuae+q7N7B1ImuNXtTiEgJqgQbVlpB2ZTjMVKyfjoXGRTGbOxlhEqxhvLJaYXc+FG
         UmzQ==
X-Gm-Message-State: AOJu0YzUYiN9HJFg90rkEfvopkY/0oahv8NqE2XHTae9a6MsOO0eeWJb
	ovFKzna6bX3QYZh6ShcQni81wd18
X-Google-Smtp-Source: AGHT+IHvdRnQyXaD2cZVGaoFh+SnCDYDvumLE/wIGS5qzsMtiSO7OlE8DeyFhoIqnQRkL3NHIF6ZGS/W
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a25:6c89:0:b0:d9a:58e1:bb52 with SMTP id
 h131-20020a256c89000000b00d9a58e1bb52mr333598ybc.6.1701087802245; Mon, 27 Nov
 2023 04:23:22 -0800 (PST)
Date: Mon, 27 Nov 2023 13:23:04 +0100
In-Reply-To: <20231127122259.2265164-7-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231127122259.2265164-7-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=13333; i=ardb@kernel.org;
 h=from:subject; bh=/mtAyA8UvG4Co8hPQgaVgFqOJxTTWYBgb/Sg4+IwoKU=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITWlSyNYe2vO2Tvqd3abzjDu2cGx33/OvHj/N+06jdeKP
 2Usefipo5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkZi0jw9nGlKZJyXOOS31W
 zgyJqpYOfVmeWtyVU7DpqJqsk+TF7Qz/3S/u/uHOviNieeWmtQvvPvf27I49N/et0fLlmq1ZB/Z L8wAA
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231127122259.2265164-11-ardb@google.com>
Subject: [PATCH v3 4/5] arm64: crypto: Remove conditional yield logic
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Some classes of crypto algorithms (such as skciphers or aeads) have
natural yield points, but SIMD based shashes yield the NEON unit
manually to avoid causing scheduling blackouts when operating on large
inputs.

This is no longer necessary now that kernel mode NEON runs with
preemption enabled, so remove this logic from the crypto assembler code,
along with the macro that implements the TIF_NEED_RESCHED check.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c       | 21 +++++---------
 arch/arm64/crypto/aes-modes.S      |  2 --
 arch/arm64/crypto/sha1-ce-core.S   |  6 ++--
 arch/arm64/crypto/sha1-ce-glue.c   | 19 ++++---------
 arch/arm64/crypto/sha2-ce-core.S   |  6 ++--
 arch/arm64/crypto/sha2-ce-glue.c   | 19 ++++---------
 arch/arm64/crypto/sha3-ce-core.S   |  6 ++--
 arch/arm64/crypto/sha3-ce-glue.c   | 14 ++++------
 arch/arm64/crypto/sha512-ce-core.S |  8 ++----
 arch/arm64/crypto/sha512-ce-glue.c | 16 ++++-------
 arch/arm64/include/asm/assembler.h | 29 --------------------
 arch/arm64/kernel/asm-offsets.c    |  4 ---
 12 files changed, 38 insertions(+), 112 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 162787c7aa86..c42c903b7d60 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -109,9 +109,9 @@ asmlinkage void aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
 				      int rounds, int blocks, u8 iv[],
 				      u32 const rk2[]);
 
-asmlinkage int aes_mac_update(u8 const in[], u32 const rk[], int rounds,
-			      int blocks, u8 dg[], int enc_before,
-			      int enc_after);
+asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+			       int blocks, u8 dg[], int enc_before,
+			       int enc_after);
 
 struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx key1;
@@ -880,17 +880,10 @@ static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
 	int rounds = 6 + ctx->key_length / 4;
 
 	if (crypto_simd_usable()) {
-		int rem;
-
-		do {
-			kernel_neon_begin();
-			rem = aes_mac_update(in, ctx->key_enc, rounds, blocks,
-					     dg, enc_before, enc_after);
-			kernel_neon_end();
-			in += (blocks - rem) * AES_BLOCK_SIZE;
-			blocks = rem;
-			enc_before = 0;
-		} while (blocks);
+		kernel_neon_begin();
+		aes_mac_update(in, ctx->key_enc, rounds, blocks, dg,
+			       enc_before, enc_after);
+		kernel_neon_end();
 	} else {
 		if (enc_before)
 			aes_encrypt(ctx, dg, dg);
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 0e834a2c062c..4d68853d0caf 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -842,7 +842,6 @@ AES_FUNC_START(aes_mac_update)
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
-	cond_yield	.Lmacout, x7, x8
 	b		.Lmacloop4x
 .Lmac1x:
 	add		w3, w3, #4
@@ -861,6 +860,5 @@ AES_FUNC_START(aes_mac_update)
 
 .Lmacout:
 	st1		{v0.16b}, [x4]			/* return dg */
-	mov		w0, w3
 	ret
 AES_FUNC_END(aes_mac_update)
diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 9b1f2d82a6fe..9e37bc09c3a5 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -62,8 +62,8 @@
 	.endm
 
 	/*
-	 * int __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-	 *			   int blocks)
+	 * void __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+	 *			    int blocks)
 	 */
 SYM_FUNC_START(__sha1_ce_transform)
 	/* load round constants */
@@ -121,7 +121,6 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	add		dgav.4s, dgav.4s, dg0v.4s
 
 	cbz		w2, 2f
-	cond_yield	3f, x5, x6
 	b		0b
 
 	/*
@@ -145,6 +144,5 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	/* store new state */
 3:	st1		{dgav.4s}, [x0]
 	str		dgb, [x0, #16]
-	mov		w0, w2
 	ret
 SYM_FUNC_END(__sha1_ce_transform)
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 1dd93e1fcb39..c1c5c5cb104b 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -29,23 +29,16 @@ struct sha1_ce_state {
 extern const u32 sha1_ce_offsetof_count;
 extern const u32 sha1_ce_offsetof_finalize;
 
-asmlinkage int __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-				   int blocks);
+asmlinkage void __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+				    int blocks);
 
 static void sha1_ce_transform(struct sha1_state *sst, u8 const *src,
 			      int blocks)
 {
-	while (blocks) {
-		int rem;
-
-		kernel_neon_begin();
-		rem = __sha1_ce_transform(container_of(sst,
-						       struct sha1_ce_state,
-						       sst), src, blocks);
-		kernel_neon_end();
-		src += (blocks - rem) * SHA1_BLOCK_SIZE;
-		blocks = rem;
-	}
+	kernel_neon_begin();
+	__sha1_ce_transform(container_of(sst, struct sha1_ce_state, sst), src,
+			    blocks);
+	kernel_neon_end();
 }
 
 const u32 sha1_ce_offsetof_count = offsetof(struct sha1_ce_state, sst.count);
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index fce84d88ddb2..112d772b29db 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -71,8 +71,8 @@
 	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
 
 	/*
-	 * int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
-	 *			     int blocks)
+	 * void __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
+	 *			      int blocks)
 	 */
 	.text
 SYM_FUNC_START(__sha256_ce_transform)
@@ -129,7 +129,6 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 
 	/* handled all input blocks? */
 	cbz		w2, 2f
-	cond_yield	3f, x5, x6
 	b		0b
 
 	/*
@@ -152,6 +151,5 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 
 	/* store new state */
 3:	st1		{dgav.4s, dgbv.4s}, [x0]
-	mov		w0, w2
 	ret
 SYM_FUNC_END(__sha256_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 0a44d2e7ee1f..f785a66a1de4 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -30,23 +30,16 @@ struct sha256_ce_state {
 extern const u32 sha256_ce_offsetof_count;
 extern const u32 sha256_ce_offsetof_finalize;
 
-asmlinkage int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
-				     int blocks);
+asmlinkage void __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
+				      int blocks);
 
 static void sha256_ce_transform(struct sha256_state *sst, u8 const *src,
 				int blocks)
 {
-	while (blocks) {
-		int rem;
-
-		kernel_neon_begin();
-		rem = __sha256_ce_transform(container_of(sst,
-							 struct sha256_ce_state,
-							 sst), src, blocks);
-		kernel_neon_end();
-		src += (blocks - rem) * SHA256_BLOCK_SIZE;
-		blocks = rem;
-	}
+	kernel_neon_begin();
+	__sha256_ce_transform(container_of(sst, struct sha256_ce_state, sst),
+			      src, blocks);
+	kernel_neon_end();
 }
 
 const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 9c77313f5a60..db64831ad35d 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -37,7 +37,7 @@
 	.endm
 
 	/*
-	 * int sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
+	 * void sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
 	 */
 	.text
 SYM_FUNC_START(sha3_ce_transform)
@@ -184,18 +184,16 @@ SYM_FUNC_START(sha3_ce_transform)
 	eor	 v0.16b,  v0.16b, v31.16b
 
 	cbnz	w8, 3b
-	cond_yield 4f, x8, x9
 	cbnz	w2, 0b
 
 	/* save state */
-4:	st1	{ v0.1d- v3.1d}, [x0], #32
+	st1	{ v0.1d- v3.1d}, [x0], #32
 	st1	{ v4.1d- v7.1d}, [x0], #32
 	st1	{ v8.1d-v11.1d}, [x0], #32
 	st1	{v12.1d-v15.1d}, [x0], #32
 	st1	{v16.1d-v19.1d}, [x0], #32
 	st1	{v20.1d-v23.1d}, [x0], #32
 	st1	{v24.1d}, [x0]
-	mov	w0, w2
 	ret
 SYM_FUNC_END(sha3_ce_transform)
 
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index 250e1377c481..d689cd2bf4cf 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -28,8 +28,8 @@ MODULE_ALIAS_CRYPTO("sha3-256");
 MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-512");
 
-asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
-				 int md_len);
+asmlinkage void sha3_ce_transform(u64 *st, const u8 *data, int blocks,
+				  int md_len);
 
 static int sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
@@ -59,15 +59,11 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 		blocks = len / sctx->rsiz;
 		len %= sctx->rsiz;
 
-		while (blocks) {
-			int rem;
-
+		if (blocks) {
 			kernel_neon_begin();
-			rem = sha3_ce_transform(sctx->st, data, blocks,
-						digest_size);
+			sha3_ce_transform(sctx->st, data, blocks, digest_size);
 			kernel_neon_end();
-			data += (blocks - rem) * sctx->rsiz;
-			blocks = rem;
+			data += blocks * sctx->rsiz;
 		}
 	}
 
diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index 91ef68b15fcc..96acc9295230 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -102,8 +102,8 @@
 	.endm
 
 	/*
-	 * int __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
-	 *			     int blocks)
+	 * void __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+	 *			      int blocks)
 	 */
 	.text
 SYM_FUNC_START(__sha512_ce_transform)
@@ -195,12 +195,10 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 	add		v10.2d, v10.2d, v2.2d
 	add		v11.2d, v11.2d, v3.2d
 
-	cond_yield	3f, x4, x5
 	/* handled all input blocks? */
 	cbnz		w2, 0b
 
 	/* store new state */
-3:	st1		{v8.2d-v11.2d}, [x0]
-	mov		w0, w2
+	st1		{v8.2d-v11.2d}, [x0]
 	ret
 SYM_FUNC_END(__sha512_ce_transform)
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index f3431fc62315..70eef74fe031 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -26,23 +26,17 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("sha384");
 MODULE_ALIAS_CRYPTO("sha512");
 
-asmlinkage int __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
-				     int blocks);
+asmlinkage void __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+				      int blocks);
 
 asmlinkage void sha512_block_data_order(u64 *digest, u8 const *src, int blocks);
 
 static void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 				int blocks)
 {
-	while (blocks) {
-		int rem;
-
-		kernel_neon_begin();
-		rem = __sha512_ce_transform(sst, src, blocks);
-		kernel_neon_end();
-		src += (blocks - rem) * SHA512_BLOCK_SIZE;
-		blocks = rem;
-	}
+	kernel_neon_begin();
+	__sha512_ce_transform(sst, src, blocks);
+	kernel_neon_end();
 }
 
 static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 376a980f2bad..f0da53a0388f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -759,35 +759,6 @@ alternative_endif
 	set_sctlr sctlr_el2, \reg
 .endm
 
-	/*
-	 * Check whether preempt/bh-disabled asm code should yield as soon as
-	 * it is able. This is the case if we are currently running in task
-	 * context, and either a softirq is pending, or the TIF_NEED_RESCHED
-	 * flag is set and re-enabling preemption a single time would result in
-	 * a preempt count of zero. (Note that the TIF_NEED_RESCHED flag is
-	 * stored negated in the top word of the thread_info::preempt_count
-	 * field)
-	 */
-	.macro		cond_yield, lbl:req, tmp:req, tmp2:req
-	get_current_task \tmp
-	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
-	/*
-	 * If we are serving a softirq, there is no point in yielding: the
-	 * softirq will not be preempted no matter what we do, so we should
-	 * run to completion as quickly as we can.
-	 */
-	tbnz		\tmp, #SOFTIRQ_SHIFT, .Lnoyield_\@
-#ifdef CONFIG_PREEMPTION
-	sub		\tmp, \tmp, #PREEMPT_DISABLE_OFFSET
-	cbz		\tmp, \lbl
-#endif
-	adr_l		\tmp, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
-	get_this_cpu_offset	\tmp2
-	ldr		w\tmp, [\tmp, \tmp2]
-	cbnz		w\tmp, \lbl	// yield on pending softirq in task context
-.Lnoyield_\@:
-	.endm
-
 /*
  * Branch Target Identifier (BTI)
  */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 5ff1942b04fc..fb9e9ef9b527 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -116,10 +116,6 @@ int main(void)
   DEFINE(DMA_TO_DEVICE,		DMA_TO_DEVICE);
   DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
   BLANK();
-  DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
-  DEFINE(SOFTIRQ_SHIFT, SOFTIRQ_SHIFT);
-  DEFINE(IRQ_CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
-  BLANK();
   DEFINE(CPU_BOOT_TASK,		offsetof(struct secondary_data, task));
   BLANK();
   DEFINE(FTR_OVR_VAL_OFFSET,	offsetof(struct arm64_ftr_override, val));
-- 
2.43.0.rc1.413.gea7ed67945-goog

