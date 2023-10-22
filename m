Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2DEC00A8F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjJVISr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjJVISq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB8CD6
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BAC433C7
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962724;
        bh=1OjWNO0YLj9rDW+dV3zDfZzVoSztg0mz8dCPVPlJWxU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pThQib2SsqSoxwTByG2qw3QeL3viYKYw9j4OZ35HyRPWV7Me9GRdA2j8Jmpe7j5VZ
         OY11WdIZMsxBBN5RfYetCs3J1XeP5K5VbE5CGAhZW2/BqJ0fILdaIgz5jjKu5I34Z7
         6hoEWeH35F8J7vRWxgjSgtnyBd7h7CeP8DbqWGqEIBw7j8BnPrC/NJWNygsidSzlAs
         yTd/yvoQi10AYEkLWvL24BGiXCA0Qk7q7b+bDw96MVOCGLq5RdPG37YxV2rAr0zOzJ
         epl0R4NH3mDMSt7t5NvKl2nDax7et58Rwwu109hT7R8BJFsQeuo+ch7RLRg+KM8qXQ
         lnyZxQg0hLbxQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 02/30] crypto: sun4i-ss - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:32 -0700
Message-ID: <20231022081100.123613-3-ebiggers@kernel.org>
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
makes the sun4i-ss driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in sun4i_hash(), already
using the unaligned access helpers.  And this driver only supports
unkeyed hash algorithms, so the key buffer need not be considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 3bcfcfc370842..e23a020a64628 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -42,21 +42,20 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.digest = sun4i_hash_digest,
 		.export = sun4i_hash_export_md5,
 		.import = sun4i_hash_import_md5,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct md5_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-sun4i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 				.cra_module = THIS_MODULE,
 				.cra_init = sun4i_hash_crainit,
 				.cra_exit = sun4i_hash_craexit,
 			}
 		}
 	}
 },
 {       .type = CRYPTO_ALG_TYPE_AHASH,
@@ -69,21 +68,20 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.digest = sun4i_hash_digest,
 		.export = sun4i_hash_export_sha1,
 		.import = sun4i_hash_import_sha1,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-sun4i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 				.cra_module = THIS_MODULE,
 				.cra_init = sun4i_hash_crainit,
 				.cra_exit = sun4i_hash_craexit,
 			}
 		}
 	}
 },
 {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
-- 
2.42.0

