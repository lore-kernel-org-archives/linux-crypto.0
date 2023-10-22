Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D88CC001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjJVI2A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EE8E8
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF4DC43391
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962728;
        bh=Td3d6l7m3zuj0gnpYJn8/IDiT4PZWc87JUJezkxaNcs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XB9h154IBaHTACJrYblyznomhCcrG4h+OTpFJv4n5i+HUk8Bg7Ri3JwtIQijdvQGr
         0h5EZqK5xbelAlqY+pRTL8ZAm+L+/fuBhQFzRpEEFGVrHD4Vrqm2u4Yzoq/JgDpK73
         8r2m8LHJdTK5/Q/pEiw198jnbRZNFhsreEMlhbIPSv1wMsTyfP/3GlxW/7HI+PBnPW
         ttjCdBqimyEGkhhO7dmOoukbPqvQ2KC+iIm7fPDjP7uQXd7Y3k5Og5SQVHtnLgpfvD
         KwQVlETplnTs3y+x67d2zvhdyXf+MWJ0KFDKJawXew5w89fMseuo5S1gbIgX+JaDIF
         +6bNdEfZJOVVA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 21/30] crypto: chacha20poly1305 - stop using alignmask of ahash
Date:   Sun, 22 Oct 2023 01:10:51 -0700
Message-ID: <20231022081100.123613-22-ebiggers@kernel.org>
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
simplify chachapoly_create() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20poly1305.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 0e2e208d98f94..9e4651330852b 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -603,22 +603,21 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		     poly->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
 		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
-	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask |
-				       poly->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
 				     ctx->saltlen;
 	inst->alg.ivsize = ivsize;
 	inst->alg.chunksize = chacha->chunksize;
 	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
 	inst->alg.init = chachapoly_init;
 	inst->alg.exit = chachapoly_exit;
 	inst->alg.encrypt = chachapoly_encrypt;
 	inst->alg.decrypt = chachapoly_decrypt;
 	inst->alg.setkey = chachapoly_setkey;
-- 
2.42.0

