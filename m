From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5] KEYS: add SP800-56A KDF support for DH
Date: Fri, 19 Aug 2016 20:39:09 +0200
Message-ID: <1571629.ErTDR5PMQO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37026 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753671AbcHSSlE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 14:41:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch now folds the KDF into the keys support as requested by
Herbert. The caller can only supply the hash name used for the KDF.

Note, the KDF implementation is identical to the kdf_ctr() support in
the now unneeded KDF patches to the kernel crypto API.

The new patch also changes the variable name from kdfname to hashname.

Also, the patch adds a missing semicolon.

Finally, the patch adds a guard against compiling the compat code
if the general Linux kernel configuration does not have the compat
code enabled. Without that guard, compilation warnings are seen.

---8<---

SP800-56A defines the use of DH with key derivation function based on a
counter. The input to the KDF is defined as (DH shared secret || other
information). The value for the "other information" is to be provided by
the caller.

The KDF is implemented using the hash support from the kernel crypto API.
The implementation uses the symmetric hash support as the input to the
hash operation is usually very small. The caller is allowed to specify
the hash name that he wants to use to derive the key material allowing
the use of all supported hashes provided with the kernel crypto API.

As the KDF implements the proper truncation of the DH shared secret to
the requested size, this patch fills the caller buffer up to its size.

The patch is tested with a new test added to the keyutils user space
code which uses a CAVS test vector testing the compliance with
SP800-56A.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/security/keys.txt |  34 ++++--
 include/linux/compat.h          |   7 ++
 include/uapi/linux/keyctl.h     |   7 ++
 security/keys/Kconfig           |   1 +
 security/keys/Makefile          |   3 +-
 security/keys/compat.c          |   5 +-
 security/keys/compat_dh.c       |  38 +++++++
 security/keys/dh.c              | 222 +++++++++++++++++++++++++++++++++++++---
 security/keys/internal.h        |  24 ++++-
 security/keys/keyctl.c          |   2 +-
 10 files changed, 317 insertions(+), 26 deletions(-)
 create mode 100644 security/keys/compat_dh.c

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 3849814..58fcae7 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -827,7 +827,7 @@ The keyctl syscall functions are:
 
        long keyctl(KEYCTL_DH_COMPUTE, struct keyctl_dh_params *params,
 		   char *buffer, size_t buflen,
-		   void *reserved);
+		   struct keyctl_kdf_params *kdf);
 
      The params struct contains serial numbers for three keys:
 
@@ -844,18 +844,36 @@ The keyctl syscall functions are:
      public key.  If the base is the remote public key, the result is
      the shared secret.
 
-     The reserved argument must be set to NULL.
+     If the parameter kdf is NULL, the following applies:
 
-     The buffer length must be at least the length of the prime, or zero.
+	 - The buffer length must be at least the length of the prime, or zero.
 
-     If the buffer length is nonzero, the length of the result is
-     returned when it is successfully calculated and copied in to the
-     buffer. When the buffer length is zero, the minimum required
-     buffer length is returned.
+	 - If the buffer length is nonzero, the length of the result is
+	   returned when it is successfully calculated and copied in to the
+	   buffer. When the buffer length is zero, the minimum required
+	   buffer length is returned.
+
+     The kdf parameter allows the caller to apply a key derivation function
+     (KDF) on the Diffie-Hellman computation where only the result
+     of the KDF is returned to the caller. The KDF is characterized with
+     struct keyctl_kdf_params as follows:
+
+	 - char *hashname specifies the NUL terminated string identifying
+	   the hash used from the kernel crypto API and applied for the KDF
+	   operation. The KDF implemenation complies with SP800-56A as well
+	   as with SP800-108 (the counter KDF).
+
+	 - char *otherinfo specifies the OtherInfo data as documented in
+	   SP800-56A section 5.8.1.2. The length of the buffer is given with
+	   otherinfolen. The format of OtherInfo is defined by the caller.
+	   The otherinfo pointer may be NULL if no OtherInfo shall be used.
 
      This function will return error EOPNOTSUPP if the key type is not
      supported, error ENOKEY if the key could not be found, or error
-     EACCES if the key is not readable by the caller.
+     EACCES if the key is not readable by the caller. In addition, the
+     function will return EMSGSIZE when the parameter kdf is non-NULL
+     and either the buffer length or the OtherInfo length exceeds the
+     allowed length.
 
 ===============
 KERNEL SERVICES
