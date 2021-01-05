Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0130BC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A037722CE3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbhAEQtc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbhAEQtc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:49:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2663022CE3;
        Tue,  5 Jan 2021 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865330;
        bh=qHONsnWp7MgBci62RPGEelvXfoc8G3PN6tAVCK/49E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc96AXO++iN7sKctUFLX/pB4JBA5E6jZeEQrQgBep26bOiXDu8A9u7Z3steIODrFc
         ES6pCwK/EzgvuCFvjnaWZ0PyCAW2O00xrtIEDtBJLkKpZ4Q0FXknAMpHTMVmkjlOYU
         quEXgi0h2jq9rTtJqPDQ3YKGw7YfOsfdLquTN8SDZ30v5p80/sy0slf3vxrlnjFPWK
         lnXzE1mqsAp7jt0BieL6KyhdhKc4dXXSr18eZcpukNFKhZ+CbtID9s9Ce+8nfTK99N
         RPiniHdqHzkFLIw2RfKT1oEOZQ/NZ02OOPkvir2oRbt2KPNiDIHCsCs2VQ2WCdqWHI
         sCdISCDw4SFnw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 01/21] crypto: x86/camellia - switch to XTS template
Date:   Tue,  5 Jan 2021 17:47:49 +0100
Message-Id: <20210105164809.8594-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that the XTS template can wrap accelerated ECB modes, it can be
used to implement Camellia in XTS mode as well, which turns out to
be at least as fast, and sometimes even faster.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 181 -----------------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 207 --------------------
 arch/x86/crypto/camellia_aesni_avx2_glue.c   |  70 -------
 arch/x86/crypto/camellia_aesni_avx_glue.c    | 101 +---------
 arch/x86/include/asm/crypto/camellia.h       |  18 --
 crypto/Kconfig                               |   2 +-
 6 files changed, 2 insertions(+), 577 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index ecc0a9a905c4..471c34e6cac2 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -17,7 +17,6 @@
 
 #include <linux/linkage.h>
 #include <asm/frame.h>
-#include <asm/nospec-branch.h>
 
 #define CAMELLIA_TABLE_BYTE_LEN 272
 
@@ -593,10 +592,6 @@ SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
 
