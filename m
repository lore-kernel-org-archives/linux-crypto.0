From: Joy Latten <latten@austin.ibm.com>
Subject: [PATCH 1/1]: CTR mode implementation
Date: Thu, 30 Aug 2007 11:14:45 -0500
Message-ID: <200708301614.l7UGEj44031217@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au, tgraf@suug.ch
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59710 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXH3QR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 12:17:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7UGHtJW028166
	for <linux-crypto@vger.kernel.org>; Thu, 30 Aug 2007 12:17:55 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7UGHtqS555324
	for <linux-crypto@vger.kernel.org>; Thu, 30 Aug 2007 12:17:55 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7UGHqLG017853
	for <linux-crypto@vger.kernel.org>; Thu, 30 Aug 2007 12:17:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements CTR mode for IPSec.
It is based off of RFC 3686.

Please note:
1. it is assumed that plaintext is  multiple of blocksize.
2. currently salt is extracted from the last 4 bytes of key.
   Thus keys entered through setkey() have an additional 32 bits.
   This causes problems for 256-bit keys. For example, 
   crypto_ablkcipher_setkey() checks the maximum keysize and
   complains about keysize. 
   This issue will be taken cared of with the new
   infrastructure/template for combined mode that is planned, 
   and appropriate changes will be made to crypto_ctr_setkey()
   and testcases.
3. rfc3686 stated that last 4 bytes of counterblock, which is the
   actual counter, are to be in big endian.
4. tested with AES based on rfc3686

The tcrypt vectors are from rfc 3686. They all pass except for the
ones with 256-bit keys. 

Please let me know if all looks ok or not.

Regards, 
Joy
  
