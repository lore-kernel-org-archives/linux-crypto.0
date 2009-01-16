From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH crypto -v5 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 15:10:25 +0800
Message-ID: <1232089825.13948.30.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HjD2U9uX3GbQIALUJQLF"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44383 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbZAPHK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2009 02:10:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-HjD2U9uX3GbQIALUJQLF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

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

ChangeLog:

v4:

- Pre-assemble AES-NI instructions, because they are not supported by
  old binutils.

v3:

- Use cryptd(%s) to delay a crypto request instead of work queue.

v2:

- Rename file name and function name to aesni_<xx>

- Move to arch/x86/crypto.

- ECB and CBC modes are implemented in parallel style to take
  advantage of pipelined hardware implementation.

- AES key scheduling algorithm is re-implemented with higher
  performance.

- ablkcipher asynchronous machanism is used to delay a crypto request
  to work queue context upon FPU state is using by other kernel
  context.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/Makefile           |    3=20
 arch/x86/crypto/aesni-intel_asm.S  |  896 ++++++++++++++++++++++++++++++++=
+++++
 arch/x86/crypto/aesni-intel_glue.c |  461 +++++++++++++++++++
 arch/x86/include/asm/cpufeature.h  |    1=20
 crypto/Kconfig                     |   25 +
 5 files changed, 1386 insertions(+)

