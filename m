Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC051E776F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjJCDo5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjJCDoy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:54 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB807B7
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWL0-002wUF-4g; Tue, 03 Oct 2023 11:44:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/16] crypto: lrw - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:31 +0800
Message-Id: <20231003034333.1441826-15-herbert@gondor.apana.org.au>
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
 crypto/lrw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 59260aefed28..e216fbf2b786 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -299,8 +299,8 @@ static void lrw_free_instance(struct skcipher_instance *inst)
 static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_alg_common *alg;
 	struct skcipher_instance *inst;
-	struct skcipher_alg *alg;
 	const char *cipher_name;
 	char ecb_name[CRYPTO_MAX_ALG_NAME];
 	u32 mask;
@@ -336,13 +336,13 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_skcipher_spawn_alg(spawn);
+	alg = crypto_spawn_skcipher_alg_common(spawn);
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != LRW_BLOCK_SIZE)
 		goto err_free_inst;
 
-	if (crypto_skcipher_alg_ivsize(alg))
+	if (alg->ivsize)
 		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "lrw",
@@ -382,10 +382,8 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 				       (__alignof__(be128) - 1);
 
 	inst->alg.ivsize = LRW_BLOCK_SIZE;
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
-				LRW_BLOCK_SIZE;
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
-				LRW_BLOCK_SIZE;
+	inst->alg.min_keysize = alg->min_keysize + LRW_BLOCK_SIZE;
+	inst->alg.max_keysize = alg->max_keysize + LRW_BLOCK_SIZE;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct lrw_tfm_ctx);
 
-- 
2.39.2

