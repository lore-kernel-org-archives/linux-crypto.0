Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87436E776F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbjJCDo5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjJCDow (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:52 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C149DCC
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKz-002wU3-02; Tue, 03 Oct 2023 11:44:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/16] crypto: hctr2 - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:30 +0800
Message-Id: <20231003034333.1441826-14-herbert@gondor.apana.org.au>
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
 crypto/hctr2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index 6f4c1884d0e9..653fde727f0f 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -406,10 +406,10 @@ static int hctr2_create_common(struct crypto_template *tmpl,
 			       const char *xctr_name,
 			       const char *polyval_name)
 {
+	struct skcipher_alg_common *xctr_alg;
 	u32 mask;
 	struct skcipher_instance *inst;
 	struct hctr2_instance_ctx *ictx;
-	struct skcipher_alg *xctr_alg;
 	struct crypto_alg *blockcipher_alg;
 	struct shash_alg *polyval_alg;
 	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
@@ -431,7 +431,7 @@ static int hctr2_create_common(struct crypto_template *tmpl,
 				   xctr_name, 0, mask);
 	if (err)
 		goto err_free_inst;
-	xctr_alg = crypto_spawn_skcipher_alg(&ictx->xctr_spawn);
+	xctr_alg = crypto_spawn_skcipher_alg_common(&ictx->xctr_spawn);
 
 	err = -EINVAL;
 	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
@@ -500,8 +500,8 @@ static int hctr2_create_common(struct crypto_template *tmpl,
 	inst->alg.decrypt = hctr2_decrypt;
 	inst->alg.init = hctr2_init_tfm;
 	inst->alg.exit = hctr2_exit_tfm;
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(xctr_alg);
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(xctr_alg);
+	inst->alg.min_keysize = xctr_alg->min_keysize;
+	inst->alg.max_keysize = xctr_alg->max_keysize;
 	inst->alg.ivsize = TWEAK_SIZE;
 
 	inst->free = hctr2_free_instance;
-- 
2.39.2