diff --git a/include/linux/compat.h b/include/linux/compat.h
index f964ef7..f6979d5 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -295,6 +295,13 @@ struct compat_old_sigaction {
 };
 #endif
 
+struct compat_keyctl_kdf_params {
+	compat_uptr_t hashname;
+	compat_uptr_t otherinfo;
+	__u32 otherinfolen;
+	__u32 __spare[8];
+};
+
 struct compat_statfs;
 struct compat_statfs64;
 struct compat_old_linux_dirent;
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 86eddd6..2102822 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -68,4 +68,11 @@ struct keyctl_dh_params {
 	__s32 base;
 };
 
+struct keyctl_kdf_params {
+	char *hashname;
+	char *otherinfo;
+	__u32 otherinfolen;
+	__u32 __spare[8];
+};
+
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index f826e87..00723a8 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -90,6 +90,7 @@ config KEY_DH_OPERATIONS
        bool "Diffie-Hellman operations on retained keys"
        depends on KEYS
        select MPILIB
+       select CRYPTO_HASH
        help
 	 This option provides support for calculating Diffie-Hellman
 	 public keys and shared secrets using values stored as keys
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 1fd4a16..57dff0c 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -15,7 +15,8 @@ obj-y := \
 	request_key.o \
 	request_key_auth.o \
 	user_defined.o
-obj-$(CONFIG_KEYS_COMPAT) += compat.o
+compat-obj-$(CONFIG_KEY_DH_OPERATIONS) += compat_dh.o
+obj-$(CONFIG_KEYS_COMPAT) += compat.o $(compat-obj-y)
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 obj-$(CONFIG_PERSISTENT_KEYRINGS) += persistent.o
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 36c80bf..b674886 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -133,8 +133,9 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
 		return keyctl_get_persistent(arg2, arg3);
 
 	case KEYCTL_DH_COMPUTE:
-		return keyctl_dh_compute(compat_ptr(arg2), compat_ptr(arg3),
-					 arg4, compat_ptr(arg5));
+		return compat_keyctl_dh_compute(compat_ptr(arg2),
+						compat_ptr(arg3),
+						arg4, compat_ptr(arg5));
 
 	default:
 		return -EOPNOTSUPP;
