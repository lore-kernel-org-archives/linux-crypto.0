From: Huang Ying <ying.huang@intel.com>
Subject: [RFC PATCH crypto] AES: Add support to Intel AES-NI instructions
Date: Fri, 12 Dec 2008 12:08:46 +0800
Message-ID: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xGXo7FgxnLaY3e7cLOzk"
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbYLLEIv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Dec 2008 23:08:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-xGXo7FgxnLaY3e7cLOzk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Add support to Intel AES-NI instructions for x86_64 platform.

Intel AES-NI is a new set of Single Instruction Multiple Data (SIMD)
instructions that are going to be introduced in the next generation of
Intel processor, as of 2009. These instructions enable fast and secure
data encryption and decryption, using the Advanced Encryption Standard
(AES), defined by FIPS Publication number 197.  The architecture
introduces six instructions that offer full hardware support for
AES. Four of them support high performance data encryption and
decryption, and the other two instructions support the AES key
expansion procedure.

The white paper can be downloaded from:

http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-=
Set_WP.pdf

AES may be used in soft_irq context, but MMX/SSE context can not be
touched safely in soft_irq context. So in_interrupt() is checked, if
in IRQ or soft_irq context, the general x86_64 implementation are used
instead.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aes_glue.c        |   10 -
 arch/x86/include/asm/aes.h        |    9 +
 arch/x86/include/asm/cpufeature.h |    1=20
 drivers/crypto/Kconfig            |   11 +
 drivers/crypto/Makefile           |    3=20
 drivers/crypto/intel-aes_asm.S    |  341 +++++++++++++++++++++++++++++++++=
+++++
 drivers/crypto/intel-aes_glue.c   |  132 ++++++++++++++
 7 files changed, 503 insertions(+), 4 deletions(-)

