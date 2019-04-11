Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315D9C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0979A2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfDKIu6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:50:58 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41192 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDKIu6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:50:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQ8-0003Ja-U2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:50:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQ8-0006lO-MM; Thu, 11 Apr 2019 16:50:56 +0800
Subject: [PATCH 1/24] crypto: des_generic - Forbid 2-key in 3DES and add helpers
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQ8-0006lO-MM@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:50:56 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a requirement to the generic 3DES implementation
such that 2-key 3DES (K1 == K3) is no longer allowed in FIPS mode.

We will also provide helpers that may be used by drivers that
implement 3DES to make the same check.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/des_generic.c |   11 ++++-------
 include/crypto/des.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 1e6621665dd9..ebec1fb08c45 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -862,14 +862,11 @@ static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 		      unsigned int keylen)
 {
-	const u32 *K = (const u32 *)key;
+	int err;
 
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = __des3_verify_key(flags, key);
+	if (unlikely(err))
+		return err;
 
 	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
diff --git a/include/crypto/des.h b/include/crypto/des.h
index d4094d58ac54..72c7c8e5a5a7 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -6,6 +6,11 @@
 #ifndef __CRYPTO_DES_H
 #define __CRYPTO_DES_H
 
+#include <crypto/skcipher.h>
+#include <linux/compiler.h>
+#include <linux/fips.h>
+#include <linux/string.h>
+
 #define DES_KEY_SIZE		8
 #define DES_EXPKEY_WORDS	32
 #define DES_BLOCK_SIZE		8
@@ -14,6 +19,44 @@
 #define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
 #define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
 
+static inline int __des3_verify_key(u32 *flags, const u8 *key)
+{
+	int err = -EINVAL;
+	u32 K[6];
+
+	memcpy(K, key, DES3_EDE_KEY_SIZE);
+
+	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+		     (fips_enabled ||
+		      (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)))
+		goto bad;
+
+	if (unlikely(!((K[0] ^ K[4]) | (K[1] ^ K[5]))) && fips_enabled)
+		goto bad;
+
+	err = 0;
+
+out:
+	memzero_explicit(K, DES3_EDE_KEY_SIZE);
+
+	return err;
+
+bad:
+	*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+	goto out;
+}
+
+static inline int des3_verify_key(struct crypto_skcipher *tfm, const u8 *key)
+{
+	u32 flags;
+	int err;
+
+	flags = crypto_skcipher_get_flags(tfm);
+	err = __des3_verify_key(&flags, key);
+	crypto_skcipher_set_flags(tfm, flags);
+	return err;
+}
 
 extern unsigned long des_ekey(u32 *pe, const u8 *k);
 