diff -urpN linux-2.6.22/crypto/ctr.c linux-2.6.22.crypto/crypto/ctr.c
--- linux-2.6.22/crypto/ctr.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.22.crypto/crypto/ctr.c	2007-08-30 10:32:51.000000000 -0500
@@ -0,0 +1,286 @@
+/*
+ * CTR: Counter mode
+ *
+ * (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+
+struct crypto_ctr_ctx {
+	struct crypto_cipher *child;
+	u8 ctrblk[16];
+};
+
+static void ctr_inc(__be32 *counter)
+{
+	u_int32_t c; 
+	
+	c = be32_to_cpu(counter[3]);
+	c++;
+	counter[3] = cpu_to_be32(c);
+}
+
+static void xor_128(u8 *a, const u8 *b)
+{
+	((u32 *)a)[0] ^= ((u32 *)b)[0];
+	((u32 *)a)[1] ^= ((u32 *)b)[1];
+	((u32 *)a)[2] ^= ((u32 *)b)[2];
+	((u32 *)a)[3] ^= ((u32 *)b)[3];
+}
+
+static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
+			     unsigned int keylen)
+{
+	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(parent);
+	struct crypto_cipher *child = ctx->child;
+	int err;
+
+	/* salt is stored in last 4 bytes of key */
+	if ((keylen % 8) != 4) {
+		err = -EINVAL;
+		return err; 
+	}
+
+	/* place salt into counterblock */
+	memset(ctx->ctrblk, 0, 16);
+	memcpy(ctx->ctrblk, key + (keylen - 4), 4);
+
+	keylen -=  4; 
+	
+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
+				CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(child, key, keylen);
+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
+			     CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int crypto_ctr_crypt_segment(struct blkcipher_desc *desc,
+				    struct blkcipher_walk *walk,
+				    struct crypto_cipher *tfm, 
+				    u8 *ctrblk)
+{
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+		   crypto_cipher_alg(tfm)->cia_encrypt;
+	int bsize = crypto_cipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+
+	do {
+		/* create keystream */
+		fn(crypto_cipher_tfm(tfm), dst, ctrblk); 
+		xor_128(dst, src); 
+		
+		/* increment counter in counterblock */
+		ctr_inc((__be32 *)ctrblk);
+	
+		src += bsize; 
+		dst += bsize; 
+	} while ((nbytes -= bsize) >= bsize);
+	
+	return nbytes; 
+}
+
+static int crypto_ctr_crypt_inplace(struct blkcipher_desc *desc,
+				    struct blkcipher_walk *walk,
+				    struct crypto_cipher *tfm, 
+				    u8 *ctrblk)
+{
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+		   crypto_cipher_alg(tfm)->cia_encrypt;
+	int bsize = crypto_cipher_blocksize(tfm);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 keystream[bsize];	/* bsize = 16 */ 
+
+	do {
+		/* create keystream */
+		fn(crypto_cipher_tfm(tfm), (u8 *)&keystream, ctrblk); 
+		xor_128(src, (u8 *)&keystream); 
+		
+		/* increment counter in counterblock */
+		ctr_inc((__be32 *)ctrblk);
+	
+		src += bsize; 
+	} while ((nbytes -= bsize) >= bsize);
+	
+	return nbytes; 
+}
+
+static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
+			      struct scatterlist *dst, struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_cipher *child = ctx->child;
+	u8 *counterblk = ctx->ctrblk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	/* set iv into the counter block */
+	/* RFC 3686 requires only 8 bytes of the iv. */
+	memcpy(counterblk + 4, walk.iv, 8); 
+	
+	/* initialize counter portion of counter block */
+	ctr_inc((__be32 *)counterblk);
+
+	while (walk.nbytes) {
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			nbytes = crypto_ctr_crypt_inplace(desc, &walk, child,
+							  counterblk);
+		else
+			nbytes = crypto_ctr_crypt_segment(desc, &walk, child,
+							  counterblk);
+
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	return err;
+}
+
+static int crypto_ctr_decrypt(struct blkcipher_desc *desc,
+			      struct scatterlist *dst, struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_cipher *child = ctx->child;
+	u8 *counterblk = ctx->ctrblk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	/* set iv into the counter block */
+	/* RFC 3686 requires only 8 bytes of the iv. */
+	memcpy(counterblk + 4, walk.iv, 8); 
+	
+	/* initialize counter portion of counter block */
+	ctr_inc((__be32 *)counterblk);
+
+	while (walk.nbytes) {
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			nbytes = crypto_ctr_crypt_inplace(desc, &walk, child, 
+							  counterblk);
+		else
+			nbytes = crypto_ctr_crypt_segment(desc, &walk, child, 
+							  counterblk);
+
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static int crypto_ctr_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
+
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	return 0;
+}
+
+static void crypto_ctr_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_cipher(ctx->child);
+}
+
+static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_PTR(PTR_ERR(alg));
+
+	inst = crypto_alloc_instance("ctr", alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_blkcipher_type;
+
+	if (!(alg->cra_blocksize % 4))
+		inst->alg.cra_alignmask |= 3;
+	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
+	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
+	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+
+	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
+
+	inst->alg.cra_init = crypto_ctr_init_tfm;
+	inst->alg.cra_exit = crypto_ctr_exit_tfm;
+
+	inst->alg.cra_blkcipher.setkey = crypto_ctr_setkey;
+	inst->alg.cra_blkcipher.encrypt = crypto_ctr_encrypt;
+	inst->alg.cra_blkcipher.decrypt = crypto_ctr_decrypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static void crypto_ctr_free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_template crypto_ctr_tmpl = {
+	.name = "ctr",
+	.alloc = crypto_ctr_alloc,
+	.free = crypto_ctr_free,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_ctr_module_init(void)
+{
+	return crypto_register_template(&crypto_ctr_tmpl);
+}
+
+static void __exit crypto_ctr_module_exit(void)
+{
+	crypto_unregister_template(&crypto_ctr_tmpl);
+}
+
+module_init(crypto_ctr_module_init);
+module_exit(crypto_ctr_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("CTR Counter block mode");
diff -urpN linux-2.6.22/crypto/Kconfig linux-2.6.22.crypto/crypto/Kconfig
--- linux-2.6.22/crypto/Kconfig	2007-08-21 14:09:01.000000000 -0500
+++ linux-2.6.22.crypto/crypto/Kconfig	2007-08-23 18:30:55.000000000 -0500
@@ -183,6 +183,15 @@ config CRYPTO_LRW
 	  The first 128, 192 or 256 bits in the key are used for AES and the
 	  rest is used to tie each cipher block to its logical position.
 
+config CRYPTO_CTR
+	tristate "CTR support"
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
+	default m
+	help
+	  CTR: Counter mode
+	  This block cipher algorithm is required for IPSec.
+
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
 	select CRYPTO_ABLKCIPHER
diff -urpN linux-2.6.22/crypto/Makefile linux-2.6.22.crypto/crypto/Makefile
--- linux-2.6.22/crypto/Makefile	2007-08-21 14:09:01.000000000 -0500
+++ linux-2.6.22.crypto/crypto/Makefile	2007-08-23 18:29:47.000000000 -0500
@@ -30,6 +30,7 @@ obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
+obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
diff -urpN linux-2.6.22/crypto/tcrypt.c linux-2.6.22.crypto/crypto/tcrypt.c
--- linux-2.6.22/crypto/tcrypt.c	2007-07-08 18:32:17.000000000 -0500
+++ linux-2.6.22.crypto/crypto/tcrypt.c	2007-08-24 16:44:18.000000000 -0500
@@ -955,6 +955,10 @@ static void do_test(void)
 			    AES_LRW_ENC_TEST_VECTORS);
 		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
 			    AES_LRW_DEC_TEST_VECTORS);
+		test_cipher("ctr(aes)", ENCRYPT, aes_ctr_enc_tv_template, 
+			    AES_CTR_ENC_TEST_VECTORS);
+		test_cipher("ctr(aes)", DECRYPT, aes_ctr_dec_tv_template, 
+			    AES_CTR_DEC_TEST_VECTORS);
 
 		//CAST5
 		test_cipher("ecb(cast5)", ENCRYPT, cast5_enc_tv_template,
@@ -1132,6 +1136,10 @@ static void do_test(void)
 			    AES_LRW_ENC_TEST_VECTORS);
 		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
 			    AES_LRW_DEC_TEST_VECTORS);
