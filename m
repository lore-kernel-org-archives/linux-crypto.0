From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -resend 06/27] x86: crypto, annotate local functions
Date: Thu, 10 May 2018 10:06:23 +0200
Message-ID: <20180510080644.19752-7-jslaby@suse.cz>
References: <20180510080644.19752-1-jslaby@suse.cz>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org
To: mingo@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180510080644.19752-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the newly added SYM_FUNC_START_LOCAL to annotate starts of all
functions which do not have ".globl" annotation, but their ends are
annotated by ENDPROC. This is needed to balance ENDPROC for tools that
are about to generate debuginfo.

To be symmetric, we also convert their ENDPROCs to the new SYM_FUNC_END.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: <linux-crypto@vger.kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S            | 49 ++++++++++++----------------
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 20 ++++++------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 20 ++++++------
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |  8 ++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |  8 ++---
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |  4 +--
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S  |  8 ++---
 arch/x86/crypto/serpent-avx2-asm_64.S        |  8 ++---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S  |  8 ++---
 9 files changed, 62 insertions(+), 71 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index e762ef417562..b482ac1a1fb3 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1763,7 +1763,7 @@ ENDPROC(aesni_gcm_finalize)
 
 .align 4
 _key_expansion_128:
-_key_expansion_256a:
+SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	pshufd $0b11111111, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
 	pxor %xmm4, %xmm0
@@ -1774,10 +1774,9 @@ _key_expansion_256a:
 	add $0x10, TKEYP
 	ret
 ENDPROC(_key_expansion_128)
-ENDPROC(_key_expansion_256a)
+SYM_FUNC_END(_key_expansion_256a)
 
-.align 4
-_key_expansion_192a:
+SYM_FUNC_START_LOCAL(_key_expansion_192a)
 	pshufd $0b01010101, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
 	pxor %xmm4, %xmm0
@@ -1799,10 +1798,9 @@ _key_expansion_192a:
 	movaps %xmm1, 0x10(TKEYP)
 	add $0x20, TKEYP
 	ret
-ENDPROC(_key_expansion_192a)
+SYM_FUNC_END(_key_expansion_192a)
 
-.align 4
-_key_expansion_192b:
+SYM_FUNC_START_LOCAL(_key_expansion_192b)
 	pshufd $0b01010101, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
 	pxor %xmm4, %xmm0
@@ -1819,10 +1817,9 @@ _key_expansion_192b:
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
 	ret
-ENDPROC(_key_expansion_192b)
+SYM_FUNC_END(_key_expansion_192b)
 
-.align 4
-_key_expansion_256b:
+SYM_FUNC_START_LOCAL(_key_expansion_256b)
 	pshufd $0b10101010, %xmm1, %xmm1
 	shufps $0b00010000, %xmm2, %xmm4
 	pxor %xmm4, %xmm2
@@ -1832,7 +1829,7 @@ _key_expansion_256b:
 	movaps %xmm2, (TKEYP)
 	add $0x10, TKEYP
 	ret
-ENDPROC(_key_expansion_256b)
+SYM_FUNC_END(_key_expansion_256b)
 
 /*
  * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
@@ -1985,8 +1982,7 @@ ENDPROC(aesni_enc)
  *	KEY
  *	TKEYP (T1)
  */
-.align 4
-_aesni_enc1:
+SYM_FUNC_START_LOCAL(_aesni_enc1)
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
 	pxor KEY, STATE		# round 0
@@ -2029,7 +2025,7 @@ _aesni_enc1:
 	movaps 0x70(TKEYP), KEY
 	AESENCLAST KEY STATE
 	ret
-ENDPROC(_aesni_enc1)
+SYM_FUNC_END(_aesni_enc1)
 
 /*
  * _aesni_enc4:	internal ABI
@@ -2049,8 +2045,7 @@ ENDPROC(_aesni_enc1)
  *	KEY
  *	TKEYP (T1)
  */
-.align 4
-_aesni_enc4:
+SYM_FUNC_START_LOCAL(_aesni_enc4)
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
 	pxor KEY, STATE1		# round 0
@@ -2138,7 +2133,7 @@ _aesni_enc4:
 	AESENCLAST KEY STATE3
 	AESENCLAST KEY STATE4
 	ret
