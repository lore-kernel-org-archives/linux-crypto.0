Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71477C32767
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4896621D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024099;
	bh=BxDmQFQEkRoqmQOoVJ48e4mMgrQdpm4kPf07VDLLxNM=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h/uutTB2DSq8LSEHqH7cuH89FpU77Sk8vilMWmS8cIukQ7KjMWuY3f9Vh+u5rwfMT
	 FYb9DQLOPL2hPGquh72qAfM2/jL0Otfg2UHl8unW/DONsx51CMPIEZ/b8criz5aVUY
	 nqAez3OrA2jI2l0Bszs6TNatexUcYZSmVqdBWD0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgACEBh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgACEB1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:27 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A38EA2253D
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024086;
        bh=BxDmQFQEkRoqmQOoVJ48e4mMgrQdpm4kPf07VDLLxNM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z/sOqWcxkq8g272DBcLzs0BN42N7FDSPVz2D04yguQBgtWxs5kV/VM/Qr0mb3Z7g6
         fvxztNbwQC+qPYdGWnf0U4XKaj/9e/c/D2TCKBn66qS29yTmj8ux9Hqc0bV2TGwzRE
         +kypzCRK5n6mJF+L0hE/WohHIV17B71/Q2TPN+Rg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 13/28] crypto: cryptd - use crypto_grab_shash() and simplify error paths
Date:   Thu,  2 Jan 2020 19:58:53 -0800
Message-Id: <20200103035908.12048-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
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
index 5aea6d6c49a0..3224f142c824 100644
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
+		goto err_free_inst;
+	alg = crypto_spawn_shash_alg(&ctx->spawn);
+
+	err = cryptd_init_instance(ahash_crypto_instance(inst), &alg->base);
+	if (err)
+		goto err_free_inst;
 
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
 	if (err) {
+err_free_inst:
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

