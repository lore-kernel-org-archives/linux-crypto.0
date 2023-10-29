Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2855C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 05:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjJ2FEI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FEH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 01:04:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2CCC5
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 22:04:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C751C433C7;
        Sun, 29 Oct 2023 05:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698555845;
        bh=Bd85Pl0HxDFyn+Xmq89TAE0x2+xo8OOJv3Wbz88xxEA=;
        h=From:To:Cc:Subject:Date:From;
        b=Mw1IfVQZiMp5BpDGgUt/tVQwmrsRmtydrP/mY+CD9xI+TnspAOs6HHsaKEdBaB97W
         Mzm57m4NaWDKJRdDI0Rh65r96MWyM0gFobkYFXPQfYKefodqAvJW9v8saGakPoAakL
         oFnyVVCqNetSd5falmLFuPW7gD/04tSmozJvE319Wqono21d9mEXhBC0nI5QdQW29Z
         q6ddAZvkQIiRDqk5JN6tsoRD1uuBxbbDgiBH/3vHXKCUx3rXjyzAyttUET8QsqfdJw
         fobRnFp1Qwd7gxrvtbgFwk/9+lq1hqCjrRkzUzt3mzFe+/KKsTa2Y7qR+0D2r6W3Cd
         0q67pUFqmu5yQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] ubifs: use crypto_shash_tfm_digest() in ubifs_hmac_wkm()
Date:   Sat, 28 Oct 2023 22:03:55 -0700
Message-ID: <20231029050355.154989-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify ubifs_hmac_wkm() by using crypto_shash_tfm_digest() instead of
an alloc+init+update+final sequence.  This should also improve
performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/auth.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index e564d5ff8781..4add4a4f0720 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -501,42 +501,27 @@ int __ubifs_shash_copy_state(const struct ubifs_info *c, struct shash_desc *src,
  *
  * This function creates a HMAC of a well known message. This is used
  * to check if the provided key is suitable to authenticate a UBIFS
  * image. This is only a convenience to the user to provide a better
  * error message when the wrong key is provided.
  *
  * This function returns 0 for success or a negative error code otherwise.
  */
 int ubifs_hmac_wkm(struct ubifs_info *c, u8 *hmac)
 {
-	SHASH_DESC_ON_STACK(shash, c->hmac_tfm);
-	int err;
 	const char well_known_message[] = "UBIFS";
 
 	if (!ubifs_authenticated(c))
 		return 0;
 
-	shash->tfm = c->hmac_tfm;
-
-	err = crypto_shash_init(shash);
-	if (err)
-		return err;
-
-	err = crypto_shash_update(shash, well_known_message,
-				  sizeof(well_known_message) - 1);
-	if (err < 0)
-		return err;
-
-	err = crypto_shash_final(shash, hmac);
-	if (err)
-		return err;
-	return 0;
+	return crypto_shash_tfm_digest(c->hmac_tfm, well_known_message,
+				       sizeof(well_known_message) - 1, hmac);
 }
 
 /*
  * ubifs_hmac_zero - test if a HMAC is zero
  * @c: UBIFS file-system description object
  * @hmac: the HMAC to test
  *
  * This function tests if a HMAC is zero and returns true if it is
  * and false otherwise.
  */

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