+		test_cipher("ctr(aes)", ENCRYPT, aes_ctr_enc_tv_template,
+			    AES_CTR_ENC_TEST_VECTORS);
+		test_cipher("ctr(aes)", DECRYPT, aes_ctr_dec_tv_template,
+			    AES_CTR_DEC_TEST_VECTORS);
 		break;
 
 	case 11:
diff -urpN linux-2.6.22/crypto/tcrypt.h linux-2.6.22.crypto/crypto/tcrypt.h
--- linux-2.6.22/crypto/tcrypt.h	2007-07-08 18:32:17.000000000 -0500
+++ linux-2.6.22.crypto/crypto/tcrypt.h	2007-08-24 16:44:26.000000000 -0500
@@ -2144,6 +2144,8 @@ static struct cipher_testvec cast6_dec_t
 #define AES_CBC_DEC_TEST_VECTORS 2
 #define AES_LRW_ENC_TEST_VECTORS 8
 #define AES_LRW_DEC_TEST_VECTORS 8
+#define AES_CTR_ENC_TEST_VECTORS 6
+#define AES_CTR_DEC_TEST_VECTORS 6
 
 static struct cipher_testvec aes_enc_tv_template[] = {
 	{ /* From FIPS-197 */
@@ -2784,6 +2786,191 @@ static struct cipher_testvec aes_lrw_dec
 	}
 };
 
