Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F01C4BA0B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF9E20726
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693264;
	bh=I7u7LPLFKrXVjTGFI1YEGtNIctou1QCT/0np+2/nC6w=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZDp06zk9gLVnLrQaucBSQphUVqOWIEKJhxvPppK07oFkj6bcYhjNp4VO1GZJvj1eG
	 Aj/gxlJMxxlikrgXgDz4gEp/JC3XjrM7gMi8FaPpRADmH0RCdp7sullbwWY040Ck9A
	 ugc5Mh5RojDJxtrjYUecAlO88nOyWbuPByvkLSvI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgBZFBE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgBZFBC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD3F2465D
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693261;
        bh=I7u7LPLFKrXVjTGFI1YEGtNIctou1QCT/0np+2/nC6w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=W+9w9UoLCpXuspht9e+XuQZVaBGzY3W39GmG4o9eQv+xkKp2eoKRBowAsD7kics+l
         kOATfQ4uvZqw6CYr2OIoURZdBL36deNsv1gA/1YcnNWNn1OsWATll/vJ/JykA7kkNY
         d5sHorufdT28rhicjHU1XELRdTQehIKVK3npPgck=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 10/12] crypto: pcrypt - simplify error handling in pcrypt_create_aead()
Date:   Tue, 25 Feb 2020 20:59:22 -0800
Message-Id: <20200226045924.97053-11-ebiggers@kernel.org>
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

Simplify the error handling in pcrypt_create_aead() by taking advantage
of crypto_grab_aead() now handling an ERR_PTR() name and by taking
advantage of crypto_drop_aead() now accepting (as a no-op) a spawn that
hasn't been grabbed yet.

This required also making padata_free_shell() accept a NULL argument.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/pcrypt.c | 33 +++++++++------------------------
 kernel/padata.c |  7 ++++---
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 1b632139a8c1a..8bddc65cd5092 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -232,17 +232,12 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
-	const char *name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -252,21 +247,21 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	ctx = aead_instance_ctx(inst);
 	ctx->psenc = padata_alloc_shell(pencrypt);
 	if (!ctx->psenc)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	ctx->psdec = padata_alloc_shell(pdecrypt);
 	if (!ctx->psdec)
-		goto out_free_psenc;
+		goto err_free_inst;
 
 	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
-			       name, 0, 0);
+			       crypto_attr_alg_name(tb[1]), 0, 0);
 	if (err)
-		goto out_free_psdec;
+		goto err_free_inst;
 
 	alg = crypto_spawn_aead_alg(&ctx->spawn);
 	err = pcrypt_init_instance(aead_crypto_instance(inst), &alg->base);
 	if (err)
-		goto out_drop_aead;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
 
@@ -286,21 +281,11 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->free = pcrypt_free;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto out_drop_aead;
-
-out:
+	if (err) {
+err_free_inst:
+		pcrypt_free(inst);
+	}
 	return err;
-
-out_drop_aead:
-	crypto_drop_aead(&ctx->spawn);
-out_free_psdec:
-	padata_free_shell(ctx->psdec);
-out_free_psenc:
-	padata_free_shell(ctx->psenc);
-out_free_inst:
-	kfree(inst);
-	goto out;
 }
 
 static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
diff --git a/kernel/padata.c b/kernel/padata.c
index 62082597d4a2a..a6afa12fb75ee 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1038,12 +1038,13 @@ EXPORT_SYMBOL(padata_alloc_shell);
  */
 void padata_free_shell(struct padata_shell *ps)
 {
-	struct padata_instance *pinst = ps->pinst;
+	if (!ps)
+		return;
 
-	mutex_lock(&pinst->lock);
+	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	padata_free_pd(rcu_dereference_protected(ps->pd, 1));
-	mutex_unlock(&pinst->lock);
+	mutex_unlock(&ps->pinst->lock);
 
 	kfree(ps);
 }
-- 
2.25.1

