From: James Yonan <james@openvpn.net>
Subject: [PATCH] crypto_mem_not_equal: add constant-time equality testing of memory regions
Date: Sun, 15 Sep 2013 09:32:59 -0600
Message-ID: <1379259179-2677-1-git-send-email-james@openvpn.net>
References: <5232CDCF.50208@redhat.com>
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
	Florian Weimer <fw@deneb.enyo.de>,
	James Yonan <james@openvpn.net>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:46695 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3IOPeP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 11:34:15 -0400
In-Reply-To: <5232CDCF.50208@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When comparing MAC hashes, AEAD authentication tags, or other hash
values in the context of authentication or integrity checking, it
is important not to leak timing information to a potential attacker.

Bytewise memory comparisons (such as memcmp) are usually optimized so
that they return a nonzero value as soon as a mismatch is found.
This early-return behavior can leak timing information, allowing an
attacker to iteratively guess the correct result.

This patch adds a new method crypto_mem_not_equal that compares
strings of the same length in roughly constant time (cache misses
could change the timing, but since they don't reveal information
about the content of the strings being compared, they are effectively
benign).  Note that crypto_mem_not_equal (unlike memcmp) can only be
used to test for equality or inequality, NOT greater-than or
less-than.  This is not an issue for its use-cases within the Crypto
API.

I tried to locate all of the places in the Crypto API where memcmp was
being used for authentication or integrity checking, and convert them
over to crypto_mem_not_equal.

crypto_mem_not_equal is declared noinline, placed in its own source
file, and compiled with optimizations that might increase code size
disabled ("Os") because a smart compiler (or LTO) might notice that
the return value is always compared against zero/nonzero, and might
then reintroduce the same early-return optimization that we are
trying to avoid.

Since crypto_mem_not_equal is often called with size == 16 by its
users in the Crypto API, we add a special fast path for this case.

Signed-off-by: James Yonan <james@openvpn.net>
---
 crypto/Makefile                                |  2 +-
 crypto/asymmetric_keys/rsa.c                   |  5 +-
 crypto/authenc.c                               |  7 ++-
 crypto/authencesn.c                            |  9 +--
 crypto/ccm.c                                   |  5 +-
 crypto/crypto_mem_not_equal.c                  | 87 ++++++++++++++++++++++++++
 crypto/gcm.c                                   |  3 +-
 include/crypto/internal/crypto_mem_not_equal.h | 21 +++++++
 8 files changed, 126 insertions(+), 13 deletions(-)
 create mode 100644 crypto/crypto_mem_not_equal.c
 create mode 100644 include/crypto/internal/crypto_mem_not_equal.h

diff --git a/crypto/Makefile b/crypto/Makefile
index 2ba0df2..1f6f44d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o
+crypto-y := api.o cipher.o compress.o crypto_mem_not_equal.o
 
 obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
 
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 4a6a069..dd82ce5 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
 #include "public_key.h"
 
 MODULE_LICENSE("GPL");
@@ -189,12 +190,12 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 		}
 	}
 
