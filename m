Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE72C00A8F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjJVITJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0261A3
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88496C433CA
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962728;
        bh=G3cmf2bNwDRiorWVX3Gfw9Cf5KsHz9Me8snVNz2tvck=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SsGmdPrzzxa2KkLJXa0WkXD9qOJeOAygHy+rvtFOsIe0rKzSUG1dHv846XAB87PQR
         21wZt9cxbBIUIvVp+URF2qfUWWBEigSm2FCA6Y6THeDBCbLRjrDX9YCXQt9a1SW1+Y
         cHnaCW7GC+SXCDMZkvp9m+IUvZBqKK8SK5QkKMugGAgdqOLV1Plbp2cnUzn4mnNcJF
         7G8QpnQFHN5l6kfVTKFdzzwC2qsbwAJx+sDh26BGsDkHQtclGfqQzuaTNp2A7YyqCX
         xjPnhw8MWXnm13c+IGkbWK2+bfwJktTLNjyPzHWeR4/n33J8G0qh71sGifLu8FgBEw
         +FJrFKuYVX27w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 23/30] crypto: ahash - remove crypto_ahash_alignmask
Date:   Sun, 22 Oct 2023 01:10:53 -0700
Message-ID: <20231022081100.123613-24-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_ahash_alignmask() no longer has any callers, and it always
returns 0 now that neither ahash nor shash algorithms support nonzero
alignmasks anymore.  Therefore, remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/hash.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index d3a380ae894ad..b00a4a36a8ec3 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -335,26 +335,20 @@ int crypto_has_ahash(const char *alg_name, u32 type, u32 mask);
 static inline const char *crypto_ahash_alg_name(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
 }
 
 static inline const char *crypto_ahash_driver_name(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 }
 
-static inline unsigned int crypto_ahash_alignmask(
-	struct crypto_ahash *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));
-}
-
 /**
  * crypto_ahash_blocksize() - obtain block size for cipher
  * @tfm: cipher handle
  *
  * The block size for the message digest cipher referenced with the cipher
  * handle is returned.
  *
  * Return: block size of cipher
  */
 static inline unsigned int crypto_ahash_blocksize(struct crypto_ahash *tfm)
-- 
2.42.0

