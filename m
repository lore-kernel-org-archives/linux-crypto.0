Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9D5CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjJSFyc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C75B116
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F614C43391
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694855;
        bh=TuzF4+jIfBft5VqDo/fE9UfXx0/TR1AztgYN6AHx+OQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vGp0ylWCyNJcdylXwU1quTIfNQxtwNGHr6tFRyQ6H43DQ/GkmQEitHntKQ435Lyu0
         Vt7tX4v7jv/p1h9ZIEiPsWgHFxI0q7c7of5tyLuHm4ZIAL3nSRL3T3UQEQd4aSfiuR
         aBI20FfnnbPLvERWMMbFD1ehxikbsl88ZbXd3CNm7atBO7Gc3A4VPWGfeuzZEh6RSb
         HbdIJuMJzfyVze0qz5RJ5wTtb/Xh0GJVgPpsq8uoXYBY/VEaAy4PIMU0G8nSa6NupA
         SyMiteaoTlBEJWUiy/PYe39DjG4UK5ScdkeQk2B4XnZOGRYNP5Dlj3JC9u50Pke+/3
         4mq/LGD8dXTBQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 13/17] crypto: drbg - stop checking crypto_shash_alignmask
Date:   Wed, 18 Oct 2023 22:53:39 -0700
Message-ID: <20231019055343.588846-14-ebiggers@kernel.org>
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
crypto_shash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_shash_alignmask() in drbg.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ff4ebbc68efab..e01f8c7769d03 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1691,21 +1691,21 @@ static int drbg_init_hash_kernel(struct drbg_state *drbg)
 	sdesc = kzalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
 			GFP_KERNEL);
 	if (!sdesc) {
 		crypto_free_shash(tfm);
 		return -ENOMEM;
 	}
 
 	sdesc->shash.tfm = tfm;
 	drbg->priv_data = sdesc;
 
-	return crypto_shash_alignmask(tfm);
+	return 0;
 }
 
 static int drbg_fini_hash_kernel(struct drbg_state *drbg)
 {
 	struct sdesc *sdesc = drbg->priv_data;
 	if (sdesc) {
 		crypto_free_shash(sdesc->shash.tfm);
 		kfree_sensitive(sdesc);
 	}
 	drbg->priv_data = NULL;
-- 
2.42.0

