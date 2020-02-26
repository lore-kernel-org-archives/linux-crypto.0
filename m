Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05562C4BA0F
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D091920658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693262;
	bh=ukrrJdhCt2fYDZAvYR+ypFP4VNz9zKLiI3U7uHj4wqw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZBcoIV4KPUmAhqgj3iHXoxBL2TpWwzD6bIAFP85HeBk+5Fd5DSgIOD4/mrQtHG5wQ
	 cP/nxAJbJrF0f29xL7adDdUrYWOgEDUZCD6ZwgKdSeFV6ac4L440SnIBx1vuvQTX24
	 3PlGryqaomgyIMsf8OsYEbalyfxmA8YRg4iLcQFU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EBE024650
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693261;
        bh=ukrrJdhCt2fYDZAvYR+ypFP4VNz9zKLiI3U7uHj4wqw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nrq7VUrn5J6cw3QrScXgJ6TdpsOZNrlQFUei41A3XyrBooM6EJ3/HIDQbAUDIsfY4
         RDQ7snhcv5lMxxAfytAloke3ZncbpY5nMZuAqektfo4qJWuQ8zm28aUf/D0DkcfxMt
         uFF2Y11zduVwzAwpcvOFxsc2hZo/HUvxzMZTfU24=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 08/12] crypto: geniv - simply error handling in aead_geniv_alloc()
Date:   Tue, 25 Feb 2020 20:59:20 -0800
Message-Id: <20200226045924.97053-9-ebiggers@kernel.org>
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

Simplify the error handling in aead_geniv_alloc() by taking advantage of
crypto_grab_aead() now handling an ERR_PTR() name and by taking
advantage of crypto_drop_aead() now accepting (as a no-op) a spawn that
hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/geniv.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/crypto/geniv.c b/crypto/geniv.c
index dbcc640274cda..6a90c52d49ad1 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -41,7 +41,6 @@ static void aead_geniv_free(struct aead_instance *inst)
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask)
 {
-	const char *name;
 	struct crypto_aead_spawn *spawn;
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
@@ -57,10 +56,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return ERR_CAST(name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return ERR_PTR(-ENOMEM);
@@ -71,7 +66,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	mask |= crypto_requires_sync(algt->type, algt->mask);
 
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
-			       name, type, mask);
+			       crypto_attr_alg_name(tb[1]), type, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -82,17 +77,17 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 
 	err = -EINVAL;
 	if (ivsize < sizeof(u64))
-		goto err_drop_alg;
+		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s)", tmpl->name, alg->base.cra_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_alg;
+		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s)", tmpl->name, alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_alg;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -111,10 +106,8 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 out:
 	return inst;
 
-err_drop_alg:
-	crypto_drop_aead(spawn);
 err_free_inst:
-	kfree(inst);
+	aead_geniv_free(inst);
 	inst = ERR_PTR(err);
 	goto out;
 }
-- 
2.25.1

