Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBF8EDE98F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbjINI3K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbjINI2n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2698210C
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-2747b49cac4so124666a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680118; x=1695284918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wLgNJmsQfWtBrh5DmPoSjzaT7sXM7jbDnkQ1KIefU8=;
        b=fYR8Fp+smSezbaFNuNBdarnAIStshpy0YuV2UrW5HtxDNkdHJxF1yH0bj4yys5KGvH
         v7E0rC7oKW2W7ii9B0dqkguVrfr4ndXz6T0RBaD2onrYJLWGq1CQMOW8xC5X+EAg0/Zb
         wIAP40oW9BMIC9JyB+spQ8cOFBc4GBnp4ZW6JNiTKGOAtcO6bu0z78LsezxC1UTqJfmi
         gvCZznqk7jTGgvj2zrnrPM+0i8gMzjiMLYT53buitOPT6U00rfMk84dcsoV+iPxc95Ne
         tWu3soXnQAXLVZmCT3MA0NIL5chYmVLfqZPdev+TWGd5zxMSsTPqyojFzBOBm9yt/mYc
         Ir+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680118; x=1695284918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9wLgNJmsQfWtBrh5DmPoSjzaT7sXM7jbDnkQ1KIefU8=;
        b=W/Vw70Ozt4mM6x36odlS508zVmq3LpNZ2YyiSiV56CMGHpK7o02soLu1SIAYPlI0bC
         JtUlicyighsIdlhes0eKU484AFjR5zqB8aURTyZTKTFZPdOcL9pce1+RTTpu/tsCKvg8
         q8k1Spgy2Wl2X/jN4hIt2AWPBnz24V8nC9+nawnKZFWdLugW7mekHqWBWQWwd4x8OVSH
         JRqx1aV4aQ13pcNyfO+cP54FQBnk7CAJZ6elQDTPDhm1eRtrDI0miH6oOinhjqSCFZtf
         uGjhSwBJ/HCwKj8yUJkZcNoDkt6s4n05W2r3wENmFSXSH+nmCMHbAyfL3gtTFPnfFiUr
         L0rw==
X-Gm-Message-State: AOJu0YyG/lHnzUamysz+SVVCRbD4kgF6A3C0gNIuCmZaEFF8ibCq9qjc
        JFOgi3HV3cEHJ3ddUGwDeGBdB5N8z7w=
X-Google-Smtp-Source: AGHT+IHKLtDuH+9WvPRgzOrAriULaR0AOWZRYO+fdAunKMezpmvCwDz3bBNBQhNYCyhIuB7XTDI/Tw==
X-Received: by 2002:a17:90a:d58d:b0:26d:2b42:cdae with SMTP id v13-20020a17090ad58d00b0026d2b42cdaemr4478277pju.3.1694680117760;
        Thu, 14 Sep 2023 01:28:37 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:37 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7/8] crypto: ecb - Convert from skcipher to lskcipher
Date:   Thu, 14 Sep 2023 16:28:27 +0800
Message-Id: <20230914082828.895403-8-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds two different implementations of ECB.  First of
all an lskcipher wrapper around existing ciphers is introduced as
a temporary transition aid.

