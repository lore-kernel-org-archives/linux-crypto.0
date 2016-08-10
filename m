From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4] KEYS: add SP800-56A KDF support for DH
Date: Wed, 10 Aug 2016 07:15:45 +0200
Message-ID: <6006845.JOrWo9jFiO@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <2623005.lF82gu89UT@positron.chronox.de> <alpine.OSX.2.20.1608091546100.24354@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34720 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331AbcHJSNV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:13:21 -0400
In-Reply-To: <alpine.OSX.2.20.1608091546100.24354@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SP800-56A defines the use of DH with key derivation function based on a
counter. The input to the KDF is defined as (DH shared secret || other
information). The value for the "other information" is to be provided by
the caller.

The KDF is provided by the kernel crypto API. The SP800-56A KDF is equal
to the SP800-108 counter KDF. However, the caller is allowed to specify
the KDF type that he wants to use to derive the key material allowing
the use of the other KDFs provided with the kernel crypto API.

As the KDF implements the proper truncation of the DH shared secret to
the requested size, this patch fills the caller buffer up to its size.

The patch is tested with a new test added to the keyutils user space
code which uses a CAVS test vector testing the compliance with
SP800-56A.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/security/keys.txt |  35 ++++++++++---
 include/linux/compat.h          |   7 +++
 include/uapi/linux/keyctl.h     |   7 +++
 security/keys/Kconfig           |   1 +
 security/keys/Makefile          |   3 +-
 security/keys/compat.c          |   5 +-
 security/keys/compat_dh.c       |  36 +++++++++++++
 security/keys/dh.c              | 110 +++++++++++++++++++++++++++++++++++-----
 security/keys/internal.h        |  21 +++++++-
 security/keys/keyctl.c          |   2 +-
 10 files changed, 201 insertions(+), 26 deletions(-)
 create mode 100644 security/keys/compat_dh.c

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 3849814..9df0605 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -827,7 +827,7 @@ The keyctl syscall functions are:
 
        long keyctl(KEYCTL_DH_COMPUTE, struct keyctl_dh_params *params,
 		   char *buffer, size_t buflen,
-		   void *reserved);
+		   struct keyctl_kdf_params *kdf);
 
      The params struct contains serial numbers for three keys:
 
@@ -844,18 +844,37 @@ The keyctl syscall functions are:
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
+	 - char *kdfname specifies the NUL terminated string identifying
+	   the KDF function used from the kernel crypto API. As of now,
+	   only non-keyed KDFs are supported, such as kdf_ctr(sha256),
+	   kdf_fb(sha1) or kdf_dpi(sha512). The use of kdf_ctr() complies
+	   with SP800-56A.
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
index f964ef7..00f348f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -295,6 +295,13 @@ struct compat_old_sigaction {
 };
 #endif
 
+struct compat_keyctl_kdf_params {
+	compat_uptr_t kdfname;
+	compat_uptr_t otherinfo;
+	__u32 otherinfolen;
+	__u32 __spare[8];
+};
+
 struct compat_statfs;
 struct compat_statfs64;
 struct compat_old_linux_dirent;
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 86eddd6..0abe048 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -68,4 +68,11 @@ struct keyctl_dh_params {
 	__s32 base;
 };
 
+struct keyctl_kdf_params {
+	char *kdfname;
+	char *otherinfo;
+	__u32 otherinfolen;
+	__u32 __spare[8];
+};
+
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index f826e87..56491fe 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -90,6 +90,7 @@ config KEY_DH_OPERATIONS
        bool "Diffie-Hellman operations on retained keys"
        depends on KEYS
        select MPILIB
