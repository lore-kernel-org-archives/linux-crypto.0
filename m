Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8662CC43215
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FDF206F0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575322974;
	bh=zDj3oM05nKO4ZKYxFm5WmcR9doF7vrNPYBOA1N8LgT8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2iKDtkdiSjVOd/p0oK1z5yOUQscIpPPXo6aY2oDqsIR+UFKT6E25f5QScmQvP/vBn
	 +jniVVpNG0LmMt/aC++zf0RHV7AR2xkT0gRnhCsaTUXxMbD0sIdYY15Cujtva5pJQn
	 s1xRsUnet11oVLxjsP8MzEM3oLXyJS6yKshlsqDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfLBVmx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBVmx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 16:42:53 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4DA020717
        for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2019 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575322972;
        bh=zDj3oM05nKO4ZKYxFm5WmcR9doF7vrNPYBOA1N8LgT8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0xMKjivBFwtr4oLAkry7DUbspci+Ej4MmMXYNrOEqlUmS7fUP2oo90921pkGFyoFT
         c7sZIR2LmFJSwoi8vDWnqzjv0YO2zxA28m8p0BsqxK+QZpcz1q1WiaZSGevC5TJy1q
         MCDSqagYiBeoRoJm0aF6LhCTB+u7jkWQYwTxK93A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: compress - remove crt_u.compress (struct compress_tfm)
Date:   Mon,  2 Dec 2019 13:42:29 -0800
Message-Id: <20191202214230.164997-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191202214230.164997-1-ebiggers@kernel.org>
References: <20191202214230.164997-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crt_u.compress (struct compress_tfm) is pointless because its two
fields, ->cot_compress() and ->cot_decompress(), always point to
crypto_compress() and crypto_decompress().

Remove this pointless indirection, and just make crypto_comp_compress()
and crypto_comp_decompress() be direct calls to what used to be
crypto_compress() and crypto_decompress().

Also remove the unused function crypto_comp_cast().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/api.c           |  2 +-
 crypto/compress.c      | 31 ++++++++++++------------------
 crypto/internal.h      |  1 -
 include/linux/crypto.h | 43 ++++++------------------------------------
 4 files changed, 19 insertions(+), 58 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 55bca28df92d86..d1ff266a92ff7d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -301,7 +301,7 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 		return crypto_init_cipher_ops(tfm);
 
 	case CRYPTO_ALG_TYPE_COMPRESS:
-		return crypto_init_compress_ops(tfm);
+		return 0;
 
 	default:
 		break;
diff --git a/crypto/compress.c b/crypto/compress.c
index e9edf852478798..9048fe390c4630 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -6,34 +6,27 @@
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  */
-#include <linux/types.h>
 #include <linux/crypto.h>
-#include <linux/errno.h>
-#include <linux/string.h>
 #include "internal.h"
 
-static int crypto_compress(struct crypto_tfm *tfm,
-                            const u8 *src, unsigned int slen,
-                            u8 *dst, unsigned int *dlen)
+int crypto_comp_compress(struct crypto_comp *comp,
+			 const u8 *src, unsigned int slen,
+			 u8 *dst, unsigned int *dlen)
 {
+	struct crypto_tfm *tfm = crypto_comp_tfm(comp);
+
 	return tfm->__crt_alg->cra_compress.coa_compress(tfm, src, slen, dst,
 	                                                 dlen);
 }
+EXPORT_SYMBOL_GPL(crypto_comp_compress);
 
-static int crypto_decompress(struct crypto_tfm *tfm,
-                             const u8 *src, unsigned int slen,
-                             u8 *dst, unsigned int *dlen)
+int crypto_comp_decompress(struct crypto_comp *comp,
+			   const u8 *src, unsigned int slen,
+			   u8 *dst, unsigned int *dlen)
 {
+	struct crypto_tfm *tfm = crypto_comp_tfm(comp);
+
 	return tfm->__crt_alg->cra_compress.coa_decompress(tfm, src, slen, dst,
 	                                                   dlen);
 }
-
-int crypto_init_compress_ops(struct crypto_tfm *tfm)
-{
-	struct compress_tfm *ops = &tfm->crt_compress;
-
-	ops->cot_compress = crypto_compress;
-	ops->cot_decompress = crypto_decompress;
-
-	return 0;
-}
+EXPORT_SYMBOL_GPL(crypto_comp_decompress);
diff --git a/crypto/internal.h b/crypto/internal.h
index 93df7bec844a7c..a58a2af4b66963 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -59,7 +59,6 @@ struct crypto_alg *crypto_mod_get(struct crypto_alg *alg);
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
-int crypto_init_compress_ops(struct crypto_tfm *tfm);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 23365a9d062e3f..8f708564b98b11 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -606,17 +606,7 @@ struct cipher_tfm {
 	void (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
-struct compress_tfm {
-	int (*cot_compress)(struct crypto_tfm *tfm,
-	                    const u8 *src, unsigned int slen,
-	                    u8 *dst, unsigned int *dlen);
-	int (*cot_decompress)(struct crypto_tfm *tfm,
-	                      const u8 *src, unsigned int slen,
-	                      u8 *dst, unsigned int *dlen);
-};
-
 #define crt_cipher	crt_u.cipher
-#define crt_compress	crt_u.compress
 
 struct crypto_tfm {
 
@@ -624,7 +614,6 @@ struct crypto_tfm {
 	
 	union {
 		struct cipher_tfm cipher;
-		struct compress_tfm compress;
 	} crt_u;
 
 	void (*exit)(struct crypto_tfm *tfm);
@@ -928,13 +917,6 @@ static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 	return (struct crypto_comp *)tfm;
 }
 
-static inline struct crypto_comp *crypto_comp_cast(struct crypto_tfm *tfm)
-{
-	BUG_ON((crypto_tfm_alg_type(tfm) ^ CRYPTO_ALG_TYPE_COMPRESS) &
-	       CRYPTO_ALG_TYPE_MASK);
-	return __crypto_comp_cast(tfm);
-}
-
 static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
 						    u32 type, u32 mask)
 {
@@ -969,26 +951,13 @@ static inline const char *crypto_comp_name(struct crypto_comp *tfm)
 	return crypto_tfm_alg_name(crypto_comp_tfm(tfm));
 }
 
-static inline struct compress_tfm *crypto_comp_crt(struct crypto_comp *tfm)
-{
-	return &crypto_comp_tfm(tfm)->crt_compress;
-}
-
-static inline int crypto_comp_compress(struct crypto_comp *tfm,
-                                       const u8 *src, unsigned int slen,
-                                       u8 *dst, unsigned int *dlen)
-{
-	return crypto_comp_crt(tfm)->cot_compress(crypto_comp_tfm(tfm),
-						  src, slen, dst, dlen);
-}
+int crypto_comp_compress(struct crypto_comp *tfm,
+			 const u8 *src, unsigned int slen,
+			 u8 *dst, unsigned int *dlen);
 
-static inline int crypto_comp_decompress(struct crypto_comp *tfm,
-                                         const u8 *src, unsigned int slen,
-                                         u8 *dst, unsigned int *dlen)
-{
-	return crypto_comp_crt(tfm)->cot_decompress(crypto_comp_tfm(tfm),
-						    src, slen, dst, dlen);
-}
+int crypto_comp_decompress(struct crypto_comp *tfm,
+			   const u8 *src, unsigned int slen,
+			   u8 *dst, unsigned int *dlen);
 
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.24.0.393.g34dc348eaf-goog

