From: Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 1/4][RFC v2] PM / Hibernate: Add helper functions for hibernation encryption
Date: Thu, 19 Jul 2018 00:39:29 +0800
Message-ID: <d53d8e71481d085d135f011704ccf65b5c7a4316.1531924968.git.yu.c.chen@intel.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
Cc: Rui Zhang <rui.zhang@intel.com>,
        "Gu, Kookoo" <kookoo.gu@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Eric Biggers <ebiggers@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-pm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1531924968.git.yu.c.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Basically, the in-kernel hibernation encryption solution is
to encrypt the pages before they go to the block device.

Why we do this?
1. One advantage is: Users do not have to
   encrypt the whole swap partition as other tools.
2. Ideally kernel memory should be encrypted by the
   kernel itself. We have uswsusp to support user
   space hibernation, however doing the encryption
   in kernel space has more advantages:
   2.1 Not having to transfer plain text kernel memory to
       user space. Per Lee, Chun-Yi, uswsusp is disabled
       when the kernel is locked down:
       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
       linux-fs.git/commit/?h=lockdown-20180410&
       id=8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
       due to:
       "There have some functions be locked-down because
       there have no appropriate mechanisms to check the
       integrity of writing data."
   2.2 Not having to copy each page to user space
       one by one not in parallel, which might introduce
       significant amount of copy_to_user() and it might
       not be efficient on servers having large amount of DRAM.
   2.3 Distribution has requirement to do snapshot
       signature for verification, which can be built
       by leveraging this patch set.
   2.4 The encryption is in the kernel, so it doesn't
       have to worry too much about bugs in user space
       utilities and similar, for example.

For the key derivation solution, there was a discussion
on the mailing list on whether the key should be derived
in kernel or in user space. And it turns out to be generating
the key by user space is more applicable[1]. So the procedure
is illustrated below:

1. The user space reads the salt from kernel and
   generates a symmetrical key(512bits for now)
   based on user passphrase. Then the kernel uses
   that key to encrypt the hibernation image.
2. The salt will be saved in image header and passed to
   the restore kernel.
3. During restore, the userspace reads the salt
   from the kernel first and then probe passphrase
   from the user to generate the same key and pass
   that key back to kernel.
4. The restore kernel uses that key to decrypt the image.

[1] https://www.spinics.net/lists/linux-crypto/msg33145.html

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Stephan Mueller <smueller@chronox.de>
Cc: Denis Kenzior <denkenz@gmail.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 kernel/power/Kconfig              |  14 ++
 kernel/power/Makefile             |   1 +
 kernel/power/crypto_hibernation.c | 411 ++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h              |  42 ++++
 4 files changed, 468 insertions(+)
 create mode 100644 kernel/power/crypto_hibernation.c

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index e880ca2..fd39c30 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -101,6 +101,20 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
+config CRYPTO_HIBERNATION
+	tristate "Encryption/signature of snapshot for hibernation"
+	depends on HIBERNATION && CRYPTO_AES && CRYPTO_HASH2 && KEYS
+	default n
+	help
+	  Allow the kernel to encrypt/signature the snapshot data
+	  based on user provided passphrase. The user should provide
+	  a valid symmetrical key to the kernel either by ioctl or
+	  by keyctl, so the kernel could use that key either to encrypt
+	  the hibernation snapshot pages, or get signature of these pages.
+	  The user facility could be found under tools/power/crypto/.
+
+	  If in doubt, say N.
+
 config PM_SLEEP
 	def_bool y
 	depends on SUSPEND || HIBERNATE_CALLBACKS
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index a3f79f0e..52c68a4 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
+obj-$(CONFIG_CRYPTO_HIBERNATION) += crypto_hibernation.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+= wakelock.o
 
