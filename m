Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5E3C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 23:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345624AbiBJX2t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:28:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345662AbiBJX2n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 18:28:43 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB5155AD
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b64-20020a256743000000b0061e169a5f19so14848559ybc.11
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=soq/cMDceqpHK6l+rLfyragElya1D0Uy3uvOnbLDSs8=;
        b=N9Dp6vKH05G7p3rbZuDVzS+TfV9mqFDQlDNtQ5abx9+01Zc0we8vE8pGmYv+vwBU0R
         fXE/AdNvZNd53sJjD3VNh1QwfBAdMJsqppzdceVM8ftPG5YmhvQ3BQeb+BN8da7ZpCUJ
         0LFXFrnh1CLRkk8dReU2CefhfnSNHvEexTYlyMm4hi90QuClvkpVYBdjpWsLuHjUJvBf
         AM5gCnAKheqsAFrM2yTQ+qt7hyGkJhGFO752Dw7DKLE/oFN7D1bTx24Xsstge2rSCCVK
         2bWqf0qx5kXKkTnGRvQxnnBwQA0RRTN8XaqLJbvmrsulMfvczwje3EcSPWzouXXMnohm
         en4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=soq/cMDceqpHK6l+rLfyragElya1D0Uy3uvOnbLDSs8=;
        b=20JAZmyNcjhVwpZwy6g8sO9Cf8tkQk9ZTEnEs+WK/3PZMQpn3z6Dxf38amFCZaBv1U
         AsXofQ3kigKyCrpbfBUBuF5cBhrnUbvrYXzQsmbPKK0dX/mawJvLOdNfy7FAACkvSggf
         epKLLbwOcLCpDhTjkvb0BTd9EfP4EKwh/xTCWQMVaA2n8WE+OWIG9lTRZ6nUMjnjPwly
         5sGcG1EMSJAXiVclG8pW3XB9hDN9DnV3IU/ypqGRzzVqjlrgsEA0I8QwYmV+eVKvxlhX
         QjHcdUktzGi5QoFY1vJttExcxa634H0UPXyLxOddl5YLBhPB6rRXFy72/du43kqFbOfc
         dfRw==
X-Gm-Message-State: AOAM530pu4uVtFOPb+KJoGtf0GQZIaD0i/FAIO6FzcNF9oJyNNOxyiyN
        FhhYFe3/vnlqG5cZ9Ua0EXp4XiCPuJy7B+EfjCejkIynhszYSqderjTwb3yy18115R6njE0hhqS
        3Ah0EZxjQDFHcq50dQDFZR0pbe21aVoNMQVkTNve08o1VRmhOVwWy7U55puwZfsjwViU=
X-Google-Smtp-Source: ABdhPJwNhJS8k8RzDgL7Swt/Z/IDZVUsu+Wmug64KapcqaducWVGvQvQJB0B0bJDfsJPg8fzZXDDlPOFgA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:7415:: with SMTP id p21mr9191014ybc.162.1644535722334;
 Thu, 10 Feb 2022 15:28:42 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:28:09 +0000
In-Reply-To: <20220210232812.798387-1-nhuck@google.com>
Message-Id: <20220210232812.798387-5-nhuck@google.com>
Mime-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC PATCH v2 4/7] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
support.  These implementations are modified versions of the CTR
implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.

More information on XCTR can be found in the HCTR2 paper:
Length-preserving encryption with HCTR2:
https://enterprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---

Changes since v1:
 * Changed ctr32 from u32 to __le32
 * Removed references to u32_to_le_block

 arch/x86/crypto/Makefile                 |   2 +-
 arch/x86/crypto/aes_xctrby8_avx-x86_64.S | 529 +++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_asm.S        |  70 +++
 arch/x86/crypto/aesni-intel_glue.c       |  89 ++++
 4 files changed, 689 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/crypto/aes_xctrby8_avx-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 2831685adf6f..ee2df489b0d9 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -48,7 +48,7 @@ chacha-x86_64-$(CONFIG_AS_AVX512) += chacha-avx512vl-x86_64.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
-aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
+aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o aes_xctrby8_avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/aes_xctrby8_avx-x86_64.S b/arch/x86/crypto/aes_xctrby8_avx-x86_64.S
new file mode 100644
index 000000000000..53d70cab9474
--- /dev/null
+++ b/arch/x86/crypto/aes_xctrby8_avx-x86_64.S
@@ -0,0 +1,529 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+/*
+ * AES XCTR mode by8 optimization with AVX instructions. (x86_64)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Chandramouli Narayanan <mouli@linux.intel.com>
+ */
+/*
+ * Implement AES XCTR mode with AVX instructions. This code is a modified
+ * version of the Linux kernel's AES CTR by8 implementation.
+ *
+ * This is AES128/192/256 XCTR mode optimization implementation. It requires
+ * the support of Intel(R) AESNI and AVX instructions.
+ *
+ * This work was inspired by the AES XCTR mode optimization published
+ * in Intel Optimized IPSEC Cryptographic library.
+ * Additional information on it can be found at:
+ *    https://github.com/intel/intel-ipsec-mb
+ */
+
+#include <linux/linkage.h>
+
+#define VMOVDQ		vmovdqu
+
+#define xdata0		%xmm0
+#define xdata1		%xmm1
+#define xdata2		%xmm2
+#define xdata3		%xmm3
+#define xdata4		%xmm4
+#define xdata5		%xmm5
+#define xdata6		%xmm6
+#define xdata7		%xmm7
+#define xiv      	%xmm8
+#define xbyteswap	%xmm9
+#define xkey0		%xmm10
+#define xkey4		%xmm11
+#define xkey8		%xmm12
+#define xkey12          %xmm13
+#define xkeyA		%xmm14
+#define xkeyB		%xmm15
+
+#define p_in		%rdi
+#define p_iv		%rsi
+#define p_keys		%rdx
+#define p_out		%rcx
+#define num_bytes	%r8
+#define counter         %r9
+
+#define tmp		%r10
+#define	DDQ_DATA	0
+#define	XDATA		1
+#define KEY_128		1
+#define KEY_192		2
+#define KEY_256		3
+
+.section .rodata
+.align 16
+
+byteswap_const:
+	.octa 0x000102030405060708090A0B0C0D0E0F
+ddq_low_msk:
+	.octa 0x0000000000000000FFFFFFFFFFFFFFFF
+ddq_high_add_1:
+	.octa 0x00000000000000010000000000000000
+ddq_add_1:
+	.octa 0x00000000000000000000000000000001
+ddq_add_2:
+	.octa 0x00000000000000000000000000000002
+ddq_add_3:
+	.octa 0x00000000000000000000000000000003
+ddq_add_4:
+	.octa 0x00000000000000000000000000000004
+ddq_add_5:
+	.octa 0x00000000000000000000000000000005
+ddq_add_6:
+	.octa 0x00000000000000000000000000000006
+ddq_add_7:
+	.octa 0x00000000000000000000000000000007
+ddq_add_8:
+	.octa 0x00000000000000000000000000000008
+
+.text
+
+/* generate a unique variable for ddq_add_x */
+
+/* generate a unique variable for xmm register */
+.macro setxdata n
+	var_xdata = %xmm\n
+.endm
+
+/* club the numeric 'id' to the symbol 'name' */
+
+.macro club name, id
+.altmacro
+	.if \name == XDATA
+		setxdata %\id
+	.endif
+.noaltmacro
+.endm
+
+/*
+ * do_aes num_in_par load_keys key_len
+ * This increments p_in, but not p_out
+ */
+.macro do_aes b, k, key_len
+	.set by, \b
+	.set load_keys, \k
+	.set klen, \key_len
+
+	.set i, 0
+	.rept (by)
+		club XDATA, i
+		movq counter, var_xdata
+		.set i, (i +1)
+	.endr
+
+	.if (load_keys)
+		vmovdqa	0*16(p_keys), xkey0
+	.endif
+
+	// next two blocks compute iv ^ block_index
+	.set i, 0
+	.rept (by)
+		club XDATA, i
+		vpaddq	(ddq_add_1 + 16 * i)(%rip), var_xdata, var_xdata
+		.set i, (i +1)
+	.endr
+	.set i, 0
+	.rept (by)
+		club XDATA, i
+		vpxor xiv, var_xdata, var_xdata
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	1*16(p_keys), xkeyA
+
+	vpxor	xkey0, xdata0, xdata0
+	add $by, counter
+
+	.set i, 1
+	.rept (by - 1)
+		club XDATA, i
+		vpxor	xkey0, var_xdata, var_xdata
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	2*16(p_keys), xkeyB
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 1 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	3*16(p_keys), xkey4
+		.endif
+	.else
+		vmovdqa	3*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyB, var_xdata, var_xdata		/* key 2 */
+		.set i, (i +1)
+	.endr
+
+	add	$(16*by), p_in
+
+	.if (klen == KEY_128)
+		vmovdqa	4*16(p_keys), xkeyB
+	.else
+		.if (load_keys)
+			vmovdqa	4*16(p_keys), xkey4
+		.endif
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 3 */
+		.if (klen == KEY_128)
+			vaesenc	xkey4, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	5*16(p_keys), xkeyA
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 4 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey4, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	6*16(p_keys), xkey8
+		.endif
+	.else
+		vmovdqa	6*16(p_keys), xkeyB
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 5 */
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	7*16(p_keys), xkeyA
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 6 */
+		.if (klen == KEY_128)
+			vaesenc	xkey8, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		vmovdqa	8*16(p_keys), xkeyB
+	.else
+		.if (load_keys)
+			vmovdqa	8*16(p_keys), xkey8
+		.endif
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 7 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	9*16(p_keys), xkey12
+		.endif
+	.else
+		vmovdqa	9*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 8 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey8, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	10*16(p_keys), xkeyB
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 9 */
+		.if (klen == KEY_128)
+			vaesenc	xkey12, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	.if (klen != KEY_128)
+		vmovdqa	11*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 10 */
+		.if (klen == KEY_128)
+			vaesenclast	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	.if (klen != KEY_128)
+		.if (load_keys)
+			vmovdqa	12*16(p_keys), xkey12
+		.endif
+
+		.set i, 0
+		.rept by
+			club XDATA, i
+			vaesenc	xkeyA, var_xdata, var_xdata	/* key 11 */
+			.set i, (i +1)
+		.endr
+
+		.if (klen == KEY_256)
+			vmovdqa	13*16(p_keys), xkeyA
+		.endif
+
+		.set i, 0
+		.rept by
+			club XDATA, i
+			.if (klen == KEY_256)
+				/* key 12 */
+				vaesenc	xkey12, var_xdata, var_xdata
+			.else
+				vaesenclast xkey12, var_xdata, var_xdata
+			.endif
+			.set i, (i +1)
+		.endr
+
+		.if (klen == KEY_256)
+			vmovdqa	14*16(p_keys), xkeyB
+
+			.set i, 0
+			.rept by
+				club XDATA, i
+				/* key 13 */
+				vaesenc	xkeyA, var_xdata, var_xdata
+				.set i, (i +1)
+			.endr
+
+			.set i, 0
+			.rept by
+				club XDATA, i
+				/* key 14 */
+				vaesenclast	xkeyB, var_xdata, var_xdata
+				.set i, (i +1)
+			.endr
+		.endif
+	.endif
+
+	.set i, 0
+	.rept (by / 2)
+		.set j, (i+1)
+		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
+		VMOVDQ	(j*16 - 16*by)(p_in), xkeyB
+		club XDATA, i
+		vpxor	xkeyA, var_xdata, var_xdata
+		club XDATA, j
+		vpxor	xkeyB, var_xdata, var_xdata
+		.set i, (i+2)
+	.endr
+
+	.if (i < by)
+		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
+		club XDATA, i
+		vpxor	xkeyA, var_xdata, var_xdata
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		VMOVDQ	var_xdata, i*16(p_out)
+		.set i, (i+1)
+	.endr
+.endm
+
+.macro do_aes_load val, key_len
+	do_aes \val, 1, \key_len
+.endm
+
+.macro do_aes_noload val, key_len
+	do_aes \val, 0, \key_len
+.endm
+
+/* main body of aes xctr load */
+
+.macro do_aes_xctrmain key_len
+	andq	$(~0xf), num_bytes
+	cmp	$16, num_bytes
+	jb	.Ldo_return2\key_len
+
+	vmovdqa	byteswap_const(%rip), xbyteswap
+	shr	$4, counter
+	vmovdqu (p_iv), xiv
+
+	mov	num_bytes, tmp
+	and	$(7*16), tmp
+	jz	.Lmult_of_8_blks\key_len
+
+	/* 1 <= tmp <= 7 */
+	cmp	$(4*16), tmp
+	jg	.Lgt4\key_len
+	je	.Leq4\key_len
+
+.Llt4\key_len:
+	cmp	$(2*16), tmp
+	jg	.Leq3\key_len
+	je	.Leq2\key_len
+
+.Leq1\key_len:
+	do_aes_load	1, \key_len
+	add	$(1*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq2\key_len:
+	do_aes_load	2, \key_len
+	add	$(2*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+
+.Leq3\key_len:
+	do_aes_load	3, \key_len
+	add	$(3*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq4\key_len:
+	do_aes_load	4, \key_len
+	add	$(4*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Lgt4\key_len:
+	cmp	$(6*16), tmp
+	jg	.Leq7\key_len
+	je	.Leq6\key_len
+
+.Leq5\key_len:
+	do_aes_load	5, \key_len
+	add	$(5*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq6\key_len:
+	do_aes_load	6, \key_len
+	add	$(6*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq7\key_len:
+	do_aes_load	7, \key_len
+	add	$(7*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Lmult_of_8_blks\key_len:
+	.if (\key_len != KEY_128)
+		vmovdqa	0*16(p_keys), xkey0
+		vmovdqa	4*16(p_keys), xkey4
+		vmovdqa	8*16(p_keys), xkey8
+		vmovdqa	12*16(p_keys), xkey12
+	.else
+		vmovdqa	0*16(p_keys), xkey0
+		vmovdqa	3*16(p_keys), xkey4
+		vmovdqa	6*16(p_keys), xkey8
+		vmovdqa	9*16(p_keys), xkey12
+	.endif
+.align 16
+.Lmain_loop2\key_len:
+	/* num_bytes is a multiple of 8 and >0 */
+	do_aes_noload	8, \key_len
+	add	$(8*16), p_out
+	sub	$(8*16), num_bytes
+	jne	.Lmain_loop2\key_len
+
+.Ldo_return2\key_len:
+	ret
+.endm
+
+/*
+ * routine to do AES128 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_128_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_128_avx_by8)
+	/* call the aes main loop */
+	do_aes_xctrmain KEY_128
+
+SYM_FUNC_END(aes_xctr_enc_128_avx_by8)
+
+/*
+ * routine to do AES192 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_192_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_192_avx_by8)
+	/* call the aes main loop */
+	do_aes_xctrmain KEY_192
+
+SYM_FUNC_END(aes_xctr_enc_192_avx_by8)
+
+/*
+ * routine to do AES256 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_256_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_256_avx_by8)
+	/* call the aes main loop */
+	do_aes_xctrmain KEY_256
+
+SYM_FUNC_END(aes_xctr_enc_256_avx_by8)
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 363699dd7220..ce17fe630150 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2821,6 +2821,76 @@ SYM_FUNC_END(aesni_ctr_enc)
 
 #endif
 
+#ifdef __x86_64__
+/*
+ * void aesni_xctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv, int byte_ctr)
+ */
+SYM_FUNC_START(aesni_xctr_enc)
+	FRAME_BEGIN
+	cmp $16, LEN
+	jb .Lxctr_ret
+	shr	$4, %arg6
+	movq %arg6, CTR
+	mov 480(KEYP), KLEN
+	movups (IVP), IV
+	cmp $64, LEN
+	jb .Lxctr_enc_loop1
+.align 4
+.Lxctr_enc_loop4:
+	movaps IV, STATE1
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE1, STATE1
+	movups (INP), IN1
+	movaps IV, STATE2
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE2, STATE2
+	movups 0x10(INP), IN2
+	movaps IV, STATE3
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE3, STATE3
+	movups 0x20(INP), IN3
+	movaps IV, STATE4
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE4, STATE4
+	movups 0x30(INP), IN4
+	call _aesni_enc4
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+	pxor IN2, STATE2
+	movups STATE2, 0x10(OUTP)
+	pxor IN3, STATE3
+	movups STATE3, 0x20(OUTP)
+	pxor IN4, STATE4
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lxctr_enc_loop4
+	cmp $16, LEN
+	jb .Lxctr_ret
+.align 4
+.Lxctr_enc_loop1:
+	movaps IV, STATE
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE1, STATE1
+	movups (INP), IN
+	call _aesni_enc1
+	pxor IN, STATE
+	movups STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lxctr_enc_loop1
+.Lxctr_ret:
+	FRAME_END
+	RET
+SYM_FUNC_END(aesni_xctr_enc)
+
+#endif
+
 .section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
 .align 16
 .Lgf128mul_x_ble_mask:
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 41901ba9d3a2..74021bd524b6 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -112,6 +112,11 @@ asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 DEFINE_STATIC_CALL(aesni_ctr_enc_tfm, aesni_ctr_enc);
 
+asmlinkage void aesni_xctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			       const u8 *in, unsigned int len, u8 *iv,
+			       unsigned int byte_ctr);
+DEFINE_STATIC_CALL(aesni_xctr_enc_tfm, aesni_xctr_enc);
+
 /* Scatter / Gather routines, with args similar to above */
 asmlinkage void aesni_gcm_init(void *ctx,
 			       struct gcm_context_data *gdata,
@@ -135,6 +140,16 @@ asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
 asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
+
+asmlinkage void aes_xctr_enc_128_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_192_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_256_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
 /*
  * asmlinkage void aesni_gcm_init_avx_gen2()
  * gcm_data *my_ctx_data, context data
@@ -527,6 +542,61 @@ static int ctr_crypt(struct skcipher_request *req)
 	return err;
 }
 
+static void aesni_xctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out, const u8
+				   *in, unsigned int len, u8 *iv, unsigned int
+				   byte_ctr)
+{
+	if (ctx->key_length == AES_KEYSIZE_128)
+		aes_xctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else if (ctx->key_length == AES_KEYSIZE_192)
+		aes_xctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else
+		aes_xctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+}
+
+static int xctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	u8 keystream[AES_BLOCK_SIZE];
+	u8 ctr[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	unsigned int byte_ctr = 0;
+	int err;
+	__le32 ctr32;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while ((nbytes = walk.nbytes) > 0) {
+		kernel_fpu_begin();
+		if (nbytes & AES_BLOCK_MASK)
+			static_call(aesni_xctr_enc_tfm)(ctx, walk.dst.virt.addr,
+				walk.src.virt.addr, nbytes & AES_BLOCK_MASK,
+				walk.iv, byte_ctr);
+		nbytes &= ~AES_BLOCK_MASK;
+		byte_ctr += walk.nbytes - nbytes;
+
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			ctr32 = cpu_to_le32(byte_ctr / AES_BLOCK_SIZE + 1);
+			memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
+			crypto_xor(ctr, (u8 *)&ctr32, sizeof(ctr32));
+			aesni_enc(ctx, keystream, ctr);
+			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes -
+				       nbytes, walk.src.virt.addr + walk.nbytes
+				       - nbytes, keystream, nbytes);
+			byte_ctr += nbytes;
+			nbytes = 0;
+		}
+		kernel_fpu_end();
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+	return err;
+}
+
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
@@ -1026,6 +1096,23 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
+	}, {
+		.base = {
+			.cra_name		= "__xctr(aes)",
+			.cra_driver_name	= "__xctr-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= xctr_crypt,
+		.decrypt	= xctr_crypt,
 #endif
 	}, {
 		.base = {
@@ -1162,6 +1249,8 @@ static int __init aesni_init(void)
 		/* optimize performance of ctr mode encryption transform */
 		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
+		static_call_update(aesni_xctr_enc_tfm, aesni_xctr_enc_avx_tfm);
+		pr_info("AES XCTR mode by8 optimization enabled\n");
 	}
 #endif
 
-- 
2.35.1.265.g69c8d7142f-goog

