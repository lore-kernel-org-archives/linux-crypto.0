Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCA6C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 05:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4AC424677
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 05:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLFF5G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 00:57:06 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51808 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfLFF5G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 00:57:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id6bw-000526-OO; Fri, 06 Dec 2019 13:57:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id6bw-0000Lp-BA; Fri, 06 Dec 2019 13:57:04 +0800
Date:   Fri, 6 Dec 2019 13:57:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: skcipher - Add skcipher_ialg_simple helper
Message-ID: <20191206055704.g2g5y2e5dakxj7za@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch introduces the skcipher_ialg_simple helper which fetches
the crypto_alg structure from a simple skcpiher instance's spawn.

This allows us to remove the third argument from the function
skcipher_alloc_instance_simple.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cbc.c b/crypto/cbc.c
index dd96bcf4d4b6..b9c718fe9d7d 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -54,10 +54,12 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	err = -EINVAL;
 	if (!is_power_of_2(alg->cra_blocksize))
 		goto out_free_inst;
diff --git a/crypto/cfb.c b/crypto/cfb.c
index 7b68fbb61732..5018db366737 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -203,10 +203,12 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	/* CFB mode is a stream cipher. */
 	inst->alg.base.cra_blocksize = 1;
 
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 70a3fccb82f3..e11e58950c0e 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -129,10 +129,12 @@ static int crypto_ctr_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	/* Block size must be >= 4 bytes. */
 	err = -EINVAL;
 	if (alg->cra_blocksize < 4)
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 9d6981ca7d5d..7679c9b84da6 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -64,10 +64,12 @@ static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	inst->alg.ivsize = 0; /* ECB mode doesn't take an IV */
 
 	inst->alg.encrypt = crypto_ecb_encrypt;
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index a155c88105ea..dcf6643f8f15 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -266,10 +266,12 @@ static int crypto_kw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	err = -EINVAL;
 	/* Section 5.1 requirement for KW */
 	if (alg->cra_blocksize != sizeof(struct crypto_kw_block))
diff --git a/crypto/ofb.c b/crypto/ofb.c
index 133ff4c7f2c6..d3bbc8bb6889 100644
--- a/crypto/ofb.c
+++ b/crypto/ofb.c
@@ -55,10 +55,12 @@ static int crypto_ofb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	/* OFB mode is a stream cipher. */
 	inst->alg.base.cra_blocksize = 1;
 
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 862cdb8d8b6c..7a6f8ff98667 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -156,10 +156,12 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_alg *alg;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	alg = skcipher_ialg_simple(inst);
+
 	inst->alg.encrypt = crypto_pcbc_encrypt;
 	inst->alg.decrypt = crypto_pcbc_decrypt;
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index bad57f07c45e..d7cc271ed76b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -953,15 +953,12 @@ static void skcipher_free_instance_simple(struct skcipher_instance *inst)
  *
  * @tmpl: the template being instantiated
  * @tb: the template parameters
- * @cipher_alg_ret: on success, a pointer to the underlying cipher algorithm is
- *		    returned here.  It must be dropped with crypto_mod_put().
  *
  * Return: a pointer to the new instance, or an ERR_PTR().  The caller still
  *	   needs to register the instance.
  */
-struct skcipher_instance *
-skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr **tb,
-			       struct crypto_alg **cipher_alg_ret)
+struct skcipher_instance *skcipher_alloc_instance_simple(
+	struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 	struct crypto_alg *cipher_alg;
@@ -1018,7 +1015,6 @@ skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.init = skcipher_init_tfm_simple;
 	inst->alg.exit = skcipher_exit_tfm_simple;
 
-	*cipher_alg_ret = cipher_alg;
 	return inst;
 
 err_free_inst:
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 921c409fe1b1..ad4a6330ff53 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -214,9 +214,17 @@ skcipher_cipher_simple(struct crypto_skcipher *tfm)
 
 	return ctx->cipher;
 }
-struct skcipher_instance *
-skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr **tb,
-			       struct crypto_alg **cipher_alg_ret);
+
+struct skcipher_instance *skcipher_alloc_instance_simple(
+	struct crypto_template *tmpl, struct rtattr **tb);
+
+static inline struct crypto_alg *skcipher_ialg_simple(
+	struct skcipher_instance *inst)
+{
+	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+
+	return spawn->alg;
+}
 
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
