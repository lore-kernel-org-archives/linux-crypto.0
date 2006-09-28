From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: crypto: Add support for the Geode AES engine (v3)
Date: Thu, 28 Sep 2006 16:03:36 -0600
Message-ID: <20060928220336.GA24564@cosmic.amd.com>
References: <20060927193147.GA21043@cosmic.amd.com>
 <20060928102337.GB23342@2ka.mipt.ru>
 <20060928214750.GM25387@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="ikeVEW9yuYc//A+q"
Cc: linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com,
	akpm@osdl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:11164 "EHLO
	outbound1-cpk-R.bigfish.com") by vger.kernel.org with ESMTP
	id S1161119AbWI1V7y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 17:59:54 -0400
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
In-Reply-To: <20060928214750.GM25387@cosmic.amd.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Sigh - forgot to do an 'stg refresh' before generating the diff.  This one
actually compiles.

Jordan
-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>

--ikeVEW9yuYc//A+q
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=geode-lx-crypto.patch
Content-Transfer-Encoding: 7bit

[PATCH] crypto:  Add support for the Geode LX AES hardware

This adds support for the AES engine on the Geode LX processor.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index adb5541..e816535 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -51,4 +51,17 @@ config CRYPTO_DEV_PADLOCK_SHA
 	  If unsure say M. The compiled module will be
 	  called padlock-sha.ko
 
