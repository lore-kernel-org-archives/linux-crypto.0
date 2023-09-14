Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96F7EDE990
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbjINI45 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbjINI44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:56:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFC5CF3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:56:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-26b44247123so573402a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694681811; x=1695286611; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+FVWyFAXDAKMnSKDDC7jOyr+ANX3gHPcKvdHW241elE=;
        b=pX/0ivHqJhpw+k9Xa8BoFhLNGdh6j0o2sBe4W8nHqyHI8HQrULoOWLWL1gqQyQroCD
         EgPXLDsgs5nYJSNZ9CE5XaHo5wWfYE2qzy7jHtfr1LlLeD6unqfkHryrbb6j3U+cYEKo
         9kK32z/xN4hTWPr1h9TbMb4QJrZVmSkJP04GBYZgK+21SF10b4/rbbOIra0mZdgv3ttU
         IlmWgJVyoEm4Wne7BFLlG/OcHGVKxIduA5VTY3N5znWjQnSCX6Mva3ADlP0SKU2ezbu8
         7DjEgkNk7CNAVnLIlseUaAoYbQy4gjN9FmVUKWWLFZEGJwoBbSBavBZauuq8iTN+dXmF
         oR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694681811; x=1695286611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FVWyFAXDAKMnSKDDC7jOyr+ANX3gHPcKvdHW241elE=;
        b=lgO+zems7lQbw+vpWkyE6W9xg7OreA/XPoXa80LC321XxFBqsML9G31z/zAplgSH8r
         BXUEI9pZAtG/JxTY1tlchXjRNMyrRm+HfeAKCpua8oFmzIJhy6GfacEotfFkRWm6716h
         JDT2OVxwLtcLP+KtUq2znQgAtVwS5+bamcbk1ml6x84o9tEQE+XutQgYuHg9NJGBQZDV
         MdPtUuJb2LG4ISO0XfRr3WoAVPbrfi0Q6WKc1KRyePzrY+v+6TlQ38MhFDYy/ktk7CUk
         tonBASaByLGT0OLyc/DzVwYDsZExYUS8GzCDgNgcwnDzt4QuRc5UCNYHgNyIOE/inSwe
         6fkA==
X-Gm-Message-State: AOJu0YwTYch12vBUvA809Dgw0E2UBQidBMWfdKUJG1EUVFOJPj/vXsbW
        bddJrbwmVPS2jFrvJ352Ras=
X-Google-Smtp-Source: AGHT+IF0delzvy5S6adEb/o5E/vNl71gJHWi0vPooL5AKsEntmXhkZWc67R5k4jEPLlsr2gX1DQ2ug==
X-Received: by 2002:a17:90b:4c89:b0:26f:4685:5b53 with SMTP id my9-20020a17090b4c8900b0026f46855b53mr5194832pjb.28.1694681811198;
        Thu, 14 Sep 2023 01:56:51 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a6e0900b0025bfda134ccsm889031pjk.16.2023.09.14.01.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:56:50 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Thu, 14 Sep 2023 16:56:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
Message-ID: <ZQLK0injXi7K3X1b@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 10:51:21AM +0200, Ard Biesheuvel wrote:
>
> So the intent is for lskcipher to ultimately supplant the current
> cipher entirely, right? And lskcipher can be used directly by clients
> of the crypto API, in which case kernel VAs may be used directly, but
> no async support is available, while skcipher API clients will gain
> access to lskciphers via a generic wrapper (if needed?)
> 
> That makes sense but it would help to spell this out.

Yes that's the idea.  It is pretty much exactly the same as how
shash and ahash are handled and used.

Because of the way I structured the ecb transition code (it will
take an old cipher and repackage it as an lskcipher), we need to
convert the templates first and then do the cipher => lskcipher
conversion.

> I'd be happy to help out here but I'll be off on vacation for ~3 weeks
> after this week so i won't get around to it before mid October. What I
> will do (if it helps) is rebase my recent RISC-V scalar AES cipher
> patches onto this, and implement ecb(aes) instead (which is the idea
> IIUC?)

That sounds good.  In fact let me attach the aes-generic proof-
of-concept conversion (it can only be applied after all templates
have been converted, so if you test it now everything but ecb/cbc
will be broken).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 666474b81c6a..afb74ee04193 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -47,14 +47,13 @@
  * ---------------------------------------------------------------------------
  */
 
