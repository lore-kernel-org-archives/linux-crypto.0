Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F81C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 12:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9E8611C8
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 12:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhIJMQq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 08:16:46 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37878
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232941AbhIJMQp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 08:16:45 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id AF3223F328;
        Fri, 10 Sep 2021 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631276132;
        bh=WH5acUJXrOaRqz+J2404Ycvly8mHVPMOcA9T/AX5FBw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=b0PPT3Tadgfgm16gBw637065w4w47RlmElz/m56mi5dfOfRt8xW8x5u7Uxzzzg6aS
         0qRdyU2IWl2rVPnw1aoqI3eJfEU8Ecgsa2EVZC18VWDS71FJbiY8UvCWSdT/4T6yx7
         SyVjA/lwqnpfjTNH8pTdsAUPcosdbBRQVJNtm0pZTCuQ4TNz2ekL2lj6JT7Iy128g1
         l2jtkPXn2npVaNbKyx9zfxDYHDQPs5HUJwWe832vmcFO2gXXN1VxBlfr67jG9amtCm
         p4Vjlt8jg8B9BSaXdGOaFHWd2SKSFKN/vy4t99XyVNOBrlhKtKFWqrlqF8hJTSEnZL
         RZjPidX5CVeHg==
From:   Colin King <colin.king@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: img-hash: remove need for error return variable ret
Date:   Fri, 10 Sep 2021 13:15:32 +0100
Message-Id: <20210910121532.50366-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment to error return variable ret and then the jump to
an error exit path can be simplified by just returning the error
return at the failure point. This allows variable ret and the
error return path to be removed. This cleans up a static analysis
warninng that variable ret is being assigned (value never being
used) and being re-assigned later.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/img-hash.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index aa4c7b2af3e2..d8e82d69745d 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -674,14 +674,12 @@ static int img_hash_digest(struct ahash_request *req)
 static int img_hash_cra_init(struct crypto_tfm *tfm, const char *alg_name)
 {
 	struct img_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err = -ENOMEM;
 
 	ctx->fallback = crypto_alloc_ahash(alg_name, 0,
 					   CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback)) {
 		pr_err("img_hash: Could not load fallback driver.\n");
-		err = PTR_ERR(ctx->fallback);
-		goto err;
+		return PTR_ERR(ctx->fallback);
 	}
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct img_hash_request_ctx) +
@@ -689,9 +687,6 @@ static int img_hash_cra_init(struct crypto_tfm *tfm, const char *alg_name)
 				 IMG_HASH_DMA_THRESHOLD);
 
 	return 0;
-
-err:
-	return err;
 }
 
 static int img_hash_cra_md5_init(struct crypto_tfm *tfm)
-- 
2.32.0

