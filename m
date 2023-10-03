Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70F7E776F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjJCDou (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjJCDop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:45 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BACC4
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKr-002wRC-AS; Tue, 03 Oct 2023 11:44:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/16] crypto: authenc - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:23 +0800
Message-Id: <20231003034333.1441826-7-herbert@gondor.apana.org.au>
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
 crypto/authenc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 3326c7343e86..fa896ab143bd 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -373,9 +373,9 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	u32 mask;
 	struct aead_instance *inst;
 	struct authenc_instance_ctx *ctx;
+	struct skcipher_alg_common *enc;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
-	struct skcipher_alg *enc;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
@@ -398,7 +398,7 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 				   crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
 		goto err_free_inst;
-	enc = crypto_spawn_skcipher_alg(&ctx->enc);
+	enc = crypto_spawn_skcipher_alg_common(&ctx->enc);
 
 	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
 			    auth_base->cra_alignmask + 1);
@@ -422,8 +422,8 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 				       enc->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
 
-	inst->alg.ivsize = crypto_skcipher_alg_ivsize(enc);
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(enc);
+	inst->alg.ivsize = enc->ivsize;
+	inst->alg.chunksize = enc->chunksize;
 	inst->alg.maxauthsize = auth->digestsize;
 
 	inst->alg.init = crypto_authenc_init_tfm;
-- 
2.39.2

