Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5E6C4BA14
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6371020658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693264;
	bh=APCpCZ7hSn7B1jgf9/ybXYkfluvNjA0o648Pw0wRYsI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jzo8wXwaGDyTL7VhSWKIrgP5X5Q+W6AO6NyyAHpKFM2Zl1ioDh8WrzhcqD4uU92ol
	 2PzWxLFnfqpBL0GpHAPRflCnTIyLIr11QINDshSTiG+GNSIhDCQQrwyR41FAWiODMN
	 8/GKuw4TK34ehqhj/Z9Om7oztD4DJ6cdlCqTl7DE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1180820726
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693261;
        bh=APCpCZ7hSn7B1jgf9/ybXYkfluvNjA0o648Pw0wRYsI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZfH28Ljh0B6h+7y8kzGvSZM2bTxEo4Yyznwaqr3xa+z/+B1m5Fh+jKMNZA5jjZVkA
         21qzufjXhpEfNDHKoKXaGkyB4R4RFrEDY/ODQmoat44RDLnxqKK7cE4CVYxof6de8u
         4+4vekOLVN0wnjCenwLB6WUz9gaMhXOqh0BHB7V8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 07/12] crypto: gcm - simplify error handling in crypto_rfc4543_create()
Date:   Tue, 25 Feb 2020 20:59:19 -0800
Message-Id: <20200226045924.97053-8-ebiggers@kernel.org>
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

Simplify the error handling in crypto_rfc4543_create() by taking
advantage of crypto_grab_aead() now handling an ERR_PTR() name and by
taking advantage of crypto_drop_aead() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Conveniently, this eliminates the 'ccm_name' variable which was
incorrectly named (it should have been 'gcm_name').

Also fix a weird case where a line was terminated by a comma rather than
a semicolon, causing the statement to be continued on the next line.
Fortunately the code still behaved as intended, though.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 5560341e28105..0103d28c541eb 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1060,10 +1060,8 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
-	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
 	struct crypto_rfc4543_instance_ctx *ctx;
-	const char *ccm_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -1075,32 +1073,27 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	ccm_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(ccm_name))
-		return PTR_ERR(ccm_name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
 	ctx = aead_instance_ctx(inst);
-	spawn = &ctx->aead;
-	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
-			       ccm_name, 0, mask);
+	err = crypto_grab_aead(&ctx->aead, aead_crypto_instance(inst),
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
-	alg = crypto_spawn_aead_alg(spawn);
+	alg = crypto_spawn_aead_alg(&ctx->aead);
 
 	err = -EINVAL;
 
 	/* Underlying IV size must be 12. */
 	if (crypto_aead_alg_ivsize(alg) != GCM_AES_IV_SIZE)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	/* Not a stream cipher? */
 	if (alg->base.cra_blocksize != 1)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
@@ -1109,7 +1102,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "rfc4543(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto out_drop_alg;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -1130,20 +1123,14 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = crypto_rfc4543_encrypt;
 	inst->alg.decrypt = crypto_rfc4543_decrypt;
 
-	inst->free = crypto_rfc4543_free,
+	inst->free = crypto_rfc4543_free;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_alg;
-
-out:
+	if (err) {
+err_free_inst:
+		crypto_rfc4543_free(inst);
+	}
 	return err;
-
-out_drop_alg:
-	crypto_drop_aead(spawn);
-out_free_inst:
-	kfree(inst);
-	goto out;
 }
 
 static struct crypto_template crypto_gcm_tmpls[] = {
-- 
2.25.1

