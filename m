Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D43C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Nov 2022 16:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiKMQ5X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 11:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiKMQ5S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 11:57:18 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFCA11C16
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 08:57:15 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 62so5897pgb.13
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 08:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+3ngscH9K444dQPXJnc/ap0Pi5L/dadgnJaOvY6tDjI=;
        b=bo56/57nwy7NGAHF/E/Btoe0TbTkWMZ6R2YkAXr7WqlW3HmJ7FsdU9PC399+CEtQyA
         dc2umtx/PhiNcxZpn+cuHetOLZMz5b3i0mhoNDI/nqst6JW4enqenBktJc0Sk1gJUveP
         qLcYNgfhNHJ3J0QPEMRgS2aYD4iYuH3/WHH/Opa+FB0zxb/5WsAOkkLwlbKyrnl6uE/t
         G8JtHUsi85OG3/RQpUNjFopccMgxfrVPQMBAyLuxahpz01xuNUqlXh67udxMYyxmmBRL
         ZUlylvGuM6lvPOKSf3hWSvJWMujrRF10y9cIYPZzlqTsDZcFnEx+AvyYfnvcVvu6QvpP
         pltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+3ngscH9K444dQPXJnc/ap0Pi5L/dadgnJaOvY6tDjI=;
        b=mop6/nv1Z4SbBcv0vlKH/IRAUm9ptn/3/LUp1/HbV2BZDA7yR5LXiL1TnVcb1GbGD3
         KhyXipfDFTudUqNDnSL7a+ZRN2ddN/A5RJCiPWsp+S6hRzCd5UeW5AI+Kdme+jqMaGc9
         StLebE6ZeM8LL6Q754MIkc/wheWFY/G1yn0rD1pUdy2Mn1Y/BYpdkj17AvusuDap6waT
         1Wr92ToGWhTwwias/xTah7w99IOl82EP5gst14lYsQv8gPFnkxWnl5bL3YO5ovShhP9Z
         yyVytItE6X4PI9WyMArOshFxZq/UYF1kEZi9ekxn5kjFl8/86t6hPtIgtqVZkW999miU
         G97g==
X-Gm-Message-State: ANoB5pkLyWpBi3t8Por5roOfzNDiJLBUqeE7cWGwQ1BgsGlZ9aEslGx9
        BbY/wxnmPbfhei9ihiV80m7EQ0TrdgOQdg==
X-Google-Smtp-Source: AA0mqf6z+EBDKOEYTJTLPV0ynRG25h7xLA/Cli8ovrdjQR3j57LeNrpKVtyCAXJAdGigu314YOJmBw==
X-Received: by 2002:a63:3343:0:b0:46f:c182:b658 with SMTP id z64-20020a633343000000b0046fc182b658mr8629401pgz.182.1668358633922;
        Sun, 13 Nov 2022 08:57:13 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id qi18-20020a17090b275200b001f8c532b93dsm4910477pjb.15.2022.11.13.08.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:57:13 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v4 4/4] crypto: aria: implement aria-avx512
Date:   Sun, 13 Nov 2022 16:56:45 +0000
Message-Id: <20221113165645.4652-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221113165645.4652-1-ap420073@gmail.com>
References: <20221113165645.4652-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

aria-avx512 implementation uses AVX512 and GFNI.
It supports 64way parallel processing.
So, byteslicing code is changed to support 64way parallel.
And it exports some aria-avx2 functions such as encrypt() and decrypt().

AVX and AVX2 have 16 registers.
They should use memory to store/load state because of lack of registers.
But AVX512 supports 32 registers.
So, it doesn't require store/load in the s-box layer.
It means that it can reduce overhead of store/load in the s-box layer.
Also code become much simpler.

Benchmark with modprobe tcrypt mode=610 num_mb=8192, i3-12100:

ARIA-AVX512(128bit and 256bit)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx512) encryption
tcrypt: 1 operation in 1504 cycles (1024 bytes)
tcrypt: 1 operation in 4595 cycles (4096 bytes)
tcrypt: 1 operation in 1763 cycles (1024 bytes)
tcrypt: 1 operation in 5540 cycles (4096 bytes)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx512) decryption
tcrypt: 1 operation in 1502 cycles (1024 bytes)
tcrypt: 1 operation in 4615 cycles (4096 bytes)
tcrypt: 1 operation in 1759 cycles (1024 bytes)
tcrypt: 1 operation in 5554 cycles (4096 bytes)

ARIA-AVX2 with GFNI(128bit and 256bit)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx2) encryption
tcrypt: 1 operation in 2003 cycles (1024 bytes)
tcrypt: 1 operation in 5867 cycles (4096 bytes)
tcrypt: 1 operation in 2358 cycles (1024 bytes)
tcrypt: 1 operation in 7295 cycles (4096 bytes)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx2) decryption
tcrypt: 1 operation in 2004 cycles (1024 bytes)
tcrypt: 1 operation in 5956 cycles (4096 bytes)
tcrypt: 1 operation in 2409 cycles (1024 bytes)
tcrypt: 1 operation in 7564 cycles (4096 bytes)

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4:
 - Add aria_avx512_request_ctx for keystream array.

v3:
 - Use ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds defines.

v2:
 - Add new "add keystream array into struct aria_ctx" patch.
 - Use keystream array in the aria_ctx instead of stack memory

 arch/x86/crypto/Kconfig                   |   19 +
 arch/x86/crypto/Makefile                  |    3 +
 arch/x86/crypto/aria-avx.h                |    8 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1019 +++++++++++++++++++++
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  249 +++++
 5 files changed, 1298 insertions(+)
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 3837ba8b78c5..688e848f740d 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -323,6 +323,25 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
 	  Processes 32 blocks in parallel.
 
+config CRYPTO_ARIA_GFNI_AVX512_X86_64
+	tristate "Ciphers: ARIA with modes: ECB, CTR (AVX512/GFNI)"
+	depends on X86 && 64BIT
+	select CRYPTO_SKCIPHER
+	select CRYPTO_SIMD
+	select CRYPTO_ALGAPI
+	select CRYPTO_ARIA
+	select CRYPTO_ARIA_AESNI_AVX_X86_64
+	select CRYPTO_ARIA_AESNI_AVX2_X86_64
+	help
+	  Length-preserving cipher: ARIA cipher algorithms
+	  (RFC 5794) with ECB and CTR modes
+
+	  Architecture: x86_64 using:
+	  - AVX512 (Advanced Vector Extensions)
+	  - GFNI (Galois Field New Instructions)
+
+	  Processes 64 blocks in parallel.
+
 config CRYPTO_CHACHA20_X86_64
 	tristate "Ciphers: ChaCha20, XChaCha20, XChaCha12 (SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 5a349c7a8127..1844925f1f4a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -106,6 +106,9 @@ aria-aesni-avx-x86_64-y := aria-aesni-avx-asm_64.o aria_aesni_avx_glue.o
 obj-$(CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64) += aria-aesni-avx2-x86_64.o
 aria-aesni-avx2-x86_64-y := aria-aesni-avx2-asm_64.o aria_aesni_avx2_glue.o
 
+obj-$(CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64) += aria-gfni-avx512-x86_64.o
+aria-gfni-avx512-x86_64-y := aria-gfni-avx512-asm_64.o aria_gfni_avx512_glue.o
+
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $< > $@
 $(obj)/%.S: $(src)/%.pl FORCE
