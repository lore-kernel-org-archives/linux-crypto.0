Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1D3C35270
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B9024D45
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgLPRrX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:47:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:21277 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgLPRrX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:47:23 -0500
IronPort-SDR: p+yBueh+aVfr5Ym399EVPdZWE2YVW3ar4yYmYuVV+pRZEfEXjgJjBNSM5RpsOTztgdILBpoILd
 I5JAkCfLAulg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171593450"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="171593450"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:14 -0800
IronPort-SDR: QhxffoV/E1PAAqd0iiMGem9EA7G+6FwS3ngdS/hQgulntfHqeS1LKJgVaqfRANOeOweNNzYQeh
 LNIS6Ua04X3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854232"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:13 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using Key Locker instructions
Date:   Wed, 16 Dec 2020 09:41:45 -0800
Message-Id: <20201216174146.10446-8-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Key Locker (KL) is Intel's new security feature that protects the AES key
at the time of data transformation. New AES SIMD instructions -- as a
successor of Intel's AES-NI -- are provided to encode an AES key and
reference it for the AES algorithm.

New instructions support 128/256-bit keys. While it is not desirable to
receive any 192-bit key, AES-NI instructions are taken to serve this size.

New instructions are operational in both 32-/64-bit modes.

Add a set of new macros for the new instructions so that no new binutils
version is required.

Implemented methods are for a single block as well as ECB, CBC, CTR, and
XTS modes. The methods are not compatible with other AES implementations as
accessing an encrypted key instead of the normal AES key.

setkey() call encodes an AES key. User may displace the AES key once
encoded, as encrypt()/decrypt() methods do not need the key.

Most C code follows the AES-NI implementation. It has higher priority than
the AES-NI as providing key protection.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/crypto/Makefile           |   3 +
 arch/x86/crypto/aeskl-intel_asm.S  | 881 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c | 697 +++++++++++++++++++++++
 arch/x86/include/asm/inst.h        | 201 +++++++
 crypto/Kconfig                     |  28 +
 5 files changed, 1810 insertions(+)
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a31de0c6ccde..8e2e34e73a21 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -54,6 +54,9 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 
+obj-$(CONFIG_CRYPTO_AES_KL) += aeskl-intel.o
+aeskl-intel-y := aeskl-intel_asm.o aesni-intel_asm.o aeskl-intel_glue.o
+
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
 sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
