From: "Loc Ho" <lho@amcc.com>
Subject: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Tue, 13 May 2008 17:00:58 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Shasi Pulijala" <spulijala@amcc.com>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:8842 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYENABX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2008 20:01:23 -0400
Content-class: urn:content-classes:message
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I am re-sending this email as I don't believe it got to the mailing
list. Due to email problem, I am forward this patch on behalf of Shasi
Pulijala who worked on this user space interface for Linux CryptoAPI.
This should add support for OpenSSL. Please note that user of this patch
musts patch OpenSSL. The OpenSSL patch can be found in OCF-Linux as this
interface uses the same I/O control interface.
 
-Loc


>From 926bbdedff99b1e8bb25cd685cb7249ba21729d9 Mon Sep 17 00:00:00 2001
From: Shasi Pulijala <spulijala@amcc.com>
Date: Thu, 8 May 2008 11:08:26 -0700
Subject: [PATCH] Add CryptoAPI User Interface Support


Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
---
 crypto/Kconfig            |    7 +
 crypto/Makefile           |    1 +
 crypto/cryptodev.c        | 1284
+++++++++++++++++++++++++++++++++++++++++++++
 fs/fcntl.c                |    9 +-
 include/linux/cryptodev.h |  119 +++++
 include/linux/fs.h        |    1 +
 6 files changed, 1420 insertions(+), 1 deletions(-)
 create mode 100644 crypto/cryptodev.c
 create mode 100644 include/linux/cryptodev.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69f1be6..de6d623 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -52,6 +52,13 @@ config CRYPTO_MANAGER
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
 
+config CRYPTO_CRYPTODEV
+	tristate "Cryptodev (/dev/crypto) interface"
+	depends on CRYPTO
+	help
+	  Device /dev/crypto gives userspace programs access to 
+	  kernel crypto algorithms.
+
 config CRYPTO_HMAC
 	tristate "HMAC support"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 85d0109..3d5251b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -22,6 +22,7 @@ crypto_hash-objs += ahash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_CRYPTODEV) += cryptodev.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
