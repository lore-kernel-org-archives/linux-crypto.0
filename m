Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926AEC4BA0A
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A87920658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693263;
	bh=kPpi7iiHdx8tqZ6wX8PT673fny11q9FyFnpnO8/nBfc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ilaupVBMmrD0vGOgLDs2/M1q1xYoSbOlNws5HIFRhj9N8TMinB1JdXmEtvLp73wCg
	 NSiIoEPemHxFjoImWDMuLeVvDrGjTCUXDc5UKpvofyFFLqaVXzNgCEz0xBcqGhrlMv
	 Ywzgv9e44DO91ZO/iuBx0+q9Qb/CqMeQ4Ce311PQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE0E21D7E
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693260;
        bh=kPpi7iiHdx8tqZ6wX8PT673fny11q9FyFnpnO8/nBfc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jwukY8HUQGalPXue3eVXX7g311BaYt+cBt+WgN4TfAYuzfTZOpL95GsBQ5mxK1jwc
         CXn14d6gtoZl9DSwU9H1oZg2hN08G66aATokJb2Ew9uH15G77nI/4EurBJGh6zBAqz
         WbnyUw28POWD8OsHv1VdSECkVFEznLPve4eiRXvs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 03/12] crypto: cryptd - simplify error handling in cryptd_create_*()
Date:   Tue, 25 Feb 2020 20:59:15 -0800
Message-Id: <20200226045924.97053-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226045924.97053-1-ebiggers@kernel.org>
References: <20200226045924.97053-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify the error handling in the various cryptd_create_*() functions
by taking advantage of crypto_grab_*() now handling an ERR_PTR() name
and by taking advantage of crypto_drop_*() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cryptd.c | 37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index d94c75c840a5e..283212262adbb 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -369,7 +369,6 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	struct skcipherd_instance_ctx *ctx;
 	struct skcipher_instance *inst;
 	struct skcipher_alg *alg;
-	const char *name;
 	u32 type;
 	u32 mask;
 	int err;
@@ -379,10 +378,6 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 
 	cryptd_check_internal(tb, &type, &mask);
 
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -391,14 +386,14 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	ctx->queue = queue;
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
-				   name, type, mask);
+				   crypto_attr_alg_name(tb[1]), type, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	alg = crypto_spawn_skcipher_alg(&ctx->spawn);
 	err = cryptd_init_instance(skcipher_crypto_instance(inst), &alg->base);
 	if (err)
-		goto out_drop_skcipher;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
 				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
@@ -421,10 +416,8 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
-out_drop_skcipher:
-		crypto_drop_skcipher(&ctx->spawn);
-out_free_inst:
-		kfree(inst);
+err_free_inst:
+		cryptd_skcipher_free(inst);
 	}
 	return err;
 }
@@ -694,8 +687,7 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	err = ahash_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		crypto_drop_shash(&ctx->spawn);
-		kfree(inst);
+		cryptd_hash_free(inst);
 	}
 	return err;
 }
@@ -833,17 +825,12 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	struct aead_instance_ctx *ctx;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
-	const char *name;
 	u32 type = 0;
 	u32 mask = CRYPTO_ALG_ASYNC;
 	int err;
 
 	cryptd_check_internal(tb, &type, &mask);
 
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -852,14 +839,14 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	ctx->queue = queue;
 
 	err = crypto_grab_aead(&ctx->aead_spawn, aead_crypto_instance(inst),
-			       name, type, mask);
+			       crypto_attr_alg_name(tb[1]), type, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	alg = crypto_spawn_aead_alg(&ctx->aead_spawn);
 	err = cryptd_init_instance(aead_crypto_instance(inst), &alg->base);
 	if (err)
-		goto out_drop_aead;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
 				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
@@ -879,10 +866,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 
 	err = aead_register_instance(tmpl, inst);
 	if (err) {
-out_drop_aead:
-		crypto_drop_aead(&ctx->aead_spawn);
-out_free_inst:
-		kfree(inst);
+err_free_inst:
+		cryptd_aead_free(inst);
 	}
 	return err;
 }
-- 
2.25.1

