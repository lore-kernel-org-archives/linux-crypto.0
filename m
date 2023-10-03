Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D11FE776F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjJCDoo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjJCDom (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:42 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17237B7
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKp-002wQq-4N; Tue, 03 Oct 2023 11:44:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 04/16] crypto: cryptd - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:21 +0800
Message-Id: <20231003034333.1441826-5-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
References: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As skcipher spawns may be of the type lskcipher, only the common
fields may be accessed.  This was already the case but use the
correct helpers to make this more obvious.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/cryptd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 194a92d677b9..31d022d47f7a 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -377,7 +377,7 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 {
 	struct skcipherd_instance_ctx *ctx;
 	struct skcipher_instance *inst;
-	struct skcipher_alg *alg;
+	struct skcipher_alg_common *alg;
 	u32 type;
 	u32 mask;
 	int err;
@@ -396,17 +396,17 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_spawn_skcipher_alg(&ctx->spawn);
+	alg = crypto_spawn_skcipher_alg_common(&ctx->spawn);
 	err = cryptd_init_instance(skcipher_crypto_instance(inst), &alg->base);
 	if (err)
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags |= CRYPTO_ALG_ASYNC |
 		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
-	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+	inst->alg.ivsize = alg->ivsize;
+	inst->alg.chunksize = alg->chunksize;
+	inst->alg.min_keysize = alg->min_keysize;
+	inst->alg.max_keysize = alg->max_keysize;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_skcipher_ctx);
 
-- 
2.39.2