diff --git a/arch/x86/crypto/aria-avx.h b/arch/x86/crypto/aria-avx.h
index b997c4888fb7..3eeb14d1d197 100644
--- a/arch/x86/crypto/aria-avx.h
+++ b/arch/x86/crypto/aria-avx.h
@@ -10,6 +10,9 @@
 #define ARIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 #define ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 32)
 
+#define ARIA_GFNI_AVX512_PARALLEL_BLOCKS 64
+#define ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 64)
+
 asmlinkage void aria_aesni_avx_encrypt_16way(const void *ctx, u8 *dst,
 					     const u8 *src);
 asmlinkage void aria_aesni_avx_decrypt_16way(const void *ctx, u8 *dst,
@@ -49,6 +52,11 @@ struct aria_avx_ops {
 	void (*aria_decrypt_32way)(const void *ctx, u8 *dst, const u8 *src);
 	void (*aria_ctr_crypt_32way)(const void *ctx, u8 *dst, const u8 *src,
 				     u8 *keystream, u8 *iv);
+	void (*aria_encrypt_64way)(const void *ctx, u8 *dst, const u8 *src);
+	void (*aria_decrypt_64way)(const void *ctx, u8 *dst, const u8 *src);
+	void (*aria_ctr_crypt_64way)(const void *ctx, u8 *dst, const u8 *src,
+				     u8 *keystream, u8 *iv);
+
 
 };
 #endif
diff --git a/arch/x86/crypto/aria-gfni-avx512-asm_64.S b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
new file mode 100644
index 000000000000..bd37de32e823
--- /dev/null
+++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
@@ -0,0 +1,1019 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARIA Cipher 64-way parallel algorithm (AVX512)
+ *
+ * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+#include <asm/asm-offsets.h>
+
+/* register macros */
+#define CTX %rdi
+
+
+#define BV8(a0, a1, a2, a3, a4, a5, a6, a7)		\
+	( (((a0) & 1) << 0) |				\
+	  (((a1) & 1) << 1) |				\
+	  (((a2) & 1) << 2) |				\
+	  (((a3) & 1) << 3) |				\
+	  (((a4) & 1) << 4) |				\
+	  (((a5) & 1) << 5) |				\
+	  (((a6) & 1) << 6) |				\
+	  (((a7) & 1) << 7) )
+
+#define BM8X8(l0, l1, l2, l3, l4, l5, l6, l7)		\
+	( ((l7) << (0 * 8)) |				\
+	  ((l6) << (1 * 8)) |				\
+	  ((l5) << (2 * 8)) |				\
+	  ((l4) << (3 * 8)) |				\
+	  ((l3) << (4 * 8)) |				\
+	  ((l2) << (5 * 8)) |				\
+	  ((l1) << (6 * 8)) |				\
+	  ((l0) << (7 * 8)) )
+
+#define add_le128(out, in, lo_counter, hi_counter1)	\
+	vpaddq lo_counter, in, out;			\
+	vpcmpuq $1, lo_counter, out, %k1;		\
+	kaddb %k1, %k1, %k1;				\
+	vpaddq hi_counter1, out, out{%k1};
+
+#define filter_8bit(x, lo_t, hi_t, mask4bit, tmp0)	\
+	vpandq x, mask4bit, tmp0;			\
+	vpandqn x, mask4bit, x;				\
+	vpsrld $4, x, x;				\
+							\
+	vpshufb tmp0, lo_t, tmp0;			\
+	vpshufb x, hi_t, x;				\
+	vpxorq tmp0, x, x;
+
+#define transpose_4x4(x0, x1, x2, x3, t1, t2)		\
+	vpunpckhdq x1, x0, t2;				\
+	vpunpckldq x1, x0, x0;				\
+							\
+	vpunpckldq x3, x2, t1;				\
+	vpunpckhdq x3, x2, x2;				\
+							\
+	vpunpckhqdq t1, x0, x1;				\
+	vpunpcklqdq t1, x0, x0;				\
+							\
+	vpunpckhqdq x2, t2, x3;				\
+	vpunpcklqdq x2, t2, x2;
+
+#define byteslice_16x16b(a0, b0, c0, d0,		\
+			 a1, b1, c1, d1,		\
+			 a2, b2, c2, d2,		\
+			 a3, b3, c3, d3,		\
+			 st0, st1)			\
+	vmovdqu64 d2, st0;				\
+	vmovdqu64 d3, st1;				\
+	transpose_4x4(a0, a1, a2, a3, d2, d3);		\
+	transpose_4x4(b0, b1, b2, b3, d2, d3);		\
+	vmovdqu64 st0, d2;				\
+	vmovdqu64 st1, d3;				\
+							\
+	vmovdqu64 a0, st0;				\
+	vmovdqu64 a1, st1;				\
+	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
+	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
+							\
+	vbroadcasti64x2 .Lshufb_16x16b, a0;		\
+	vmovdqu64 st1, a1;				\
+	vpshufb a0, a2, a2;				\
+	vpshufb a0, a3, a3;				\
+	vpshufb a0, b0, b0;				\
+	vpshufb a0, b1, b1;				\
+	vpshufb a0, b2, b2;				\
+	vpshufb a0, b3, b3;				\
+	vpshufb a0, a1, a1;				\
+	vpshufb a0, c0, c0;				\
+	vpshufb a0, c1, c1;				\
+	vpshufb a0, c2, c2;				\
+	vpshufb a0, c3, c3;				\
+	vpshufb a0, d0, d0;				\
+	vpshufb a0, d1, d1;				\
+	vpshufb a0, d2, d2;				\
+	vpshufb a0, d3, d3;				\
+	vmovdqu64 d3, st1;				\
+	vmovdqu64 st0, d3;				\
+	vpshufb a0, d3, a0;				\
+	vmovdqu64 d2, st0;				\
+							\
+	transpose_4x4(a0, b0, c0, d0, d2, d3);		\
+	transpose_4x4(a1, b1, c1, d1, d2, d3);		\
+	vmovdqu64 st0, d2;				\
+	vmovdqu64 st1, d3;				\
+							\
+	vmovdqu64 b0, st0;				\
+	vmovdqu64 b1, st1;				\
+	transpose_4x4(a2, b2, c2, d2, b0, b1);		\
+	transpose_4x4(a3, b3, c3, d3, b0, b1);		\
+	vmovdqu64 st0, b0;				\
+	vmovdqu64 st1, b1;				\
+	/* does not adjust output bytes inside vectors */
+
+#define debyteslice_16x16b(a0, b0, c0, d0,		\
+			   a1, b1, c1, d1,		\
+			   a2, b2, c2, d2,		\
+			   a3, b3, c3, d3,		\
+			   st0, st1)			\
+	vmovdqu64 d2, st0;				\
+	vmovdqu64 d3, st1;				\
+	transpose_4x4(a0, a1, a2, a3, d2, d3);		\
+	transpose_4x4(b0, b1, b2, b3, d2, d3);		\
+	vmovdqu64 st0, d2;				\
+	vmovdqu64 st1, d3;				\
+							\
+	vmovdqu64 a0, st0;				\
+	vmovdqu64 a1, st1;				\
+	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
+	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
+							\
+	vbroadcasti64x2 .Lshufb_16x16b, a0;		\
+	vmovdqu64 st1, a1;				\
+	vpshufb a0, a2, a2;				\
+	vpshufb a0, a3, a3;				\
+	vpshufb a0, b0, b0;				\
+	vpshufb a0, b1, b1;				\
+	vpshufb a0, b2, b2;				\
+	vpshufb a0, b3, b3;				\
+	vpshufb a0, a1, a1;				\
+	vpshufb a0, c0, c0;				\
+	vpshufb a0, c1, c1;				\
+	vpshufb a0, c2, c2;				\
+	vpshufb a0, c3, c3;				\
+	vpshufb a0, d0, d0;				\
+	vpshufb a0, d1, d1;				\
+	vpshufb a0, d2, d2;				\
+	vpshufb a0, d3, d3;				\
+	vmovdqu64 d3, st1;				\
+	vmovdqu64 st0, d3;				\
+	vpshufb a0, d3, a0;				\
+	vmovdqu64 d2, st0;				\
+							\
+	transpose_4x4(c0, d0, a0, b0, d2, d3);		\
+	transpose_4x4(c1, d1, a1, b1, d2, d3);		\
+	vmovdqu64 st0, d2;				\
+	vmovdqu64 st1, d3;				\
+							\
+	vmovdqu64 b0, st0;				\
+	vmovdqu64 b1, st1;				\
+	transpose_4x4(c2, d2, a2, b2, b0, b1);		\
+	transpose_4x4(c3, d3, a3, b3, b0, b1);		\
+	vmovdqu64 st0, b0;				\
+	vmovdqu64 st1, b1;				\
+	/* does not adjust output bytes inside vectors */
+
+/* load blocks to registers and apply pre-whitening */
+#define inpack16_pre(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     rio)				\
+	vmovdqu64 (0 * 64)(rio), x0;			\
+	vmovdqu64 (1 * 64)(rio), x1;			\
+	vmovdqu64 (2 * 64)(rio), x2;			\
+	vmovdqu64 (3 * 64)(rio), x3;			\
+	vmovdqu64 (4 * 64)(rio), x4;			\
+	vmovdqu64 (5 * 64)(rio), x5;			\
+	vmovdqu64 (6 * 64)(rio), x6;			\
+	vmovdqu64 (7 * 64)(rio), x7;			\
+	vmovdqu64 (8 * 64)(rio), y0;			\
+	vmovdqu64 (9 * 64)(rio), y1;			\
+	vmovdqu64 (10 * 64)(rio), y2;			\
+	vmovdqu64 (11 * 64)(rio), y3;			\
+	vmovdqu64 (12 * 64)(rio), y4;			\
+	vmovdqu64 (13 * 64)(rio), y5;			\
+	vmovdqu64 (14 * 64)(rio), y6;			\
+	vmovdqu64 (15 * 64)(rio), y7;
+
+/* byteslice pre-whitened blocks and store to temporary memory */
+#define inpack16_post(x0, x1, x2, x3,			\
+		      x4, x5, x6, x7,			\
+		      y0, y1, y2, y3,			\
+		      y4, y5, y6, y7,			\
+		      mem_ab, mem_cd)			\
+	byteslice_16x16b(x0, x1, x2, x3,		\
+			 x4, x5, x6, x7,		\
+			 y0, y1, y2, y3,		\
+			 y4, y5, y6, y7,		\
+			 (mem_ab), (mem_cd));		\
+							\
+	vmovdqu64 x0, 0 * 64(mem_ab);			\
+	vmovdqu64 x1, 1 * 64(mem_ab);			\
+	vmovdqu64 x2, 2 * 64(mem_ab);			\
+	vmovdqu64 x3, 3 * 64(mem_ab);			\
+	vmovdqu64 x4, 4 * 64(mem_ab);			\
+	vmovdqu64 x5, 5 * 64(mem_ab);			\
+	vmovdqu64 x6, 6 * 64(mem_ab);			\
+	vmovdqu64 x7, 7 * 64(mem_ab);			\
+	vmovdqu64 y0, 0 * 64(mem_cd);			\
+	vmovdqu64 y1, 1 * 64(mem_cd);			\
+	vmovdqu64 y2, 2 * 64(mem_cd);			\
+	vmovdqu64 y3, 3 * 64(mem_cd);			\
+	vmovdqu64 y4, 4 * 64(mem_cd);			\
+	vmovdqu64 y5, 5 * 64(mem_cd);			\
+	vmovdqu64 y6, 6 * 64(mem_cd);			\
+	vmovdqu64 y7, 7 * 64(mem_cd);
+
+#define write_output(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     mem)				\
+	vmovdqu64 x0, 0 * 64(mem);			\
+	vmovdqu64 x1, 1 * 64(mem);			\
+	vmovdqu64 x2, 2 * 64(mem);			\
+	vmovdqu64 x3, 3 * 64(mem);			\
+	vmovdqu64 x4, 4 * 64(mem);			\
+	vmovdqu64 x5, 5 * 64(mem);			\
+	vmovdqu64 x6, 6 * 64(mem);			\
+	vmovdqu64 x7, 7 * 64(mem);			\
+	vmovdqu64 y0, 8 * 64(mem);			\
+	vmovdqu64 y1, 9 * 64(mem);			\
+	vmovdqu64 y2, 10 * 64(mem);			\
+	vmovdqu64 y3, 11 * 64(mem);			\
+	vmovdqu64 y4, 12 * 64(mem);			\
+	vmovdqu64 y5, 13 * 64(mem);			\
+	vmovdqu64 y6, 14 * 64(mem);			\
+	vmovdqu64 y7, 15 * 64(mem);			\
+
+#define aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, idx)		\
+	vmovdqu64 x0, ((idx + 0) * 64)(mem_tmp);	\
+	vmovdqu64 x1, ((idx + 1) * 64)(mem_tmp);	\
+	vmovdqu64 x2, ((idx + 2) * 64)(mem_tmp);	\
+	vmovdqu64 x3, ((idx + 3) * 64)(mem_tmp);	\
+	vmovdqu64 x4, ((idx + 4) * 64)(mem_tmp);	\
+	vmovdqu64 x5, ((idx + 5) * 64)(mem_tmp);	\
+	vmovdqu64 x6, ((idx + 6) * 64)(mem_tmp);	\
+	vmovdqu64 x7, ((idx + 7) * 64)(mem_tmp);
+
+#define aria_load_state_8way(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     mem_tmp, idx)		\
+	vmovdqu64 ((idx + 0) * 64)(mem_tmp), x0;	\
+	vmovdqu64 ((idx + 1) * 64)(mem_tmp), x1;	\
+	vmovdqu64 ((idx + 2) * 64)(mem_tmp), x2;	\
+	vmovdqu64 ((idx + 3) * 64)(mem_tmp), x3;	\
+	vmovdqu64 ((idx + 4) * 64)(mem_tmp), x4;	\
+	vmovdqu64 ((idx + 5) * 64)(mem_tmp), x5;	\
+	vmovdqu64 ((idx + 6) * 64)(mem_tmp), x6;	\
+	vmovdqu64 ((idx + 7) * 64)(mem_tmp), x7;
+
+#define aria_ark_16way(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7,			\
+		       t0, rk, round)			\
+	/* AddRoundKey */                               \
+	vpbroadcastb ((round * 16) + 3)(rk), t0;	\
+	vpxorq t0, x0, x0;				\
+	vpbroadcastb ((round * 16) + 2)(rk), t0;	\
+	vpxorq t0, x1, x1;				\
+	vpbroadcastb ((round * 16) + 1)(rk), t0;	\
+	vpxorq t0, x2, x2;				\
+	vpbroadcastb ((round * 16) + 0)(rk), t0;	\
+	vpxorq t0, x3, x3;				\
+	vpbroadcastb ((round * 16) + 7)(rk), t0;	\
+	vpxorq t0, x4, x4;				\
+	vpbroadcastb ((round * 16) + 6)(rk), t0;	\
+	vpxorq t0, x5, x5;				\
+	vpbroadcastb ((round * 16) + 5)(rk), t0;	\
+	vpxorq t0, x6, x6;				\
+	vpbroadcastb ((round * 16) + 4)(rk), t0;	\
+	vpxorq t0, x7, x7;				\
+	vpbroadcastb ((round * 16) + 11)(rk), t0;	\
+	vpxorq t0, y0, y0;				\
+	vpbroadcastb ((round * 16) + 10)(rk), t0;	\
+	vpxorq t0, y1, y1;				\
+	vpbroadcastb ((round * 16) + 9)(rk), t0;	\
+	vpxorq t0, y2, y2;				\
+	vpbroadcastb ((round * 16) + 8)(rk), t0;	\
+	vpxorq t0, y3, y3;				\
+	vpbroadcastb ((round * 16) + 15)(rk), t0;	\
+	vpxorq t0, y4, y4;				\
+	vpbroadcastb ((round * 16) + 14)(rk), t0;	\
+	vpxorq t0, y5, y5;				\
+	vpbroadcastb ((round * 16) + 13)(rk), t0;	\
+	vpxorq t0, y6, y6;				\
+	vpbroadcastb ((round * 16) + 12)(rk), t0;	\
+	vpxorq t0, y7, y7;
+
+#define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
+			    x4, x5, x6, x7,		\
+			    t0, t1, t2, t3,		\
+			    t4, t5, t6, t7)		\
+	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
+	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
+	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
+	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
+	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
+	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
+	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
+	vgf2p8affineqb $(tf_inv_const), t1, x6, x6;	\
+	vgf2p8affineinvqb $0, t2, x2, x2;		\
+	vgf2p8affineinvqb $0, t2, x6, x6;		\
+	vgf2p8affineinvqb $(tf_aff_const), t3, x0, x0;	\
+	vgf2p8affineinvqb $(tf_aff_const), t3, x4, x4;	\
+	vgf2p8affineqb $(tf_x2_const), t4, x3, x3;	\
+	vgf2p8affineqb $(tf_x2_const), t4, x7, x7;	\
+	vgf2p8affineinvqb $0, t2, x3, x3;		\
+	vgf2p8affineinvqb $0, t2, x7, x7;
+
+#define aria_sbox_16way_gfni(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     y0, y1, y2, y3,		\
+			     y4, y5, y6, y7,		\
+			     t0, t1, t2, t3,		\
+			     t4, t5, t6, t7)		\
+	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
+	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
+	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
+	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
+	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
+	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
+	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
+	vgf2p8affineqb $(tf_inv_const), t1, x6, x6;	\
+	vgf2p8affineinvqb $0, t2, x2, x2;		\
+	vgf2p8affineinvqb $0, t2, x6, x6;		\
+	vgf2p8affineinvqb $(tf_aff_const), t3, x0, x0;	\
+	vgf2p8affineinvqb $(tf_aff_const), t3, x4, x4;	\
+	vgf2p8affineqb $(tf_x2_const), t4, x3, x3;	\
+	vgf2p8affineqb $(tf_x2_const), t4, x7, x7;	\
+	vgf2p8affineinvqb $0, t2, x3, x3;		\
+	vgf2p8affineinvqb $0, t2, x7, x7;		\
+	vgf2p8affineinvqb $(tf_s2_const), t0, y1, y1;	\
+	vgf2p8affineinvqb $(tf_s2_const), t0, y5, y5;	\
+	vgf2p8affineqb $(tf_inv_const), t1, y2, y2;	\
+	vgf2p8affineqb $(tf_inv_const), t1, y6, y6;	\
+	vgf2p8affineinvqb $0, t2, y2, y2;		\
+	vgf2p8affineinvqb $0, t2, y6, y6;		\
+	vgf2p8affineinvqb $(tf_aff_const), t3, y0, y0;	\
+	vgf2p8affineinvqb $(tf_aff_const), t3, y4, y4;	\
+	vgf2p8affineqb $(tf_x2_const), t4, y3, y3;	\
+	vgf2p8affineqb $(tf_x2_const), t4, y7, y7;	\
+	vgf2p8affineinvqb $0, t2, y3, y3;		\
+	vgf2p8affineinvqb $0, t2, y7, y7;
+
+
+#define aria_diff_m(x0, x1, x2, x3,			\
+		    t0, t1, t2, t3)			\
+	/* T = rotr32(X, 8); */				\
+	/* X ^= T */					\
+	vpxorq x0, x3, t0;				\
+	vpxorq x1, x0, t1;				\
+	vpxorq x2, x1, t2;				\
+	vpxorq x3, x2, t3;				\
+	/* X = T ^ rotr(X, 16); */			\
+	vpxorq t2, x0, x0;				\
+	vpxorq x1, t3, t3;				\
+	vpxorq t0, x2, x2;				\
+	vpxorq t1, x3, x1;				\
+	vmovdqu64 t3, x3;
+
+#define aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7)			\
+	/* t1 ^= t2; */					\
+	vpxorq y0, x4, x4;				\
+	vpxorq y1, x5, x5;				\
+	vpxorq y2, x6, x6;				\
+	vpxorq y3, x7, x7;				\
+							\
+	/* t2 ^= t3; */					\
+	vpxorq y4, y0, y0;				\
+	vpxorq y5, y1, y1;				\
+	vpxorq y6, y2, y2;				\
+	vpxorq y7, y3, y3;				\
+							\
+	/* t0 ^= t1; */					\
+	vpxorq x4, x0, x0;				\
+	vpxorq x5, x1, x1;				\
+	vpxorq x6, x2, x2;				\
+	vpxorq x7, x3, x3;				\
+							\
+	/* t3 ^= t1; */					\
+	vpxorq x4, y4, y4;				\
+	vpxorq x5, y5, y5;				\
+	vpxorq x6, y6, y6;				\
+	vpxorq x7, y7, y7;				\
+							\
+	/* t2 ^= t0; */					\
+	vpxorq x0, y0, y0;				\
+	vpxorq x1, y1, y1;				\
+	vpxorq x2, y2, y2;				\
+	vpxorq x3, y3, y3;				\
+							\
+	/* t1 ^= t2; */					\
+	vpxorq y0, x4, x4;				\
+	vpxorq y1, x5, x5;				\
+	vpxorq y2, x6, x6;				\
+	vpxorq y3, x7, x7;
+
+#define aria_fe_gfni(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     z0, z1, z2, z3,			\
+		     z4, z5, z6, z7,			\
+		     mem_tmp, rk, round)		\
+	aria_ark_16way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7,	\
+		       z0, rk, round);			\
+							\
+	aria_sbox_16way_gfni(x2, x3, x0, x1,		\
+			     x6, x7, x4, x5,		\
+			     y2, y3, y0, y1,		\
+			     y6, y7, y4, y5,		\
+			     z0, z1, z2, z3,		\
+			     z4, z5, z6, z7);		\
+							\
+	aria_diff_m(x0, x1, x2, x3, z0, z1, z2, z3);	\
+	aria_diff_m(x4, x5, x6, x7, z0, z1, z2, z3);	\
+	aria_diff_m(y0, y1, y2, y3, z0, z1, z2, z3);	\
+	aria_diff_m(y4, y5, y6, y7, z0, z1, z2, z3);	\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7);			\
+	/* aria_diff_byte()				\
+	 * T3 = ABCD -> BADC				\
+	 * T3 = y4, y5, y6, y7 -> y5, y4, y7, y6	\
+	 * T0 = ABCD -> CDAB				\
+	 * T0 = x0, x1, x2, x3 -> x2, x3, x0, x1	\
+	 * T1 = ABCD -> DCBA				\
+	 * T1 = x4, x5, x6, x7 -> x7, x6, x5, x4	\
+	 */						\
+	aria_diff_word(x2, x3, x0, x1,			\
+		       x7, x6, x5, x4,			\
+		       y0, y1, y2, y3,			\
+		       y5, y4, y7, y6);			\
+
+
+#define aria_fo_gfni(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     z0, z1, z2, z3,			\
+		     z4, z5, z6, z7,			\
+		     mem_tmp, rk, round)		\
+	aria_ark_16way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7,	\
+		       z0, rk, round);			\
+							\
+	aria_sbox_16way_gfni(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     y0, y1, y2, y3,		\
+			     y4, y5, y6, y7,		\
+			     z0, z1, z2, z3,		\
+			     z4, z5, z6, z7);		\
+							\
+	aria_diff_m(x0, x1, x2, x3, z0, z1, z2, z3);	\
+	aria_diff_m(x4, x5, x6, x7, z0, z1, z2, z3);	\
+	aria_diff_m(y0, y1, y2, y3, z0, z1, z2, z3);	\
+	aria_diff_m(y4, y5, y6, y7, z0, z1, z2, z3);	\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7);			\
+	/* aria_diff_byte()				\
+	 * T1 = ABCD -> BADC				\
+	 * T1 = x4, x5, x6, x7 -> x5, x4, x7, x6	\
+	 * T2 = ABCD -> CDAB				\
+	 * T2 = y0, y1, y2, y3, -> y2, y3, y0, y1	\
+	 * T3 = ABCD -> DCBA				\
+	 * T3 = y4, y5, y6, y7 -> y7, y6, y5, y4	\
+	 */						\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x5, x4, x7, x6,			\
+		       y2, y3, y0, y1,			\
+		       y7, y6, y5, y4);
+
+#define aria_ff_gfni(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     z0, z1, z2, z3,			\
+		     z4, z5, z6, z7,			\
+		     mem_tmp, rk, round, last_round)	\
+	aria_ark_16way(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7,			\
+		       z0, rk, round);			\
+	aria_sbox_16way_gfni(x2, x3, x0, x1,		\
+			     x6, x7, x4, x5,		\
+			     y2, y3, y0, y1,		\
+			     y6, y7, y4, y5,		\
+			     z0, z1, z2, z3,		\
+			     z4, z5, z6, z7);		\
+	aria_ark_16way(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7,			\
+		       z0, rk, last_round);
+
+
+.section        .rodata.cst64, "aM", @progbits, 64
+.align 64
+.Lpack_bswap:
+	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
+	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
+	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
+	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
+
+.Lcounter0123_lo:
+	.quad 0, 0
+	.quad 1, 0
+	.quad 2, 0
+	.quad 3, 0
+
+.section        .rodata.cst32.shufb_16x16b, "aM", @progbits, 32
+.align 32
+#define SHUFB_BYTES(idx) \
+	0 + (idx), 4 + (idx), 8 + (idx), 12 + (idx)
+.Lshufb_16x16b:
+	.byte SHUFB_BYTES(0), SHUFB_BYTES(1), SHUFB_BYTES(2), SHUFB_BYTES(3)
+	.byte SHUFB_BYTES(0), SHUFB_BYTES(1), SHUFB_BYTES(2), SHUFB_BYTES(3)
+
+.section	.rodata.cst16, "aM", @progbits, 16
+.align 16
+
+.Lcounter4444_lo:
+	.quad 4, 0
+.Lcounter8888_lo:
+	.quad 8, 0
+.Lcounter16161616_lo:
+	.quad 16, 0
+.Lcounter1111_hi:
+	.quad 0, 1
+
+/* For isolating SubBytes from AESENCLAST, inverse shift row */
+.Linv_shift_row:
+	.byte 0x00, 0x0d, 0x0a, 0x07, 0x04, 0x01, 0x0e, 0x0b
+	.byte 0x08, 0x05, 0x02, 0x0f, 0x0c, 0x09, 0x06, 0x03
+.Lshift_row:
+	.byte 0x00, 0x05, 0x0a, 0x0f, 0x04, 0x09, 0x0e, 0x03
+	.byte 0x08, 0x0d, 0x02, 0x07, 0x0c, 0x01, 0x06, 0x0b
+/* For CTR-mode IV byteswap */
+.Lbswap128_mask:
+	.byte 0x0f, 0x0e, 0x0d, 0x0c, 0x0b, 0x0a, 0x09, 0x08
+	.byte 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00
+
+/* AES inverse affine and S2 combined:
+ *      1 1 0 0 0 0 0 1     x0     0
+ *      0 1 0 0 1 0 0 0     x1     0
+ *      1 1 0 0 1 1 1 1     x2     0
+ *      0 1 1 0 1 0 0 1     x3     1
+ *      0 1 0 0 1 1 0 0  *  x4  +  0
+ *      0 1 0 1 1 0 0 0     x5     0
+ *      0 0 0 0 0 1 0 1     x6     0
+ *      1 1 1 0 0 1 1 1     x7     1
+ */
+.Ltf_lo__inv_aff__and__s2:
+	.octa 0x92172DA81A9FA520B2370D883ABF8500
+.Ltf_hi__inv_aff__and__s2:
+	.octa 0x2B15FFC1AF917B45E6D8320C625CB688
+
+/* X2 and AES forward affine combined:
+ *      1 0 1 1 0 0 0 1     x0     0
+ *      0 1 1 1 1 0 1 1     x1     0
+ *      0 0 0 1 1 0 1 0     x2     1
+ *      0 1 0 0 0 1 0 0     x3     0
+ *      0 0 1 1 1 0 1 1  *  x4  +  0
+ *      0 1 0 0 1 0 0 0     x5     0
+ *      1 1 0 1 0 0 1 1     x6     0
+ *      0 1 0 0 1 0 1 0     x7     0
+ */
+.Ltf_lo__x2__and__fwd_aff:
+	.octa 0xEFAE0544FCBD1657B8F95213ABEA4100
+.Ltf_hi__x2__and__fwd_aff:
+	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
+
+.section	.rodata.cst8, "aM", @progbits, 8
+.align 8
+/* AES affine: */
+#define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
+.Ltf_aff_bitmatrix:
+	.quad BM8X8(BV8(1, 0, 0, 0, 1, 1, 1, 1),
+		    BV8(1, 1, 0, 0, 0, 1, 1, 1),
+		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 1, 0, 0, 0, 1),
+		    BV8(1, 1, 1, 1, 1, 0, 0, 0),
+		    BV8(0, 1, 1, 1, 1, 1, 0, 0),
+		    BV8(0, 0, 1, 1, 1, 1, 1, 0),
+		    BV8(0, 0, 0, 1, 1, 1, 1, 1))
+
+/* AES inverse affine: */
+#define tf_inv_const BV8(1, 0, 1, 0, 0, 0, 0, 0)
+.Ltf_inv_bitmatrix:
+	.quad BM8X8(BV8(0, 0, 1, 0, 0, 1, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 0, 1, 0),
+		    BV8(0, 1, 0, 0, 1, 0, 0, 1),
+		    BV8(1, 0, 1, 0, 0, 1, 0, 0),
+		    BV8(0, 1, 0, 1, 0, 0, 1, 0),
+		    BV8(0, 0, 1, 0, 1, 0, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 1, 0, 0),
+		    BV8(0, 1, 0, 0, 1, 0, 1, 0))
+
+/* S2: */
+#define tf_s2_const BV8(0, 1, 0, 0, 0, 1, 1, 1)
+.Ltf_s2_bitmatrix:
+	.quad BM8X8(BV8(0, 1, 0, 1, 0, 1, 1, 1),
+		    BV8(0, 0, 1, 1, 1, 1, 1, 1),
+		    BV8(1, 1, 1, 0, 1, 1, 0, 1),
+		    BV8(1, 1, 0, 0, 0, 0, 1, 1),
+		    BV8(0, 1, 0, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 0, 0, 1, 1, 1, 0),
+		    BV8(0, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 1, 0, 1, 1, 0))
+
+/* X2: */
+#define tf_x2_const BV8(0, 0, 1, 1, 0, 1, 0, 0)
+.Ltf_x2_bitmatrix:
+	.quad BM8X8(BV8(0, 0, 0, 1, 1, 0, 0, 0),
+		    BV8(0, 0, 1, 0, 0, 1, 1, 0),
+		    BV8(0, 0, 0, 0, 1, 0, 1, 0),
+		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 0, 1, 1, 0, 0),
+		    BV8(0, 1, 1, 0, 1, 0, 1, 1),
+		    BV8(1, 0, 1, 1, 1, 1, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 0, 1, 1))
+
+/* Identity matrix: */
+.Ltf_id_bitmatrix:
+	.quad BM8X8(BV8(1, 0, 0, 0, 0, 0, 0, 0),
+		    BV8(0, 1, 0, 0, 0, 0, 0, 0),
+		    BV8(0, 0, 1, 0, 0, 0, 0, 0),
+		    BV8(0, 0, 0, 1, 0, 0, 0, 0),
+		    BV8(0, 0, 0, 0, 1, 0, 0, 0),
+		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
+		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
+		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
+
+/* 4-bit mask */
+.section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
+.align 4
+.L0f0f0f0f:
+	.long 0x0f0f0f0f
+
+.text
+SYM_FUNC_START_LOCAL(__aria_gfni_avx512_crypt_64way)
+	/* input:
+	 *      %r9: rk
+	 *      %rsi: dst
+	 *      %rdx: src
+	 *      %zmm0..%zmm15: byte-sliced blocks
+	 */
+
+	FRAME_BEGIN
+
+	movq %rsi, %rax;
+	leaq 8 * 64(%rax), %r8;
+
+	inpack16_post(%zmm0, %zmm1, %zmm2, %zmm3,
+		      %zmm4, %zmm5, %zmm6, %zmm7,
+		      %zmm8, %zmm9, %zmm10, %zmm11,
+		      %zmm12, %zmm13, %zmm14,
+		      %zmm15, %rax, %r8);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 0);
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 1);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 2);
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 3);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 4);
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 5);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 6);
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 7);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 8);
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 9);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 10);
+	cmpl $12, ARIA_CTX_rounds(CTX);
+	jne .Laria_gfni_192;
+	aria_ff_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 11, 12);
+	jmp .Laria_gfni_end;
+.Laria_gfni_192:
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 11);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 12);
+	cmpl $14, ARIA_CTX_rounds(CTX);
+	jne .Laria_gfni_256;
+	aria_ff_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 13, 14);
+	jmp .Laria_gfni_end;
+.Laria_gfni_256:
+	aria_fe_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 13);
+	aria_fo_gfni(%zmm0, %zmm1, %zmm2, %zmm3,
+		     %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 14);
+	aria_ff_gfni(%zmm3, %zmm2, %zmm1, %zmm0,
+		     %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10,
+		     %zmm12, %zmm13, %zmm14, %zmm15,
+		     %zmm24, %zmm25, %zmm26, %zmm27,
+		     %zmm28, %zmm29, %zmm30, %zmm31,
+		     %rax, %r9, 15, 16);
+.Laria_gfni_end:
+	debyteslice_16x16b(%zmm9, %zmm12, %zmm3, %zmm6,
+			   %zmm8, %zmm13, %zmm2, %zmm7,
+			   %zmm11, %zmm14, %zmm1, %zmm4,
+			   %zmm10, %zmm15, %zmm0, %zmm5,
+			   (%rax), (%r8));
+	FRAME_END
+	RET;
+SYM_FUNC_END(__aria_gfni_avx512_crypt_64way)
+
+SYM_FUNC_START(aria_gfni_avx512_encrypt_64way)
+	/* input:
+	 *      %rdi: ctx, CTX
+	 *      %rsi: dst
+	 *      %rdx: src
+	 */
+
+	FRAME_BEGIN
+
+	leaq ARIA_CTX_enc_key(CTX), %r9;
+
+	inpack16_pre(%zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11, %zmm12, %zmm13, %zmm14,
+		     %zmm15, %rdx);
+
+	call __aria_gfni_avx512_crypt_64way;
+
+	write_output(%zmm3, %zmm2, %zmm1, %zmm0, %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
+		     %zmm15, %rax);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(aria_gfni_avx512_encrypt_64way)
+
+SYM_FUNC_START(aria_gfni_avx512_decrypt_64way)
+	/* input:
+	 *      %rdi: ctx, CTX
+	 *      %rsi: dst
+	 *      %rdx: src
+	 */
+
+	FRAME_BEGIN
+
+	leaq ARIA_CTX_dec_key(CTX), %r9;
+
+	inpack16_pre(%zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %zmm7,
+		     %zmm8, %zmm9, %zmm10, %zmm11, %zmm12, %zmm13, %zmm14,
+		     %zmm15, %rdx);
+
+	call __aria_gfni_avx512_crypt_64way;
+
+	write_output(%zmm3, %zmm2, %zmm1, %zmm0, %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
+		     %zmm15, %rax);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(aria_gfni_avx512_decrypt_64way)
+
+SYM_FUNC_START_LOCAL(__aria_gfni_avx512_ctr_gen_keystream_64way)
+	/* input:
+	 *      %rdi: ctx
+	 *      %rsi: dst
+	 *      %rdx: src
+	 *      %rcx: keystream
+	 *      %r8: iv (big endian, 128bit)
+	 */
+
+	FRAME_BEGIN
+
+	vbroadcasti64x2 .Lbswap128_mask (%rip), %zmm19;
+	vmovdqa64 .Lcounter0123_lo (%rip), %zmm21;
+	vbroadcasti64x2 .Lcounter4444_lo (%rip), %zmm22;
+	vbroadcasti64x2 .Lcounter8888_lo (%rip), %zmm23;
+	vbroadcasti64x2 .Lcounter16161616_lo (%rip), %zmm24;
+	vbroadcasti64x2 .Lcounter1111_hi (%rip), %zmm25;
+
+	/* load IV and byteswap */
+	movq 8(%r8), %r11;
+	movq (%r8), %r10;
+	bswapq %r11;
+	bswapq %r10;
+	vbroadcasti64x2 (%r8), %zmm20;
+	vpshufb %zmm19, %zmm20, %zmm20;
+
+	/* check need for handling 64-bit overflow and carry */
+	cmpq $(0xffffffffffffffff - 64), %r11;
+	ja .Lload_ctr_carry;
+
+	/* construct IVs */
+	vpaddq %zmm21, %zmm20, %zmm0;  /* +0:+1:+2:+3 */
+	vpaddq %zmm22, %zmm0, %zmm1; /* +4:+5:+6:+7 */
+	vpaddq %zmm23, %zmm0, %zmm2; /* +8:+9:+10:+11 */
+	vpaddq %zmm23, %zmm1, %zmm3; /* +12:+13:+14:+15 */
+	vpaddq %zmm24, %zmm0, %zmm4; /* +16... */
+	vpaddq %zmm24, %zmm1, %zmm5; /* +20... */
+	vpaddq %zmm24, %zmm2, %zmm6; /* +24... */
+	vpaddq %zmm24, %zmm3, %zmm7; /* +28... */
+	vpaddq %zmm24, %zmm4, %zmm8; /* +32... */
+	vpaddq %zmm24, %zmm5, %zmm9; /* +36... */
+	vpaddq %zmm24, %zmm6, %zmm10; /* +40... */
+	vpaddq %zmm24, %zmm7, %zmm11; /* +44... */
+	vpaddq %zmm24, %zmm8, %zmm12; /* +48... */
+	vpaddq %zmm24, %zmm9, %zmm13; /* +52... */
+	vpaddq %zmm24, %zmm10, %zmm14; /* +56... */
+	vpaddq %zmm24, %zmm11, %zmm15; /* +60... */
+	jmp .Lload_ctr_done;
+
+.Lload_ctr_carry:
+	/* construct IVs */
+	add_le128(%zmm0, %zmm20, %zmm21, %zmm25);  /* +0:+1:+2:+3 */
+	add_le128(%zmm1, %zmm0, %zmm22, %zmm25); /* +4:+5:+6:+7 */
+	add_le128(%zmm2, %zmm0, %zmm23, %zmm25); /* +8:+9:+10:+11 */
+	add_le128(%zmm3, %zmm1, %zmm23, %zmm25); /* +12:+13:+14:+15 */
+	add_le128(%zmm4, %zmm0, %zmm24, %zmm25); /* +16... */
+	add_le128(%zmm5, %zmm1, %zmm24, %zmm25); /* +20... */
+	add_le128(%zmm6, %zmm2, %zmm24, %zmm25); /* +24... */
+	add_le128(%zmm7, %zmm3, %zmm24, %zmm25); /* +28... */
+	add_le128(%zmm8, %zmm4, %zmm24, %zmm25); /* +32... */
+	add_le128(%zmm9, %zmm5, %zmm24, %zmm25); /* +36... */
+	add_le128(%zmm10, %zmm6, %zmm24, %zmm25); /* +40... */
+	add_le128(%zmm11, %zmm7, %zmm24, %zmm25); /* +44... */
+	add_le128(%zmm12, %zmm8, %zmm24, %zmm25); /* +48... */
+	add_le128(%zmm13, %zmm9, %zmm24, %zmm25); /* +52... */
+	add_le128(%zmm14, %zmm10, %zmm24, %zmm25); /* +56... */
+	add_le128(%zmm15, %zmm11, %zmm24, %zmm25); /* +60... */
+
+.Lload_ctr_done:
+	/* Byte-swap IVs and update counter. */
+	addq $64, %r11;
+	adcq $0, %r10;
+	vpshufb %zmm19, %zmm15, %zmm15;
+	vpshufb %zmm19, %zmm14, %zmm14;
+	vpshufb %zmm19, %zmm13, %zmm13;
+	vpshufb %zmm19, %zmm12, %zmm12;
+	vpshufb %zmm19, %zmm11, %zmm11;
+	vpshufb %zmm19, %zmm10, %zmm10;
+	vpshufb %zmm19, %zmm9, %zmm9;
+	vpshufb %zmm19, %zmm8, %zmm8;
+	bswapq %r11;
+	bswapq %r10;
+	vpshufb %zmm19, %zmm7, %zmm7;
+	vpshufb %zmm19, %zmm6, %zmm6;
+	vpshufb %zmm19, %zmm5, %zmm5;
+	vpshufb %zmm19, %zmm4, %zmm4;
+	vpshufb %zmm19, %zmm3, %zmm3;
+	vpshufb %zmm19, %zmm2, %zmm2;
+	vpshufb %zmm19, %zmm1, %zmm1;
+	vpshufb %zmm19, %zmm0, %zmm0;
+	movq %r11, 8(%r8);
+	movq %r10, (%r8);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(__aria_gfni_avx512_ctr_gen_keystream_64way)
+
+SYM_FUNC_START(aria_gfni_avx512_ctr_crypt_64way)
+	/* input:
+	 *      %rdi: ctx
+	 *      %rsi: dst
+	 *      %rdx: src
+	 *      %rcx: keystream
+	 *      %r8: iv (big endian, 128bit)
+	 */
+	FRAME_BEGIN
+
+	call __aria_gfni_avx512_ctr_gen_keystream_64way
+
+	leaq (%rsi), %r10;
+	leaq (%rdx), %r11;
+	leaq (%rcx), %rsi;
+	leaq (%rcx), %rdx;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
+
+	call __aria_gfni_avx512_crypt_64way;
+
+	vpxorq (0 * 64)(%r11), %zmm3, %zmm3;
+	vpxorq (1 * 64)(%r11), %zmm2, %zmm2;
+	vpxorq (2 * 64)(%r11), %zmm1, %zmm1;
+	vpxorq (3 * 64)(%r11), %zmm0, %zmm0;
+	vpxorq (4 * 64)(%r11), %zmm6, %zmm6;
+	vpxorq (5 * 64)(%r11), %zmm7, %zmm7;
+	vpxorq (6 * 64)(%r11), %zmm4, %zmm4;
+	vpxorq (7 * 64)(%r11), %zmm5, %zmm5;
+	vpxorq (8 * 64)(%r11), %zmm9, %zmm9;
+	vpxorq (9 * 64)(%r11), %zmm8, %zmm8;
+	vpxorq (10 * 64)(%r11), %zmm11, %zmm11;
+	vpxorq (11 * 64)(%r11), %zmm10, %zmm10;
+	vpxorq (12 * 64)(%r11), %zmm12, %zmm12;
+	vpxorq (13 * 64)(%r11), %zmm13, %zmm13;
+	vpxorq (14 * 64)(%r11), %zmm14, %zmm14;
+	vpxorq (15 * 64)(%r11), %zmm15, %zmm15;
+	write_output(%zmm3, %zmm2, %zmm1, %zmm0, %zmm6, %zmm7, %zmm4, %zmm5,
+		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
+		     %zmm15, %r10);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(aria_gfni_avx512_ctr_crypt_64way)
diff --git a/arch/x86/crypto/aria_gfni_avx512_glue.c b/arch/x86/crypto/aria_gfni_avx512_glue.c
new file mode 100644
index 000000000000..5eaebe1eea8a
--- /dev/null
+++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
@@ -0,0 +1,249 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Glue Code for the AVX512/GFNI assembler implementation of the ARIA Cipher
+ *
+ * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/simd.h>
+#include <crypto/aria.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+#include "ecb_cbc_helpers.h"
+#include "aria-avx.h"
+
+asmlinkage void aria_gfni_avx512_encrypt_64way(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void aria_gfni_avx512_decrypt_64way(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void aria_gfni_avx512_ctr_crypt_64way(const void *ctx, u8 *dst,
+						 const u8 *src,
+						 u8 *keystream, u8 *iv);
+
+static struct aria_avx_ops aria_ops;
+
+struct aria_avx512_request_ctx {
+	u8 keystream[ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE];
+};
+
+static int ecb_do_encrypt(struct skcipher_request *req, const u32 *rkey)
+{
+	ECB_WALK_START(req, ARIA_BLOCK_SIZE, ARIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(ARIA_GFNI_AVX512_PARALLEL_BLOCKS, aria_ops.aria_encrypt_64way);
+	ECB_BLOCK(ARIA_AESNI_AVX2_PARALLEL_BLOCKS, aria_ops.aria_encrypt_32way);
+	ECB_BLOCK(ARIA_AESNI_PARALLEL_BLOCKS, aria_ops.aria_encrypt_16way);
+	ECB_BLOCK(1, aria_encrypt);
+	ECB_WALK_END();
+}
+
+static int ecb_do_decrypt(struct skcipher_request *req, const u32 *rkey)
+{
+	ECB_WALK_START(req, ARIA_BLOCK_SIZE, ARIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(ARIA_GFNI_AVX512_PARALLEL_BLOCKS, aria_ops.aria_decrypt_64way);
+	ECB_BLOCK(ARIA_AESNI_AVX2_PARALLEL_BLOCKS, aria_ops.aria_decrypt_32way);
+	ECB_BLOCK(ARIA_AESNI_PARALLEL_BLOCKS, aria_ops.aria_decrypt_16way);
+	ECB_BLOCK(1, aria_decrypt);
+	ECB_WALK_END();
+}
+
+static int aria_avx512_ecb_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return ecb_do_encrypt(req, ctx->enc_key[0]);
+}
+
+static int aria_avx512_ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return ecb_do_decrypt(req, ctx->dec_key[0]);
+}
+
+static int aria_avx512_set_key(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	return aria_set_key(&tfm->base, key, keylen);
+}
+
+static int aria_avx512_ctr_encrypt(struct skcipher_request *req)
+{
+	struct aria_avx512_request_ctx *req_ctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while ((nbytes = walk.nbytes) > 0) {
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+
+		while (nbytes >= ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE) {
+			kernel_fpu_begin();
+			aria_ops.aria_ctr_crypt_64way(ctx, dst, src,
+						      &req_ctx->keystream[0],
+						      walk.iv);
+			kernel_fpu_end();
+			dst += ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE;
+			src += ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE;
+			nbytes -= ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE;
+		}
+
+		while (nbytes >= ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE) {
+			kernel_fpu_begin();
+			aria_ops.aria_ctr_crypt_32way(ctx, dst, src,
+						      &req_ctx->keystream[0],
+						      walk.iv);
+			kernel_fpu_end();
+			dst += ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE;
+			src += ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE;
+			nbytes -= ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE;
+		}
+
+		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
+			kernel_fpu_begin();
+			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
+						      &req_ctx->keystream[0],
+						      walk.iv);
+			kernel_fpu_end();
+			dst += ARIA_AESNI_PARALLEL_BLOCK_SIZE;
+			src += ARIA_AESNI_PARALLEL_BLOCK_SIZE;
+			nbytes -= ARIA_AESNI_PARALLEL_BLOCK_SIZE;
+		}
+
+		while (nbytes >= ARIA_BLOCK_SIZE) {
+			memcpy(&req_ctx->keystream[0], walk.iv,
+			       ARIA_BLOCK_SIZE);
+			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
+
+			aria_encrypt(ctx, &req_ctx->keystream[0],
+				     &req_ctx->keystream[0]);
+
+			crypto_xor_cpy(dst, src, &req_ctx->keystream[0],
+				       ARIA_BLOCK_SIZE);
+			dst += ARIA_BLOCK_SIZE;
+			src += ARIA_BLOCK_SIZE;
+			nbytes -= ARIA_BLOCK_SIZE;
+		}
+
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			memcpy(&req_ctx->keystream[0], walk.iv,
+			       ARIA_BLOCK_SIZE);
+			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
+
+			aria_encrypt(ctx, &req_ctx->keystream[0],
+				     &req_ctx->keystream[0]);
+
+			crypto_xor_cpy(dst, src, &req_ctx->keystream[0],
+				       nbytes);
+			dst += nbytes;
+			src += nbytes;
+			nbytes = 0;
+		}
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+
+	return err;
+}
+
+static int aria_avx512_init_tfm(struct crypto_skcipher *tfm)
+{
+	crypto_skcipher_set_reqsize(tfm,
+				    sizeof(struct aria_avx512_request_ctx));
+
+	return 0;
+}
+
+static struct skcipher_alg aria_algs[] = {
+	{
+		.base.cra_name		= "__ecb(aria)",
+		.base.cra_driver_name	= "__ecb-aria-avx512",
+		.base.cra_priority	= 600,
+		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct aria_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= ARIA_MIN_KEY_SIZE,
+		.max_keysize		= ARIA_MAX_KEY_SIZE,
+		.setkey			= aria_avx512_set_key,
+		.encrypt		= aria_avx512_ecb_encrypt,
+		.decrypt		= aria_avx512_ecb_decrypt,
+	}, {
+		.base.cra_name		= "__ctr(aria)",
+		.base.cra_driver_name	= "__ctr-aria-avx512",
+		.base.cra_priority	= 600,
+		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct aria_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= ARIA_MIN_KEY_SIZE,
+		.max_keysize		= ARIA_MAX_KEY_SIZE,
+		.ivsize			= ARIA_BLOCK_SIZE,
+		.chunksize		= ARIA_BLOCK_SIZE,
+		.setkey			= aria_avx512_set_key,
+		.encrypt		= aria_avx512_ctr_encrypt,
+		.decrypt		= aria_avx512_ctr_encrypt,
+		.init                   = aria_avx512_init_tfm,
+	}
+};
+
+static struct simd_skcipher_alg *aria_simd_algs[ARRAY_SIZE(aria_algs)];
+
+static int __init aria_avx512_init(void)
+{
+	const char *feature_name;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX) ||
+	    !boot_cpu_has(X86_FEATURE_AVX2) ||
+	    !boot_cpu_has(X86_FEATURE_AVX512F) ||
+	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
+	    !boot_cpu_has(X86_FEATURE_GFNI) ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		pr_info("AVX512/GFNI instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+			       XFEATURE_MASK_AVX512, &feature_name)) {
+		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+		return -ENODEV;
+	}
+
+	aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
+	aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
+	aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
+	aria_ops.aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
+	aria_ops.aria_decrypt_32way = aria_aesni_avx2_gfni_decrypt_32way;
+	aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_gfni_ctr_crypt_32way;
+	aria_ops.aria_encrypt_64way = aria_gfni_avx512_encrypt_64way;
+	aria_ops.aria_decrypt_64way = aria_gfni_avx512_decrypt_64way;
+	aria_ops.aria_ctr_crypt_64way = aria_gfni_avx512_ctr_crypt_64way;
+
+	return simd_register_skciphers_compat(aria_algs,
+					      ARRAY_SIZE(aria_algs),
+					      aria_simd_algs);
+}
+
+static void __exit aria_avx512_exit(void)
+{
+	simd_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs),
+				  aria_simd_algs);
+}
+
+module_init(aria_avx512_init);
+module_exit(aria_avx512_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Taehee Yoo <ap420073@gmail.com>");
+MODULE_DESCRIPTION("ARIA Cipher Algorithm, AVX512/GFNI optimized");
+MODULE_ALIAS_CRYPTO("aria");
+MODULE_ALIAS_CRYPTO("aria-gfni-avx512");
-- 
2.17.1

