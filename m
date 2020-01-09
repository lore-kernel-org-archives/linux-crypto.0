Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027A7C282DD
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 22:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B53242077B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 22:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578608484;
	bh=R4cywW+LwgPD2vuU4tHxNwln/uNRdQsJ6FS2UIIVMy0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=zREnbCtD6vaIKpnrMnbetHtVbT+IgRM2YTk8TxnNB5NsUEA4SnDj1kIdSJ1kf1u1W
	 xW1OIHBJC2hgsaUaSz1SjaI74mpg7O+wVKOmsbN6qCLVSliszz6vrljxLl8uSSO4fO
	 eY0uEiyVw6CjbzKjqlyOF5NiQm1Ko/lrUm/zE3Js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgAIWVY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 17:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgAIWVY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 17:21:24 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C98C32077B;
        Thu,  9 Jan 2020 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578608481;
        bh=R4cywW+LwgPD2vuU4tHxNwln/uNRdQsJ6FS2UIIVMy0=;
        h=From:To:Cc:Subject:Date:From;
        b=Vea0JXoOs3F82NoflSyRchHoafvS4+wIv3+FsdepoDz2S9Ye4a+p3ZgxIoKixA/XV
         XE2JsRmFnLBR6PzGqXPbZmBiqJ9zTSG19fE/pGYJRAiCbhGsgagbsETlVJOIA+mpgN
         slMLWA5lfCh3LZnknZcHsI5LBV4/5EhI9TN6e2M4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: cipher - move API definition to internal header file
Date:   Thu,  9 Jan 2020 23:21:08 +0100
Message-Id: <20200109222108.15228-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The single block cipher API is not intended for general use, and so it
should not be exposed to users outside of the crypto subsystem via the
public header files. So create a new internal header file and move the
definitions there.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/crypto/api-skcipher.rst         |   9 -
 arch/arm/crypto/aes-neonbs-glue.c             |   1 +
 arch/s390/crypto/aes_s390.c                   |   1 +
 crypto/adiantum.c                             |   1 +
 crypto/ansi_cprng.c                           |   1 +
 crypto/cbc.c                                  |   1 +
 crypto/ccm.c                                  |   1 +
 crypto/cfb.c                                  |   1 +
 crypto/cipher.c                               |   1 +
 crypto/cmac.c                                 |   1 +
 crypto/ctr.c                                  |   1 +
 crypto/drbg.c                                 |   1 +
 crypto/ecb.c                                  |   1 +
 crypto/essiv.c                                |   1 +
 crypto/keywrap.c                              |   1 +
 crypto/ofb.c                                  |   1 +
 crypto/pcbc.c                                 |   1 +
 crypto/skcipher.c                             |   1 +
 crypto/vmac.c                                 |   1 +
 crypto/xcbc.c                                 |   1 +
 crypto/xts.c                                  |   1 +
 drivers/crypto/geode-aes.c                    |   1 +
 .../crypto/inside-secure/safexcel_cipher.c    |   1 +
 drivers/crypto/inside-secure/safexcel_hash.c  |   1 +
 include/crypto/algapi.h                       |  29 ---
 include/crypto/internal/cipher.h              | 206 ++++++++++++++++++
 include/linux/crypto.h                        | 163 --------------
 27 files changed, 229 insertions(+), 201 deletions(-)
 create mode 100644 include/crypto/internal/cipher.h

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index 1aaf8985894b..563d5bb06a7a 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -24,12 +24,3 @@ Symmetric Key Cipher Request Handle
 
 .. kernel-doc:: include/crypto/skcipher.h
    :functions: crypto_skcipher_reqsize skcipher_request_set_tfm skcipher_request_alloc skcipher_request_free skcipher_request_set_callback skcipher_request_set_crypt
