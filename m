From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] KEYS: Add placeholder KDF usage with DH
Date: Thu, 26 May 2016 23:38:12 +0200
Message-ID: <4396788.BlSbYuWPli@positron.chronox.de>
References: <20160526165741.2634-1-mathew.j.martineau@linux.intel.com> <23038.1464293450@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34870 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbcEZViQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 17:38:16 -0400
In-Reply-To: <23038.1464293450@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 21:10:50 schrieb David Howells:

Hi David,

Mat asked me to step in in case his patch needed an update.

---8<---
The values computed during Diffie-Hellman key exchange are often used
in combination with key derivation functions to create cryptographic
keys. Add a placeholder for a later implementation to configure a
key derivation function that will transform the Diffie-Hellman
result returned by the KEYCTL_DH_COMPUTE command.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/security/keys.txt | 5 ++++-
 security/keys/compat.c          | 2 +-
 security/keys/dh.c              | 8 +++++++-
 security/keys/internal.h        | 5 +++--
 security/keys/keyctl.c          | 4 ++--
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 20d0571..3849814 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -826,7 +826,8 @@ The keyctl syscall functions are:
  (*) Compute a Diffie-Hellman shared secret or public key
 
        long keyctl(KEYCTL_DH_COMPUTE, struct keyctl_dh_params *params,
-		   char *buffer, size_t buflen);
+		   char *buffer, size_t buflen,
+		   void *reserved);
 
      The params struct contains serial numbers for three keys:
 
@@ -843,6 +844,8 @@ The keyctl syscall functions are:
      public key.  If the base is the remote public key, the result is
      the shared secret.
 
+     The reserved argument must be set to NULL.
+
      The buffer length must be at least the length of the prime, or zero.
 
      If the buffer length is nonzero, the length of the result is
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
index 880505a..531ed2e 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -78,7 +78,8 @@ error:
 }
 
 long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-		       char __user *buffer, size_t buflen)
+		       char __user *buffer, size_t buflen,
+		       void __user *reserved)
 {
 	long ret;
 	MPI base, private, prime, result;
@@ -97,6 +98,11 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto out;
 	}
 
+	if (reserved) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	keylen = mpi_from_key(pcopy.prime, buflen, &prime);
 	if (keylen < 0 || !prime) {
 		/* buflen == 0 may be used to query the required buffer size,
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8ec7a52..a705a7d 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -260,10 +260,11 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
 
 #ifdef CONFIG_KEY_DH_OPERATIONS
 extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
-			      size_t);
+			      size_t, void __user *);
 #else
 static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
-				     char __user *buffer, size_t buflen)
+				     char __user *buffer, size_t buflen,
+				     void __user *reserved)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3b135a0..d580ad0 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1688,8 +1688,8 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 
 	case KEYCTL_DH_COMPUTE:
 		return keyctl_dh_compute((struct keyctl_dh_params __user *) arg2,
-					 (char __user *) arg3,
-					 (size_t) arg4);
+					 (char __user *) arg3, (size_t) arg4,
+					 (void __user *) arg5);
 
 	default:
 		return -EOPNOTSUPP;
-- 
2.5.5