diff --git a/kernel/power/crypto_hibernation.c b/kernel/power/crypto_hibernation.c
new file mode 100644
index 0000000..406bb0c
--- /dev/null
+++ b/kernel/power/crypto_hibernation.c
@@ -0,0 +1,411 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/kernel/power/crypto_hibernation.c
+ *
+ * This file provides in-kernel encrypted/signature hibernation support.
+ *
+ * Copyright (c) 2018, Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ * Copyright (c) 2018, Chen, Yu <yu.c.chen@intel.com>
+ * Copyright (c) 2018, Lee, Chun-Yi <jlee@suse.com>
+ *
+ * Basically, this solution encrypts the pages before they go to
+ * the block device, the procedure is illustrated below:
+ * 1. The user space reads the salt from the kernel, generates
+ *    a symmetrical key, the kernel uses that key to encrypt the
+ *    hibernation image.
+ * 2. The salt is saved in image header and passed to
+ *    the restore kernel.
+ * 3. During restore, the userspace needs to read the salt
+ *    from the kernel and probe passphrase from the user
+ *    to generate the key and pass that key back to kernel.
+ * 4. The restore kernel uses that key to decrypt the image.
+ *
+ * After all, ideally kernel memory should be encrypted
+ * by the kernel itself.
+ */
+#define pr_fmt(fmt) "PM: " fmt
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/cdev.h>
+#include <linux/major.h>
+#include <crypto/skcipher.h>
+#include <crypto/akcipher.h>
+#include <crypto/aes.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include "power.h"
+
+static int crypto_data(const char *inbuf,
+			    int inlen,
+			    char *outbuf,
+			    int outlen,
+			    unsigned int cmd,
+			    int page_idx);
+static void crypto_save(void *buf);
+static void crypto_restore(void *buf);
+static int crypto_init(bool suspend);
+
+static struct hibernation_crypto hib_crypto;
+
+/* return the key value. */
+static char *get_key_ptr(void)
+{
+	return hib_crypto.keys.derived_key;
+}
+
+/* return the salt value. */
+static char *get_salt_ptr(void)
+{
+	return hib_crypto.keys.salt;
+}
+
+/* Encrypt algorithm. */
+static struct hibernate_crypt_mode {
+	const char *friendly_name;
+	const char *cipher_str;
+	int keysize;
+} available_modes[] = {
+	[HIBERNATE_ENCRYPTION_MODE_AES_256_XTS] = {
+		.friendly_name = "AES-256-XTS",
+		.cipher_str = "xts(aes)",
+		.keysize = 64,
+	},
+};
+
+/**
+ * crypto_data() - en/decrypt/digest the data
+ * @inbuf: the source buffer
+ * @inlen: the length of source buffer
+ * @outbuf: the dest buffer
+ * @outlen: the length of dest buffer
+ * @cmd: combination mask of encrypt/decrypt/signature
+ * @page_idx: the index of that page been manipulated
+ *
+ * Return: 0 on success, non-zero for other cases.
+ *
+ * Better use SKCIPHER_REQUEST_ON_STACK to support multi-thread
+ * encryption, however hibernation does not support multi-threaded
+ * swap page write out due to the fact that the swap_map has to be
+ * accessed sequently.
+ */
+static int crypto_data(const char *inbuf,
+			    int inlen,
+			    char *outbuf,
+			    int outlen,
+			    unsigned int cmd,
+			    int page_idx)
+{
+	struct scatterlist src, dst;
+	int ret;
+	struct {
+		__le64 idx;
+		u8 padding[HIBERNATE_IV_SIZE - sizeof(__le64)];
+	} iv;
+
+	if (cmd | CMD_CRYPT) {
+		bool encrypt = (cmd & CMD_ENCRYPT) ? true : false;
+
+		iv.idx = cpu_to_le64(page_idx);
+		memset(iv.padding, 0, sizeof(iv.padding));
+
+		/*
+		 * Do a AES-256 encryption on every page-index
+		 * to generate the IV.
+		 */
+		crypto_cipher_encrypt_one(hib_crypto.essiv_tfm, (u8 *)&iv,
+								(u8 *)&iv);
+		sg_init_one(&src, inbuf, inlen);
+		sg_init_one(&dst, outbuf, outlen);
+		skcipher_request_set_crypt(hib_crypto.req_sk,
+						&src, &dst, outlen, &iv);
+
+		if (encrypt)
+			ret = crypto_skcipher_encrypt(hib_crypto.req_sk);
+		else
+			ret = crypto_skcipher_decrypt(hib_crypto.req_sk);
+		if (ret)
+			pr_err("%s %scrypt failed: %d\n", __func__,
+					encrypt ? "en" : "de", ret);
+			goto out;
+	}
+
+ out:
+	return ret;
+}
+
+/* Invoked across hibernate/restore. */
+static void crypto_save(void *buf)
+{
+	memcpy(buf, get_salt_ptr(), HIBERNATE_MAX_SALT_BYTES);
+}
+
+static void crypto_restore(void *buf)
+{
+	memcpy(get_salt_ptr(), buf, HIBERNATE_MAX_SALT_BYTES);
+}
+
+/*
+ * Copied from init_essiv_generator().
+ * Using SHA256 to derive the key and
+ * save it.
+ */
+static int init_iv_generator(const u8 *raw_key, int keysize)
+{
+	int ret = -EINVAL;
+	u8 salt[SHA256_DIGEST_SIZE];
+
+	/* 1. IV generator initialization. */
+	if (!hib_crypto.essiv_hash_tfm) {
+		hib_crypto.essiv_hash_tfm = crypto_alloc_shash("sha256", 0, 0);
+		if (IS_ERR(hib_crypto.essiv_hash_tfm)) {
+			pr_err("crypto_hibernate: error allocating SHA-256 transform for IV: %ld\n",
+					    PTR_ERR(hib_crypto.essiv_hash_tfm));
+			return -ENOMEM;
+		}
+	}
+
+	if (!hib_crypto.essiv_tfm) {
+		hib_crypto.essiv_tfm = crypto_alloc_cipher("aes", 0, 0);
+		if (IS_ERR(hib_crypto.essiv_tfm)) {
+			pr_err("crypto_hibernate: error allocating cipher aes for IV generation: %ld\n",
+					PTR_ERR(hib_crypto.essiv_tfm));
+			ret = -ENOMEM;
+			goto free_essiv_hash;
+		}
+	}
+
+	{
+		/* 2. Using hash to generate the 256bits AES key */
+		SHASH_DESC_ON_STACK(desc, hib_crypto.essiv_hash_tfm);
+
+		desc->tfm = hib_crypto.essiv_hash_tfm;
+		desc->flags = 0;
+		ret = crypto_shash_digest(desc, raw_key, keysize, salt);
+		if (ret) {
+			pr_err("crypto_hibernate: error get digest for raw_key\n");
+			goto free_essiv_hash;
+		}
+	}
+	/* 3. Switch to the 256bits AES key for later IV generation. */
+	ret = crypto_cipher_setkey(hib_crypto.essiv_tfm, salt, sizeof(salt));
+
+ free_essiv_hash:
+	crypto_free_shash(hib_crypto.essiv_hash_tfm);
+	hib_crypto.essiv_hash_tfm = NULL;
+	return ret;
+}
+
+static int init_crypto_helper(void)
+{
+	int ret = 0;
+	struct hibernate_crypt_mode *mode;
+
+	/* Choose the user specified encryption algorithm */
+	mode = &available_modes[hib_crypto.keys.contents_encryption_mode];
+	if (IS_ERR(mode))
+		return -EINVAL;
+
+	pr_info("Hibernate crypto: choose %s for encryption.\n",
+			mode->friendly_name);
+	/* Symmetric encryption initialization. */
+	if (!hib_crypto.tfm_sk) {
+		hib_crypto.tfm_sk =
+			crypto_alloc_skcipher(mode->cipher_str,
+					0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hib_crypto.tfm_sk)) {
+			pr_err("Failed to load transform for aes: %ld\n",
+				PTR_ERR(hib_crypto.tfm_sk));
+			return -ENOMEM;
+		}
+	}
+
+	if (!hib_crypto.req_sk) {
+		hib_crypto.req_sk =
+			skcipher_request_alloc(hib_crypto.tfm_sk, GFP_KERNEL);
+		if (!hib_crypto.req_sk) {
+			pr_err("Failed to allocate request\n");
+			ret = -ENOMEM;
+			goto free_tfm_sk;
+		}
+	}
+	skcipher_request_set_callback(hib_crypto.req_sk, 0, NULL, NULL);
+
+	/* Switch to the image key, and prepare for page en/decryption. */
+	ret = crypto_skcipher_setkey(hib_crypto.tfm_sk, get_key_ptr(),
+				     mode->keysize);
+	if (ret) {
+		pr_err("Failed to set the image key. (%d)\n", ret);
+		goto free_req_sk;
+	}
+
+	ret = init_iv_generator(get_key_ptr(),
+							mode->keysize);
+	if (ret) {
+		pr_err("Failed to init the iv generator. (%d)\n", ret);
+		goto free_req_sk;
+	}
+	return 0;
+
+ free_req_sk:
+	skcipher_request_free(hib_crypto.req_sk);
+	hib_crypto.req_sk = NULL;
+ free_tfm_sk:
+	crypto_free_skcipher(hib_crypto.tfm_sk);
+	hib_crypto.tfm_sk = NULL;
+	return ret;
+}
+
+/*
+ * Either invoked during suspend or resume.
+ */
+static int crypto_init(bool suspend)
+{
+	int ret = 0;
+
+	pr_info("Prepared to %scrypt the image data.\n",
+		  suspend ? "en" : "de");
+	if (!hib_crypto.keys.user_key_valid) {
+		pr_err("Need to get user provided key first!(eg, via ioctl)\n");
+		return -EINVAL;
+	}
+
+	ret = init_crypto_helper();
+	if (ret) {
+		pr_err("Failed to initialize basic crypto helpers. (%d)\n",
+			ret);
+		return ret;
+	}
+
+	pr_info("Key generated, waiting for data encryption/decrytion.\n");
+	return 0;
+}
+
+/* key/salt probing via ioctl. */
+dev_t crypto_dev;
+static struct class *crypto_dev_class;
+static struct cdev crypto_cdev;
+
+#define HIBERNATE_SALT_READ		_IOW('C', 0x18, int)
+#define HIBERNATE_KEY_WRITE		_IOW('C', 0x19, int)
+
+static DEFINE_MUTEX(crypto_mutex);
+
+static long crypto_ioctl(struct file *file, unsigned int cmd,
+			 unsigned long arg)
+{
+	int ret = 0;
+
+	mutex_lock(&crypto_mutex);
+	switch (cmd) {
+	case HIBERNATE_SALT_READ:
+		if (copy_to_user((void __user *)arg,
+				 get_salt_ptr(),
+				 HIBERNATE_MAX_SALT_BYTES))
+			ret = -EFAULT;
+		break;
+	case HIBERNATE_KEY_WRITE:
+		if (copy_from_user(&hib_crypto.keys,
+				   (void __user *)arg,
+				   sizeof(struct hibernation_crypto_keys))) {
+			hib_crypto.keys.user_key_valid = 0;
+			ret = -EFAULT;
+		} else
+			hib_crypto.keys.user_key_valid = 1;
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&crypto_mutex);
+
+	return ret;
+}
+
+static int crypto_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int crypto_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static const struct file_operations crypto_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= crypto_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= crypto_ioctl,
+#endif
+	.open		= crypto_open,
+	.release	= crypto_release,
+	.llseek		= noop_llseek,
+};
+
+/*
+ * For key/salt exchange between user and kernel space
+ * via ioctl(TODO: keyring).
+ */
+static int crypto_hibernate_init(void)
+{
+	if ((alloc_chrdev_region(&crypto_dev, 0, 1, "crypto")) < 0) {
+		pr_err("Cannot allocate major number for crypto hibernate.\n");
+		return -ENOMEM;
+	}
+
+	cdev_init(&crypto_cdev, &crypto_fops);
+	crypto_cdev.owner = THIS_MODULE;
+	crypto_cdev.ops = &crypto_fops;
+
+	if ((cdev_add(&crypto_cdev, crypto_dev, 1)) < 0) {
+		pr_err("Cannot add the crypto device.\n");
+		goto r_chrdev;
+	}
+
+	crypto_dev_class = class_create(THIS_MODULE,
+					"crypto_class");
+	if (crypto_dev_class == NULL) {
+		pr_err("Cannot create the crypto_class.\n");
+		goto r_cdev;
+	}
+
+	if ((device_create(crypto_dev_class, NULL, crypto_dev, NULL,
+					"crypto_hibernate")) == NULL){
+		pr_err("Cannot create the crypto device node.\n");
+		goto r_device;
+	}
+	/* generate the random salt */
+	get_random_bytes(get_salt_ptr(), HIBERNATE_MAX_SALT_BYTES);
+
+	return 0;
+
+ r_device:
+	class_destroy(crypto_dev_class);
+ r_cdev:
+	cdev_del(&crypto_cdev);
+ r_chrdev:
+	unregister_chrdev_region(crypto_dev, 1);
+	return -EINVAL;
+}
+
+static void crypto_hibernate_exit(void)
+{
+	device_destroy(crypto_dev_class, crypto_dev);
+	class_destroy(crypto_dev_class);
+	cdev_del(&crypto_cdev);
+	unregister_chrdev_region(crypto_dev, 1);
+}
+
+MODULE_AUTHOR("Yu Chen <yu.c.chen@intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hibernation crypto facility");
+
+module_init(crypto_hibernate_init);
+module_exit(crypto_hibernate_exit);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 9e58bdc..a539bdb 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -69,6 +69,48 @@ extern void enable_restore_image_protection(void);
 static inline void enable_restore_image_protection(void) {}
 #endif /* CONFIG_STRICT_KERNEL_RWX */
 