-
-Single Block Cipher API
------------------------
-
-.. kernel-doc:: include/linux/crypto.h
-   :doc: Single Block Cipher API
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_cipher crypto_free_cipher crypto_has_cipher crypto_cipher_blocksize crypto_cipher_setkey crypto_cipher_encrypt_one crypto_cipher_decrypt_one
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index e85839a8aaeb..03a7a37d6393 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -10,6 +10,7 @@
 #include <crypto/aes.h>
 #include <crypto/cbc.h>
 #include <crypto/ctr.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 1c23d84a9097..33c606521412 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -21,6 +21,7 @@
 #include <crypto/algapi.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 4d7a6cac82ed..49c94d147184 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -32,6 +32,7 @@
 
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c475c1129ff2..4320a961d013 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -7,6 +7,7 @@
  *  (C) Neil Horman <nhorman@tuxdriver.com>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/cbc.c b/crypto/cbc.c
index e6f6273a7d39..45fe3117cd39 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -7,6 +7,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/cbc.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 241ecdc5c4e0..731fb0fe3dda 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
diff --git a/crypto/cfb.c b/crypto/cfb.c
index 4e5219bbcd19..343263554876 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -20,6 +20,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/cipher.c b/crypto/cipher.c
index fd78150deb1c..6ae67731f81e 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 143a6544c873..66177a217cb4 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -11,6 +11,7 @@
  *   Author: Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
diff --git a/crypto/ctr.c b/crypto/ctr.c
index a8feab621c6c..2192d72eec1d 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -7,6 +7,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/drbg.c b/crypto/drbg.c
index b6929eb5f565..bcb22065caf4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -98,6 +98,7 @@
  */
 
 #include <crypto/drbg.h>
+#include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 
 /***************************************************************
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 69a687cbdf21..71fbb0543d64 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 20d7c1fdbf5d..c19524e323ff 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -31,6 +31,7 @@
 #include <crypto/authenc.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 0355cce21b1e..1b87e6d3a5e6 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -85,6 +85,7 @@
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 
 struct crypto_kw_block {
diff --git a/crypto/ofb.c b/crypto/ofb.c
index 2ec68e3f2c55..7fc426935b45 100644
--- a/crypto/ofb.c
+++ b/crypto/ofb.c
@@ -8,6 +8,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index ae921fb74dc9..7ab6003eeaa5 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -10,6 +10,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7221def7b9a7..fab5e39e9fac 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -10,6 +10,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 2d906830df96..0cba941ec368 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -36,6 +36,7 @@
 #include <linux/scatterlist.h>
 #include <asm/byteorder.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 
 /*
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 598ec88abf0f..9bc998699180 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -6,6 +6,7 @@
  * 	Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
diff --git a/crypto/xts.c b/crypto/xts.c
index 29efa15f1495..91e3eb63f00e 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -7,6 +7,7 @@
  * Based on ecb.c
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  */
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index f4f18bfc2247..a25fb9783c7e 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 
 #include <linux/io.h>
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 0c5e80c3f6e3..159653985388 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -24,6 +24,7 @@
 #include <crypto/xts.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 
 #include "safexcel.h"
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 43962bc709c6..648ea63c9224 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -12,6 +12,7 @@
 #include <crypto/sha3.h>
 #include <crypto/skcipher.h>
 #include <crypto/sm3.h>
+#include <crypto/internal/cipher.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e115f9215ed5..a278ceaaeb6f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -191,41 +191,12 @@ struct crypto_cipher_spawn {
 	struct crypto_spawn base;
 };
 
-static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
-				     struct crypto_instance *inst,
-				     const char *name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
-}
-
-static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
-{
-	crypto_drop_spawn(&spawn->base);
-}
-
 static inline struct crypto_alg *crypto_spawn_cipher_alg(
 	struct crypto_cipher_spawn *spawn)
 {
 	return spawn->base.alg;
 }
 
