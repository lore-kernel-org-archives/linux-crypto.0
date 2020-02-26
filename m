Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C9EC4BA13
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB1D20658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693264;
	bh=7SLlCC1YGdRQ/h+aQyJidKzAfNlLQuSKfCThJkShylU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nOPLotSB/cP0E7NaOYRxBoCcedDC4VV1QP33MDUyTslwWVTUFRi53F2NHBouPGovx
	 7CKFvVKTxLXfkm7vq03aOmMJOEmooFpHRH1ymivUTtgleVlI56v/rgCkWsiGhDJlB2
	 wIgrEcY/ZA2KkMgf06e2YOdxtpZzlkLqeMUw/KG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgBZFBD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgBZFBC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEAC24656
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693261;
        bh=7SLlCC1YGdRQ/h+aQyJidKzAfNlLQuSKfCThJkShylU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nmtWoO0iljjQZaWh6hykw6dKOxmFwUNHmFYEjifW0Buk/bPoKp7flNKgl1wL2bnQU
         DlODqDVVhXLKiq4WkoFuJLWwRDzv9Ju29PXMpO8y7ujyo+JdTBO5kalh7Z4DoFyOBr
         DIgqTRxbrE2tu8a2ciiZUOzkceNwBcBm0VJkUdoU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 11/12] crypto: rsa-pkcs1pad - simplify error handling in pkcs1pad_create()
Date:   Tue, 25 Feb 2020 20:59:23 -0800
Message-Id: <20200226045924.97053-12-ebiggers@kernel.org>
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

Simplify the error handling in pkcs1pad_create() by taking advantage of
crypto_grab_akcipher() now handling an ERR_PTR() name and by taking
advantage of crypto_drop_akcipher() now accepting (as a no-op) a spawn
that hasn't been grabbed yet.

While we're at it, also simplify the way the hash_name optional argument
is handled.  We only need to check whether it's present in one place,
and we can just assign directly to ctx->digest_info.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 59 +++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 176b63afec8d9..d31031de51bcb 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -596,14 +596,11 @@ static void pkcs1pad_free(struct akcipher_instance *inst)
 
 static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	const struct rsa_asn1_template *digest_info;
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct akcipher_instance *inst;
 	struct pkcs1pad_inst_ctx *ctx;
-	struct crypto_akcipher_spawn *spawn;
 	struct akcipher_alg *rsa_alg;
-	const char *rsa_alg_name;
 	const char *hash_name;
 	int err;
 
@@ -616,60 +613,49 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	rsa_alg_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(rsa_alg_name))
-		return PTR_ERR(rsa_alg_name);
-
-	hash_name = crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(hash_name))
-		hash_name = NULL;
-
-	if (hash_name) {
-		digest_info = rsa_lookup_asn1(hash_name);
-		if (!digest_info)
-			return -EINVAL;
-	} else
-		digest_info = NULL;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
 	ctx = akcipher_instance_ctx(inst);
-	spawn = &ctx->spawn;
-	ctx->digest_info = digest_info;
 
-	err = crypto_grab_akcipher(spawn, akcipher_crypto_instance(inst),
-				   rsa_alg_name, 0, mask);
+	err = crypto_grab_akcipher(&ctx->spawn, akcipher_crypto_instance(inst),
+				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
-	rsa_alg = crypto_spawn_akcipher_alg(spawn);
+	rsa_alg = crypto_spawn_akcipher_alg(&ctx->spawn);
 
 	err = -ENAMETOOLONG;
-
-	if (!hash_name) {
+	hash_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(hash_name)) {
 		if (snprintf(inst->alg.base.cra_name,
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
 			     rsa_alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
-			goto out_drop_alg;
+			goto err_free_inst;
 
 		if (snprintf(inst->alg.base.cra_driver_name,
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
 			     rsa_alg->base.cra_driver_name) >=
 			     CRYPTO_MAX_ALG_NAME)
-			goto out_drop_alg;
+			goto err_free_inst;
 	} else {
+		ctx->digest_info = rsa_lookup_asn1(hash_name);
+		if (!ctx->digest_info) {
+			err = -EINVAL;
+			goto err_free_inst;
+		}
+
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 			     "pkcs1pad(%s,%s)", rsa_alg->base.cra_name,
 			     hash_name) >= CRYPTO_MAX_ALG_NAME)
-			goto out_drop_alg;
+			goto err_free_inst;
 
 		if (snprintf(inst->alg.base.cra_driver_name,
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
 			     rsa_alg->base.cra_driver_name,
 			     hash_name) >= CRYPTO_MAX_ALG_NAME)
-			goto out_drop_alg;
+			goto err_free_inst;
 	}
 
 	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
@@ -691,15 +677,10 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = pkcs1pad_free;
 
 	err = akcipher_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_alg;
-
-	return 0;
-
-out_drop_alg:
-	crypto_drop_akcipher(spawn);
-out_free_inst:
-	kfree(inst);
+	if (err) {
+err_free_inst:
+		pkcs1pad_free(inst);
+	}
 	return err;
 }
 
-- 
2.25.1

