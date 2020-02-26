Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F1BC4BA0D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4405820658
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693265;
	bh=JWiL5EYFqROT3KU3uMX3K7+vkn9rT8D0FcCaVmsk4ZI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PQRLR/+jLvm/EPurRCzc/Y6HPQpZ/MzgtYU+Mvm5UEVJ3hlPKSRqm7D79VA15oiN/
	 K4yN+gR2cMmXiDlPTe1DV29nOHXxUdEzEriOug4m4LnYUbdauEHYwnR34kTD+Xpbju
	 cpUgx6ERf9uaiqSzoQTdj/Dl2lnu+bIfSAzpo7ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgBZFBE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAADA20658
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693260;
        bh=JWiL5EYFqROT3KU3uMX3K7+vkn9rT8D0FcCaVmsk4ZI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PTzBpKYMHXenFEpjDokFpIV/SzkRw5TrhfIxVQ6tPIjnOpBXqhqV6UAGOcTSPn7wd
         NDXYoaTsObtooCOuQgoolJIXgntGJDasxKuTKj835lM/QVtnnXxRprpEv132+GfwFT
         dsyEE34f93uf+zTG5GHLg93XEcYupjncXsip4Rco=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 05/12] crypto: cts - simplify error handling in crypto_cts_create()
Date:   Tue, 25 Feb 2020 20:59:17 -0800
Message-Id: <20200226045924.97053-6-ebiggers@kernel.org>
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

Simplify the error handling in crypto_cts_create() by taking advantage
of crypto_grab_skcipher() now handling an ERR_PTR() name and by taking
advantage of crypto_drop_skcipher() now accepting (as a no-op) a spawn
that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cts.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 48188adc8e91c..5e005c4f02215 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -327,7 +327,6 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct skcipher_instance *inst;
 	struct crypto_attr_type *algt;
 	struct skcipher_alg *alg;
-	const char *cipher_name;
 	u32 mask;
 	int err;
 
@@ -340,10 +339,6 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	mask = crypto_requires_sync(algt->type, algt->mask);
 
-	cipher_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(cipher_name))
-		return PTR_ERR(cipher_name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -351,7 +346,7 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = skcipher_instance_ctx(inst);
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
-				   cipher_name, 0, mask);
+				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -359,15 +354,15 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	if (crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	if (strncmp(alg->base.cra_name, "cbc(", 4))
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cts",
 				  &alg->base);
 	if (err)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -391,17 +386,11 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = crypto_cts_free;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_spawn;
-
-out:
-	return err;
-
-err_drop_spawn:
-	crypto_drop_skcipher(spawn);
+	if (err) {
 err_free_inst:
-	kfree(inst);
-	goto out;
+		crypto_cts_free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template crypto_cts_tmpl = {
-- 
2.25.1

