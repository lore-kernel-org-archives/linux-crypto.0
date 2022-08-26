Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CD3ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 05:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiHZFcJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244909AbiHZFcG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 01:32:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40806CD789
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y4so705156plb.2
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=hKsq0iOApcIOYWcNByBIPx/+QD4AUICqkaLKR9AryS4=;
        b=HjTVZSd2zVcbhJ8WXaGoELjF9skdktsHUDTP/MFm+aUIl/5wahLue43FilLUJldCq5
         9xaKH8fmYK9REfV5UBctjvARhMdqjPcz2QQXPdnuW7+SvrqqlQlpZIy1HPyM47TmbYwr
         J4epY+o4ivDqby8y4ocApDssG1Z+x4V3amnsf4f3hkU7bnDu6lJPxJKrhwHU2zr9teQu
         CNgVXMomfcVjN+ra9EnOsOgEWs2SxiF2bKdHkh0hDvq6i9ZeIaRU+C7DoZd/ys3ssqiX
         Ddj5g/1jobrGzox9VAQ0jd0ukSkp8ayCxOt6ymQ+O9iObJ4O6hQ6tDwOuVBgXCqjPHQF
         iauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=hKsq0iOApcIOYWcNByBIPx/+QD4AUICqkaLKR9AryS4=;
        b=CDx1WRi3f/Do40bX2sphsLgL/CCAp3xP1+A2UpsB8TxJLf2KTofmf3D040ps9RCfql
         IoolxCnEld64tYbR9u0t5H17kqF/A+px+5F2Bdshfc63Irm/XuQQ/Y8fVRVxWJmUp9eI
         Mwc8ouHf6DY0tQeTkKhTQ+xZFHUbKDnc2QqZ1fBRmq9isJy1KYY3p1z8w/66j6xFykJ+
         9DxS+LwtJ9k7DrKv4Wcku+dGQE3Yg16rImOllAqa7xRXqsG/sa5irllGKzwVdRk2Lza4
         uhK6EzT8DCeLi+EgNUcVXCb88DtIgLSr8ZgYChauqRle4UzetAkx3L1oy6SPrR/4pGA3
         SGaA==
X-Gm-Message-State: ACgBeo1IZ4xyTx8tSivglwbm2m/SJQiDcJZbYhb6we5uncAxigbqV80y
        NTy62dlyYwLPshpk4zyl0gzh+uyJhgI=
X-Google-Smtp-Source: AA6agR7qtYcg+tCcNivLvWPYQRhTmlzlGmPMqkETMpQUcz8FAgI0wW+BBBaRY11j5W84MRRXhlFBgA==
X-Received: by 2002:a17:902:f70d:b0:16c:50a2:78d1 with SMTP id h13-20020a170902f70d00b0016c50a278d1mr2196747plo.34.1661491914226;
        Thu, 25 Aug 2022 22:31:54 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b00172925f3c79sm545726pla.153.2022.08.25.22.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 22:31:53 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     elliott@hpe.com, ap420073@gmail.com
Subject: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler implementation of aria cipher
Date:   Fri, 26 Aug 2022 05:31:30 +0000
Message-Id: <20220826053131.24792-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220826053131.24792-1-ap420073@gmail.com>
References: <20220826053131.24792-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The implementation is based on the 32-bit implementation of the aria.
Also, aria-avx process steps are the similar to the camellia-avx.
1. Byteslice(16way)
2. Add-round-key.
3. Sbox
4. Diffusion layer.

Except for s-box, all steps are the same as the aria-generic
implementation. s-box step is very similar to camellia and
sm4 implementation.

There are 4 s-boxes in the ARIA and the 2 s-boxes are the same as
AES's s-boxes. The basic strategy is to use the aes-ni.

To calculate a first sbox, it just uses the aesenclast and then
inverts shift_row.
No more process is needed for this job because the first s-box is
the same as the AES encryption s-box.

To calculate a second sbox(invert of s1), it just uses the aesdeclast
and then inverts shift_row.
No more process is needed for this job because the second s-box is
the same as the AES decryption s-box.

To calculate a third and fourth s-boxes, it uses the aesenclast,
then inverts shift_row, and affine transformation.