+
+static struct cipher_testvec aes_ctr_enc_tv_template[] = {
+	{ /* From RFC 3686 */
+		.key	= { 0xae, 0x68, 0x52, 0xf8, 0x12, 0x10, 0x67, 0xcc, 
+			    0x4b, 0xf7, 0xa5, 0x76, 0x55, 0x77, 0xf3, 0x9e, 
+			    0x00, 0x00, 0x00, 0x30 }, 
+		.klen	= 20,
+		.iv 	= { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, 
+		.input 	= { "Single block msg" }, 
+		.ilen	= 16, 
+		.result = { 0xe4, 0x09, 0x5d, 0x4f, 0xb7, 0xa7, 0xb3, 0x79, 
+			    0x2d, 0x61, 0x75, 0xa3, 0x26, 0x13, 0x11, 0xb8 }, 
+		.rlen	= 16, 
+	}, {
+		
+		.key	= { 0x7e, 0x24, 0x06, 0x78, 0x17, 0xfa, 0xe0, 0xd7, 
+			    0x43, 0xd6, 0xce, 0x1f, 0x32, 0x53, 0x91, 0x63, 
+			    0x00, 0x6c, 0xb6, 0xdb },
+		.klen	= 20, 
+		.iv 	= { 0xc0, 0x54, 0x3b, 0x59, 0xda, 0x48, 0xd9, 0x0b }, 
+		.input	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.ilen 	= 32, 
+		.result = { 0x51, 0x04, 0xa1, 0x06, 0x16, 0x8a, 0x72, 0xd9, 
+			    0x79, 0x0d, 0x41, 0xee, 0x8e, 0xda, 0xd3, 0x88, 
+			    0xeb, 0x2e, 0x1e, 0xfc, 0x46, 0xda, 0x57, 0xc8, 
+			    0xfc, 0xe6, 0x30, 0xdf, 0x91, 0x41, 0xbe, 0x28 }, 
+		.rlen	= 32, 
+	}, {
+		.key 	= { 0x16, 0xaf, 0x5b, 0x14, 0x5f, 0xc9, 0xf5, 0x79, 
+			    0xc1, 0x75, 0xf9, 0x3e, 0x3b, 0xfb, 0x0e, 0xed, 
+			    0x86, 0x3d, 0x06, 0xcc, 0xfd, 0xb7, 0x85, 0x15, 
+			    0x00, 0x00, 0x00, 0x48 }, 
+		.klen 	= 28, 
+		.iv	= { 0x36, 0x73, 0x3c, 0x14, 0x7d, 0x6d, 0x93, 0xcb }, 
+		.input	= { "Single block msg" }, 
+		.ilen 	= 16, 
+		.result	= { 0x4b, 0x55, 0x38, 0x4f, 0xe2, 0x59, 0xc9, 0xc8, 
+			    0x4e, 0x79, 0x35, 0xa0, 0x03, 0xcb, 0xe9, 0x28 },  
+		.rlen	= 16, 
+	}, {
+		.key	= { 0x7c, 0x5c, 0xb2, 0x40, 0x1b, 0x3d, 0xc3, 0x3c, 
+			    0x19, 0xe7, 0x34, 0x08, 0x19, 0xe0, 0xf6, 0x9c, 
+			    0x67, 0x8c, 0x3d, 0xb8, 0xe6, 0xf6, 0xa9, 0x1a, 
+			    0x00, 0x96, 0xb0, 0x3b }, 
+		.klen	= 28, 
+		.iv 	= { 0x02, 0x0c, 0x6e, 0xad, 0xc2, 0xcb, 0x50, 0x0d }, 
+		.input	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.ilen	= 32, 
+		.result	= { 0x45, 0x32, 0x43, 0xfc, 0x60, 0x9b, 0x23, 0x32, 
+			    0x7e, 0xdf, 0xaa, 0xfa, 0x71, 0x31, 0xcd, 0x9f, 
+			    0x84, 0x90, 0x70, 0x1c, 0x5a, 0xd4, 0xa7, 0x9c, 
+			    0xfc, 0x1f, 0xe0, 0xff, 0x42, 0xf4, 0xfb, 0x00 }, 
+		.rlen 	= 32, 
+	}, {
+		.key 	= { 0x77, 0x6b, 0xef, 0xf2, 0x85, 0x1d, 0xb0, 0x6f, 
+			    0x4c, 0x8a, 0x05, 0x42, 0xc8, 0x69, 0x6f, 0x6c, 
+			    0x6a, 0x81, 0xaf, 0x1e, 0xec, 0x96, 0xb4, 0xd3,
+			    0x7f, 0xc1, 0xd6, 0x89, 0xe6, 0xc1, 0xc1, 0x04, 
+			    0x00, 0x00, 0x00, 0x60 }, 
+		.klen	= 36, 
+		.iv 	= { 0xdb, 0x56, 0x72, 0xc9, 0x7a, 0xa8, 0xf0, 0xb2 }, 
+		.input	= { "Single block msg" }, 
+		.ilen	= 16, 
+		.result = { 0x14, 0x5a, 0xd0, 0x1d, 0xbf, 0x82, 0x4e, 0xc7, 
+			    0x56, 0x08, 0x63, 0xdc, 0x71, 0xe3, 0xe0, 0xc0 },
+		.rlen 	= 16, 
+	}, {
+		.key	= { 0xf6, 0xd6, 0x6d, 0x6b, 0xd5, 0x2d, 0x59, 0xbb, 
+			    0x07, 0x96, 0x36, 0x58, 0x79, 0xef, 0xf8, 0x86, 
+			    0xc6, 0x6d, 0xd5, 0x1a, 0x5b, 0x6a, 0x99, 0x74, 
+			    0x4b, 0x50, 0x59, 0x0c, 0x87, 0xa2, 0x38, 0x84, 
+			    0x00, 0xfa, 0xac, 0x24 }, 
+		.klen 	= 36, 
+		.iv	= { 0xc1, 0x58, 0x5e, 0xf1, 0x5a, 0x43, 0xd8, 0x75 },  
+		.input	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.ilen	= 32, 
+		.result = { 0xf0, 0x5e, 0x23, 0x1b, 0x38, 0x94, 0x61, 0x2c, 
+			    0x49, 0xee, 0x00, 0x0b, 0x80, 0x4e, 0xb2, 0xa9, 
+			    0xb8, 0x30, 0x6b, 0x50, 0x8f, 0x83, 0x9d, 0x6a, 
+			    0x55, 0x30, 0x83, 0x1d, 0x93, 0x44, 0xaf, 0x1c }, 
+		.rlen	= 32, 
+	}, 
+};
+	
+static struct cipher_testvec aes_ctr_dec_tv_template[] = {
+	{ /* From RFC 3686 */
+		.key	= { 0xae, 0x68, 0x52, 0xf8, 0x12, 0x10, 0x67, 0xcc, 
+			    0x4b, 0xf7, 0xa5, 0x76, 0x55, 0x77, 0xf3, 0x9e, 
+			    0x00, 0x00, 0x00, 0x30 }, 
+		.klen	= 20,
+		.iv 	= { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, 
+		.input	= { 0xe4, 0x09, 0x5d, 0x4f, 0xb7, 0xa7, 0xb3, 0x79, 
+			    0x2d, 0x61, 0x75, 0xa3, 0x26, 0x13, 0x11, 0xb8 }, 
+		.ilen	= 16, 
+		.result	= { "Single block msg" }, 
+		.rlen	= 16, 
+	}, {
+		
+		.key	= { 0x7e, 0x24, 0x06, 0x78, 0x17, 0xfa, 0xe0, 0xd7, 
+			    0x43, 0xd6, 0xce, 0x1f, 0x32, 0x53, 0x91, 0x63, 
+			    0x00, 0x6c, 0xb6, 0xdb },
+		.klen	= 20, 
+		.iv 	= { 0xc0, 0x54, 0x3b, 0x59, 0xda, 0x48, 0xd9, 0x0b }, 
+		.input	= { 0x51, 0x04, 0xa1, 0x06, 0x16, 0x8a, 0x72, 0xd9, 
+			    0x79, 0x0d, 0x41, 0xee, 0x8e, 0xda, 0xd3, 0x88, 
+			    0xeb, 0x2e, 0x1e, 0xfc, 0x46, 0xda, 0x57, 0xc8, 
+			    0xfc, 0xe6, 0x30, 0xdf, 0x91, 0x41, 0xbe, 0x28 }, 
+		.ilen 	= 32, 
+		.result	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.rlen	= 32, 
+	}, {
+		.key 	= { 0x16, 0xaf, 0x5b, 0x14, 0x5f, 0xc9, 0xf5, 0x79, 
+			    0xc1, 0x75, 0xf9, 0x3e, 0x3b, 0xfb, 0x0e, 0xed, 
+			    0x86, 0x3d, 0x06, 0xcc, 0xfd, 0xb7, 0x85, 0x15, 
+			    0x00, 0x00, 0x00, 0x48 }, 
+		.klen 	= 28, 
+		.iv	= { 0x36, 0x73, 0x3c, 0x14, 0x7d, 0x6d, 0x93, 0xcb }, 
+		.input	= { 0x4b, 0x55, 0x38, 0x4f, 0xe2, 0x59, 0xc9, 0xc8, 
+			    0x4e, 0x79, 0x35, 0xa0, 0x03, 0xcb, 0xe9, 0x28 }, 
+		.ilen 	= 16, 
+		.result	= { "Single block msg" }, 
+		.rlen	= 16, 
+	}, {
+		.key	= { 0x7c, 0x5c, 0xb2, 0x40, 0x1b, 0x3d, 0xc3, 0x3c, 
+			    0x19, 0xe7, 0x34, 0x08, 0x19, 0xe0, 0xf6, 0x9c, 
+			    0x67, 0x8c, 0x3d, 0xb8, 0xe6, 0xf6, 0xa9, 0x1a, 
+			    0x00, 0x96, 0xb0, 0x3b }, 
+		.klen	= 28, 
+		.iv 	= { 0x02, 0x0c, 0x6e, 0xad, 0xc2, 0xcb, 0x50, 0x0d }, 
+		.input	= { 0x45, 0x32, 0x43, 0xfc, 0x60, 0x9b, 0x23, 0x32, 
+			    0x7e, 0xdf, 0xaa, 0xfa, 0x71, 0x31, 0xcd, 0x9f, 
+			    0x84, 0x90, 0x70, 0x1c, 0x5a, 0xd4, 0xa7, 0x9c, 
+			    0xfc, 0x1f, 0xe0, 0xff, 0x42, 0xf4, 0xfb, 0x00 }, 
+		.ilen	= 32, 
+		.result	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.rlen 	= 32, 
+	}, { 
+		.key 	= { 0x77, 0x6b, 0xef, 0xf2, 0x85, 0x1d, 0xb0, 0x6f, 
+			    0x4c, 0x8a, 0x05, 0x42, 0xc8, 0x69, 0x6f, 0x6c, 
+			    0x6a, 0x81, 0xaf, 0x1e, 0xec, 0x96, 0xb4, 0xd3,
+			    0x7f, 0xc1, 0xd6, 0x89, 0xe6, 0xc1, 0xc1, 0x04, 
+			    0x00, 0x00, 0x00, 0x60 }, 
+		.klen	= 36, 
+		.iv 	= { 0xdb, 0x56, 0x72, 0xc9, 0x7a, 0xa8, 0xf0, 0xb2 }, 
+		.input	= { 0x14, 0x5a, 0xd0, 0x1d, 0xbf, 0x82, 0x4e, 0xc7, 
+			    0x56, 0x08, 0x63, 0xdc, 0x71, 0xe3, 0xe0, 0xc0 },
+		.ilen	= 16, 
+		.result	= { "Single block msg" }, 
+		.rlen 	= 16, 
+	}, {
+		.key	= { 0xf6, 0xd6, 0x6d, 0x6b, 0xd5, 0x2d, 0x59, 0xbb, 
+			    0x07, 0x96, 0x36, 0x58, 0x79, 0xef, 0xf8, 0x86, 
+			    0xc6, 0x6d, 0xd5, 0x1a, 0x5b, 0x6a, 0x99, 0x74, 
+			    0x4b, 0x50, 0x59, 0x0c, 0x87, 0xa2, 0x38, 0x84, 
+			    0x00, 0xfa, 0xac, 0x24 }, 
+		.klen 	= 36, 
+		.iv	= { 0xc1, 0x58, 0x5e, 0xf1, 0x5a, 0x43, 0xd8, 0x75 },  
+		.input	= { 0xf0, 0x5e, 0x23, 0x1b, 0x38, 0x94, 0x61, 0x2c, 
+			    0x49, 0xee, 0x00, 0x0b, 0x80, 0x4e, 0xb2, 0xa9, 
+			    0xb8, 0x30, 0x6b, 0x50, 0x8f, 0x83, 0x9d, 0x6a, 
+			    0x55, 0x30, 0x83, 0x1d, 0x93, 0x44, 0xaf, 0x1c }, 
+		.ilen	= 32, 
+		.result	= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 
+			    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 	
+			    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
+			    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f }, 
+		.rlen	= 32, 
+	}, 
+};
+	
 /* Cast5 test vectors from RFC 2144 */
 #define CAST5_ENC_TEST_VECTORS	3
 #define CAST5_DEC_TEST_VECTORS	3
