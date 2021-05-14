Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98954C43462
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B12361465
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhENUWD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:22:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:58439 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhENUVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:54 -0400
IronPort-SDR: Gta2bt4XfsiSHVTozbktEjojuvGZ6KWRFwGZwQ/sN+yw/1aEYOE0WMQuLZJUCjNXiXVEbJI+de
 NsbkS4QqfG8Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="261469085"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="261469085"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:40 -0700
IronPort-SDR: /TWRE/pK27TU8ThON76+0YO+Ew27t0d1zYiFo+DjpPCaxfHzn6lreAzm29K3S8g4ziJdFZnerP
 zBDPZ11J10HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147202"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:40 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm using Key Locker instructions
Date:   Fri, 14 May 2021 13:15:07 -0700
Message-Id: <20210514201508.27967-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
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

Included are methods for ECB, CBC, CTR, and XTS modes. They are not
compatible with other implementations as referencing an encrypted form
only.

XTS needs a separate 32-bit assembly code as the 64-bit version clobbers
more than eight 128-bit registers. Support 64-bit mode only.

setkey() encodes an AES key. Users may displace the AES key right after
this as encrypt()/decrypt() methods do not need the key.

Most glue code reuses the refactored functions from the AES-NI part. When
enabled, it will have a bit higher priority than the AES-NI as providing
key protection.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v1:
* Rebased on the refactored code. (Ard Biesheuvel)
* Dropped exporting the single block interface. (Ard Biesheuvel)
* Fixed the fallback and error handling paths. (Ard Biesheuvel)
* Revised the module description. (Dave Hansen and Peter Zijlsta)
* Made the build depend on the binutils version to support new instructions.
  (Borislav Petkov and Peter Zijlstra)
* Updated the changelog accordingly.
---
 arch/x86/crypto/Makefile           |    3 +
 arch/x86/crypto/aeskl-intel_asm.S  | 1181 ++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c |  390 +++++++++
 crypto/Kconfig                     |   23 +
 4 files changed, 1597 insertions(+)
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 30d558df67cd..6bb4e2fb2b47 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -50,6 +50,9 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o aes-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 
+obj-$(CONFIG_CRYPTO_AES_KL) += aeskl-intel.o
+aeskl-intel-y := aeskl-intel_asm.o aesni-intel_asm.o aeskl-intel_glue.o aes-intel_glue.o
+
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
 sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
