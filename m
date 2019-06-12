Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537D1C31E47
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C9A52082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yxACm3A5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405317AbfFLQUN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:20:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35035 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbfFLQUN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 12:20:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so7202177wml.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=71XtsErnWwza7NpJOunpzUrf9mDsoTV+W1Ysg9p4k2o=;
        b=yxACm3A5BvBtD/oTZ10SCftJv/HJQwBaaE9YyNlHEmeMfgBGTXyDWEvOOlGi+qmqNF
         bdtxIUyQpBaQpf29p1VZZXpWpDg9z2sE4Gs96qAWDmifWDIffYuRa7+mU8dk3OoV+djJ
         t9sKC3MSbq/h5cLjPaEVdS5C+D9Q4os8PtAYBJ+NkcXAPrZWMzsddcS8reb5AFXLtV3j
         UJMgrC68lQa+Qhq5jPgvl9xS9XPlm0QOMCV71IAPevba1Hi3kw4+O75YW4BrUK12Bom4
         GdT3j8xrq7bEA5lg4PVGhVoA+yX6wGBdPirlrpLaZ2EwpNVlAG78ryDyLr3iIMYnE/VM
         foag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=71XtsErnWwza7NpJOunpzUrf9mDsoTV+W1Ysg9p4k2o=;
        b=oF2T7FxQtB0ps1yOs++xQXQ+UkWUf4BZOS1oiO8Ie4Z5TI17nKXM8hpZZgMeoDEWZG
         taeukyb4JqDfA4FrYe1XomHzu5ly6wCR4Cpm790U9LUZwR9roka+VM+XYFyiISxQEVNX
         qVE8yYGTJ66zk9wE2mgXvVtbuu67Xt38bJkaEpfLznzBfzzxz6PsSKI9pAtzKalwtAp8
         51yUU4rw0zab7jfhLDxO4ElGVbKEdqr0z6Bc0pbeeacDBOaWWpIjXAmy4C1a0TpiUXQn
         xvkrK4Cup0dwa4Epw5aZkXUiKocXA4mObOmBbW55LC4agnySVxro9zftGPHyHh4oIGk9
         ONEg==
X-Gm-Message-State: APjAAAUDMxe0/QMj/yjaeq9RTJRIPpOKw/5X6xRTRXeblzKMY4HhAecz
        SMHCHsTdYSWG26Htg0byJz33AeLUf4Bm5g==
X-Google-Smtp-Source: APXvYqxv5KxAk9xUzorRc55bqiIbOee+f8TZqUEwT06yZ8hFLLREwJXksxLanHw8+VOh6RCxSSiHrQ==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr22019wme.146.1560356411078;
        Wed, 12 Jun 2019 09:20:11 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id c16sm70172wrr.53.2019.06.12.09.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:20:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 5/7] crypto: arc4 - remove cipher implementation
Date:   Wed, 12 Jun 2019 18:19:57 +0200
Message-Id: <20190612161959.30478-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are no remaining users of the cipher implementation, and there
are no meaningful ways in which the arc4 cipher can be combined with
templates other than ECB (and the way we do provide that combination
is highly dubious to begin with).

So let's drop the arc4 cipher altogether, and only keep the ecb(arc4)
skcipher, which is used in various places in the kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/arc4.c    | 64 +++++---------------
 crypto/testmgr.c |  1 +
 2 files changed, 16 insertions(+), 49 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 6974dba1b7b9..dd82fb7ebc75 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -13,26 +13,15 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-			unsigned int key_len)
+static int crypto_arc4_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			      unsigned int key_len)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return arc4_setkey(ctx, in_key, key_len);
 }
 
-static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
-				 unsigned int key_len)
-{
-	return arc4_set_key(&tfm->base, in_key, key_len);
-}
-
-static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
-}
-
-static int ecb_arc4_crypt(struct skcipher_request *req)
+static int crypto_arc4_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -50,24 +39,11 @@ static int ecb_arc4_crypt(struct skcipher_request *req)
 	return err;
 }
 
-static struct crypto_alg arc4_cipher = {
-	.cra_name		=	"arc4",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct arc4_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
-			.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
-			.cia_setkey		=	arc4_set_key,
-			.cia_encrypt		=	arc4_crypt_one,
-			.cia_decrypt		=	arc4_crypt_one,
-		},
-	},
-};
-
-static struct skcipher_alg arc4_skcipher = {
+static struct skcipher_alg arc4_alg = {
+	/*
+	 * For legacy reasons, this is named "ecb(arc4)", not "arc4".
+	 * Nevertheless it's actually a stream cipher, not a block cipher.
+	 */
 	.base.cra_name		=	"ecb(arc4)",
 	.base.cra_priority	=	100,
 	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
@@ -75,29 +51,19 @@ static struct skcipher_alg arc4_skcipher = {
 	.base.cra_module	=	THIS_MODULE,
 	.min_keysize		=	ARC4_MIN_KEY_SIZE,
 	.max_keysize		=	ARC4_MAX_KEY_SIZE,
-	.setkey			=	arc4_set_key_skcipher,
-	.encrypt		=	ecb_arc4_crypt,
-	.decrypt		=	ecb_arc4_crypt,
+	.setkey			=	crypto_arc4_setkey,
+	.encrypt		=	crypto_arc4_crypt,
+	.decrypt		=	crypto_arc4_crypt,
 };
 
 static int __init arc4_init(void)
 {
-	int err;
-
-	err = crypto_register_alg(&arc4_cipher);
-	if (err)
-		return err;
-
-	err = crypto_register_skcipher(&arc4_skcipher);
-	if (err)
-		crypto_unregister_alg(&arc4_cipher);
-	return err;
+	return crypto_register_skcipher(&arc4_alg);
 }
 
 static void __exit arc4_exit(void)
 {
-	crypto_unregister_alg(&arc4_cipher);
-	crypto_unregister_skcipher(&arc4_skcipher);
+	crypto_unregister_skcipher(&arc4_alg);
 }
 
 subsys_initcall(arc4_init);
@@ -106,4 +72,4 @@ module_exit(arc4_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
-MODULE_ALIAS_CRYPTO("arc4");
+MODULE_ALIAS_CRYPTO("ecb(arc4)");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 658a7eeebab2..c7be4e3c22cc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4125,6 +4125,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(arc4)",
+		.generic_driver = "ecb(arc4)-generic",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(arc4_tv_template)
-- 
2.20.1