+       select CRYPTO_KDF
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
index 0000000..dc93e95e
--- /dev/null
+++ b/security/keys/compat_dh.c
@@ -0,0 +1,36 @@
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
+	kdfcopy.kdfname = compat_ptr(compat_kdfcopy.kdfname);
+	kdfcopy.otherinfo = compat_ptr(compat_kdfcopy.otherinfo);
+	kdfcopy.otherinfolen = compat_kdfcopy.otherinfolen;
+
+	return __keyctl_dh_compute(params, buffer, buflen, &kdfcopy);
+}
diff --git a/security/keys/dh.c b/security/keys/dh.c
index 531ed2e..8054454 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -77,9 +77,35 @@ error:
 	return ret;
 }
 
-long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-		       char __user *buffer, size_t buflen,
-		       void __user *reserved)
+static int keyctl_dh_compute_kdf(struct crypto_rng *tfm,
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
+	ret = crypto_rng_generate(tfm, kbuf, kbuflen, outbuf, buflen);
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
@@ -88,6 +114,7 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	uint8_t *kbuf;
 	ssize_t keylen;
 	size_t resultlen;
+	struct crypto_rng *tfm = NULL;
 
 	if (!params || (!buffer && buflen)) {
 		ret = -EINVAL;
@@ -98,12 +125,36 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto out;
 	}
 
-	if (reserved) {
-		ret = -EINVAL;
-		goto out;
+	if (kdfcopy) {
+		char *kdfname;
+
+		if (buflen > KEYCTL_KDF_MAX_OUTPUT_LEN ||
+		    kdfcopy->otherinfolen > KEYCTL_KDF_MAX_OI_LEN) {
+			ret = -EMSGSIZE;
+			goto out;
+		}
+
+		/* get KDF name string */
+		kdfname = strndup_user(kdfcopy->kdfname, CRYPTO_MAX_ALG_NAME);
+		if (IS_ERR(kdfname)) {
+			ret = PTR_ERR(kdfname);
+			goto out;
+		}
+
+		/* allocate KDF from the kernel crypto API */
+		tfm = crypto_alloc_rng(kdfname, 0, 0);
+		kfree(kdfname);
+		if (IS_ERR(tfm)) {
+			ret = PTR_ERR(tfm);
+			goto out;
+		}
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
@@ -133,12 +184,25 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
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
@@ -147,12 +211,17 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	if (ret != 0)
 		goto error5;
 
-	ret = nbytes;
-	if (copy_to_user(buffer, kbuf, nbytes) != 0)
-		ret = -EFAULT;
+	if (kdfcopy) {
+		ret = keyctl_dh_compute_kdf(tfm, buffer, buflen, kbuf,
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
@@ -162,5 +231,22 @@ error2:
 error1:
 	mpi_free(prime);
 out:
+	if (tfm)
+		crypto_free_rng(tfm);
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
index a705a7d..cb5aec9 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 #include <linux/keyctl.h>
+#include <crypto/rng.h>
+#include <linux/compat.h>
 
 struct iovec;
 
@@ -260,14 +262,29 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
 
 #ifdef CONFIG_KEY_DH_OPERATIONS
 extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
-			      size_t, void __user *);
+			      size_t, struct keyctl_kdf_params __user *);
+extern long __keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
+				size_t, struct keyctl_kdf_params *);
+extern long compat_keyctl_dh_compute(struct keyctl_dh_params __user *params,
+				char __user *buffer, size_t buflen,
+				struct compat_keyctl_kdf_params __user *kdf);
+#define KEYCTL_KDF_MAX_OUTPUT_LEN	1024	/* max length of KDF output */
+#define KEYCTL_KDF_MAX_OI_LEN		64	/* max length of otherinfo */
 #else
 static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 				     char __user *buffer, size_t buflen,
-				     void __user *reserved)
+				     struct keyctl_kdf_params __user *kdf)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline long compat_keyctl_dh_compute(
+				struct keyctl_dh_params __user *params,
+				char __user *buffer, size_t buflen,
+				struct keyctl_kdf_params __user *kdf)
+{
+	return -EOPNOTSUPP
+}
 #endif
 
 /*
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