-	if (memcmp(asn1_template, EM + T_offset, asn1_size) != 0) {
+	if (crypto_mem_not_equal(asn1_template, EM + T_offset, asn1_size) != 0) {
 		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
 		return -EBADMSG;
 	}
 
-	if (memcmp(H, EM + T_offset + asn1_size, hash_size) != 0) {
+	if (crypto_mem_not_equal(H, EM + T_offset + asn1_size, hash_size) != 0) {
 		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
 		return -EKEYREJECTED;
 	}
diff --git a/crypto/authenc.c b/crypto/authenc.c
index ffce19d..040ab09 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -13,6 +13,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -188,7 +189,7 @@ static void authenc_verify_ahash_update_done(struct crypto_async_request *areq,
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
+	err = crypto_mem_not_equal(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -227,7 +228,7 @@ static void authenc_verify_ahash_done(struct crypto_async_request *areq,
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
+	err = crypto_mem_not_equal(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -462,7 +463,7 @@ static int crypto_authenc_verify(struct aead_request *req,
 	ihash = ohash + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
-	return memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
+	return crypto_mem_not_equal(ihash, ohash, authsize) ? -EBADMSG : 0;
 }
 
 static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index ab53762..063d550 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -15,6 +15,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -247,7 +248,7 @@ static void authenc_esn_verify_ahash_update_done(struct crypto_async_request *ar
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
+	err = crypto_mem_not_equal(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -296,7 +297,7 @@ static void authenc_esn_verify_ahash_update_done2(struct crypto_async_request *a
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
+	err = crypto_mem_not_equal(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -336,7 +337,7 @@ static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
 
-	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
+	err = crypto_mem_not_equal(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
@@ -568,7 +569,7 @@ static int crypto_authenc_esn_verify(struct aead_request *req)
 	ihash = ohash + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
-	return memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
+	return crypto_mem_not_equal(ihash, ohash, authsize) ? -EBADMSG : 0;
 }
 
 static int crypto_authenc_esn_iverify(struct aead_request *req, u8 *iv,
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 499c917..1d5c63a 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -12,6 +12,7 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -363,7 +364,7 @@ static void crypto_ccm_decrypt_done(struct crypto_async_request *areq,
 
 	if (!err) {
 		err = crypto_ccm_auth(req, req->dst, cryptlen);
-		if (!err && memcmp(pctx->auth_tag, pctx->odata, authsize))
+		if (!err && crypto_mem_not_equal(pctx->auth_tag, pctx->odata, authsize))
 			err = -EBADMSG;
 	}
 	aead_request_complete(req, err);
@@ -422,7 +423,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 		return err;
 
 	/* verify */
-	if (memcmp(authtag, odata, authsize))
+	if (crypto_mem_not_equal(authtag, odata, authsize))
 		return -EBADMSG;
 
 	return err;
diff --git a/crypto/crypto_mem_not_equal.c b/crypto/crypto_mem_not_equal.c
new file mode 100644
index 0000000..8469edb
--- /dev/null
+++ b/crypto/crypto_mem_not_equal.c
@@ -0,0 +1,87 @@
+/*
+ * Constant-time equality testing of memory regions.
+ *
+ * Copyright (C) 2013 OpenVPN Technologies Inc. 
+ * Author: James Yonan <james@openvpn.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/export.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
+
+/* We want to avoid any optimizations that might shortcut
+ * the comparison and make it non-constant-time.
+ */
+#pragma GCC optimize ("Os")
+
+/**
+ * Constant-time equality testing of memory regions.
+ * Returns 0 when data is equal, non-zero otherwise.
+ * Fast path if size == 16.
+ */
+noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size)
+{
+	unsigned long ret = 0;
+
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#if BITS_PER_LONG == 64
+	if (size == 16)
+		return ((*(unsigned long *)(a)   ^ *(unsigned long *)(b))
+		      | (*(unsigned long *)(a+8) ^ *(unsigned long *)(b+8)));
+	while (size >= 8) {
+		ret |= *(unsigned long *)a ^ *(unsigned long *)b;
+		a += 8;
+		b += 8;
+		size -= 8;
+	}
+	if (!size)
+		return ret;
+#else /* BITS_PER_LONG != 64 */
+	if (size == 16 && sizeof(unsigned int) == 4)
+		return ((*(unsigned int *)(a)    ^ *(unsigned int *)(b))
+		      | (*(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4))
+		      | (*(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8))
+		      | (*(unsigned int *)(a+12) ^ *(unsigned int *)(b+12)));
+#endif /* BITS_PER_LONG */
+	if (sizeof(unsigned int) == 4) {
+		while (size >= 4) {
+			ret |= *(unsigned int *)a ^ *(unsigned int *)b;
+			a += 4;
+			b += 4;
+			size -= 4;
+		}
+		if (!size)
+			return ret;
+	}
+#else /* !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) */
+	if (size == 16)
+		return ((*(unsigned char *)(a)    ^ *(unsigned char *)(b))
+		      | (*(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1))
+		      | (*(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2))
+		      | (*(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3))
+		      | (*(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4))
+		      | (*(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5))
+		      | (*(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6))
+		      | (*(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7))
+		      | (*(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8))
+		      | (*(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9))
+		      | (*(unsigned char *)(a+10) ^ *(unsigned char *)(b+10))
+		      | (*(unsigned char *)(a+11) ^ *(unsigned char *)(b+11))
+		      | (*(unsigned char *)(a+12) ^ *(unsigned char *)(b+12))
+		      | (*(unsigned char *)(a+13) ^ *(unsigned char *)(b+13))
+		      | (*(unsigned char *)(a+14) ^ *(unsigned char *)(b+14))
+		      | (*(unsigned char *)(a+15) ^ *(unsigned char *)(b+15)));
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	while (size > 0) {
+		ret |= *(unsigned char *)a ^ *(unsigned char *)b;
+		a += 1;
+		b += 1;
+		size -= 1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_mem_not_equal);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 43e1fb0..4470b4e 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/crypto_mem_not_equal.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/hash.h>
 #include "internal.h"
@@ -582,7 +583,7 @@ static int crypto_gcm_verify(struct aead_request *req,
 
 	crypto_xor(auth_tag, iauth_tag, 16);
 	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
-	return memcmp(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
+	return crypto_mem_not_equal(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
 }
 
 static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
diff --git a/include/crypto/internal/crypto_mem_not_equal.h b/include/crypto/internal/crypto_mem_not_equal.h
new file mode 100644
index 0000000..7b2bd7e
--- /dev/null
+++ b/include/crypto/internal/crypto_mem_not_equal.h
@@ -0,0 +1,21 @@
+/*
+ * Constant-time equality testing of memory regions.
+ *
+ * Copyright (C) 2013 OpenVPN Technologies Inc. 
+ * Author: James Yonan <james@openvpn.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef _CRYPTO_INTERNAL_CRYPTO_MEM_NOT_EQUAL_H
+#define _CRYPTO_INTERNAL_CRYPTO_MEM_NOT_EQUAL_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size);
+
+#endif
-- 
1.8.1.2