new file mode 100644
index 000000000000..80ddeda11bdf
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -0,0 +1,881 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Implement AES algorithm using Intel AES Key Locker instructions.
+ *
+ * Most codes are based from AES-NI implementation, aesni-intel_asm.S
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+#include <asm/frame.h>
+
+#define STATE1	%xmm0
+#define STATE2	%xmm1
+#define STATE3	%xmm2
+#define STATE4	%xmm3
+#define STATE5	%xmm4
+#define STATE6	%xmm5
+#define STATE7	%xmm6
+#define STATE8	%xmm7
+#define STATE	STATE1
+
+#ifdef __x86_64__
+#define IN1	%xmm8
+#define IN2	%xmm9
+#define IN3	%xmm10
+#define IN4	%xmm11
+#define IN5	%xmm12
+#define IN6	%xmm13
+#define IN7	%xmm14
+#define IN8	%xmm15
+#define IN	IN1
+#else
+#define IN	%xmm1
+#endif
+
+#ifdef __x86_64__
+#define AREG	%rax
+#define HANDLEP	%rdi
+#define OUTP	%rsi
+#define KLEN	%r9d
+#define INP	%rdx
+#define T1	%r10
+#define LEN	%rcx
+#define IVP	%r8
+#else
+#define AREG	%eax
+#define HANDLEP	%edi
+#define OUTP	AREG
+#define KLEN	%ebx
+#define INP	%edx
+#define T1    %ecx
+#define LEN %esi
+#define IVP %ebp
+#endif
+
+#define UKEYP OUTP
+
+/*
+ * int __aeskl_setkey(struct crypto_aes_ctx *ctx,
+ *		      const u8 *in_key,
+ *		      unsigned int key_len)
+ */
+SYM_FUNC_START(__aeskl_setkey)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	push HANDLEP
+	movl (FRAME_OFFSET+8)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+12)(%esp), UKEYP	# in_key
+	movl (FRAME_OFFSET+16)(%esp), %edx	# key_len
+#endif
+	movl %edx, 480(HANDLEP)
+	movdqu (UKEYP), STATE1
+	mov $1, %eax
+	cmp $16, %dl
+	je .Lsetkey_128
+
+	movdqu 0x10(UKEYP), STATE2
+	ENCODEKEY256 %eax, %eax
+	movdqu STATE4, 0x30(HANDLEP)
+	jmp .Lsetkey_end
+.Lsetkey_128:
+	ENCODEKEY128 %eax, %eax
+
+.Lsetkey_end:
+	movdqu STATE1, (HANDLEP)
+	movdqu STATE2, 0x10(HANDLEP)
+	movdqu STATE3, 0x20(HANDLEP)
+
+	xor AREG, AREG
+#ifndef __x86_64__
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_setkey)
+
+/*
+ * int __aeskl_enc1(const void *ctx,
+ *		    u8 *dst,
+ *		    const u8 *src)
+ */
+SYM_FUNC_START(__aeskl_enc1)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+12)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+16)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+20)(%esp), INP	# src
+#endif
+	movdqu (INP), STATE
+	movl 480(HANDLEP), KLEN
+
+	cmp $16, KLEN
+	je .Lenc_128
+	AESENC256KL HANDLEP, STATE
+	jz .Lenc_err
+	jmp .Lenc_noerr
+.Lenc_128:
+	AESENC128KL HANDLEP, STATE
+	jz .Lenc_err
+
+.Lenc_noerr:
+	xor AREG, AREG
+	jmp .Lenc_end
+.Lenc_err:
+	mov $1, AREG
+.Lenc_end:
+	movdqu STATE, (OUTP)
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_enc1)
+
+/*
+ * int __aeskl_dec1(const void *ctx,
+ *		    u8 *dst,
+ *		    const u8 *src)
+ */
+SYM_FUNC_START(__aeskl_dec1)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+12)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+16)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+20)(%esp), INP	# src
+#endif
+	movdqu (INP), STATE
+	mov 480(HANDLEP), KLEN
+
+	cmp $16, KLEN
+	je .Ldec_128
+	AESDEC256KL HANDLEP, STATE
+	jz .Ldec_err
+	jmp .Ldec_noerr
+.Ldec_128:
+	AESDEC128KL HANDLEP, STATE
+	jz .Ldec_err
+
+.Ldec_noerr:
+	xor AREG, AREG
+	jmp .Ldec_end
+.Ldec_err:
+	mov $1, AREG
+.Ldec_end:
+	movdqu STATE, (OUTP)
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_dec1)
+
+/*
+ * int __aeskl_ecb_enc(struct crypto_aes_ctx *ctx,
+ *		       const u8 *dst,
+ *		       u8 *src,
+ *		       size_t len)
+ */
+SYM_FUNC_START(__aeskl_ecb_enc)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+16)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+24)(%esp), INP	# src
+	movl (FRAME_OFFSET+28)(%esp), LEN	# len
+#endif
+	test LEN, LEN
+	jz .Lecb_enc_noerr
+	mov 480(HANDLEP), KLEN
+	cmp $16, LEN
+	jb .Lecb_enc_noerr
+	cmp $128, LEN
+	jb .Lecb_enc1
+
+.align 4
+.Lecb_enc8:
+	movdqu (INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	cmp $16, KLEN
+	je .Lecb_enc8_128
+	AESENCWIDE256KL HANDLEP
+	jz .Lecb_enc_err
+	jmp .Lecb_enc8_end
+.Lecb_enc8_128:
+	AESENCWIDE128KL HANDLEP
+	jz .Lecb_enc_err
+
+.Lecb_enc8_end:
+	movdqu STATE1, (OUTP)
+	movdqu STATE2, 0x10(OUTP)
+	movdqu STATE3, 0x20(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+	movdqu STATE5, 0x40(OUTP)
+	movdqu STATE6, 0x50(OUTP)
+	movdqu STATE7, 0x60(OUTP)
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lecb_enc8
+	cmp $16, LEN
+	jb .Lecb_enc_noerr
+
+.align 4
+.Lecb_enc1:
+	movdqu (INP), STATE1
+	cmp $16, KLEN
+	je .Lecb_enc1_128
+	AESENC256KL HANDLEP, STATE
+	jz .Lecb_enc_err
+	jmp .Lecb_enc1_end
+.Lecb_enc1_128:
+	AESENC128KL HANDLEP, STATE
+	jz .Lecb_enc_err
+
+.Lecb_enc1_end:
+	movdqu STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_enc1
+
+.Lecb_enc_noerr:
+	xor AREG, AREG
+	jmp .Lecb_enc_end
+.Lecb_enc_err:
+	mov $1, AREG
+.Lecb_enc_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_ecb_enc)
+
+/*
+ * int __aeskl_ecb_dec(struct crypto_aes_ctx *ctx,
+ *		       const u8 *dst,
+ *		       u8 *src,
+ *		       size_t len);
+ */
+SYM_FUNC_START(__aeskl_ecb_dec)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+16)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+24)(%esp), INP	# src
+	movl (FRAME_OFFSET+28)(%esp), LEN	# len
+#endif
+
+	test LEN, LEN
+	jz .Lecb_dec_noerr
+	mov 480(HANDLEP), KLEN
+	cmp $16, LEN
+	jb .Lecb_dec_noerr
+	cmp $128, LEN
+	jb .Lecb_dec1
+
+.align 4
+.Lecb_dec8:
+	movdqu (INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	cmp $16, KLEN
+	je .Lecb_dec8_128
+	AESDECWIDE256KL HANDLEP
+	jz .Lecb_dec_err
+	jmp .Lecb_dec8_end
+.Lecb_dec8_128:
+	AESDECWIDE128KL HANDLEP
+	jz .Lecb_dec_err
+
+.Lecb_dec8_end:
+	movdqu STATE1, (OUTP)
+	movdqu STATE2, 0x10(OUTP)
+	movdqu STATE3, 0x20(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+	movdqu STATE5, 0x40(OUTP)
+	movdqu STATE6, 0x50(OUTP)
+	movdqu STATE7, 0x60(OUTP)
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lecb_dec8
+	cmp $16, LEN
+	jb .Lecb_dec_noerr
+
+.align 4
+.Lecb_dec1:
+	movdqu (INP), STATE1
+	cmp $16, KLEN
+	je .Lecb_dec1_128
+	AESDEC256KL HANDLEP, STATE
+	jz .Lecb_dec_err
+	jmp .Lecb_dec1_end
+.Lecb_dec1_128:
+	AESDEC128KL HANDLEP, STATE
+	jz .Lecb_dec_err
+
+.Lecb_dec1_end:
+	movdqu STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_dec1
+
+.Lecb_dec_noerr:
+	xor AREG, AREG
+	jmp .Lecb_dec_end
+.Lecb_dec_err:
+	mov $1, AREG
+.Lecb_dec_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_ecb_dec)
+
+/*
+ * int __aeskl_cbc_enc(struct crypto_aes_ctx *ctx,
+ *		       const u8 *dst,
+ *		       u8 *src,
+ *		       size_t len,
+ *		       u8 *iv)
+ */
+SYM_FUNC_START(__aeskl_cbc_enc)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
+#endif
+
+	cmp $16, LEN
+	jb .Lcbc_enc_noerr
+	mov 480(HANDLEP), KLEN
+	movdqu (IVP), STATE
+
+.align 4
+.Lcbc_enc1:
+	movdqu (INP), IN
+	pxor IN, STATE
+
+	cmp $16, KLEN
+	je .Lcbc_enc1_128
+	AESENC256KL HANDLEP, STATE
+	jz .Lcbc_enc_err
+	jmp .Lcbc_enc1_end
+.Lcbc_enc1_128:
+	AESENC128KL HANDLEP, STATE
+	jz .Lcbc_enc_err
+
+.Lcbc_enc1_end:
+	movdqu STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_enc1
+	movdqu STATE, (IVP)
+
+.Lcbc_enc_noerr:
+	xor AREG, AREG
+	jmp .Lcbc_enc_end
+.Lcbc_enc_err:
+	mov $1, AREG
+.Lcbc_enc_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_cbc_enc)
+
+/*
+ * int __aeskl_cbc_dec(struct crypto_aes_ctx *ctx,
+ *		       const u8 *dst,
+ *		       u8 *src,
+ *		       size_t len,
+ *		       u8 *iv)
+ */
+SYM_FUNC_START(__aeskl_cbc_dec)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
+#endif
+
+	cmp $16, LEN
+	jb .Lcbc_dec_noerr
+	mov 480(HANDLEP), KLEN
+#ifdef __x86_64__
+	cmp $128, LEN
+	jb .Lcbc_dec1_pre
+
+.align 4
+.Lcbc_dec8:
+	movdqu 0x0(INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	movdqu (IVP), IN1
+	movdqa STATE1, IN2
+	movdqa STATE2, IN3
+	movdqa STATE3, IN4
+	movdqa STATE4, IN5
+	movdqa STATE5, IN6
+	movdqa STATE6, IN7
+	movdqa STATE7, IN8
+	movdqu STATE8, (IVP)
+
+	cmp $16, KLEN
+	je .Lcbc_dec8_128
+	AESDECWIDE256KL HANDLEP
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec8_end
+.Lcbc_dec8_128:
+	AESDECWIDE128KL HANDLEP
+	jz .Lcbc_dec_err
+
+.Lcbc_dec8_end:
+	pxor IN1, STATE1
+	pxor IN2, STATE2
+	pxor IN3, STATE3
+	pxor IN4, STATE4
+	pxor IN5, STATE5
+	pxor IN6, STATE6
+	pxor IN7, STATE7
+	pxor IN8, STATE8
+
+	movdqu STATE1, 0x0(OUTP)
+	movdqu STATE2, 0x10(OUTP)
+	movdqu STATE3, 0x20(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+	movdqu STATE5, 0x40(OUTP)
+	movdqu STATE6, 0x50(OUTP)
+	movdqu STATE7, 0x60(OUTP)
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lcbc_dec8
+	cmp $16, LEN
+	jb .Lcbc_dec_noerr
+#endif
+
+.align 4
+.Lcbc_dec1_pre:
+	movdqu (IVP), STATE3
+.Lcbc_dec1:
+	movdqu (INP), STATE2
+	movdqa STATE2, STATE1
+
+	cmp $16, KLEN
+	je .Lcbc_dec1_128
+	AESDEC256KL HANDLEP, STATE1
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec1_end
+.Lcbc_dec1_128:
+	AESDEC128KL HANDLEP, STATE1
+	jz .Lcbc_dec_err
+
+.Lcbc_dec1_end:
+	pxor STATE3, STATE1
+	movdqu STATE1, (OUTP)
+	movdqa STATE2, STATE3
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_dec1
+	movdqu STATE3, (IVP)
+
+.Lcbc_dec_noerr:
+	xor AREG, AREG
+	jmp .Lcbc_dec_end
+.Lcbc_dec_err:
+	mov $1, AREG
+.Lcbc_dec_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_cbc_dec)
+
+
+#ifdef __x86_64__
+
+/*
+ * CTR implementations
+ */
+
+.pushsection .rodata
+.align 16
+.Lbswap_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.popsection
+
+.section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
+.align 16
+.Lgf128mul_x_ble_mask:
+	.octa 0x00000000000000010000000000000087
+
+#define BSWAP_MASK	%xmm10
+#define CTR		%xmm11
+#define INC		%xmm12
+#define IV		%xmm13
+#define TCTR_LOW	%r11
+
+.text
+.align 4
+__aeskl_ctr_init:
+	movdqa .Lbswap_mask, BSWAP_MASK
+	movdqa IV, CTR
+	pshufb BSWAP_MASK, CTR
+	mov $1, TCTR_LOW
+	movq TCTR_LOW, INC
+	movq CTR, TCTR_LOW
+	ret
+SYM_FUNC_END(__aeskl_ctr_init)
+
+.align 4
+__aeskl_ctr_inc:
+	paddq INC, CTR
+	add $1, TCTR_LOW
+	jnc .Lctr_inc_low
+	pslldq $8, INC
+	paddq INC, CTR
+	psrldq $8, INC
+.Lctr_inc_low:
+	movdqa CTR, IV
+	pshufb BSWAP_MASK, IV
+	ret
+SYM_FUNC_END(__aeskl_ctr_inc)
+
+/*
+ * int __aeskl_ctr_enc(struct crypto_aes_ctx *ctx,
+ *		       const u8 *dst,
+ *		       u8 *src,
+ *		       size_t len,
+ *		       u8 *iv)
+ */
+SYM_FUNC_START(__aeskl_ctr_enc)
+	FRAME_BEGIN
+	cmp $16, LEN
+	jb .Lctr_enc_noerr
+	mov 480(HANDLEP), KLEN
+	movdqu (IVP), IV
+	call __aeskl_ctr_init
+	cmp $128, LEN
+	jb .Lctr_enc1
+
+.align 4
+.Lctr_enc8:
+	movdqa IV, STATE1
+	call __aeskl_ctr_inc
+	movdqa IV, STATE2
+	call __aeskl_ctr_inc
+	movdqa IV, STATE3
+	call __aeskl_ctr_inc
+	movdqa IV, STATE4
+	call __aeskl_ctr_inc
+	movdqa IV, STATE5
+	call __aeskl_ctr_inc
+	movdqa IV, STATE6
+	call __aeskl_ctr_inc
+	movdqa IV, STATE7
+	call __aeskl_ctr_inc
+	movdqa IV, STATE8
+	call __aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc8_128
+	AESENCWIDE256KL %rdi
+	jz .Lctr_enc_err
+	jmp .Lctr_enc8_end
+.Lctr_enc8_128:
+	AESENCWIDE128KL %rdi
+	jz .Lctr_enc_err
+.Lctr_enc8_end:
+
+	movdqu (INP), IN1
+	pxor IN1, STATE1
+	movdqu STATE1, (OUTP)
+
+	movdqu 0x10(INP), IN1
+	pxor IN1, STATE2
+	movdqu STATE2, 0x10(OUTP)
+
+	movdqu 0x20(INP), IN1
+	pxor IN1, STATE3
+	movdqu STATE3, 0x20(OUTP)
+
+	movdqu 0x30(INP), IN1
+	pxor IN1, STATE4
+	movdqu STATE4, 0x30(OUTP)
+
+	movdqu 0x40(INP), IN1
+	pxor IN1, STATE5
+	movdqu STATE5, 0x40(OUTP)
+
+	movdqu 0x50(INP), IN1
+	pxor IN1, STATE6
+	movdqu STATE6, 0x50(OUTP)
+
+	movdqu 0x60(INP), IN1
+	pxor IN1, STATE7
+	movdqu STATE7, 0x60(OUTP)
+
+	movdqu 0x70(INP), IN1
+	pxor IN1, STATE8
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lctr_enc8
+	cmp $16, LEN
+	jb .Lctr_enc_end
+
+.align 4
+.Lctr_enc1:
+	movdqa IV, STATE
+	call __aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc1_128
+	AESENC256KL HANDLEP, STATE
+	jmp .Lctr_enc1_end
+.Lctr_enc1_128:
+	AESENC128KL HANDLEP, STATE
+
+.Lctr_enc1_end:
+	movdqu (INP), IN
+	pxor IN, STATE
+	movdqu STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lctr_enc1
+
+.Lctr_enc_end:
+	movdqu IV, (IVP)
+.Lctr_enc_noerr:
+	xor AREG, AREG
+	jmp .Lctr_enc_ret
+.Lctr_enc_err:
+	mov $1, AREG
+.Lctr_enc_ret:
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_ctr_enc)
+
+/*
+ * XTS implementation
+ */
+#define GF128MUL_MASK %xmm10
+
+#define __aeskl_gf128mul_x_ble() \
+	pshufd $0x13, IV, CTR; \
+	paddq IV, IV; \
+	psrad $31, CTR; \
+	pand GF128MUL_MASK, CTR; \
+	pxor CTR, IV;
+
+/*
+ * int __aeskl_xts_crypt8(const struct crypto_aes_ctx *ctx,
+ *			  const u8 *dst,
+ *			  u8 *src,
+ *			  bool enc,
+ *			  u8 *iv)
+ */
+SYM_FUNC_START(__aeskl_xts_crypt8)
+	FRAME_BEGIN
+
+	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movdqu (IVP), IV
+
+	mov 480(HANDLEP), KLEN
+
+	movdqa IV, STATE1
+	movdqu (INP), INC
+	pxor INC, STATE1
+	movdqu IV, (OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE5
+	movdqu 0x40(INP), INC
+	pxor INC, STATE5
+	movdqu IV, 0x40(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE6
+	movdqu 0x50(INP), INC
+	pxor INC, STATE6
+	movdqu IV, 0x50(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE7
+	movdqu 0x60(INP), INC
+	pxor INC, STATE7
+	movdqu IV, 0x60(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqa IV, STATE8
+	movdqu 0x70(INP), INC
+	pxor INC, STATE8
+	movdqu IV, 0x70(OUTP)
+
+	cmpb $0, %cl
+	je  .Lxts_dec8
+	cmp $16, KLEN
+	je .Lxts_enc8_128
+	AESENCWIDE256KL %rdi
+	jz .Lxts_err
+	jmp .Lxts_crypt8_end
+.Lxts_enc8_128:
+	AESENCWIDE128KL %rdi
+	jz .Lxts_err
+	jmp .Lxts_crypt8_end
+.Lxts_dec8:
+	cmp $16, KLEN
+	je .Lxts_dec8_128
+	AESDECWIDE256KL %rdi
+	jz .Lxts_err
+	jmp .Lxts_crypt8_end
+.Lxts_dec8_128:
+	AESDECWIDE128KL %rdi
+	jz .Lxts_err
+
+.Lxts_crypt8_end:
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
+	movdqu STATE1, 0x00(OUTP)
+
+	movdqu 0x10(OUTP), INC
+	pxor INC, STATE2
+	movdqu STATE2, 0x10(OUTP)
+
+	movdqu 0x20(OUTP), INC
+	pxor INC, STATE3
+	movdqu STATE3, 0x20(OUTP)
+
+	movdqu 0x30(OUTP), INC
+	pxor INC, STATE4
+	movdqu STATE4, 0x30(OUTP)
+
+	movdqu 0x40(OUTP), INC
+	pxor INC, STATE5
+	movdqu STATE5, 0x40(OUTP)
+
+	movdqu 0x50(OUTP), INC
+	pxor INC, STATE6
+	movdqu STATE6, 0x50(OUTP)
+
+	movdqu 0x60(OUTP), INC
+	pxor INC, STATE7
+	movdqu STATE7, 0x60(OUTP)
+
+	movdqu 0x70(OUTP), INC
+	pxor INC, STATE8
+	movdqu STATE8, 0x70(OUTP)
+
+	__aeskl_gf128mul_x_ble()
+	movdqu IV, (IVP)
+
+	xor AREG, AREG
+	jmp .Lxts_end
+.Lxts_err:
+	mov $1, AREG
+.Lxts_end:
+	FRAME_END
+	ret
+SYM_FUNC_END(__aeskl_xts_crypt8)
+
+#endif
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
new file mode 100644
index 000000000000..9e3f900ad4af
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -0,0 +1,697 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Support for AES Key Locker instructions. This file contains glue
+ * code, the real AES implementation will be in aeskl-intel_asm.S.
+ *
+ * Most code is based on AES-NI glue code, aesni-intel_glue.c
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/simd.h>
+#include <crypto/xts.h>
+#include <asm/keylocker.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
+#include <asm/simd.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/crypto/glue_helper.h>
+#endif
+
+#define AESKL_ALIGN		16
+#define AESKL_ALIGN_ATTR	__aligned(AESKL_ALIGN)
+#define AES_BLOCK_MASK		(~(AES_BLOCK_SIZE - 1))
+#define RFC4106_HASH_SUBKEY_SZ	16
+#define AESKL_ALIGN_EXTRA	((AESKL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+#define CRYPTO_AESKL_CTX_SIZE	(sizeof(struct crypto_aes_ctx) + AESKL_ALIGN_EXTRA)
+
+struct aeskl_xts_ctx {
+	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx)] AESKL_ALIGN_ATTR;
+	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx)] AESKL_ALIGN_ATTR;
+};
+
+#define XTS_AESKL_CTX_SIZE	(sizeof(struct aeskl_xts_ctx) + AESKL_ALIGN_EXTRA)
+
+asmlinkage int __aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len);
+asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_en);
+
+asmlinkage int __aeskl_enc1(const void *ctx, u8 *out, const u8 *in);
+asmlinkage int __aeskl_dec1(const void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_dec(const void *ctx, u8 *out, const u8 *in);
+
+asmlinkage int __aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+asmlinkage int __aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
+asmlinkage int __aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			       const u8 *in, unsigned int len, u8 *iv);
+asmlinkage int __aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			       const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+
+#ifdef CONFIG_X86_64
+asmlinkage int __aeskl_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			       const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage int __aeskl_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, bool enc, u8 *iv);
+asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
+				 const u8 *in, bool enc, u8 *iv);
+#endif
+
+static inline void aeskl_enc1(const void *ctx, u8 *out, const u8 *in)
+{
+	int err;
+
+	err = __aeskl_enc1(ctx, out, in);
+	if (err)
+		pr_err("aes-kl: invalid handle\n");
+}
+
+static inline void aeskl_dec1(const void *ctx, u8 *out, const u8 *in)
+{
+	int err;
+
+	err = __aeskl_dec1(ctx, out, in);
+	if (err)
+		pr_err("aes-kl: invalid handle\n");
+}
+
+static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
+{
+	unsigned long addr = (unsigned long)raw_ctx;
+	unsigned long align = AESKL_ALIGN;
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+	return (struct crypto_aes_ctx *)ALIGN(addr, align);
+}
+
+static int aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
+			       unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
+	int err;
+
+	if (!crypto_simd_usable())
+		return -EBUSY;
+
+	/*
+	 * 192-bit key is not supported by Key Locker. Fall back to
+	 * the AES-NI implementation.
+	 */
+	if (unlikely(key_len == AES_KEYSIZE_192)) {
+		kernel_fpu_begin();
+		err = aesni_set_key(ctx, in_key, key_len);
+		kernel_fpu_end();
+		return err;
+	}
+
+	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	kernel_fpu_begin();
+	/* Encode the key to a handle, only usable at ring 0 */
+	err = __aeskl_setkey(ctx, in_key, key_len);
+	kernel_fpu_end();
+
+	return err;
+}
+
+static int aeskl_setkey(struct crypto_tfm *tfm, const u8 *in_key, unsigned int key_len)
+{
+	return aeskl_setkey_common(tfm, crypto_tfm_ctx(tfm), in_key, key_len);
+}
+
+static void aeskl_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
+	int err = 0;
+
+	if (!crypto_simd_usable())
+		return;
+
+	kernel_fpu_begin();
+	/* 192-bit key not supported, fall back to AES-NI.*/
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		aesni_enc(ctx, dst, src);
+	else
+		err = __aeskl_enc1(ctx, dst, src);
+	kernel_fpu_end();
+
+	if (err)
+		pr_err("aes-kl (encrypt): invalid handle\n");
+}
+
+static void aeskl_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
+	int err = 0;
+
+	if (!crypto_simd_usable())
+		return;
+
+	kernel_fpu_begin();
+	/* 192-bit key not supported, fall back to AES-NI */
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		aesni_dec(ctx, dst, src);
+	else
+		err = __aeskl_dec1(ctx, dst, src);
+	kernel_fpu_end();
+
+	if (err)
+		pr_err("aes-kl (encrypt): invalid handle\n");
+}
+
+static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int len)
+{
+	return aeskl_setkey_common(crypto_skcipher_tfm(tfm),
+				   crypto_skcipher_ctx(tfm), key, len);
+}
+
+static int ecb_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm;
+	struct crypto_aes_ctx *ctx;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	while ((nbytes = walk.nbytes)) {
+		unsigned int len = nbytes & AES_BLOCK_MASK;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_ecb_enc(ctx, dst, src, len);
+		else
+			err = __aeskl_ecb_enc(ctx, dst, src, len);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
+			return -EINVAL;
+		}
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+
+		err = skcipher_walk_done(&walk, nbytes);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm;
+	struct crypto_aes_ctx *ctx;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	while ((nbytes = walk.nbytes)) {
+		unsigned int len = nbytes & AES_BLOCK_MASK;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_ecb_dec(ctx, dst, src, len);
+		else
+			err = __aeskl_ecb_dec(ctx, dst, src, len);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
+			return -EINVAL;
+		}
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+
+		err = skcipher_walk_done(&walk, nbytes);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm;
+	struct crypto_aes_ctx *ctx;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	while ((nbytes = walk.nbytes)) {
+		unsigned int len = nbytes & AES_BLOCK_MASK;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *iv = walk.iv;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_cbc_enc(ctx, dst, src, len, iv);
+		else
+			err = __aeskl_cbc_enc(ctx, dst, src, len, iv);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
+			return -EINVAL;
+		}
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+
+		err = skcipher_walk_done(&walk, nbytes);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm;
+	struct crypto_aes_ctx *ctx;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	while ((nbytes = walk.nbytes)) {
+		unsigned int len = nbytes & AES_BLOCK_MASK;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *iv = walk.iv;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_cbc_dec(ctx, dst, src, len, iv);
+		else
+			err = __aeskl_cbc_dec(ctx, dst, src, len, iv);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
+			return -EINVAL;
+		}
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+
+		err = skcipher_walk_done(&walk, nbytes);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+#ifdef CONFIG_X86_64
+static int ctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm;
+	struct crypto_aes_ctx *ctx;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+		unsigned int len = nbytes & AES_BLOCK_MASK;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *iv = walk.iv;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_ctr_enc(ctx, dst, src, len, iv);
+		else
+			err = __aeskl_ctr_enc(ctx, dst, src, len, iv);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
+			return -EINVAL;
+		}
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+
+		err = skcipher_walk_done(&walk, nbytes);
+		if (err)
+			return err;
+	}
+
+	if (nbytes) {
+		u8 keystream[AES_BLOCK_SIZE];
+		u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *ctrblk = walk.iv;
+
+		kernel_fpu_begin();
+		if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+			aesni_enc(ctx, keystream, ctrblk);
+		else
+			err = __aeskl_enc1(ctx, keystream, ctrblk);
+		kernel_fpu_end();
+
+		if (err) {
+			skcipher_walk_done(&walk, 0);
+			return -EINVAL;
+		}
+
+		crypto_xor(keystream, src, nbytes);
+		memcpy(dst, keystream, nbytes);
+		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	return err;
+}
+
+static int aeskl_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct aeskl_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	err = xts_verify_key(tfm, key, keylen);
+	if (err)
+		return err;
+
+	keylen /= 2;
+
+	/* first half of xts-key is for crypt */
+	err = aeskl_setkey_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx, key, keylen);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return aeskl_setkey_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx, key + keylen,
+				   keylen);
+}
+
+static void aeskl_xts_tweak(const void *raw_ctx, u8 *out, const u8 *in)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		aesni_enc(raw_ctx, out, in);
+	else
+		aeskl_enc1(raw_ctx, out, in);
+}
+
+static void aeskl_xts_enc1(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+	common_glue_func_t fn = aeskl_enc1;
+
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		fn = aesni_enc;
+
+	glue_xts_crypt_128bit_one(raw_ctx, dst, src, iv, fn);
+}
+
+static void aeskl_xts_dec1(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+	common_glue_func_t fn = aeskl_dec1;
+
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		fn = aesni_dec;
+
+	glue_xts_crypt_128bit_one(raw_ctx, dst, src, iv, fn);
+}
+
+static void aeskl_xts_enc8(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+	int err = 0;
+
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		aesni_xts_crypt8(raw_ctx, dst, src, true, (u8 *)iv);
+	else
+		err = __aeskl_xts_crypt8(raw_ctx, dst, src, true, (u8 *)iv);
+
+	if (err)
+		pr_err("aes-kl (XTS encrypt): invalid handle\n");
+}
+
+static void aeskl_xts_dec8(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+	int err = 0;
+
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		aesni_xts_crypt8(raw_ctx, dst, src, false, (u8 *)iv);
+	else
+		__aeskl_xts_crypt8(raw_ctx, dst, src, false, (u8 *)iv);
+
+	if (err)
+		pr_err("aes-kl (XTS decrypt): invalid handle\n");
+}
+
+static const struct common_glue_ctx aeskl_xts_enc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = 1,
+
+	.funcs = { {
+		.num_blocks = 8,
+		.fn_u = { .xts = aeskl_xts_enc8 }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = aeskl_xts_enc1 }
+	} }
+};
+
+static const struct common_glue_ctx aeskl_xts_dec = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = 1,
+
+	.funcs = { {
+		.num_blocks = 8,
+		.fn_u = { .xts = aeskl_xts_dec8 }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = aeskl_xts_dec1 }
+	} }
+};
+
+static int xts_crypt(struct skcipher_request *req, bool decrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aeskl_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const struct common_glue_ctx *gctx;
+
+	if (decrypt)
+		gctx = &aeskl_xts_dec;
+	else
+		gctx = &aeskl_xts_enc;
+
+	return glue_xts_req_128bit(gctx, req, aeskl_xts_tweak,
+				   aes_ctx(ctx->raw_tweak_ctx),
+				   aes_ctx(ctx->raw_crypt_ctx),
+				   decrypt);
+}
+
+static int xts_encrypt(struct skcipher_request *req)
+{
+	return xts_crypt(req, false);
+}
+
+static int xts_decrypt(struct skcipher_request *req)
+{
+	return xts_crypt(req, true);
+}
+#endif
+
+static struct crypto_alg aeskl_cipher_alg = {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-aeskl",
+	.cra_priority		= 301,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= CRYPTO_AESKL_CTX_SIZE,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= AES_MIN_KEY_SIZE,
+			.cia_max_keysize	= AES_MAX_KEY_SIZE,
+			.cia_setkey		= aeskl_setkey,
+			.cia_encrypt		= aeskl_encrypt,
+			.cia_decrypt		= aeskl_decrypt
+		}
+	}
+};
+
+static struct skcipher_alg aeskl_skciphers[] = {
+	{
+		.base = {
+			.cra_name		= "__ecb(aes)",
+			.cra_driver_name	= "__ecb-aes-aeskl",
+			.cra_priority		= 401,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AESKL_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= ecb_encrypt,
+		.decrypt	= ecb_decrypt,
+	}, {
+		.base = {
+			.cra_name		= "__cbc(aes)",
+			.cra_driver_name	= "__cbc-aes-aeskl",
+			.cra_priority		= 401,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AESKL_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= cbc_encrypt,
+		.decrypt	= cbc_decrypt,
+#ifdef CONFIG_X86_64
+	}, {
+		.base = {
+			.cra_name		= "__ctr(aes)",
+			.cra_driver_name	= "__ctr-aes-aeskl",
+			.cra_priority		= 401,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= CRYPTO_AESKL_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= ctr_crypt,
+		.decrypt	= ctr_crypt,
+	}, {
+		.base = {
+			.cra_name		= "__xts(aes)",
+			.cra_driver_name	= "__xts-aes-aeskl",
+			.cra_priority		= 402,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= XTS_AESKL_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= aeskl_xts_setkey,
+		.encrypt	= xts_encrypt,
+		.decrypt	= xts_decrypt,
+#endif
+	}
+};
+
+static struct simd_skcipher_alg *aeskl_simd_skciphers[ARRAY_SIZE(aeskl_skciphers)];
+
+static const struct x86_cpu_id aes_keylocker_cpuid[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_AES, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_KEYLOCKER, NULL),
+	{}
+};
+
+static int __init aeskl_init(void)
+{
+	u32 eax, ebx, ecx, edx;
+	int err;
+
+	if (!x86_match_cpu(aes_keylocker_cpuid))
+		return -ENODEV;
+
+	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	if (!(ebx & KEYLOCKER_CPUID_EBX_AESKLE) ||
+	    !(eax & KEYLOCKER_CPUID_EAX_SUPERVISOR) ||
+	    !(ebx & KEYLOCKER_CPUID_EBX_WIDE))
+		return -ENODEV;
+
+	err = crypto_register_alg(&aeskl_cipher_alg);
+	if (err)
+		return err;
+
+	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+					     aeskl_simd_skciphers);
+	if (err)
+		goto unregister_algs;
+
+	return 0;
+
+unregister_algs:
+	crypto_unregister_alg(&aeskl_cipher_alg);
+
+	return err;
+}
+
+static void __exit aeskl_exit(void)
+{
+	simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+				  aeskl_simd_skciphers);
+	crypto_unregister_alg(&aeskl_cipher_alg);
+}
+
+late_initcall(aeskl_init);
+module_exit(aeskl_exit);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, AES Key Locker implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aes");
diff --git a/arch/x86/include/asm/inst.h b/arch/x86/include/asm/inst.h
index bd7f02480ca1..b719a11a2905 100644
--- a/arch/x86/include/asm/inst.h
+++ b/arch/x86/include/asm/inst.h
@@ -122,9 +122,62 @@
 #endif
 	.endm
 
+	.macro XMM_NUM opd xmm
+	\opd = REG_NUM_INVALID
+	.ifc \xmm,%xmm0
+	\opd = 0
+	.endif
+	.ifc \xmm,%xmm1
+	\opd = 1
+	.endif
+	.ifc \xmm,%xmm2
+	\opd = 2
+	.endif
+	.ifc \xmm,%xmm3
+	\opd = 3
+	.endif
+	.ifc \xmm,%xmm4
+	\opd = 4
+	.endif
+	.ifc \xmm,%xmm5
+	\opd = 5
+	.endif
+	.ifc \xmm,%xmm6
+	\opd = 6
+	.endif
+	.ifc \xmm,%xmm7
+	\opd = 7
+	.endif
+	.ifc \xmm,%xmm8
+	\opd = 8
+	.endif
+	.ifc \xmm,%xmm9
+	\opd = 9
+	.endif
+	.ifc \xmm,%xmm10
+	\opd = 10
+	.endif
+	.ifc \xmm,%xmm11
+	\opd = 11
+	.endif
+	.ifc \xmm,%xmm12
+	\opd = 12
+	.endif
+	.ifc \xmm,%xmm13
+	\opd = 13
+	.endif
+	.ifc \xmm,%xmm14
+	\opd = 14
+	.endif
+	.ifc \xmm,%xmm15
+	\opd = 15
+	.endif
+	.endm
+
 	.macro REG_TYPE type reg
 	R32_NUM reg_type_r32 \reg
 	R64_NUM reg_type_r64 \reg
+	XMM_NUM reg_type_xmm \reg
 	.if reg_type_r64 <> REG_NUM_INVALID
 	\type = REG_TYPE_R64
 	.elseif reg_type_r32 <> REG_NUM_INVALID
@@ -134,6 +187,14 @@
 	.endif
 	.endm
 
+	.macro PFX_OPD_SIZE
+	.byte 0x66
+	.endm
+
+	.macro PFX_RPT
+	.byte 0xf3
+	.endm
+
 	.macro PFX_REX opd1 opd2 W=0
 	.if ((\opd1 | \opd2) & 8) || \W
 	.byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1) | (\W << 3)