Secondly a permanent lskcipher template is also added.  It's simply
a wrapper around the underlying lskcipher algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ecb.c | 206 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 164 insertions(+), 42 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index 71fbb0543d64..cc7625d1a475 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -5,75 +5,196 @@
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
-static int crypto_ecb_crypt(struct skcipher_request *req,
-			    struct crypto_cipher *cipher,
+static int crypto_ecb_crypt(struct crypto_cipher *cipher, const u8 *src,
+			    u8 *dst, unsigned nbytes, bool final,
 			    void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
 {
 	const unsigned int bsize = crypto_cipher_blocksize(cipher);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
+
+	while (nbytes >= bsize) {
+		fn(crypto_cipher_tfm(cipher), dst, src);
+
+		src += bsize;
+		dst += bsize;
+
+		nbytes -= bsize;
+	}
+
+	return nbytes && final ? -EINVAL : nbytes;
+}
+
+static int crypto_ecb_encrypt2(struct crypto_lskcipher *tfm, const u8 *src,
+			       u8 *dst, unsigned len, u8 *iv, bool final)
+{
+	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_cipher *cipher = *ctx;
+
+	return crypto_ecb_crypt(cipher, src, dst, len, final,
+				crypto_cipher_alg(cipher)->cia_encrypt);
+}
+
+static int crypto_ecb_decrypt2(struct crypto_lskcipher *tfm, const u8 *src,
+			       u8 *dst, unsigned len, u8 *iv, bool final)
+{
+	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_cipher *cipher = *ctx;
+
+	return crypto_ecb_crypt(cipher, src, dst, len, final,
+				crypto_cipher_alg(cipher)->cia_decrypt);
+}
+
+static int lskcipher_setkey_simple2(struct crypto_lskcipher *tfm,
+				    const u8 *key, unsigned int keylen)
+{
+	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_cipher *cipher = *ctx;
+
+	crypto_cipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(cipher, crypto_lskcipher_get_flags(tfm) &
+				CRYPTO_TFM_REQ_MASK);
+	return crypto_cipher_setkey(cipher, key, keylen);
+}
+
+static int lskcipher_init_tfm_simple2(struct crypto_lskcipher *tfm)
+{
+	struct lskcipher_instance *inst = lskcipher_alg_instance(tfm);
+	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_cipher_spawn *spawn;
+	struct crypto_cipher *cipher;
+
+	spawn = lskcipher_instance_ctx(inst);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	*ctx = cipher;
+	return 0;
+}
+
+static void lskcipher_exit_tfm_simple2(struct crypto_lskcipher *tfm)
+{
+	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
+
+	crypto_free_cipher(*ctx);
+}
+
+static void lskcipher_free_instance_simple2(struct lskcipher_instance *inst)
+{
+	crypto_drop_cipher(lskcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct lskcipher_instance *lskcipher_alloc_instance_simple2(
+	struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct crypto_cipher_spawn *spawn;
+	struct lskcipher_instance *inst;
+	struct crypto_alg *cipher_alg;
+	u32 mask;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_LSKCIPHER, &mask);
+	if (err)
+		return ERR_PTR(err);
 
-	while ((nbytes = walk.nbytes) != 0) {
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+	spawn = lskcipher_instance_ctx(inst);
 
-		do {
-			fn(crypto_cipher_tfm(cipher), dst, src);
+	err = crypto_grab_cipher(spawn, lskcipher_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	cipher_alg = crypto_spawn_cipher_alg(spawn);
 
-			src += bsize;
-			dst += bsize;
-		} while ((nbytes -= bsize) >= bsize);
+	err = crypto_inst_setname(lskcipher_crypto_instance(inst), tmpl->name,
+				  cipher_alg);
+	if (err)
+		goto err_free_inst;
 
-		err = skcipher_walk_done(&walk, nbytes);
-	}
+	inst->free = lskcipher_free_instance_simple2;
+
+	/* Default algorithm properties, can be overridden */
+	inst->alg.co.base.cra_blocksize = cipher_alg->cra_blocksize;
+	inst->alg.co.base.cra_alignmask = cipher_alg->cra_alignmask;
+	inst->alg.co.base.cra_priority = cipher_alg->cra_priority;
+	inst->alg.co.min_keysize = cipher_alg->cra_cipher.cia_min_keysize;
+	inst->alg.co.max_keysize = cipher_alg->cra_cipher.cia_max_keysize;
+	inst->alg.co.ivsize = cipher_alg->cra_blocksize;
+
+	/* Use struct crypto_cipher * by default, can be overridden */
+	inst->alg.co.base.cra_ctxsize = sizeof(struct crypto_cipher *);
+	inst->alg.setkey = lskcipher_setkey_simple2;
+	inst->alg.init = lskcipher_init_tfm_simple2;
+	inst->alg.exit = lskcipher_exit_tfm_simple2;
+
+	return inst;
+
+err_free_inst:
+	lskcipher_free_instance_simple2(inst);
+	return ERR_PTR(err);
+}
+
+static int crypto_ecb_create2(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct lskcipher_instance *inst;
+	int err;
+
+	inst = lskcipher_alloc_instance_simple2(tmpl, tb);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
+
+	/* ECB mode doesn't take an IV */
+	inst->alg.co.ivsize = 0;
+
+	inst->alg.encrypt = crypto_ecb_encrypt2;
+	inst->alg.decrypt = crypto_ecb_decrypt2;
+
+	err = lskcipher_register_instance(tmpl, inst);
+	if (err)
+		inst->free(inst);
 
 	return err;
 }
 
-static int crypto_ecb_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-
-	return crypto_ecb_crypt(req, cipher,
-				crypto_cipher_alg(cipher)->cia_encrypt);
-}
-
-static int crypto_ecb_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-
-	return crypto_ecb_crypt(req, cipher,
-				crypto_cipher_alg(cipher)->cia_decrypt);
-}
-
 static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct skcipher_instance *inst;
+	struct crypto_lskcipher_spawn *spawn;
+	struct lskcipher_alg *cipher_alg;
+	struct lskcipher_instance *inst;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb);
-	if (IS_ERR(inst))
-		return PTR_ERR(inst);
+	inst = lskcipher_alloc_instance_simple(tmpl, tb);
+	if (IS_ERR(inst)) {
+		err = crypto_ecb_create2(tmpl, tb);
+		return err;
+	}
 
-	inst->alg.ivsize = 0; /* ECB mode doesn't take an IV */
+	spawn = lskcipher_instance_ctx(inst);
+	cipher_alg = crypto_lskcipher_spawn_alg(spawn);
 
-	inst->alg.encrypt = crypto_ecb_encrypt;
-	inst->alg.decrypt = crypto_ecb_decrypt;
+	/* ECB mode doesn't take an IV */
+	inst->alg.co.ivsize = 0;
+	if (cipher_alg->co.ivsize)
+		return -EINVAL;
 
-	err = skcipher_register_instance(tmpl, inst);
+	inst->alg.co.base.cra_ctxsize = cipher_alg->co.base.cra_ctxsize;
+	inst->alg.setkey = cipher_alg->setkey;
+	inst->alg.encrypt = cipher_alg->encrypt;
+	inst->alg.decrypt = cipher_alg->decrypt;
+	inst->alg.init = cipher_alg->init;
+	inst->alg.exit = cipher_alg->exit;
+
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err)
 		inst->free(inst);
 
@@ -102,3 +223,4 @@ module_exit(crypto_ecb_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ECB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("ecb");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