-#include <crypto/aes.h>
-#include <crypto/algapi.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <asm/byteorder.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 static inline u8 byte(const u32 x, const unsigned n)
 {
@@ -1123,7 +1122,7 @@ EXPORT_SYMBOL_GPL(crypto_it_tab);
 
 /**
  * crypto_aes_set_key - Set the AES key.
- * @tfm:	The %crypto_tfm that is used in the context.
+ * @tfm:	The %crypto_lskcipher that is used in the context.
  * @in_key:	The input key.
  * @key_len:	The size of the key.
  *
@@ -1133,10 +1132,10 @@ EXPORT_SYMBOL_GPL(crypto_it_tab);
  *
  * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
-int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		unsigned int key_len)
+int crypto_aes_set_key(struct crypto_lskcipher *tfm, const u8 *in_key,
+		       unsigned int key_len)
 {
-	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aes_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
 	return aes_expandkey(ctx, in_key, key_len);
 }
@@ -1173,9 +1172,9 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 	f_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_encrypt_one(struct crypto_lskcipher *tfm, const u8 *in, u8 *out)
 {
-	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_lskcipher_ctx(tfm);
 	u32 b0[4], b1[4];
 	const u32 *kp = ctx->key_enc + 4;
 	const int key_len = ctx->key_length;
@@ -1212,6 +1211,17 @@ static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(b0[3], out + 12);
 }
 
+static int crypto_aes_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			      u8 *dst, unsigned nbytes, u8 *iv, bool final)
+{
+	const unsigned int bsize = AES_BLOCK_SIZE;
+
+	for (; nbytes >= bsize; src += bsize, dst += bsize, nbytes -= bsize)
+		aes_encrypt_one(tfm, src, dst);
+
+	return nbytes && final ? -EINVAL : nbytes;
+}
+
 /* decrypt a block of text */
 
 #define i_rn(bo, bi, n, k)	do {				\
@@ -1243,9 +1253,9 @@ static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	i_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_decrypt_one(struct crypto_lskcipher *tfm, const u8 *in, u8 *out)
 {
-	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_lskcipher_ctx(tfm);
 	u32 b0[4], b1[4];
 	const int key_len = ctx->key_length;
 	const u32 *kp = ctx->key_dec + 4;
@@ -1282,33 +1292,41 @@ static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(b0[3], out + 12);
 }
 
-static struct crypto_alg aes_alg = {
-	.cra_name		=	"aes",
-	.cra_driver_name	=	"aes-generic",
-	.cra_priority		=	100,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
-			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		=	crypto_aes_set_key,
-			.cia_encrypt		=	crypto_aes_encrypt,
-			.cia_decrypt		=	crypto_aes_decrypt
-		}
-	}
+static int crypto_aes_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			      u8 *dst, unsigned nbytes, u8 *iv, bool final)
+{
+	const unsigned int bsize = AES_BLOCK_SIZE;
+
+	for (; nbytes >= bsize; src += bsize, dst += bsize, nbytes -= bsize)
+		aes_decrypt_one(tfm, src, dst);
+
+	return nbytes && final ? -EINVAL : nbytes;
+}
+
+static struct lskcipher_alg aes_alg = {
+	.co = {
+		.base.cra_name		=	"aes",
+		.base.cra_driver_name	=	"aes-generic",
+		.base.cra_priority	=	100,
+		.base.cra_blocksize	=	AES_BLOCK_SIZE,
+		.base.cra_ctxsize	=	sizeof(struct crypto_aes_ctx),
+		.base.cra_module	=	THIS_MODULE,
+		.min_keysize		=	AES_MIN_KEY_SIZE,
+		.max_keysize		=	AES_MAX_KEY_SIZE,
+	},
+	.setkey				=	crypto_aes_set_key,
+	.encrypt			=	crypto_aes_encrypt,
+	.decrypt			=	crypto_aes_decrypt,
 };
 
 static int __init aes_init(void)
 {
-	return crypto_register_alg(&aes_alg);
+	return crypto_register_lskcipher(&aes_alg);
 }
 
 static void __exit aes_fini(void)
 {
-	crypto_unregister_alg(&aes_alg);
+	crypto_unregister_lskcipher(&aes_alg);
 }
 
 subsys_initcall(aes_init);
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 2090729701ab..947109e24360 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -6,8 +6,9 @@
 #ifndef _CRYPTO_AES_H
 #define _CRYPTO_AES_H
 
+#include <linux/cache.h>
+#include <linux/errno.h>
 #include <linux/types.h>
-#include <linux/crypto.h>
 
 #define AES_MIN_KEY_SIZE	16
 #define AES_MAX_KEY_SIZE	32
@@ -18,6 +19,8 @@
 #define AES_MAX_KEYLENGTH	(15 * 16)
 #define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
 
+struct crypto_lskcipher;
+
 /*
  * Please ensure that the first two fields are 16-byte aligned
  * relative to the start of the structure, i.e., don't move them!
@@ -48,8 +51,8 @@ static inline int aes_check_keylen(unsigned int keylen)
 	return 0;
 }
 
-int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		unsigned int key_len);
+int crypto_aes_set_key(struct crypto_lskcipher *tfm, const u8 *in_key,
+		       unsigned int key_len);
 
 /**
  * aes_expandkey - Expands the AES key as described in FIPS-197
