From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/8] KEYS: Provide key type operations for asymmetric key
 ops [ver #2]
Date: Thu, 23 Jun 2016 14:47:41 +0100
Message-ID: <146668966176.2977.3517277451461183332.stgit@warthog.procyon.org.uk>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbcFWNrp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 09:47:45 -0400
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Provide five new operations in the key_type struct that can be used to
provide access to asymmetric key operations.  These will be implemented for
the asymmetric key type in a later patch and may refer to a key retained in
RAM by the kernel or a key retained in crypto hardware.

     int (*asym_query)(const struct kernel_pkey_params *params,
		       struct kernel_pkey_query *info);
     int (*asym_eds_op)(struct kernel_pkey_params *params,
			const void *in, void *out);
     int (*asym_verify_signature)(struct kernel_pkey_params *params,
			          const void *in, const void *in2);

Since encrypt, decrypt and sign are identical in their interfaces, they're
rolled together in the asym_eds_op() operation and there's an operation ID
in the params argument to distinguish them.

Verify is different in that we supply the data and the signature instead
and get an error value (or 0) as the only result on the expectation that
this may well be how a hardware crypto device may work.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt |  106 +++++++++++++++++++++++++++++++++++++++
 include/linux/key-type.h        |   11 ++++
 include/linux/keyctl.h          |   46 +++++++++++++++++
 include/uapi/linux/keyctl.h     |    5 ++
 4 files changed, 168 insertions(+)
 create mode 100644 include/linux/keyctl.h

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 3849814bfe6d..286b4cab7e68 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -1432,6 +1432,112 @@ The structure has a number of fields, some of which are mandatory:
      	 The authorisation key.
 
 
+ (*) int (*asym_eds_op)(struct kernel_pkey_params *params,
+			const void *in, void *out);
+     int (*asym_verify_signature)(struct kernel_pkey_params *params,
+			          const void *in, const void *in2);
+
+     These methods are optional.  If provided the first allows a key to be
+     used to encrypt, decrypt or sign a blob of data, and the second allows a
+     key to verify a signature.
+
+     In all cases, the following information is provided in the params block:
+
+	struct kernel_pkey_params {
+		struct key	*key;
+		const char	*encoding;
+		const char	*hash_algo;
+		char		*info;
+		__u32		in_len;
+		union {
+			__u32	out_len;
+			__u32	in2_len;
+		};
+		enum kernel_pkey_operation op : 8;
+	};
+
+     This includes the key to be used; an optional string indicating the
+     encoding to use (for instance, "pkcs1" may be used with an RSA key to
+     indicate RSASSA-PKCS1-v1.5 or RSAES-PKCS1-v1.5 encoding); the name of the
+     hash algorithm used to generate the data for a signature (if appropriate);
+     the sizes of the input and output (or second input) buffers; and the ID of
+     the operation to be performed.
+
+     For a given operation ID, the input and output buffers are used as
+     follows:
+
+	Operation ID		in,in_len	out,out_len	in2,in2_len
+	=======================	===============	===============	===============
+	kernel_pkey_encrypt	Raw data	Encrypted data	-
+	kernel_pkey_decrypt	Encrypted data	Raw data	-
+	kernel_pkey_sign	Raw data	Signature	-
+	kernel_pkey_verify	Raw data	-		Signature
+
+     asym_eds_op() deals with encryption, decryption and signature creation as
+     specified by params->op.  Note that params->op is also set for
+     asym_verify_signature().
+
+     Encrypting and signature creation both take raw data in the input buffer
+     and return the encrypted result in the output buffer.  Padding may have
+     been added if an encoding was set.  In the case of signature creation,
+     depending on the encoding, the padding created may need to indicate the
+     digest algorithm - the name of which should be supplied in hash_algo.
+
+     Decryption takes encrypted data in the input buffer and returns the raw
+     data in the output buffer.  Padding will get checked and stripped off if
+     an encoding was set.
+
+     Verification takes raw data in the input buffer and the signature in the
+     second input buffer and checks that the one matches the other.  Padding
+     will be validated.  Depending on the encoding, the digest algorithm used
+     to generate the raw data may need to be indicated in hash_algo.
+
+     If successful, asym_eds_op() should return the number of bytes written
+     into the output buffer.  asym_verify_signature() should return 0.
+
+     A variety of errors may be returned, including EOPNOTSUPP if the operation
+     is not supported; EKEYREJECTED if verification fails; ENOPKG if the
+     required crypto isn't available.
+
+
+ (*) int (*asym_query)(const struct kernel_pkey_params *params,
+		       struct kernel_pkey_query *info);
+
+     This method is optional.  If provided it allows information about the
+     public or asymmetric key held in the key to be determined.
+
+     The parameter block is as for asym_eds_op() and co. but in_len and out_len
+     are unused.  The encoding and hash_algo fields should be used to reduce
+     the returned buffer/data sizes as appropriate.
+
+     If successful, the following information is filled in:
+
+	struct kernel_pkey_query {
+		__u32		supported_ops;
+		__u32		key_size;
+		__u16		max_data_size;
+		__u16		max_sig_size;
+		__u16		max_enc_size;
+		__u16		max_dec_size;
+	};
+
+     The supported_ops field will contain a bitmask indicating what operations
+     are supported by the key, including encryption of a blob, decryption of a
+     blob, signing a blob and verifying the signature on a blob.  The following
+     constants are defined for this:
+
+	KEYCTL_SUPPORTS_{ENCRYPT,DECRYPT,SIGN,VERIFY}
+
+     The key_size field is the size of the key in bits.  max_data_size and
+     max_sig_size are the maximum raw data and signature sizes for creation and
+     verification of a signature; max_enc_size and max_dec_size are the maximum
+     raw data and signature sizes for encryption and decryption.  The
+     max_*_size fields are measured in bytes.
+
+     If successful, 0 will be returned.  If the key doesn't support this,
+     EOPNOTSUPP will be returned.
+
+
 ============================
 REQUEST-KEY CALLBACK SERVICE
 ============================
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index eaee981c5558..63b2a92c2085 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -17,6 +17,9 @@
 
 #ifdef CONFIG_KEYS
 
+struct kernel_pkey_query;
+struct kernel_pkey_params;
+
 /*
  * key under-construction record
  * - passed to the request_key actor if supplied
@@ -147,6 +150,14 @@ struct key_type {
 	 */
 	request_key_actor_t request_key;
 
+	/* Asymmetric key accessor functions. */
+	int (*asym_query)(const struct kernel_pkey_params *params,
+			  struct kernel_pkey_query *info);
+	int (*asym_eds_op)(struct kernel_pkey_params *params,
+			   const void *in, void *out);
+	int (*asym_verify_signature)(struct kernel_pkey_params *params,
+				     const void *in, const void *in2);
+
 	/* internal fields */
 	struct list_head	link;		/* link in types list */
 	struct lock_class_key	lock_class;	/* key->sem lock class */
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
new file mode 100644
index 000000000000..e89b4a4e43d0
--- /dev/null
+++ b/include/linux/keyctl.h
@@ -0,0 +1,46 @@
+/* keyctl kernel bits
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef __LINUX_KEYCTL_H
+#define __LINUX_KEYCTL_H
+
+#include <uapi/linux/keyctl.h>
+
+struct kernel_pkey_query {
+	__u32		supported_ops;	/* Which ops are supported */
+	__u32		key_size;	/* Size of the key in bits */
+	__u16		max_data_size;	/* Maximum size of raw data to sign in bytes */
+	__u16		max_sig_size;	/* Maximum size of signature in bytes */
+	__u16		max_enc_size;	/* Maximum size of encrypted blob in bytes */
+	__u16		max_dec_size;	/* Maximum size of decrypted blob in bytes */
+};
+
+enum kernel_pkey_operation {
+	kernel_pkey_encrypt,
+	kernel_pkey_decrypt,
+	kernel_pkey_sign,
+	kernel_pkey_verify,
+};
+
+struct kernel_pkey_params {
+	struct key	*key;
+	const char	*encoding;	/* Encoding (eg. "oaep" or NULL for raw) */
+	const char	*hash_algo;	/* Digest algorithm used (eg. "sha1") or NULL if N/A */
+	char		*info;		/* Modified info string to be released later */
+	__u32		in_len;		/* Input data size */
+	union {
+		__u32	out_len;	/* Output buffer size (enc/dec/sign) */
+		__u32	in2_len;	/* 2nd input data size (verify) */
+	};
+	enum kernel_pkey_operation op : 8;
+};
+
+#endif /* __LINUX_KEYCTL_H */
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 86eddd6241f3..8ac2c5fbc8fc 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -68,4 +68,9 @@ struct keyctl_dh_params {
 	__s32 base;
 };
 
+#define KEYCTL_SUPPORTS_ENCRYPT		0x01
+#define KEYCTL_SUPPORTS_DECRYPT		0x02
+#define KEYCTL_SUPPORTS_SIGN		0x04
+#define KEYCTL_SUPPORTS_VERIFY		0x08
+
 #endif /*  _LINUX_KEYCTL_H */
