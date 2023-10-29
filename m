Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EDDC4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 05:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjJ2FRw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FRv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 01:17:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C78C6
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 22:17:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2A4C433C8
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 05:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698556669;
        bh=7y5OwQMoHHyAxREHbOe6QO1zjTwRbQqjxXgq56y8JKY=;
        h=From:To:Subject:Date:From;
        b=A4plIIDZBy1lotsMS0Y/bpUeApOe4KR0jtmEH/bES+FeZpGRbvYzjdr8hlA77G7g8
         Dy3PzGCp5nkwC/e8OQKLU43yD2urM38TrZny9Phvw4iENpaIP/gAR+7rZOa3Gxs6Kb
         80+JvgPZZHsF3oxMmyV08InHHNNj6/q3G2CdJvRFcKSLZBHajI/mwewlpeE8AIjCh7
         Kfo4Qjay3rQkzvvFA/c8WjKdP0Pxpb2TgZHqBzoWDFQz7fn1OP70UeVNkmvAu5xROW
         cKdCSZ08rG1BORQ0akV9tozgn4+3xueJpRmPrCAeehIqeWtvsPpmMWKLIOtHGl+WUX
         VaST3D0O3190A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: shash - don't exclude async statuses from error stats
Date:   Sat, 28 Oct 2023 22:16:59 -0700
Message-ID: <20231029051659.157987-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

EINPROGRESS and EBUSY have special meaning for async operations.
However, shash is always synchronous, so these statuses have no special
meaning for shash and don't need to be excluded when handling errors.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index d5194221c88c..c3f7f6a25280 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -16,26 +16,22 @@
 
 #include "hash.h"
 
 static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
 {
 	return hash_get_stat(&alg->halg);
 }
 
 static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
 {
-	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
-		return err;
-
-	if (err && err != -EINPROGRESS && err != -EBUSY)
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS) && err)
 		atomic64_inc(&shash_get_stat(alg)->err_cnt);
-
 	return err;
 }
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(shash_no_setkey);
 

base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
-- 
2.42.0

