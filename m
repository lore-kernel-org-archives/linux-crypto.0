From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Fri, 29 Oct 2010 23:10:24 +0200
Message-ID: <1288386624-5649-1-git-send-email-minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:38734 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab0J2VT6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Oct 2010 17:19:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES-NI instructions are also available in legacy mode so the x86
architecture may profit from those, too.

To illustrate the performance gain here's a short summary of the tcrypt
speed test on a Core i5 M 520 running at 2.40GHz comparing both
assembler implementations:

                             aes-i586   aes-ni-i586   delta
256 bit, 8kB blocks, ECB:  46.81 MB/s   164.46 MB/s   +251%
256 bit, 8kB blocks, CBC:  43.89 MB/s    62.18 MB/s    +41%
384 bit, 8kB blocks, LRW:  42.24 MB/s   142.90 MB/s   +238%
512 bit, 8kB blocks, XTS:  43.41 MB/s   148.67 MB/s   +242%

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/Makefile                 |    7 +-
 arch/x86/crypto/aesni-intel_asm-i586.S   |  773 +++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_asm-x86_64.S |  841 ++++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_asm.S        |  841 ------------------------------
 arch/x86/crypto/aesni-intel_glue.c       |   18 +
 crypto/Kconfig                           |   32 ++-
 6 files changed, 1667 insertions(+), 845 deletions(-)
 create mode 100644 arch/x86/crypto/aesni-intel_asm-i586.S
 create mode 100644 arch/x86/crypto/aesni-intel_asm-x86_64.S
 delete mode 100644 arch/x86/crypto/aesni-intel_asm.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 1a58ad8..949e7e5 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -5,25 +5,26 @@
 obj-$(CONFIG_CRYPTO_FPU) += fpu.o
 
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
+obj-$(CONFIG_CRYPTO_AES_NI_INTEL_586) += aesni-intel-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
 
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
+obj-$(CONFIG_CRYPTO_AES_NI_INTEL_X86_64) += aesni-intel-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
-obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
+aesni-intel-i586-y := aesni-intel_asm-i586.o aesni-intel_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
 
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
+aesni-intel-x86_64-y := aesni-intel_asm-x86_64.o aesni-intel_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 
-aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
-
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
diff --git a/arch/x86/crypto/aesni-intel_asm-i586.S b/arch/x86/crypto/aesni-intel_asm-i586.S
new file mode 100644
index 0000000..e2bdb5a
--- /dev/null
+++ b/arch/x86/crypto/aesni-intel_asm-i586.S
@@ -0,0 +1,773 @@
+/*
+ * Implement AES algorithm in Intel AES-NI instructions.
+ *
+ * The white paper of AES-NI instructions can be downloaded from:
+ *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-Set_WP.pdf
+ *
+ * Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *            Vinodh Gopal <vinodh.gopal@intel.com>
+ *            Kahraman Akdemir
+ * Copyright (C) 2010 secunet Security Networks AG
+ *    Author: Mathias Krause <mathias.krause@secunet.com>
+ *            ported x86_64 version to x86
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+
+.text
+
+#define STATE1	%xmm0
+#define STATE2	%xmm4
+#define STATE3	%xmm5
+#define STATE4	%xmm6
+#define STATE	STATE1
+#define IN1	%xmm1
+#define IN2	%xmm7
+#define IN	IN1
+#define KEY	%xmm2
+#define IV	%xmm3
+
+#define KEYP	%edi
+#define OUTP	%eax
+#define INP	%edx
+#define LEN	%esi
+#define IVP	%ebp
+#define EKLEN	480(KEYP)
+#define DKLEN	240(KEYP)
+#define T1	%ecx
+#define TKEYP	T1
+
+_key_expansion_128:
+_key_expansion_256a:
+	pshufd $0b11111111, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+ 	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+	movaps %xmm0, (%ecx)
+	add $0x10, %ecx
+	ret
+
+_key_expansion_192a:
+	pshufd $0b01010101, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+
+	movaps %xmm2, %xmm5
+	movaps %xmm2, %xmm6
+	pslldq $4, %xmm5
+	pshufd $0b11111111, %xmm0, %xmm3
+	pxor %xmm3, %xmm2
+	pxor %xmm5, %xmm2
+
+	movaps %xmm0, %xmm1
+	shufps $0b01000100, %xmm0, %xmm6
+	movaps %xmm6, (%ecx)
+	shufps $0b01001110, %xmm2, %xmm1
+	movaps %xmm1, 0x10(%ecx)
+	add $0x20, %ecx
+	ret
+
+_key_expansion_192b:
+	pshufd $0b01010101, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+
+	movaps %xmm2, %xmm5
+	pslldq $4, %xmm5
+	pshufd $0b11111111, %xmm0, %xmm3
+	pxor %xmm3, %xmm2
+	pxor %xmm5, %xmm2
+
+	movaps %xmm0, (%ecx)
+	add $0x10, %ecx
+	ret
+
+_key_expansion_256b:
+	pshufd $0b10101010, %xmm1, %xmm1
+	shufps $0b00010000, %xmm2, %xmm4
+	pxor %xmm4, %xmm2
+	shufps $0b10001100, %xmm2, %xmm4
+	pxor %xmm4, %xmm2
+	pxor %xmm1, %xmm2
+	movaps %xmm2, (%ecx)
+	add $0x10, %ecx
+	ret
+
+/*
+ * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+ *                   unsigned int key_len)
+ */
+ENTRY(aesni_set_key)
+	pushl %edi
+	movl 8(%esp), %edi		# ctx
+	movl 12(%esp), %edx		# in_key
+	movl 16(%esp), %eax		# key_len
+
+	movups (%edx), %xmm0		# user key (first 16 bytes)
+	movaps %xmm0, (%edi)
+	lea 0x10(%edi), %ecx		# key addr
+	movl %eax, 480(%edi)
+	pxor %xmm4, %xmm4		# xmm4 is assumed 0 in _key_expansion_x
+	cmp $24, %al
+	jb .Lenc_key128
+	je .Lenc_key192
+	movups 0x10(%edx), %xmm2	# other user key
+	movaps %xmm2, (%ecx)
+	add $0x10, %ecx
+	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x1 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x2 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x4 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x8 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x10 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x20 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	call _key_expansion_256a
+	jmp .Ldec_key
+.Lenc_key192:
+	movq 0x10(%edx), %xmm2		# other user key
+	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x80 %xmm2 %xmm1	# round 8
+	call _key_expansion_192b
+	jmp .Ldec_key
+.Lenc_key128:
+	AESKEYGENASSIST 0x1 %xmm0 %xmm1		# round 1
+	call _key_expansion_128
+	AESKEYGENASSIST 0x2 %xmm0 %xmm1		# round 2
+	call _key_expansion_128
+	AESKEYGENASSIST 0x4 %xmm0 %xmm1		# round 3
+	call _key_expansion_128
+	AESKEYGENASSIST 0x8 %xmm0 %xmm1		# round 4
+	call _key_expansion_128
+	AESKEYGENASSIST 0x10 %xmm0 %xmm1	# round 5
+	call _key_expansion_128
+	AESKEYGENASSIST 0x20 %xmm0 %xmm1	# round 6
+	call _key_expansion_128
+	AESKEYGENASSIST 0x40 %xmm0 %xmm1	# round 7
+	call _key_expansion_128
+	AESKEYGENASSIST 0x80 %xmm0 %xmm1	# round 8
+	call _key_expansion_128
+	AESKEYGENASSIST 0x1b %xmm0 %xmm1	# round 9
+	call _key_expansion_128
+	AESKEYGENASSIST 0x36 %xmm0 %xmm1	# round 10
+	call _key_expansion_128
+.Ldec_key:
+	sub $0x10, %ecx
+	movaps (%edi), %xmm0
+	movaps (%ecx), %xmm1
+	movaps %xmm0, 240(%ecx)
+	movaps %xmm1, 240(%edi)
+	add $0x10, %edi
+	lea 240-16(%ecx), %edx
+.align 4
+.Ldec_key_loop:
+	movaps (%edi), %xmm0
+	AESIMC %xmm0 %xmm1
+	movaps %xmm1, (%edx)
+	add $0x10, %edi
+	sub $0x10, %edx
+	cmp %ecx, %edi
+	jb .Ldec_key_loop
+	xor %eax, %eax
+	popl %edi
+	ret
+
+/*
+ * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ */
+ENTRY(aesni_enc)
+	pushl KEYP
+	movl 8(%esp), KEYP
+	movl 12(%esp), OUTP
+	movl 16(%esp), INP
+	movups (INP), STATE		# input
+	call _aesni_enc1
+	movups STATE, (OUTP)		# output
+	popl KEYP
+	ret
+
+/*
+ * _aesni_enc1:		internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	EKLEN:		round count
+ *	STATE:		initial state (input)
+ * output:
+ *	STATE:		finial state (output)
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_enc1:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE		# round 0
+	add $0x30, TKEYP
+	cmp $24, EKLEN
+	jb .Lenc128
+	lea 0x20(TKEYP), TKEYP
+	je .Lenc192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x50(TKEYP), KEY
+	AESENC KEY STATE
+.align 4
+.Lenc192:
+	movaps -0x40(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x30(TKEYP), KEY
+	AESENC KEY STATE
+.align 4
+.Lenc128:
+	movaps -0x20(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x10(TKEYP), KEY
+	AESENC KEY STATE
+	movaps (TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x10(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x20(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x30(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x40(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x50(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x60(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x70(TKEYP), KEY
+	AESENCLAST KEY STATE
+	ret
+
+/*
+ * _aesni_enc4:	internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	EKLEN:		round count
+ *	STATE1:		initial state (input)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * output:
+ *	STATE1:		finial state (output)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_enc4:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE1		# round 0
+	pxor KEY, STATE2
+	pxor KEY, STATE3
+	pxor KEY, STATE4
+	add $0x30, TKEYP
+	cmp $24, EKLEN
+	jb .L4enc128
+	lea 0x20(TKEYP), TKEYP
+	je .L4enc192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x50(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+#.align 4
+.L4enc192:
+	movaps -0x40(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x30(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+#.align 4
+.L4enc128:
+	movaps -0x20(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x10(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps (TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x10(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x20(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x30(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x40(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x50(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x60(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x70(TKEYP), KEY
+	AESENCLAST KEY STATE1		# last round
+	AESENCLAST KEY STATE2
+	AESENCLAST KEY STATE3
+	AESENCLAST KEY STATE4
+	ret
+
+/*
+ * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ */
+ENTRY(aesni_dec)
+	pushl KEYP
+	movl 8(%esp), KEYP
+	movl 12(%esp), OUTP
+	movl 16(%esp), INP
+	add $240, KEYP
+	movups (INP), STATE		# input
+	call _aesni_dec1
+	movups STATE, (OUTP)		#output
+	popl KEYP
+	ret
+
+/*
+ * _aesni_dec1:		internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	DKLEN:		key length
+ *	STATE:		initial state (input)
+ * output:
+ *	STATE:		finial state (output)
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_dec1:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE		# round 0
+	add $0x30, TKEYP
+	cmp $24, DKLEN
+	jb .Ldec128
+	lea 0x20(TKEYP), TKEYP
+	je .Ldec192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x50(TKEYP), KEY
+	AESDEC KEY STATE
+.align 4
+.Ldec192:
+	movaps -0x40(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x30(TKEYP), KEY
+	AESDEC KEY STATE
+.align 4
+.Ldec128:
+	movaps -0x20(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x10(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps (TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x10(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x20(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x30(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x40(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x50(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x60(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x70(TKEYP), KEY
+	AESDECLAST KEY STATE
+	ret
+
+/*
+ * _aesni_dec4:	internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	DKLEN:		key length
+ *	STATE1:		initial state (input)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * output:
+ *	STATE1:		finial state (output)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_dec4:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE1		# round 0
+	pxor KEY, STATE2
+	pxor KEY, STATE3
+	pxor KEY, STATE4
+	add $0x30, TKEYP
+	cmp $24, DKLEN
+	jb .L4dec128
+	lea 0x20(TKEYP), TKEYP
+	je .L4dec192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x50(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+.align 4
+.L4dec192:
+	movaps -0x40(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x30(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+.align 4
+.L4dec128:
+	movaps -0x20(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x10(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps (TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x10(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x20(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x30(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x40(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x50(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x60(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x70(TKEYP), KEY
+	AESDECLAST KEY STATE1		# last round
+	AESDECLAST KEY STATE2
+	AESDECLAST KEY STATE3
+	AESDECLAST KEY STATE4
+	ret
+
+/*
+ * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len)
+ */
+ENTRY(aesni_ecb_enc)
+	pushl LEN
+	pushl KEYP
+	movl 12(%esp), KEYP
+	movl 16(%esp), OUTP
+	movl 20(%esp), INP
+	movl 24(%esp), LEN
+	test LEN, LEN		# check length
+	jz .Lecb_enc_ret
+	cmp $16, LEN
+	jb .Lecb_enc_ret
+	cmp $64, LEN
+	jb .Lecb_enc_loop1
+.align 4
+.Lecb_enc_loop4:
+	movups (INP), STATE1
+	movups 0x10(INP), STATE2
+	movups 0x20(INP), STATE3
+	movups 0x30(INP), STATE4
+	call _aesni_enc4
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lecb_enc_loop4
+	cmp $16, LEN
+	jb .Lecb_enc_ret
+.align 4
+.Lecb_enc_loop1:
+	movups (INP), STATE1
+	call _aesni_enc1
+	movups STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_enc_loop1
+.Lecb_enc_ret:
+	popl KEYP
+	popl LEN
+	ret
+
+/*
+ * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len);
+ */
+ENTRY(aesni_ecb_dec)
+	pushl LEN
+	pushl KEYP
+	movl 12(%esp), KEYP
+	movl 16(%esp), OUTP
+	movl 20(%esp), INP
+	movl 24(%esp), LEN
+	test LEN, LEN
+	jz .Lecb_dec_ret
+	add $240, KEYP
+	cmp $16, LEN
+	jb .Lecb_dec_ret
+	cmp $64, LEN
+	jb .Lecb_dec_loop1
+.align 4
+.Lecb_dec_loop4:
+	movups (INP), STATE1
+	movups 0x10(INP), STATE2
+	movups 0x20(INP), STATE3
+	movups 0x30(INP), STATE4
+	call _aesni_dec4
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lecb_dec_loop4
+	cmp $16, LEN
+	jb .Lecb_dec_ret
+.align 4
+.Lecb_dec_loop1:
+	movups (INP), STATE1
+	call _aesni_dec1
+	movups STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_dec_loop1
+.Lecb_dec_ret:
+	popl KEYP
+	popl LEN
+	ret
+
+/*
+ * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_cbc_enc)
+	pushl IVP
+	pushl LEN
+	pushl KEYP
+	movl 16(%esp), KEYP
+	movl 20(%esp), OUTP
+	movl 24(%esp), INP
+	movl 28(%esp), LEN
+	cmp $16, LEN
+	jb .Lcbc_enc_ret
+	movups (IVP), STATE	# load iv as initial state
+.align 4
+.Lcbc_enc_loop:
+	movups (INP), IN	# load input
+	pxor IN, STATE
+	call _aesni_enc1
+	movups STATE, (OUTP)	# store output
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_enc_loop
+	movups STATE, (IVP)
+.Lcbc_enc_ret:
+	popl KEYP
+	popl LEN
+	popl IVP
+	ret
+
+/*
+ * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_cbc_dec)
+	pushl IVP
+	pushl LEN
+	pushl KEYP
+	movl 16(%esp), KEYP
+	movl 20(%esp), OUTP
+	movl 24(%esp), INP
+	movl 28(%esp), LEN
+	cmp $16, LEN
+	jb .Lcbc_dec_just_ret
+	add $240, KEYP
+	movups (IVP), IV
+	cmp $64, LEN
+	jb .Lcbc_dec_loop1
+.align 4
+.Lcbc_dec_loop4:
+	movups (INP), IN1
+	movaps IN1, STATE1
+	movups 0x10(INP), IN2
+	movaps IN2, STATE2
+	movups 0x20(INP), IN1
+	movaps IN1, STATE3
+	movups 0x30(INP), IN2
+	movaps IN2, STATE4
+	call _aesni_dec4
+	pxor IV, STATE1
+	pxor (INP), STATE2
+	pxor 0x10(INP), STATE3
+	pxor IN1, STATE4
+	movaps IN2, IV
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lcbc_dec_loop4
+	cmp $16, LEN
+	jb .Lcbc_dec_ret
+.align 4
+.Lcbc_dec_loop1:
+	movups (INP), IN
+	movaps IN, STATE
+	call _aesni_dec1
+	pxor IV, STATE
+	movups STATE, (OUTP)
+	movaps IN, IV
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_dec_loop1
+.Lcbc_dec_ret:
+	movups IV, (IVP)
+.Lcbc_dec_just_ret:
+	popl KEYP
+	popl LEN
+	popl IVP
+	ret
diff --git a/arch/x86/crypto/aesni-intel_asm-x86_64.S b/arch/x86/crypto/aesni-intel_asm-x86_64.S
new file mode 100644
index 0000000..ff16756
--- /dev/null
+++ b/arch/x86/crypto/aesni-intel_asm-x86_64.S
@@ -0,0 +1,841 @@
+/*
+ * Implement AES algorithm in Intel AES-NI instructions.
+ *
+ * The white paper of AES-NI instructions can be downloaded from:
+ *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-Set_WP.pdf
+ *
+ * Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *            Vinodh Gopal <vinodh.gopal@intel.com>
+ *            Kahraman Akdemir
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+
+.text
+
+#define STATE1	%xmm0
+#define STATE2	%xmm4
+#define STATE3	%xmm5
+#define STATE4	%xmm6
+#define STATE	STATE1
+#define IN1	%xmm1
+#define IN2	%xmm7
+#define IN3	%xmm8
+#define IN4	%xmm9
+#define IN	IN1
+#define KEY	%xmm2
+#define IV	%xmm3
+#define BSWAP_MASK %xmm10
+#define CTR	%xmm11
+#define INC	%xmm12
+
+#define KEYP	%rdi
+#define OUTP	%rsi
+#define INP	%rdx
+#define LEN	%rcx
+#define IVP	%r8
+#define KLEN	%r9d
+#define T1	%r10
+#define TKEYP	T1
+#define T2	%r11
+#define TCTR_LOW T2
+
+_key_expansion_128:
+_key_expansion_256a:
+	pshufd $0b11111111, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+	movaps %xmm0, (%rcx)
+	add $0x10, %rcx
+	ret
+
+_key_expansion_192a:
+	pshufd $0b01010101, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+
+	movaps %xmm2, %xmm5
+	movaps %xmm2, %xmm6
+	pslldq $4, %xmm5
+	pshufd $0b11111111, %xmm0, %xmm3
+	pxor %xmm3, %xmm2
+	pxor %xmm5, %xmm2
+
+	movaps %xmm0, %xmm1
+	shufps $0b01000100, %xmm0, %xmm6
+	movaps %xmm6, (%rcx)
+	shufps $0b01001110, %xmm2, %xmm1
+	movaps %xmm1, 16(%rcx)
+	add $0x20, %rcx
+	ret
+
+_key_expansion_192b:
+	pshufd $0b01010101, %xmm1, %xmm1
+	shufps $0b00010000, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	shufps $0b10001100, %xmm0, %xmm4
+	pxor %xmm4, %xmm0
+	pxor %xmm1, %xmm0
+
+	movaps %xmm2, %xmm5
+	pslldq $4, %xmm5
+	pshufd $0b11111111, %xmm0, %xmm3
+	pxor %xmm3, %xmm2
+	pxor %xmm5, %xmm2
+
+	movaps %xmm0, (%rcx)
+	add $0x10, %rcx
+	ret
+
+_key_expansion_256b:
+	pshufd $0b10101010, %xmm1, %xmm1
+	shufps $0b00010000, %xmm2, %xmm4
+	pxor %xmm4, %xmm2
+	shufps $0b10001100, %xmm2, %xmm4
+	pxor %xmm4, %xmm2
+	pxor %xmm1, %xmm2
+	movaps %xmm2, (%rcx)
+	add $0x10, %rcx
+	ret
+
+/*
+ * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+ *                   unsigned int key_len)
+ */
+ENTRY(aesni_set_key)
+	movups (%rsi), %xmm0		# user key (first 16 bytes)
+	movaps %xmm0, (%rdi)
+	lea 0x10(%rdi), %rcx		# key addr
+	movl %edx, 480(%rdi)
+	pxor %xmm4, %xmm4		# xmm4 is assumed 0 in _key_expansion_x
+	cmp $24, %dl
+	jb .Lenc_key128
+	je .Lenc_key192
+	movups 0x10(%rsi), %xmm2	# other user key
+	movaps %xmm2, (%rcx)
+	add $0x10, %rcx
+	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x1 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x2 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x4 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x8 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x10 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	call _key_expansion_256a
+	AESKEYGENASSIST 0x20 %xmm0 %xmm1
+	call _key_expansion_256b
+	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	call _key_expansion_256a
+	jmp .Ldec_key
+.Lenc_key192:
+	movq 0x10(%rsi), %xmm2		# other user key
+	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	call _key_expansion_192b
+	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	call _key_expansion_192a
+	AESKEYGENASSIST 0x80 %xmm2 %xmm1	# round 8
+	call _key_expansion_192b
+	jmp .Ldec_key
+.Lenc_key128:
+	AESKEYGENASSIST 0x1 %xmm0 %xmm1		# round 1
+	call _key_expansion_128
+	AESKEYGENASSIST 0x2 %xmm0 %xmm1		# round 2
+	call _key_expansion_128
+	AESKEYGENASSIST 0x4 %xmm0 %xmm1		# round 3
+	call _key_expansion_128
+	AESKEYGENASSIST 0x8 %xmm0 %xmm1		# round 4
+	call _key_expansion_128
+	AESKEYGENASSIST 0x10 %xmm0 %xmm1	# round 5
+	call _key_expansion_128
+	AESKEYGENASSIST 0x20 %xmm0 %xmm1	# round 6
+	call _key_expansion_128
+	AESKEYGENASSIST 0x40 %xmm0 %xmm1	# round 7
+	call _key_expansion_128
+	AESKEYGENASSIST 0x80 %xmm0 %xmm1	# round 8
+	call _key_expansion_128
+	AESKEYGENASSIST 0x1b %xmm0 %xmm1	# round 9
+	call _key_expansion_128
+	AESKEYGENASSIST 0x36 %xmm0 %xmm1	# round 10
+	call _key_expansion_128
+.Ldec_key:
+	sub $0x10, %rcx
+	movaps (%rdi), %xmm0
+	movaps (%rcx), %xmm1
+	movaps %xmm0, 240(%rcx)
+	movaps %xmm1, 240(%rdi)
+	add $0x10, %rdi
+	lea 240-16(%rcx), %rsi
+.align 4
+.Ldec_key_loop:
+	movaps (%rdi), %xmm0
+	AESIMC %xmm0 %xmm1
+	movaps %xmm1, (%rsi)
+	add $0x10, %rdi
+	sub $0x10, %rsi
+	cmp %rcx, %rdi
+	jb .Ldec_key_loop
+	xor %rax, %rax
+	ret
+
+/*
+ * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ */
+ENTRY(aesni_enc)
+	movl 480(KEYP), KLEN		# key length
+	movups (INP), STATE		# input
+	call _aesni_enc1
+	movups STATE, (OUTP)		# output
+	ret
+
+/*
+ * _aesni_enc1:		internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	KLEN:		round count
+ *	STATE:		initial state (input)
+ * output:
+ *	STATE:		finial state (output)
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_enc1:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE		# round 0
+	add $0x30, TKEYP
+	cmp $24, KLEN
+	jb .Lenc128
+	lea 0x20(TKEYP), TKEYP
+	je .Lenc192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x50(TKEYP), KEY
+	AESENC KEY STATE
+.align 4
+.Lenc192:
+	movaps -0x40(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x30(TKEYP), KEY
+	AESENC KEY STATE
+.align 4
+.Lenc128:
+	movaps -0x20(TKEYP), KEY
+	AESENC KEY STATE
+	movaps -0x10(TKEYP), KEY
+	AESENC KEY STATE
+	movaps (TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x10(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x20(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x30(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x40(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x50(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x60(TKEYP), KEY
+	AESENC KEY STATE
+	movaps 0x70(TKEYP), KEY
+	AESENCLAST KEY STATE
+	ret
+
+/*
+ * _aesni_enc4:	internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	KLEN:		round count
+ *	STATE1:		initial state (input)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * output:
+ *	STATE1:		finial state (output)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_enc4:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE1		# round 0
+	pxor KEY, STATE2
+	pxor KEY, STATE3
+	pxor KEY, STATE4
+	add $0x30, TKEYP
+	cmp $24, KLEN
+	jb .L4enc128
+	lea 0x20(TKEYP), TKEYP
+	je .L4enc192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x50(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+#.align 4
+.L4enc192:
+	movaps -0x40(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x30(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+#.align 4
+.L4enc128:
+	movaps -0x20(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps -0x10(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps (TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x10(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x20(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x30(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x40(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x50(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x60(TKEYP), KEY
+	AESENC KEY STATE1
+	AESENC KEY STATE2
+	AESENC KEY STATE3
+	AESENC KEY STATE4
+	movaps 0x70(TKEYP), KEY
+	AESENCLAST KEY STATE1		# last round
+	AESENCLAST KEY STATE2
+	AESENCLAST KEY STATE3
+	AESENCLAST KEY STATE4
+	ret
+
+/*
+ * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ */
+ENTRY(aesni_dec)
+	mov 480(KEYP), KLEN		# key length
+	add $240, KEYP
+	movups (INP), STATE		# input
+	call _aesni_dec1
+	movups STATE, (OUTP)		#output
+	ret
+
+/*
+ * _aesni_dec1:		internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	KLEN:		key length
+ *	STATE:		initial state (input)
+ * output:
+ *	STATE:		finial state (output)
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_dec1:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE		# round 0
+	add $0x30, TKEYP
+	cmp $24, KLEN
+	jb .Ldec128
+	lea 0x20(TKEYP), TKEYP
+	je .Ldec192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x50(TKEYP), KEY
+	AESDEC KEY STATE
+.align 4
+.Ldec192:
+	movaps -0x40(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x30(TKEYP), KEY
+	AESDEC KEY STATE
+.align 4
+.Ldec128:
+	movaps -0x20(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps -0x10(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps (TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x10(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x20(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x30(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x40(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x50(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x60(TKEYP), KEY
+	AESDEC KEY STATE
+	movaps 0x70(TKEYP), KEY
+	AESDECLAST KEY STATE
+	ret
+
+/*
+ * _aesni_dec4:	internal ABI
+ * input:
+ *	KEYP:		key struct pointer
+ *	KLEN:		key length
+ *	STATE1:		initial state (input)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * output:
+ *	STATE1:		finial state (output)
+ *	STATE2
+ *	STATE3
+ *	STATE4
+ * changed:
+ *	KEY
+ *	TKEYP (T1)
+ */
+_aesni_dec4:
+	movaps (KEYP), KEY		# key
+	mov KEYP, TKEYP
+	pxor KEY, STATE1		# round 0
+	pxor KEY, STATE2
+	pxor KEY, STATE3
+	pxor KEY, STATE4
+	add $0x30, TKEYP
+	cmp $24, KLEN
+	jb .L4dec128
+	lea 0x20(TKEYP), TKEYP
+	je .L4dec192
+	add $0x20, TKEYP
+	movaps -0x60(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x50(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+.align 4
+.L4dec192:
+	movaps -0x40(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x30(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+.align 4
+.L4dec128:
+	movaps -0x20(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps -0x10(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps (TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x10(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x20(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x30(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x40(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x50(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x60(TKEYP), KEY
+	AESDEC KEY STATE1
+	AESDEC KEY STATE2
+	AESDEC KEY STATE3
+	AESDEC KEY STATE4
+	movaps 0x70(TKEYP), KEY
+	AESDECLAST KEY STATE1		# last round
+	AESDECLAST KEY STATE2
+	AESDECLAST KEY STATE3
+	AESDECLAST KEY STATE4
+	ret
+
+/*
+ * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len)
+ */
+ENTRY(aesni_ecb_enc)
+	test LEN, LEN		# check length
+	jz .Lecb_enc_ret
+	mov 480(KEYP), KLEN
+	cmp $16, LEN
+	jb .Lecb_enc_ret
+	cmp $64, LEN
+	jb .Lecb_enc_loop1
+.align 4
+.Lecb_enc_loop4:
+	movups (INP), STATE1
+	movups 0x10(INP), STATE2
+	movups 0x20(INP), STATE3
+	movups 0x30(INP), STATE4
+	call _aesni_enc4
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lecb_enc_loop4
+	cmp $16, LEN
+	jb .Lecb_enc_ret
+.align 4
+.Lecb_enc_loop1:
+	movups (INP), STATE1
+	call _aesni_enc1
+	movups STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_enc_loop1
+.Lecb_enc_ret:
+	ret
+
+/*
+ * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len);
+ */
+ENTRY(aesni_ecb_dec)
+	test LEN, LEN
+	jz .Lecb_dec_ret
+	mov 480(KEYP), KLEN
+	add $240, KEYP
+	cmp $16, LEN
+	jb .Lecb_dec_ret
+	cmp $64, LEN
+	jb .Lecb_dec_loop1
+.align 4
+.Lecb_dec_loop4:
+	movups (INP), STATE1
+	movups 0x10(INP), STATE2
+	movups 0x20(INP), STATE3
+	movups 0x30(INP), STATE4
+	call _aesni_dec4
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lecb_dec_loop4
+	cmp $16, LEN
+	jb .Lecb_dec_ret
+.align 4
+.Lecb_dec_loop1:
+	movups (INP), STATE1
+	call _aesni_dec1
+	movups STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_dec_loop1
+.Lecb_dec_ret:
+	ret
+
+/*
+ * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_cbc_enc)
+	cmp $16, LEN
+	jb .Lcbc_enc_ret
+	mov 480(KEYP), KLEN
+	movups (IVP), STATE	# load iv as initial state
+.align 4
+.Lcbc_enc_loop:
+	movups (INP), IN	# load input
+	pxor IN, STATE
+	call _aesni_enc1
+	movups STATE, (OUTP)	# store output
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_enc_loop
+	movups STATE, (IVP)
+.Lcbc_enc_ret:
+	ret
+
+/*
+ * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_cbc_dec)
+	cmp $16, LEN
+	jb .Lcbc_dec_just_ret
+	mov 480(KEYP), KLEN
+	add $240, KEYP
+	movups (IVP), IV
+	cmp $64, LEN
+	jb .Lcbc_dec_loop1
+.align 4
+.Lcbc_dec_loop4:
+	movups (INP), IN1
+	movaps IN1, STATE1
+	movups 0x10(INP), IN2
+	movaps IN2, STATE2
+	movups 0x20(INP), IN3
+	movaps IN3, STATE3
+	movups 0x30(INP), IN4
+	movaps IN4, STATE4
+	call _aesni_dec4
+	pxor IV, STATE1
+	pxor IN1, STATE2
+	pxor IN2, STATE3
+	pxor IN3, STATE4
+	movaps IN4, IV
+	movups STATE1, (OUTP)
+	movups STATE2, 0x10(OUTP)
+	movups STATE3, 0x20(OUTP)
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lcbc_dec_loop4
+	cmp $16, LEN
+	jb .Lcbc_dec_ret
+.align 4
+.Lcbc_dec_loop1:
+	movups (INP), IN
+	movaps IN, STATE
+	call _aesni_dec1
+	pxor IV, STATE
+	movups STATE, (OUTP)
+	movaps IN, IV
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_dec_loop1
+.Lcbc_dec_ret:
+	movups IV, (IVP)
+.Lcbc_dec_just_ret:
+	ret
+
+.align 16
+.Lbswap_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+/*
+ * _aesni_inc_init:	internal ABI
+ *	setup registers used by _aesni_inc
+ * input:
+ *	IV
+ * output:
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ */
+_aesni_inc_init:
+	movaps .Lbswap_mask, BSWAP_MASK
+	movaps IV, CTR
+	PSHUFB_XMM BSWAP_MASK CTR
+	mov $1, TCTR_LOW
+	MOVQ_R64_XMM TCTR_LOW INC
+	MOVQ_R64_XMM CTR TCTR_LOW
+	ret
+
+/*
+ * _aesni_inc:		internal ABI
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
+_aesni_inc:
+	paddq INC, CTR
+	add $1, TCTR_LOW
+	jnc .Linc_low
+	pslldq $8, INC
+	paddq INC, CTR
+	psrldq $8, INC
+.Linc_low:
+	movaps CTR, IV
+	PSHUFB_XMM BSWAP_MASK IV
+	ret
+
+/*
+ * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_ctr_enc)
+	cmp $16, LEN
+	jb .Lctr_enc_just_ret
+	mov 480(KEYP), KLEN
+	movups (IVP), IV
+	call _aesni_inc_init
+	cmp $64, LEN
+	jb .Lctr_enc_loop1
+.align 4
+.Lctr_enc_loop4:
+	movaps IV, STATE1
+	call _aesni_inc
+	movups (INP), IN1
+	movaps IV, STATE2
+	call _aesni_inc
+	movups 0x10(INP), IN2
+	movaps IV, STATE3
+	call _aesni_inc
+	movups 0x20(INP), IN3
+	movaps IV, STATE4
+	call _aesni_inc
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
+	jge .Lctr_enc_loop4
+	cmp $16, LEN
+	jb .Lctr_enc_ret
+.align 4
+.Lctr_enc_loop1:
+	movaps IV, STATE
+	call _aesni_inc
+	movups (INP), IN
+	call _aesni_enc1
+	pxor IN, STATE
+	movups STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lctr_enc_loop1
+.Lctr_enc_ret:
+	movups IV, (IVP)
+.Lctr_enc_just_ret:
+	ret
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
deleted file mode 100644
index ff16756..0000000
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ /dev/null
@@ -1,841 +0,0 @@
-/*
- * Implement AES algorithm in Intel AES-NI instructions.
- *
- * The white paper of AES-NI instructions can be downloaded from:
- *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-Set_WP.pdf
- *
- * Copyright (C) 2008, Intel Corp.
- *    Author: Huang Ying <ying.huang@intel.com>
- *            Vinodh Gopal <vinodh.gopal@intel.com>
- *            Kahraman Akdemir
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-#include <asm/inst.h>
-
-.text
-
-#define STATE1	%xmm0
-#define STATE2	%xmm4
-#define STATE3	%xmm5
-#define STATE4	%xmm6
-#define STATE	STATE1
-#define IN1	%xmm1
-#define IN2	%xmm7
-#define IN3	%xmm8
-#define IN4	%xmm9
-#define IN	IN1
-#define KEY	%xmm2
-#define IV	%xmm3
-#define BSWAP_MASK %xmm10
-#define CTR	%xmm11
-#define INC	%xmm12
-
-#define KEYP	%rdi
-#define OUTP	%rsi
-#define INP	%rdx
-#define LEN	%rcx
-#define IVP	%r8
-#define KLEN	%r9d
-#define T1	%r10
-#define TKEYP	T1
-#define T2	%r11
-#define TCTR_LOW T2
-
-_key_expansion_128:
-_key_expansion_256a:
-	pshufd $0b11111111, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-	movaps %xmm0, (%rcx)
-	add $0x10, %rcx
-	ret
-
-_key_expansion_192a:
-	pshufd $0b01010101, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-
-	movaps %xmm2, %xmm5
-	movaps %xmm2, %xmm6
-	pslldq $4, %xmm5
-	pshufd $0b11111111, %xmm0, %xmm3
-	pxor %xmm3, %xmm2
-	pxor %xmm5, %xmm2
-
-	movaps %xmm0, %xmm1
-	shufps $0b01000100, %xmm0, %xmm6
-	movaps %xmm6, (%rcx)
-	shufps $0b01001110, %xmm2, %xmm1
-	movaps %xmm1, 16(%rcx)
-	add $0x20, %rcx
-	ret
-
-_key_expansion_192b:
-	pshufd $0b01010101, %xmm1, %xmm1
-	shufps $0b00010000, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	shufps $0b10001100, %xmm0, %xmm4
-	pxor %xmm4, %xmm0
-	pxor %xmm1, %xmm0
-
-	movaps %xmm2, %xmm5
-	pslldq $4, %xmm5
-	pshufd $0b11111111, %xmm0, %xmm3
-	pxor %xmm3, %xmm2
-	pxor %xmm5, %xmm2
-
-	movaps %xmm0, (%rcx)
-	add $0x10, %rcx
-	ret
-
-_key_expansion_256b:
-	pshufd $0b10101010, %xmm1, %xmm1
-	shufps $0b00010000, %xmm2, %xmm4
-	pxor %xmm4, %xmm2
-	shufps $0b10001100, %xmm2, %xmm4
-	pxor %xmm4, %xmm2
-	pxor %xmm1, %xmm2
-	movaps %xmm2, (%rcx)
-	add $0x10, %rcx
-	ret
-
-/*
- * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
- *                   unsigned int key_len)
- */
-ENTRY(aesni_set_key)
-	movups (%rsi), %xmm0		# user key (first 16 bytes)
-	movaps %xmm0, (%rdi)
-	lea 0x10(%rdi), %rcx		# key addr
-	movl %edx, 480(%rdi)
-	pxor %xmm4, %xmm4		# xmm4 is assumed 0 in _key_expansion_x
-	cmp $24, %dl
-	jb .Lenc_key128
-	je .Lenc_key192
-	movups 0x10(%rsi), %xmm2	# other user key
-	movaps %xmm2, (%rcx)
-	add $0x10, %rcx
-	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x1 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x2 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x4 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x8 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x10 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
-	call _key_expansion_256a
-	AESKEYGENASSIST 0x20 %xmm0 %xmm1
-	call _key_expansion_256b
-	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
-	call _key_expansion_256a
-	jmp .Ldec_key
-.Lenc_key192:
-	movq 0x10(%rsi), %xmm2		# other user key
-	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
-	call _key_expansion_192a
-	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
-	call _key_expansion_192b
-	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
-	call _key_expansion_192a
-	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
-	call _key_expansion_192b
-	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
-	call _key_expansion_192a
-	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
-	call _key_expansion_192b
-	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
-	call _key_expansion_192a
-	AESKEYGENASSIST 0x80 %xmm2 %xmm1	# round 8
-	call _key_expansion_192b
-	jmp .Ldec_key
-.Lenc_key128:
-	AESKEYGENASSIST 0x1 %xmm0 %xmm1		# round 1
-	call _key_expansion_128
-	AESKEYGENASSIST 0x2 %xmm0 %xmm1		# round 2
-	call _key_expansion_128
-	AESKEYGENASSIST 0x4 %xmm0 %xmm1		# round 3
-	call _key_expansion_128
-	AESKEYGENASSIST 0x8 %xmm0 %xmm1		# round 4
-	call _key_expansion_128
-	AESKEYGENASSIST 0x10 %xmm0 %xmm1	# round 5
-	call _key_expansion_128
-	AESKEYGENASSIST 0x20 %xmm0 %xmm1	# round 6
-	call _key_expansion_128
-	AESKEYGENASSIST 0x40 %xmm0 %xmm1	# round 7
-	call _key_expansion_128
-	AESKEYGENASSIST 0x80 %xmm0 %xmm1	# round 8
-	call _key_expansion_128
-	AESKEYGENASSIST 0x1b %xmm0 %xmm1	# round 9
-	call _key_expansion_128
-	AESKEYGENASSIST 0x36 %xmm0 %xmm1	# round 10
-	call _key_expansion_128
-.Ldec_key:
-	sub $0x10, %rcx
-	movaps (%rdi), %xmm0
-	movaps (%rcx), %xmm1
-	movaps %xmm0, 240(%rcx)
-	movaps %xmm1, 240(%rdi)
-	add $0x10, %rdi
-	lea 240-16(%rcx), %rsi
-.align 4
-.Ldec_key_loop:
-	movaps (%rdi), %xmm0
-	AESIMC %xmm0 %xmm1
-	movaps %xmm1, (%rsi)
-	add $0x10, %rdi
-	sub $0x10, %rsi
-	cmp %rcx, %rdi
-	jb .Ldec_key_loop
-	xor %rax, %rax
-	ret
-
-/*
- * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
- */
-ENTRY(aesni_enc)
-	movl 480(KEYP), KLEN		# key length
-	movups (INP), STATE		# input
-	call _aesni_enc1
-	movups STATE, (OUTP)		# output
-	ret
-
-/*
- * _aesni_enc1:		internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		round count
- *	STATE:		initial state (input)
- * output:
- *	STATE:		finial state (output)
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-_aesni_enc1:
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE		# round 0
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .Lenc128
-	lea 0x20(TKEYP), TKEYP
-	je .Lenc192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	AESENC KEY STATE
-	movaps -0x50(TKEYP), KEY
-	AESENC KEY STATE
-.align 4
-.Lenc192:
-	movaps -0x40(TKEYP), KEY
-	AESENC KEY STATE
-	movaps -0x30(TKEYP), KEY
-	AESENC KEY STATE
-.align 4
-.Lenc128:
-	movaps -0x20(TKEYP), KEY
-	AESENC KEY STATE
-	movaps -0x10(TKEYP), KEY
-	AESENC KEY STATE
-	movaps (TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x10(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x20(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x30(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x40(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x50(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x60(TKEYP), KEY
-	AESENC KEY STATE
-	movaps 0x70(TKEYP), KEY
-	AESENCLAST KEY STATE
-	ret
-
-/*
- * _aesni_enc4:	internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		round count
- *	STATE1:		initial state (input)
- *	STATE2
- *	STATE3
- *	STATE4
- * output:
- *	STATE1:		finial state (output)
- *	STATE2
- *	STATE3
- *	STATE4
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-_aesni_enc4:
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE1		# round 0
-	pxor KEY, STATE2
-	pxor KEY, STATE3
-	pxor KEY, STATE4
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .L4enc128
-	lea 0x20(TKEYP), TKEYP
-	je .L4enc192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps -0x50(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-#.align 4
-.L4enc192:
-	movaps -0x40(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps -0x30(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-#.align 4
-.L4enc128:
-	movaps -0x20(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps -0x10(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps (TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x10(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x20(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x30(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x40(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x50(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x60(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
-	movaps 0x70(TKEYP), KEY
-	AESENCLAST KEY STATE1		# last round
-	AESENCLAST KEY STATE2
-	AESENCLAST KEY STATE3
-	AESENCLAST KEY STATE4
-	ret
-
-/*
- * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
- */
-ENTRY(aesni_dec)
-	mov 480(KEYP), KLEN		# key length
-	add $240, KEYP
-	movups (INP), STATE		# input
-	call _aesni_dec1
-	movups STATE, (OUTP)		#output
-	ret
-
-/*
- * _aesni_dec1:		internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		key length
- *	STATE:		initial state (input)
- * output:
- *	STATE:		finial state (output)
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-_aesni_dec1:
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE		# round 0
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .Ldec128
-	lea 0x20(TKEYP), TKEYP
-	je .Ldec192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps -0x50(TKEYP), KEY
-	AESDEC KEY STATE
-.align 4
-.Ldec192:
-	movaps -0x40(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps -0x30(TKEYP), KEY
-	AESDEC KEY STATE
-.align 4
-.Ldec128:
-	movaps -0x20(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps -0x10(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps (TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x10(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x20(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x30(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x40(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x50(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x60(TKEYP), KEY
-	AESDEC KEY STATE
-	movaps 0x70(TKEYP), KEY
-	AESDECLAST KEY STATE
-	ret
-
-/*
- * _aesni_dec4:	internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		key length
- *	STATE1:		initial state (input)
- *	STATE2
- *	STATE3
- *	STATE4
- * output:
- *	STATE1:		finial state (output)
- *	STATE2
- *	STATE3
- *	STATE4
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-_aesni_dec4:
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE1		# round 0
-	pxor KEY, STATE2
-	pxor KEY, STATE3
-	pxor KEY, STATE4
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .L4dec128
-	lea 0x20(TKEYP), TKEYP
-	je .L4dec192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps -0x50(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-.align 4
-.L4dec192:
-	movaps -0x40(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps -0x30(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-.align 4
-.L4dec128:
-	movaps -0x20(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps -0x10(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps (TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x10(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x20(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x30(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x40(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x50(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x60(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
-	movaps 0x70(TKEYP), KEY
-	AESDECLAST KEY STATE1		# last round
-	AESDECLAST KEY STATE2
-	AESDECLAST KEY STATE3
-	AESDECLAST KEY STATE4
-	ret
-
-/*
- * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len)
- */
-ENTRY(aesni_ecb_enc)
-	test LEN, LEN		# check length
-	jz .Lecb_enc_ret
-	mov 480(KEYP), KLEN
-	cmp $16, LEN
-	jb .Lecb_enc_ret
-	cmp $64, LEN
-	jb .Lecb_enc_loop1
-.align 4
-.Lecb_enc_loop4:
-	movups (INP), STATE1
-	movups 0x10(INP), STATE2
-	movups 0x20(INP), STATE3
-	movups 0x30(INP), STATE4
-	call _aesni_enc4
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lecb_enc_loop4
-	cmp $16, LEN
-	jb .Lecb_enc_ret
-.align 4
-.Lecb_enc_loop1:
-	movups (INP), STATE1
-	call _aesni_enc1
-	movups STATE1, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lecb_enc_loop1
-.Lecb_enc_ret:
-	ret
-
-/*
- * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len);
- */
-ENTRY(aesni_ecb_dec)
-	test LEN, LEN
-	jz .Lecb_dec_ret
-	mov 480(KEYP), KLEN
-	add $240, KEYP
-	cmp $16, LEN
-	jb .Lecb_dec_ret
-	cmp $64, LEN
-	jb .Lecb_dec_loop1
-.align 4
-.Lecb_dec_loop4:
-	movups (INP), STATE1
-	movups 0x10(INP), STATE2
-	movups 0x20(INP), STATE3
-	movups 0x30(INP), STATE4
-	call _aesni_dec4
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lecb_dec_loop4
-	cmp $16, LEN
-	jb .Lecb_dec_ret
-.align 4
-.Lecb_dec_loop1:
-	movups (INP), STATE1
-	call _aesni_dec1
-	movups STATE1, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lecb_dec_loop1
-.Lecb_dec_ret:
-	ret
-
-/*
- * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-ENTRY(aesni_cbc_enc)
-	cmp $16, LEN
-	jb .Lcbc_enc_ret
-	mov 480(KEYP), KLEN
-	movups (IVP), STATE	# load iv as initial state
-.align 4
-.Lcbc_enc_loop:
-	movups (INP), IN	# load input
-	pxor IN, STATE
-	call _aesni_enc1
-	movups STATE, (OUTP)	# store output
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lcbc_enc_loop
-	movups STATE, (IVP)
-.Lcbc_enc_ret:
-	ret
-
-/*
- * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-ENTRY(aesni_cbc_dec)
-	cmp $16, LEN
-	jb .Lcbc_dec_just_ret
-	mov 480(KEYP), KLEN
-	add $240, KEYP
-	movups (IVP), IV
-	cmp $64, LEN
-	jb .Lcbc_dec_loop1
-.align 4
-.Lcbc_dec_loop4:
-	movups (INP), IN1
-	movaps IN1, STATE1
-	movups 0x10(INP), IN2
-	movaps IN2, STATE2
-	movups 0x20(INP), IN3
-	movaps IN3, STATE3
-	movups 0x30(INP), IN4
-	movaps IN4, STATE4
-	call _aesni_dec4
-	pxor IV, STATE1
-	pxor IN1, STATE2
-	pxor IN2, STATE3
-	pxor IN3, STATE4
-	movaps IN4, IV
-	movups STATE1, (OUTP)
-	movups STATE2, 0x10(OUTP)
-	movups STATE3, 0x20(OUTP)
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lcbc_dec_loop4
-	cmp $16, LEN
-	jb .Lcbc_dec_ret
-.align 4
-.Lcbc_dec_loop1:
-	movups (INP), IN
-	movaps IN, STATE
-	call _aesni_dec1
-	pxor IV, STATE
-	movups STATE, (OUTP)
-	movaps IN, IV
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lcbc_dec_loop1
-.Lcbc_dec_ret:
-	movups IV, (IVP)
-.Lcbc_dec_just_ret:
-	ret
-
-.align 16
-.Lbswap_mask:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-
-/*
- * _aesni_inc_init:	internal ABI
- *	setup registers used by _aesni_inc
- * input:
- *	IV
- * output:
- *	CTR:	== IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- *	INC:	== 1, in little endian
- *	BSWAP_MASK == endian swapping mask
- */
-_aesni_inc_init:
-	movaps .Lbswap_mask, BSWAP_MASK
-	movaps IV, CTR
-	PSHUFB_XMM BSWAP_MASK CTR
-	mov $1, TCTR_LOW
-	MOVQ_R64_XMM TCTR_LOW INC
-	MOVQ_R64_XMM CTR TCTR_LOW
-	ret
-
-/*
- * _aesni_inc:		internal ABI
- *	Increase IV by 1, IV is in big endian
- * input:
- *	IV
- *	CTR:	== IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- *	INC:	== 1, in little endian
- *	BSWAP_MASK == endian swapping mask
- * output:
- *	IV:	Increase by 1
- * changed:
- *	CTR:	== output IV, in little endian
- *	TCTR_LOW: == lower qword of CTR
- */
-_aesni_inc:
-	paddq INC, CTR
-	add $1, TCTR_LOW
-	jnc .Linc_low
-	pslldq $8, INC
-	paddq INC, CTR
-	psrldq $8, INC
-.Linc_low:
-	movaps CTR, IV
-	PSHUFB_XMM BSWAP_MASK IV
-	ret
-
-/*
- * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *		      size_t len, u8 *iv)
- */
-ENTRY(aesni_ctr_enc)
-	cmp $16, LEN
-	jb .Lctr_enc_just_ret
-	mov 480(KEYP), KLEN
-	movups (IVP), IV
-	call _aesni_inc_init
-	cmp $64, LEN
-	jb .Lctr_enc_loop1
-.align 4
-.Lctr_enc_loop4:
-	movaps IV, STATE1
-	call _aesni_inc
-	movups (INP), IN1
-	movaps IV, STATE2
-	call _aesni_inc
-	movups 0x10(INP), IN2
-	movaps IV, STATE3
-	call _aesni_inc
-	movups 0x20(INP), IN3
-	movaps IV, STATE4
-	call _aesni_inc
-	movups 0x30(INP), IN4
-	call _aesni_enc4
-	pxor IN1, STATE1
-	movups STATE1, (OUTP)
-	pxor IN2, STATE2
-	movups STATE2, 0x10(OUTP)
-	pxor IN3, STATE3
-	movups STATE3, 0x20(OUTP)
-	pxor IN4, STATE4
-	movups STATE4, 0x30(OUTP)
-	sub $64, LEN
-	add $64, INP
-	add $64, OUTP
-	cmp $64, LEN
-	jge .Lctr_enc_loop4
-	cmp $16, LEN
-	jb .Lctr_enc_ret
-.align 4
-.Lctr_enc_loop1:
-	movaps IV, STATE
-	call _aesni_inc
-	movups (INP), IN
-	call _aesni_enc1
-	pxor IN, STATE
-	movups STATE, (OUTP)
-	sub $16, LEN
-	add $16, INP
-	add $16, OUTP
-	cmp $16, LEN
-	jge .Lctr_enc_loop1
-.Lctr_enc_ret:
-	movups IV, (IVP)
-.Lctr_enc_just_ret:
-	ret
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2cb3dcc..39f6238 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -59,8 +59,10 @@ asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+#endif
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -324,6 +326,7 @@ static struct crypto_alg blk_cbc_alg = {
 	},
 };
 
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 			    struct blkcipher_walk *walk)
 {
@@ -389,6 +392,7 @@ static struct crypto_alg blk_ctr_alg = {
 		},
 	},
 };
+#endif
 
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
@@ -536,6 +540,7 @@ static struct crypto_alg ablk_cbc_alg = {
 	},
 };
 
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 static int ablk_ctr_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -612,6 +617,7 @@ static struct crypto_alg ablk_rfc3686_ctr_alg = {
 	},
 };
 #endif
+#endif
 
 #ifdef HAS_LRW
 static int ablk_lrw_init(struct crypto_tfm *tfm)
@@ -746,18 +752,22 @@ static int __init aesni_init(void)
 		goto blk_ecb_err;
 	if ((err = crypto_register_alg(&blk_cbc_alg)))
 		goto blk_cbc_err;
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 	if ((err = crypto_register_alg(&blk_ctr_alg)))
 		goto blk_ctr_err;
+#endif
 	if ((err = crypto_register_alg(&ablk_ecb_alg)))
 		goto ablk_ecb_err;
 	if ((err = crypto_register_alg(&ablk_cbc_alg)))
 		goto ablk_cbc_err;
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 	if ((err = crypto_register_alg(&ablk_ctr_alg)))
 		goto ablk_ctr_err;
 #ifdef HAS_CTR
 	if ((err = crypto_register_alg(&ablk_rfc3686_ctr_alg)))
 		goto ablk_rfc3686_ctr_err;
 #endif
+#endif
 #ifdef HAS_LRW
 	if ((err = crypto_register_alg(&ablk_lrw_alg)))
 		goto ablk_lrw_err;
@@ -784,18 +794,22 @@ ablk_pcbc_err:
 	crypto_unregister_alg(&ablk_lrw_alg);
 ablk_lrw_err:
 #endif
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 #ifdef HAS_CTR
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 ablk_rfc3686_ctr_err:
 #endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 ablk_ctr_err:
+#endif
 	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
 	crypto_unregister_alg(&ablk_ecb_alg);
 ablk_ecb_err:
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 	crypto_unregister_alg(&blk_ctr_alg);
 blk_ctr_err:
+#endif
 	crypto_unregister_alg(&blk_cbc_alg);
 blk_cbc_err:
 	crypto_unregister_alg(&blk_ecb_alg);
@@ -818,13 +832,17 @@ static void __exit aesni_exit(void)
 #ifdef HAS_LRW
 	crypto_unregister_alg(&ablk_lrw_alg);
 #endif
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 #ifdef HAS_CTR
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 #endif
 	crypto_unregister_alg(&ablk_ctr_alg);
+#endif
 	crypto_unregister_alg(&ablk_cbc_alg);
 	crypto_unregister_alg(&ablk_ecb_alg);
+#ifdef CONFIG_CRYPTO_AES_NI_INTEL_X86_64
 	crypto_unregister_alg(&blk_ctr_alg);
+#endif
 	crypto_unregister_alg(&blk_cbc_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
 	crypto_unregister_alg(&__aesni_alg);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e4bac29..7f917c6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -537,7 +537,37 @@ config CRYPTO_AES_X86_64
 
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 
-config CRYPTO_AES_NI_INTEL
+config CRYPTO_AES_NI_INTEL_586
+	tristate "AES cipher algorithms (AES-NI)"
+	depends on (X86 || UML_X86) && !64BIT
+	select CRYPTO_AES_586
+	select CRYPTO_CRYPTD
+	select CRYPTO_ALGAPI
+	select CRYPTO_FPU
+	help
+	  Use Intel AES-NI instructions for AES algorithm.
+
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+
+	  Rijndael appears to be consistently a very good performer in
+	  both hardware and software across a wide range of computing
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
+	  In addition to AES cipher algorithm support, the
+	  acceleration for some popular block cipher mode is supported
+	  too, including ECB, CBC, CTR, LRW, PCBC, XTS.
+
+config CRYPTO_AES_NI_INTEL_X86_64
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_AES_X86_64
-- 
1.5.6.5
