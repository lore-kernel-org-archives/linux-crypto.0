Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACE4CDB484
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjJSFyh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjJSFyY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A5DFE
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5633C433CD
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694855;
        bh=GcLYinJeWpUvY/Uoy8rAE5b2gBzBptP2ijV9hrQy9vg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eXLwQyPQ4lCitWeeffNUOvNFLlJf21BdUFCQ0Fi/354X1YBx3PNkruJq4RHufgHik
         m5KNFkgC4w17IMHnK6EQkc+8vCfTjNbhZnjw8QLrTXKayapw206rn9bvbIve8sWhTp
         G7Hi+SMfrpKOp7kWWI8LM7HCHpmaFIgznOo52D75QM2GSs0wB1pbypDM3UR6kgfL65
         55dFWOfTAuMY5c3pvy90nD3v8gT4UH+GbFZ409vDRSpbQS7C0wkhmguF/6AZuSH5mx
         k30YfFLx+OtaJ/bQy+ye0SddaLinsA9JmQGEqHwQyqiXqw0qkPPlyMk8pFA/r00MAe
         blNdiaCz8ETYQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 17/17] crypto: shash - remove crypto_shash_alignmask
Date:   Wed, 18 Oct 2023 22:53:43 -0700
Message-ID: <20231019055343.588846-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_shash_alignmask() no longer has any callers, and it always
returns 0 now that the shash algorithm type no longer supports nonzero
alignmasks.  Therefore, remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/hash.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 52e57e93b2f59..d3a380ae894ad 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -791,26 +791,20 @@ static inline void crypto_free_shash(struct crypto_shash *tfm)
 static inline const char *crypto_shash_alg_name(struct crypto_shash *tfm)
 {
 	return crypto_tfm_alg_name(crypto_shash_tfm(tfm));
 }
 
 static inline const char *crypto_shash_driver_name(struct crypto_shash *tfm)
 {
 	return crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
 }
 
-static inline unsigned int crypto_shash_alignmask(
-	struct crypto_shash *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_shash_tfm(tfm));
-}
-
 /**
  * crypto_shash_blocksize() - obtain block size for cipher
  * @tfm: cipher handle
  *
  * The block size for the message digest cipher referenced with the cipher
  * handle is returned.
  *
  * Return: block size of cipher
  */
 static inline unsigned int crypto_shash_blocksize(struct crypto_shash *tfm)
-- 
2.42.0

