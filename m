Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5B7E784A8
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjJCDsZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjJCDos (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:48 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E8ABF
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKu-002wRu-Jm; Tue, 03 Oct 2023 11:44:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/16] crypto: chacha20poly1305 - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:26 +0800
Message-Id: <20231003034333.1441826-10-herbert@gondor.apana.org.au>
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
 crypto/chacha20poly1305.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 3a905c5d8f53..0e2e208d98f9 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -558,7 +558,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	u32 mask;
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
-	struct skcipher_alg *chacha;
+	struct skcipher_alg_common *chacha;
 	struct hash_alg_common *poly;
 	int err;
 
@@ -579,7 +579,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
-	chacha = crypto_spawn_skcipher_alg(&ctx->chacha);
+	chacha = crypto_spawn_skcipher_alg_common(&ctx->chacha);
 
 	err = crypto_grab_ahash(&ctx->poly, aead_crypto_instance(inst),
 				crypto_attr_alg_name(tb[2]), 0, mask);
@@ -591,7 +591,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if (poly->digestsize != POLY1305_DIGEST_SIZE)
 		goto err_free_inst;
 	/* Need 16-byte IV size, including Initial Block Counter value */
-	if (crypto_skcipher_alg_ivsize(chacha) != CHACHA_IV_SIZE)
+	if (chacha->ivsize != CHACHA_IV_SIZE)
 		goto err_free_inst;
 	/* Not a stream cipher? */
 	if (chacha->base.cra_blocksize != 1)
@@ -615,7 +615,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
 				     ctx->saltlen;
 	inst->alg.ivsize = ivsize;
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(chacha);
+	inst->alg.chunksize = chacha->chunksize;
 	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
 	inst->alg.init = chachapoly_init;
 	inst->alg.exit = chachapoly_exit;
-- 
2.39.2

