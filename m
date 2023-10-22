Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8CFC001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjJVIS7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjJVISt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA8AF4
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E47C433D9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962727;
        bh=rj/ALPreHUuVA2MtLaC3G7UlQAWXRyVrXCMUiaGremU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qRzbTJSQqIpLo4BesaG3aAHqb7rc5MRbNBHwrzobBNBC/e5HiLZMAYJs3h9u6RIb+
         z8T/FHBPVNUKBoeVpbifnBBdBNzIbOAlObPbLW2D07DvScSHuB/+X0JGByflD9gxKi
         PnX/JRDB56qHUHy+/tkkag0XXiPfW/IJH1nU8gKFotPOxYvl9Zj4gA30hw13AjvDf4
         1ewfR8irfAZqbA6dpVl/pvjEKuaq790EzykgI1WJmFojpps9V363CpnxkDqStUYEP6
         6XWrCwjU0hdwX3h6PzcX4gkDcnxDB8mUcpg1AkSB4uOihm00RsbLQ7g1T7KuU0MjpQ
         lTvfwCq2n1owg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 17/30] crypto: testmgr - stop checking crypto_ahash_alignmask
Date:   Sun, 22 Oct 2023 01:10:47 -0700
Message-ID: <20231022081100.123613-18-ebiggers@kernel.org>
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
crypto_ahash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_ahash_alignmask() in testmgr.

As a result of this change,
test_sg_division::offset_relative_to_alignmask and
testvec_config::key_offset_relative_to_alignmask no longer have any
effect on ahash (or shash) algorithms.  Therefore, also stop setting
these flags in default_hash_testvec_configs[].

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 48a0929c7a158..335449a27f757 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -401,31 +401,29 @@ static const struct testvec_config default_hash_testvec_configs[] = {
 	}, {
 		.name = "digest aligned buffer",
 		.src_divs = { { .proportion_of_total = 10000 } },
 		.finalization_type = FINALIZATION_TYPE_DIGEST,
 	}, {
 		.name = "init+update+final misaligned buffer",
 		.src_divs = { { .proportion_of_total = 10000, .offset = 1 } },
 		.finalization_type = FINALIZATION_TYPE_FINAL,
 		.key_offset = 1,
 	}, {
-		.name = "digest buffer aligned only to alignmask",
+		.name = "digest misaligned buffer",
 		.src_divs = {
 			{
 				.proportion_of_total = 10000,
 				.offset = 1,
-				.offset_relative_to_alignmask = true,
 			},
 		},
 		.finalization_type = FINALIZATION_TYPE_DIGEST,
 		.key_offset = 1,
-		.key_offset_relative_to_alignmask = true,
 	}, {
 		.name = "init+update+update+final two even splits",
 		.src_divs = {
 			{ .proportion_of_total = 5000 },
 			{
 				.proportion_of_total = 5000,
 				.flush_type = FLUSH_TYPE_FLUSH,
 			},
 		},
 		.finalization_type = FINALIZATION_TYPE_FINAL,
@@ -1451,54 +1449,53 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 
 /* Test one hash test vector in one configuration, using the ahash API */
 static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
 			      struct ahash_request *req,
 			      struct test_sglist *tsgl,
 			      u8 *hashstate)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int statesize = crypto_ahash_statesize(tfm);
 	const char *driver = crypto_ahash_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const struct test_sg_division *divs[XBUFSIZE];
 	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int i;
 	struct scatterlist *pending_sgl;
 	unsigned int pending_len;
 	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
 	int err;
 
 	/* Set the key, if specified */
 	if (vec->ksize) {
 		err = do_setkey(crypto_ahash_setkey, tfm, vec->key, vec->ksize,
-				cfg, alignmask);
+				cfg, 0);
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
 			pr_err("alg: ahash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
 			       driver, vec_name, vec->setkey_error, err,
 			       crypto_ahash_get_flags(tfm));
 			return err;
 		}
 		if (vec->setkey_error) {
 			pr_err("alg: ahash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
 			       driver, vec_name, vec->setkey_error);
 			return -EINVAL;
 		}
 	}
 
 	/* Build the scatterlist for the source data */
-	err = build_hash_sglist(tsgl, vec, cfg, alignmask, divs);
+	err = build_hash_sglist(tsgl, vec, cfg, 0, divs);
 	if (err) {
 		pr_err("alg: ahash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
 		       driver, vec_name, cfg->name);
 		return err;
 	}
 
 	/* Do the actual hashing */
 
 	testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
 	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
-- 
2.42.0