-ENDPROC(_aesni_enc4)
+SYM_FUNC_END(_aesni_enc4)
 
 /*
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
@@ -2177,8 +2172,7 @@ ENDPROC(aesni_dec)
  *	KEY
  *	TKEYP (T1)
  */
-.align 4
-_aesni_dec1:
+SYM_FUNC_START_LOCAL(_aesni_dec1)
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
 	pxor KEY, STATE		# round 0
@@ -2221,7 +2215,7 @@ _aesni_dec1:
 	movaps 0x70(TKEYP), KEY
 	AESDECLAST KEY STATE
 	ret
-ENDPROC(_aesni_dec1)
+SYM_FUNC_END(_aesni_dec1)
 
 /*
  * _aesni_dec4:	internal ABI
@@ -2241,8 +2235,7 @@ ENDPROC(_aesni_dec1)
  *	KEY
  *	TKEYP (T1)
  */
-.align 4
-_aesni_dec4:
+SYM_FUNC_START_LOCAL(_aesni_dec4)
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
 	pxor KEY, STATE1		# round 0
@@ -2330,7 +2323,7 @@ _aesni_dec4:
 	AESDECLAST KEY STATE3
 	AESDECLAST KEY STATE4
 	ret
-ENDPROC(_aesni_dec4)
+SYM_FUNC_END(_aesni_dec4)
 
 /*
  * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2608,8 +2601,7 @@ ENDPROC(aesni_cbc_dec)
  *	INC:	== 1, in little endian
  *	BSWAP_MASK == endian swapping mask
  */
-.align 4
-_aesni_inc_init:
+SYM_FUNC_START_LOCAL(_aesni_inc_init)
 	movaps .Lbswap_mask, BSWAP_MASK
 	movaps IV, CTR
 	PSHUFB_XMM BSWAP_MASK CTR
@@ -2617,7 +2609,7 @@ _aesni_inc_init:
 	MOVQ_R64_XMM TCTR_LOW INC
 	MOVQ_R64_XMM CTR TCTR_LOW
 	ret
-ENDPROC(_aesni_inc_init)
+SYM_FUNC_END(_aesni_inc_init)
 
 /*
  * _aesni_inc:		internal ABI
@@ -2634,8 +2626,7 @@ ENDPROC(_aesni_inc_init)
  *	CTR:	== output IV, in little endian
  *	TCTR_LOW: == lower qword of CTR
  */
-.align 4
-_aesni_inc:
+SYM_FUNC_START_LOCAL(_aesni_inc)
 	paddq INC, CTR
 	add $1, TCTR_LOW
 	jnc .Linc_low
@@ -2646,7 +2637,7 @@ _aesni_inc:
 	movaps CTR, IV
 	PSHUFB_XMM BSWAP_MASK IV
 	ret
-ENDPROC(_aesni_inc)
+SYM_FUNC_END(_aesni_inc)
 
 /*
  * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index a14af6eb09cb..f4408ca55fdb 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -189,20 +189,20 @@
  * larger and would only be 0.5% faster (on sandy-bridge).
  */
 .align 8
-roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd:
+SYM_FUNC_START_LOCAL(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 	roundsm16(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		  %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15,
 		  %rcx, (%r9));
 	ret;
-ENDPROC(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
+SYM_FUNC_END(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 
 .align 8
-roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab:
+SYM_FUNC_START_LOCAL(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	roundsm16(%xmm4, %xmm5, %xmm6, %xmm7, %xmm0, %xmm1, %xmm2, %xmm3,
 		  %xmm12, %xmm13, %xmm14, %xmm15, %xmm8, %xmm9, %xmm10, %xmm11,
 		  %rax, (%r9));
 	ret;
-ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
+SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 
 /*
  * IN/OUT:
@@ -722,7 +722,7 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 .text
 
 .align 8
-__camellia_enc_blk16:
+SYM_FUNC_START_LOCAL(__camellia_enc_blk16)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rax: temporary storage, 256 bytes
@@ -806,10 +806,10 @@ __camellia_enc_blk16:
 		     %xmm15, %rax, %rcx, 24);
 
 	jmp .Lenc_done;
-ENDPROC(__camellia_enc_blk16)
+SYM_FUNC_END(__camellia_enc_blk16)
 
 .align 8
-__camellia_dec_blk16:
+SYM_FUNC_START_LOCAL(__camellia_dec_blk16)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rax: temporary storage, 256 bytes
@@ -891,7 +891,7 @@ __camellia_dec_blk16:
 	      ((key_table + (24) * 8) + 4)(CTX));
 
 	jmp .Ldec_max24;
-ENDPROC(__camellia_dec_blk16)
+SYM_FUNC_END(__camellia_dec_blk16)
 
 ENTRY(camellia_ecb_enc_16way)
 	/* input:
@@ -1120,7 +1120,7 @@ ENDPROC(camellia_ctr_16way)
 	vpxor tmp, iv, iv;
 
 .align 8
-camellia_xts_crypt_16way:
+SYM_FUNC_START_LOCAL(camellia_xts_crypt_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -1254,7 +1254,7 @@ camellia_xts_crypt_16way:
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_xts_crypt_16way)
+SYM_FUNC_END(camellia_xts_crypt_16way)
 
 ENTRY(camellia_xts_enc_16way)
 	/* input:
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index b66bbfa62f50..916a3e2b8ea4 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -228,20 +228,20 @@
  * larger and would only marginally faster.
  */
 .align 8
-roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd:
+SYM_FUNC_START_LOCAL(roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 	roundsm32(%ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %ymm7,
 		  %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14, %ymm15,
 		  %rcx, (%r9));
 	ret;
-ENDPROC(roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
+SYM_FUNC_END(roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 
 .align 8
-roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab:
+SYM_FUNC_START_LOCAL(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	roundsm32(%ymm4, %ymm5, %ymm6, %ymm7, %ymm0, %ymm1, %ymm2, %ymm3,
 		  %ymm12, %ymm13, %ymm14, %ymm15, %ymm8, %ymm9, %ymm10, %ymm11,
 		  %rax, (%r9));
 	ret;
-ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
+SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 
 /*
  * IN/OUT:
@@ -765,7 +765,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 .text
 
 .align 8
-__camellia_enc_blk32:
+SYM_FUNC_START_LOCAL(__camellia_enc_blk32)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rax: temporary storage, 512 bytes
@@ -849,10 +849,10 @@ __camellia_enc_blk32:
 		     %ymm15, %rax, %rcx, 24);
 
 	jmp .Lenc_done;
-ENDPROC(__camellia_enc_blk32)
+SYM_FUNC_END(__camellia_enc_blk32)
 
 .align 8
-__camellia_dec_blk32:
+SYM_FUNC_START_LOCAL(__camellia_dec_blk32)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rax: temporary storage, 512 bytes
@@ -934,7 +934,7 @@ __camellia_dec_blk32:
 	      ((key_table + (24) * 8) + 4)(CTX));
 
 	jmp .Ldec_max24;
-ENDPROC(__camellia_dec_blk32)
+SYM_FUNC_END(__camellia_dec_blk32)
 
 ENTRY(camellia_ecb_enc_32way)
 	/* input:
@@ -1227,7 +1227,7 @@ ENDPROC(camellia_ctr_32way)
 	vpxor tmp1, iv, iv;
 
 .align 8
-camellia_xts_crypt_32way:
+SYM_FUNC_START_LOCAL(camellia_xts_crypt_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -1372,7 +1372,7 @@ camellia_xts_crypt_32way:
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_xts_crypt_32way)
+SYM_FUNC_END(camellia_xts_crypt_32way)
 
 ENTRY(camellia_xts_enc_32way)
 	/* input:
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 86107c961bb4..b26df120413c 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -224,7 +224,7 @@
 .text
 
 .align 16
-__cast5_enc_blk16:
+SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 	/* input:
 	 *	%rdi: ctx
 	 *	RL1: blocks 1 and 2
@@ -295,10 +295,10 @@ __cast5_enc_blk16:
 	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
 	ret;
-ENDPROC(__cast5_enc_blk16)
+SYM_FUNC_END(__cast5_enc_blk16)
 
 .align 16
-__cast5_dec_blk16:
+SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 	/* input:
 	 *	%rdi: ctx
 	 *	RL1: encrypted blocks 1 and 2
@@ -372,7 +372,7 @@ __cast5_dec_blk16:
 .L__skip_dec:
 	vpsrldq $4, RKR, RKR;
 	jmp .L__dec_tail;
-ENDPROC(__cast5_dec_blk16)
+SYM_FUNC_END(__cast5_dec_blk16)
 
 ENTRY(cast5_ecb_enc_16way)
 	/* input:
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 7f30b6f0d72c..0a68e42a00f9 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -262,7 +262,7 @@
 .text
 
 .align 8
-__cast6_enc_blk8:
+SYM_FUNC_START_LOCAL(__cast6_enc_blk8)
 	/* input:
 	 *	%rdi: ctx
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
@@ -307,10 +307,10 @@ __cast6_enc_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	ret;
-ENDPROC(__cast6_enc_blk8)
+SYM_FUNC_END(__cast6_enc_blk8)
 
 .align 8
-__cast6_dec_blk8:
+SYM_FUNC_START_LOCAL(__cast6_dec_blk8)
 	/* input:
 	 *	%rdi: ctx
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
@@ -354,7 +354,7 @@ __cast6_dec_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	ret;
-ENDPROC(__cast6_dec_blk8)
+SYM_FUNC_END(__cast6_dec_blk8)
 
 ENTRY(cast6_ecb_enc_8way)
 	/* input:
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index f94375a8dcd1..c3db86842578 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -47,7 +47,7 @@
  *	T2
  *	T3
  */
-__clmul_gf128mul_ble:
+SYM_FUNC_START_LOCAL(__clmul_gf128mul_ble)
 	movaps DATA, T1
 	pshufd $0b01001110, DATA, T2
 	pshufd $0b01001110, SHASH, T3
@@ -90,7 +90,7 @@ __clmul_gf128mul_ble:
 	pxor T2, T1
 	pxor T1, DATA
 	ret
-ENDPROC(__clmul_gf128mul_ble)
+SYM_FUNC_END(__clmul_gf128mul_ble)
 
 /* void clmul_ghash_mul(char *dst, const u128 *shash) */
 ENTRY(clmul_ghash_mul)
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 2925077f8c6a..c2d4a1fc9ee8 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -570,7 +570,7 @@
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
 .align 8
-__serpent_enc_blk8_avx:
+SYM_FUNC_START_LOCAL(__serpent_enc_blk8_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
@@ -621,10 +621,10 @@ __serpent_enc_blk8_avx:
 	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(__serpent_enc_blk8_avx)
+SYM_FUNC_END(__serpent_enc_blk8_avx)
 
 .align 8
-__serpent_dec_blk8_avx:
+SYM_FUNC_START_LOCAL(__serpent_dec_blk8_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: encrypted blocks
@@ -675,7 +675,7 @@ __serpent_dec_blk8_avx:
 	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(__serpent_dec_blk8_avx)
+SYM_FUNC_END(__serpent_dec_blk8_avx)
 
 ENTRY(serpent_ecb_enc_8way_avx)
 	/* input:
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index d67888f2a52a..52c527ce4b18 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -566,7 +566,7 @@
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
 .align 8
-__serpent_enc_blk16:
+SYM_FUNC_START_LOCAL(__serpent_enc_blk16)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: plaintext
@@ -617,10 +617,10 @@ __serpent_enc_blk16:
 	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(__serpent_enc_blk16)
+SYM_FUNC_END(__serpent_enc_blk16)
 
 .align 8
-__serpent_dec_blk16:
+SYM_FUNC_START_LOCAL(__serpent_dec_blk16)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: ciphertext
@@ -671,7 +671,7 @@ __serpent_dec_blk16:
 	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(__serpent_dec_blk16)
+SYM_FUNC_END(__serpent_dec_blk16)
 
 ENTRY(serpent_ecb_enc_16way)
 	/* input:
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 73b471da3622..96ddfda4d7b2 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -249,7 +249,7 @@
 	vpxor		x3, wkey, x3;
 
 .align 8
-__twofish_enc_blk8:
+SYM_FUNC_START_LOCAL(__twofish_enc_blk8)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: blocks
@@ -288,10 +288,10 @@ __twofish_enc_blk8:
 	outunpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	ret;
-ENDPROC(__twofish_enc_blk8)
+SYM_FUNC_END(__twofish_enc_blk8)
 
 .align 8
-__twofish_dec_blk8:
+SYM_FUNC_START_LOCAL(__twofish_dec_blk8)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2: encrypted blocks
@@ -328,7 +328,7 @@ __twofish_dec_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 
 	ret;
-ENDPROC(__twofish_dec_blk8)
+SYM_FUNC_END(__twofish_dec_blk8)
 
 ENTRY(twofish_ecb_enc_8way)
 	/* input:
-- 
2.16.3