--- /dev/null
+++ b/drivers/crypto/intel-aes_glue.c
@@ -0,0 +1,132 @@
+/*
+ * Support for Intel AES-NI instructions. This file contains glue
+ * code, the real AES implementation is in intel-aes_asm.S.
+ *
+ * Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <crypto/aes.h>
+#include <linux/hardirq.h>
+#include <asm/i387.h>
+#include <asm/aes.h>
+
+#define INTEL_AES_ALIGN	16
+
+struct aes_ctx {
+	u32 key_enc[60];
+	u32 key_dec[60];
+	u32 key_length;
+};
+
+asmlinkage int intel_aes_set_key(struct aes_ctx *ctx, const u8 *in_key,
+				unsigned int key_len);
+asmlinkage void intel_aes_enc(struct aes_ctx *ctx, u8 *out, const u8 *in);
+asmlinkage void intel_aes_dec(struct aes_ctx *ctx, u8 *out, const u8 *in);
+
+static inline struct aes_ctx *aes_ctx(struct crypto_tfm *tfm)
+{
+	unsigned long addr =3D (unsigned long)crypto_tfm_ctx(tfm);
+	unsigned long align =3D INTEL_AES_ALIGN;
+
+	if (align <=3D crypto_tfm_ctx_alignment())
+		align =3D 1;
+	return (struct aes_ctx *)ALIGN(addr, align);
+}
+
+static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	struct aes_ctx *ctx =3D aes_ctx(tfm);
+	u32 *tfm_flags =3D &tfm->crt_flags;
+	int ret;
+
+	if (key_len % 8) {
+		*tfm_flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	if (in_interrupt())
+		ret =3D crypto_aes_set_key(tfm, in_key, key_len);
+	else {
+		kernel_fpu_begin();
+		ret =3D intel_aes_set_key(ctx, in_key, key_len);
+		kernel_fpu_end();
+	}
+
+	return ret;
+}
+
+static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct aes_ctx *ctx =3D aes_ctx(tfm);
+
+	if (in_interrupt())
+		crypto_aes_encrypt_x86(tfm, dst, src);
+	else {
+		kernel_fpu_begin();
+		intel_aes_enc(ctx, dst, src);
+		kernel_fpu_end();
+	}
+}
+
+static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct aes_ctx *ctx =3D aes_ctx(tfm);
+
+	if (in_interrupt())
+		crypto_aes_decrypt_x86(tfm, dst, src);
+	else {
+		kernel_fpu_begin();
+		intel_aes_dec(ctx, dst, src);
+		kernel_fpu_end();
+	}
+}
+
+static struct crypto_alg intel_aes_alg =3D {
+	.cra_name		=3D "aes",
+	.cra_driver_name	=3D "aes-intel",
+	.cra_priority		=3D 300,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct aes_ctx),
+	.cra_alignmask		=3D INTEL_AES_ALIGN - 1,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(intel_aes_alg.cra_list),
+	.cra_u	=3D {
+		.cipher	=3D {
+			.cia_min_keysize	=3D AES_MIN_KEY_SIZE,
+			.cia_max_keysize	=3D AES_MAX_KEY_SIZE,
+			.cia_setkey		=3D aes_set_key,
+			.cia_encrypt		=3D aes_encrypt,
+			.cia_decrypt		=3D aes_decrypt
+		}
+	}
+};
+
+static int __init intel_aes_init(void)
+{
+	if (!cpu_has_aes) {
+		printk(KERN_ERR "Intel AES instructions are not detected.\n");
+		return -ENODEV;
+	}
+	return crypto_register_alg(&intel_aes_alg);
+}
+
+static void __exit intel_aes_fini(void)
+{
+	crypto_unregister_alg(&intel_aes_alg);
+}
+
+module_init(intel_aes_init);
+module_exit(intel_aes_fini);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, Intel AES-NI instruct=
ions optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-intel");
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -200,4 +200,15 @@ config CRYPTO_DEV_IXP4XX
 	help
 	  Driver for the IXP4xx NPE crypto engine.
=20
+config CRYPTO_DEV_INTEL_AES
+	tristate "Support for Intel AES-NI instructions"
+	depends on X86_64 && !UML
+	select CRYPTO_AES_X86_64
+	select CRYPTO_ALGAPI
+	help
+	  Use Intel AES-NI instructions for AES algorithm.
+
+	  The instructions are used only when the CPU supports them.
+	  Otherwise software encryption is used.
+
 endif # CRYPTO_HW
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -4,3 +4,6 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) +=3D ixp4xx_crypto.o
+obj-$(CONFIG_CRYPTO_DEV_INTEL_AES) +=3D intel-aes.o
+
+intel-aes-y :=3D intel-aes_asm.o intel-aes_glue.o
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -210,6 +210,7 @@ extern const char * const x86_power_flag
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
 #define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_xmm3		boot_cpu_has(X86_FEATURE_XMM3)
+#define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
--- /dev/null
+++ b/drivers/crypto/intel-aes_asm.S
@@ -0,0 +1,341 @@
+/*
+ * Implement AES algorithm in Intel AES-NI instructions.
+ *
+ * The white paper of AES-NI instructions can be downloaded from:
+ *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instruc=
tions-Set_WP.pdf
+ *
+ * Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+.text
+
+#include <linux/linkage.h>
+
+key_expansion_128:
+	movaps %xmm1, %xmm4
+	psrldq $12, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm1, %xmm0
+
+	movaps %xmm0, (%rcx)
+	add $0x10, %rcx
+	ret
+
+key_expansion_192:
+	pshufd $0b01010101, %xmm1, %xmm1
+	movaps %xmm1, %xmm4
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm1, %xmm0
+
+	pshufd $0b11111111, %xmm0, %xmm3
+	pxor %xmm2, %xmm3
+	palignr $12, %xmm0, %xmm3
+	pxor %xmm2, %xmm3
+
+	test %r9, %r9
+	not %r9
+	jnz 1f
+
+	movaps %xmm0, %xmm1
+	pslldq $8, %xmm2
+	palignr $8, %xmm2, %xmm1
+	movaps %xmm1, (%rcx)
+	add $0x10, %rcx
+	movaps %xmm3, %xmm2
+	palignr $8, %xmm0, %xmm3
+	movaps %xmm3, (%rcx)
+	add $0x10, %rcx
+	ret
+1:
+	movaps %xmm0, (%rcx)
+	add $0x10, %rcx
+	movaps %xmm3, %xmm2
+	ret
+
+key_expansion_256:
+	movaps %xmm1, %xmm4
+	psrldq $12, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm0, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm1, %xmm0
+
+	movaps %xmm0, (%rcx)
+	add $0x10, %rcx
+
+	test %r9, %r9
+	jnz 1f
+
+	# aeskeygenassist $0x1, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x01
+
+	pshufd $0b10101010, %xmm1, %xmm1
+	movaps %xmm1, %xmm4
+	pxor %xmm2, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm2, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm2, %xmm1
+	palignr $12, %xmm4, %xmm1
+	pxor %xmm1, %xmm2
+
+	movaps %xmm2, (%rcx)
+	add $0x10, %rcx
+1:
+	ret
+
+ENTRY(intel_aes_set_key)
+	movups (%rsi), %xmm0		# user key (first 16 bytes)
+	movaps %xmm0, (%rdi)
+	lea 0x10(%rdi), %rcx		# key addr
+	mov %edx, 480(%rdi)		# key len
+	cmp $24, %dl
+	jb 2f
+	je 1f
+	movups 0x10(%rsi), %xmm2		# other user key
+	movaps %xmm2, (%rcx)
+	lea 0x10(%rcx), %rcx
+	xor %r9, %r9
+	# aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x01
+	call key_expansion_256
+	# aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x02
+	call key_expansion_256
+	# aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x04
+	call key_expansion_256
+	# aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x08
+	call key_expansion_256
+	# aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x10
+	call key_expansion_256
+	# aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x20
+	call key_expansion_256
+	# aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x40
+	not %r9
+	call key_expansion_256
+	lea 224(%rdi), %rdx
+	jmp 3f
+1:
+	mov $192, %edx
+	movq 0x10(%rsi), %xmm2			# other user key
+	xor %r9, %r9
+	# aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x01
+	call key_expansion_192
+	# aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x02
+	call key_expansion_192
+	# aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x04
+	call key_expansion_192
+	# aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x08
+	call key_expansion_192
+	# aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x10
+	call key_expansion_192
+	# aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x20
+	call key_expansion_192
+	# aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x40
+	call key_expansion_192
+	# aeskeygenassist $0x80, %xmm2, %xmm1	# round 8
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x80
+	call key_expansion_192
+	lea 192(%rdi), %rdx
+	jmp 3f
+2:
+	# aeskeygenassist $0x1, %xmm0, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x01
+	call key_expansion_128
+	# aeskeygenassist $0x2, %xmm0, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x02
+	call key_expansion_128
+	# aeskeygenassist $0x4, %xmm0, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x04
+	call key_expansion_128
+	# aeskeygenassist $0x8, %xmm0, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x08
+	call key_expansion_128
+	# aeskeygenassist $0x10, %xmm0, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x10
+	call key_expansion_128
+	# aeskeygenassist $0x20, %xmm0, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x20
+	call key_expansion_128
+	# aeskeygenassist $0x40, %xmm0, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x40
+	call key_expansion_128
+	# aeskeygenassist $0x80, %xmm0, %xmm1	# round 8
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x80
+	call key_expansion_128
+	# aeskeygenassist $0x1b, %xmm0, %xmm1	# round 9
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x1b
+	call key_expansion_128
+	# aeskeygenassist $0x36, %xmm0, %xmm1	# round 10
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x36
+	call key_expansion_128
+	lea 160(%rdi), %rdx
+3:
+	movaps (%rdi), %xmm0
+	movaps (%rdx), %xmm1
+	movaps %xmm0, 240(%rdx)
+	movaps %xmm1, 240(%rdi)
+	lea 0x10(%rdi), %rdi
+	lea 224(%rdx), %rsi
+4:
+	movaps (%rdi), %xmm0
+	# aesimc %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x38, 0xdb, 0xc8
+	movaps %xmm1, (%rsi)
+	lea 0x10(%rdi), %rdi
+	lea -0x10(%rsi), %rsi
+	cmp %rdx, %rdi
+	jb 4b
+	xor %rax, %rax
+	ret
+END(intel_aes_set_key)
+
+ENTRY(intel_aes_enc)
+	movups (%rdx), %xmm0		# input
+	mov 480(%rdi), %ecx		# key length
+	movaps (%rdi), %xmm1		# key
+	pxor %xmm1, %xmm0		# round 0
+	lea 0x30(%rdi), %rdi
+	cmp $24, %cl
+	jb 2f
+	lea 0x20(%rdi), %rdi
+	je 1f
+	lea 0x20(%rdi), %rdi
+	movaps -0x60(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps -0x50(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+1:
+	movaps -0x40(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps -0x30(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+2:
+	movaps -0x20(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps -0x10(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps (%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x10(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x20(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x30(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x40(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x50(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x60(%rdi), %xmm1
+	# aesenc %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc1
+	movaps 0x70(%rdi), %xmm1
+	# aesenclast %xmm1, %xmm0	# last round
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xc1
+	movups %xmm0, (%rsi)		# output
+	ret
+END(intel_aes_enc)
+
+ENTRY(intel_aes_dec)
+	movups (%rdx), %xmm0		# input
+	mov 480(%rdi), %ecx		# key length
+	lea 240(%rdi), %rdi
+	movaps (%rdi), %xmm1		# key
+	pxor %xmm1, %xmm0		# round 0
+	lea 0x30(%rdi), %rdi
+	cmp $24, %cl
+	jb 2f
+	lea 0x20(%rdi), %rdi
+	je 1f
+	lea 0x20(%rdi), %rdi
+	movaps -0x60(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps -0x50(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+1:
+	movaps -0x40(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps -0x30(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+2:
+	movaps -0x20(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps -0x10(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps (%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x10(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x20(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x30(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x40(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x50(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x60(%rdi), %xmm1
+	# aesdec %xmm1, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc1
+	movaps 0x70(%rdi), %xmm1
+	# aesdeclast %xmm1, %xmm0	# last round
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xc1
+	movups %xmm0, (%rsi)		# output
+	ret
+END(intel_aes_dec)
--- /dev/null
+++ b/arch/x86/include/asm/aes.h
@@ -0,0 +1,9 @@
+#ifndef ASM_X86_AES_H
+#define ASM_X86_AES_H
+
+#include <linux/crypto.h>
+
+void crypto_aes_encrypt_x86(struct crypto_tfm *tfm, u8 *dst, const u8 *src=
);
+void crypto_aes_decrypt_x86(struct crypto_tfm *tfm, u8 *dst, const u8 *src=
);
+
+#endif
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -8,15 +8,17 @@
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in)=
;
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in)=
;
=20
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+void crypto_aes_encrypt_x86(struct crypto_tfm *tfm, u8 *dst, const u8 *src=
)
 {
 	aes_enc_blk(tfm, dst, src);
 }
+EXPORT_SYMBOL_GPL(crypto_aes_encrypt_x86);
=20
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+void crypto_aes_decrypt_x86(struct crypto_tfm *tfm, u8 *dst, const u8 *src=
)
 {
 	aes_dec_blk(tfm, dst, src);
 }
+EXPORT_SYMBOL_GPL(crypto_aes_decrypt_x86);
=20
 static struct crypto_alg aes_alg =3D {
 	.cra_name		=3D "aes",
@@ -32,8 +34,8 @@ static struct crypto_alg aes_alg =3D {
 			.cia_min_keysize	=3D AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=3D AES_MAX_KEY_SIZE,
 			.cia_setkey		=3D crypto_aes_set_key,
-			.cia_encrypt		=3D aes_encrypt,
-			.cia_decrypt		=3D aes_decrypt
+			.cia_encrypt		=3D crypto_aes_encrypt_x86,
+			.cia_decrypt		=3D crypto_aes_decrypt_x86
 		}
 	}
 };


--=-xGXo7FgxnLaY3e7cLOzk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklB48wACgkQKhFGF+eHlpjgfwCdG1XR6QU2H2CxiyvBiWLZT3nR
HlcAoKCRduZ0/VB6U+9YrWOQVrqACX//
=dyhd
-----END PGP SIGNATURE-----

--=-xGXo7FgxnLaY3e7cLOzk--

