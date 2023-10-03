Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E235E776F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjJCDow (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjJCDou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:50 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F176BF
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:47 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKw-002wSv-RU; Tue, 03 Oct 2023 11:44:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/16] crypto: cts - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:28 +0800
Message-Id: <20231003034333.1441826-12-herbert@gondor.apana.org.au>
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
 crypto/cts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 8f604f6554b1..f5b42156b6c7 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -324,8 +324,8 @@ static void crypto_cts_free(struct skcipher_instance *inst)
 static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_alg_common *alg;
 	struct skcipher_instance *inst;
-	struct skcipher_alg *alg;
 	u32 mask;
 	int err;
 
@@ -344,10 +344,10 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_spawn_skcipher_alg(spawn);
+	alg = crypto_spawn_skcipher_alg_common(spawn);
 
 	err = -EINVAL;
-	if (crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
+	if (alg->ivsize != alg->base.cra_blocksize)
 		goto err_free_inst;
 
 	if (strncmp(alg->base.cra_name, "cbc(", 4))
@@ -363,9 +363,9 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
 	inst->alg.ivsize = alg->base.cra_blocksize;
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+	inst->alg.chunksize = alg->chunksize;
+	inst->alg.min_keysize = alg->min_keysize;
+	inst->alg.max_keysize = alg->max_keysize;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cts_ctx);
 
-- 
2.39.2

