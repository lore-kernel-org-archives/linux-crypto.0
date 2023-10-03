Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2728DE776FD
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjJCDow (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjJCDov (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:51 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F8C6
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:48 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKx-002wTN-U2; Tue, 03 Oct 2023 11:44:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/16] crypto: gcm - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:29 +0800
Message-Id: <20231003034333.1441826-13-herbert@gondor.apana.org.au>
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
 crypto/gcm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 4ba624450c3f..91ce6e0e2afc 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -576,10 +576,10 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
+	struct skcipher_alg_common *ctr;
 	u32 mask;
 	struct aead_instance *inst;
 	struct gcm_instance_ctx *ctx;
-	struct skcipher_alg *ctr;
 	struct hash_alg_common *ghash;
 	int err;
 
@@ -607,13 +607,12 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				   ctr_name, 0, mask);
 	if (err)
 		goto err_free_inst;
-	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
+	ctr = crypto_spawn_skcipher_alg_common(&ctx->ctr);
 
 	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
 	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
-	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
-	    ctr->base.cra_blocksize != 1)
+	    ctr->ivsize != 16 || ctr->base.cra_blocksize != 1)
 		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
@@ -634,7 +633,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				       ctr->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.ivsize = GCM_AES_IV_SIZE;
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(ctr);
+	inst->alg.chunksize = ctr->chunksize;
 	inst->alg.maxauthsize = 16;
 	inst->alg.init = crypto_gcm_init_tfm;
 	inst->alg.exit = crypto_gcm_exit_tfm;
-- 
2.39.2

