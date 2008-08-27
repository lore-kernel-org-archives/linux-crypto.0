From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: [PATCH 1/1 v5] Add CryptoAPI User Interface Patch v5
Date: Wed, 27 Aug 2008 14:23:31 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B05FDE273@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>, "Loc Ho" <lho@amcc.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:22319 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYH0VXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Aug 2008 17:23:33 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 
Hi Evgeniy,
 This is Linux CryptoAPI user space interface support patch v5. This version adds:
-Preventing race conditions in session creation.
-Crypto operations are now issued from user space using writev(sync) and AIO write(async) instead of ioctls.

From: Shasi Pulijala <spulijala@amcc.com>


Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
---
 crypto/Kconfig            |    7 +
 crypto/Makefile           |    1 +
 crypto/cryptodev.c        | 1834 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cryptodev.h |   79 ++
 4 files changed, 1921 insertions(+), 0 deletions(-)
 create mode 100644 crypto/cryptodev.c
 create mode 100644 include/linux/cryptodev.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69f1be6..0cd97c2 100644
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
+	  kernel crypto algorithms(Sync and Async Support).
+
 config CRYPTO_HMAC
 	tristate "HMAC support"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 7cf3625..4ed5634 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -21,6 +21,7 @@ crypto_hash-objs := hash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_CRYPTODEV) += cryptodev.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
