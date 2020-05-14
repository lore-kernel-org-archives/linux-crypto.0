Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4A2C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F1BB2065F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589483337;
	bh=KuXimrsHA3zb0KgBizYd4QVjSY3d7N/R9dZqKgNYgYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0LoESRQ3ZP9IFCTUcPcP2S3k9zVwyHzBcARCPqtFNRdt4O8Dblp8KkcviBOoQon3y
	 Qbjjbkh609CuOOhDsk5dp8FsCg3DseCRjFE9gnGy2PgnI2+PhayywPqerUoJ6L56rK
	 l9re2DqbltDyd23/lCODRfm3gGwt7OCehOJmrlLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgENSxE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 14:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbgENSxE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 14:53:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5BE20727;
        Thu, 14 May 2020 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482383;
        bh=KuXimrsHA3zb0KgBizYd4QVjSY3d7N/R9dZqKgNYgYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d70w3SQQI4V43ciCzRlpOARZFsHYLYLyAI56BYRtpESrhsrFtOL0MFVU4C52wuI5t
         IAscvocbs5Hs3o1+xYT7eCkmnMghzQK6V6PXww+fEWdKGEi9xnHjC+x5LYPHrGINDe
         dNad4k4IqMyfzNkr4SHyNBPpyHcNa97D04sAD8fQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 60/62] crypto: lrw - simplify error handling in create()
Date:   Thu, 14 May 2020 14:51:45 -0400
Message-Id: <20200514185147.19716-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit d57063103332b95eac9c118900f35700a491da08 ]

Simplify the error handling in the LRW template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1