--- /dev/null
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -0,0 +1,461 @@
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
+#include <linux/hardirq.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/cryptd.h>
+#include <asm/i387.h>
+#include <asm/aes.h>
+
+struct async_aes_ctx {
+	struct cryptd_ablkcipher *cryptd_tfm;
+};
+
+#define AESNI_ALIGN	16
+#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
+
+asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+			     unsigned int key_len);
+asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			  const u8 *in);
+asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			  const u8 *in);
+asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len);
+asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len);
+asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+
+static inline int kernel_fpu_using(void)
+{
+	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
+		return 1;
+	return 0;
+}
+
+static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
+{
+	unsigned long addr =3D (unsigned long)raw_ctx;
+	unsigned long align =3D AESNI_ALIGN;
+
+	if (align <=3D crypto_tfm_ctx_alignment())
+		align =3D 1;
+	return (struct crypto_aes_ctx *)ALIGN(addr, align);
+}
+
+static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
+			      const u8 *in_key, unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(raw_ctx);
+	u32 *flags =3D &tfm->crt_flags;
+	int err;
+
+	if (key_len !=3D AES_KEYSIZE_128 && key_len !=3D AES_KEYSIZE_192 &&
+	    key_len !=3D AES_KEYSIZE_256) {
+		*flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	if (kernel_fpu_using())
+		err =3D crypto_aes_expand_key(ctx, in_key, key_len);
+	else {
+		kernel_fpu_begin();
+		err =3D aesni_set_key(ctx, in_key, key_len);
+		kernel_fpu_end();
+	}
+
+	return err;
+}
+
+static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	return aes_set_key_common(tfm, crypto_tfm_ctx(tfm), in_key, key_len);
+}
+
+static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_tfm_ctx(tfm));
+
+	if (kernel_fpu_using())
+		crypto_aes_encrypt_x86(ctx, dst, src);
+	else {
+		kernel_fpu_begin();
+		aesni_enc(ctx, dst, src);
+		kernel_fpu_end();
+	}
+}
+
+static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_tfm_ctx(tfm));
+
+	if (kernel_fpu_using())
+		crypto_aes_decrypt_x86(ctx, dst, src);
+	else {
+		kernel_fpu_begin();
+		aesni_dec(ctx, dst, src);
+		kernel_fpu_end();
+	}
+}
+
+static struct crypto_alg aesni_alg =3D {
+	.cra_name		=3D "aes",
+	.cra_driver_name	=3D "aes-aesni",
+	.cra_priority		=3D 300,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
+	.cra_alignmask		=3D 0,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(aesni_alg.cra_list),
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
+static int ecb_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_blkcipher_ctx(desc->tfm));
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	kernel_fpu_begin();
+	while ((nbytes =3D walk.nbytes)) {
+		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes & AES_BLOCK_MASK);
+		nbytes &=3D AES_BLOCK_SIZE - 1;
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_blkcipher_ctx(desc->tfm));
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	kernel_fpu_begin();
+	while ((nbytes =3D walk.nbytes)) {
+		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes & AES_BLOCK_MASK);
+		nbytes &=3D AES_BLOCK_SIZE - 1;
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static struct crypto_alg blk_ecb_alg =3D {
+	.cra_name		=3D "__ecb-aes-aesni",
+	.cra_driver_name	=3D "__driver-ecb-aes-aesni",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(blk_ecb_alg.cra_list),
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.setkey		=3D aes_set_key,
+			.encrypt	=3D ecb_encrypt,
+			.decrypt	=3D ecb_decrypt,
+		},
+	},
+};
+
+static int cbc_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_blkcipher_ctx(desc->tfm));
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	kernel_fpu_begin();
+	while ((nbytes =3D walk.nbytes)) {
+		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes & AES_BLOCK_MASK, walk.iv);
+		nbytes &=3D AES_BLOCK_SIZE - 1;
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_blkcipher_ctx(desc->tfm));
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	kernel_fpu_begin();
+	while ((nbytes =3D walk.nbytes)) {
+		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes & AES_BLOCK_MASK, walk.iv);
+		nbytes &=3D AES_BLOCK_SIZE - 1;
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static struct crypto_alg blk_cbc_alg =3D {
+	.cra_name		=3D "__cbc-aes-aesni",
+	.cra_driver_name	=3D "__driver-cbc-aes-aesni",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(blk_cbc_alg.cra_list),
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.setkey		=3D aes_set_key,
+			.encrypt	=3D cbc_encrypt,
+			.decrypt	=3D cbc_decrypt,
+		},
+	},
+};
+
+static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int key_len)
+{
+	struct async_aes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+
+	return crypto_ablkcipher_setkey(&ctx->cryptd_tfm->base, key, key_len);
+}
+
+static int ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
+	struct async_aes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+
+	if (kernel_fpu_using()) {
+		struct ablkcipher_request *cryptd_req =3D
+			ablkcipher_request_ctx(req);
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		return crypto_ablkcipher_encrypt(cryptd_req);
+	} else {
+		struct blkcipher_desc desc;
+		desc.tfm =3D cryptd_ablkcipher_child(ctx->cryptd_tfm);
+		desc.info =3D req->info;
+		desc.flags =3D 0;
+		return crypto_blkcipher_crt(desc.tfm)->encrypt(
+			&desc, req->dst, req->src, req->nbytes);
+	}
+}
+
+static int ablk_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
+	struct async_aes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+
+	if (kernel_fpu_using()) {
+		struct ablkcipher_request *cryptd_req =3D
+			ablkcipher_request_ctx(req);
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		return crypto_ablkcipher_decrypt(cryptd_req);
+	} else {
+		struct blkcipher_desc desc;
+		desc.tfm =3D cryptd_ablkcipher_child(ctx->cryptd_tfm);
+		desc.info =3D req->info;
+		desc.flags =3D 0;
+		return crypto_blkcipher_crt(desc.tfm)->decrypt(
+			&desc, req->dst, req->src, req->nbytes);
+	}
+}
+
+static void ablk_exit(struct crypto_tfm *tfm)
+{
+	struct async_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	cryptd_free_ablkcipher(ctx->cryptd_tfm);
+}
+
+static void ablk_init_common(struct crypto_tfm *tfm,
+			     struct cryptd_ablkcipher *cryptd_tfm)
+{
+	struct async_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	ctx->cryptd_tfm =3D cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize =3D sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+}
+
+static int ablk_ecb_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("__driver-ecb-aes-aesni", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_ecb_alg =3D {
+	.cra_name		=3D "ecb(aes)",
+	.cra_driver_name	=3D "ecb-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_ecb_alg.cra_list),
+	.cra_init		=3D ablk_ecb_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+
+static int ablk_cbc_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("__driver-cbc-aes-aesni", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_cbc_alg =3D {
+	.cra_name		=3D "cbc(aes)",
+	.cra_driver_name	=3D "cbc-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_cbc_alg.cra_list),
+	.cra_init		=3D ablk_cbc_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.ivsize		=3D AES_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+
+static int __init aesni_init(void)
+{
+	int err;
+
+	if (!cpu_has_aes) {
+		printk(KERN_ERR "Intel AES-NI instructions are not detected.\n");
+		return -ENODEV;
+	}
+	if ((err =3D crypto_register_alg(&aesni_alg)))
+		goto aes_err;
+	if ((err =3D crypto_register_alg(&blk_ecb_alg)))
+		goto blk_ecb_err;
+	if ((err =3D crypto_register_alg(&blk_cbc_alg)))
+		goto blk_cbc_err;
+	if ((err =3D crypto_register_alg(&ablk_ecb_alg)))
+		goto ablk_ecb_err;
+	if ((err =3D crypto_register_alg(&ablk_cbc_alg)))
+		goto ablk_cbc_err;
+
+	return err;
+
+ablk_cbc_err:
+	crypto_unregister_alg(&ablk_ecb_alg);
+ablk_ecb_err:
+	crypto_unregister_alg(&blk_cbc_alg);
+blk_cbc_err:
+	crypto_unregister_alg(&blk_ecb_alg);
+blk_ecb_err:
+	crypto_unregister_alg(&aesni_alg);
+aes_err:
+	return err;
+}
+
+static void __exit aesni_exit(void)
+{
+	crypto_unregister_alg(&ablk_cbc_alg);
+	crypto_unregister_alg(&ablk_ecb_alg);
+	crypto_unregister_alg(&blk_cbc_alg);
+	crypto_unregister_alg(&blk_ecb_alg);
+	crypto_unregister_alg(&aesni_alg);
+}
+
+module_init(aesni_init);
+module_exit(aesni_exit);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, Intel AES-NI instruct=
ions optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("aes");
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
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -0,0 +1,896 @@
+/*
+ * Implement AES algorithm in Intel AES-NI instructions.
+ *
+ * The white paper of AES-NI instructions can be downloaded from:
+ *   http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instruc=
tions-Set_WP.pdf
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
+	# aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x01
+	call _key_expansion_256a
+	# aeskeygenassist $0x1, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x01
+	call _key_expansion_256b
+	# aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x02
+	call _key_expansion_256a
+	# aeskeygenassist $0x2, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x02
+	call _key_expansion_256b
+	# aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x04
+	call _key_expansion_256a
+	# aeskeygenassist $0x4, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x04
+	call _key_expansion_256b
+	# aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x08
+	call _key_expansion_256a
+	# aeskeygenassist $0x8, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x08
+	call _key_expansion_256b
+	# aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x10
+	call _key_expansion_256a
+	# aeskeygenassist $0x10, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x10
+	call _key_expansion_256b
+	# aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x20
+	call _key_expansion_256a
+	# aeskeygenassist $0x20, %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x20
+	call _key_expansion_256b
+	# aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x40
+	call _key_expansion_256a
+	jmp .Ldec_key
+.Lenc_key192:
+	movq 0x10(%rsi), %xmm2		# other user key
+	# aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x01
+	call _key_expansion_192a
+	# aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x02
+	call _key_expansion_192b
+	# aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x04
+	call _key_expansion_192a
+	# aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x08
+	call _key_expansion_192b
+	# aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x10
+	call _key_expansion_192a
+	# aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x20
+	call _key_expansion_192b
+	# aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x40
+	call _key_expansion_192a
+	# aeskeygenassist $0x80, %xmm2, %xmm1	# round 8
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xca, 0x80
+	call _key_expansion_192b
+	jmp .Ldec_key
+.Lenc_key128:
+	# aeskeygenassist $0x1, %xmm0, %xmm1	# round 1
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x01
+	call _key_expansion_128
+	# aeskeygenassist $0x2, %xmm0, %xmm1	# round 2
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x02
+	call _key_expansion_128
+	# aeskeygenassist $0x4, %xmm0, %xmm1	# round 3
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x04
+	call _key_expansion_128
+	# aeskeygenassist $0x8, %xmm0, %xmm1	# round 4
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x08
+	call _key_expansion_128
+	# aeskeygenassist $0x10, %xmm0, %xmm1	# round 5
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x10
+	call _key_expansion_128
+	# aeskeygenassist $0x20, %xmm0, %xmm1	# round 6
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x20
+	call _key_expansion_128
+	# aeskeygenassist $0x40, %xmm0, %xmm1	# round 7
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x40
+	call _key_expansion_128
+	# aeskeygenassist $0x80, %xmm0, %xmm1	# round 8
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x80
+	call _key_expansion_128
+	# aeskeygenassist $0x1b, %xmm0, %xmm1	# round 9
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x1b
+	call _key_expansion_128
+	# aeskeygenassist $0x36, %xmm0, %xmm1	# round 10
+	.byte 0x66, 0x0f, 0x3a, 0xdf, 0xc8, 0x36
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
+	# aesimc %xmm0, %xmm1
+	.byte 0x66, 0x0f, 0x38, 0xdb, 0xc8
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
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps -0x50(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+.align 4
+.Lenc192:
+	movaps -0x40(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps -0x30(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+.align 4
+.Lenc128:
+	movaps -0x20(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps -0x10(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps (TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x10(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x20(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x30(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x40(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x50(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x60(TKEYP), KEY
+	# aesenc KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	movaps 0x70(TKEYP), KEY
+	# aesenclast KEY, STATE	# last round
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xc2
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
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps -0x50(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+#.align 4
+.L4enc192:
+	movaps -0x40(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps -0x30(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+#.align 4
+.L4enc128:
+	movaps -0x20(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps -0x10(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps (TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x10(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x20(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x30(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x40(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x50(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x60(TKEYP), KEY
+	# aesenc KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xc2
+	# aesenc KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xe2
+	# aesenc KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xea
+	# aesenc KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdc, 0xf2
+	movaps 0x70(TKEYP), KEY
+	# aesenclast KEY, STATE1	# last round
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xc2
+	# aesenclast KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xe2
+	# aesenclast KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xea
+	# aesenclast KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdd, 0xf2
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
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps -0x50(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+.align 4
+.Ldec192:
+	movaps -0x40(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps -0x30(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+.align 4
+.Ldec128:
+	movaps -0x20(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps -0x10(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps (TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x10(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x20(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x30(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x40(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x50(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x60(TKEYP), KEY
+	# aesdec KEY, STATE
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	movaps 0x70(TKEYP), KEY
+	# aesdeclast KEY, STATE		# last round
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xc2
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
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps -0x50(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+.align 4
+.L4dec192:
+	movaps -0x40(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps -0x30(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+.align 4
+.L4dec128:
+	movaps -0x20(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps -0x10(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps (TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x10(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x20(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x30(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x40(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x50(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x60(TKEYP), KEY
+	# aesdec KEY, STATE1
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xc2
+	# aesdec KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xe2
+	# aesdec KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xea
+	# aesdec KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xde, 0xf2
+	movaps 0x70(TKEYP), KEY
+	# aesdeclast KEY, STATE1	# last round
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xc2
+	# aesdeclast KEY, STATE2
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xe2
+	# aesdeclast KEY, STATE3
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xea
+	# aesdeclast KEY, STATE4
+	.byte 0x66, 0x0f, 0x38, 0xdf, 0xf2
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
+	jb .Lcbc_dec_ret
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
+	movups IV, (IVP)
+.Lcbc_dec_ret:
+	ret
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CRYPTO_SALSA20_586) +=3D sals
 obj-$(CONFIG_CRYPTO_AES_X86_64) +=3D aes-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) +=3D twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) +=3D salsa20-x86_64.o
+obj-$(CONFIG_CRYPTO_AES_NI_INTEL) +=3D aesni-intel.o
=20
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) +=3D crc32c-intel.o
=20
@@ -19,3 +20,5 @@ salsa20-i586-y :=3D salsa20-i586-asm_32.o=20
 aes-x86_64-y :=3D aes-x86_64-asm_64.o aes_glue.o
 twofish-x86_64-y :=3D twofish-x86_64-asm_64.o twofish_glue.o
 salsa20-x86_64-y :=3D salsa20-x86_64-asm_64.o salsa20_glue.o
+
+aesni-intel-y :=3D aesni-intel_asm.o aesni-intel_glue.o
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -470,6 +470,31 @@ config CRYPTO_AES_X86_64
=20
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
=20
+config CRYPTO_AES_NI_INTEL
+	tristate "AES cipher algorithms (AES-NI)"
+	depends on (X86 || UML_X86) && 64BIT
+	select CRYPTO_AES_X86_64
+	select CRYPTO_CRYPTD
+	select CRYPTO_ALGAPI
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
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI


--=-HjD2U9uX3GbQIALUJQLF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklwMt4ACgkQKhFGF+eHlpggjQCfT/99CbL01ol4dNVaaihycn5Z
GWAAni6UtJvBby87+RR12cI3rd44APvq
=/8wP
-----END PGP SIGNATURE-----

--=-HjD2U9uX3GbQIALUJQLF--

