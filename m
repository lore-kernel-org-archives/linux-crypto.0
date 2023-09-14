Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71612EDE995
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbjINI3M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbjINI2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ABF1FC2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:39 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c364fb8a4cso5973425ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680119; x=1695284919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOqdX3+nXUyUV8mHKNyJgOZWEIR1SpCUVEK0tW5/qpI=;
        b=Lcvxbm9CsbIjhjsEBUk3yS8wH9PHUVX617x3YjFlGEcr0+RqJKB9k2uouSPItegl+J
         NazYnPfUqfNJpHr0SZ7oBx3wmLI7H78zBkWiqDQKgqNMj+AF9e2C1TiAqUwiQTSmrcLx
         NtZUDYH0bVACXDFvjB8m4tmDcLRT7oDoWxeGzDCyZVTNm9OPG/dJVj92l+JaQez/eub+
         ldaYRIw6/vLhGBx2zdDiJOpXbEGvsUKvkXi1Pw3NEJ4Z1XniZzXgbI7ZuBXCp09ciNzv
         hAV1Uw22LqvArVuUgCJtTCiXkKL6015Ji6orZ0uTbVSddmWo8uMHmolGqcN1va6egFTO
         lOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680119; x=1695284919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YOqdX3+nXUyUV8mHKNyJgOZWEIR1SpCUVEK0tW5/qpI=;
        b=pcf8SW3OWaolWkCIXuVpvBDkrRiAnkWvUAo7zNsQM8UqgcbAEScfdAwr9uqqCO5xc0
         mVxnRP/Pzh/VnoLqAiFGF8RQCeKjl5mk4tcOH88cy7gDHaM7rdNaryX9SaZZGZxNZdAs
         ZjD3M193kbHkgxAWAk8sfZZAa/FldsL8xxaZoT5uEdkf9ifVKMDmQE9uA5/w92zQ6ArK
         of+ESMxRTKwl2CFv8tH4yuzy1oK8phihWigIWN+evqsnqD1YVgRZ93fksyFoXUJcwmRj
         G5l5r2lxFTTtraNCFcTo2I71UlGA0ae36kLZBGMXW7kKZFeEo3tv3axNTG4ygmXD8xqi
         NZQA==
X-Gm-Message-State: AOJu0YxDZmqTuGai8BSDxENHBIRwj6haSx5aInmn1c8sJpy+p7rWKR7a
        wbw74MXPpjqJz2Zyp80z20rX4GUdWRE=
X-Google-Smtp-Source: AGHT+IEL7T9O1XL36VjJ9mUivYOlkw0boAV7umveE0r1MQ5fuIY87lSl43P3gsdXnuymz8F0JTSY3g==
X-Received: by 2002:a17:902:da86:b0:1c1:e258:7447 with SMTP id j6-20020a170902da8600b001c1e2587447mr5678825plx.22.1694680118985;
        Thu, 14 Sep 2023 01:28:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:38 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 8/8] crypto: cbc - Convert from skcipher to lskcipher
Date:   Thu, 14 Sep 2023 16:28:28 +0800
Message-Id: <20230914082828.895403-9-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the existing skcipher CBC template with an lskcipher version.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/cbc.c | 159 +++++++++++++++++++--------------------------------
 1 file changed, 59 insertions(+), 100 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 6c03e96b945f..28345b8d921c 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -5,8 +5,6 @@
  * Copyright (c) 2006-2016 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