diff --git a/security/keys/compat_dh.c b/security/keys/compat_dh.c
new file mode 100644
index 0000000..a6a659b
--- /dev/null
+++ b/security/keys/compat_dh.c
@@ -0,0 +1,38 @@
+/* 32-bit compatibility syscall for 64-bit systems for DH operations
+ *
+ * Copyright (C) 2016 Stephan Mueller <smueller@chronox.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/uaccess.h>
+
+#include "internal.h"
+
+/*
+ * Perform the DH computation or DH based key derivation.
+ *
+ * If successful, 0 will be returned.
+ */
+long compat_keyctl_dh_compute(struct keyctl_dh_params __user *params,
+			      char __user *buffer, size_t buflen,
+			      struct compat_keyctl_kdf_params __user *kdf)
+{
+	struct keyctl_kdf_params kdfcopy;
+	struct compat_keyctl_kdf_params compat_kdfcopy;
+
+	if (!kdf)
+		return __keyctl_dh_compute(params, buffer, buflen, NULL);
+
+	if (copy_from_user(&compat_kdfcopy, kdf, sizeof(compat_kdfcopy)) != 0)
+		return -EFAULT;
+
+	kdfcopy.hashname = compat_ptr(compat_kdfcopy.hashname);
+	kdfcopy.otherinfo = compat_ptr(compat_kdfcopy.otherinfo);
+	kdfcopy.otherinfolen = compat_kdfcopy.otherinfolen;
+
+	return __keyctl_dh_compute(params, buffer, buflen, &kdfcopy);
+}
diff --git a/security/keys/dh.c b/security/keys/dh.c
index 531ed2e..51ca787 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -12,6 +12,10 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <keys/user-type.h>
+
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+
 #include "internal.h"
 
 /*
@@ -77,9 +81,146 @@ error:
 	return ret;
 }
 
-long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-		       char __user *buffer, size_t buflen,
-		       void __user *reserved)
+struct kdf_sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
+{
+	struct crypto_shash *tfm;
+	struct kdf_sdesc *sdesc;
+	int size;
+
+	/* allocate synchronous hash */
+	tfm = crypto_alloc_shash(hashname, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_info("could not allocate digest TFM handle %s\n", hashname);
+		return PTR_ERR(tfm);
+	}
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(tfm);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return -ENOMEM;
+	sdesc->shash.tfm = tfm;
+	sdesc->shash.flags = 0x0;
+
+	*sdesc_ret = sdesc;
+
+	return 0;
+}
+
+static void kdf_dealloc(struct kdf_sdesc *sdesc)
+{
+	if (!sdesc)
+		return;
+
+	if (sdesc->shash.tfm)
+		crypto_free_shash(sdesc->shash.tfm);
+
+	kzfree(sdesc);
+}
+
+/* convert 32 bit integer into its string representation */
+static inline void crypto_kw_cpu_to_be32(u32 val, u8 *buf)
+{
+	__be32 *a = (__be32 *)buf;
+
+	*a = cpu_to_be32(val);
+}
+
+/*
+ * Implementation of the KDF in counter mode according to SP800-108 section 5.1
+ * as well as SP800-56A section 5.8.1 (Single-step KDF).
+ *
+ * SP800-56A:
+ * The src pointer is defined as Z || other info where Z is the shared secret
+ * from DH and other info is an arbitrary string (see SP800-56A section
+ * 5.8.1.2).
+ */
+static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
+		   u8 *dst, unsigned int dlen)
+{
+	struct shash_desc *desc = &sdesc->shash;
+	unsigned int h = crypto_shash_digestsize(desc->tfm);
+	int err = 0;
+	u8 *dst_orig = dst;
+	u32 i = 1;
+	u8 iteration[sizeof(u32)];
+
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto err;
+
+		crypto_kw_cpu_to_be32(i, iteration);
+		err = crypto_shash_update(desc, iteration, sizeof(u32));
+		if (err)
+			goto err;
+
+		if (src && slen) {
+			err = crypto_shash_update(desc, src, slen);
+			if (err)
+				goto err;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[h];
+
+			err = crypto_shash_final(desc, tmpbuffer);
+			if (err)
+				goto err;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			return 0;
+		} else {
+			err = crypto_shash_final(desc, dst);
+			if (err)
+				goto err;
+
+			dlen -= h;
+			dst += h;
+			i++;
+		}
+	}
+
+	return 0;
+
+err:
+	memzero_explicit(dst_orig, dlen);
+	return err;
+}
+
+static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
+				 char __user *buffer, size_t buflen,
+				 uint8_t *kbuf, size_t kbuflen)
+{
+	uint8_t *outbuf = NULL;
+	int ret;
+
+	outbuf = kmalloc(buflen, GFP_KERNEL);
+	if (!outbuf) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, buflen);
+	if (ret)
+		goto err;
+
+	ret = buflen;
+	if (copy_to_user(buffer, outbuf, buflen) != 0)
+		ret = -EFAULT;
+
+err:
+	kzfree(outbuf);
+	return ret;
+}
+
+long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
+			 char __user *buffer, size_t buflen,
+			 struct keyctl_kdf_params *kdfcopy)
 {
 	long ret;
 	MPI base, private, prime, result;
@@ -88,6 +229,7 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	uint8_t *kbuf;
 	ssize_t keylen;
 	size_t resultlen;
+	struct kdf_sdesc *sdesc = NULL;
 
 	if (!params || (!buffer && buflen)) {
 		ret = -EINVAL;
@@ -98,12 +240,34 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto out;
 	}
 
-	if (reserved) {
-		ret = -EINVAL;
-		goto out;
+	if (kdfcopy) {
+		char *hashname;
+
+		if (buflen > KEYCTL_KDF_MAX_OUTPUT_LEN ||
+		    kdfcopy->otherinfolen > KEYCTL_KDF_MAX_OI_LEN) {
+			ret = -EMSGSIZE;
+			goto out;
+		}
+
+		/* get KDF name string */
+		hashname = strndup_user(kdfcopy->hashname, CRYPTO_MAX_ALG_NAME);
+		if (IS_ERR(hashname)) {
+			ret = PTR_ERR(hashname);
+			goto out;
+		}
+
+		/* allocate KDF from the kernel crypto API */
+		ret = kdf_alloc(&sdesc, hashname);
+		kfree(hashname);
+		if (ret)
+			goto out;
 	}
 
-	keylen = mpi_from_key(pcopy.prime, buflen, &prime);
+	/*
+	 * If the caller requests postprocessing with a KDF, allow an
+	 * arbitrary output buffer size since the KDF ensures proper truncation.
+	 */
+	keylen = mpi_from_key(pcopy.prime, kdfcopy ? SIZE_MAX : buflen, &prime);
 	if (keylen < 0 || !prime) {
 		/* buflen == 0 may be used to query the required buffer size,
 		 * which is the prime key length.
@@ -133,12 +297,25 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto error3;
 	}
 
-	kbuf = kmalloc(resultlen, GFP_KERNEL);
+	/* allocate space for DH shared secret and SP800-56A otherinfo */
+	kbuf = kmalloc(kdfcopy ? (resultlen + kdfcopy->otherinfolen) : resultlen,
+		       GFP_KERNEL);
 	if (!kbuf) {
 		ret = -ENOMEM;
 		goto error4;
 	}
 
+	/*
+	 * Concatenate SP800-56A otherinfo past DH shared secret -- the
+	 * input to the KDF is (DH shared secret || otherinfo)
+	 */
+	if (kdfcopy && kdfcopy->otherinfo &&
+	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
+			   kdfcopy->otherinfolen) != 0) {
+		ret = -EFAULT;
+		goto error5;
+	}
+
 	ret = do_dh(result, base, private, prime);
 	if (ret)
 		goto error5;
@@ -147,12 +324,17 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	if (ret != 0)
 		goto error5;
 
-	ret = nbytes;
-	if (copy_to_user(buffer, kbuf, nbytes) != 0)
-		ret = -EFAULT;
+	if (kdfcopy) {
+		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, kbuf,
+					    resultlen + kdfcopy->otherinfolen);
+	} else {
+		ret = nbytes;
+		if (copy_to_user(buffer, kbuf, nbytes) != 0)
+			ret = -EFAULT;
+	}
 
 error5:
-	kfree(kbuf);
+	kzfree(kbuf);
 error4:
 	mpi_free(result);
 error3:
@@ -162,5 +344,21 @@ error2:
 error1:
 	mpi_free(prime);
 out:
+	kdf_dealloc(sdesc);
 	return ret;
 }
