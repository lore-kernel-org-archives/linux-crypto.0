From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 6/7] AES for PPC/SPE - glue code
Date: Mon, 16 Feb 2015 13:46:02 +0100
Message-ID: <04fca01f-a5a3-42be-af6e-e03a92474db2@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-636f15e5-167e-40ba-81f5-a521419b078d"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:7436 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274AbbBPMqF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 07:46:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-636f15e5-167e-40ba-81f5-a521419b078d
Content-Type: text/plain

[PATCH v1 6/7] AES for PPC/SPE - glue code

Integrate the assembler modules into the kernel crypto
framework. Take care to avoid long intervals of disabled
preemption.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/aes_spe_glue.c b/arch/powerpc/crypto/aes_spe_glue.c
new file mode 100644
index 0000000..bd5e63f
--- /dev/null
+++ b/arch/powerpc/crypto/aes_spe_glue.c
@@ -0,0 +1,512 @@
+/*
+ * Glue code for AES implementation for SPE instructions (PPC)
+ *
+ * Based on generic implementation. The assembler module takes care
+ * about the SPE registers so it can run from interrupt context.
+ *
+ * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/aes.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/crypto.h>
+#include <asm/byteorder.h>
+#include <asm/switch_to.h>
+#include <crypto/algapi.h>
+
+/*
+ * MAX_BYTES defines the number of bytes that are allowed to be processed
+ * between preempt_disable() and preempt_enable(). e500 cores can issue two
+ * instructions per clock cycle using one 32/64 bit unit (SU1) and one 32
+ * bit unit (SU2). One of these can be a memory access that is executed via
+ * a single load and store unit (LSU). XTS-AES-256 takes ~780 operations per
+ * 16 byte block block or 25 cycles per byte. Thus 768 bytes of input data
+ * will need an estimated maximum of 20,000 cycles. Headroom for cache misses
+ * included. Even with the low end model clocked at 667 MHz this equals to a
+ * critical time window of less than 30us. The value has been choosen to
+ * process a 512 byte disk block in one or a large 1400 bytes IPsec network
+ * packet in two runs.
+ *
+ */
+#define MAX_BYTES 768
+
+struct ppc_aes_ctx {
+	u32 key_enc[AES_MAX_KEYLENGTH_U32];
+	u32 key_dec[AES_MAX_KEYLENGTH_U32];
+	u32 rounds;
+};
+
+struct ppc_xts_ctx {
+	u32 key_enc[AES_MAX_KEYLENGTH_U32];
+	u32 key_dec[AES_MAX_KEYLENGTH_U32];
+	u32 key_twk[AES_MAX_KEYLENGTH_U32];
+	u32 rounds;
+};
+
+extern void ppc_encrypt_aes(u8 *out, const u8 *in, u32 *key_enc, u32 rounds);
+extern void ppc_decrypt_aes(u8 *out, const u8 *in, u32 *key_dec, u32 rounds);
+extern void ppc_encrypt_ecb(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
+			    u32 bytes);
+extern void ppc_decrypt_ecb(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
+			    u32 bytes);
+extern void ppc_encrypt_cbc(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
+			    u32 bytes, u8 *iv);
+extern void ppc_decrypt_cbc(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
+			    u32 bytes, u8 *iv);
+extern void ppc_crypt_ctr  (u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
+			    u32 bytes, u8 *iv);
+extern void ppc_encrypt_xts(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
+			    u32 bytes, u8 *iv, u32 *key_twk);
+extern void ppc_decrypt_xts(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
+			    u32 bytes, u8 *iv, u32 *key_twk);
+
+extern void ppc_expand_key_128(u32 *key_enc, const u8 *key);
+extern void ppc_expand_key_192(u32 *key_enc, const u8 *key);
+extern void ppc_expand_key_256(u32 *key_enc, const u8 *key);
+
+extern void ppc_generate_decrypt_key(u32 *key_dec,u32 *key_enc,
+				     unsigned int key_len);
+
+static void spe_begin(void)
+{
+	/* disable preemption and save users SPE registers if required */
+	preempt_disable();
+	enable_kernel_spe();
+}
+
+static void spe_end(void)
+{
+	/* reenable preemption */
+	preempt_enable();
+}
+
+static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
+		unsigned int key_len)
+{
+	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (key_len != AES_KEYSIZE_128 &&
+	    key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		ctx->rounds = 4;
+		ppc_expand_key_128(ctx->key_enc, in_key);
+		break;
+	case AES_KEYSIZE_192:
+		ctx->rounds = 5;
+		ppc_expand_key_192(ctx->key_enc, in_key);
+		break;
+	case AES_KEYSIZE_256:
+		ctx->rounds = 6;
+		ppc_expand_key_256(ctx->key_enc, in_key);
+		break;
+	}
+
+	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
+
+	return 0;
+}
+
+static int ppc_xts_setkey(struct crypto_tfm *tfm, const u8 *in_key,
+		   unsigned int key_len)
+{
+	struct ppc_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	key_len >>= 1;
+
+	if (key_len != AES_KEYSIZE_128 &&
+	    key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		ctx->rounds = 4;
+		ppc_expand_key_128(ctx->key_enc, in_key);
+		ppc_expand_key_128(ctx->key_twk, in_key + AES_KEYSIZE_128);
+		break;
+	case AES_KEYSIZE_192:
+		ctx->rounds = 5;
+		ppc_expand_key_192(ctx->key_enc, in_key);
+		ppc_expand_key_192(ctx->key_twk, in_key + AES_KEYSIZE_192);
+		break;
+	case AES_KEYSIZE_256:
+		ctx->rounds = 6;
+		ppc_expand_key_256(ctx->key_enc, in_key);
+		ppc_expand_key_256(ctx->key_twk, in_key + AES_KEYSIZE_256);
+		break;
+	}
+
+	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
+
+	return 0;
+}
+
+static void ppc_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	spe_begin();
+	ppc_encrypt_aes(out, in, ctx->key_enc, ctx->rounds);
+	spe_end();
+}
+
+static void ppc_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	spe_begin();
+	ppc_decrypt_aes(out, in, ctx->key_dec, ctx->rounds);
+	spe_end();
+}
+
+static int ppc_ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_encrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_enc, ctx->rounds, nbytes);
+		spe_end();
+
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_decrypt_ecb(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_dec, ctx->rounds, nbytes);
+		spe_end();
+
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_encrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_enc, ctx->rounds, nbytes, walk.iv);
+		spe_end();
+
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_decrypt_cbc(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_dec, ctx->rounds, nbytes, walk.iv);
+		spe_end();
+
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			 struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int pbytes, ubytes;
+	int err;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
+
+	while ((pbytes = walk.nbytes)) {
+		pbytes = pbytes > MAX_BYTES ? MAX_BYTES : pbytes;
+		pbytes = pbytes == nbytes ?
+			 nbytes : pbytes & ~(AES_BLOCK_SIZE - 1);
+		ubytes = walk.nbytes - pbytes;
+
+		spe_begin();
+		ppc_crypt_ctr(walk.dst.virt.addr, walk.src.virt.addr,
+			      ctx->key_enc, ctx->rounds, pbytes , walk.iv);
+		spe_end();
+
+		nbytes -= pbytes;
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+	u32 *twk;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+	twk = ctx->key_twk;
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_encrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_enc, ctx->rounds, nbytes, walk.iv, twk);
+		spe_end();
+
+		twk = NULL;
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+static int ppc_xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			   struct scatterlist *src, unsigned int nbytes)
+{
+	struct ppc_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	unsigned int ubytes;
+	int err;
+	u32 *twk;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+	twk = ctx->key_twk;
+
+	while ((nbytes = walk.nbytes)) {
+		ubytes = nbytes > MAX_BYTES ?
+			 nbytes - MAX_BYTES : nbytes & (AES_BLOCK_SIZE - 1);
+		nbytes -= ubytes;
+
+		spe_begin();
+		ppc_decrypt_xts(walk.dst.virt.addr, walk.src.virt.addr,
+				ctx->key_dec, ctx->rounds, nbytes, walk.iv, twk);
+		spe_end();
+
+		twk = NULL;
+		err = blkcipher_walk_done(desc, &walk, ubytes);
+	}
+
+	return err;
+}
+
+/*
+ * Algorithm definitions. Disabling alignment (cra_alignmask=0) was chosen
+ * because the e500 platform can handle unaligned reads/writes very efficently.
+ * This improves IPsec thoughput by another few percent. Additionally we assume
+ * that AES context is always aligned to at least 8 bytes because it is created
+ * with kmalloc() in the crypto infrastructure
+ *
+ */
+static struct crypto_alg aes_algs[] = { {
+	.cra_name		=	"aes",
+	.cra_driver_name	=	"aes-ppc-spe",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct ppc_aes_ctx),
+	.cra_alignmask		=	0,
+	.cra_module		=	THIS_MODULE,
+	.cra_u			=	{
+		.cipher = {
+			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
+			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
+			.cia_setkey		=	ppc_aes_setkey,
+			.cia_encrypt		=	ppc_aes_encrypt,
+			.cia_decrypt		=	ppc_aes_decrypt
+		}
+	}
+}, {
+	.cra_name		=	"ecb(aes)",
+	.cra_driver_name	=	"ecb-ppc-spe",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct ppc_aes_ctx),
+	.cra_alignmask		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	ppc_aes_setkey,
+			.encrypt		=	ppc_ecb_encrypt,
+			.decrypt		=	ppc_ecb_decrypt,
+		}
+	}
+}, {
+	.cra_name		=	"cbc(aes)",
+	.cra_driver_name	=	"cbc-ppc-spe",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct ppc_aes_ctx),
+	.cra_alignmask		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	ppc_aes_setkey,
+			.encrypt		=	ppc_cbc_encrypt,
+			.decrypt		=	ppc_cbc_decrypt,
+		}
+	}
+}, {
+	.cra_name		=	"ctr(aes)",
+	.cra_driver_name	=	"ctr-ppc-spe",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	1,
+	.cra_ctxsize		=	sizeof(struct ppc_aes_ctx),
+	.cra_alignmask		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	ppc_aes_setkey,
+			.encrypt		=	ppc_ctr_crypt,
+			.decrypt		=	ppc_ctr_crypt,
+		}
+	}
+}, {
+	.cra_name		=	"xts(aes)",
+	.cra_driver_name	=	"xts-ppc-spe",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct ppc_xts_ctx),
+	.cra_alignmask		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize		=	AES_MIN_KEY_SIZE * 2,
+			.max_keysize		=	AES_MAX_KEY_SIZE * 2,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	ppc_xts_setkey,
+			.encrypt		=	ppc_xts_encrypt,
+			.decrypt		=	ppc_xts_decrypt,
+		}
+	}
+} };
+
+static int __init ppc_aes_mod_init(void)
+{
+	return crypto_register_algs(aes_algs, ARRAY_SIZE(aes_algs));
+}
+
+static void __exit ppc_aes_mod_fini(void)
+{
+	crypto_unregister_algs(aes_algs, ARRAY_SIZE(aes_algs));
+}
+
+module_init(ppc_aes_mod_init);
+module_exit(ppc_aes_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS, SPE optimized");
+
+MODULE_ALIAS_CRYPTO("aes");
+MODULE_ALIAS_CRYPTO("ecb(aes)");
+MODULE_ALIAS_CRYPTO("cbc(aes)");
+MODULE_ALIAS_CRYPTO("ctr(aes)");
+MODULE_ALIAS_CRYPTO("xts(aes)");
+MODULE_ALIAS_CRYPTO("aes-ppc-spe");

------=_NextPartTM-000-636f15e5-167e-40ba-81f5-a521419b078d
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-636f15e5-167e-40ba-81f5-a521419b078d--