+config CRYPTO_DEV_GEODE
+	tristate "Support for the Geode LX AES engine"
+	depends on CRYPTO && X86_32
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	default m
+	help
+	  Say 'Y' here to use the AMD Geode LX processor on-board AES
+	  engine for the CryptoAPI AES alogrithm.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called geode-aes.
+
 endmenu
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 4c3d0ec..6059cf8 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
+obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
new file mode 100644
index 0000000..1fbc41d
--- /dev/null
+++ b/drivers/crypto/geode-aes.c
@@ -0,0 +1,486 @@
+/* CryptoAPI interface for the Geode LX hardware AES encryption module
+ * Copyright (C) 2004-2006, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/crypto.h>
+#include <linux/spinlock.h>
+#include <crypto/algapi.h>
+
+#include <asm/io.h>
+#include <asm/delay.h>
+
+#include "geode-aes.h"
+
+/* Register definitions */
+
+#define AES_CTRLA_REG  0x0000
+
+#define AES_CTRL_START     0x01
+#define AES_CTRL_DECRYPT   0x00
+#define AES_CTRL_ENCRYPT   0x02
+#define AES_CTRL_WRKEY     0x04
+#define AES_CTRL_DCA       0x08
+#define AES_CTRL_SCA       0x10
+#define AES_CTRL_CBC       0x20
+
+#define AES_INTR_REG  0x0008
+
+#define AES_INTRA_PENDING (1 << 16)
+#define AES_INTRB_PENDING (1 << 17)
+
+#define AES_INTR_PENDING  (AES_INTRA_PENDING | AES_INTRB_PENDING)
+#define AES_INTR_MASK     0x07
+
+#define AES_SOURCEA_REG   0x0010
+#define AES_DSTA_REG      0x0014
+#define AES_LENA_REG      0x0018
+#define AES_WRITEKEY0_REG 0x0030
+#define AES_WRITEIV0_REG  0x0040
+
+/*  A very large counter that is used to gracefully bail out of an
+ *  operation in case of trouble
+ */
+
+#define AES_OP_TIMEOUT    0x50000
+
+/* Useful macros */
+
+#define SET_KEY(key) _writefield(AES_WRITEKEY0_REG, key)
+#define SET_IV(iv)   _writefield(AES_WRITEIV0_REG, iv)
+#define GET_IV(iv)   _readfield(AES_WRITEIV0_REG, iv)
+#define AWRITE(val, reg) (iowrite32(val, _iobase + reg))
+#define AREAD(reg)  (ioread32(_iobase + reg))
+
+/* Static structures */
+
+static void __iomem * _iobase;
+static spinlock_t lock;
+
+/* Write a 128 bit field (either a writable key or IV) */
+static inline void
+_writefield(u32 offset, void *value)
+{
+	int i;
+	for(i = 0; i < 4; i++)
+		AWRITE(((u32 *) value)[i], offset + (i * 4));
+}
+
+/* Read a 128 bit field (either a writable key or IV) */
+static inline void
+_readfield(u32 offset, void *value)
+{
+	int i;
+	for(i = 0; i < 4; i++)
+		((u32 *) value)[i] = AREAD(offset + (i * 4));
+}
+
+static int
+do_crypt(void *src, void *dst, int len, u32 flags)
+{
+	u32 status;
+	u32 counter = AES_OP_TIMEOUT;
+
+	AWRITE(virt_to_phys(src), AES_SOURCEA_REG);
+	AWRITE(virt_to_phys(dst), AES_DSTA_REG);
+	AWRITE(len,  AES_LENA_REG);
+
+	/* Start the operation */ 
+	AWRITE(AES_CTRL_START | flags, AES_CTRLA_REG);
+
+	do 
+		status = AREAD(AES_INTR_REG);
+	while(!(status & AES_INTRA_PENDING) && --counter);
+
+	/* Clear the event */
+	AWRITE((status & 0xFF) | AES_INTRA_PENDING, AES_INTR_REG);
+	return counter ? 0 : 1;
+}
+
+unsigned int
+geode_aes_crypt(struct geode_aes_op *op)
+{
+
+	u32 flags = 0;
+	int iflags;
+
+	if (op->len == 0 || op->src == op->dst)
+		return 0;
+
+	if (op->flags & AES_FLAGS_COHERENT)
+		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
+
+	if (op->dir == AES_DIR_ENCRYPT)
+		flags |= AES_CTRL_ENCRYPT;
+
+	/* Start the critical section */
+
+	spin_lock_irqsave(&lock, iflags);
+
+	if (op->mode == AES_MODE_CBC) {
+		flags |= AES_CTRL_CBC;
+		SET_IV(op->iv);
+	}
+
+	if (op->flags & AES_FLAGS_USRKEY) {
+		flags |= AES_CTRL_WRKEY;
+		SET_KEY(op->key);
+	}
+
+	do_crypt(op->src, op->dst, op->len, flags);
+
+	if (op->mode == AES_MODE_CBC)
+		GET_IV(op->iv);
+
+	spin_unlock_irqrestore(&lock, iflags);
+
+	return op->len;
+}
+
+/* CRYPTO-API Functions */
+
+#define blk_ctx(tfm) ((struct geode_aes_op *) crypto_blkcipher_ctx(tfm))
+#define ctx(tfm) ((struct geode_aes_op *) crypto_tfm_ctx(tfm))
+
+static int
+geode_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
+{
+	struct geode_aes_op *op = ctx(tfm);
+
+	if (len != AES_KEY_LENGTH) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	memcpy(op->key, key, len);
+	return 0;
+}
+
+static void
+geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct geode_aes_op *op = ctx(tfm);
+
+	if ((out == NULL) || (in == NULL))
+		return;
+
+	op->src = (void *) in;
+	op->dst = (void *) out;
+	op->mode = AES_MODE_ECB;
+	op->flags = 0;
+	op->len = AES_MIN_BLOCK_SIZE;
+	op->dir = AES_DIR_ENCRYPT;
+
+	geode_aes_crypt(op);
+}
+
+
+static void
+geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	struct geode_aes_op *op = ctx(tfm);
+
+	if ((out == NULL) || (in == NULL))
+		return;
+
+	op->src = (void *) in;
+	op->dst = (void *) out;
+	op->mode = AES_MODE_ECB;
+	op->flags = 0;
+	op->len = AES_MIN_BLOCK_SIZE;
+	op->dir = AES_DIR_DECRYPT;
+
+	geode_aes_crypt(op);
+}
+
+
+static struct crypto_alg geode_alg = {
+	.cra_name               =       "aes",
+	.cra_driver_name	=       "geode-aes-128",
+	.cra_priority           =       300,
+	.cra_alignmask          =       15,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct geode_aes_op),
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
+	.cra_u			=	{
+		.cipher = {
+			.cia_min_keysize	=  AES_KEY_LENGTH,
+			.cia_max_keysize	=  AES_KEY_LENGTH,
+			.cia_setkey		=  geode_setkey,
+			.cia_encrypt		=  geode_encrypt,
+			.cia_decrypt		=  geode_decrypt
+		}
+	}
+};
+
+static int
+geode_cbc_decrypt(struct blkcipher_desc *desc,
+		  struct scatterlist *dst, struct scatterlist *src,
+		  unsigned int nbytes)
+{
+	struct geode_aes_op *op = blk_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err, ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while((nbytes = walk.nbytes)) {
+		op->src = (void *) walk.src.virt.addr,
+		op->dst = (void *) walk.dst.virt.addr;
+		op->mode = AES_MODE_CBC;
+		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->dir = AES_DIR_DECRYPT;
+
+		memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+
+		ret = geode_aes_crypt(op);
+
+		memcpy(walk.iv, op->iv, AES_IV_LENGTH);
+		nbytes -= ret;
+
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static int
+geode_cbc_encrypt(struct blkcipher_desc *desc,
+		  struct scatterlist *dst, struct scatterlist *src,
+		  unsigned int nbytes)
+{
+	struct geode_aes_op *op = blk_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err, ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while((nbytes = walk.nbytes)) {
+		op->src = (void *) walk.src.virt.addr,
+		op->dst = (void *) walk.dst.virt.addr;
+		op->mode = AES_MODE_CBC;
+		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->dir = AES_DIR_ENCRYPT;
+
+		memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+
+		ret = geode_aes_crypt(op);
+		nbytes -= ret;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static struct crypto_alg geode_cbc_alg = {
+	.cra_name		=	"cbc(aes)",
+	.cra_driver_name	=	"cbc-aes-geode-128",
+	.cra_priority		=	400,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct geode_aes_op),
+	.cra_alignmask		=	15,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	AES_KEY_LENGTH,
+			.max_keysize		=	AES_KEY_LENGTH,
+			.setkey			=	geode_setkey,
+			.encrypt		=	geode_cbc_encrypt,
+			.decrypt		=	geode_cbc_decrypt,
+		}
+	}
+};
+
+static int
+geode_ecb_decrypt(struct blkcipher_desc *desc,
+		  struct scatterlist *dst, struct scatterlist *src,
+		  unsigned int nbytes)
+{
+	struct geode_aes_op *op = blk_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err, ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while((nbytes = walk.nbytes)) {
+		op->src = (void *) walk.src.virt.addr,
+		op->dst = (void *) walk.dst.virt.addr;
+		op->mode = AES_MODE_ECB;
+		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->dir = AES_DIR_DECRYPT;
+
+		ret = geode_aes_crypt(op);
+		nbytes -= ret;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static int
+geode_ecb_encrypt(struct blkcipher_desc *desc,
+		  struct scatterlist *dst, struct scatterlist *src,
+		  unsigned int nbytes)
+{
+	struct geode_aes_op *op = blk_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err, ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while((nbytes = walk.nbytes)) {
+		op->src = (void *) walk.src.virt.addr,
+		op->dst = (void *) walk.dst.virt.addr;
+		op->mode = AES_MODE_ECB;
+		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->dir = AES_DIR_ENCRYPT;
+
+		ret = geode_aes_crypt(op);
+		nbytes -= ret;
+		ret =  blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static struct crypto_alg geode_ecb_alg = {
+	.cra_name		=	"ecb(aes)",
+	.cra_driver_name	=	"ecb-aes-geode-128",
+	.cra_priority		=	400,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct geode_aes_op),
+	.cra_alignmask		=	15,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	AES_KEY_LENGTH,
+			.max_keysize		=	AES_KEY_LENGTH,
+			.setkey			=	geode_setkey,
+			.encrypt		=	geode_ecb_encrypt,
+			.decrypt		=	geode_ecb_decrypt,
+		}
+	}
+};
+
+static void
+geode_aes_remove(struct pci_dev *dev)
+{
+	crypto_unregister_alg(&geode_alg);
+	crypto_unregister_alg(&geode_ecb_alg);
+	crypto_unregister_alg(&geode_cbc_alg);
+
+	pci_iounmap(dev, _iobase);
+	_iobase = NULL;
+
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+}
+
+
+static int
+geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	int ret;
+
+	if ((ret = pci_enable_device(dev)))
+		return ret;
+
+	if ((ret = pci_request_regions(dev, "geode-aes-128")))
+		goto eenable;
+
+	_iobase = pci_iomap(dev, 0, 0);
+
+	if (_iobase == NULL) {
+		ret = -ENOMEM;
+		goto erequest;
+	}
+
+	spin_lock_init(&lock);
+
+	/* Clear any pending activity */
+	AWRITE(AES_INTR_PENDING | AES_INTR_MASK, AES_INTR_REG);
+
+	if ((ret = crypto_register_alg(&geode_alg)))
+		goto eiomap;
+
+	if ((ret = crypto_register_alg(&geode_ecb_alg)))
+		goto ealg;
+
+	if ((ret = crypto_register_alg(&geode_cbc_alg)))
+		goto eecb;
+
+	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled.\n");
+	return 0;
+
+ eecb:
+	crypto_unregister_alg(&geode_ecb_alg);
+
+ ealg:
+	crypto_unregister_alg(&geode_alg);
+
+ eiomap:
+	pci_iounmap(dev, _iobase);
+
+ erequest:
+	pci_release_regions(dev);
+
+ eenable:
+	pci_disable_device(dev);
+
+	printk(KERN_ERR "geode-aes:  GEODE AES initialization failed.\n");
+	return ret;
+}
+
+struct pci_device_id geode_aes_tbl[] = {
+	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES, PCI_ANY_ID, PCI_ANY_ID} ,
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, geode_aes_tbl);
+
+static struct pci_driver geode_aes_driver = {
+	name:      "Geode LX AES",
+	id_table:  geode_aes_tbl,
+	probe:     geode_aes_probe,
+	remove:    __devexit_p(geode_aes_remove)
+};
+
+static int __devinit
+geode_aes_init(void)
+{
+	return pci_module_init(&geode_aes_driver);
+}
+
+static void __devexit
+geode_aes_exit(void)
+{
+	pci_unregister_driver(&geode_aes_driver);
+}
+
+MODULE_AUTHOR("Advanced Micro Devices, Inc.");
+MODULE_DESCRIPTION("Geode LX Hardware AES driver");
+MODULE_LICENSE("GPL");
+
+module_init(geode_aes_init);
+module_exit(geode_aes_exit);
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
new file mode 100644
index 0000000..97f9eee
--- /dev/null
+++ b/drivers/crypto/geode-aes.h
@@ -0,0 +1,42 @@
+/* Copyright (C) 2003-2006, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _GEODE_AES_H_
+#define _GEODE_AES_H_
+
+#define AES_KEY_LENGTH 16
+#define AES_IV_LENGTH  16
+
+#define AES_MIN_BLOCK_SIZE 16
+
+#define AES_MODE_ECB 0
+#define AES_MODE_CBC 1
+
+#define AES_DIR_DECRYPT 0
+#define AES_DIR_ENCRYPT 1
+
+#define AES_FLAGS_USRKEY   (1 << 0)
+#define AES_FLAGS_COHERENT (1 << 1)
+
+struct geode_aes_op {
+
+  void *src;
+  void *dst;
+
+  u32 mode;
+  u32 dir;
+  u32 flags;
+  int len;
+
+  u8 key[AES_KEY_LENGTH];
+  u8 iv[AES_IV_LENGTH];
+};
+
+unsigned int geode_aes_crypt(struct geode_aes_op *);
+
+#endif

--ikeVEW9yuYc//A+q--