+
+long keyctl_dh_compute(struct keyctl_dh_params __user *params,
+		       char __user *buffer, size_t buflen,
+		       struct keyctl_kdf_params __user *kdf)
+{
+	struct keyctl_kdf_params kdfcopy;
+
+	if (!kdf)
+		return __keyctl_dh_compute(params, buffer, buflen, NULL);
+
+	if (copy_from_user(&kdfcopy, kdf, sizeof(kdfcopy)) != 0)
+		return -EFAULT;
+
+	return __keyctl_dh_compute(params, buffer, buflen, &kdfcopy);
+}
diff --git a/security/keys/internal.h b/security/keys/internal.h
index a705a7d..c0f1adf 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,7 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 #include <linux/keyctl.h>
+#include <linux/compat.h>
 
 struct iovec;
 
@@ -260,15 +261,34 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
 
 #ifdef CONFIG_KEY_DH_OPERATIONS
 extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
-			      size_t, void __user *);
+			      size_t, struct keyctl_kdf_params __user *);
+extern long __keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
+				size_t, struct keyctl_kdf_params *);
+#ifdef CONFIG_KEYS_COMPAT
+extern long compat_keyctl_dh_compute(struct keyctl_dh_params __user *params,
+				char __user *buffer, size_t buflen,
+				struct compat_keyctl_kdf_params __user *kdf);
+#endif
+#define KEYCTL_KDF_MAX_OUTPUT_LEN	1024	/* max length of KDF output */
+#define KEYCTL_KDF_MAX_OI_LEN		64	/* max length of otherinfo */
 #else
 static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 				     char __user *buffer, size_t buflen,
-				     void __user *reserved)
+				     struct keyctl_kdf_params __user *kdf)
+{
+	return -EOPNOTSUPP;
+}
+
+#ifdef CONFIG_KEYS_COMPAT
+static inline long compat_keyctl_dh_compute(
+				struct keyctl_dh_params __user *params,
+				char __user *buffer, size_t buflen,
+				struct keyctl_kdf_params __user *kdf)
 {
 	return -EOPNOTSUPP;
 }
 #endif
+#endif
 
 /*
  * Debugging key validation
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d580ad0..b106898 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1689,7 +1689,7 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case KEYCTL_DH_COMPUTE:
 		return keyctl_dh_compute((struct keyctl_dh_params __user *) arg2,
 					 (char __user *) arg3, (size_t) arg4,
-					 (void __user *) arg5);
+					 (struct keyctl_kdf_params __user *) arg5);
 
 	default:
 		return -EOPNOTSUPP;
-- 
2.7.4