diff --git a/crypto/cryptodev.c b/crypto/cryptodev.c
new file mode 100644
index 0000000..9175ee0
--- /dev/null
+++ b/crypto/cryptodev.c
@@ -0,0 +1,1284 @@
+/**********************************************************************
*********
+ * cryptodev.c
+ *
+ * Linux CryptoAPI user space interface module
+ *
+ * Copyright (c) 2008 Shasi Pulijala <spulijala@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * Detail Description:
+ * This file implements the /dev/crypto interface which is intended to
+ * provide user space interface to the Linux CryptoAPI.
+ *
+
************************************************************************
*******
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/miscdevice.h>
+#include <linux/crypto.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/random.h>
+#include <linux/cryptodev.h>
+#include <linux/syscalls.h>
+#include <linux/scatterlist.h>
+#include <linux/time.h>
+#include <linux/unistd.h>
+#include <linux/rtnetlink.h>
+#include <linux/err.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <asm/uaccess.h>
+#include <asm/ioctl.h>
+#include <asm/scatterlist.h>
+#include <asm-powerpc/unistd.h>
+
+/**********************************************************************
*********
+ * Forward declaration
+
************************************************************************
*******
+ */
+#define CRYPTODEV_DEBUG
+
+/**********************************************************************
*********
+ * Macro declaration
+
************************************************************************
*******
+ */
+/* /dev/crypto is a char block device with majar 10 and minor below */
+#define	CRYPTODEV_MINOR				70
+
+#define	CRYPTODEV_UI_SUPPORT_DRIVER		"0.1"
+
+/**********************************************************************
*********
+ * Module Parameters
+
************************************************************************
*******
+ */
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "0: normal, 1: verbose, 2: debug");
+
+static int sg_single;
+module_param(sg_single, int, 0644);
+MODULE_PARM_DESC(sg_single, "0: sg array list, 1: single sg entity");
+
+#ifdef CRYPTODEV_STATS
+static int enable_stats;
+module_param(enable_stats, int, 0644);
+MODULE_PARM_DESC(enable_stats, "collect statictics about cryptodev
usage");
+#endif
+
+/**********************************************************************
*********
+ * Debugging Macro's
+
************************************************************************
*******
+ */
+#define PFX "cryptodev: "
+
+#ifndef CRYPTODEV_DEBUG
+#define CRYPTODEV_HEXDUMP(b, l) \
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET, \
+				16, 1, (b), (l), false);
+#define CRYPTODEV_PRINTK(level, severity, format, a...)
\
+	do {
\
+		if (level <= debug)
\
+			printk(severity PFX "%s[%u]: " format,
\
+			       current->comm, current->pid, ##a);
\
+	} while (0)
+#else
+#define CRYPTODEV_HEXDUMP(b, l)
+#define CRYPTODEV_PRINTK(level, severity, format, a...)
+#endif
+
+/**********************************************************************
*********
+ * Helper Structure
+
************************************************************************
*******
+ */
+#define CRYPTO_ACIPHER	0
+#define CRYPTO_AHASH	1
+#define CRYPTO_AEAD	2
+
+#define tfm_ablkcipher	crt_tfm.acipher_tfm
+#define tfm_aead	crt_tfm.aead_tfm
+#define tfm_ahash	crt_tfm.ahash_tfm
+
+struct csession {
+	struct list_head entry;
+	struct semaphore sem;
+	union {
+		struct crypto_ablkcipher *acipher_tfm;
+		struct crypto_ahash 	 *ahash_tfm;
+		struct crypto_aead 	 *aead_tfm;
+	} crt_tfm;
+
+	int 		mode;
+	unsigned int 	sid;
+};
+
+/**********************************************************************
*********
+ * Table Lookup for Algorithms name(Crypto/hash name)
+ * Helper Structure
+
************************************************************************
*******
+ */
+char *algo_map_tbl[CRYPTO_ALGORITHM_MAX] = {
+	[CRYPTO_DES_CBC]  	= "cbc(des)",
+	[CRYPTO_3DES_CBC] 	= "cbc(des3_ede)",
+	[CRYPTO_MD5_HMAC] 	= "hmac(md5)",
+	[CRYPTO_BLF_CBC]  	= "cbc(blowfish)",
+	[CRYPTO_CAST_CBC]		= "cbc(cast5)",
+	[CRYPTO_SKIPJACK_CBC]	= "camellia",
+	[CRYPTO_MD5_HMAC]		= "hmac(md5)",
+	[CRYPTO_SHA1_HMAC]	= "hmac(sha1)",
+	[CRYPTO_RIPEMD160_HMAC]	= "hmac(rmd160)",
+	[CRYPTO_MD5_KPDK]		= "",
+	[CRYPTO_SHA1_KPDK]	= "",
+	[CRYPTO_RIJNDAEL128_CBC] = "cbc(aes)",
+	[CRYPTO_AES_CBC]		= "cbc(aes)",
+	[CRYPTO_ARC4]		= "ecb(arc4)",
+	[CRYPTO_MD5]		= "md5",
+	[CRYPTO_SHA1]		= "sha1",
+	[CRYPTO_NULL_HMAC]	= "",
+	[CRYPTO_NULL_CBC]		= "",
+	[CRYPTO_DEFLATE_COMP]	= "deflate",
+	[CRYPTO_SHA2_256_HMAC]	= "hmac(sha256)",
+	[CRYPTO_SHA2_384_HMAC]	= "hmac(sha384)",
+	[CRYPTO_SHA2_512_HMAC]	= "hmac(sha512)",
+	[CRYPTO_CAMELLIA_CBC]	= "cbc(camellia)",
+	[CRYPTO_SHA2_256]		= "sha256",
+	[CRYPTO_SHA2_384]		= "sha384",
+	[CRYPTO_SHA2_512]		= "sha512",
+	[CRYPTO_RIPEMD160]	= "rmd160",
+	[CRYPTO_AES_GCM]		= "gcm(aes)",
+	[CRYPTO_AES_CCM]		= "ccm(aes)",
+};
+
+struct fcrypt {
+	struct list_head list;
+	struct semaphore sem;
+};
+
+struct async_result {
+	struct completion completion;
+	int err;
+};
+
+/**********************************************************************
*********
+ * Function Declarations
+
************************************************************************
*******
+ */
+static int create_session_ablkcipher(char *alg_name,
+				struct fcrypt *fcr,
+				struct session_op *sop);
+static int create_session_ahash(char *alg_name,
+				struct fcrypt *fcr,
+				struct session_op *sop);
+static int create_session_aead(char *alg_name,
+				struct fcrypt *fcr,
+				struct session_op *sop);
+static int cryptodev_run_acipher(struct csession *ses_ptr,
+				struct crypt_op *cop);
+static int cryptodev_run_ahash(struct csession *ses_ptr,
+				struct crypt_op *cop);
+static int cryptodev_run_aead(struct csession *ses_ptr,
+				struct crypt_op *cop);
+static int sg_setup(unsigned char *addr, int bufsize, struct
scatterlist *sg,
+				int sg_single);
+
+/**********************************************************************
*********
+ * Asynchronous handling Routine
+ *
+
************************************************************************
*******
+ */
+static void cryptodev_async_complete(struct crypto_async_request *req,
int err)
+{
+	struct async_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+/**********************************************************************
*********
+ * Prepare session for future use
+ *
+
************************************************************************
*******
+ */
+static int cryptodev_create_session(struct fcrypt *fcr, struct
session_op *sop)
+{
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	int  mode = -1;
+	int ret =  0;
+
+	if (sop->mac > CRYPTO_ALGORITHM_MAX ||
+		sop->cipher > CRYPTO_ALGORITHM_MAX) {
+		printk(KERN_INFO PFX "algorithm not supported or "
+			"not set\n");
+		return -EINVAL;
+	}
+
+	if (sop->cipher && sop->mac) {
+		mode = CRYPTO_AEAD;
+		printk(KERN_INFO PFX "authenc(%s,%s) (Algorithm
Chanining Mode"
+			"not yet supported", algo_map_tbl[sop->mac],
+			algo_map_tbl[sop->cipher]);
+		return -EINVAL;
+	} else if (sop->cipher) {
+		if (sop->cipher == CRYPTO_AES_GCM ||
+			sop->cipher == CRYPTO_AES_CCM)
+			mode = CRYPTO_AEAD;
+		else
+			mode = CRYPTO_ACIPHER;
+		strncpy(alg_name, algo_map_tbl[sop->cipher],
+			 CRYPTO_MAX_ALG_NAME);
+	} else if (sop->mac) {
+		mode = CRYPTO_AHASH;
+		strncpy(alg_name, algo_map_tbl[sop->mac],
CRYPTO_MAX_ALG_NAME);
+	}
+
+	if (!alg_name)
+		return -EINVAL;
+
+	switch (mode) {
+	case CRYPTO_ACIPHER:
+		ret = create_session_ablkcipher(alg_name, fcr, sop);
+		break;
+	case CRYPTO_AHASH:
+		ret = create_session_ahash(alg_name, fcr, sop);
+		break;
+	case CRYPTO_AEAD:
+		ret = create_session_aead(alg_name, fcr, sop);
+		break;
+	default:
+		printk(KERN_INFO PFX "Improper Mode Set(Not
Cipher/Hash/Aead)");
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+/**********************************************************************
*********
+ * Routine for Creating a Session for the Combined Mode Implementation
+ *
+
************************************************************************
*******
+ */
+static int create_session_aead(char *alg_name, struct fcrypt *fcr,
+			struct session_op *sop)
+{
+	struct csession	*ses_new;
+	struct csession	*ses_ptr;
+	struct crypto_aead *tfm;
+	char *keyp = NULL;
+	size_t authsize;
+	int ret = 0;
+
+	tfm = crypto_alloc_aead(alg_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk(KERN_INFO PFX "Failed to load aead"
+			"transform for %s: %ld \n", alg_name,
PTR_ERR(tfm));
+		return -EINVAL;
+	}
+
+	crypto_aead_clear_flags(tfm, ~0);
+
+	keyp = kmalloc(sop->keylen, GFP_KERNEL);
+	if (unlikely(!keyp)) {
+		crypto_free_aead(tfm);
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(keyp, sop->key, sop->keylen)) {
+		printk(KERN_INFO PFX "Copy of Key Failed from"
+		"User Space for %s\n", alg_name);
+		kfree(keyp);
+		crypto_free_aead(tfm);
+		return -EFAULT;
+	}
+
+	ret = crypto_aead_setkey(tfm, keyp, sop->keylen);
+	kfree(keyp);
+	if (ret) {
+		printk(KERN_INFO PFX
+			"Setting key failed for %s-%zu: flags=0x%X\n",
+			alg_name, sop->keylen*8,
+			crypto_aead_get_flags(tfm));
+		printk(KERN_INFO PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> "
+			"for details)\n");
+
+		crypto_free_aead(tfm);
+		return -EINVAL;
+	}
+
+	/* Supporting Authsize for ccm and gcm from mackeylen
+	(no separate field for authsize) */
+	authsize = sop->mackeylen;
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		printk(KERN_INFO "failed to set authsize = %u\n",
authsize);
+		crypto_free_aead(tfm);
+		return -EINVAL;
+	}
+
+	ses_new = kmalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_aead(tfm);
+		return -ENOMEM;
+	}
+
+	memset(ses_new, 0, sizeof(*ses_new));
+	get_random_bytes(&ses_new->sid, sizeof(ses_new->sid));
+	ses_new->tfm_aead = tfm;
+
+	ses_new->mode = CRYPTO_AEAD;
+	init_MUTEX(&ses_new->sem);
+
+	down(&fcr->sem);
+
+restart:
+	list_for_each_entry(ses_ptr, &fcr->list, entry) {
+		/* Check for duplicate SID */
+		if (unlikely(ses_new->sid == ses_ptr->sid)) {
+			get_random_bytes(&ses_new->sid,
sizeof(ses_new->sid));
+			goto restart;
+		}
+	}
+
+	list_add(&ses_new->entry, &fcr->list);
+	up(&fcr->sem);
+
+	sop->ses = ses_new->sid;
+
+	return 0;
+}
+
+/**********************************************************************
*********
+ * Routine for Creating a Session for the Hash Implementation
+ *
+
************************************************************************
*******
+ */
+static int create_session_ahash(char *alg_name, struct fcrypt *fcr,
+			struct session_op *sop)
+{
+	struct csession	*ses_new;
+	struct csession	*ses_ptr;
+	struct crypto_ahash *tfm;
+	char *keyp = NULL;
+	int ret = 0;
+
+	tfm = crypto_alloc_ahash(alg_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk(KERN_INFO PFX "Failed to load ahash "
+			"transform for %s: %ld \n", alg_name,
PTR_ERR(tfm));
+		return -EINVAL;
+	}
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	/* Copy the key(hmac) from user and set to TFM. */
+	if (sop->mackey && (sop->mac != CRYPTO_MD5) && (sop->mac !=
CRYPTO_SHA1)
+		&& (sop->mac != CRYPTO_SHA2_256)
+		&& (sop->mac != CRYPTO_SHA2_384)
+		&& (sop->mac != CRYPTO_SHA2_512)
+		&& (sop->mac != CRYPTO_RIPEMD160)) {
+		keyp = kmalloc(sop->mackeylen, GFP_KERNEL);
+		if (unlikely(!keyp)) {
+			crypto_free_ahash(tfm);
+			return -ENOMEM;
+		}
+
+		if (copy_from_user(keyp, sop->mackey, sop->mackeylen)) {
+			printk(KERN_INFO PFX "Copy of Key Failed from
User"
+			"space for %s\n", alg_name);
+			kfree(keyp);
+			crypto_free_ahash(tfm);
+			return -EFAULT;
+		}
+
+		ret = crypto_ahash_setkey(tfm, keyp, sop->mackeylen);
+		kfree(keyp);
+		if (ret) {
+			printk(KERN_INFO PFX
+				"Setting key failed for %s-%zu:
flags=0x%X\n",
+				alg_name, sop->mackeylen * 8,
+				crypto_ahash_get_flags(tfm));
+			printk(KERN_INFO PFX
+				"(see CRYPTO_TFM_RES_* in "
+				"<linux/crypto.h> for details)\n");
+
+			crypto_free_ahash(tfm);
+			return -EINVAL;
+		}
+	}
+
+	ses_new = kmalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_ahash(tfm);
+		return -ENOMEM;
+	}
+
+	memset(ses_new, 0, sizeof(*ses_new));
+	get_random_bytes(&ses_new->sid, sizeof(ses_new->sid));
+	ses_new->tfm_ahash = tfm;
+
+	ses_new->mode = CRYPTO_AHASH;
+	init_MUTEX(&ses_new->sem);
+
+	down(&fcr->sem);
+
+restart:
+	list_for_each_entry(ses_ptr, &fcr->list, entry) {
+		/* Check for duplicate SID */
+		if (unlikely(ses_new->sid == ses_ptr->sid)) {
+			get_random_bytes(&ses_new->sid,
sizeof(ses_new->sid));
+			goto restart;
+		}
+	}
+	list_add(&ses_new->entry, &fcr->list);
+	up(&fcr->sem);
+
+	/* Fill in some values for the user. */
+	sop->ses = ses_new->sid;
+
+	return 0;
+}
+
+/**********************************************************************
*********
+ * Routine for Creating a Session for the Crypto Implementation
+ *
+
************************************************************************
*******
+ */
+static int create_session_ablkcipher(char *alg_name, struct fcrypt
*fcr,
+			struct session_op *sop)
+{
+	struct csession	*ses_new, *ses_ptr;
+	struct crypto_ablkcipher *tfm;
+	char *keyp = NULL;
+	int ret = 0;
+
+	tfm = crypto_alloc_ablkcipher(alg_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk(KERN_INFO PFX "Failed to load crypto "
+			"transform for %s: %ld\n", alg_name,
PTR_ERR(tfm));
+		return -EINVAL;
+	}
+
+	crypto_ablkcipher_clear_flags(tfm, ~0);
+
+	/* Copy the key from user and set to TFM. */
+	keyp = kmalloc(sop->keylen, GFP_KERNEL);
+	if (unlikely(!keyp)) {
+		crypto_free_ablkcipher(tfm);
+		return -ENOMEM;
+
+	}
+
+	if (copy_from_user(keyp, sop->key, sop->keylen)) {
+		printk(KERN_INFO PFX "Copy of Key Failed from User"
+		"space for %s\n", alg_name);
+		kfree(keyp);
+		crypto_free_ablkcipher(tfm);
+		return -EFAULT;
+	}
+
+	ret = crypto_ablkcipher_setkey(tfm, keyp, sop->keylen);
+	kfree(keyp);
+	if (ret) {
+		printk(KERN_INFO PFX
+			"Setting key failed for %s-%zu: flags=0x%X\n",
+			alg_name, sop->keylen*8,
+			crypto_ablkcipher_get_flags(tfm));
+		printk(KERN_INFO PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> for "
+			"details)\n");
+
+		crypto_free_ablkcipher(tfm);
+		return -EINVAL;
+	}
+
+	ses_new = kmalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_ablkcipher(tfm);
+		return -ENOMEM;
+	}
+
+	memset(ses_new, 0, sizeof(*ses_new));
+	get_random_bytes(&ses_new->sid, sizeof(ses_new->sid));
+	ses_new->tfm_ablkcipher = tfm;
+
+	ses_new->mode = CRYPTO_ACIPHER;
+	init_MUTEX(&ses_new->sem);
+
+	down(&fcr->sem);
+
+restart:
+	list_for_each_entry(ses_ptr, &fcr->list, entry) {
+		/* Check for duplicate SID */
+		if (unlikely(ses_new->sid == ses_ptr->sid)) {
+			get_random_bytes(&ses_new->sid,
sizeof(ses_new->sid));
+			goto restart;
+		}
+	}
+	list_add(&ses_new->entry, &fcr->list);
+	up(&fcr->sem);
+
+	/* Fill in some values for the user. */
+	sop->ses = ses_new->sid;
+
+	return 0;
+}
+
+/**********************************************************************
*********
+ *  Everything that needs to be done when removing a session.
+ *
+
************************************************************************
*******
+ */
+static inline void cryptodev_destroy_session(struct csession *ses_ptr)
+{
+	if (down_trylock(&ses_ptr->sem)) {
+		CRYPTODEV_PRINTK(2, KERN_DEBUG,
+			"Waiting for semaphore of sid=0x%08X\n",
+			ses_ptr->sid);
+		down(&ses_ptr->sem);
+	}
+	CRYPTODEV_PRINTK(2, KERN_DEBUG, "Removed session 0x%08X\n",
+			 ses_ptr->sid);
+
+	/* Check for mode and then delete */
+	switch (ses_ptr->mode) {
+	case CRYPTO_ACIPHER:
+		crypto_free_ablkcipher(ses_ptr->tfm_ablkcipher);
+		ses_ptr->tfm_ablkcipher = NULL;
+		break;
+	case CRYPTO_AHASH:
+		crypto_free_ahash(ses_ptr->tfm_ahash);
+		ses_ptr->tfm_ahash = NULL;
+		break;
+	case CRYPTO_AEAD:
+		crypto_free_aead(ses_ptr->tfm_aead);
+		ses_ptr->tfm_aead = NULL;
+		break;
+	}
+	up(&ses_ptr->sem);
+	kfree(ses_ptr);
+}
+
+/**********************************************************************
*********
+ * Look up a session by ID and remove.
+ *
+
************************************************************************
*******
+ */
+static int cryptodev_finish_session(struct fcrypt *fcr, u32 sid)
+{
+	struct csession  *tmp;
+	struct csession  *ses_ptr;
+	struct list_head *head;
+	int ret = 0;
+
+	down(&fcr->sem);
+	head = &fcr->list;
+	list_for_each_entry_safe(ses_ptr, tmp, head, entry) {
+		if (ses_ptr->sid == sid) {
+			list_del(&ses_ptr->entry);
+			cryptodev_destroy_session(ses_ptr);
+			break;
+		}
+	}
+
+	if (!ses_ptr) {
+		CRYPTODEV_PRINTK(1, KERN_ERR,
+			"Session with sid=0x%08X not found!\n", sid);
+		ret = -ENOENT;
+	}
+	up(&fcr->sem);
+
+	return ret;
+}
+
+/**********************************************************************
*********
+ * Remove all sessions when closing the file
+ *
+
************************************************************************
*******
+ */
+static int cryptodev_finish_all_sessions(struct fcrypt *fcr)
+{
+	struct csession *tmp;
+	struct csession *ses_ptr;
+
+	down(&fcr->sem);
+	list_for_each_entry_safe(ses_ptr, tmp, &fcr->list, entry) {
+		list_del(&ses_ptr->entry);
+		cryptodev_destroy_session(ses_ptr);
+	}
+	up(&fcr->sem);
+
+	return 0;
+}
+
+/**********************************************************************
*********
+ * Look up session by session ID. The returned session is locked.
+
************************************************************************
*******
+ */
+static struct csession *cryptodev_get_session_by_sid(struct fcrypt
*fcr,
+							u32 sid)
+{
+	struct csession *ses_ptr;
+
+	down(&fcr->sem);
+	list_for_each_entry(ses_ptr, &fcr->list, entry) {
+		if (ses_ptr->sid == sid) {
+			down(&ses_ptr->sem);
+			break;
+		}
+	}
+	up(&fcr->sem);
+
+	return ses_ptr;
+}
+
+static void cryptodev_release_session(struct csession *session)
+{
+	if (session)
+		up(&session->sem);
+}
+
+/**********************************************************************
*********
+ * This is the main crypto function - feed it with plaintext
+ * and get a ciphertext
+
************************************************************************
*******
+ */
+static int cryptodev_run(struct fcrypt *fcr, struct crypt_op *cop)
+{
+
+	struct csession *ses_ptr;
+	int ret = 0;
+
+	if (cop->op &&
+	    (cop->op != COP_ENCRYPT && cop->op != COP_DECRYPT)) {
+		printk(KERN_INFO PFX "invalid operation op=%u\n",
cop->op);
+		return -EINVAL;
+	}
+
+	ses_ptr = cryptodev_get_session_by_sid(fcr, cop->ses);
+	if (!ses_ptr) {
+		printk(KERN_INFO PFX "invalid session ID=0x%08X\n",
cop->ses);
+		return -EINVAL;
+	}
+
+	switch (ses_ptr->mode) {
+	case CRYPTO_ACIPHER:
+		ret = cryptodev_run_acipher(ses_ptr, cop);
+		break;
+	case CRYPTO_AHASH:
+		ret = cryptodev_run_ahash(ses_ptr, cop);
+		break;
+	case CRYPTO_AEAD:
+		ret = cryptodev_run_aead(ses_ptr, cop);
+		break;
+	}
+	cryptodev_release_session(ses_ptr);
+
+	return ret;
+
+}
+
+/**********************************************************************
*********
+ * This is the routine that splits the user buffer data over
+ * pages and creates scatterlist
+
************************************************************************
*******
+ */
+static int sg_setup(unsigned char *data, int bufsize, struct
scatterlist *sg,
+			int sg_single)
+{
+	int sg_size, remainder_of_page;
+	int i = 0;
+
+	if (sg_single || (!bufsize)) {
+		sg_set_buf(&sg[0], data, bufsize);
+		return 1;
+	}
+	sg_size = bufsize % PAGE_SIZE == 0 ? bufsize/PAGE_SIZE :
+					 bufsize/PAGE_SIZE + 1;
+	sg_init_table(sg, sg_size);
+
+	while (bufsize > 0 && i < sg_size) {
+		sg_set_buf(&sg[i], data, bufsize);
+		remainder_of_page = PAGE_SIZE - sg[i].offset;
+		if (bufsize > remainder_of_page) {
+			/* the buffer was split over multiple pages */
+			sg[i].length = remainder_of_page;
+			bufsize -= remainder_of_page;
+			data += remainder_of_page;
+		} else {
+			bufsize = 0;
+		}
+		i++;
+	}
+	sg_mark_end(&sg[sg_size - 1]);
+
+	return sg_size;
+}
+
+/**********************************************************************
*********
+ * This is the actual aead function that implements
+ * the Combined mode
+
************************************************************************
*******
+ */
+static int cryptodev_run_aead(struct csession *ses_ptr, struct crypt_op
*cop)
+{
+	char *data = NULL;
+	char *ivp  = NULL;
+	char __user *src;
+	char __user *dst;
+	struct scatterlist sg[16];
+	struct scatterlist asg[1];
+	struct aead_request *req;
+	struct async_result result;
+	size_t bufsize;
+	size_t ivsize;
+	size_t order;
+	size_t authsize;
+	int ret = 0;
+	int nsg = 0;
+
+	/* Checking the Input Length */
+	bufsize = cop->len;
+	if (cop->len > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d >
%d\n",
+			cop->len, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	init_completion(&result.completion);
+
+	/* Setting the resquest */
+	req = aead_request_alloc(ses_ptr->tfm_aead, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_INFO PFX "failed to allocate request");
+		return -EINVAL;
+	}
+
+	order = get_order(bufsize);
+	data = (char *) __get_free_pages(GFP_KERNEL, order);
+
+	if (unlikely(!data)) {
+		ret = -ENOMEM;
+		goto out_req;
+	}
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  cryptodev_async_complete, &result);
+
+	src = cop->src;
+	dst = cop->dst;
+
+	authsize = crypto_aead_authsize(ses_ptr->tfm_aead);
+
+	if (copy_from_user(data, src, bufsize)) {
+		printk(KERN_INFO PFX "Copy of src data Failed from User"
+		"space for aead\n");
+		free_pages((unsigned long)data, order);
+		ret = -EFAULT;
+		goto out_req;
+	}
+
+	ivsize = crypto_aead_ivsize(ses_ptr->tfm_aead);
+
+	ivp = kmalloc(ivsize, GFP_KERNEL);
+	if (unlikely(!ivp)) {
+		free_pages((unsigned long)data, order);
+		ret = -ENOMEM;
+		goto out_req;
+	}
+
+	memset(ivp, 0, ivsize);
+	if (cop->iv && copy_from_user(ivp, cop->iv, ivsize)) {
+		printk(KERN_INFO PFX "Copy of src iv Failed from User "
+		"space for aead\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	nsg = sg_setup(data, bufsize + authsize, sg, sg_single);
+	if (!nsg) {
+		printk("Scatter Allocation failed err due to improper"
+			"sg size");
+		goto out;
+	}
+
+	/* Additional Associated data set to 0 bytes */
+	sg_init_one(&asg[0], ivp, 0);
+
+	aead_request_set_crypt(req, sg, sg, bufsize, ivp);
+	aead_request_set_assoc(req, asg, 0);
+
+	if (cop->op == COP_ENCRYPT)
+		ret = crypto_aead_encrypt(req);
+	else
+		ret = crypto_aead_decrypt(req);
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(
+			&result.completion);
+		if (!ret)
+			ret = result.err;
+		if (!ret) {
+			INIT_COMPLETION(result.completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk("%s () failed err=%d\n", "enc/dec", -ret);
+		goto out;
+	}
+
+	CRYPTODEV_HEXDUMP(data, bufsize + authsize);
+	if (copy_to_user(dst, data, bufsize + authsize)) {
+		printk(KERN_INFO PFX "Copy of enc data Failed to User"
+		"space for aead\n");
+		ret = -EFAULT;
+	}
+
+out:
+	free_pages((unsigned long)data, order);
+	kfree(ivp);
+
+out_req:
+	aead_request_free(req);
+
+	return ret;
+}
+
+/**********************************************************************
*********
+ * This is the actual hash function that creates the
+ * authenticated data
+
************************************************************************
*******
+ */
+static int cryptodev_run_ahash(struct csession *ses_ptr, struct
crypt_op *cop)
+{
+
+	char *data = NULL;
+	char __user *src;
+	char __user *mac;
+	struct scatterlist sg[16];
+	struct ahash_request *req;
+	struct async_result result;
+	size_t authsize;
+	size_t bufsize;
+	size_t order;
+	int ret = 0;
+	int nsg = 0;
+	char digest_result[64];
+
+	/* Checking the Input Length */
+	bufsize = cop->len;
+	if (cop->len > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d >
%d\n",
+		 cop->len, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	init_completion(&result.completion);
+
+	/* Setting the resquest */
+	req = ahash_request_alloc(ses_ptr->tfm_ahash, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_INFO PFX "failed to allocate request");
+		return -EINVAL;
+	}
+
+	order = (!bufsize) ? 0 : get_order(bufsize);
+	data = (char *) __get_free_pages(GFP_KERNEL, order);
+
+	if (unlikely(!data)) {
+		printk(KERN_INFO PFX "Improper data size "
+		"set = %d\n", bufsize);
+		ret = -ENOMEM;
+		goto out_req;
+	}
+
+	authsize = crypto_ahash_digestsize(ses_ptr->tfm_ahash);
+	memset(digest_result, 0, 64);
+
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete,
&result);
+
+	src = cop->src;
+	mac = cop->mac;
+
+	if (copy_from_user(data, src, bufsize)) {
+		printk(KERN_INFO PFX "Copy of src data Failed from User"
+		"space for hash\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	nsg = sg_setup(data, bufsize, sg, sg_single);
+	if (!nsg) {
+		printk("Scatter Allocation () failed err=%d\n", nsg);
+		goto out;
+	}
+
+	ahash_request_set_crypt(req, sg, digest_result, bufsize);
+	ret = crypto_ahash_digest(req);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(
+			&result.completion);
+		if (!ret)
+			ret = result.err;
+		if (!ret) {
+			INIT_COMPLETION(result.completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk(KERN_INFO PFX "%s failed err=%d\n", "enc/dec",
-ret);
+		goto out;
+	}
+
+	CRYPTODEV_HEXDUMP(digest_result, authsize);
+	if (copy_to_user(mac, digest_result, authsize)) {
+		printk(KERN_INFO PFX "Copy of mac data Failed to User"
+		"space for hash\n");
+		ret = -EFAULT;
+	}
+
+out:
+	free_pages((unsigned long)data, order);
+
+out_req:
+	ahash_request_free(req);
+
+	return ret;
+}
+
+/**********************************************************************
*********
+ * This is the actual crypto function that creates the
+ * encrypted or decrypted data
+
************************************************************************
*******
+ */
+static int cryptodev_run_acipher(struct csession *ses_ptr, struct
crypt_op *cop)
+{
+	char *data = NULL;
+	char *ivp = NULL;
+	char __user *src;
+	char __user *dst;
+	struct scatterlist sg[16];
+	struct ablkcipher_request *req;
+	struct async_result result;
+	size_t bufsize;
+	size_t ivsize;
+	size_t order;
+	int ret = 0;
+	int nsg = 0;
+
+	/* Checking the Input Length */
+	bufsize = cop->len;
+	if (cop->len > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d >
%d\n",
+		 cop->len, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	init_completion(&result.completion);
+
+	/* Setting the request */
+	req = ablkcipher_request_alloc(ses_ptr->tfm_ablkcipher,
GFP_KERNEL);
+	if (!req) {
+		printk(KERN_INFO PFX "failed to allocate request\n");
+		return -EINVAL;
+	}
+
+	if (bufsize %
crypto_ablkcipher_blocksize(ses_ptr->tfm_ablkcipher)) {
+		printk(KERN_INFO PFX
+			"data size (%zu) isn't a multiple of block size
(%u)\n",
+			bufsize, crypto_ablkcipher_blocksize
+			(ses_ptr->tfm_ablkcipher));
+		ret = -EINVAL;
+		goto out_req;
+	}
+
+	order = get_order(bufsize);
+	data = (char *) __get_free_pages(GFP_KERNEL, order);
+
+	if (unlikely(!data)) {
+		ret = -ENOMEM;
+		goto out_req;
+	}
+
+	ivsize = crypto_ablkcipher_ivsize(ses_ptr->tfm_ablkcipher);
+
+	ivp = kmalloc(ivsize, GFP_KERNEL);
+	if (unlikely(!ivp)) {
+		free_pages((unsigned long)data, order);
+		ret = -ENOMEM;
+		goto out_req;
+	}
+
+	memset(ivp, 0, ivsize);
+	if (cop->iv && copy_from_user(ivp, cop->iv, ivsize)) {
+		printk(KERN_INFO PFX "Copy of src iv Failed from User "
+		"space for crypto\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete,
&result);
+
+	src = cop->src;
+	dst = cop->dst;
+
+	if (copy_from_user(data, src, bufsize)) {
+		printk(KERN_INFO PFX "Copy of src data Failed from User"
+		"space for crypto\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	nsg = sg_setup(data, bufsize, sg, sg_single);
+	if (!nsg) {
+		printk(KERN_INFO PFX "Scatter Allocation failed
err=%d\n",
+			nsg);
+		goto out;
+	}
+	ablkcipher_request_set_crypt(req, sg, sg, bufsize, ivp);
+
+	if (cop->op == COP_ENCRYPT)
+		ret = crypto_ablkcipher_encrypt(req);
+	else
+		ret = crypto_ablkcipher_decrypt(req);
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(
+			&result.completion);
+		if (!ret)
+			ret = result.err;
+		if (!ret) {
+			INIT_COMPLETION(result.completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk(KERN_INFO PFX "%s failed err=%d\n", "enc/dec",
-ret);
+		goto out;
+	}
+
+	CRYPTODEV_HEXDUMP(data, bufsize);
+	if (copy_to_user(dst, data, bufsize)) {
+		printk(KERN_INFO PFX "Copy of enc data Failed to User"
+		"space for crypto\n");
+		ret = -EFAULT;
+	}
+
+out:
+	free_pages((unsigned long)data, order);
+	kfree(ivp);
+
+out_req:
+	ablkcipher_request_free(req);
+
+	return ret;
+}
+
+
/***********************************************************************
******
+ * /dev/crypto function operation functions
+
************************************************************************
******
+ */
+static int cryptodev_clonefd(struct file *filp)
+{
+	mm_segment_t fs;
+	int fd;
+
+	fs = get_fs();
+	set_fs(get_ds());
+	for (fd = 0; fd < files_fdtable(current->files)->max_fds; fd++)
+		if (files_fdtable(current->files)->fd[fd] == filp)
+			break;
+	fd = __sys_dup(fd);
+	set_fs(fs);
+	return fd;
+}
+
+static int cryptodev_open(struct inode *inode, struct file *filp)
+{
+	struct fcrypt *fcr;
+
+	fcr = kmalloc(sizeof(*fcr), GFP_KERNEL);
+	if (!fcr)
+		return -ENOMEM;
+
+	memset(fcr, 0, sizeof(*fcr));
+	init_MUTEX(&fcr->sem);
+	INIT_LIST_HEAD(&fcr->list);
+	filp->private_data = fcr;
+
+	return 0;
+}
+
+static int cryptodev_release(struct inode *inode, struct file *filp)
+{
+	struct fcrypt *fcr = filp->private_data;
+
+	if (fcr) {
+		cryptodev_finish_all_sessions(fcr);
+		kfree(fcr);
+		filp->private_data = NULL;
+	}
+	return 0;
+}
+
+static int cryptodev_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	struct session_op sop;
+	struct crypt_op   cop;
+	struct fcrypt *fcr = filp->private_data;
+	unsigned int  ses;
+	int ret;
+	int fd, feat;
+
+	if (!fcr)
+		BUG();
+
+	switch (cmd) {
+	case CRIOGET:
+		fd = cryptodev_clonefd(filp);
+		put_user(fd, (int *) arg);
+		return IS_ERR_VALUE(fd) ? fd : 0;
+
+	case CIOCGSESSION:
+		if (copy_from_user(&sop, (void *) arg, sizeof(sop))) {
+			printk(KERN_INFO PFX "Copy of Session data
failed"
+				"at CIOCGSESSION from user space\n");
+			return -EFAULT;
+		}
+		ret = cryptodev_create_session(fcr, &sop);
+		if (ret)
+			return ret;
+		if (copy_to_user((void *)arg, &sop, sizeof(sop))) {
+			printk(KERN_INFO PFX "Copy of Session data
failed"
+				"at CIOCGSESSION to user space\n");
+			return -EFAULT;
+		}
+		return 0;
+
+	case CIOCFSESSION:
+		get_user(ses, (u32 *) arg);
+		return cryptodev_finish_session(fcr, ses);
+
+	case CIOCCRYPT:
+		if (copy_from_user(&cop, (void *) arg, sizeof(cop))) {
+			printk(KERN_INFO PFX "Copy of src data failed"
+				"at CIOCCRYPT from user space\n");
+			return -EFAULT;
+		}
+		ret = cryptodev_run(fcr, &cop);
+		if (copy_to_user((void *) arg, &cop, sizeof(cop))) {
+			printk(KERN_INFO PFX "Copy of enc/dec/hash data
failed"
+				"at CIOCCRYPT to user space\n");
+			return -EFAULT;
+		}
+		return ret;
+
+	case CIOCASYMFEAT:
+		/* No Asymmetric Algorithms Supported */
+		feat = 0;
+		if (copy_to_user((void *)arg, &feat, sizeof(feat))) {
+			printk(KERN_INFO PFX "Copy of asymm algorithm
data"
+				" failed at CIOCASYMFEAT to user
space\n");
+			return -EFAULT;
+		}
+		return 0;
+
+	default:
+		printk(KERN_ERR PFX "un-supported command 0x%08X\n",
cmd);
+		return -EINVAL;
+	}
+}
+
+struct file_operations cryptodev_fops = {
+	.owner   = THIS_MODULE,
+	.open    = cryptodev_open,
+	.release = cryptodev_release,
+	.ioctl   = cryptodev_ioctl,
+};
+
+struct miscdevice cryptodev = {
+	.minor = CRYPTODEV_MINOR,
+	.name  = "crypto",
+	.fops  = &cryptodev_fops,
+};
+
+static int cryptodev_register(void)
+{
+	int rc;
+
+	rc = misc_register(&cryptodev);
+	if (rc) {
+		printk(KERN_ERR PFX "registeration of /dev/crypto
failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void cryptodev_deregister(void)
+{
+	misc_deregister(&cryptodev);
+}
+
+/**********************************************************************
*********
+ * Module init/exit
+
************************************************************************
*******
+ */
+int __init init_cryptodev(void)
+{
+	int rc;
+
+	rc = cryptodev_register();
+	if (rc)
+		return rc;
+
+	printk(KERN_INFO PFX "CryptoAPI driver v%s loaded\n",
+		CRYPTODEV_UI_SUPPORT_DRIVER);
+
+	return 0;
+}
+
+void __exit exit_cryptodev(void)
+{
+	cryptodev_deregister();
+	printk(KERN_INFO PFX "CryptoAPI driver v%s unloaded\n",
+		CRYPTODEV_UI_SUPPORT_DRIVER);
+}
+
+module_init(init_cryptodev);
+module_exit(exit_cryptodev);
+
+MODULE_AUTHOR("Shasi Pulijala <spulijala@amcc.com>");
+MODULE_DESCRIPTION("CryptoDev driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/fcntl.c b/fs/fcntl.c
index e632da7..5afec53 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -137,6 +137,7 @@ static int dupfd(struct file *file, unsigned int
start, int cloexec)
 	return fd;
 }
 
+
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
 {
 	int err = -EBADF;
@@ -193,7 +194,7 @@ out_fput:
 	goto out;
 }
 
-asmlinkage long sys_dup(unsigned int fildes)
+asmlinkage long __sys_dup(unsigned int fildes)
 {
 	int ret = -EBADF;
 	struct file * file = fget(fildes);
@@ -202,6 +203,12 @@ asmlinkage long sys_dup(unsigned int fildes)
 		ret = dupfd(file, 0, 0);
 	return ret;
 }
+EXPORT_SYMBOL(__sys_dup);
+
+asmlinkage long sys_dup(unsigned int fildes)
+{
+	return __sys_dup(fildes);
+}
 
 #define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC |
O_DIRECT | O_NOATIME)
 
diff --git a/include/linux/cryptodev.h b/include/linux/cryptodev.h
new file mode 100644
index 0000000..46466d4
--- /dev/null
+++ b/include/linux/cryptodev.h
@@ -0,0 +1,119 @@
+/**********************************************************************
*********
+ * cryptodev.h
+ *
+ * Linux CryptoAPI user space interface module
+ *
+ * Copyright (c) 2008 Shasi Pulijala <spulijala@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * Detail Description:
+ * This file defines ioctl structures for the Linux CryptoAPI
interface. It
+ * provides user space applications accesss into the Linux CryptoAPI
+ * functionalities.
+ *
+
************************************************************************
*******
+ */
+#ifndef __CRYPTODEV_H__
+#define __CRYPTODEV_H__
+
+/* Crypto and Hash Algorithms */
+
+#define CRYPTO_ALGORITHM_MIN		1
+#define CRYPTO_DES_CBC			1
+#define CRYPTO_3DES_CBC		2
+#define CRYPTO_BLF_CBC			3
+#define CRYPTO_CAST_CBC		4
+#define CRYPTO_SKIPJACK_CBC		5
+#define CRYPTO_MD5_HMAC		6
+#define CRYPTO_SHA1_HMAC		7
+#define CRYPTO_RIPEMD160_HMAC	8
+#define CRYPTO_MD5_KPDK		9
+#define CRYPTO_SHA1_KPDK		10
+#define CRYPTO_RIJNDAEL128_CBC	11 /* 128 bit blocksize */
+#define CRYPTO_AES_CBC			11 /* 128 bit blocksize  */
+#define CRYPTO_ARC4			12
+#define CRYPTO_MD5			13
+#define CRYPTO_SHA1			14
+#define CRYPTO_NULL_HMAC		15
+#define CRYPTO_NULL_CBC		16
+#define CRYPTO_DEFLATE_COMP		17 /* Deflate compression
algorithm */
+#define CRYPTO_SHA2_256_HMAC		18
+#define CRYPTO_SHA2_384_HMAC		19
+#define CRYPTO_SHA2_512_HMAC		20
+#define CRYPTO_CAMELLIA_CBC		21
+#define CRYPTO_SHA2_256		22
+#define CRYPTO_SHA2_384		23
+#define CRYPTO_SHA2_512		24
+#define CRYPTO_RIPEMD160		25
+#define CRYPTO_AES_GCM			26
+#define CRYPTO_AES_CCM			27
+#define CRYPTO_ALGORITHM_MAX		28 /* Keep last */
+
+/**
+ * @struct session_op
+ * @brief ioctl parameter to create a session
+ *
+
************************************************************************
*******
+ */
+struct session_op {
+	u32	cipher;				/* e.g. CRYPTO_DES_CBC
*/
+	u32	mac;				/* e.g. CRYPTO_MD5_HMAC
*/
+	u32	keylen;				/* cipher key */
+	char	*key;
+	int	mackeylen;			/* mac key length*/
+	char	*mackey;			/* mackey(hmac)/authsize
+						(ccm, gcm) */
+
+	/* Return values */
+	u32 	ses;				/* session ID */
+};
+
+#define CRYPTO_MAX_DATA_LEN		64*1024 - 1
+/**
+ * @struct crypt_op
+ * @brief ioctl parameter to request a crypt/decrypt operation against
a session
+ *
+
************************************************************************
*******
+ */
+struct crypt_op {
+	u32	ses;
+	u16	op;				/* i.e. COP_ENCRYPT */
+#define COP_NONE	0
+#define COP_ENCRYPT	1
+#define COP_DECRYPT	2
+	u16	flags;
+#define	COP_F_BATCH	0x0008			/* Batch op if
possible */
+	u_int		len;
+	caddr_t		src, dst;		/* become sg inside
kernel */
+	caddr_t		mac;			/* must be big enough
for
+						chosen MAC */
+	caddr_t		iv;
+};
+
+/* clone original filedescriptor */
+#define CRIOGET         _IOWR('c', 100, unsigned int)
+
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
+
+/* finish crypto session */
+#define CIOCFSESSION    _IOW('c', 102, unsigned int)
+
+/* request encryption/decryptions of a given buffer */
+#define CIOCCRYPT       _IOWR('c', 103, struct crypt_op)
+
+/* ioctl()s for asym-crypto. Not yet supported. */
+#define CIOCKEY         _IOWR('c', 104, void *)
+#define CIOCASYMFEAT    _IOR('c', 105, unsigned int)
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..e9dc39e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -962,6 +962,7 @@ extern void __kill_fasync(struct fasync_struct *,
int, int);
 
 extern int __f_setown(struct file *filp, struct pid *, enum pid_type,
int force);
 extern int f_setown(struct file *filp, unsigned long arg, int force);
+extern long __sys_dup(unsigned int fildes);
 extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
-- 
1.5.4.4