-static inline struct crypto_cipher *crypto_spawn_cipher(
-	struct crypto_cipher_spawn *spawn)
-{
-	u32 type = CRYPTO_ALG_TYPE_CIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_cipher_cast(crypto_spawn_tfm(&spawn->base, type, mask));
-}
-
-static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
-{
-	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
-}
-
 static inline struct crypto_async_request *crypto_get_backlog(
 	struct crypto_queue *queue)
 {
diff --git a/include/crypto/internal/cipher.h b/include/crypto/internal/cipher.h
new file mode 100644
index 000000000000..0784fa2e3531
--- /dev/null
+++ b/include/crypto/internal/cipher.h
@@ -0,0 +1,206 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * Copyright (c) 2002 David S. Miller (davem@redhat.com)
+ * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+
+#ifndef _CRYPTO_INTERNAL_CIPHER_H
+#define _CRYPTO_INTERNAL_CIPHER_H
+
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+
+struct crypto_cipher {
+	struct crypto_tfm base;
+};
+
+/**
+ * DOC: Single Block Cipher API
+ *
+ * The single block cipher API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_CIPHER (listed as type "cipher" in /proc/crypto).
+ *
+ * Using the single block cipher API calls, operations with the basic cipher
+ * primitive can be implemented. These cipher primitives exclude any block
+ * chaining operations including IV handling.
+ *
+ * The purpose of this single block cipher API is to support the implementation
+ * of templates or other concepts that only need to perform the cipher operation
+ * on one block at a time. Templates invoke the underlying cipher primitive
+ * block-wise and process either the input or the output data of these cipher
+ * operations.
+ */
+
+static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_cipher *)tfm;
+}
+
+/**
+ * crypto_alloc_cipher() - allocate single block cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a single block cipher. The returned struct
+ * crypto_cipher is the cipher handle that is required for any subsequent API
+ * invocation for that single block cipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
+							u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_cipher_cast(crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
+{
+	return &tfm->base;
+}
+
+/**
+ * crypto_free_cipher() - zeroize and free the single block cipher handle
+ * @tfm: cipher handle to be freed
+ */
+static inline void crypto_free_cipher(struct crypto_cipher *tfm)
+{
+	crypto_free_tfm(crypto_cipher_tfm(tfm));
+}
+
+/**
+ * crypto_has_cipher() - Search for the availability of a single block cipher
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the single block cipher is known to the kernel crypto API;
+ *	   false otherwise
+ */
+static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
+/**
+ * crypto_cipher_blocksize() - obtain block size for cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the single block cipher referenced with the cipher handle
+ * tfm is returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
+static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
+}
+
+static inline unsigned int crypto_cipher_alignmask(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_cipher_tfm(tfm));
+}
+
+static inline u32 crypto_cipher_get_flags(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_get_flags(crypto_cipher_tfm(tfm));
+}
+
+static inline void crypto_cipher_set_flags(struct crypto_cipher *tfm,
+					   u32 flags)
+{
+	crypto_tfm_set_flags(crypto_cipher_tfm(tfm), flags);
+}
+
+static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
+					     u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
+}
+
+/**
+ * crypto_cipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the single block cipher referenced by the
+ * cipher handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
+int crypto_cipher_setkey(struct crypto_cipher *tfm,
+			 const u8 *key, unsigned int keylen);
+
+/**
+ * crypto_cipher_encrypt_one() - encrypt one block of plaintext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the ciphertext
+ * @src: buffer holding the plaintext to be encrypted
+ *
+ * Invoke the encryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
+void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
+
+/**
+ * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the plaintext
+ * @src: buffer holding the ciphertext to be decrypted
+ *
+ * Invoke the decryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
+void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
+
+static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
+				     struct crypto_instance *inst,
+				     const char *name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+
+static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_cipher *crypto_spawn_cipher(
+	struct crypto_cipher_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_CIPHER;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_cipher_cast(crypto_spawn_tfm(&spawn->base, type, mask));
+}
+
+static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
+{
+	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
+}
+
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 763863dbc079..defe6bd76232 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -603,10 +603,6 @@ struct crypto_tfm {
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-struct crypto_cipher {
-	struct crypto_tfm base;
-};
-
 struct crypto_comp {
 	struct crypto_tfm base;
 };
@@ -710,165 +706,6 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
 	return __alignof__(tfm->__crt_ctx);
 }
 
-/**
- * DOC: Single Block Cipher API
- *
- * The single block cipher API is used with the ciphers of type
- * CRYPTO_ALG_TYPE_CIPHER (listed as type "cipher" in /proc/crypto).
- *
- * Using the single block cipher API calls, operations with the basic cipher
- * primitive can be implemented. These cipher primitives exclude any block
- * chaining operations including IV handling.
- *
- * The purpose of this single block cipher API is to support the implementation
- * of templates or other concepts that only need to perform the cipher operation
- * on one block at a time. Templates invoke the underlying cipher primitive
- * block-wise and process either the input or the output data of these cipher
- * operations.
- */
-
-static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_cipher *)tfm;
-}
-
-/**
- * crypto_alloc_cipher() - allocate single block cipher handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	     single block cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for a single block cipher. The returned struct
- * crypto_cipher is the cipher handle that is required for any subsequent API
- * invocation for that single block cipher.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
-							u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_cipher_cast(crypto_alloc_base(alg_name, type, mask));
-}
-
-static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
-{
-	return &tfm->base;
-}
-
-/**
- * crypto_free_cipher() - zeroize and free the single block cipher handle
- * @tfm: cipher handle to be freed
- */
-static inline void crypto_free_cipher(struct crypto_cipher *tfm)
-{
-	crypto_free_tfm(crypto_cipher_tfm(tfm));
-}
-
-/**
- * crypto_has_cipher() - Search for the availability of a single block cipher
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	     single block cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the single block cipher is known to the kernel crypto API;
- *	   false otherwise
- */
-static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
-}
-
-/**
- * crypto_cipher_blocksize() - obtain block size for cipher
- * @tfm: cipher handle
- *
- * The block size for the single block cipher referenced with the cipher handle
- * tfm is returned. The caller may use that information to allocate appropriate
- * memory for the data returned by the encryption or decryption operation
- *
- * Return: block size of cipher
- */
-static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
-}
-
-static inline unsigned int crypto_cipher_alignmask(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_cipher_tfm(tfm));
-}
-
-static inline u32 crypto_cipher_get_flags(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_get_flags(crypto_cipher_tfm(tfm));
-}
-
-static inline void crypto_cipher_set_flags(struct crypto_cipher *tfm,
-					   u32 flags)
-{
-	crypto_tfm_set_flags(crypto_cipher_tfm(tfm), flags);
-}
-
-static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
-					     u32 flags)
-{
-	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
-}
-
-/**
- * crypto_cipher_setkey() - set key for cipher
- * @tfm: cipher handle
- * @key: buffer holding the key
- * @keylen: length of the key in bytes
- *
- * The caller provided key is set for the single block cipher referenced by the
- * cipher handle.
- *
- * Note, the key length determines the cipher type. Many block ciphers implement
- * different cipher modes depending on the key size, such as AES-128 vs AES-192
- * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
- * is performed.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-int crypto_cipher_setkey(struct crypto_cipher *tfm,
-			 const u8 *key, unsigned int keylen);
-
-/**
- * crypto_cipher_encrypt_one() - encrypt one block of plaintext
- * @tfm: cipher handle
- * @dst: points to the buffer that will be filled with the ciphertext
- * @src: buffer holding the plaintext to be encrypted
- *
- * Invoke the encryption operation of one block. The caller must ensure that
- * the plaintext and ciphertext buffers are at least one block in size.
- */
-void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
-
-/**
- * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
- * @tfm: cipher handle
- * @dst: points to the buffer that will be filled with the plaintext
- * @src: buffer holding the ciphertext to be decrypted
- *
- * Invoke the decryption operation of one block. The caller must ensure that
- * the plaintext and ciphertext buffers are at least one block in size.
- */
-void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
-
 static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_comp *)tfm;
-- 
2.20.1

