Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2638CDB482
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjJSFye (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978C1124
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A203C433C9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694855;
        bh=nrvdUnNzBcEYHOgVy+o433Wmsw1Eb+ZN29j5yZ8/iW0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UcujRJ/ZzXStpBtb+1q8h6Z+lV26x/5L/eylyo7ppBI/IsGKUpKZ3CGIhnSJ8PQUF
         mLA1X0BT/VaiuoXvXDn1koLOFXQ76XJiP+fjS7u8eXh4WdiT4NReVhKgI//eUwr5wy
         PodKm46iaE16TmlGWzqKX6m8QIVykug0pIex6NSFnE29NqCm3bbd6OxWPZriOqwCeb
         +aI8M7DhUtxEjfYUy5oAAoIzI4+nBotm5VCQEiFHINflz34/rnAr320sb7rAcyakBR
         msCjlQ5Fe8x3CzTOFwZpyl9mcoReWINIkLSoXdEa2iT+dbQhNdGTunfCLzQgnbAWia
         CrijRO/Xw2IlQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 15/17] crypto: adiantum - stop using alignmask of shash_alg
Date:   Wed, 18 Oct 2023 22:53:41 -0700
Message-ID: <20231019055343.588846-16-ebiggers@kernel.org>
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
 crypto/adiantum.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 51703746d91e2..064a0a57c77c1 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -554,22 +554,21 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s,%s)",
 		     streamcipher_alg->base.cra_driver_name,
 		     blockcipher_alg->cra_driver_name,
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
-	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask |
-				       hash_alg->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask;
 	/*
 	 * The block cipher is only invoked once per message, so for long
 	 * messages (e.g. sectors for disk encryption) its performance doesn't
 	 * matter as much as that of the stream cipher and hash function.  Thus,
 	 * weigh the block cipher's ->cra_priority less.
 	 */
 	inst->alg.base.cra_priority = (4 * streamcipher_alg->base.cra_priority +
 				       2 * hash_alg->base.cra_priority +
 				       blockcipher_alg->cra_priority) / 7;
 
-- 
2.42.0