@@ -158,6 +219,146 @@
 	.byte 0x0f, 0xc7
 	MODRM 0xc0 rdpid_opd 0x7
 .endm
+
+	.macro ENCODEKEY128 reg1 reg2
+	R32_NUM encodekey128_opd1 \reg1
+	R32_NUM encodekey128_opd2 \reg2
+	PFX_RPT
+	.byte 0xf, 0x38, 0xfa
+	MODRM 0xc0  encodekey128_opd2 encodekey128_opd1
+	.endm
+
+	.macro ENCODEKEY256 reg1 reg2
+	R32_NUM encodekey256_opd1 \reg1
+	R32_NUM encodekey256_opd2 \reg2
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xfb
+	MODRM 0xc0 encodekey256_opd1 encodekey256_opd2
+	.endm
+
+	.macro AESENC128KL reg, xmm
+	REG_TYPE aesenc128kl_opd1_type \reg
+	.if aesenc128kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesenc128kl_opd1 \reg
+	.elseif aesenc128kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesenc128kl_opd1 \reg
+	.else
+	aesenc128kl_opd1 = REG_NUM_INVALID
+	.endif
+	XMM_NUM aesenc128kl_opd2 \xmm
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xdc
+	MODRM 0x0 aesenc128kl_opd1 aesenc128kl_opd2
+	.endm
+
+	.macro AESDEC128KL reg, xmm
+	REG_TYPE aesdec128kl_opd1_type \reg
+	.if aesdec128kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesdec128kl_opd1 \reg
+	.elseif aesdec128kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesdec128kl_opd1 \reg
+	.else
+	aesdec128kl_opd1 = REG_NUM_INVALID
+	.endif
+	XMM_NUM aesdec128kl_opd2 \xmm
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xdd
+	MODRM 0x0 aesdec128kl_opd1 aesdec128kl_opd2
+	.endm
+
+	.macro AESENC256KL reg, xmm
+	REG_TYPE aesenc256kl_opd1_type \reg
+	.if aesenc256kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesenc256kl_opd1 \reg
+	.elseif aesenc256kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesenc256kl_opd1 \reg
+	.else
+	aesenc256kl_opd1 = REG_NUM_INVALID
+	.endif
+	XMM_NUM aesenc256kl_opd2 \xmm
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xde
+	MODRM 0x0 aesenc256kl_opd1 aesenc256kl_opd2
+	.endm
+
+	.macro AESDEC256KL reg, xmm
+	REG_TYPE aesdec256kl_opd1_type \reg
+	.if aesdec256kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesdec256kl_opd1 \reg
+	.elseif aesdec256kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesdec256kl_opd1 \reg
+	.else
+	aesdec256kl_opd1 = REG_NUM_INVALID
+	.endif
+	XMM_NUM aesdec256kl_opd2 \xmm
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xdf
+	MODRM 0x0 aesdec256kl_opd1 aesdec256kl_opd2
+	.endm
+
+	.macro AESENCWIDE128KL reg
+	REG_TYPE aesencwide128kl_opd1_type \reg
+	.if aesencwide128kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesencwide128kl_opd1 \reg
+	.elseif aesencwide128kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesencwide128kl_opd1 \reg
+	.else
+	aesencwide128kl_opd1 = REG_NUM_INVALID
+	.endif
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xd8
+	MODRM 0x0 aesencwide128kl_opd1 0x0
+	.endm
+
+	.macro AESDECWIDE128KL reg
+	REG_TYPE aesdecwide128kl_opd1_type \reg
+	.if aesdecwide128kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesdecwide128kl_opd1 \reg
+	.elseif aesdecwide128kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesdecwide128kl_opd1 \reg
+	.else
+	aesdecwide128kl_opd1 = REG_NUM_INVALID
+	.endif
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xd8
+	MODRM 0x0 aesdecwide128kl_opd1 0x1
+	.endm
+
+	.macro AESENCWIDE256KL reg
+	REG_TYPE aesencwide256kl_opd1_type \reg
+	.if aesencwide256kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesencwide256kl_opd1 \reg
+	.elseif aesencwide256kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesencwide256kl_opd1 \reg
+	.else
+	aesencwide256kl_opd1 = REG_NUM_INVALID
+	.endif
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xd8
+	MODRM 0x0 aesencwide256kl_opd1 0x2
+	.endm
+
+	.macro AESDECWIDE256KL reg
+	REG_TYPE aesdecwide256kl_opd1_type \reg
+	.if aesdecwide256kl_opd1_type == REG_TYPE_R64
+	R64_NUM aesdecwide256kl_opd1 \reg
+	.elseif aesdecwide256kl_opd1_type == REG_TYPE_R32
+	R32_NUM aesdecwide256kl_opd1 \reg
+	.else
+	aesdecwide256kl_opd1 = REG_NUM_INVALID
+	.endif
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xd8
+	MODRM 0x0 aesdecwide256kl_opd1 0x3
+	.endm
+
+	.macro LOADIWKEY xmm1, xmm2
+	XMM_NUM loadiwkey_opd1 \xmm1
+	XMM_NUM loadiwkey_opd2 \xmm2
+	PFX_RPT
+	.byte 0x0f, 0x38, 0xdc
+	MODRM 0xc0 loadiwkey_opd1 loadiwkey_opd2
+	.endm
 #endif
 
 #endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..75a184179c72 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1159,6 +1159,34 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config CRYPTO_AES_KL
+	tristate "AES cipher algorithms (AES-KL)"
+	depends on X86_KEYLOCKER
+	select CRYPTO_AES_NI_INTEL
+	help
+	  Use AES Key Locker instructions for AES algorithm.
+
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+
+	  Rijndael appears to be consistently a very good performer in both
+	  hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
+
+	  The AES specifies three key sizes: 128, 192 and 256 bits
+
+	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+
+	  For 128- and 256-bit keys, the AES cipher algorithm is
+	  implemented by AES Key Locker instructions. This implementation
+	  does not need an AES key once wrapped to an encoded form. For AES
+	  compliance, 192-bit is processed by AES-NI instructions.
+
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
-- 
2.17.1

