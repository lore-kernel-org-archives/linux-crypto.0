From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/6] crypto: sun4i-ss: clean unused ss
Date: Wed, 10 Aug 2016 11:45:31 +0200
Message-ID: <1470822334-20672-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36206 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbcHJSbu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:31:50 -0400
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ss variable is never used, remove it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 2fb0684..7841d73 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -32,12 +32,10 @@ int sun4i_hash_init(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun4i_ss_alg_template *algt;
-	struct sun4i_ss_ctx *ss;
 
 	memset(op, 0, sizeof(struct sun4i_req_ctx));
 
 	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
-	ss = algt->ss;
 	op->ss = algt->ss;
 	op->mode = algt->mode;
 
-- 
2.7.3