The aria-generic implementation is based on a 32-bit implementation,
not an 8-bit implementation. the aria-avx Diffusion Layer implementation
is based on aria-generic implementation because 8-bit implementation is
not fit for parallel implementation but 32-bit is enough to fit for this.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Do not call non-FPU functions(aria_{encrypt | decrypt}() in the
   FPU context.
 - Do not acquire FPU context for too long.

 arch/x86/crypto/Makefile                |   3 +
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 648 ++++++++++++++++++++++++
 arch/x86/crypto/aria_aesni_avx_glue.c   | 165 ++++++
 crypto/Kconfig                          |  21 +
 4 files changed, 837 insertions(+)
 create mode 100644 arch/x86/crypto/aria-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 04d07ab744b2..3b1d701a4f6c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -100,6 +100,9 @@ sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64) += sm4-aesni-avx2-x86_64.o
 sm4-aesni-avx2-x86_64-y := sm4-aesni-avx2-asm_64.o sm4_aesni_avx2_glue.o
 
+obj-$(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) += aria-aesni-avx-x86_64.o
+aria-aesni-avx-x86_64-y := aria-aesni-avx-asm_64.o aria_aesni_avx_glue.o
+
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $< > $@
 $(obj)/%.S: $(src)/%.pl FORCE
diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
new file mode 100644
index 000000000000..3d01f5229f72
--- /dev/null
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -0,0 +1,648 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARIA Cipher 16-way parallel algorithm (AVX)
+ *
+ * Copyright (c) 2022 Taehee Yoo <ap420073@gmail.com>
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#define filter_8bit(x, lo_t, hi_t, mask4bit, tmp0)	\
+	vpand x, mask4bit, tmp0;			\
+	vpandn x, mask4bit, x;				\
+	vpsrld $4, x, x;				\
+							\
+	vpshufb tmp0, lo_t, tmp0;			\
+	vpshufb x, hi_t, x;				\
+	vpxor tmp0, x, x;
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
+	vmovdqu d2, st0;				\
+	vmovdqu d3, st1;				\
+	transpose_4x4(a0, a1, a2, a3, d2, d3);		\
+	transpose_4x4(b0, b1, b2, b3, d2, d3);		\
+	vmovdqu st0, d2;				\
+	vmovdqu st1, d3;				\
+							\
+	vmovdqu a0, st0;				\
+	vmovdqu a1, st1;				\
+	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
+	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
+							\
+	vmovdqu .Lshufb_16x16b, a0;			\
+	vmovdqu st1, a1;				\
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
+	vmovdqu d3, st1;				\
+	vmovdqu st0, d3;				\
+	vpshufb a0, d3, a0;				\
+	vmovdqu d2, st0;				\
+							\
+	transpose_4x4(a0, b0, c0, d0, d2, d3);		\
+	transpose_4x4(a1, b1, c1, d1, d2, d3);		\
+	vmovdqu st0, d2;				\
+	vmovdqu st1, d3;				\
+							\
+	vmovdqu b0, st0;				\
+	vmovdqu b1, st1;				\
+	transpose_4x4(a2, b2, c2, d2, b0, b1);		\
+	transpose_4x4(a3, b3, c3, d3, b0, b1);		\
+	vmovdqu st0, b0;				\
+	vmovdqu st1, b1;				\
+	/* does not adjust output bytes inside vectors */
+
+#define debyteslice_16x16b(a0, b0, c0, d0,		\
+			   a1, b1, c1, d1,		\
+			   a2, b2, c2, d2,		\
+			   a3, b3, c3, d3,		\
+			   st0, st1)			\
+	vmovdqu d2, st0;				\
+	vmovdqu d3, st1;				\
+	transpose_4x4(a0, a1, a2, a3, d2, d3);		\
+	transpose_4x4(b0, b1, b2, b3, d2, d3);		\
+	vmovdqu st0, d2;				\
+	vmovdqu st1, d3;				\
+							\
+	vmovdqu a0, st0;				\
+	vmovdqu a1, st1;				\
+	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
+	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
+							\
+	vmovdqu .Lshufb_16x16b, a0;			\
+	vmovdqu st1, a1;				\
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
+	vmovdqu d3, st1;				\
+	vmovdqu st0, d3;				\
+	vpshufb a0, d3, a0;				\
+	vmovdqu d2, st0;				\
+							\
+	transpose_4x4(c0, d0, a0, b0, d2, d3);		\
+	transpose_4x4(c1, d1, a1, b1, d2, d3);		\
+	vmovdqu st0, d2;				\
+	vmovdqu st1, d3;				\
+							\
+	vmovdqu b0, st0;				\
+	vmovdqu b1, st1;				\
+	transpose_4x4(c2, d2, a2, b2, b0, b1);		\
+	transpose_4x4(c3, d3, a3, b3, b0, b1);		\
+	vmovdqu st0, b0;				\
+	vmovdqu st1, b1;				\
+	/* does not adjust output bytes inside vectors */
+
+/* load blocks to registers and apply pre-whitening */
+#define inpack16_pre(x0, x1, x2, x3,			\
+		     x4, x5, x6, x7,			\
+		     y0, y1, y2, y3,			\
+		     y4, y5, y6, y7,			\
+		     rio)				\
+	vmovdqu (0 * 16)(rio), x0;			\
+	vmovdqu (1 * 16)(rio), x1;			\
+	vmovdqu (2 * 16)(rio), x2;			\
+	vmovdqu (3 * 16)(rio), x3;			\
+	vmovdqu (4 * 16)(rio), x4;			\
+	vmovdqu (5 * 16)(rio), x5;			\
+	vmovdqu (6 * 16)(rio), x6;			\
+	vmovdqu (7 * 16)(rio), x7;			\
+	vmovdqu (8 * 16)(rio), y0;			\
+	vmovdqu (9 * 16)(rio), y1;			\
+	vmovdqu (10 * 16)(rio), y2;			\
+	vmovdqu (11 * 16)(rio), y3;			\
+	vmovdqu (12 * 16)(rio), y4;			\
+	vmovdqu (13 * 16)(rio), y5;			\
+	vmovdqu (14 * 16)(rio), y6;			\
+	vmovdqu (15 * 16)(rio), y7;
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
+	vmovdqu x0, 0 * 16(mem_ab);			\
+	vmovdqu x1, 1 * 16(mem_ab);			\
+	vmovdqu x2, 2 * 16(mem_ab);			\
+	vmovdqu x3, 3 * 16(mem_ab);			\
+	vmovdqu x4, 4 * 16(mem_ab);			\
+	vmovdqu x5, 5 * 16(mem_ab);			\
+	vmovdqu x6, 6 * 16(mem_ab);			\
+	vmovdqu x7, 7 * 16(mem_ab);			\
+	vmovdqu y0, 0 * 16(mem_cd);			\
+	vmovdqu y1, 1 * 16(mem_cd);			\
+	vmovdqu y2, 2 * 16(mem_cd);			\
+	vmovdqu y3, 3 * 16(mem_cd);			\
+	vmovdqu y4, 4 * 16(mem_cd);			\
+	vmovdqu y5, 5 * 16(mem_cd);			\
+	vmovdqu y6, 6 * 16(mem_cd);			\
+	vmovdqu y7, 7 * 16(mem_cd);
+
+/* de-byteslice, apply post-whitening and store blocks */
+#define outunpack16(x0, x1, x2, x3,			\
+		    x4, x5, x6, x7,			\
+		    y0, y1, y2, y3,			\
+		    y4, y5, y6, y7,			\
+		    mem_ab, mem_cd)			\
+	debyteslice_16x16b(y0, y4, x0, x4,		\
+			   y1, y5, x1, x5,		\
+			   y2, y6, x2, x6,		\
+			   y3, y7, x3, x7,		\
+			   (mem_ab), (mem_cd));		\
+	vmovdqu x0, 0 * 16(mem_ab);			\
+	vmovdqu x1, 1 * 16(mem_ab);			\
+	vmovdqu x2, 2 * 16(mem_ab);			\
+	vmovdqu x3, 3 * 16(mem_ab);			\
+	vmovdqu x4, 4 * 16(mem_ab);			\
+	vmovdqu x5, 5 * 16(mem_ab);			\
+	vmovdqu x6, 6 * 16(mem_ab);			\
+	vmovdqu x7, 7 * 16(mem_ab);			\
+	vmovdqu y0, 8 * 16(mem_ab);			\
+	vmovdqu y1, 9 * 16(mem_ab);			\
+	vmovdqu y2, 10 * 16(mem_ab);			\
+	vmovdqu y3, 11 * 16(mem_ab);			\
+	vmovdqu y4, 12 * 16(mem_ab);			\
+	vmovdqu y5, 13 * 16(mem_ab);			\
+	vmovdqu y6, 14 * 16(mem_ab);			\
+	vmovdqu y7, 15 * 16(mem_ab);			\
+
+#define aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, idx)		\
+	vmovdqu x0, ((idx + 0) * 16)(mem_tmp);		\
+	vmovdqu x1, ((idx + 1) * 16)(mem_tmp);		\
+	vmovdqu x2, ((idx + 2) * 16)(mem_tmp);		\
+	vmovdqu x3, ((idx + 3) * 16)(mem_tmp);		\
+	vmovdqu x4, ((idx + 4) * 16)(mem_tmp);		\
+	vmovdqu x5, ((idx + 5) * 16)(mem_tmp);		\
+	vmovdqu x6, ((idx + 6) * 16)(mem_tmp);		\
+	vmovdqu x7, ((idx + 7) * 16)(mem_tmp);
+
+#define aria_load_state_8way(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     mem_tmp, idx)		\
+	vmovdqu ((idx + 0) * 16)(mem_tmp), x0;		\
+	vmovdqu ((idx + 1) * 16)(mem_tmp), x1;		\
+	vmovdqu ((idx + 2) * 16)(mem_tmp), x2;		\
+	vmovdqu ((idx + 3) * 16)(mem_tmp), x3;		\
+	vmovdqu ((idx + 4) * 16)(mem_tmp), x4;		\
+	vmovdqu ((idx + 5) * 16)(mem_tmp), x5;		\
+	vmovdqu ((idx + 6) * 16)(mem_tmp), x6;		\
+	vmovdqu ((idx + 7) * 16)(mem_tmp), x7;
+
+#define aria_ark_8way(x0, x1, x2, x3,			\
+		      x4, x5, x6, x7,			\
+		      t0, rk, idx, round)		\
+	/* AddRoundKey */                               \
+	vpbroadcastb ((round * 16) + idx + 3)(rk), t0;	\
+	vpxor t0, x0, x0;				\
+	vpbroadcastb ((round * 16) + idx + 2)(rk), t0;	\
+	vpxor t0, x1, x1;				\
+	vpbroadcastb ((round * 16) + idx + 1)(rk), t0;	\
+	vpxor t0, x2, x2;				\
+	vpbroadcastb ((round * 16) + idx + 0)(rk), t0;	\
+	vpxor t0, x3, x3;				\
+	vpbroadcastb ((round * 16) + idx + 7)(rk), t0;	\
+	vpxor t0, x4, x4;				\
+	vpbroadcastb ((round * 16) + idx + 6)(rk), t0;	\
+	vpxor t0, x5, x5;				\
+	vpbroadcastb ((round * 16) + idx + 5)(rk), t0;	\
+	vpxor t0, x6, x6;				\
+	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
+	vpxor t0, x7, x7;
+
+#define aria_sbox_8way(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       t0, t1, t2, t3,			\
+		       t4, t5, t6, t7)			\
+	vpxor t0, t0, t0;				\
+	vaesenclast t0, x0, x0;				\
+	vaesenclast t0, x4, x4;				\
+	vaesenclast t0, x1, x1;				\
+	vaesenclast t0, x5, x5;				\
+	vaesdeclast t0, x2, x2;				\
+	vaesdeclast t0, x6, x6;				\
+							\
+	/* AES inverse shift rows */			\
+	vmovdqa .Linv_shift_row, t0;			\
+	vmovdqa .Lshift_row, t1;			\
+	vpshufb t0, x0, x0;				\
+	vpshufb t0, x4, x4;				\
+	vpshufb t0, x1, x1;				\
+	vpshufb t0, x5, x5;				\
+	vpshufb t0, x3, x3;				\
+	vpshufb t0, x7, x7;				\
+	vpshufb t1, x2, x2;				\
+	vpshufb t1, x6, x6;				\
+							\
+	vmovdqa .Linv_lo, t0;				\
+	vmovdqa .Linv_hi, t1;				\
+	vmovdqa .Ltf_lo_s2, t2;				\
+	vmovdqa .Ltf_hi_s2, t3;				\
+	vmovdqa .Ltf_lo_x2, t4;				\
+	vmovdqa .Ltf_hi_x2, t5;				\
+	vbroadcastss .L0f0f0f0f, t6;			\
+							\
+	/* extract multiplicative inverse */		\
+	filter_8bit(x1, t0, t1, t6, t7);		\
+	/* affine transformation for S2 */		\
+	filter_8bit(x1, t2, t3, t6, t7);		\
+	/* extract multiplicative inverse */		\
+	filter_8bit(x5, t0, t1, t6, t7);		\
+	/* affine transformation for S2 */		\
+	filter_8bit(x5, t2, t3, t6, t7);		\
+							\
+	/* affine transformation for X2 */		\
+	filter_8bit(x3, t4, t5, t6, t7);		\
+	vpxor t7, t7, t7;				\
+	vaesenclast t7, x3, x3;				\
+	/* extract multiplicative inverse */		\
+	filter_8bit(x3, t0, t1, t6, t7);		\
+	/* affine transformation for X2 */		\
+	filter_8bit(x7, t4, t5, t6, t7);		\
+	vpxor t7, t7, t7;				\
+	vaesenclast t7, x7, x7;                         \
+	/* extract multiplicative inverse */		\
+	filter_8bit(x7, t0, t1, t6, t7);
+
+#define aria_diff_m(x0, x1, x2, x3,			\
+		    t0, t1, t2, t3)			\
+	/* T = rotr32(X, 8); */				\
+	/* X ^= T */					\
+	vpxor x0, x3, t0;				\
+	vpxor x1, x0, t1;				\
+	vpxor x2, x1, t2;				\
+	vpxor x3, x2, t3;				\
+	/* X = T ^ rotr(X, 16); */			\
+	vpxor t2, x0, x0;				\
+	vpxor x1, t3, t3;				\
+	vpxor t0, x2, x2;				\
+	vpxor t1, x3, x1;				\
+	vmovdqu t3, x3;
+
+#define aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7)			\
+	/* t1 ^= t2; */					\
+	vpxor y0, x4, x4;				\
+	vpxor y1, x5, x5;				\
+	vpxor y2, x6, x6;				\
+	vpxor y3, x7, x7;				\
+							\
+	/* t2 ^= t3; */					\
+	vpxor y4, y0, y0;				\
+	vpxor y5, y1, y1;				\
+	vpxor y6, y2, y2;				\
+	vpxor y7, y3, y3;				\
+							\
+	/* t0 ^= t1; */					\
+	vpxor x4, x0, x0;				\
+	vpxor x5, x1, x1;				\
+	vpxor x6, x2, x2;				\
+	vpxor x7, x3, x3;				\
+							\
+	/* t3 ^= t1; */					\
+	vpxor x4, y4, y4;				\
+	vpxor x5, y5, y5;				\
+	vpxor x6, y6, y6;				\
+	vpxor x7, y7, y7;				\
+							\
+	/* t2 ^= t0; */					\
+	vpxor x0, y0, y0;				\
+	vpxor x1, y1, y1;				\
+	vpxor x2, y2, y2;				\
+	vpxor x3, y3, y3;				\
+							\
+	/* t1 ^= t2; */					\
+	vpxor y0, x4, x4;				\
+	vpxor y1, x5, x5;				\
+	vpxor y2, x6, x6;				\
+	vpxor y3, x7, x7;
+
+#define aria_fe(x0, x1, x2, x3,				\
+		x4, x5, x6, x7,				\
+		y0, y1, y2, y3,				\
+		y4, y5, y6, y7,				\
+		mem_tmp, rk, round)			\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 8, round);		\
+							\
+	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_diff_m(x0, x1, x2, x3, y0, y1, y2, y3);	\
+	aria_diff_m(x4, x5, x6, x7, y0, y1, y2, y3);	\
+	aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, 8);		\
+							\
+	aria_load_state_8way(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     mem_tmp, 0);		\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 0, round);		\
+							\
+	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_diff_m(x0, x1, x2, x3, y0, y1, y2, y3);	\
+	aria_diff_m(x4, x5, x6, x7, y0, y1, y2, y3);	\
+	aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, 0);		\
+	aria_load_state_8way(y0, y1, y2, y3,		\
+			     y4, y5, y6, y7,		\
+			     mem_tmp, 8);		\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7);			\
+	/* aria_diff_byte() 				\
+	 * T3 = ABCD -> BADC 				\
+	 * T3 = y4, y5, y6, y7 -> y5, y4, y7, y6 	\
+	 * T0 = ABCD -> CDAB 				\
+	 * T0 = x0, x1, x2, x3 -> x2, x3, x0, x1 	\
+	 * T1 = ABCD -> DCBA 				\
+	 * T1 = x4, x5, x6, x7 -> x7, x6, x5, x4	\
+	 */						\
+	aria_diff_word(x2, x3, x0, x1,			\
+		       x7, x6, x5, x4,			\
+		       y0, y1, y2, y3,			\
+		       y5, y4, y7, y6);			\
+	aria_store_state_8way(x3, x2, x1, x0,		\
+			      x6, x7, x4, x5,		\
+			      mem_tmp, 0);
+
+#define aria_fo(x0, x1, x2, x3,				\
+		x4, x5, x6, x7,				\
+		y0, y1, y2, y3,				\
+		y4, y5, y6, y7,				\
+		mem_tmp, rk, round)			\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 8, round);		\
+							\
+	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_diff_m(x0, x1, x2, x3, y0, y1, y2, y3);	\
+	aria_diff_m(x4, x5, x6, x7, y0, y1, y2, y3);	\
+	aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, 8);		\
+							\
+	aria_load_state_8way(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     mem_tmp, 0);		\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 0, round);		\
+							\
+	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_diff_m(x0, x1, x2, x3, y0, y1, y2, y3);	\
+	aria_diff_m(x4, x5, x6, x7, y0, y1, y2, y3);	\
+	aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, 0);		\
+	aria_load_state_8way(y0, y1, y2, y3,		\
+			     y4, y5, y6, y7,		\
+			     mem_tmp, 8);		\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x4, x5, x6, x7,			\
+		       y0, y1, y2, y3,			\
+		       y4, y5, y6, y7);			\
+	/* aria_diff_byte() 				\
+	 * T1 = ABCD -> BADC 				\
+	 * T1 = x4, x5, x6, x7 -> x5, x4, x7, x6	\
+	 * T2 = ABCD -> CDAB 				\
+	 * T2 = y0, y1, y2, y3, -> y2, y3, y0, y1 	\
+	 * T3 = ABCD -> DCBA 				\
+	 * T3 = y4, y5, y6, y7 -> y7, y6, y5, y4 	\
+	 */						\
+	aria_diff_word(x0, x1, x2, x3,			\
+		       x5, x4, x7, x6,			\
+		       y2, y3, y0, y1,			\
+		       y7, y6, y5, y4);			\
+	aria_store_state_8way(x3, x2, x1, x0,		\
+			      x6, x7, x4, x5,		\
+			      mem_tmp, 0);
+
+#define aria_ff(x0, x1, x2, x3,				\
+		x4, x5, x6, x7,				\
+		y0, y1, y2, y3,				\
+		y4, y5, y6, y7,				\
+		mem_tmp, rk, round, last_round)		\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 8, round);		\
+							\
+	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 8, last_round);		\
+							\
+	aria_store_state_8way(x0, x1, x2, x3,		\
+			      x4, x5, x6, x7,		\
+			      mem_tmp, 8);		\
+							\
+	aria_load_state_8way(x0, x1, x2, x3,		\
+			     x4, x5, x6, x7,		\
+			     mem_tmp, 0);		\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 0, round);		\
+							\
+	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
+		       y0, y1, y2, y3, y4, y5, y6, y7);	\
+							\
+	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
+		      y0, rk, 0, last_round);		\
+							\
+	aria_load_state_8way(y0, y1, y2, y3,		\
+			     y4, y5, y6, y7,		\
+			     mem_tmp, 8);
+
+/* NB: section is mergeable, all elements must be aligned 16-byte blocks */
+.section	.rodata.cst16, "aM", @progbits, 16
+.align 16
+
+#define SHUFB_BYTES(idx) \
+	0 + (idx), 4 + (idx), 8 + (idx), 12 + (idx)
+
+.Lshufb_16x16b:
+	.byte SHUFB_BYTES(0), SHUFB_BYTES(1), SHUFB_BYTES(2), SHUFB_BYTES(3);
+/* For isolating SubBytes from AESENCLAST, inverse shift row */
+.Linv_shift_row:
+	.byte 0x00, 0x0d, 0x0a, 0x07, 0x04, 0x01, 0x0e, 0x0b
+	.byte 0x08, 0x05, 0x02, 0x0f, 0x0c, 0x09, 0x06, 0x03
+.Lshift_row:
+	.byte 0x00, 0x05, 0x0a, 0x0f, 0x04, 0x09, 0x0e, 0x03
+	.byte 0x08, 0x0d, 0x02, 0x07, 0x0c, 0x01, 0x06, 0x0b
+/* extract multiplicative inverse from subByte(x) */
+.Linv_lo:
+	.byte 0x05, 0x4f, 0x91, 0xdb, 0x2c, 0x66, 0xb8, 0xf2
+	.byte 0x57, 0x1d, 0xc3, 0x89, 0x7e, 0x34, 0xea, 0xa0
+.Linv_hi:
+	.byte 0x00, 0xa4, 0x49, 0xed, 0x92, 0x36, 0xdb, 0x7f
+	.byte 0x25, 0x81, 0x6c, 0xc8, 0xb7, 0x13, 0xfe, 0x5a
+.Ltf_lo_s2:
+	.byte 0xe2, 0x4e, 0x1f, 0xb3, 0x24, 0x88, 0xd9, 0x75
+	.byte 0x61, 0xcd, 0x9c, 0x30, 0xa7, 0x0b, 0x5a, 0xf6
+.Ltf_hi_s2:
+	.byte 0x00, 0x26, 0xa7, 0x81, 0xfb, 0xdd, 0x5c, 0x7a
+	.byte 0x5f, 0x79, 0xf8, 0xde, 0xa4, 0x82, 0x03, 0x25
+.Ltf_lo_x2:
+	.byte 0x2c, 0xf4, 0x14, 0xcc, 0x56, 0x8e, 0x6e, 0xb6
+	.byte 0xed, 0x35, 0xd5, 0x0d, 0x97, 0x4f, 0xaf, 0x77
+.Ltf_hi_x2:
+	.byte 0x00, 0x75, 0x52, 0x27, 0xae, 0xdb, 0xfc, 0x89
+	.byte 0xe8, 0x9d, 0xba, 0xcf, 0x46, 0x33, 0x14, 0x61
+
+/* 4-bit mask */
+.section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
+.align 4
+.L0f0f0f0f:
+	.long 0x0f0f0f0f
+
+.text
+
+.align 8
+SYM_FUNC_START(aria_aesni_avx_crypt_16way)
+	/* input:
+	*      %rdi: rk
+	*      %rsi: dst
+	*      %rdx: src
+	*      %rcx: rounds
+	*/
+
+	FRAME_BEGIN
+
+	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		     %xmm15, %rdx);
+
+	movq	%rsi, %rax;
+	leaq 8 * 16(%rax), %r8;
+
+	inpack16_post(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		      %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		      %xmm15, %rax, %r8);
+	aria_fo(%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 0);
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 1);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 2);
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 3);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 4);
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 5);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 6);
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 7);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 8);
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 9);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 10);
+	cmp $12, %rcx;
+	jne .Laria192;
+	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 11, 12);
+	jmp .Laria_end;
+.Laria192:
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 11);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 12);
+	cmp $14, %rcx;
+	jne .Laria256;
+	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 13, 14);
+	jmp .Laria_end;
+.Laria256:
+	aria_fe(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 13);
+	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
+		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+		%rax, %rdi, 14);
+	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		%xmm15, %rax, %rdi, 15, 16);
+.Laria_end:
+	outunpack16(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
+		    %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
+		    %xmm15, %rax, %r8);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(aria_aesni_avx_crypt_16way)
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
new file mode 100644
index 000000000000..535b4dac5b1c
--- /dev/null
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -0,0 +1,165 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Glue Code for the AVX assembler implementation of the ARIA Cipher
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
+
+asmlinkage void aria_aesni_avx_crypt_16way(const u32 *rk, u8 *dst,
+					  const u8 *src, int rounds);
+
+static int ecb_do_encrypt(struct skcipher_request *req, const u32 *rkey)
+{
+	struct aria_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
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
+		kernel_fpu_begin();
+		while (nbytes >= ARIA_AVX_BLOCK_SIZE) {
+			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
+			dst += ARIA_AVX_BLOCK_SIZE;
+			src += ARIA_AVX_BLOCK_SIZE;
+			nbytes -= ARIA_AVX_BLOCK_SIZE;
+		}
+		kernel_fpu_end();
+		while (nbytes >= ARIA_BLOCK_SIZE) {
+			aria_encrypt(ctx, dst, src);
+			dst += ARIA_BLOCK_SIZE;
+			src += ARIA_BLOCK_SIZE;
+			nbytes -= ARIA_BLOCK_SIZE;
+		}
+
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+
+	return err;
+}
+
+static int ecb_do_decrypt(struct skcipher_request *req, const u32 *rkey)
+{
+	struct aria_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
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
+		while (nbytes >= ARIA_AVX_BLOCK_SIZE) {
+			kernel_fpu_begin();
+			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
+			kernel_fpu_end();
+			dst += ARIA_AVX_BLOCK_SIZE;
+			src += ARIA_AVX_BLOCK_SIZE;
+			nbytes -= ARIA_AVX_BLOCK_SIZE;
+		}
+		while (nbytes >= ARIA_BLOCK_SIZE) {
+			aria_decrypt(ctx, dst, src);
+			dst += ARIA_BLOCK_SIZE;
+			src += ARIA_BLOCK_SIZE;
+			nbytes -= ARIA_BLOCK_SIZE;
+		}
+
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+
+	return err;
+}
+
+static int aria_avx_ecb_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return ecb_do_encrypt(req, ctx->enc_key[0]);
+}
+
+static int aria_avx_ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return ecb_do_decrypt(req, ctx->dec_key[0]);
+}
+
+static int aria_avx_set_key(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	return aria_set_key(&tfm->base, key, keylen);
+}
+
+static struct skcipher_alg aria_algs[] = {
+	{
+		.base.cra_name		= "__ecb(aria)",
+		.base.cra_driver_name	= "__ecb-aria-avx",
+		.base.cra_priority	= 400,
+		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct aria_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= ARIA_MIN_KEY_SIZE,
+		.max_keysize		= ARIA_MAX_KEY_SIZE,
+		.setkey			= aria_avx_set_key,
+		.encrypt		= aria_avx_ecb_encrypt,
+		.decrypt		= aria_avx_ecb_decrypt,
+	}
+};
+
+static struct simd_skcipher_alg *aria_simd_algs[ARRAY_SIZE(aria_algs)];
+
+static int __init aria_avx_init(void)
+{
+	const char *feature_name;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX) ||
+	    !boot_cpu_has(X86_FEATURE_AES) ||
+	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		pr_info("AVX or AES-NI instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
+				&feature_name)) {
+		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+		return -ENODEV;
+	}
+
+	return simd_register_skciphers_compat(aria_algs,
+					      ARRAY_SIZE(aria_algs),
+					      aria_simd_algs);
+}
+
+static void __exit aria_avx_exit(void)
+{
+	simd_unregister_skciphers(aria_algs, ARRAY_SIZE(aria_algs),
+				  aria_simd_algs);
+}
+
+module_init(aria_avx_init);
+module_exit(aria_avx_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Taehee Yoo <ap420073@gmail.com>");
+MODULE_DESCRIPTION("ARIA Cipher Algorithm, AVX/AES-NI optimized");
+MODULE_ALIAS_CRYPTO("aria");
+MODULE_ALIAS_CRYPTO("aria-aesni-avx");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b1ccf873779d..cd63ea83ddd7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1659,6 +1659,27 @@ config CRYPTO_ARIA
 	  See also:
 	  <https://seed.kisa.or.kr/kisa/algorithm/EgovAriaInfo.do>
 
+config CRYPTO_ARIA_AESNI_AVX_X86_64
+	tristate "ARIA cipher algorithm (x86_64/AES-NI/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_SKCIPHER
+	select CRYPTO_ARIA
+	select CRYPTO_SIMD
+	help
+	  ARIA cipher algorithm (RFC5794).
+
+	  ARIA is a standard encryption algorithm of the Republic of Korea.
+	  The ARIA specifies three key sizes and rounds.
+	  128-bit: 12 rounds.
+	  192-bit: 14 rounds.
+	  256-bit: 16 rounds.
+
+	  This module provides the ARIA cipher algorithm that processes
+	  sixteen blocks parallel using the AVX instruction set.
+
+	  See also:
+	  <https://seed.kisa.or.kr/kisa/algorithm/EgovAriaInfo.do>
+
 config CRYPTO_SERPENT
 	tristate "Serpent cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
2.17.1

