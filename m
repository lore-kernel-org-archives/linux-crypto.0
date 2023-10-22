Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED080C25B42
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjJVISx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjJVISr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30221F4
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D6CC43395
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962726;
        bh=WXgzK4O6+fvazhY9rDTpzwXQKpRF0dnRpBE1ykWmc+k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NjH2+gb9AhK/ol8kAreWX6MEOf75cm233hTnviYBhIgDJoaI5+SwzaLYa3KADhxDN
         xN+BCk9FAsdVR+ErQ0+sadJSOD6g/3Pmool03s/+n1xM1EvsXAUnWuL5q9ATjF1QFw
         vE4bBDGl81OGIawB369aqMNAbg2Mnwk/Qz1qIPT4ccFnvpl34mWok20gvihlvk1jop
         XxvPrtSzLTM99c+4LfM0gsh2Moo5a7146rtMyDO9ohEzRq5NSJwcWjfVItCkFqJ9CJ
         jY9nRjh00+mCtnYxACacznKBoDEfl9ESUfdCwcCPTEQBwX6UbU2cWyQS0WRB+yYq6i
         OrPHjO3VJICNQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 11/30] crypto: rockchip - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:41 -0700
Message-ID: <20231022081100.123613-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto API's support for alignmasks for ahash algorithms is nearly
useless, as its only effect is to cause the API to align the key and
result buffers.  The drivers that happen to be specifying an alignmask
for ahash rarely actually need it.  When they do, it's easily fixable,
especially considering that these buffers cannot be used for DMA.

In preparation for removing alignmask support from ahash, this patch
makes the rockchip driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in rk_hash_run(),
already using put_unaligned_le32().  And this driver only supports
unkeyed hash algorithms, so the key buffer need not be considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 8c143180645e5..1b13b4aa16ecc 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -386,21 +386,20 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 			 .digestsize = SHA1_DIGEST_SIZE,
 			 .statesize = sizeof(struct sha1_state),
 			 .base = {
 				  .cra_name = "sha1",
 				  .cra_driver_name = "rk-sha1",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
-				  .cra_alignmask = 3,
 				  .cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
 		.do_one_request = rk_hash_run,
 	},
 };
 
 struct rk_crypto_tmp rk_ahash_sha256 = {
@@ -419,21 +418,20 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 			 .digestsize = SHA256_DIGEST_SIZE,
 			 .statesize = sizeof(struct sha256_state),
 			 .base = {
 				  .cra_name = "sha256",
 				  .cra_driver_name = "rk-sha256",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA256_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
-				  .cra_alignmask = 3,
 				  .cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
 		.do_one_request = rk_hash_run,
 	},
 };
 
 struct rk_crypto_tmp rk_ahash_md5 = {
@@ -452,19 +450,18 @@ struct rk_crypto_tmp rk_ahash_md5 = {
 			 .digestsize = MD5_DIGEST_SIZE,
 			 .statesize = sizeof(struct md5_state),
 			 .base = {
 				  .cra_name = "md5",
 				  .cra_driver_name = "rk-md5",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
-				  .cra_alignmask = 3,
 				  .cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
 		.do_one_request = rk_hash_run,
 	},
 };
-- 
2.42.0