-/* For XTS mode IV generation */
-.Lxts_gf128mul_and_shl1_mask:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
-
 /*
  * pre-SubByte transform
  *
@@ -1111,179 +1106,3 @@ SYM_FUNC_START(camellia_ctr_16way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(camellia_ctr_16way)
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-.align 8
-SYM_FUNC_START_LOCAL(camellia_xts_crypt_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 *	%r8: index for input whitening key
-	 *	%r9: pointer to  __camellia_enc_blk16 or __camellia_dec_blk16
-	 */
-	FRAME_BEGIN
-
-	subq $(16 * 16), %rsp;
-	movq %rsp, %rax;
-
-	vmovdqa .Lxts_gf128mul_and_shl1_mask, %xmm14;
-
-	/* load IV */
-	vmovdqu (%rcx), %xmm0;
-	vpxor 0 * 16(%rdx), %xmm0, %xmm15;
-	vmovdqu %xmm15, 15 * 16(%rax);
-	vmovdqu %xmm0, 0 * 16(%rsi);
-
-	/* construct IVs */
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 1 * 16(%rdx), %xmm0, %xmm15;
-	vmovdqu %xmm15, 14 * 16(%rax);
-	vmovdqu %xmm0, 1 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 2 * 16(%rdx), %xmm0, %xmm13;
-	vmovdqu %xmm0, 2 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 3 * 16(%rdx), %xmm0, %xmm12;
-	vmovdqu %xmm0, 3 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 4 * 16(%rdx), %xmm0, %xmm11;
-	vmovdqu %xmm0, 4 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 5 * 16(%rdx), %xmm0, %xmm10;
-	vmovdqu %xmm0, 5 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 6 * 16(%rdx), %xmm0, %xmm9;
-	vmovdqu %xmm0, 6 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 7 * 16(%rdx), %xmm0, %xmm8;
-	vmovdqu %xmm0, 7 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 8 * 16(%rdx), %xmm0, %xmm7;
-	vmovdqu %xmm0, 8 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 9 * 16(%rdx), %xmm0, %xmm6;
-	vmovdqu %xmm0, 9 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 10 * 16(%rdx), %xmm0, %xmm5;
-	vmovdqu %xmm0, 10 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 11 * 16(%rdx), %xmm0, %xmm4;
-	vmovdqu %xmm0, 11 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 12 * 16(%rdx), %xmm0, %xmm3;
-	vmovdqu %xmm0, 12 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 13 * 16(%rdx), %xmm0, %xmm2;
-	vmovdqu %xmm0, 13 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 14 * 16(%rdx), %xmm0, %xmm1;
-	vmovdqu %xmm0, 14 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vpxor 15 * 16(%rdx), %xmm0, %xmm15;
-	vmovdqu %xmm15, 0 * 16(%rax);
-	vmovdqu %xmm0, 15 * 16(%rsi);
-
-	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
-	vmovdqu %xmm0, (%rcx);
-
-	/* inpack16_pre: */
-	vmovq (key_table)(CTX, %r8, 8), %xmm15;
-	vpshufb .Lpack_bswap, %xmm15, %xmm15;
-	vpxor 0 * 16(%rax), %xmm15, %xmm0;
-	vpxor %xmm1, %xmm15, %xmm1;
-	vpxor %xmm2, %xmm15, %xmm2;
-	vpxor %xmm3, %xmm15, %xmm3;
-	vpxor %xmm4, %xmm15, %xmm4;
-	vpxor %xmm5, %xmm15, %xmm5;
-	vpxor %xmm6, %xmm15, %xmm6;
-	vpxor %xmm7, %xmm15, %xmm7;
-	vpxor %xmm8, %xmm15, %xmm8;
-	vpxor %xmm9, %xmm15, %xmm9;
-	vpxor %xmm10, %xmm15, %xmm10;
-	vpxor %xmm11, %xmm15, %xmm11;
-	vpxor %xmm12, %xmm15, %xmm12;
-	vpxor %xmm13, %xmm15, %xmm13;
-	vpxor 14 * 16(%rax), %xmm15, %xmm14;
-	vpxor 15 * 16(%rax), %xmm15, %xmm15;
-
-	CALL_NOSPEC r9;
-
-	addq $(16 * 16), %rsp;
-
-	vpxor 0 * 16(%rsi), %xmm7, %xmm7;
-	vpxor 1 * 16(%rsi), %xmm6, %xmm6;
-	vpxor 2 * 16(%rsi), %xmm5, %xmm5;
-	vpxor 3 * 16(%rsi), %xmm4, %xmm4;
-	vpxor 4 * 16(%rsi), %xmm3, %xmm3;
-	vpxor 5 * 16(%rsi), %xmm2, %xmm2;
-	vpxor 6 * 16(%rsi), %xmm1, %xmm1;
-	vpxor 7 * 16(%rsi), %xmm0, %xmm0;
-	vpxor 8 * 16(%rsi), %xmm15, %xmm15;
-	vpxor 9 * 16(%rsi), %xmm14, %xmm14;
-	vpxor 10 * 16(%rsi), %xmm13, %xmm13;
-	vpxor 11 * 16(%rsi), %xmm12, %xmm12;
-	vpxor 12 * 16(%rsi), %xmm11, %xmm11;
-	vpxor 13 * 16(%rsi), %xmm10, %xmm10;
-	vpxor 14 * 16(%rsi), %xmm9, %xmm9;
-	vpxor 15 * 16(%rsi), %xmm8, %xmm8;
-	write_output(%xmm7, %xmm6, %xmm5, %xmm4, %xmm3, %xmm2, %xmm1, %xmm0,
-		     %xmm15, %xmm14, %xmm13, %xmm12, %xmm11, %xmm10, %xmm9,
-		     %xmm8, %rsi);
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(camellia_xts_crypt_16way)
-
-SYM_FUNC_START(camellia_xts_enc_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	xorl %r8d, %r8d; /* input whitening key, 0 for enc */
-
-	leaq __camellia_enc_blk16, %r9;
-
-	jmp camellia_xts_crypt_16way;
-SYM_FUNC_END(camellia_xts_enc_16way)
-
-SYM_FUNC_START(camellia_xts_dec_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-
-	cmpl $16, key_length(CTX);
-	movl $32, %r8d;
-	movl $24, %eax;
-	cmovel %eax, %r8d;  /* input whitening key, last for dec */
-
-	leaq __camellia_dec_blk16, %r9;
-
-	jmp camellia_xts_crypt_16way;
-SYM_FUNC_END(camellia_xts_dec_16way)
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 0907243c501c..9561dee52de0 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -7,7 +7,6 @@
 
 #include <linux/linkage.h>
 #include <asm/frame.h>
-#include <asm/nospec-branch.h>
 
 #define CAMELLIA_TABLE_BYTE_LEN 272
 
@@ -629,12 +628,6 @@ SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
 
-/* For XTS mode */
-.Lxts_gf128mul_and_shl1_mask_0:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
-.Lxts_gf128mul_and_shl1_mask_1:
-	.byte 0x0e, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
-
 /*
  * pre-SubByte transform
  *
@@ -1201,203 +1194,3 @@ SYM_FUNC_START(camellia_ctr_32way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(camellia_ctr_32way)
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-#define gf128mul_x2_ble(iv, mask1, mask2, tmp0, tmp1) \
-	vpsrad $31, iv, tmp0; \
-	vpaddq iv, iv, tmp1; \
-	vpsllq $2, iv, iv; \
-	vpshufd $0x13, tmp0, tmp0; \
-	vpsrad $31, tmp1, tmp1; \
-	vpand mask2, tmp0, tmp0; \
-	vpshufd $0x13, tmp1, tmp1; \
-	vpxor tmp0, iv, iv; \
-	vpand mask1, tmp1, tmp1; \
-	vpxor tmp1, iv, iv;
-
-.align 8
-SYM_FUNC_START_LOCAL(camellia_xts_crypt_32way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (32 blocks)
-	 *	%rdx: src (32 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 *	%r8: index for input whitening key
-	 *	%r9: pointer to  __camellia_enc_blk32 or __camellia_dec_blk32
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	subq $(16 * 32), %rsp;
-	movq %rsp, %rax;
-
-	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_0, %ymm12;
-
-	/* load IV and construct second IV */
-	vmovdqu (%rcx), %xmm0;
-	vmovdqa %xmm0, %xmm15;
-	gf128mul_x_ble(%xmm0, %xmm12, %xmm13);
-	vbroadcasti128 .Lxts_gf128mul_and_shl1_mask_1, %ymm13;
-	vinserti128 $1, %xmm0, %ymm15, %ymm0;
-	vpxor 0 * 32(%rdx), %ymm0, %ymm15;
-	vmovdqu %ymm15, 15 * 32(%rax);
-	vmovdqu %ymm0, 0 * 32(%rsi);
-
-	/* construct IVs */
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 1 * 32(%rdx), %ymm0, %ymm15;
-	vmovdqu %ymm15, 14 * 32(%rax);
-	vmovdqu %ymm0, 1 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 2 * 32(%rdx), %ymm0, %ymm15;
-	vmovdqu %ymm15, 13 * 32(%rax);
-	vmovdqu %ymm0, 2 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 3 * 32(%rdx), %ymm0, %ymm15;
-	vmovdqu %ymm15, 12 * 32(%rax);
-	vmovdqu %ymm0, 3 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 4 * 32(%rdx), %ymm0, %ymm11;
-	vmovdqu %ymm0, 4 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 5 * 32(%rdx), %ymm0, %ymm10;
-	vmovdqu %ymm0, 5 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 6 * 32(%rdx), %ymm0, %ymm9;
-	vmovdqu %ymm0, 6 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 7 * 32(%rdx), %ymm0, %ymm8;
-	vmovdqu %ymm0, 7 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 8 * 32(%rdx), %ymm0, %ymm7;
-	vmovdqu %ymm0, 8 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 9 * 32(%rdx), %ymm0, %ymm6;
-	vmovdqu %ymm0, 9 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 10 * 32(%rdx), %ymm0, %ymm5;
-	vmovdqu %ymm0, 10 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 11 * 32(%rdx), %ymm0, %ymm4;
-	vmovdqu %ymm0, 11 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 12 * 32(%rdx), %ymm0, %ymm3;
-	vmovdqu %ymm0, 12 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 13 * 32(%rdx), %ymm0, %ymm2;
-	vmovdqu %ymm0, 13 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 14 * 32(%rdx), %ymm0, %ymm1;
-	vmovdqu %ymm0, 14 * 32(%rsi);
-
-	gf128mul_x2_ble(%ymm0, %ymm12, %ymm13, %ymm14, %ymm15);
-	vpxor 15 * 32(%rdx), %ymm0, %ymm15;
-	vmovdqu %ymm15, 0 * 32(%rax);
-	vmovdqu %ymm0, 15 * 32(%rsi);
-
-	vextracti128 $1, %ymm0, %xmm0;
-	gf128mul_x_ble(%xmm0, %xmm12, %xmm15);
-	vmovdqu %xmm0, (%rcx);
-
-	/* inpack32_pre: */
-	vpbroadcastq (key_table)(CTX, %r8, 8), %ymm15;
-	vpshufb .Lpack_bswap, %ymm15, %ymm15;
-	vpxor 0 * 32(%rax), %ymm15, %ymm0;
-	vpxor %ymm1, %ymm15, %ymm1;
-	vpxor %ymm2, %ymm15, %ymm2;
-	vpxor %ymm3, %ymm15, %ymm3;
-	vpxor %ymm4, %ymm15, %ymm4;
-	vpxor %ymm5, %ymm15, %ymm5;
-	vpxor %ymm6, %ymm15, %ymm6;
-	vpxor %ymm7, %ymm15, %ymm7;
-	vpxor %ymm8, %ymm15, %ymm8;
-	vpxor %ymm9, %ymm15, %ymm9;
-	vpxor %ymm10, %ymm15, %ymm10;
-	vpxor %ymm11, %ymm15, %ymm11;
-	vpxor 12 * 32(%rax), %ymm15, %ymm12;
-	vpxor 13 * 32(%rax), %ymm15, %ymm13;
-	vpxor 14 * 32(%rax), %ymm15, %ymm14;
-	vpxor 15 * 32(%rax), %ymm15, %ymm15;
-
-	CALL_NOSPEC r9;
-
-	addq $(16 * 32), %rsp;
-
-	vpxor 0 * 32(%rsi), %ymm7, %ymm7;
-	vpxor 1 * 32(%rsi), %ymm6, %ymm6;
-	vpxor 2 * 32(%rsi), %ymm5, %ymm5;
-	vpxor 3 * 32(%rsi), %ymm4, %ymm4;
-	vpxor 4 * 32(%rsi), %ymm3, %ymm3;
-	vpxor 5 * 32(%rsi), %ymm2, %ymm2;
-	vpxor 6 * 32(%rsi), %ymm1, %ymm1;
-	vpxor 7 * 32(%rsi), %ymm0, %ymm0;
-	vpxor 8 * 32(%rsi), %ymm15, %ymm15;
-	vpxor 9 * 32(%rsi), %ymm14, %ymm14;
-	vpxor 10 * 32(%rsi), %ymm13, %ymm13;
-	vpxor 11 * 32(%rsi), %ymm12, %ymm12;
-	vpxor 12 * 32(%rsi), %ymm11, %ymm11;
-	vpxor 13 * 32(%rsi), %ymm10, %ymm10;
-	vpxor 14 * 32(%rsi), %ymm9, %ymm9;
-	vpxor 15 * 32(%rsi), %ymm8, %ymm8;
-	write_output(%ymm7, %ymm6, %ymm5, %ymm4, %ymm3, %ymm2, %ymm1, %ymm0,
-		     %ymm15, %ymm14, %ymm13, %ymm12, %ymm11, %ymm10, %ymm9,
-		     %ymm8, %rsi);
-
-	vzeroupper;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(camellia_xts_crypt_32way)
-
-SYM_FUNC_START(camellia_xts_enc_32way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (32 blocks)
-	 *	%rdx: src (32 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-
-	xorl %r8d, %r8d; /* input whitening key, 0 for enc */
-
-	leaq __camellia_enc_blk32, %r9;
-
-	jmp camellia_xts_crypt_32way;
-SYM_FUNC_END(camellia_xts_enc_32way)
-
-SYM_FUNC_START(camellia_xts_dec_32way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (32 blocks)
-	 *	%rdx: src (32 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-
-	cmpl $16, key_length(CTX);
-	movl $32, %r8d;
-	movl $24, %eax;
-	cmovel %eax, %r8d;  /* input whitening key, last for dec */
-
-	leaq __camellia_dec_blk32, %r9;
-
-	jmp camellia_xts_crypt_32way;
-SYM_FUNC_END(camellia_xts_dec_32way)
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index ccda647422d6..d956d0473668 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -9,7 +9,6 @@
 #include <asm/crypto/glue_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
-#include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -26,11 +25,6 @@ asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void camellia_ctr_32way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_32way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-asmlinkage void camellia_xts_dec_32way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -69,22 +63,6 @@ static const struct common_glue_ctx camellia_ctr = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_enc_xts = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_enc_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_enc_16way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = camellia_xts_enc }
-	} }
-};
-
 static const struct common_glue_ctx camellia_dec = {
 	.num_funcs = 4,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -123,22 +101,6 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_dec_xts = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_dec_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_dec_16way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = camellia_xts_dec }
-	} }
-};
-
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
@@ -170,24 +132,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return glue_ctr_req_128bit(&camellia_ctr, req);
 }
 
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
-}
-
 static struct skcipher_alg camellia_algs[] = {
 	{
 		.base.cra_name		= "__ecb(camellia)",
@@ -231,20 +175,6 @@ static struct skcipher_alg camellia_algs[] = {
 		.setkey			= camellia_setkey,
 		.encrypt		= ctr_crypt,
 		.decrypt		= ctr_crypt,
-	}, {
-		.base.cra_name		= "__xts(camellia)",
-		.base.cra_driver_name	= "__xts-camellia-aesni-avx2",
-		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct camellia_xts_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= 2 * CAMELLIA_MIN_KEY_SIZE,
-		.max_keysize		= 2 * CAMELLIA_MAX_KEY_SIZE,
-		.ivsize			= CAMELLIA_BLOCK_SIZE,
-		.setkey			= xts_camellia_setkey,
-		.encrypt		= xts_encrypt,
-		.decrypt		= xts_decrypt,
 	},
 };
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 4e5de6ef206e..44614f8a452c 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -9,7 +9,6 @@
 #include <asm/crypto/glue_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
-#include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -31,26 +30,6 @@ asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
-
-asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
-
-void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
-}
-EXPORT_SYMBOL_GPL(camellia_xts_enc);
-
-void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk);
-}
-EXPORT_SYMBOL_GPL(camellia_xts_dec);
-
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -83,19 +62,6 @@ static const struct common_glue_ctx camellia_ctr = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_enc_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_enc_16way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = camellia_xts_enc }
-	} }
-};
-
 static const struct common_glue_ctx camellia_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -128,19 +94,6 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_dec_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = camellia_xts_dec_16way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = camellia_xts_dec }