diff --git a/crypto/cryptodev.c b/crypto/cryptodev.c
new file mode 100644
index 0000000..52c29bb
--- /dev/null
+++ b/crypto/cryptodev.c
@@ -0,0 +1,1834 @@
+/**************************************************************************
+ * Linux CryptoAPI user space interface module
+ *
+ * Copyright (c) 2008 Applied Micro Circuits Corporation.
+ * All rights reserved. Shasi Pulijala <spulijala@amcc.com>
+ *	 		Loc Ho <lho@amcc.com>
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
+ * @file cryptodev.c
+ *
+ * This file defines ioctl structures for the Linux CryptoAPI interface. It
+ * provides user space applications accesss into the Linux CryptoAPI
+ * functionalities.
+ *
+ **************************************************************************
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pagemap.h>
+#include <linux/miscdevice.h>
+#include <linux/ioctl.h>
+#include <linux/scatterlist.h>
+#include <linux/cryptodev.h>
+#include <linux/aio.h>
+#include <linux/mutex.h>
+#include <asm/atomic.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+
+/* /dev/crypto is a char block device with major 10 and minor below */
+#define	CRYPTODEV_MINOR		70
+
+/* Debug Mode Setting */
+#define CRYPTODEV_DEBUG
+
+/* Version Number */
+#define	CRYPTODEV_VER		"0.1"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "0: normal, 1: verbose, 2: debug");
+
+static int sg_single;
+module_param(sg_single, int, 0644);
+MODULE_PARM_DESC(sg_single, "0: scatter user buffers to page size, "
+			    "1: single buffer for user buffer");
+
+static int page_pin_min_size;
+module_param(page_pin_min_size, int, 0644);
+MODULE_PARM_DESC(page_pin_min_size,
+		"min value to decide copy to/from user or pin pages");
+
+static int page_pin_max_size;
+module_param(page_pin_max_size, int, 0644);
+MODULE_PARM_DESC(page_pin_max_size,
+		"max value to decide copy to/from user or pin pages");
+
+#ifdef CRYPTODEV_STATS
+static int enable_stats;
+module_param(enable_stats, int, 0644);
+MODULE_PARM_DESC(enable_stats, "collect statictics about cryptodev usage");
+#endif
+
+#define PFX "cryptodev: "
+
+#ifndef CRYPTODEV_DEBUG
+#define CD_HEXDUMP(b, l) \
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET, 	\
+				16, 1, (b), (l), false);
+#define CDPRINTK(level, severity, format, a...)			\
+	do { 								\
+		if (level <= debug)					\
+			printk(severity PFX "%s[%u]: " format,		\
+			       current->comm, current->pid, ##a); 	\
+	} while (0)
+#else
+#define CD_HEXDUMP(b, l)
+#define CDPRINTK(level, severity, format, a...)
+#endif
+
+#define CRYPTO_MODE_NOTSET	0
+#define CRYPTO_MODE_ACIPHER	1
+#define CRYPTO_MODE_AHASH	2
+#define CRYPTO_MODE_AEAD	3
+
+struct crypto_item_op {
+	struct crypt_op *udata;
+	char *iv;
+	char *assoc;
+	char __user *src_data;
+	char __user *dst_data;
+	u16 src_size;
+};
+
+#define iv_len		udata->iv_size
+#define assoc_len	udata->assoc_size
+#define eop		udata->op
+
+#define tfm_ablkcipher	crt_tfm.acipher_tfm
+#define tfm_aead	crt_tfm.aead_tfm
+#define tfm_ahash	crt_tfm.ahash_tfm
+
+struct csession {
+	atomic_t	refcnt;
+	int		mode;			/* See CRYPTO_MODE_XXX */
+	union {
+		struct crypto_ablkcipher *acipher_tfm;
+		struct crypto_ahash 	 *ahash_tfm;
+		struct crypto_aead 	 *aead_tfm;
+	} crt_tfm;
+	int (*destroy)(struct csession *ses_ptr);
+	int (*runop)(struct csession *ses_ptr,
+		     struct crypto_item_op *cop,
+		     struct kiocb *iocb);
+	int (*getivsize)(struct csession *ses_ptr);
+	int (*setkey)(struct csession *ses_ptr, char *key, int key_size);
+
+};
+
+struct cryptodev_ctx {
+	struct csession	 *session;
+	struct mutex 	lock;
+};
+
+#define crypto_completion	async.syncio.completion
+#define session_ptr		async.aio.ses_ptr
+#define iocbvec			async.aio.iocb
+#define nopin_data		async.aio.data
+#define aio_enc			async.aio.enc
+#define aio_dst_data		async.aio.dst_data
+#define aio_size_data		async.aio.data_size
+struct async_result {
+	struct list_head next;	/* Pending AIO requests ready for read */
+	int nr_spages;
+	int nr_dpages;
+	struct page **spages;
+	struct page **dpages;
+
+	char *null_buf;
+	void *udata;
+
+	union {
+		struct {
+			struct csession *ses_ptr;
+			struct kiocb *iocb;
+			char *data;
+			char __user *dst_data;
+			int enc;
+			size_t data_size;
+		} aio;
+		struct {
+			struct completion completion;
+		} syncio;
+	} async;
+	int err;
+};
+
+static int cryptodev_run_acipher(struct csession *ses_ptr,
+				struct crypto_item_op *cop,
+				struct kiocb *iocb);
+static int cryptodev_run_ahash(struct csession *ses_ptr,
+				struct crypto_item_op *cop,
+				struct kiocb *iocb);
+static int cryptodev_run_aead(struct csession *ses_ptr,
+				struct crypto_item_op *cop,
+				struct kiocb *iocb);
+static void cryptodev_async_aio_complete(struct crypto_async_request *req,
+					 int err);
+
+/**
+ * Synchronous handling Routine
+ *
+ */
+static void cryptodev_async_complete(struct crypto_async_request *req,
+					int err)
+{
+	struct async_result *res;
+
+	CDPRINTK(2, KERN_INFO, "Synchrnous call-back Called\n");
+
+	res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&(res->crypto_completion));
+}
+
+/**
+ * Destroy Alg Sessions
+ *
+ */
+int cryptodev_destroy_ablkcipher_tfm(struct csession *ses_ptr)
+{
+	CDPRINTK(1, KERN_INFO, "ABLKCIPHER sid %p deleting\n", ses_ptr);
+	crypto_free_ablkcipher(ses_ptr->tfm_ablkcipher);
+	return 0;
+}
+
+int cryptodev_destroy_ahash_tfm(struct csession *ses_ptr)
+{
+	CDPRINTK(1, KERN_INFO, "AHASH sid %p deleting\n", ses_ptr);
+	crypto_free_ahash(ses_ptr->tfm_ahash);
+	return 0;
+}
+
+int cryptodev_destroy_aead_tfm(struct csession *ses_ptr)
+{
+	CDPRINTK(1, KERN_INFO, "AEAD sid %p deleting\n", ses_ptr);
+	crypto_free_aead(ses_ptr->tfm_aead);
+	return 0;
+}
+
+/**
+ * ivsize return functions
+ *
+ */
+int cryptodev_ablkcipher_getivsize(struct csession *ses_ptr)
+{
+	return crypto_ablkcipher_ivsize(ses_ptr->tfm_ablkcipher);
+}
+
+int cryptodev_aead_getivsize(struct csession *ses_ptr)
+{
+	return crypto_aead_ivsize(ses_ptr->tfm_aead);
+}
+
+int cryptodev_ahash_getivsize(struct csession *ses_ptr)
+{
+	return 0;
+}
+
+/**
+ * setkey functions
+ *
+ */
+int cryptodev_ablkcipher_setkey(struct csession *ses_ptr, char *key,
+				int key_size)
+{
+	int ret;
+
+	ret = crypto_ablkcipher_setkey(ses_ptr->tfm_ablkcipher,
+					key, key_size);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key for %zu: flags=0x%X\n", key_size*8,
+			crypto_ablkcipher_get_flags(ses_ptr->tfm_ablkcipher));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> for "
+			"details)\n");
+
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int cryptodev_aead_setkey(struct csession *ses_ptr, char *key, int key_size)
+{
+	int ret;
+
+	ret = crypto_aead_setkey(ses_ptr->tfm_aead, key, key_size);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key field for %zu: flags=0x%X\n",
+			key_size * 8,
+			crypto_aead_get_flags(ses_ptr->tfm_aead));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> "
+			"for details)\n");
+
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int cryptodev_ahash_setkey(struct csession *ses_ptr, char *key, int key_size)
+{
+	int ret = 0;
+
+	if (!key_size)
+		return ret;
+	ret = crypto_ahash_setkey(ses_ptr->tfm_ahash, key, key_size);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key field for %zu: flags=0x%X\n"
+			"(see CRYPTO_TFM_RES_* in "
+			"<linux/crypto.h> for details)\n",
+			key_size * 8,
+			crypto_ahash_get_flags(ses_ptr->tfm_ahash));
+
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/**
+ * Routine for creating a session for AEAD type algorithm
+ *
+ */
+static int create_session_aead(struct crypto_aead *tfm, char *alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr,
+				char *keyp)
+{
+	struct csession	*ses_new;
+	int ret = 0;
+
+	crypto_aead_clear_flags(tfm, ~0);
+
+	ret = crypto_aead_setkey(tfm, keyp, sop->key_size);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key field for %s-%zu: flags=0x%X\n",
+			alg_name, sop->key_size * 8,
+			crypto_aead_get_flags(tfm));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> "
+			"for details)\n");
+
+		ret = -EINVAL;
+		goto free_aead;
+	}
+
+	ret = crypto_aead_setauthsize(tfm, sop->icv_size);
+	if (ret) {
+		printk(KERN_ERR "failed to set authsize = %u\n", sop->icv_size);
+		ret = -EINVAL;
+		goto free_aead;
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		ret =  -ENOMEM;
+		goto free_aead;
+	}
+	ses_new->tfm_aead = tfm;
+	ses_new->mode     = CRYPTO_MODE_AEAD;
+	ses_new->destroy  = cryptodev_destroy_aead_tfm;
+	ses_new->runop    = cryptodev_run_aead;
+	ses_new->getivsize = cryptodev_aead_getivsize;
+	ses_new->setkey    = cryptodev_aead_setkey;
+
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+	CDPRINTK(1, KERN_INFO, "AEAD sid %p alg %s created\n",
+		 ses_new, alg_name);
+	goto ret;
+
+free_aead:
+	crypto_free_aead(tfm);
+ret:
+	return ret;
+}
+
+/**
+ * Routine for creating a session for HASH type algorithm
+ *
+ */
+static int create_session_ahash(struct crypto_ahash *tfm, char *alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr, char *keyp)
+{
+	struct csession	*ses_new;
+	int ret = 0;
+
+
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	/* Copy the key(hmac) from user and set to TFM. */
+	if (sop->hmackey_size) {
+		ret = crypto_ahash_setkey(tfm, keyp, sop->hmackey_size);
+		if (ret) {
+			printk(KERN_ERR PFX
+				"failed to set key field for %s-%zu: "
+				"flags=0x%X\n"
+				"(see CRYPTO_TFM_RES_* in "
+				"<linux/crypto.h> for details)\n",
+				alg_name, sop->hmackey_size * 8,
+				crypto_ahash_get_flags(tfm));
+
+			ret = -EINVAL;
+			goto free_ahash;
+		}
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		ret = -ENOMEM;
+		goto free_ahash;
+	}
+	ses_new->tfm_ahash = tfm;
+	ses_new->mode      = CRYPTO_MODE_AHASH;
+	ses_new->destroy   = cryptodev_destroy_ahash_tfm;
+	ses_new->runop     = cryptodev_run_ahash;
+	ses_new->getivsize = cryptodev_ahash_getivsize;
+	ses_new->setkey    = cryptodev_ahash_setkey;
+
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+
+	CDPRINTK(1, KERN_INFO, "AHASH sid %p alg %s created\n",
+		ses_new, alg_name);
+	goto ret;
+
+free_ahash:
+	crypto_free_ahash(tfm);
+ret:
+	return ret;
+}
+
+/**
+ * Routine for creating a session for CRYPTO block type algorithm
+ *
+ */
+static int create_session_ablkcipher(struct crypto_ablkcipher *tfm,
+				char *alg_name, struct session_op *sop,
+				struct csession **ses_ptr, char *keyp)
+{
+	struct csession	*ses_new;
+	int ret = 0;
+
+	crypto_ablkcipher_clear_flags(tfm, ~0);
+
+	/* Copy the key from user and set to TFM. */
+	ret = crypto_ablkcipher_setkey(tfm, keyp, sop->key_size);
+
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key for %s-%zu: flags=0x%X\n",
+			alg_name, sop->key_size*8,
+			crypto_ablkcipher_get_flags(tfm));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> for "
+			"details)\n");
+
+		ret = -EINVAL;
+		goto free_ablkcipher;
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		ret = -ENOMEM;
+		goto free_ablkcipher;
+	}
+
+	ses_new->tfm_ablkcipher = tfm;
+	ses_new->mode 		= CRYPTO_MODE_ACIPHER;
+	ses_new->destroy 	= cryptodev_destroy_ablkcipher_tfm;
+	ses_new->runop    	= cryptodev_run_acipher;
+	ses_new->getivsize 	= cryptodev_ablkcipher_getivsize;
+	ses_new->setkey 	= cryptodev_ablkcipher_setkey;
+
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+	CDPRINTK(1, KERN_INFO, "ABLCKCIPHER sid %p alg %s created\n",
+		 ses_new, alg_name);
+	goto ret;
+
+free_ablkcipher:
+	crypto_free_ablkcipher(tfm);
+ret:
+	return ret;
+}
+
+/**
+ * Prepare session for future use
+ *
+ */
+static int cryptodev_create_session(struct csession **ses_ptr,
+				    struct session_op *sop,
+				    void *session_udata)
+{
+	char *alg_name;
+	char *key;
+	char *hmac_key;
+	struct crypto_ablkcipher *ablkcipher_tfm;
+	struct crypto_aead *aead_tfm;
+	struct crypto_ahash *ahash_tfm;
+
+	alg_name = (char *) session_udata;
+	key 	 = alg_name + sop->algo_size;
+	hmac_key = key + sop->key_size;
+
+	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
+	if (!IS_ERR(ahash_tfm))
+		return create_session_ahash(ahash_tfm, alg_name, sop,
+					    ses_ptr, hmac_key);
+
+	ablkcipher_tfm = crypto_alloc_ablkcipher(alg_name, 0, 0);
+	if (!IS_ERR(ablkcipher_tfm))
+		return create_session_ablkcipher(ablkcipher_tfm,
+			alg_name, sop, ses_ptr,
+			key);
+	aead_tfm = crypto_alloc_aead(alg_name, 0, 0);
+	if (!IS_ERR(aead_tfm))
+		return create_session_aead(aead_tfm, alg_name, sop,
+					   ses_ptr, key);
+
+	printk(KERN_ERR PFX "un-supported algorithm %s\n", alg_name);
+	return -EINVAL;
+}
+
+/**
+ * Helper Functions for Page Creation and deletion.
+ *
+ */
+static int cryptodev_num_pages(unsigned long data, size_t bufsize)
+{
+	unsigned long first;
+	unsigned long last;
+	int num_pages;
+
+	if (!bufsize)
+		return 1;
+	first = (data & PAGE_MASK) >> PAGE_SHIFT;
+	last = ((data + bufsize - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	num_pages = last - first + 1;
+	return num_pages;
+}
+
+static void cryptodev_release_pages(struct page **pages, int nr_pages)
+{
+	int x;
+	struct page *mpage;
+
+	for (x = 0; x < nr_pages; x++) {
+		mpage = pages[x];
+		SetPageDirty(mpage);
+		page_cache_release(mpage);
+	}
+}
+
+static int cryptodev_set_user_pages(char __user *src, struct scatterlist *sg,
+					struct page **pages, size_t bufsize,
+					int *nr_pages, char **null_buf)
+{
+	unsigned long offset;
+	struct page *page = NULL;
+	int x;
+	int rop;
+	int err;
+
+	if (!src) {
+		*nr_pages = 0;
+		CDPRINTK(1, KERN_INFO, "Case of null buffer\n");
+		*null_buf = kzalloc(bufsize, GFP_KERNEL);
+		if (!*null_buf)
+			return -ENOMEM;
+		sg_init_one(&sg[0], *null_buf, bufsize);
+		return 0;
+	}
+
+	offset = (unsigned long) src & ~PAGE_MASK;
+	if (!pages) {
+		printk(KERN_ERR PFX "pages memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	down_read(&current->mm->mmap_sem);
+	err = get_user_pages(current, current->mm,
+			((unsigned long) src) & PAGE_MASK,
+			*nr_pages, 1, 0, /* read, force */ pages, NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (err != *nr_pages) {
+		printk(KERN_ERR PFX "pages requested[%d] !="
+			" pages granted[%d]\n", *nr_pages, err);
+		return err < 0 ? err : -EINVAL;
+
+	}
+
+	if (sg_single) {
+		page = pages[0];
+		CDPRINTK(2, KERN_INFO, "single buffer implementation\n");
+		sg_set_page(&sg[0], page, bufsize, offset);
+		return 0;
+	}
+
+	sg_init_table(sg, *nr_pages);
+	for (x = 0; x < *nr_pages; x++) {
+		page = pages[x] ;
+		if (!page || IS_ERR(page)) {
+			printk(KERN_ERR PFX "missing page in "
+				"DumpUserPages %d\n", x);
+			return -EFAULT;
+		}
+		sg_set_page(&sg[x], page, bufsize, offset);
+		rop = PAGE_SIZE - sg[x].offset;
+		if (bufsize > rop) {
+			sg[x].length = rop;
+			bufsize = bufsize - rop;
+		}
+		offset = 0;
+	}
+
+	return 0;
+}
+
+static void cryptodev_sg_setbuf(unsigned char *data, size_t bufsize,
+			       struct scatterlist *sg, int sg_num)
+{
+	int remainder_of_page;
+	int i = 0;
+
+	sg_init_table(sg, sg_num);
+	while (bufsize > 0 && i < sg_num) {
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
+}
+
+/**
+ * Helper Functions for the AEAD mode
+ *
+ */
+static void *aead_alloc_tmp(struct crypto_aead *aead, int sg_size,
+				int ssg_num, int nopin, size_t bufsize)
+{
+	unsigned int len;
+
+	len = sizeof(struct async_result) +
+		(crypto_aead_alignmask(aead) &
+				~(crypto_tfm_ctx_alignment() - 1));
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+
+	len += sizeof(struct aead_request) + crypto_aead_reqsize(aead);
+
+	if (nopin) {
+		len = ALIGN(len, __alignof__(struct scatterlist));
+		len += sizeof(struct scatterlist) * ssg_num;
+		len += bufsize;
+
+		return kzalloc(len, GFP_KERNEL);
+	}
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += sizeof(struct scatterlist) * (sg_size);
+
+	len = ALIGN(len, __alignof__(struct page *));
+	len += sizeof(struct page *) * sg_size;
+
+	return kzalloc(len, GFP_KERNEL);
+}
+
+static inline struct aead_request *aead_result_req(
+			struct crypto_aead *aead,
+			struct async_result *result)
+{
+	struct aead_request *req;
+
+	req = (struct aead_request *) PTR_ALIGN(
+				(unsigned long) result +
+					sizeof(struct async_result),
+				crypto_tfm_ctx_alignment());
+	aead_request_set_tfm(req, aead);
+	return req;
+}
+
+static inline struct scatterlist *aead_req_ssg(struct crypto_aead *aead,
+					     struct aead_request *req)
+{
+	return (struct scatterlist *) ALIGN((unsigned long) (req + 1) +
+				crypto_aead_reqsize(aead),
+				__alignof__(struct scatterlist));
+}
+
+static inline char *aead_ssg_data(struct scatterlist *ssg, int ssg_num)
+{
+	return (char *) ((unsigned long) ssg + sizeof(struct scatterlist)
+				* ssg_num);
+}
+
+static inline struct page **aead_ssg_spages(struct scatterlist *sg,
+					int sg_size)
+{
+	return (struct page **) ALIGN((unsigned long) sg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static inline struct scatterlist *aead_spages_dsg(struct page **pages,
+						int npages)
+{
+	return (struct scatterlist *) ALIGN((unsigned long) pages +
+				sizeof(struct page *) * npages,
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **aead_dsg_dpages(struct scatterlist *dsg,
+						int sg_size)
+{
+	return (struct page **) ALIGN((unsigned long) dsg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static inline int cryptodev_is_pin_pages(int size)
+{
+	int ret;
+	ret = (size <= page_pin_min_size || size >= page_pin_max_size);
+
+	return ret;
+}
+
+/**
+ * This is the actual aead function that implements
+ * the Combined mode
+ *
+ */
+static int cryptodev_run_aead(struct csession *ses_ptr,
+				struct crypto_item_op *cop,
+				struct kiocb *iocb)
+{
+	void *tmp;
+	char __user *src;
+	char __user *dst;
+	char *data = NULL;
+	struct scatterlist *ssg;
+	struct scatterlist *dsg;
+	struct aead_request *req;
+	struct async_result *result = NULL;
+	size_t bufsize, authsize;
+	int nr_spages, nr_dpages = 0;
+	int ssg_num;
+	int enc, ret, dst_flag, nopin; /*Flags*/
+	struct scatterlist adata;
+
+	/* Setting the Input params */
+	bufsize = cop->src_size;
+	src = cop->src_data;
+	dst = cop->dst_data;
+	dst_flag = src != dst;
+	enc = cop->eop == COP_ENCRYPT ? 1 : 0;
+	authsize = crypto_aead_authsize(ses_ptr->tfm_aead);
+
+	ssg_num = cryptodev_num_pages((unsigned long) src,
+				enc ? bufsize + authsize : bufsize);
+
+	if (cop->eop && cop->eop != COP_ENCRYPT && cop->eop != COP_DECRYPT) {
+		printk(KERN_ERR PFX "sid %p invalid operation op=%u\n",
+			ses_ptr, cop->eop);
+		return -EINVAL;
+	}
+
+	if (bufsize > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d > %d\n",
+		       bufsize, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	/* Flag set No Pinning pages, Size too large or too small*/
+	nopin = cryptodev_is_pin_pages(bufsize) ? 1 : 0;
+
+	if (dst_flag) {
+		if (nopin) {
+			nr_spages  = nr_dpages = 0;
+		} else {
+			nr_spages = cryptodev_num_pages((unsigned long) src,
+						bufsize);
+			nr_dpages = cryptodev_num_pages((unsigned long) dst,
+						enc ? bufsize + authsize :
+						      bufsize - authsize);
+		}
+	} else {
+		if (nopin)
+			nr_spages = 0;
+		else
+			nr_spages = cryptodev_num_pages((unsigned long) src,
+						enc ? bufsize + authsize :
+						      bufsize);
+	}
+
+	tmp = aead_alloc_tmp(ses_ptr->tfm_aead,
+			dst_flag ? nr_spages + nr_dpages : nr_spages,
+			ssg_num, nopin, bufsize);
+	if (!tmp)
+		return -ENOMEM;
+
+	result = (struct async_result *) tmp;
+	req = aead_result_req(ses_ptr->tfm_aead, result);
+	ssg = aead_req_ssg(ses_ptr->tfm_aead, req);
+
+	if (nopin) {
+		data = aead_ssg_data(ssg, ssg_num);
+		if (src && copy_from_user(data, src, bufsize)) {
+			printk(KERN_ERR PFX
+				"failed to copy aead "
+				"cop data from user space\n");
+			kfree(tmp);
+			return -EINVAL;
+		}
+		cryptodev_sg_setbuf(data, enc ? bufsize + authsize : bufsize,
+				ssg, ssg_num);
+		dsg = ssg;
+	} else {
+		result->spages = aead_ssg_spages(ssg, nr_spages);
+
+		if (dst_flag) {
+			dsg    = aead_spages_dsg(result->spages, nr_spages);
+			result->dpages = aead_dsg_dpages(dsg, nr_dpages);
+			ret    = cryptodev_set_user_pages(src, ssg,
+						result->spages, bufsize,
+						&nr_spages,
+						&result->null_buf);
+
+			if (ret)
+				goto out_tmp;
+			ret = cryptodev_set_user_pages(dst, dsg,
+						result->dpages,
+						enc ? bufsize + authsize :
+						      bufsize - authsize,
+						&nr_dpages,
+						&result->null_buf);
+			if (ret)
+				goto out_spages;
+		} else {
+			dsg 	       = ssg;
+			result->dpages = result->spages;
+			ret = cryptodev_set_user_pages(src, ssg,
+						result->spages,
+						enc ? bufsize + authsize :
+						      bufsize,
+						&nr_spages,
+						&result->null_buf);
+			if (ret)
+				goto out_tmp;
+		}
+	}
+
+	if (iocb) {
+		result->nr_spages   = nr_spages;
+		result->nr_dpages   = nr_dpages;
+		result->iocbvec     = iocb;
+		result->nopin_data  = data;
+		result->session_ptr = ses_ptr;
+		result->udata   = (void *)cop->udata;
+		result->aio_enc = cop->eop;
+		result->aio_dst_data = dst;
+		result->aio_size_data = enc ? bufsize + authsize :
+					bufsize - authsize;
+		aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  cryptodev_async_aio_complete,
+					  result);
+	} else {
+		init_completion(&(result->crypto_completion));
+		aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  cryptodev_async_complete,
+					  result);
+	}
+
+	/* Additional Associated data */
+	sg_init_one(&adata, cop->assoc, cop->assoc_len);
+
+	aead_request_set_crypt(req, ssg, dsg, bufsize, cop->iv);
+	aead_request_set_assoc(req, &adata, cop->assoc_len);
+
+	atomic_inc(&ses_ptr->refcnt);
+
+	if (cop->eop == COP_ENCRYPT)
+		ret = crypto_aead_encrypt(req);
+	else
+		ret = crypto_aead_decrypt(req);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		if (iocb) {
+			CDPRINTK(2, KERN_INFO,
+				"Async Call AEAD:Returning Now\n");
+			return -EIOCBQUEUED;
+		}
+		ret = wait_for_completion_interruptible(
+					&result->crypto_completion);
+		if (!ret)
+			ret = result->err;
+		if (!ret) {
+			INIT_COMPLETION(result->crypto_completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
+			ses_ptr, -ret);
+		break;
+	}
+
+	if (nopin && !ret) {
+		if (copy_to_user(dst, data, enc ? bufsize + authsize :
+						bufsize - authsize))
+			printk(KERN_ERR PFX
+				"failed to copy encrypted data "
+				"to user space\n");
+		CD_HEXDUMP(data, enc ? bufsize + authsize :
+					bufsize - authsize);
+	}
+
+	/* Check if last reference */
+	if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+		if (ses_ptr->destroy)
+			ses_ptr->destroy(ses_ptr);
+		kfree(ses_ptr);
+	}
+
+	if (dst_flag)
+		cryptodev_release_pages(result->dpages, nr_dpages);
+out_spages:
+	cryptodev_release_pages(result->spages, nr_spages);
+
+out_tmp:
+	if (result->null_buf)
+		kfree(result->null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**
+ * Helper Functions for the Hash mode
+ *
+ */
+static void *ahash_alloc_tmp(struct crypto_ahash *ahash, int sg_size,
+					size_t bufsize, int nopin,
+					int sg_num)
+{
+	unsigned int len;
+
+	len = sizeof(struct async_result);
+	len += sizeof(char) * 64;
+
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += sizeof(struct ahash_request) + crypto_ahash_reqsize(ahash);
+
+	if (nopin) {
+		len = ALIGN(len, __alignof__(struct scatterlist));
+		len += sizeof(struct scatterlist) * sg_num;
+		len += bufsize;
+
+		return kzalloc(len, GFP_KERNEL);
+	}
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += sizeof(struct scatterlist) * sg_size;
+
+	len = ALIGN(len, __alignof__(struct page *));
+	len += sizeof(struct page *) * sg_size;
+
+	return kzalloc(len, GFP_KERNEL);
+}
+
+static inline struct ahash_request *ahash_digest_req(
+				struct crypto_ahash *ahash,
+				char *digest)
+{
+	struct ahash_request *req;
+
+	req = (struct ahash_request *) PTR_ALIGN((digest + sizeof(char) * 64),
+				crypto_tfm_ctx_alignment());
+	ahash_request_set_tfm(req, ahash);
+	return req;
+
+}
+
+static inline struct scatterlist *ahash_req_sg(struct crypto_ahash *ahash,
+					     struct ahash_request *req)
+{
+	return (struct scatterlist *) ALIGN((unsigned long)(req + 1) +
+				crypto_ahash_reqsize(ahash),
+				__alignof__(struct scatterlist));
+}
+
+static inline char *ahash_ssg_data(struct scatterlist *ssg, int ssg_num)
+{
+	return (char *) ((unsigned long) ssg + sizeof(struct scatterlist)
+				* ssg_num);
+}
+
+static inline struct page **ahash_sg_pages(struct scatterlist *sg,
+						int sg_size)
+{
+	return (struct page **) ALIGN((unsigned long)sg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+/**
+ * This is the actual hash function that creates the
+ * authenticated data
+ *
+ */
+static int cryptodev_run_ahash(struct csession *ses_ptr,
+			       struct crypto_item_op *cop,
+			       struct kiocb *iocb)
+{
+	char __user *src;
+	char __user *mac;
+	struct scatterlist *ssg;
+	struct ahash_request *req;
+	struct async_result *result = NULL;
+	size_t authsize;
+	size_t bufsize;
+	int ret;
+	char *digest;
+	char *data = NULL;
+	void *tmp;
+	int nr_spages;
+	int nopin;
+	int ssg_num;
+
+	bufsize = cop->src_size;
+	src = cop->src_data;
+	mac = cop->dst_data;
+	ssg_num = cryptodev_num_pages((unsigned long) src, bufsize);
+
+	/* Checking the Input Length */
+	if (bufsize > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d > %d\n",
+		       bufsize, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	/* Flag set No Pinning pages, Size too large or too small*/
+	nopin = cryptodev_is_pin_pages(bufsize) ? 1 : 0;
+
+	nr_spages = nopin ? 0 :
+			    cryptodev_num_pages((unsigned long) src, bufsize);
+	authsize = crypto_ahash_digestsize(ses_ptr->tfm_ahash);
+
+	tmp = ahash_alloc_tmp(ses_ptr->tfm_ahash, nr_spages,
+			      bufsize, nopin, ssg_num);
+	if (!tmp)
+		return -ENOMEM;
+
+	/* Setting the request, Digest, and sg */
+	result = (struct async_result *) tmp;
+	digest = (char *) ((unsigned long) result +
+				sizeof(struct async_result));
+	req = ahash_digest_req(ses_ptr->tfm_ahash, digest);
+	ssg = ahash_req_sg(ses_ptr->tfm_ahash, req);
+	if (nopin) {
+		data = ahash_ssg_data(ssg, ssg_num);
+		if (src && copy_from_user(data, src, bufsize)) {
+			printk(KERN_ERR PFX
+				"failed to copy hash data from user space\n");
+			kfree(tmp);
+			return -EINVAL;
+		}
+		cryptodev_sg_setbuf(data, bufsize, ssg, ssg_num);
+	} else {
+		result->spages = ahash_sg_pages(ssg, nr_spages);
+
+		ret = cryptodev_set_user_pages(src, ssg, result->spages,
+					bufsize, &nr_spages,
+					&result->null_buf);
+		if (ret)
+			goto out_tmp;
+	}
+
+	if (iocb) {
+		result->iocbvec     = iocb;
+		result->nr_spages   = nr_spages;
+		result->session_ptr = ses_ptr;
+		result->aio_dst_data	= mac;
+		result->udata   = (void *)cop->udata;
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   cryptodev_async_aio_complete,
+					   result);
+	} else {
+		init_completion(&(result->crypto_completion));
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete, result);
+	}
+
+	ahash_request_set_crypt(req, ssg, digest, bufsize);
+
+	atomic_inc(&ses_ptr->refcnt);
+
+	ret = crypto_ahash_digest(req);
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		if (iocb) {
+			CDPRINTK(2, KERN_INFO,
+				"Async Call AHASH:Returning Now\n");
+			return -EIOCBRETRY;
+		}
+		ret = wait_for_completion_interruptible(
+					&result->crypto_completion);
+		if (!ret)
+			ret = result->err;
+		if (!ret) {
+			INIT_COMPLETION(result->crypto_completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk(KERN_ERR PFX "sid %p digest failed error %d\n",
+		       ses_ptr, -ret);
+		break;
+
+	}
+
+	if (!ret) {
+		CD_HEXDUMP(digest, authsize);
+		if (copy_to_user(mac, digest, authsize)) {
+			printk(KERN_ERR PFX "sid %p failed to copy mac data to"
+				"user space for hash\n", ses_ptr);
+			ret = -EFAULT;
+		}
+	}
+
+	/* Check if last reference */
+	if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+		if (ses_ptr->destroy)
+			ses_ptr->destroy(ses_ptr);
+		kfree(ses_ptr);
+	}
+
+	cryptodev_release_pages(result->spages, nr_spages);
+out_tmp:
+	if (result->null_buf)
+		kfree(result->null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**
+ * Helper Functions for the Cipher mode
+ *
+ */
+static void *ablkcipher_alloc_tmp(struct crypto_ablkcipher *ablkcipher,
+					int sg_size, int nopin,
+					size_t bufsize, int ssg_num)
+{
+	unsigned int len;
+
+	len = sizeof(struct async_result) +
+		(crypto_ablkcipher_alignmask(ablkcipher) &
+				~(crypto_tfm_ctx_alignment() - 1));
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+
+	len += sizeof(struct ablkcipher_request) +
+			crypto_ablkcipher_reqsize(ablkcipher);
+	if (nopin) {
+		len = ALIGN(len, __alignof__(struct scatterlist));
+		len += sizeof(struct scatterlist) * ssg_num;
+		len += bufsize;
+
+		return kzalloc(len, GFP_KERNEL);
+	}
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += sizeof(struct scatterlist) * sg_size;
+
+	len = ALIGN(len, __alignof__(struct page *));
+	len += sizeof(struct page *) * sg_size;
+
+	return kzalloc(len, GFP_KERNEL);
+}
+
+static inline struct ablkcipher_request *ablkcipher_result_req
+					(struct crypto_ablkcipher
+					*ablkcipher,
+					struct async_result
+					*result)
+{
+	struct ablkcipher_request *req;
+
+	req = (struct ablkcipher_request *) PTR_ALIGN(
+				(unsigned long) result +
+				sizeof(struct async_result),
+				crypto_tfm_ctx_alignment());
+	ablkcipher_request_set_tfm(req, ablkcipher);
+	return req;
+}
+
+static inline struct scatterlist *ablkcipher_req_sg(
+				struct crypto_ablkcipher *ablkcipher,
+				struct ablkcipher_request *req)
+{
+	return (struct scatterlist *) ALIGN((unsigned long) (req + 1) +
+				crypto_ablkcipher_reqsize(ablkcipher),
+				__alignof__(struct scatterlist));
+}
+
+static inline char *ablkcipher_ssg_data(struct scatterlist *ssg,
+					 int ssg_num)
+{
+	return (char *) ((unsigned long) ssg +
+				sizeof(struct scatterlist) * ssg_num);
+}
+
+static inline struct page **ablkcipher_ssg_spages(struct scatterlist *ssg,
+						int sg_size)
+{
+	return (struct page **) ALIGN((unsigned long) ssg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static inline struct scatterlist *ablkcipher_spages_dsg
+					(struct page **pages, int len)
+{
+	return (struct scatterlist *) ALIGN((unsigned long) pages +
+				sizeof(struct page *) * len,
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **ablkcipher_dsg_dpages(struct scatterlist *dsg,
+						int sg_size)
+{
+	return (struct page **) ALIGN((unsigned long) dsg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+/**
+ * This is the actual crypto function that creates the
+ * encrypted or decrypted data
+ *
+ */
+static int cryptodev_run_acipher(struct csession *ses_ptr,
+				 struct crypto_item_op *cop,
+				 struct kiocb *iocb)
+{
+	char __user *src;
+	char __user *dst;
+	void *tmp;
+	struct scatterlist *ssg;
+	struct scatterlist *dsg;
+	char *data = NULL;
+	struct ablkcipher_request *req;
+	struct async_result *result = NULL;
+	size_t bufsize;
+	int ret = 0;
+	int nr_spages;
+	int nr_dpages = 0;
+	int dst_flag, nopin;
+	int ssg_num;
+
+	/* Setting the Input params */
+	bufsize = cop->src_size;
+	src = cop->src_data;
+	dst = cop->dst_data;
+	dst_flag = src != dst;
+	ssg_num = cryptodev_num_pages((unsigned long) src, bufsize);
+
+	nopin = cryptodev_is_pin_pages(bufsize) ? 1 : 0;
+
+	if (cop->eop && cop->eop != COP_ENCRYPT && cop->eop != COP_DECRYPT) {
+		printk(KERN_ERR PFX "sid %p invalid operation op=%u\n",
+			ses_ptr, cop->eop);
+		return -EINVAL;
+	}
+
+	if (bufsize > CRYPTO_MAX_DATA_LEN) {
+		printk(KERN_INFO PFX "Maximum Data Size Exceeded: %d > %d\n",
+			bufsize, CRYPTO_MAX_DATA_LEN);
+		return -E2BIG;
+	}
+
+	if (bufsize % crypto_ablkcipher_blocksize(ses_ptr->tfm_ablkcipher)) {
+		printk(KERN_ERR PFX
+			"data size (%zu) isn't a multiple of block size (%u)\n",
+			bufsize, 
+			crypto_ablkcipher_blocksize(ses_ptr->tfm_ablkcipher));
+		return -EINVAL;
+	}
+
+	nr_spages = nopin ? 0 : 
+			   cryptodev_num_pages((unsigned long) src, bufsize);
+	if (dst_flag)
+		nr_dpages = nopin ? 0 : cryptodev_num_pages(
+						(unsigned long) dst, bufsize);
+
+	tmp = ablkcipher_alloc_tmp(ses_ptr->tfm_ablkcipher,
+				dst_flag ? (nr_spages + nr_dpages) :
+				nr_spages, nopin, bufsize, ssg_num);
+	if (!tmp)
+		return -ENOMEM;
+
+	/* Setting the request, Digest, and sg */
+	result = (struct async_result *) tmp;
+	req = ablkcipher_result_req(ses_ptr->tfm_ablkcipher, result);
+	ssg = ablkcipher_req_sg(ses_ptr->tfm_ablkcipher, req);
+	if (nopin) {
+		data = ablkcipher_ssg_data(ssg, ssg_num);
+		if (src && copy_from_user(data, src, bufsize)) {
+			printk(KERN_ERR PFX
+				"failed to copy cop cipher "
+				"data from user space\n");
+			kfree(tmp);
+			return -EINVAL;
+		}
+		cryptodev_sg_setbuf(data, bufsize, ssg, ssg_num);
+
+		dsg = ssg;
+	} else {
+		result->spages = ablkcipher_ssg_spages(ssg, nr_spages);
+		ret = cryptodev_set_user_pages(src, ssg, result->spages, 
+					bufsize, &nr_spages, 
+					&result->null_buf);
+		if (ret)
+			goto out_tmp;
+		if (dst_flag) {
+			dsg = ablkcipher_spages_dsg(result->spages, nr_spages);
+			result->dpages = ablkcipher_dsg_dpages(dsg, nr_dpages);
+			ret = cryptodev_set_user_pages(dst, dsg,
+					result->dpages, bufsize, &nr_dpages,
+					&result->null_buf);
+			if (ret)
+				goto out_spages;
+		} else {
+			dsg = ssg;
+			result->dpages = result->spages;
+		}
+	}
+
+	if (iocb) {
+		result->iocbvec     	= iocb;
+		result->nr_spages   	= nr_spages;
+		result->nr_dpages   	= nr_dpages;
+		result->nopin_data  	= data;
+		result->session_ptr 	= ses_ptr;
+		result->udata		= cop->udata;
+		result->aio_enc		= cop->eop;
+		result->aio_dst_data	= dst;
+		result->aio_size_data	= bufsize;
+		ablkcipher_request_set_callback(req,
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_aio_complete,
+					result);
+	} else {
+		init_completion(&(result->crypto_completion));
+		ablkcipher_request_set_callback(req,
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete,
+					result);
+	}
+
+	ablkcipher_request_set_crypt(req, ssg, dsg, bufsize, cop->iv);
+
+	atomic_inc(&ses_ptr->refcnt);
+	if (cop->eop == COP_ENCRYPT)
+		ret = crypto_ablkcipher_encrypt(req);
+	else
+		ret = crypto_ablkcipher_decrypt(req);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		if (iocb) {
+			CDPRINTK(2, KERN_INFO,
+				 "Async Call ACRYPTO:Returning Now\n");
+			if (nopin)
+				return -EIOCBRETRY;
+			else
+				return -EIOCBQUEUED;
+		}
+		ret = wait_for_completion_interruptible(
+				&(result->crypto_completion));
+		if (!ret)
+			ret = result->err;
+		if (!ret) {
+			INIT_COMPLETION(result->crypto_completion);
+			break;
+		}
+		/* fall through */
+	default:
+		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
+			ses_ptr, -ret);
+		break;
+	}
+
+	if (nopin && !ret) {
+		if (copy_to_user(dst, data, bufsize))
+			printk(KERN_ERR PFX
+				"failed to encrypted data to user space\n");
+		CD_HEXDUMP(data, bufsize);
+	}
+
+	/* Check if last reference */
+	if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+		if (ses_ptr->destroy)
+			ses_ptr->destroy(ses_ptr);
+		kfree(ses_ptr);
+	}
+
+	if (dst_flag)
+		cryptodev_release_pages(result->dpages, nr_dpages);
+out_spages:
+	cryptodev_release_pages(result->spages, nr_spages);
+
+out_tmp:
+	if (result->null_buf)
+		kfree(result->null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**
+ * Asynchronous Function Support
+ *
+ */
+static void cryptodev_async_aio_complete(struct crypto_async_request *req,
+					 int err)
+{
+	struct async_result *res;
+	struct csession *ses_ptr;
+	struct kiocb	*iocb;
+	int err2 = 0;
+	int done = 1;
+
+	res = req->data;
+	iocb = res->iocbvec;
+	res->err = err;
+
+	if (err == -EINPROGRESS)
+		return;
+	if (!res)
+		return;
+
+	CDPRINTK(2, KERN_INFO, "Asynchrnous call-back Called\n");
+
+	if (res->spages)
+		cryptodev_release_pages(res->spages, res->nr_spages);
+
+	ses_ptr = res->session_ptr;
+	err2 = iocb->ki_nbytes;
+
+	switch (ses_ptr->mode) {
+	case CRYPTO_MODE_ACIPHER:
+	case CRYPTO_MODE_AEAD:
+		if (res->dpages) {
+			if (res->dpages != res->spages)
+				cryptodev_release_pages(res->dpages,
+				res->nr_dpages);
+			aio_complete(res->iocbvec, err2, err);
+			/* No need to copy anything to user
+			since, using Direct I/O */
+		} else {
+			done = 0;
+			iocb->private = res;
+			kick_iocb(iocb);
+		}
+		break;
+	case CRYPTO_MODE_AHASH:
+		done = 0;
+		iocb->private = res;
+		kick_iocb(iocb);
+		break;
+	}
+
+	if (done) {
+		if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+			if (ses_ptr->destroy)
+				ses_ptr->destroy(ses_ptr);
+			kfree(ses_ptr);
+		}
+		if (res->null_buf)
+			kfree(res->null_buf);
+		if (res->udata)
+			kfree(res->udata);
+		kfree(res);
+	}
+
+}
+
+static int cryptodev_aio_write_retry(struct kiocb *iocb)
+{
+	struct async_result *res = iocb->private;
+	struct csession *ses_ptr;
+	int  ret;
+	char *digest;
+	int  size;
+
+	ses_ptr = res->session_ptr;
+	ret = res->err;
+
+	 if (ret == -EINPROGRESS)
+		 return -EINPROGRESS;
+
+	switch (ses_ptr->mode) {
+	case CRYPTO_MODE_ACIPHER:
+	case CRYPTO_MODE_AEAD:
+		size = res->aio_size_data;
+		if (res->aio_enc)
+			size += crypto_aead_authsize(ses_ptr->tfm_aead);
+		else
+			size -= crypto_aead_authsize(ses_ptr->tfm_aead);
+		if (copy_to_user(res->aio_dst_data, res->nopin_data, size)) {
+			printk(KERN_ERR PFX
+				"failed to copy encrypted data "
+				"to user space\n");
+			ret = -EFAULT;
+		}
+
+		break;
+	case CRYPTO_MODE_AHASH:
+		digest = (char *) ((unsigned long) res +
+				   sizeof(struct async_result));
+		size = crypto_ahash_digestsize(ses_ptr->tfm_ahash);
+
+		if (copy_to_user(res->aio_dst_data, digest, size)) {
+			printk(KERN_ERR PFX
+				"sid %p failed to copy mac data to"
+				"user space for hash\n", ses_ptr);
+			ret = -EFAULT;
+		}
+		break;
+	}
+
+	if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+		if (ses_ptr->destroy)
+			ses_ptr->destroy(ses_ptr);
+		kfree(ses_ptr);
+	}
+	if (res->null_buf)
+		kfree(res->null_buf);
+	if (res->udata)
+		kfree(res->udata);
+	kfree(res);
+
+	return ret;
+}
+
+/**
+ * Helper Functions for File Descriptor setting and releasing
+ *
+ */
+static int cryptodev_open(struct inode *inode, struct file *filp)
+{
+	struct cryptodev_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mutex_init(&ctx->lock);
+	ctx->session = NULL;
+	filp->private_data = ctx;
+
+	return 0;
+}
+
+static int cryptodev_release(struct inode *inode, struct file *filp)
+{
+	struct cryptodev_ctx *ctx = filp->private_data;
+	struct csession *ses_ptr;
+
+	if (!ctx)
+		return 0;
+
+	mutex_lock(&ctx->lock);
+	ses_ptr = ctx->session;
+
+	if (!ses_ptr)
+		goto out;
+
+	if (atomic_dec_and_test(&ses_ptr->refcnt)) {
+		if (ses_ptr->destroy)
+			ses_ptr->destroy(ses_ptr);
+		kfree(ses_ptr);
+	}
+
+out:
+	filp->private_data = NULL;
+	mutex_unlock(&ctx->lock);
+	kfree(ctx);
+
+	return 0;
+}
+
+static int cryptodev_user_create_session(void *arg, struct csession **ses_ptr)
+{
+	struct session_op sop;
+	void *session_udata;
+	int  size;
+	int  ret;
+
+	if (copy_from_user(&sop, (void *) arg, sizeof(sop))) {
+		printk(KERN_ERR PFX "copy of session data failed\n");
+		return -EFAULT;
+	}
+
+	size = sop.algo_size + sop.hmackey_size + sop.key_size + sop.icv_size;
+	session_udata = kzalloc(size, GFP_KERNEL);
+	if (!session_udata)
+		return -ENOMEM;
+
+	if (copy_from_user(session_udata, (void *) arg + sizeof(sop), size)) {
+		printk(KERN_ERR PFX "failed to copy sop data\n");
+		ret = -EINVAL;
+		goto out_sess;
+	}
+
+	ret = cryptodev_create_session(ses_ptr, &sop, session_udata);
+
+out_sess:
+	kfree(session_udata);
+	return ret;
+}
+
+static int crypto_dev_user_setkey(struct csession *ses_ptr, void *arg)
+{
+	struct key_op kop;
+	char *keyp;
+	u16  key_size;
+	int  ret;
+
+	if (copy_from_user(&kop, (void *) arg, sizeof(kop))) {
+		printk(KERN_ERR PFX "Copy of key data failed"
+				"at CIOCKEY from user space\n");
+		return -EFAULT;
+	}
+
+	key_size = kop.ksize;
+	keyp = kzalloc(key_size, GFP_KERNEL);
+	if (!keyp)
+		return -ENOMEM;
+
+	if (copy_from_user(keyp, (void *) arg + sizeof(kop), key_size)) {
+		printk(KERN_ERR PFX "copy of key data failed\n");
+		kfree(keyp);
+		return -EFAULT;
+	}
+	ret = ses_ptr->setkey(ses_ptr, keyp, key_size);
+
+	kfree(keyp);
+	return ret;
+}
+
+static int cryptodev_user_op(struct csession *ses_ptr, const struct iovec *iov,
+				struct kiocb *iocb)
+{
+	struct crypto_item_op cop;
+	int  ivsize;
+	int  ret;
+
+	cop.udata = kzalloc(iov[0].iov_len, GFP_KERNEL);
+	if (!cop.udata)
+		return -ENOMEM;
+
+	if (copy_from_user(cop.udata, iov[0].iov_base,
+			iov[0].iov_len)) {
+		    printk(KERN_ERR PFX "copy of operation data failed\n");
+		    ret = -EFAULT;
+		    goto out_cryp;
+	}
+
+	ivsize = ses_ptr->getivsize(ses_ptr);
+	if (cop.iv_len != ivsize) {
+		printk(KERN_ERR PFX "ivsize set incorrectly\n");
+		ret = -EINVAL;
+		goto out_cryp;
+	}
+
+	cop.iv = cop.udata->data;
+	cop.assoc = cop.udata->data + cop.iv_len;
+
+	cop.src_data = iov[1].iov_base;
+	cop.src_size = iov[1].iov_len;
+	cop.dst_data = iov[2].iov_base;
+
+	ret = ses_ptr->runop(ses_ptr, &cop, iocb);
+
+	if (ret == -EIOCBRETRY || ret == -EIOCBQUEUED)
+		return ret;
+
+out_cryp:
+	kfree(cop.udata);
+	return ret;
+}
+
+static int cryptodev_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	struct csession *ses_ptr;
+	struct cryptodev_ctx *ctx = filp->private_data;
+	int	ret;
+
+	if (!ctx) {
+		printk(KERN_ERR PFX "Context Not set for fd\n");
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case CIOCGSESSION:
+		mutex_lock(&ctx->lock);
+		ses_ptr = ctx->session;
+		if (ses_ptr) {
+			printk(KERN_ERR PFX "Session data already set\n");
+			mutex_unlock(&ctx->lock);
+			return -EINVAL;
+		}
+		ret = cryptodev_user_create_session((void *) arg, &ses_ptr);
+		ctx->session = ses_ptr;
+		mutex_unlock(&ctx->lock);
+		return ret;
+	case CIOCKEY:
+		ses_ptr = ctx->session;
+		if (!ses_ptr) {
+			printk(KERN_ERR PFX "session data does not exist\n");
+			return -EINVAL;
+		}
+		return crypto_dev_user_setkey(ses_ptr, (void *) arg);
+	default:
+		printk(KERN_ERR PFX "un-supported command 0x%08X\n", cmd);
+		return -EINVAL;
+	}
+}
+
+static int cyptodev_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			      unsigned long nr_segs, loff_t o)
+{
+	struct file *filp = iocb->ki_filp;
+	struct cryptodev_ctx *ctx = filp->private_data;
+	struct csession *ses_ptr;
+
+	if (!ctx) {
+		printk(KERN_ERR PFX "Context Not set for fd\n");
+		return -EINVAL;
+	}
+
+	ses_ptr = ctx->session;
+	if (!ses_ptr) {
+		printk(KERN_ERR PFX "session data does not exist\n");
+		return -EINVAL;
+	}
+
+	if (is_sync_kiocb(iocb)) {
+		CDPRINTK(2, KERN_INFO, "Synchronous call\n");
+		return cryptodev_user_op(ses_ptr, iov, NULL);
+
+	} else {
+		CDPRINTK(2, KERN_INFO, "Asynchronous call\n");
+		iocb->ki_retry = cryptodev_aio_write_retry;
+		return cryptodev_user_op(ses_ptr, iov, iocb);
+	}
+}
+
+struct file_operations cryptodev_fops = {
+	.owner   = THIS_MODULE,
+	.open    = cryptodev_open,
+	.release = cryptodev_release,
+	.ioctl   = cryptodev_ioctl,
+	.aio_write = cyptodev_aio_write,
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
+		printk(KERN_ERR PFX
+			"failed to register /dev/crypto error %d \n", rc);
+		return rc;
+	}
+	return 0;
+}
+
+static void cryptodev_deregister(void)
+{
+	misc_deregister(&cryptodev);
+}
+
+/**
+ * Module init/exit
+ *
+ */
+int __init cryptodev_init(void)
+{
+	int rc;
+
+	rc = cryptodev_register();
+	if (rc)
+		return rc;
+
+	printk(KERN_INFO "User space CryptoAPI driver v%s loaded\n",
+			CRYPTODEV_VER);
+
+	return 0;
+}
+
+void __exit cryptodev_exit(void)
+{
+	cryptodev_deregister();
+	printk(KERN_INFO "User space CryptoAPI driver v%s unloaded\n",
+			CRYPTODEV_VER);
+}
+
+module_init(cryptodev_init);
+module_exit(cryptodev_exit);
+
+MODULE_AUTHOR("Shasi Pulijala <spulijala@amcc.com>");
+MODULE_DESCRIPTION("Linux CryptoAPI user space driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/cryptodev.h b/include/linux/cryptodev.h
new file mode 100644
index 0000000..11996b0
--- /dev/null
+++ b/include/linux/cryptodev.h
@@ -0,0 +1,79 @@
+/****************************************************************************
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
+ * This file defines ioctl structures for the Linux CryptoAPI interface. It
+ * provides user space applications accesss into the Linux CryptoAPI
+ * functionalities.
+ *
+ ****************************************************************************
+ */
+
+#ifndef __CRYPTODEV_H__
+#define __CRYPTODEV_H__
+
+/**
+ * @struct session_op
+ * @brief ioctl parameter to create a session
+ *
+ *
+ */
+struct session_op {
+
+	__u16		algo_size;
+	__u16		key_size;	/* cipher key length*/
+	__u16		hmackey_size;	/* mac key length*/
+	__u16		icv_size;	/*authsize (ccm, gcm)*/
+	__u8		data[0];
+};
+
+/**
+ * @struct key_op
+ * @brief ioctl parameter to change the session key
+ *
+ */
+struct key_op {
+	__u16		ksize;
+	__u8		data[0];
+};
+
+/**
+ * @struct crypt_op
+ * @brief ioctl parameter to request a crypt/decrypt operation
+ * against a session
+ *
+ *
+ */
+#define CRYPTO_MAX_DATA_LEN		(64*1024 - 1)
+struct crypt_op {
+#define COP_NONE	0
+#define COP_ENCRYPT	1
+#define COP_DECRYPT	2
+	__u16		op;		/* i.e. COP_ENCRYPT */
+	__u16		flags;
+	__u16		iv_size;
+	__u16 		assoc_size;
+	__u8		data[0];	/* must be big enough for chosen MAC */
+};
+
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
+/* change crypto key */
+#define CIOCKEY    	_IOWR('c', 102, struct key_op)
+
+#endif
-- 
1.5.5