-#include <crypto/algapi.h>
-#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -14,99 +12,71 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 
-static int crypto_cbc_encrypt_segment(struct skcipher_walk *walk,
-				      struct crypto_skcipher *skcipher)
+static int crypto_cbc_encrypt_segment(struct crypto_lskcipher *tfm,
+				      const u8 *src, u8 *dst, unsigned nbytes,
+				      u8 *iv)
 {
-	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	struct crypto_cipher *cipher;
-	struct crypto_tfm *tfm;
-	u8 *iv = walk->iv;
+	unsigned int bsize = crypto_lskcipher_blocksize(tfm);
 
-	cipher = skcipher_cipher_simple(skcipher);
-	tfm = crypto_cipher_tfm(cipher);
-	fn = crypto_cipher_alg(cipher)->cia_encrypt;
-
-	do {
+	for (; nbytes >= bsize; src += bsize, dst += bsize, nbytes -= bsize) {
 		crypto_xor(iv, src, bsize);
-		fn(tfm, dst, iv);
+		crypto_lskcipher_encrypt(tfm, iv, dst, bsize, NULL);
 		memcpy(iv, dst, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+	}
 
 	return nbytes;
 }
 
-static int crypto_cbc_encrypt_inplace(struct skcipher_walk *walk,
-				      struct crypto_skcipher *skcipher)
+static int crypto_cbc_encrypt_inplace(struct crypto_lskcipher *tfm,
+				      u8 *src, unsigned nbytes, u8 *oiv)
 {
-	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	struct crypto_cipher *cipher;
-	struct crypto_tfm *tfm;
-	u8 *iv = walk->iv;
+	unsigned int bsize = crypto_lskcipher_blocksize(tfm);
+	u8 *iv = oiv;
 
-	cipher = skcipher_cipher_simple(skcipher);
-	tfm = crypto_cipher_tfm(cipher);
-	fn = crypto_cipher_alg(cipher)->cia_encrypt;
+	if (nbytes < bsize)
+		goto out;
 
 	do {
 		crypto_xor(src, iv, bsize);
-		fn(tfm, src, src);
+		crypto_lskcipher_encrypt(tfm, src, src, bsize, NULL);
 		iv = src;
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
+	memcpy(oiv, iv, bsize);
 
+out:
 	return nbytes;
 }
 
-static int crypto_cbc_encrypt(struct skcipher_request *req)
+static int crypto_cbc_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			      u8 *dst, unsigned len, u8 *iv, bool final)
 {
-	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-	struct skcipher_walk walk;
-	int err;
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *cipher = *ctx;
+	int rem;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	if (src == dst)
+		rem = crypto_cbc_encrypt_inplace(cipher, dst, len, iv);
+	else
+		rem = crypto_cbc_encrypt_segment(cipher, src, dst, len, iv);
 
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			err = crypto_cbc_encrypt_inplace(&walk, skcipher);
-		else
-			err = crypto_cbc_encrypt_segment(&walk, skcipher);
-		err = skcipher_walk_done(&walk, err);
-	}
-
-	return err;
+	return rem && final ? -EINVAL : rem;
 }
 
-static int crypto_cbc_decrypt_segment(struct skcipher_walk *walk,
-				      struct crypto_skcipher *skcipher)
+static int crypto_cbc_decrypt_segment(struct crypto_lskcipher *tfm,
+				      const u8 *src, u8 *dst, unsigned nbytes,
+				      u8 *oiv)
 {
-	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	struct crypto_cipher *cipher;
-	struct crypto_tfm *tfm;
-	u8 *iv = walk->iv;
+	unsigned int bsize = crypto_lskcipher_blocksize(tfm);
+	const u8 *iv = oiv;
 
-	cipher = skcipher_cipher_simple(skcipher);
-	tfm = crypto_cipher_tfm(cipher);
-	fn = crypto_cipher_alg(cipher)->cia_decrypt;
+	if (nbytes < bsize)
+		goto out;
 
 	do {
-		fn(tfm, dst, src);
+		crypto_lskcipher_decrypt(tfm, src, dst, bsize, NULL);
 		crypto_xor(dst, iv, bsize);
 		iv = src;
 
@@ -114,83 +84,72 @@ static int crypto_cbc_decrypt_segment(struct skcipher_walk *walk,
 		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
+	memcpy(oiv, iv, bsize);
 
+out:
 	return nbytes;
 }
 
-static int crypto_cbc_decrypt_inplace(struct skcipher_walk *walk,
-				      struct crypto_skcipher *skcipher)
+static int crypto_cbc_decrypt_inplace(struct crypto_lskcipher *tfm,
+				      u8 *src, unsigned nbytes, u8 *iv)
 {
-	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
+	unsigned int bsize = crypto_lskcipher_blocksize(tfm);
 	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
-	struct crypto_cipher *cipher;
-	struct crypto_tfm *tfm;
 
-	cipher = skcipher_cipher_simple(skcipher);
-	tfm = crypto_cipher_tfm(cipher);
-	fn = crypto_cipher_alg(cipher)->cia_decrypt;
+	if (nbytes < bsize)
+		goto out;
 
 	/* Start of the last block. */
 	src += nbytes - (nbytes & (bsize - 1)) - bsize;
 	memcpy(last_iv, src, bsize);
 
 	for (;;) {
-		fn(tfm, src, src);
+		crypto_lskcipher_decrypt(tfm, src, src, bsize, NULL);
 		if ((nbytes -= bsize) < bsize)
 			break;
 		crypto_xor(src, src - bsize, bsize);
 		src -= bsize;
 	}
 
-	crypto_xor(src, walk->iv, bsize);
-	memcpy(walk->iv, last_iv, bsize);
+	crypto_xor(src, iv, bsize);
+	memcpy(iv, last_iv, bsize);
 
+out:
 	return nbytes;
 }
 
-static int crypto_cbc_decrypt(struct skcipher_request *req)
+static int crypto_cbc_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			      u8 *dst, unsigned len, u8 *iv, bool final)
 {
-	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-	struct skcipher_walk walk;
-	int err;
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *cipher = *ctx;
+	int rem;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	if (src == dst)
+		rem = crypto_cbc_decrypt_inplace(cipher, dst, len, iv);
+	else
+		rem = crypto_cbc_decrypt_segment(cipher, src, dst, len, iv);
 
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			err = crypto_cbc_decrypt_inplace(&walk, skcipher);
-		else
-			err = crypto_cbc_decrypt_segment(&walk, skcipher);
-		err = skcipher_walk_done(&walk, err);
-	}
-
-	return err;
+	return rem && final ? -EINVAL : rem;
 }
 
 static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct skcipher_instance *inst;
-	struct crypto_alg *alg;
+	struct lskcipher_instance *inst;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb);
+	inst = lskcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
-	alg = skcipher_ialg_simple(inst);
-
 	err = -EINVAL;
-	if (!is_power_of_2(alg->cra_blocksize))
+	if (!is_power_of_2(inst->alg.co.base.cra_blocksize))
 		goto out_free_inst;
 
 	inst->alg.encrypt = crypto_cbc_encrypt;
 	inst->alg.decrypt = crypto_cbc_decrypt;
 
-	err = skcipher_register_instance(tmpl, inst);
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err) {
 out_free_inst:
 		inst->free(inst);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

