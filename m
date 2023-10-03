Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049E1E776F8
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjJCDov (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjJCDou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:50 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C11CE
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKv-002wSR-Nt; Tue, 03 Oct 2023 11:44:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/16] crypto: ctr - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:27 +0800
Message-Id: <20231003034333.1441826-11-herbert@gondor.apana.org.au>
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
 crypto/ctr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 23c698b22013..1420496062d5 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -258,8 +258,8 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
-	struct skcipher_alg *alg;
 	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_alg_common *alg;
 	u32 mask;
 	int err;
 
@@ -278,11 +278,11 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_spawn_skcipher_alg(spawn);
+	alg = crypto_spawn_skcipher_alg_common(spawn);
 
 	/* We only support 16-byte blocks. */
 	err = -EINVAL;
-	if (crypto_skcipher_alg_ivsize(alg) != CTR_RFC3686_BLOCK_SIZE)
+	if (alg->ivsize != CTR_RFC3686_BLOCK_SIZE)
 		goto err_free_inst;
 
 	/* Not a stream cipher? */
@@ -303,11 +303,9 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
 	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
-				CTR_RFC3686_NONCE_SIZE;
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
-				CTR_RFC3686_NONCE_SIZE;
+	inst->alg.chunksize = alg->chunksize;
+	inst->alg.min_keysize = alg->min_keysize + CTR_RFC3686_NONCE_SIZE;
+	inst->alg.max_keysize = alg->max_keysize + CTR_RFC3686_NONCE_SIZE;
 
 	inst->alg.setkey = crypto_rfc3686_setkey;
 	inst->alg.encrypt = crypto_rfc3686_crypt;
-- 
2.39.2