new file mode 100644
index 000000000000..34426f11219d
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -0,0 +1,1181 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Implement AES algorithm using Intel AES Key Locker instructions.
+ *
+ * Most code is based from the AES-NI implementation, aesni-intel_asm.S
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+#include <asm/frame.h>
+#include "aes-intel_asm.S"
+
+.text
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
+#define IV	%xmm9
+#define KEY	%xmm10
+#define BSWAP_MASK %xmm11
+#define CTR	%xmm12
+#define INC	%xmm13
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
+#define TCTR_LOW %r11
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
+#define T1	%ecx
+#define LEN	%esi
+#define IVP	%ebp
+#endif
+
+#define UKEYP	OUTP
+#define GF128MUL_MASK %xmm11
+
+/*
+ * int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len)
+ */
+SYM_FUNC_START(aeskl_setkey)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	push HANDLEP
+	movl (FRAME_OFFSET+8)(%esp),  HANDLEP	# ctx
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
+	encodekey256 %eax, %eax
+	movdqu STATE4, 0x30(HANDLEP)
+	jmp .Lsetkey_end
+.Lsetkey_128:
+	encodekey128 %eax, %eax
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
+SYM_FUNC_END(aeskl_setkey)
+
+/*
+ * int _aeskl_enc(const void *ctx, u8 *dst, const u8 *src)
+ */
+SYM_FUNC_START(_aeskl_enc)
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
+	aesenc256kl (HANDLEP), STATE
+	jz .Lenc_err
+	jmp .Lenc_noerr
+.Lenc_128:
+	aesenc128kl (HANDLEP), STATE
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
+SYM_FUNC_END(_aeskl_enc)
+
+/*
+ * int _aeskl_dec(const void *ctx, u8 *dst, const u8 *src)
+ */
+SYM_FUNC_START(_aeskl_dec)
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
+	aesdec256kl (HANDLEP), STATE
+	jz .Ldec_err
+	jmp .Ldec_noerr
+.Ldec_128:
+	aesdec128kl (HANDLEP), STATE
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
+SYM_FUNC_END(_aeskl_dec)
+
+/*
+ * int _aeskl_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src, size_t len)
+ */
+SYM_FUNC_START(_aeskl_ecb_enc)
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
+	aesencwide256kl (HANDLEP)
+	jz .Lecb_enc_err
+	jmp .Lecb_enc8_end
+.Lecb_enc8_128:
+	aesencwide128kl (HANDLEP)
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
+	aesenc256kl (HANDLEP), STATE
+	jz .Lecb_enc_err
+	jmp .Lecb_enc1_end
+.Lecb_enc1_128:
+	aesenc128kl (HANDLEP), STATE
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
+SYM_FUNC_END(_aeskl_ecb_enc)
+
+/*
+ * int _aeskl_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src, size_t len);
+ */
+SYM_FUNC_START(_aeskl_ecb_dec)
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
+	aesdecwide256kl (HANDLEP)
+	jz .Lecb_dec_err
+	jmp .Lecb_dec8_end
+.Lecb_dec8_128:
+	aesdecwide128kl (HANDLEP)
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
+	aesdec256kl (HANDLEP), STATE
+	jz .Lecb_dec_err
+	jmp .Lecb_dec1_end
+.Lecb_dec1_128:
+	aesdec128kl (HANDLEP), STATE
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
+SYM_FUNC_END(_aeskl_ecb_dec)
+
+/*
+ * int _aeskl_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src, size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_cbc_enc)
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
+	aesenc256kl (HANDLEP), STATE
+	jz .Lcbc_enc_err
+	jmp .Lcbc_enc1_end
+.Lcbc_enc1_128:
+	aesenc128kl (HANDLEP), STATE
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
+SYM_FUNC_END(_aeskl_cbc_enc)
+
+/*
+ * int _aeskl_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src, size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_cbc_dec)
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
+	aesdecwide256kl (HANDLEP)
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec8_end
+.Lcbc_dec8_128:
+	aesdecwide128kl (HANDLEP)
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
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec1_end
+.Lcbc_dec1_128:
+	aesdec128kl (HANDLEP), STATE1
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
+SYM_FUNC_END(_aeskl_cbc_dec)
+
+#ifdef __x86_64__
+
+/*
+ * _aeskl_ctr_inc_init:	internal ABI
+ *	setup registers used by _aesni_inc
+ * input:
+ *	IV
+ * output:
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ */
+SYM_FUNC_START_LOCAL(_aeskl_ctr_inc_init)
+	movaps .Lbswap_mask, BSWAP_MASK
+	movaps IV, CTR
+	pshufb BSWAP_MASK, CTR
+	mov $1, TCTR_LOW
+	movq TCTR_LOW, INC
+	movq CTR, TCTR_LOW
+	ret
+SYM_FUNC_END(_aeskl_ctr_inc_init)
+
+/*
+ * _aeskl_ctr_inc:		internal ABI
+ *	Increase IV by 1, IV is in big endian
+ * input:
+ *	IV
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ * output:
+ *	IV:	Increase by 1
+ * changed:
+ *	CTR:	== output IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ */
+SYM_FUNC_START_LOCAL(_aeskl_ctr_inc)
+	paddq INC, CTR
+	add $1, TCTR_LOW
+	jnc .Linc_low
+	pslldq $8, INC
+	paddq INC, CTR
+	psrldq $8, INC
+.Linc_low:
+	movaps CTR, IV
+	pshufb BSWAP_MASK, IV
+	ret
+SYM_FUNC_END(_aeskl_ctr_inc)
+
+/*
+ * CTR implementations
+ */
+
+/*
+ * int _aeskl_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src, size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_ctr_enc)
+	FRAME_BEGIN
+	cmp $16, LEN
+	jb .Lctr_enc_noerr
+	mov 480(HANDLEP), KLEN
+	movdqu (IVP), IV
+	call _aeskl_ctr_inc_init
+	cmp $128, LEN
+	jb .Lctr_enc1
+
+.align 4
+.Lctr_enc8:
+	movaps IV, STATE1
+	call _aeskl_ctr_inc
+	movaps IV, STATE2
+	call _aeskl_ctr_inc
+	movaps IV, STATE3
+	call _aeskl_ctr_inc
+	movaps IV, STATE4
+	call _aeskl_ctr_inc
+	movaps IV, STATE5
+	call _aeskl_ctr_inc
+	movaps IV, STATE6
+	call _aeskl_ctr_inc
+	movaps IV, STATE7
+	call _aeskl_ctr_inc
+	movaps IV, STATE8
+	call _aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc8_128
+	aesencwide256kl (%rdi)
+	jz .Lctr_enc_err
+	jmp .Lctr_enc8_end
+.Lctr_enc8_128:
+	aesencwide128kl (%rdi)
+	jz .Lctr_enc_err
+.Lctr_enc8_end:
+
+	movups (INP), IN1
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+
+	movups 0x10(INP), IN1
+	pxor IN1, STATE2
+	movups STATE2, 0x10(OUTP)
+
+	movups 0x20(INP), IN1
+	pxor IN1, STATE3
+	movups STATE3, 0x20(OUTP)
+
+	movups 0x30(INP), IN1
+	pxor IN1, STATE4
+	movups STATE4, 0x30(OUTP)
+
+	movups 0x40(INP), IN1
+	pxor IN1, STATE5
+	movups STATE5, 0x40(OUTP)
+
+	movups 0x50(INP), IN1
+	pxor IN1, STATE6
+	movups STATE6, 0x50(OUTP)
+
+	movups 0x60(INP), IN1
+	pxor IN1, STATE7
+	movups STATE7, 0x60(OUTP)
+
+	movups 0x70(INP), IN1
+	pxor IN1, STATE8
+	movups STATE8, 0x70(OUTP)
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
+	movaps IV, STATE1
+	call _aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc1_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lctr_enc_err
+	jmp .Lctr_enc1_end
+.Lctr_enc1_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lctr_enc_err
+
+.Lctr_enc1_end:
+	movups (INP), IN1
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
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
+SYM_FUNC_END(_aeskl_ctr_enc)
+
+/*
+ * XTS implementation
+ */
+
+/*
+ * _aeskl_gf128mul_x_ble: 		internal ABI
+ *	Multiply in GF(2^128) for XTS IVs
+ * input:
+ *	IV:	current IV
+ *	GF128MUL_MASK == mask with 0x87 and 0x01
+ * output:
+ *	IV:	next IV
+ * changed:
+ *	CTR:	== temporary value
+ */
+#define _aeskl_gf128mul_x_ble() \
+	pshufd $0x13, IV, KEY; \
+	paddq IV, IV; \
+	psrad $31, KEY; \
+	pand GF128MUL_MASK, KEY; \
+	pxor KEY, IV;
+
+/*
+ * int _aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+ *			   unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(_aeskl_xts_encrypt)
+	FRAME_BEGIN
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(HANDLEP), KLEN
+
+.Lxts_enc8:
+	sub $128, LEN
+	jl .Lxts_enc1_pre
+
+	movdqa IV, STATE1
+	movdqu (INP), INC
+	pxor INC, STATE1
+	movdqu IV, (OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE5
+	movdqu 0x40(INP), INC
+	pxor INC, STATE5
+	movdqu IV, 0x40(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE6
+	movdqu 0x50(INP), INC
+	pxor INC, STATE6
+	movdqu IV, 0x50(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE7
+	movdqu 0x60(INP), INC
+	pxor INC, STATE7
+	movdqu IV, 0x60(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE8
+	movdqu 0x70(INP), INC
+	pxor INC, STATE8
+	movdqu IV, 0x70(OUTP)
+
+	cmp $16, KLEN
+	je .Lxts_enc8_128
+	aesencwide256kl (%rdi)
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc8_end
+.Lxts_enc8_128:
+	aesencwide128kl (%rdi)
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc8_end:
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
+	_aeskl_gf128mul_x_ble()
+
+	add $128, INP
+	add $128, OUTP
+	test LEN, LEN
+	jnz .Lxts_enc8
+
+.Lxts_enc_ret_iv:
+	movups IV, (IVP)
+.Lxts_enc_ret_noerr:
+	xor AREG, AREG
+	jmp .Lxts_enc_ret
+.Lxts_enc_ret_err:
+	mov $1, AREG
+.Lxts_enc_ret:
+	FRAME_END
+	ret
+
+.Lxts_enc1_pre:
+	add $128, LEN
+	jz .Lxts_enc_ret_iv
+	sub $16, LEN
+	jl .Lxts_enc_cts4
+
+.Lxts_enc1:
+	movdqu (INP), STATE1
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_enc1_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc1_end
+.Lxts_enc1_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc1_end:
+	pxor IV, STATE1
+	_aeskl_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_enc1_out
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_enc_cts1
+
+	movdqu STATE1, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_enc1
+
+.Lxts_enc1_out:
+	movdqu STATE1, (OUTP)
+	jmp .Lxts_enc_ret_iv
+
+.Lxts_enc_cts4:
+	movdqu STATE8, STATE1
+	sub $16, OUTP
+
+.Lxts_enc_cts1:
+	lea .Lcts_permute_table(%rip), T1
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), STATE2
+	movaps STATE1, STATE3
+	pshufb STATE2, STATE1
+	movups STATE1, (LEN)
+
+	movups (IVP), STATE1
+	pshufb STATE1, IN1
+	pblendvb STATE3, IN1
+	movaps IN1, STATE1
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_enc1_cts_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc1_cts_end
+.Lxts_enc1_cts_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc1_cts_end:
+	pxor IV, STATE1
+	movups STATE1, (OUTP)
+	jmp .Lxts_enc_ret_noerr
+SYM_FUNC_END(_aeskl_xts_encrypt)
+
+/*
+ * int _aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+ *			   unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(_aeskl_xts_decrypt)
+	FRAME_BEGIN
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(HANDLEP), KLEN
+
+	test $15, LEN
+	jz .Lxts_dec8
+	sub $16, LEN
+
+.Lxts_dec8:
+	sub $128, LEN
+	jl .Lxts_dec1_pre
+
+	movdqa IV, STATE1
+	movdqu (INP), INC
+	pxor INC, STATE1
+	movdqu IV, (OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE5
+	movdqu 0x40(INP), INC
+	pxor INC, STATE5
+	movdqu IV, 0x40(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE6
+	movdqu 0x50(INP), INC
+	pxor INC, STATE6
+	movdqu IV, 0x50(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE7
+	movdqu 0x60(INP), INC
+	pxor INC, STATE7
+	movdqu IV, 0x60(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE8
+	movdqu 0x70(INP), INC
+	pxor INC, STATE8
+	movdqu IV, 0x70(OUTP)
+
+	cmp $16, KLEN
+	je .Lxts_dec8_128
+	aesdecwide256kl (%rdi)
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec8_end
+.Lxts_dec8_128:
+	aesdecwide128kl (%rdi)
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec8_end:
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
+	_aeskl_gf128mul_x_ble()
+
+	add $128, INP
+	add $128, OUTP
+	test LEN, LEN
+	jnz .Lxts_dec8
+
+.Lxts_dec_ret_iv:
+	movups IV, (IVP)
+.Lxts_dec_ret_noerr:
+	xor AREG, AREG
+	jmp .Lxts_dec_ret
+.Lxts_dec_ret_err:
+	mov $1, AREG
+.Lxts_dec_ret:
+	FRAME_END
+	ret
+
+.Lxts_dec1_pre:
+	add $128, LEN
+	jz .Lxts_dec_ret_iv
+
+.Lxts_dec1:
+	movdqu (INP), STATE1
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_dec_cts1
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_end
+.Lxts_dec1_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_end:
+	pxor IV, STATE1
+	_aeskl_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_dec1_out
+
+	movdqu STATE1, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_dec1
+
+.Lxts_dec1_out:
+	movdqu STATE1, (OUTP)
+	jmp .Lxts_dec_ret_iv
+
+.Lxts_dec_cts1:
+	movdqa IV, STATE5
+	_aeskl_gf128mul_x_ble()
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_cts_pre_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_cts_pre_end
+.Lxts_dec1_cts_pre_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_cts_pre_end:
+	pxor IV, STATE1
+
+	lea .Lcts_permute_table(%rip), T1
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), STATE2
+	movaps STATE1, STATE3
+	pshufb STATE2, STATE1
+	movups STATE1, (LEN)
+
+	movups (IVP), STATE1
+	pshufb STATE1, IN1
+	pblendvb STATE3, IN1
+	movaps IN1, STATE1
+
+	pxor STATE5, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_cts_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_cts_end
+.Lxts_dec1_cts_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_cts_end:
+	pxor STATE5, STATE1
+
+	movups STATE1, (OUTP)
+	jmp .Lxts_dec_ret_noerr
+
+SYM_FUNC_END(_aeskl_xts_decrypt)
+
+#endif
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
new file mode 100644
index 000000000000..e0a052e89fa0
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -0,0 +1,390 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Support for AES Key Locker instructions. This file contains glue
+ * code and the real AES implementation is in aeskl-intel_asm.S.
+ *
+ * Most code is based on AES-NI glue code, aesni-intel_glue.c
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/xts.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
+#include <asm/simd.h>
+#include <asm/keylocker.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/simd.h>
+#include "aes-intel_glue.h"
+#include "aesni-intel_glue.h"
+
+asmlinkage int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len);
+
+asmlinkage int _aeskl_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage int _aeskl_dec(const void *ctx, u8 *out, const u8 *in);
+
+asmlinkage int _aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+asmlinkage int _aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
+asmlinkage int _aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+asmlinkage int _aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+
+#ifdef CONFIG_X86_64
+asmlinkage int _aeskl_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+
+asmlinkage int _aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				  unsigned int len, u8 *iv);
+asmlinkage int _aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				  unsigned int len, u8 *iv);
+#endif
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
+	if ((key_len != AES_KEYSIZE_128) && (key_len != AES_KEYSIZE_192) &&
+	    (key_len != AES_KEYSIZE_256))
+		return -EINVAL;
+
+	kernel_fpu_begin();
+	/*
+	 * For 128-bit and 256-bit keys, encode to a handle that is usable only
+	 * in kernel mode. Use AES-NI instructions for 192-bit keys.
+	 */
+	if (likely(key_len != AES_KEYSIZE_192))
+		err = aeskl_setkey(ctx, in_key, key_len);
+	else
+		err = aesni_set_key(ctx, in_key, key_len);
+	kernel_fpu_end();
+
+	return err;
+}
+
+static inline u32 keylength(const void *raw_ctx)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+
+	return ctx->key_length;
+}
+
+static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
+{
+	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_enc(ctx, out, in))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
+{
+	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_dec(ctx, out, in))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_ecb_enc(ctx, out, in, len))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_ecb_dec(ctx, out, in, len))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_cbc_enc(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_cbc_dec(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+#ifdef CONFIG_X86_64
+
+static int aeskl_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_ctr_enc(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static inline int aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				    unsigned int len, u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_xts_encrypt(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static inline int aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				    unsigned int len, u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+
+	if (_aeskl_xts_decrypt(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+#endif /* CONFIG_X86_64 */
+
+static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int len)
+{
+	struct crypto_tfm *crypto_tfm = crypto_skcipher_tfm(tfm);
+	void *raw_ctx = crypto_skcipher_ctx(tfm);
+
+	return aeskl_setkey_common(crypto_tfm, raw_ctx, key, len);
+}
+
+static int ecb_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ecb_crypt_common(req, aeskl_ecb_enc);
+	else
+		return ecb_crypt_common(req, aesni_ecb_enc);
+}
+
+static int ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ecb_crypt_common(req, aeskl_ecb_dec);
+	else
+		return ecb_crypt_common(req, aesni_ecb_dec);
+}
+
+static int cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return cbc_crypt_common(req, aeskl_cbc_enc);
+	else
+		return cbc_crypt_common(req, aesni_cbc_enc);
+}
+
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return cbc_crypt_common(req, aeskl_cbc_dec);
+	else
+		return cbc_crypt_common(req, aesni_cbc_dec);
+}
+
+#ifdef CONFIG_X86_64
+
+static int ctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ctr_crypt_common(req, aeskl_ctr_enc, aeskl_enc);
+	else
+		return ctr_crypt_common(req, aesni_ctr_enc, aesni_enc);
+}
+
+static int aeskl_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	return xts_setkey_common(tfm, key, keylen, aeskl_setkey_common);
+}
+
+static int xts_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return xts_crypt_common(req, aeskl_xts_encrypt, aeskl_enc);
+	else
+		return xts_crypt_common(req, aesni_xts_encrypt, aesni_enc);
+}
+
+static int xts_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return xts_crypt_common(req, aeskl_xts_decrypt, aeskl_enc);
+	else
+		return xts_crypt_common(req, aesni_xts_decrypt, aesni_enc);
+}
+
+#endif /* CONFIG_X86_64 */
+
+static struct skcipher_alg aeskl_skciphers[] = {
+	{
+		.base = {
+			.cra_name		= "__ecb(aes)",
+			.cra_driver_name	= "__ecb-aes-aeskl",
+			.cra_priority		= 401,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
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
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
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
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
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
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= XTS_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.walksize	= 2 * AES_BLOCK_SIZE,
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
+	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+					     aeskl_simd_skciphers);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void __exit aeskl_exit(void)
+{
+	simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+				  aeskl_simd_skciphers);
+}
+
+late_initcall(aeskl_init);
+module_exit(aeskl_exit);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, AES Key Locker implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aes");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ca3b02dcbbfa..5f3d4052fa3c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1113,6 +1113,29 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config CRYPTO_AES_KL
+	tristate "AES cipher algorithms (AES-KL)"
+	depends on X86_KEYLOCKER
+	depends on LD_VERSION >= 23600
+	select CRYPTO_AES_NI_INTEL
+	help
+	  Key Locker provides AES SIMD instructions (AES-KL) to protect AES
+	  keys. They are analogous to AES-NI. AES-KL supports to encode AES
+	  keys and use an encoded form to transform data instead of
+	  referencing an AES key all the way.
+
+	  The CPU-internal key is used to wrap AES keys. AES-KL relies on
+	  the x86 core code that manages the internal key.
+
+	  AES-KL supports 128-/256-bit keys. This module uses the AES-NI
+	  methods for 192-bit keys. It includes such block cipher mode
+	  support as ECB, CBC, CTR, and XTS.
+
+	  binutils version 2.36 or later is needed to assemble AES-KL.
+
+	  See the CRYPTO_AES_NI_INTEL description for more about the AES
+	  algorithm.
+
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
-- 
2.17.1

