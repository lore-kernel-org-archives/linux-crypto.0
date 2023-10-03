Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F735E776F8
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjJCDom (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjJCDol (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:41 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C1B8
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKo-002wQf-0r; Tue, 03 Oct 2023 11:44:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 03/16] crypto: essiv - Handle lskcipher spawns
Date:   Tue,  3 Oct 2023 11:43:20 +0800
Message-Id: <20231003034333.1441826-4-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
References: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add code to handle an underlying lskcihper object when grabbing
an skcipher spawn.

Fixes: 31865c4c4db2 ("crypto: skcipher - Add lskcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/essiv.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index f7d4ef4837e5..e63fc6442e32 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -442,6 +442,7 @@ static bool essiv_supported_algorithms(const char *essiv_cipher_name,
 
 static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct skcipher_alg_common *skcipher_alg = NULL;
 	struct crypto_attr_type *algt;
 	const char *inner_cipher_name;
 	const char *shash_name;
@@ -450,7 +451,6 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_instance *inst;
 	struct crypto_alg *base, *block_base;
 	struct essiv_instance_ctx *ictx;
-	struct skcipher_alg *skcipher_alg = NULL;
 	struct aead_alg *aead_alg = NULL;
 	struct crypto_alg *_hash_alg;
 	struct shash_alg *hash_alg;
@@ -475,7 +475,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	mask = crypto_algt_inherited_mask(algt);
 
 	switch (type) {
-	case CRYPTO_ALG_TYPE_SKCIPHER:
+	case CRYPTO_ALG_TYPE_LSKCIPHER:
 		skcipher_inst = kzalloc(sizeof(*skcipher_inst) +
 					sizeof(*ictx), GFP_KERNEL);
 		if (!skcipher_inst)
@@ -489,9 +489,10 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 					   inner_cipher_name, 0, mask);
 		if (err)
 			goto out_free_inst;
-		skcipher_alg = crypto_spawn_skcipher_alg(&ictx->u.skcipher_spawn);
+		skcipher_alg = crypto_spawn_skcipher_alg_common(
+			&ictx->u.skcipher_spawn);
 		block_base = &skcipher_alg->base;
-		ivsize = crypto_skcipher_alg_ivsize(skcipher_alg);
+		ivsize = skcipher_alg->ivsize;
 		break;
 
 	case CRYPTO_ALG_TYPE_AEAD:
@@ -574,18 +575,17 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	base->cra_alignmask	= block_base->cra_alignmask;
 	base->cra_priority	= block_base->cra_priority;
 
-	if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
+	if (type == CRYPTO_ALG_TYPE_LSKCIPHER) {
 		skcipher_inst->alg.setkey	= essiv_skcipher_setkey;
 		skcipher_inst->alg.encrypt	= essiv_skcipher_encrypt;
 		skcipher_inst->alg.decrypt	= essiv_skcipher_decrypt;
 		skcipher_inst->alg.init		= essiv_skcipher_init_tfm;
 		skcipher_inst->alg.exit		= essiv_skcipher_exit_tfm;
 
-		skcipher_inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(skcipher_alg);
-		skcipher_inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(skcipher_alg);
+		skcipher_inst->alg.min_keysize	= skcipher_alg->min_keysize;
+		skcipher_inst->alg.max_keysize	= skcipher_alg->max_keysize;
 		skcipher_inst->alg.ivsize	= ivsize;
-		skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
-		skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
+		skcipher_inst->alg.chunksize	= skcipher_alg->chunksize;
 
 		skcipher_inst->free		= essiv_skcipher_free_instance;
 
@@ -616,7 +616,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 out_free_hash:
 	crypto_mod_put(_hash_alg);
 out_drop_skcipher:
-	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
+	if (type == CRYPTO_ALG_TYPE_LSKCIPHER)
 		crypto_drop_skcipher(&ictx->u.skcipher_spawn);
 	else
 		crypto_drop_aead(&ictx->u.aead_spawn);
-- 
2.39.2

