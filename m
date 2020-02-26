Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F269C4BA11
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 062422067C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693263;
	bh=PttdxIj3lqzreG0Wccf68PsarfLwS7UolPyxX7OQSjw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=16Zab3dH7yfe5gDLwu8IVURSsbYgsF2gnZCQygppUChn17oMr3YKqfAOubCgXqgaZ
	 EyUTMyjZrfhj2vYgWEAi3xfpCeSC+H8p0KXCoyFP+B1yw9Str3tKa0EAGVlnq72XU+
	 RmYuhQAkJmNTpPled3hE193SDNLpV/ks3U4E0glo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgBZFBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgBZFBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:01 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBCF222C2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693260;
        bh=PttdxIj3lqzreG0Wccf68PsarfLwS7UolPyxX7OQSjw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=F2gBKORdDf9eEmiGMG51XBIlc6U2IfGSVx6uv9E0PTwlZW5TH/lRpdQbORYRj3tkI
         zTm4XLcgH1eipH5mratPnATl3uj7DxTkj1bdIU0RpZInYG1b00KZ9PAMPnvQG45nH2
         3OlTX+CuAtWoAw6jAA769fNmExfQ4KK6KBty6SMg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 04/12] crypto: ctr - simplify error handling in crypto_rfc3686_create()
Date:   Tue, 25 Feb 2020 20:59:16 -0800
Message-Id: <20200226045924.97053-5-ebiggers@kernel.org>
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

Simplify the error handling in crypto_rfc3686_create() by taking
advantage of crypto_grab_skcipher() now handling an ERR_PTR() name and
by taking advantage of crypto_drop_skcipher() now accepting (as a no-op)
a spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ctr.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a8feab621c6c1..31ac4ae598e17 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -260,7 +260,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	struct skcipher_instance *inst;
 	struct skcipher_alg *alg;
 	struct crypto_skcipher_spawn *spawn;
-	const char *cipher_name;
 	u32 mask;
 
 	int err;
@@ -272,10 +271,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	cipher_name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(cipher_name))
-		return PTR_ERR(cipher_name);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -287,7 +282,7 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	spawn = skcipher_instance_ctx(inst);
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
-				   cipher_name, 0, mask);
+				   crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -296,20 +291,20 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	/* We only support 16-byte blocks. */
 	err = -EINVAL;
 	if (crypto_skcipher_alg_ivsize(alg) != CTR_RFC3686_BLOCK_SIZE)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	/* Not a stream cipher? */
 	if (alg->base.cra_blocksize != 1)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "rfc3686(%s)", alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_drop_spawn;
+		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "rfc3686(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
@@ -336,17 +331,11 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	inst->free = crypto_rfc3686_free;
 
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
+		crypto_rfc3686_free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template crypto_ctr_tmpls[] = {
-- 
2.25.1

