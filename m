Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20246E776F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjJCDot (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjJCDop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:45 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EB7B8
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKq-002wQy-6u; Tue, 03 Oct 2023 11:44:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/16] crypto: adiantum - Only access common skcipher fields on spawn
Date:   Tue,  3 Oct 2023 11:43:22 +0800
Message-Id: <20231003034333.1441826-6-herbert@gondor.apana.org.au>
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
 crypto/adiantum.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index c33ba22a6638..51703746d91e 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -468,7 +468,7 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
  * Check for a supported set of inner algorithms.
  * See the comment at the beginning of this file.
  */
-static bool adiantum_supported_algorithms(struct skcipher_alg *streamcipher_alg,
+static bool adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
 					  struct crypto_alg *blockcipher_alg,
 					  struct shash_alg *hash_alg)
 {
@@ -494,7 +494,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	const char *nhpoly1305_name;
 	struct skcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
-	struct skcipher_alg *streamcipher_alg;
+	struct skcipher_alg_common *streamcipher_alg;
 	struct crypto_alg *blockcipher_alg;
 	struct shash_alg *hash_alg;
 	int err;
@@ -514,7 +514,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
-	streamcipher_alg = crypto_spawn_skcipher_alg(&ictx->streamcipher_spawn);
+	streamcipher_alg = crypto_spawn_skcipher_alg_common(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
 	err = crypto_grab_cipher(&ictx->blockcipher_spawn,
@@ -578,8 +578,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.decrypt = adiantum_decrypt;
 	inst->alg.init = adiantum_init_tfm;
 	inst->alg.exit = adiantum_exit_tfm;
-	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(streamcipher_alg);
-	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(streamcipher_alg);
+	inst->alg.min_keysize = streamcipher_alg->min_keysize;
+	inst->alg.max_keysize = streamcipher_alg->max_keysize;
 	inst->alg.ivsize = TWEAK_SIZE;
 
 	inst->free = adiantum_free_instance;
-- 
2.39.2

