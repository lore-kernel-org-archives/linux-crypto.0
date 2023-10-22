Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081CAC25B41
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjJVITI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00AD13E
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E5AC433CB
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962728;
        bh=TVqrhoCS2w7qxwVjScgFIrOOQ/TNDwB8i4iW4nh1QUE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OjC1btectAeIxjsAkUzgd4EchM0EWoMwYfu5Vo1zOW+NdbeaI3NRpLMnuKfEccuvk
         mFQ1QXiAJP4fQeMUgkBzgU9Zw2cmN5kYfUCEeWDvSJdDLyq6tAS5PqPl6auUQZsFuu
         dmB5nXMAuckUHZgmJ/LqfqdKW589gvTz9z/6LW3aM4M66BaWelJ+H3Dfc/AS0thK2o
         3P067pgZA2sVg2ScqEmI6A1FHBtfmSSPDKnH8i5BPmz/9SpxKk6VNwXOK7FWabvL2w
         rk5xv9ASY9iQEmz7mhLCKogXPdTiQ6yUED0ubes8vSvifxbUEgtqTrmf5oSuZCyCRa
         IMUUv6jYwpt9Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 22/30] crypto: gcm - stop using alignmask of ahash
Date:   Sun, 22 Oct 2023 01:10:52 -0700
Message-ID: <20231022081100.123613-23-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the alignmask for ahash and shash algorithms is always 0,
simplify crypto_gcm_create_common() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 91ce6e0e2afc1..84f7c23d14e48 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -622,22 +622,21 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
 		     ghash->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
-	inst->alg.base.cra_alignmask = ghash->base.cra_alignmask |
-				       ctr->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = ctr->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.ivsize = GCM_AES_IV_SIZE;
 	inst->alg.chunksize = ctr->chunksize;
 	inst->alg.maxauthsize = 16;
 	inst->alg.init = crypto_gcm_init_tfm;
 	inst->alg.exit = crypto_gcm_exit_tfm;
 	inst->alg.setkey = crypto_gcm_setkey;
 	inst->alg.setauthsize = crypto_gcm_setauthsize;
 	inst->alg.encrypt = crypto_gcm_encrypt;
 	inst->alg.decrypt = crypto_gcm_decrypt;
-- 
2.42.0

