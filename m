Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3869E95A96
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 07:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbjJIHc7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345374AbjJIHc6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2023 03:32:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B123C5
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 00:32:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB434C433CA
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 07:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696836776;
        bh=kEoFp/FJCQU3tv7T+Sz+gSZdAkoL7AjRu/2pmjuhGNY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=F+aamyx8PvoAbfxAiwJozZjCVHt7zRjUzjzpQjDrrAKsZcFzSBm6DI0RTR4jkhwNG
         lreLIL9rec0xeKZnfrvuxKP0EPGcij4pV6R+2E8HUyhQ0OnueQKCqb3a6gTCbGRclF
         Pvx4uWJIUp+Ek3jRdoq5Z+otwO8jcarz52oSTw28TLuYPMS7vjr9BWoEOXrlHb6svj
         dewmj63AmqsEJAK30DlEA6kULF8sjpiJQccTFEqag+3ofRV/e8DRvW7KNyAhb0v3KM
         UVkCg0yE1O7gQRW8PWjH2qKt0YKgC8HggxDgSNWJ2Qu5bRAljrMX3DKRdHYqX/dHI1
         UcI3MrAm6ig1w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] crypto: shash - fold shash_digest_unaligned() into crypto_shash_digest()
Date:   Mon,  9 Oct 2023 00:32:14 -0700
Message-ID: <20231009073214.423279-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009073214.423279-1-ebiggers@kernel.org>
References: <20231009073214.423279-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Fold shash_digest_unaligned() into its only remaining caller.  Also,
avoid a redundant check of CRYPTO_TFM_NEED_KEY by replacing the call to
crypto_shash_init() with shash->init(desc).  Finally, replace
shash_update_unaligned() + shash_final_unaligned() with
shash_finup_unaligned() which does exactly that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index d99dc2f94c65f..15fee57cca8ef 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -218,28 +218,20 @@ int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 	if (((unsigned long)data | (unsigned long)out) & alignmask)
 		err = shash_finup_unaligned(desc, data, len, out);
 	else
 		err = shash->finup(desc, data, len, out);
 
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
-static int shash_digest_unaligned(struct shash_desc *desc, const u8 *data,
-				  unsigned int len, u8 *out)
-{
-	return crypto_shash_init(desc) ?:
-	       shash_update_unaligned(desc, data, len) ?:
-	       shash_final_unaligned(desc, out);
-}
-
 static int shash_default_digest(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
 	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
 
 	return shash->init(desc) ?:
 	       shash->finup(desc, data, len, out);
 }
 
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
@@ -253,21 +245,22 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = shash_get_stat(shash);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(len, &istat->hash_tlen);
 	}
 
 	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		err = -ENOKEY;
 	else if (((unsigned long)data | (unsigned long)out) & alignmask)
-		err = shash_digest_unaligned(desc, data, len, out);
+		err = shash->init(desc) ?:
+		      shash_finup_unaligned(desc, data, len, out);
 	else
 		err = shash->digest(desc, data, len, out);
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out)
 {
-- 
2.42.0

