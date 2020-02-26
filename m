Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC429C4BA12
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9427720726
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693263;
	bh=FgAiK5TMmSlvhj7NLv0z4I2C+JqpPce2yzZZBs7rqNI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EjpDzLK+vXQtpiIIEc92SCm0HJDW7kr4RIw+yMqm2vDapcLJ2lOVlr2e92/BcVm6e
	 nId+epENYRd/Zd84b62yA0FvejeonZwQLnhrYhtQq/5KlQJzyqSVgSL07lyx9jHGPb
	 83wo0BYzRbwdlYqll+op9ZzNmfPnRe05xpPLk61g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D40924653
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693261;
        bh=FgAiK5TMmSlvhj7NLv0z4I2C+JqpPce2yzZZBs7rqNI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ClnXuEzrkqu63eVuJGSuXNJHXVm+qbuAW6Tq0weVZ6XpChKYl/7QGY4ZQP6BslK0A
         lsbo0FzFVPvwZdzA7uxNibOeJBos0ZXSriYWj06IlsfSeOZkNxLUGSHeDKADOXfuOE
         5SO+xXFx9PbpM4+L2l+S5UnIEqYjfa+sALtUKjSE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 09/12] crypto: lrw - simplify error handling in create()
Date:   Tue, 25 Feb 2020 20:59:21 -0800
Message-Id: <20200226045924.97053-10-ebiggers@kernel.org>
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

Simplify the error handling in the LRW template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/lrw.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 63c485c0d8a66..376d7ed3f1f87 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -343,15 +343,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != LRW_BLOCK_SIZE)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	if (crypto_skcipher_alg_ivsize(alg))
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "lrw",
 				  &alg->base);
 	if (err)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = -EINVAL;
 	cipher_name = alg->base.cra_name;
@@ -364,20 +364,20 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
 		if (len < 2 || len >= sizeof(ecb_name))
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		ecb_name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
-			goto err_drop_spawn;
+			goto err_free_inst;
 		}
 	} else
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -403,17 +403,11 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = free;
 
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
+		free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template crypto_tmpl = {
-- 
2.25.1

