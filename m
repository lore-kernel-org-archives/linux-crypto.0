From: "Loc Ho" <lho@amcc.com>
Subject: [PATCH 1/1 v2] crypto: Add CryptoAPI User Interface Support
Date: Thu, 12 Jun 2008 13:54:00 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604921C4D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:52206 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYFLUyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2008 16:54:03 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This is CryptoAPI user space interface support patch v2. This version
includes:

1. a file descriptor per tfm
2. Direct I/O for user data buffer (with option for single mapping)
3. algorithm properties is set via I/O control call
4. Per buffer operation is operated via I/O control call

Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>

---
 crypto/Kconfig            |    7 +
 crypto/Makefile           |    1 +
 crypto/cryptodev.c        | 1293
+++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cryptodev.h |   74 +++
 4 files changed, 1375 insertions(+), 0 deletions(-)
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
index 0000000..8a7e477
--- /dev/null
+++ b/crypto/cryptodev.c
@@ -0,0 +1,1293 @@
+/**********************************************************************
******
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
+ * Detail Description:
+ * This file implements the /dev/crypto interface which is intended to
+ * provide user space interface to the Linux CryptoAPI.
+ *
+
************************************************************************
***
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pagemap.h>
+#include <linux/miscdevice.h>
+#include <linux/ioctl.h>
+#include <linux/scatterlist.h>
+#include <linux/cryptodev.h>
+#include <asm/atomic.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+
+/**********************************************************************
******
+ * Macro declaration
+
************************************************************************
****
+ */
+/* /dev/crypto is a char block device with major 10 and minor below */
+#define	CRYPTODEV_MINOR		70
+
+/* Debug Mode Setting */
+#define CRYPTODEV_DEBUG
+
+/* Version Number */
+#define	CRYPTODEV_VER		"0.1"
+
+/**********************************************************************
******
+ * Module Parameters
+
************************************************************************
****
+ */
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "0: normal, 1: verbose, 2: debug");
+
+static int sg_single;
+module_param(sg_single, int, 0644);
+MODULE_PARM_DESC(sg_single, "0: scatter user buffers to page size, "
+			    "1: single buffer for user buffer");
+
+#ifdef CRYPTODEV_STATS
+static int enable_stats;
+module_param(enable_stats, int, 0644);
+MODULE_PARM_DESC(enable_stats, "collect statictics about cryptodev
usage");
+#endif
+
+/**********************************************************************
******
+ * Debugging Macro's
+
************************************************************************
****
+ */
+#define PFX "cryptodev: "
+
+#ifndef CRYPTODEV_DEBUG
+#define CRYPTODEV_HEXDUMP(b, l) \
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
\
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
******
+ * Helper Structures
+
************************************************************************
****
+ */
+#define CRYPTO_MODE_NOTSET	0
+#define CRYPTO_MODE_ACIPHER	1
+#define CRYPTO_MODE_AHASH	2
+#define CRYPTO_MODE_AEAD	3
+
+#define tfm_ablkcipher	crt_tfm.acipher_tfm
+#define tfm_aead	crt_tfm.aead_tfm
+#define tfm_ahash	crt_tfm.ahash_tfm
+
+struct csession {
+	atomic_t  refcnt;
+	int	mode;			/* See CRYPTO_MODE_XXX */
+	union {
+		struct crypto_ablkcipher *acipher_tfm;
+		struct crypto_ahash 	 *ahash_tfm;
+		struct crypto_aead 	 *aead_tfm;
+	} crt_tfm;
+};
+
+struct async_result {
+	struct completion completion;
+	int err;
+};
+
+/**********************************************************************
******
+ * Function Declarations
+
************************************************************************
****
+ */
+static int create_session_ablkcipher(struct crypto_ablkcipher *tfm,
+				char *alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr);
+static int create_session_ahash(struct crypto_ahash *tfm,
+				char *alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr);
+static int create_session_aead(struct crypto_aead *tfm,
+				char *alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr);
+static int cryptodev_run_acipher(struct csession *ses_ptr,
+				struct crypt_op *cop);
+static int cryptodev_run_ahash(struct csession *ses_ptr,
+				struct crypt_op *cop);
+static int cryptodev_run_aead(struct csession *ses_ptr,
+				struct crypt_op *cop);
+
+/**********************************************************************
******
+ * Scatter/Gather Helper Functions
+
************************************************************************
****
+ */
+static int cryptodev_set_user_pages(char __user *src,
+				struct scatterlist *asg,
+				struct page **pages, int bufsize,
+				int *nr_pages, char **null_buf);
+static void cryptodev_release_pages(struct page **pages, int nr_pages);
+static int cryptodev_num_pages(unsigned long data, int bufsize);
+
+/**********************************************************************
******
+ * Asynchronous handling Routine
+
************************************************************************
****
+ */
+static void cryptodev_async_complete(struct crypto_async_request *req,
+					int err)
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
******
+ * Prepare session for future use
+
************************************************************************
****
+ */
+static int cryptodev_create_session(struct csession **ses_ptr,
+				    struct session_op *sop)
+{
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_ablkcipher *ablkcipher_tfm;
+	struct crypto_aead *aead_tfm;
+	struct crypto_ahash *ahash_tfm;
+
+	if (copy_from_user(alg_name, sop->alg_name,
CRYPTO_MAX_ALG_NAME)) {
+		printk(KERN_ERR PFX
+			"failed to copy alg name from user space\n");
+		return -EINVAL;
+	}
+
+	if (strlen(alg_name) <= 0) {
+		printk(KERN_ERR PFX "alg name can not be empty\n");
+		return -EINVAL;
+	}
+
+	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
+	if (!IS_ERR(ahash_tfm))
+		return create_session_ahash(ahash_tfm, alg_name, sop,
+					    ses_ptr);
+	ablkcipher_tfm = crypto_alloc_ablkcipher(alg_name, 0, 0);
+	if (!IS_ERR(ablkcipher_tfm))
+		return create_session_ablkcipher(ablkcipher_tfm,
+						alg_name, sop, ses_ptr);
+	aead_tfm = crypto_alloc_aead(alg_name, 0, 0);
+	if (!IS_ERR(aead_tfm))
+		return create_session_aead(aead_tfm, alg_name, sop,
ses_ptr);
+
+	printk(KERN_ERR PFX "un-supported algorithm %s\n", alg_name);
+	return -EINVAL;
+}
+
+/**********************************************************************
******
+ * Routine for creating a session for AEAD type algorithm
+
************************************************************************
****
+ */
+static int create_session_aead(struct crypto_aead *tfm, char *alg_name,
+			struct session_op *sop, struct csession
**ses_ptr)
+{
+	struct csession	*ses_new;
+	char *keyp = NULL;
+	size_t authsize;
+	int ret = 0;
+
+	crypto_aead_clear_flags(tfm, ~0);
+
+	keyp = kzalloc(sop->keylen, GFP_KERNEL);
+	if (unlikely(!keyp)) {
+		crypto_free_aead(tfm);
+		return -ENOMEM;
+	}
+
+	if (sop->key && copy_from_user(keyp, sop->key, sop->keylen)) {
+		printk(KERN_ERR PFX
+			"failed to copy of key field from user space "
+			"for alg %s\n", alg_name);
+		kfree(keyp);
+		crypto_free_aead(tfm);
+		return -EFAULT;
+	}
+
+	ret = crypto_aead_setkey(tfm, keyp, sop->keylen);
+	kfree(keyp);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to set key field for %s-%zu:
flags=0x%X\n",
+			alg_name, sop->keylen * 8,
+			crypto_aead_get_flags(tfm));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> "
+			"for details)\n");
+
+		crypto_free_aead(tfm);
+		return -EINVAL;
+	}
+
+	authsize = sop->icvlen;
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		printk(KERN_ERR "failed to set authsize = %u\n",
authsize);
+		crypto_free_aead(tfm);
+		return -EINVAL;
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_aead(tfm);
+		return -ENOMEM;
+	}
+	ses_new->tfm_aead = tfm;
+	ses_new->mode     = CRYPTO_MODE_AEAD;
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+	CRYPTODEV_PRINTK(1, KERN_INFO, "AEAD sid %p alg %s created\n",
+			 ses_new, alg_name);
+	return 0;
+}
+
+/**********************************************************************
******
+ * Routine for creating a session for HASH type algorithm
+
************************************************************************
****
+ */
+static int create_session_ahash(struct crypto_ahash *tfm, char
*alg_name,
+				struct session_op *sop,
+				struct csession **ses_ptr)
+{
+	struct csession	*ses_new;
+	char *keyp = NULL;
+	int ret = 0;
+
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	/* Copy the key(hmac) from user and set to TFM. */
+	if (sop->mackey) {
+		keyp = kzalloc(sop->mackeylen, GFP_KERNEL);
+		if (unlikely(!keyp)) {
+			crypto_free_ahash(tfm);
+			return -ENOMEM;
+		}
+
+		if (copy_from_user(keyp, sop->mackey, sop->mackeylen)) {
+			printk(KERN_ERR PFX
+				"failed to copy key field from user
space "
+				"for alg %s\n", alg_name);
+			kfree(keyp);
+			crypto_free_ahash(tfm);
+			return -EFAULT;
+		}
+
+		ret = crypto_ahash_setkey(tfm, keyp, sop->mackeylen);
+		kfree(keyp);
+		if (ret) {
+			printk(KERN_ERR PFX
+				"failed to set key field for %s-%zu: "
+				"flags=0x%X\n"
+				"(see CRYPTO_TFM_RES_* in "
+				"<linux/crypto.h> for details)\n",
+				alg_name, sop->mackeylen * 8,
+				crypto_ahash_get_flags(tfm));
+
+			crypto_free_ahash(tfm);
+			return -EINVAL;
+		}
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_ahash(tfm);
+		return -ENOMEM;
+	}
+	ses_new->tfm_ahash = tfm;
+	ses_new->mode      = CRYPTO_MODE_AHASH;
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+
+	CRYPTODEV_PRINTK(1, KERN_INFO, "AHASH sid %p alg %s created\n",
+			 ses_new, alg_name);
+	return 0;
+}
+
+/**********************************************************************
******
+ * Routine for creating a session for CRYPTO block type algorithm
+
************************************************************************
****
+ */
+static int create_session_ablkcipher(struct crypto_ablkcipher *tfm,
+				char *alg_name, struct session_op *sop,
+				struct csession **ses_ptr)
+{
+	struct csession	*ses_new;
+	char *keyp = NULL;
+	int ret = 0;
+
+	crypto_ablkcipher_clear_flags(tfm, ~0);
+
+	/* Copy the key from user and set to TFM. */
+	keyp = kzalloc(sop->keylen, GFP_KERNEL);
+	if (unlikely(!keyp)) {
+		crypto_free_ablkcipher(tfm);
+		return -ENOMEM;
+	}
+
+	if (sop->key && copy_from_user(keyp, sop->key, sop->keylen)) {
+		printk(KERN_ERR PFX "failed to copy key field from user"
+			"space for alg %s\n", alg_name);
+		kfree(keyp);
+		crypto_free_ablkcipher(tfm);
+		return -EFAULT;
+	}
+
+	ret = crypto_ablkcipher_setkey(tfm, keyp, sop->keylen);
+	kfree(keyp);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"failed to seet key for %s-%zu: flags=0x%X\n",
+			alg_name, sop->keylen*8,
+			crypto_ablkcipher_get_flags(tfm));
+		printk(KERN_ERR PFX
+			"(see CRYPTO_TFM_RES_* in <linux/crypto.h> for "
+			"details)\n");
+
+		crypto_free_ablkcipher(tfm);
+		return -EINVAL;
+	}
+
+	ses_new = kzalloc(sizeof(*ses_new), GFP_KERNEL);
+	if (!ses_new) {
+		crypto_free_ablkcipher(tfm);
+		return -ENOMEM;
+	}
+
+	ses_new->tfm_ablkcipher = tfm;
+	ses_new->mode 		= CRYPTO_MODE_ACIPHER;
+	atomic_set(&ses_new->refcnt, 1);
+
+	*ses_ptr = ses_new;
+	CRYPTODEV_PRINTK(1, KERN_INFO,
+			"ABLCKCIPHER sid %p alg %s created\n",
+			 ses_new, alg_name);
+	return 0;
+}
+
+/**********************************************************************
******
+ *  Everything that needs to be done when removing a session.
+ *
+
************************************************************************
****
+ */
+static inline int cryptodev_destroy_session(struct csession *ses_ptr)
+{
+	/* Check for mode and then delete */
+	switch (ses_ptr->mode) {
+	case CRYPTO_MODE_ACIPHER:
+		CRYPTODEV_PRINTK(1, KERN_INFO,
+				"ABLCKCIPHER sid %p deleting\n",
+				ses_ptr);
+		crypto_free_ablkcipher(ses_ptr->tfm_ablkcipher);
+		break;
+	case CRYPTO_MODE_AHASH:
+		CRYPTODEV_PRINTK(1, KERN_INFO,
+				"AHASH sid %p deleting\n",
+				ses_ptr);
+		crypto_free_ahash(ses_ptr->tfm_ahash);
+		break;
+	case CRYPTO_MODE_AEAD:
+		CRYPTODEV_PRINTK(1, KERN_INFO,
+				"AEAD sid %p deleting\n",
+				 ses_ptr);
+		crypto_free_aead(ses_ptr->tfm_aead);
+		break;
+	}
+
+	kfree(ses_ptr);
+	return 0;
+}
+
+static int cryptodev_run(struct csession *ses_ptr, struct crypt_op
*cop)
+{
+	int ret;
+
+	if (cop->op &&
+	    (cop->op != COP_ENCRYPT && cop->op != COP_DECRYPT)) {
+			printk(KERN_ERR PFX "sid %p invalid "
+			"operation op=%u\n",
+			ses_ptr, cop->op);
+		return -EINVAL;
+	}
+
+	switch (ses_ptr->mode) {
+	case CRYPTO_MODE_ACIPHER:
+		ret = cryptodev_run_acipher(ses_ptr, cop);
+		break;
+	case CRYPTO_MODE_AHASH:
+		ret = cryptodev_run_ahash(ses_ptr, cop);
+		break;
+	case CRYPTO_MODE_AEAD:
+		ret = cryptodev_run_aead(ses_ptr, cop);
+		break;
+	default:
+		printk(KERN_ERR PFX "sid %p unknown mode set/unset mode.
"
+			"See I/O control CIOCGSESSION\n", ses_ptr);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static void *aead_alloc_tmp(struct crypto_aead *aead, int sg_size,
+				int assoclen, int asg_len)
+{
+	unsigned int len;
+
+	len = crypto_aead_ivsize(aead);
+
+	if (len) {
+		len += crypto_aead_alignmask(aead) &
+		       ~(crypto_tfm_ctx_alignment() - 1);
+		len = ALIGN(len, crypto_tfm_ctx_alignment());
+	}
+
+	len += sizeof(char) * assoclen;
+
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += sizeof(struct aead_request) + crypto_aead_reqsize(aead);
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += sizeof(struct scatterlist) * (sg_size + asg_len);
+
+	len = ALIGN(len, __alignof__(struct page *));
+	len += sizeof(struct page *) * sg_size;
+
+	return kzalloc(len, GFP_KERNEL);
+}
+
+static inline char *aead_tmp_iv(void *tmp, struct crypto_aead *aead)
+{
+	return crypto_aead_ivsize(aead) ?
+	       PTR_ALIGN((u8 *) tmp, crypto_aead_alignmask(aead) + 1) :
tmp;
+}
+
+static inline char *aead_iv_assoc(char *iv, struct crypto_aead *aead)
+{
+	return (void *) ((unsigned long) iv + crypto_aead_ivsize(aead));
+}
+
+static inline struct aead_request *aead_assoc_req(struct crypto_aead
+					 *aead, char *assoc, int
assoclen)
+{
+	struct aead_request *req;
+
+	req = (void *) PTR_ALIGN((unsigned long) assoc + assoclen,
+				 crypto_tfm_ctx_alignment());
+	aead_request_set_tfm(req, aead);
+	return req;
+}
+
+static inline struct scatterlist *aead_req_asg(struct crypto_aead
*aead,
+					     struct aead_request *req)
+{
+	return (void *) ALIGN((unsigned long) (req + 1) +
+				crypto_aead_reqsize(aead),
+				__alignof__(struct scatterlist));
+}
+
+static inline struct scatterlist *aead_asg_sg(struct scatterlist *asg,
+						int sg_size)
+{
+	return (void *) ALIGN((unsigned long) asg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **aead_sg_spages(struct scatterlist *sg,
+					int sg_size)
+{
+	return (void *) ALIGN((unsigned long) sg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static inline struct scatterlist *aead_spages_dsg(struct page **pages,
+							int npages)
+{
+	return (void *) ALIGN((unsigned long) pages +
+				sizeof(struct page *) * npages,
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **aead_dsg_dpages(struct scatterlist *dsg,
+						int sg_size)
+{
+	return (void *) ALIGN((unsigned long) dsg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+/**********************************************************************
******
+ * This is the actual aead function that implements
+ * the Combined mode
+
************************************************************************
****
+ */
+static int cryptodev_run_aead(struct csession *ses_ptr, struct crypt_op
*cop)
+{
+	char *ivp  = NULL;
+	char *assoc = NULL;
+	char *null_buf = NULL;
+	void *tmp;
+	char __user *src;
+	char __user *dst;
+	struct scatterlist *asg;
+	struct scatterlist *ssg;
+	struct scatterlist *dsg;
+	struct aead_request *req;
+	struct async_result result;
+	struct page **pages;
+	struct page **dpages;
+	size_t bufsize;
+	size_t ivsize;
+	size_t assoclen;
+	size_t authsize;
+	int enc;
+	int nr_pages;
+	int nr_dpages;
+	int asg_len;
+	int dst_flag;
+	int ret;
+
+	/* Setting the Input params */
+	bufsize = cop->len;
+	assoclen = cop->assoclen;
+	src = cop->src;
+	dst = cop->dst;
+	dst_flag = src != dst;
+
+	enc = cop->op == COP_ENCRYPT ? 1 : 0;
+	authsize = crypto_aead_authsize(ses_ptr->tfm_aead);
+	ivsize = crypto_aead_ivsize(ses_ptr->tfm_aead);
+	asg_len = (assoclen + PAGE_SIZE - 1)/PAGE_SIZE;
+
+	init_completion(&result.completion);
+
+	if (dst_flag) {
+		nr_pages = cryptodev_num_pages((unsigned long) src,
bufsize);
+		nr_dpages = cryptodev_num_pages((unsigned long) dst,
+						 enc ? bufsize +
authsize :
+						 bufsize - authsize);
+	} else {
+		nr_pages = cryptodev_num_pages((unsigned long) src,
+					enc ? bufsize + authsize :
bufsize);
+	}
+	tmp = aead_alloc_tmp(ses_ptr->tfm_aead, dst_flag ?
+					nr_pages + nr_dpages : nr_pages,
+					assoclen, asg_len);
+	if (!tmp)
+		return -ENOMEM;
+
+	ivp = aead_tmp_iv(tmp, ses_ptr->tfm_aead);
+	assoc = aead_iv_assoc(ivp, ses_ptr->tfm_aead);
+	req = aead_assoc_req(ses_ptr->tfm_aead, assoc, assoclen);
+
+	asg = aead_req_asg(ses_ptr->tfm_aead, req);
+	ssg = aead_asg_sg(asg, asg_len);
+	pages = aead_sg_spages(ssg, nr_pages);
+
+	dsg = dst_flag ? aead_spages_dsg(pages, nr_pages) : ssg;
+	dpages = dst_flag ? aead_dsg_dpages(dsg, nr_dpages) : pages;
+
+	if (dst_flag) {
+		ret = cryptodev_set_user_pages(src, ssg, pages, bufsize,
+						&nr_pages, &null_buf);
+
+		if (ret)
+			goto out_tmp;
+		ret = cryptodev_set_user_pages(dst, dsg, dpages,
+					enc ? bufsize + authsize :
+					bufsize - authsize,
+					&nr_dpages, &null_buf);
+		if (ret)
+			goto out_spages;
+	} else {
+		ret = cryptodev_set_user_pages(src, ssg, pages,
+				enc ? bufsize + authsize : bufsize,
+				&nr_pages, &null_buf);
+		if (ret)
+			goto out_tmp;
+	}
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  cryptodev_async_complete, &result);
+
+	if (cop->iv && copy_from_user(ivp, cop->iv, ivsize)) {
+		printk(KERN_ERR PFX "sid %p failed to copy src iv from "
+			"user space for aead\n", ses_ptr);
+		ret = -EFAULT;
+		goto out_dpages;
+	}
+
+	if (cop->assoc && copy_from_user(assoc, cop->assoc,
cop->assoclen)) {
+		printk(KERN_ERR PFX "sid %p failed to copy src assoc
from "
+			"user space for aead\n", ses_ptr);
+		ret = -EFAULT;
+		goto out_dpages;
+	}
+
+	/* Additional Associated data */
+	sg_init_one(&asg[0], assoc, cop->assoclen);
+
+	aead_request_set_crypt(req, ssg, dsg, bufsize, ivp);
+	aead_request_set_assoc(req, asg, cop->assoclen);
+
+	atomic_inc(&ses_ptr->refcnt);
+	if (cop->op == COP_ENCRYPT)
+		ret = crypto_aead_encrypt(req);
+	else
+		ret = crypto_aead_decrypt(req);
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+		/* fall through */
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
+		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
+			ses_ptr, -ret);
+		break;
+	}
+	/* Check if last reference */
+	if (atomic_dec_return(&ses_ptr->refcnt) == 0)
+		cryptodev_destroy_session(ses_ptr);
+
+out_dpages:
+	if (dst_flag)
+		cryptodev_release_pages(dpages, nr_dpages);
+out_spages:
+	cryptodev_release_pages(pages, nr_pages);
+
+out_tmp:
+	kfree(null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**********************************************************************
******
+ * Helper Functions for the Hash mode
+
************************************************************************
****
+ */
+static void *ahash_alloc_tmp(struct crypto_ahash *ahash, int sg_size)
+{
+	unsigned int len;
+
+	len = sizeof(char) * 64;
+
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+
+	len += sizeof(struct ahash_request) +
crypto_ahash_reqsize(ahash);
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+
+	len += sizeof(struct scatterlist) * sg_size;
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
+	req = (void *) PTR_ALIGN(digest, crypto_tfm_ctx_alignment());
+	ahash_request_set_tfm(req, ahash);
+	return req;
+
+}
+
+static inline struct scatterlist *ahash_req_sg(struct crypto_ahash
*ahash,
+					     struct ahash_request *req)
+{
+	return (void *) ALIGN((unsigned long)(req + 1) +
+				crypto_ahash_reqsize(ahash),
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **ahash_sg_pages(struct scatterlist *sg,
+						int sg_size)
+{
+	return (void *) ALIGN((unsigned long)sg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static int cryptodev_run_ahash(struct csession *ses_ptr,
+				struct crypt_op *cop)
+{
+	char __user *src;
+	char __user *mac;
+	char *null_buf = NULL;
+	struct scatterlist *asg;
+	struct ahash_request *req;
+	struct async_result result;
+	size_t authsize;
+	size_t bufsize;
+	int ret;
+	char *digest;
+	void *tmp;
+	int nr_pages;
+	struct page **pages = NULL;
+
+	/* Checking the Input Length */
+	bufsize = cop->len;
+	src = cop->src;
+	mac = cop->mac;
+
+	nr_pages = cryptodev_num_pages((unsigned long) src, bufsize);
+
+	init_completion(&result.completion);
+
+	tmp = ahash_alloc_tmp(ses_ptr->tfm_ahash, nr_pages);
+	if (!tmp)
+		return -ENOMEM;
+
+	/* Setting the resquest, Digest, and sg */
+	digest = tmp;
+	req = ahash_digest_req(ses_ptr->tfm_ahash, digest);
+	asg = ahash_req_sg(ses_ptr->tfm_ahash, req);
+	pages = ahash_sg_pages(asg, nr_pages);
+
+	authsize = crypto_ahash_digestsize(ses_ptr->tfm_ahash);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete,
&result);
+
+	ret = cryptodev_set_user_pages(src, asg, pages, bufsize,
+					&nr_pages, &null_buf);
+	if (ret)
+		goto out_tmp;
+
+	ahash_request_set_crypt(req, asg, digest, bufsize);
+
+	atomic_inc(&ses_ptr->refcnt);
+	ret = crypto_ahash_digest(req);
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
+		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
+			ses_ptr, -ret);
+		/* Check if last reference */
+		if (atomic_dec_return(&ses_ptr->refcnt) == 0)
+			cryptodev_destroy_session(ses_ptr);
+		goto out_pages;
+	}
+
+	CRYPTODEV_HEXDUMP(digest, authsize);
+	if (copy_to_user(mac, digest, authsize)) {
+		printk(KERN_ERR PFX "sid %p failed to copy mac data to "
+			"user space for hash\n", ses_ptr);
+		ret = -EFAULT;
+	}
+
+	/* Check if last reference */
+	if (atomic_dec_return(&ses_ptr->refcnt) == 0)
+		cryptodev_destroy_session(ses_ptr);
+
+out_pages:
+	cryptodev_release_pages(pages, nr_pages);
+out_tmp:
+	kfree(null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**********************************************************************
*****
+ * This is the actual hash function that creates the
+ * authenticated data
+
************************************************************************
***
+ */
+static void *ablkcipher_alloc_tmp(struct crypto_ablkcipher *ablkcipher,
+					int sg_size)
+{
+	unsigned int len;
+
+	len = crypto_ablkcipher_ivsize(ablkcipher);
+
+	if (len) {
+		len += crypto_ablkcipher_alignmask(ablkcipher) &
+		       ~(crypto_tfm_ctx_alignment() - 1);
+		len = ALIGN(len, crypto_tfm_ctx_alignment());
+	}
+
+	len += sizeof(struct ablkcipher_request) +
+				crypto_ablkcipher_reqsize(ablkcipher);
+
+	len = ALIGN(len, __alignof__(struct scatterlist));
+
+	len += sizeof(struct scatterlist) * sg_size;
+
+	len = ALIGN(len, __alignof__(struct page *));
+
+	len += sizeof(struct page *) * sg_size;
+
+	return kzalloc(len, GFP_KERNEL);
+}
+
+static inline char *ablkcipher_tmp_iv(void *tmp,
+			struct crypto_ablkcipher *ablkcipher)
+{
+	return crypto_ablkcipher_ivsize(ablkcipher) ?
+	       PTR_ALIGN((u8 *)tmp,
+			crypto_ablkcipher_alignmask(ablkcipher) + 1) :
tmp;
+}
+
+static inline struct ablkcipher_request *ablkcipher_tmp_req
+					(struct crypto_ablkcipher
+					 *ablkcipher, char *iv)
+{
+	struct ablkcipher_request *req;
+
+	req = (void *) PTR_ALIGN((unsigned long)iv +
+				crypto_ablkcipher_ivsize(ablkcipher),
+				crypto_tfm_ctx_alignment());
+	ablkcipher_request_set_tfm(req, ablkcipher);
+	return req;
+}
+
+static inline struct scatterlist *ablkcipher_req_sg(
+				struct crypto_ablkcipher *ablkcipher,
+				struct ablkcipher_request *req)
+{
+	return (void *) ALIGN((unsigned long) (req + 1) +
+				crypto_ablkcipher_reqsize(ablkcipher),
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **ablkcipher_sg_spages(struct scatterlist
*sg,
+						int sg_size)
+{
+	return (void *) ALIGN((unsigned long) sg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+static inline struct scatterlist *ablkcipher_spages_dsg
+					(struct page **pages, int len)
+{
+	return (void *) ALIGN((unsigned long) pages +
+				sizeof(struct page *) * len,
+				__alignof__(struct scatterlist));
+}
+
+static inline struct page **ablkcipher_dsg_dpages(struct scatterlist
*dsg,
+						int sg_size)
+{
+	return (void *) ALIGN((unsigned long) dsg +
+				sizeof(struct scatterlist) * sg_size,
+				__alignof__(struct page *));
+}
+
+/**********************************************************************
*****
+ * This is the actual crypto function that creates the
+ * encrypted or decrypted data
+
************************************************************************
***
+ */
+static int cryptodev_run_acipher(struct csession *ses_ptr,
+				struct crypt_op *cop)
+{
+	char *ivp = NULL;
+	char __user *src;
+	char __user *dst;
+	char *null_buf = NULL;
+	void *tmp;
+	struct scatterlist *asg;
+	struct scatterlist *dsg;
+	struct ablkcipher_request *req;
+	struct async_result result;
+	size_t bufsize;
+	size_t ivsize;
+	int ret;
+	int nr_pages;
+	int nr_dpages;
+	struct page **pages = NULL;
+	struct page **dpages = NULL;
+	int dst_flag;
+
+	/* Setting the Input params */
+	bufsize = cop->len;
+	src = cop->src;
+	dst = cop->dst;
+	dst_flag = src != dst;
+
+	init_completion(&result.completion);
+
+	nr_pages = cryptodev_num_pages((unsigned long) src, bufsize);
+	if (dst_flag)
+		nr_dpages = cryptodev_num_pages((unsigned long) dst,
+						bufsize);
+
+	tmp = ablkcipher_alloc_tmp(ses_ptr->tfm_ablkcipher,
+				dst_flag ? (nr_pages + nr_dpages) :
+					   nr_pages);
+	if (!tmp)
+		return -ENOMEM;
+
+	/* Setting the resquest, Digest, and sg */
+	ivp = ablkcipher_tmp_iv(tmp, ses_ptr->tfm_ablkcipher);
+	req = ablkcipher_tmp_req(ses_ptr->tfm_ablkcipher, ivp);
+	asg = ablkcipher_req_sg(ses_ptr->tfm_ablkcipher, req);
+	pages = ablkcipher_sg_spages(asg, nr_pages);
+
+	dsg = dst_flag ? ablkcipher_spages_dsg(pages, nr_pages) : asg;
+	dpages = dst_flag ? ablkcipher_dsg_dpages(dsg, nr_dpages) :
pages;
+
+	if (bufsize %
crypto_ablkcipher_blocksize(ses_ptr->tfm_ablkcipher)) {
+		printk(KERN_ERR PFX
+			"data size (%zu) isn't a multiple"
+			" of block size (%u)\n",
+			bufsize, crypto_ablkcipher_blocksize
+			(ses_ptr->tfm_ablkcipher));
+		ret = -EINVAL;
+		goto out_tmp;
+	}
+
+	ivsize = crypto_ablkcipher_ivsize(ses_ptr->tfm_ablkcipher);
+
+	if (cop->iv && copy_from_user(ivp, cop->iv, ivsize)) {
+		printk(KERN_ERR PFX "failed to copy src iv from user "
+			"space for block cipher\n");
+		ret = -EFAULT;
+		goto out_tmp;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					cryptodev_async_complete,
&result);
+
+	ret = cryptodev_set_user_pages(src, asg, pages, bufsize,
+					&nr_pages, &null_buf);
+	if (ret)
+		goto out_tmp;
+
+	if (dst_flag) {
+		ret = cryptodev_set_user_pages(dst, dsg, dpages,
bufsize,
+					&nr_dpages, &null_buf);
+		if (ret)
+			goto out_spages;
+
+	}
+
+	ablkcipher_request_set_crypt(req, asg, dsg, bufsize, ivp);
+
+	atomic_inc(&ses_ptr->refcnt);
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
+		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
+			ses_ptr, -ret);
+		break;
+	}
+	/* Check if last reference */
+	if (atomic_dec_return(&ses_ptr->refcnt) == 0)
+		cryptodev_destroy_session(ses_ptr);
+
+	if (dst_flag)
+		cryptodev_release_pages(dpages, nr_dpages);
+out_spages:
+	cryptodev_release_pages(pages, nr_pages);
+
+out_tmp:
+
+	kfree(null_buf);
+	kfree(tmp);
+
+	return ret;
+}
+
+/**********************************************************************
*****
+ * Helper Functions for Page Creation and deletion.
+
************************************************************************
***
+ */
+static int cryptodev_num_pages(unsigned long data, int bufsize)
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
+void cryptodev_release_pages(struct page **pages, int nr_pages)
+{
+	int x;
+	struct page *Page;
+
+	for (x = 0; x < nr_pages; x++) {
+		Page = pages[x];
+		SetPageDirty(Page);
+		page_cache_release(Page);
+	}
+}
+
+static int cryptodev_set_user_pages(char __user *src, struct
scatterlist *sg,
+					struct page **pages, int
bufsize,
+					int *nr_pages, char **null_buf)
+{
+	unsigned long offset;
+	struct page *Page = NULL;
+	int x;
+	int rop;
+	int err;
+
+	if (!src) {
+		*nr_pages = 0;
+		CRYPTODEV_PRINTK(1, KERN_INFO, "case of null buffer\n");
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
+		Page = pages[0];
+		CRYPTODEV_PRINTK(2, KERN_INFO,
+				"single buffer implementation\n");
+		sg_set_page(&sg[0], Page, bufsize, offset);
+		return 0;
+	}
+
+	sg_init_table(sg, *nr_pages);
+	for (x = 0; x < *nr_pages; x++) {
+		Page = pages[x];
+		if (!Page || IS_ERR(Page)) {
+			printk(KERN_ERR PFX "missing page in "
+				"DumpUserPages %d\n", x);
+			return -EFAULT;
+		}
+		sg_set_page(&sg[x], Page, bufsize, offset);
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
+/**********************************************************************
*****
+ * Helper Functions for File Descriptor setting and releasing
+
************************************************************************
***
+ */
+static int cryptodev_open(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static int cryptodev_release(struct inode *inode, struct file *filp)
+{
+	struct csession *ses_ptr = filp->private_data;
+
+	if (!ses_ptr)
+		return 0;
+
+	if (atomic_dec_return(&ses_ptr->refcnt) == 0) {
+		cryptodev_destroy_session(ses_ptr);
+		filp->private_data = NULL;
+	} else {
+		printk(KERN_WARNING PFX
+			"session id %p operation still pending, "
+			"delay deletion\n", ses_ptr);
+	}
+	return 0;
+}
+
+static int cryptodev_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	struct session_op sop;
+	struct crypt_op   cop;
+	struct csession *ses_ptr;
+	int ret;
+
+	switch (cmd) {
+	case CIOCGSESSION:
+		if (copy_from_user(&sop, (void *) arg, sizeof(sop))) {
+			printk(KERN_ERR PFX "Copy of Session data
failed"
+				"at CIOCGSESSION from user space\n");
+			return -EFAULT;
+		}
+		if (filp->private_data) {
+			printk(KERN_ERR PFX "Session data already
sets\n");
+			return -EINVAL;
+		}
+		ses_ptr = NULL;	/* init to NULL to mute compiler warning
*/
+		ret = cryptodev_create_session(&ses_ptr, &sop);
+		if (ret)
+			return ret;
+		filp->private_data = ses_ptr;
+		return ret;
+
+	case CIOCCRYPT:
+		if (copy_from_user(&cop, (void *) arg, sizeof(cop))) {
+			printk(KERN_ERR PFX "Copy of src data failed"
+				"at CIOCCRYPT from user space\n");
+			return -EFAULT;
+		}
+		ses_ptr = filp->private_data;
+		if (!ses_ptr) {
+			printk(KERN_ERR PFX "Session data does not
exist\n");
+			return -EINVAL;
+		}
+		return cryptodev_run(ses_ptr, &cop);
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
+		printk(KERN_ERR PFX
+			"failed to register /dev/crypto error %d \n",
rc);
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
+/**********************************************************************
*****
+ * Module init/exit
+
************************************************************************
***
+ */
+int __init init_cryptodev(void)
+{
+	int rc;
+
+	rc = cryptodev_register();
+	if (rc)
+		return rc;
+	printk(KERN_INFO "User space CryptoAPI driver v%s loaded\n",
+		CRYPTODEV_VER);
+
+	return 0;
+}
+
+void __exit exit_cryptodev(void)
+{
+	cryptodev_deregister();
+	printk(KERN_INFO "User space CryptoAPI driver v%s unloaded\n",
+		CRYPTODEV_VER);
+}
+
+module_init(init_cryptodev);
+module_exit(exit_cryptodev);
+
+MODULE_AUTHOR("Shasi Pulijala <spulijala@amcc.com>");
+MODULE_DESCRIPTION("Linux CryptoAPI user space driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/cryptodev.h b/include/linux/cryptodev.h
new file mode 100644
index 0000000..24edb38
--- /dev/null
+++ b/include/linux/cryptodev.h
@@ -0,0 +1,74 @@
+/**********************************************************************
******
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
****
+ */
+
+#ifndef __CRYPTODEV_H__
+#define __CRYPTODEV_H__
+
+/**********************************************************************
******
+ * @struct session_op
+ * @brief ioctl parameter to create a session
+ *
+
************************************************************************
****
+ */
+struct session_op {
+	caddr_t		alg_name;
+	unsigned int	keylen;		/* cipher key */
+	caddr_t		key;
+	int		mackeylen;	/* mac key length*/
+	caddr_t		mackey;		/* mackey(hmac)*/
+	int		icvlen;		/*authsize (ccm, gcm)*/
+
+};
+
+/**********************************************************************
******
+ * @struct crypt_op
+ * @brief ioctl parameter to request a crypt/decrypt operation
+ * against a session
+ *
+
************************************************************************
*****
+ */
+struct crypt_op {
+	unsigned short	op;		/* i.e. COP_ENCRYPT */
+#define COP_NONE	0
+#define COP_ENCRYPT	1
+#define COP_DECRYPT	2
+	unsigned short	flags;
+#define	COP_F_BATCH	0x0008		/* Batch op if possible
*/
+	unsigned int	len;
+	caddr_t		src;		/* become sg inside kernel */
+	caddr_t		dst;		/* become sg inside kernel */
+	caddr_t		mac;		/* must be big enough for chosen
MAC */
+	caddr_t		iv;
+	caddr_t		assoc;		/* Associated data for Combined
Mode */
+	unsigned int 	assoclen;
+};
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
+
+/* request encryption/decryptions of a given buffer */
+#define CIOCCRYPT       _IOWR('c', 103, struct crypt_op)
+
+#endif
-- 
1.5.4.4

