Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80020C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D70206D8
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589483122;
	bh=gb/i0j2gNia+7sEXHbZ90BuWjrlQGacJSxf8ncd9gpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MbCkyJ7H5M6LDCyB3KeDU2OOeldKUc06f3ruCFlZ4zVjmuC1yGEn6p4/QVwD0uqBk
	 V7viG0DEMbcVksNFaW1gBc3Ar7HKhU2naHueQ9ZrKd6ZpP76K4PEmZMpOYsGQP1bTg
	 3TDPk6yAxg7MO1/xXEmIhk8HLUuNAxazwA4Pik/Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgENSyO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 14:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgENSyK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 14:54:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4D3206F1;
        Thu, 14 May 2020 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482449;
        bh=gb/i0j2gNia+7sEXHbZ90BuWjrlQGacJSxf8ncd9gpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2Dc1Oz6JAEsu2J183rFq/wefmVKABhCNWhyawa8rfmm7dLGeDPLUr6IXftbDKe7b
         K4OKiINUFeJDHl9CeNAISbQLRhMB3AyQsuZwoDKV/vI66e5o1RVvWhoagyPu+rRGA4
         oxtqI2p40bVpQrSGv6PoCMuesxmlzigo5YjNjkZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 48/49] crypto: xts - simplify error handling in ->create()
Date:   Thu, 14 May 2020 14:53:09 -0400
Message-Id: <20200514185311.20294-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 732e540953477083082e999ff553622c59cffd5f ]

Simplify the error handling in the XTS template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index ab117633d64e7..73c648c373595 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -384,15 +384,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
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
@@ -405,20 +405,20 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
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
@@ -442,17 +442,11 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
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
2.20.1

