Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262FFC41513
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjJSFyf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5712126
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981CBC433C7
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694855;
        bh=ZglcWcSc/6r5kwTLpX9SlSkzhKg8wNTkUlAli5+ICIw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Trz63NTtoKbuZ6/LG+WwDV7L/PPd9dkgn3uHSmu9P8kPk+weOHNTX1jK618v1xueu
         LGCcaMYr2cZGhwRffg7h/B+RZwjIgTEdGDp3+W1JFughOZV/K78m5gQwAVqYMnbyym
         b6dpLBDGKu/Q+Oug8niYN35vLptzd8zUJX8/VTPT6uf8p8dFdfSrpU6WDNNW9D9n3r
         cx9pZo8KvuiNSMtukKsChuNmth+Sya8eF/x8+OeAySFg8TAfWmUCikkhsAxUUyr3AO
         JJP2JKMNa8/8+/Ur/mLCsc9j0W9GRik/4BwkNKT9No1+zpSnxih0sD1H7OV8xSkWkm
         x1DU3IsPaEb2A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 16/17] crypto: hctr2 - stop using alignmask of shash_alg
Date:   Wed, 18 Oct 2023 22:53:42 -0700
Message-ID: <20231019055343.588846-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the shash algorithm type does not support nonzero alignmasks,
shash_alg::base.cra_alignmask is always 0, so OR-ing it into another
value is a no-op.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hctr2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index 653fde727f0fa..87e7547ad1862 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -478,22 +478,21 @@ static int hctr2_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "hctr2_base(%s,%s)",
 		     xctr_alg->base.cra_driver_name,
 		     polyval_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct hctr2_tfm_ctx) +
 				     polyval_alg->statesize * 2;
-	inst->alg.base.cra_alignmask = xctr_alg->base.cra_alignmask |
-				       polyval_alg->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = xctr_alg->base.cra_alignmask;
 	/*
 	 * The hash function is called twice, so it is weighted higher than the
 	 * xctr and blockcipher.
 	 */
 	inst->alg.base.cra_priority = (2 * xctr_alg->base.cra_priority +
 				       4 * polyval_alg->base.cra_priority +
 				       blockcipher_alg->cra_priority) / 7;
 
 	inst->alg.setkey = hctr2_setkey;
 	inst->alg.encrypt = hctr2_encrypt;
-- 
2.42.0