+#if IS_ENABLED(CONFIG_CRYPTO_HIBERNATION)
+#define HIBERNATE_MAX_SALT_BYTES	16
+#define HIBERNATE_MAX_KEY_BYTES	64
+#define HIBERNATE_IV_SIZE	16
+
+/* Do data encryption */
+#define CMD_ENCRYPT	0x1
+/* Do data decryption */
+#define CMD_DECRYPT	0x2
+/* Do data signature update */
+#define CMD_SIG_UPDATE	0x4
+/* Do data signature final */
+#define CMD_SIG_FINAL	0x8
+#define CMD_CRYPT	(CMD_ENCRYPT | CMD_DECRYPT)
+
+/* Add any encryption algorithm here. */
+#define HIBERNATE_ENCRYPTION_MODE_AES_256_XTS 1
+
+struct hibernation_crypto_keys {
+	char derived_key[HIBERNATE_MAX_KEY_BYTES];
+	char salt[HIBERNATE_MAX_SALT_BYTES];
+	int	contents_encryption_mode;
+	int user_key_valid;
+};
+
+struct hibernation_crypto {
+	/* For data encryption */
+	struct crypto_skcipher *tfm_sk;
+	struct skcipher_request *req_sk;
+
+	/* For IV generation */
+	struct crypto_cipher *essiv_tfm;
+	struct crypto_shash *essiv_hash_tfm;
+
+	/* Private key info */
+	struct hibernation_crypto_keys keys;
+};
+
+#else
+#define HIBERNATE_MAX_SALT_BYTES	0
+#endif
+
 #else /* !CONFIG_HIBERNATION */
 
 static inline void hibernate_reserved_size_init(void) {}
-- 
2.7.4