-	} }
-};
-
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
@@ -172,44 +125,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return glue_ctr_req_128bit(&camellia_ctr, req);
 }
 
-int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			unsigned int keylen)
-{
-	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err;
-
-	err = xts_verify_key(tfm, key, keylen);
-	if (err)
-		return err;
-
-	/* first half of xts-key is for crypt */
-	err = __camellia_setkey(&ctx->crypt_ctx, key, keylen / 2);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return __camellia_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
-}
-EXPORT_SYMBOL_GPL(xts_camellia_setkey);
-
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
-}
-
 static struct skcipher_alg camellia_algs[] = {
 	{
 		.base.cra_name		= "__ecb(camellia)",
@@ -253,21 +168,7 @@ static struct skcipher_alg camellia_algs[] = {
 		.setkey			= camellia_setkey,
 		.encrypt		= ctr_crypt,
 		.decrypt		= ctr_crypt,
-	}, {
-		.base.cra_name		= "__xts(camellia)",
-		.base.cra_driver_name	= "__xts-camellia-aesni",
-		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct camellia_xts_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= 2 * CAMELLIA_MIN_KEY_SIZE,
-		.max_keysize		= 2 * CAMELLIA_MAX_KEY_SIZE,
-		.ivsize			= CAMELLIA_BLOCK_SIZE,
-		.setkey			= xts_camellia_setkey,
-		.encrypt		= xts_encrypt,
-		.decrypt		= xts_decrypt,
-	},
+	}
 };
 
 static struct simd_skcipher_alg *camellia_simd_algs[ARRAY_SIZE(camellia_algs)];
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index f6d91861cb14..0e5f82adbaf9 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -19,18 +19,10 @@ struct camellia_ctx {
 	u32 key_length;
 };
 
-struct camellia_xts_ctx {
-	struct camellia_ctx tweak_ctx;
-	struct camellia_ctx crypt_ctx;
-};
-
 extern int __camellia_setkey(struct camellia_ctx *cctx,
 			     const unsigned char *key,
 			     unsigned int key_len);
 
-extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			       unsigned int keylen);
-
 /* regular block cipher functions */
 asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
 				   bool xor);
@@ -49,11 +41,6 @@ asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
-
 static inline void camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, false);
@@ -83,9 +70,4 @@ extern void camellia_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
 extern void camellia_crypt_ctr_2way(const void *ctx, u8 *dst, const u8 *src,
 				    le128 *iv);
 
-extern void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src,
-			     le128 *iv);
-extern void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src,
-			     le128 *iv);
-
 #endif /* ASM_X86_CAMELLIA_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index c48ca26e2169..b9ea4e262ebe 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1305,7 +1305,7 @@ config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
 	select CRYPTO_CAMELLIA_X86_64
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
-	select CRYPTO_XTS
+	imply CRYPTO_XTS
 	help
 	  Camellia cipher algorithm module (x86_64/AES-NI/AVX).
 
-- 
2.17.1

