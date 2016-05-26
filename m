From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH] KEYS: Add optional key derivation parameters for DH
Date: Thu, 26 May 2016 09:57:41 -0700
Message-ID: <20160526165741.2634-1-mathew.j.martineau@linux.intel.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
To: dhowells@redhat.com, smueller@chronox.de, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37127 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbcEZQ5o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 12:57:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The values computed during Diffie-Hellman key exchange are often used
in combination with key derivation functions to create cryptographic
keys. Add an interface to configure a key derivation function that
will transform the Diffie-Hellman result returned by the
KEYCTL_DH_COMPUTE command.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 Documentation/security/keys.txt | 9 ++++++++-
 include/uapi/linux/keyctl.h     | 5 +++++
 security/keys/compat.c          | 2 +-
 security/keys/dh.c              | 8 +++++++-
 security/keys/internal.h        | 5 +++--
 security/keys/keyctl.c          | 4 ++--
 6 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 20d0571..47470a6 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -826,7 +826,8 @@ The keyctl syscall functions are:
  (*) Compute a Diffie-Hellman shared secret or public key
 
        long keyctl(KEYCTL_DH_COMPUTE, struct keyctl_dh_params *params,
-		   char *buffer, size_t buflen);
+		   char *buffer, size_t buflen,
+		   struct keyctl_kdf_params *kdf);
 
      The params struct contains serial numbers for three keys:
 
@@ -843,6 +844,12 @@ The keyctl syscall functions are:
      public key.  If the base is the remote public key, the result is
      the shared secret.
 
+     When kdf is NULL, the raw computed value is written to the
+     buffer. If valid kdf parameters are provided, the result of the
+     DH computation is transformed according to the requested key
+     derivation function and the transformed value is written to the
+     buffer.
+
      The buffer length must be at least the length of the prime, or zero.
 
      If the buffer length is nonzero, the length of the result is
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 86eddd6..d55cf53 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -68,4 +68,9 @@ struct keyctl_dh_params {
 	__s32 base;
 };
 
+struct keyctl_kdf_params {
+	char *name;
+	__u8 reserved[32]; /* Reserved for future use, must be 0 */
+};
+
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/security/keys/compat.c b/security/keys/compat.c
index c8783b3..36c80bf 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -134,7 +134,7 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
 
 	case KEYCTL_DH_COMPUTE:
 		return keyctl_dh_compute(compat_ptr(arg2), compat_ptr(arg3),
-					 arg4);
+					 arg4, compat_ptr(arg5));
 
 	default:
 		return -EOPNOTSUPP;
diff --git a/security/keys/dh.c b/security/keys/dh.c
index 880505a..e415d4c 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -78,7 +78,8 @@ error:
 }
 
 long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-		       char __user *buffer, size_t buflen)
+		       char __user *buffer, size_t buflen,
+		       struct keyctl_kdf_params __user *kdf)
 {
 	long ret;
 	MPI base, private, prime, result;
@@ -97,6 +98,11 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto out;
 	}
 
+	if (kdf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	keylen = mpi_from_key(pcopy.prime, buflen, &prime);
 	if (keylen < 0 || !prime) {
 		/* buflen == 0 may be used to query the required buffer size,
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8ec7a52..1b7aaaa22 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -260,10 +260,11 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
 
 #ifdef CONFIG_KEY_DH_OPERATIONS
 extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
-			      size_t);
+			      size_t, struct keyctl_kdf_params __user *);
 #else
 static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-				     char __user *buffer, size_t buflen)
+				     char __user *buffer, size_t buflen,
+				     struct keyctl_kdf_params __user *kdf)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3b135a0..b106898 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1688,8 +1688,8 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 
 	case KEYCTL_DH_COMPUTE:
 		return keyctl_dh_compute((struct keyctl_dh_params __user *) arg2,
-					 (char __user *) arg3,
-					 (size_t) arg4);
+					 (char __user *) arg3, (size_t) arg4,
+					 (struct keyctl_kdf_params __user *) arg5);
 
 	default:
 		return -EOPNOTSUPP;
-- 
2.8.3
