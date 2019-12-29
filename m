Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D88C2D0C8
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADBE2176D
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588290;
	bh=np+roapxtX5jgIeLpF7LDUvmFP7uKtLrO4I887RMTSA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=U0ZKXqxWp36kRnNNy3WC3zlJAGr2nUhp2Gdw2MbgXh0I018/C6JeBjLz+vHf+1Xr5
	 yvmRc11r2Bals4+++eaZJ0WCpr37jy/iipBpeRKMbYyrx59TFo4QP/mVeRBoLGV6dp
	 kUGggIpoayz7E66WtTY5mk4B7BgT+onttV4jVB9Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfL2C6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfL2C6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:09 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B6921D7E
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588288;
        bh=np+roapxtX5jgIeLpF7LDUvmFP7uKtLrO4I887RMTSA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FG8gu/JB5kJg0JoRamVQvSybNJkTTzdIt75xet3LoX/oFBAi/G1TCNQ41KGogJ7s2
         DlCmPByG2LlpN1TeQ6RFR5wdd5oPGTGnk32IZj4XZYvtkrFRXw/UMW1ZMwR8+szspW
         7CXbpdKODx98TVGuS9aJTrT+iONfFQZs26ng5Qs8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 13/28] crypto: cryptd - use crypto_grab_shash() and simplify error paths
Date:   Sat, 28 Dec 2019 20:56:59 -0600
Message-Id: <20191229025714.544159-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the cryptd template (in the hash case) use the new function
crypto_grab_shash() to initialize its shash spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making cryptd_create_hash() allocate the instance directly
rather than use cryptd_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cryptd.c | 68 +++++++++++++------------------------------------
 1 file changed, 18 insertions(+), 50 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 5aea6d6c49a0..2b4c39a8fd80 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -221,32 +221,6 @@ static int cryptd_init_instance(struct crypto_instance *inst,
 	return 0;
 }
 
-static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
-				   unsigned int tail)
-{
-	char *p;
-	struct crypto_instance *inst;
-	int err;
-
-	p = kzalloc(head + sizeof(*inst) + tail, GFP_KERNEL);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	inst = (void *)(p + head);
-
-	err = cryptd_init_instance(inst, alg);
-	if (err)
-		goto out_free_inst;
-
-out:
-	return p;
-
-out_free_inst:
-	kfree(p);
-	p = ERR_PTR(err);
-	goto out;
-}
-
 static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 				  const u8 *key, unsigned int keylen)
 {
@@ -671,39 +645,36 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 {
 	struct hashd_instance_ctx *ctx;
 	struct ahash_instance *inst;
-	struct shash_alg *salg;
-	struct crypto_alg *alg;
+	struct shash_alg *alg;
 	u32 type = 0;
 	u32 mask = 0;
 	int err;
 
 	cryptd_check_internal(tb, &type, &mask);
 
-	salg = shash_attr_alg(tb[1], type, mask);
-	if (IS_ERR(salg))
-		return PTR_ERR(salg);
-
-	alg = &salg->base;
-	inst = cryptd_alloc_instance(alg, ahash_instance_headroom(),
-				     sizeof(*ctx));
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
 
 	ctx = ahash_instance_ctx(inst);
 	ctx->queue = queue;
 
-	err = crypto_init_shash_spawn(&ctx->spawn, salg,
-				      ahash_crypto_instance(inst));
+	err = crypto_grab_shash(&ctx->spawn, ahash_crypto_instance(inst),
+				crypto_attr_alg_name(tb[1]), type, mask);
 	if (err)
-		goto out_free_inst;
+		goto out;
+	alg = crypto_spawn_shash_alg(&ctx->spawn);
+
+	err = cryptd_init_instance(ahash_crypto_instance(inst), &alg->base);
+	if (err)
+		goto out;
 
 	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC |
-		(alg->cra_flags & (CRYPTO_ALG_INTERNAL |
-				   CRYPTO_ALG_OPTIONAL_KEY));
+		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL |
+					CRYPTO_ALG_OPTIONAL_KEY));
 
-	inst->alg.halg.digestsize = salg->digestsize;
-	inst->alg.halg.statesize = salg->statesize;
+	inst->alg.halg.digestsize = alg->digestsize;
+	inst->alg.halg.statesize = alg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
 	inst->alg.halg.base.cra_init = cryptd_hash_init_tfm;
@@ -715,19 +686,16 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.finup  = cryptd_hash_finup_enqueue;
 	inst->alg.export = cryptd_hash_export;
 	inst->alg.import = cryptd_hash_import;
-	if (crypto_shash_alg_has_setkey(salg))
+	if (crypto_shash_alg_has_setkey(alg))
 		inst->alg.setkey = cryptd_hash_setkey;
 	inst->alg.digest = cryptd_hash_digest_enqueue;
 
 	err = ahash_register_instance(tmpl, inst);
+out:
 	if (err) {
 		crypto_drop_shash(&ctx->spawn);
-out_free_inst:
 		kfree(inst);
 	}
-
-out_put_alg:
-	crypto_mod_put(alg);
 	return err;
 }
 
-- 
2.24.1

