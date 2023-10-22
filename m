Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4532FC25B41
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjJVISs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjJVISq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B99DE
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E71C433CD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962725;
        bh=PZQocI1QBzG2Ecp825Cf12w+l7PnCtCH9SldnSU4hnE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TxR7XHJZr8gi9yKJvqvLPoqST/8ICkwfyoQ7bzLZ1YaMh+yh3Id0uYdwTevg4v/OG
         X5wDhHEjkcWhNKTFPAMQTNGuLw+TiqCd71qozOrNCipXhUcEzxicqh4n8VYudj8vFF
         2hqWBDFyVlO4RyK7wdwDOe5S976CdHN2IH1yfnfYUG0xAOH+Qhe6ZR1/9ixDcFuKGY
         LgTo8O4gW5jJz1rTIVnwTT4kmRU70mVxHAsTrA/RSx2n4HaidZsxwY6XGUmSjO9fwe
         SiFg+ZzCi9aGD28wekONVJHMBoAfaKB48yxa4rgQ+5mNi6ULpao04KlBV5XLOEZejk
         SW7yf8kDGpYMw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 06/30] crypto: artpec6 - stop setting alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:36 -0700
Message-ID: <20231022081100.123613-7-ebiggers@kernel.org>
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
makes the artpec6 driver no longer use it.  This driver is unusual in
that it DMAs the digest directly to the result buffer.  This is broken
because the crypto API provides the result buffer as an arbitrary
virtual address, which might not be valid for DMA, even after the crypto
API applies the alignmask.  Maybe the alignmask (which this driver set
only to 3) made this code work in a few more cases than it otherwise
would have.  But even if so, it doesn't make sense for this single
driver that is broken anyway to block removal of the alignmask support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 8493a45e1bd46..62373a5cd3961 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2628,21 +2628,20 @@ static struct ahash_alg hash_algos[] = {
 		.halg.digestsize = SHA1_DIGEST_SIZE,
 		.halg.statesize = sizeof(struct artpec6_hash_export_state),
 		.halg.base = {
 			.cra_name = "sha1",
 			.cra_driver_name = "artpec-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
 			.cra_module = THIS_MODULE,
 			.cra_init = artpec6_crypto_ahash_init,
 			.cra_exit = artpec6_crypto_ahash_exit,
 		}
 	},
 	/* SHA-256 */
 	{
 		.init = artpec6_crypto_sha256_init,
 		.update = artpec6_crypto_hash_update,
 		.final = artpec6_crypto_hash_final,
@@ -2652,21 +2651,20 @@ static struct ahash_alg hash_algos[] = {
 		.halg.digestsize = SHA256_DIGEST_SIZE,
 		.halg.statesize = sizeof(struct artpec6_hash_export_state),
 		.halg.base = {
 			.cra_name = "sha256",
 			.cra_driver_name = "artpec-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
 			.cra_module = THIS_MODULE,
 			.cra_init = artpec6_crypto_ahash_init,
 			.cra_exit = artpec6_crypto_ahash_exit,
 		}
 	},
 	/* HMAC SHA-256 */
 	{
 		.init = artpec6_crypto_hmac_sha256_init,
 		.update = artpec6_crypto_hash_update,
 		.final = artpec6_crypto_hash_final,
@@ -2677,21 +2675,20 @@ static struct ahash_alg hash_algos[] = {
 		.halg.digestsize = SHA256_DIGEST_SIZE,
 		.halg.statesize = sizeof(struct artpec6_hash_export_state),
 		.halg.base = {
 			.cra_name = "hmac(sha256)",
 			.cra_driver_name = "artpec-hmac-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
 			.cra_module = THIS_MODULE,
 			.cra_init = artpec6_crypto_ahash_init_hmac_sha256,
 			.cra_exit = artpec6_crypto_ahash_exit,
 		}
 	},
 };
 
 /* Crypto */
 static struct skcipher_alg crypto_algos[] = {
 	/* AES - ECB */
-- 
2.42.0

