Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B8C4BA10
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4D772067C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693264;
	bh=5laeDQs86G7LBHjHkqd2n1YkIxXWCby9msKA7DAx3w0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r2uqMOPbPyqnTkXqCFexqS71O9BV4+b0GV8/33suDzGJ3BIYFUAenAAB/Iekpg8WK
	 iGfmuaYG6LtDq13xizyvAtet2Wgryli7mq4ADB81Dxyzs3cSpYgqNaolz/zqtrzS2A
	 RHAyb/1cpl1zg9QfH3GVtJ7IwoQmX+76o/tQTZyw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgBZFBD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgBZFBC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054C820658
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693262;
        bh=5laeDQs86G7LBHjHkqd2n1YkIxXWCby9msKA7DAx3w0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=2dpPrhEBqsQW8+tTL5VuldkzkQ1iIQfekSGxPzt9f1nRCoooM9eMIPsYAg2iNWaEs
         oSzg7ygDcX85yfr9vh/iROu0ux2aJyUJlNgsyosnJ1diGL7QLdXcznpYwgNUiMi0zr
         8HPUjHUd5rPKIvy7Tsygeam4rioBcLqNDC3tPWqw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 12/12] crypto: xts - simplify error handling in ->create()
Date:   Tue, 25 Feb 2020 20:59:24 -0800
Message-Id: <20200226045924.97053-13-ebiggers@kernel.org>
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

Simplify the error handling in the XTS template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/xts.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 29efa15f14954..dbdd8af629e69 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -379,15 +379,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != XTS_BLOCK_SIZE)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	if (crypto_skcipher_alg_ivsize(alg))
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "xts",
 				  &alg->base);
 	if (err)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = -EINVAL;
 	cipher_name = alg->base.cra_name;
@@ -400,20 +400,20 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
 		if (len < 2 || len >= sizeof(ctx->name))
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		ctx->name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
-			goto err_drop_spawn;
+			goto err_free_inst;
 		}
 	} else
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -437,17 +437,11 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = free;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_spawn;
-
-out:
-	return err;
-
-err_drop_spawn:
-	crypto_drop_skcipher(&ctx->spawn);
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

