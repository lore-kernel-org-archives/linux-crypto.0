Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66005CDB482
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjJSFyP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjJSFyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B48B112
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2156C433C8
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694853;
        bh=p+BNwiGefb1vbbfgRqLq1+GHJYCnXtut4Dm0CzVglTQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FpqtD48Fc2My4dKG7uV4nKnblrLFdMleA8QstkQo7sTzXsBMO0WWFUoFfi/FAuiHI
         h8ga3bQU8tOZzUe7ZgMeGwdk2ADJpa7d91fzpfanns4PXO6b1GgX/jYA5HX82ULb2T
         F5Onn/jqm7+dRXpn+BPzNYPVIBnr46ef/zbMhXxH2CMiR7YRX2QyY6qgx33ZMCaJqC
         82lhxkR8aTA3oifj0DoyJwuZDV1pqp7f93WUAergcQj+Y/YiVL/qGbYLWI3VvKBl0v
         jbPhaiBx0iFT23Ly0OLxME7vIrB7fTzlte3Zbs8ynYEt76pWp36Eubp0cZvZRH9t9w
         TxlO0+4sLsQ7g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 02/17] crypto: stm32 - remove unnecessary alignmask
Date:   Wed, 18 Oct 2023 22:53:28 -0700
Message-ID: <20231019055343.588846-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The stm32 crc32 algorithms set a nonzero alignmask, but they don't seem
to actually need it.  Their ->update function already has code that
handles aligning the data to the same alignment that the alignmask
specifies, their ->setkey function already uses get_unaligned_le32(),
and their ->final function already uses put_unaligned_le32().
Therefore, stop setting the alignmask.  This will allow these algorithms
to keep being registered after alignmask support is removed from shash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/stm32/stm32-crc32.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 90a920e7f6642..fa4fec31fcfc4 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -276,21 +276,20 @@ static struct shash_alg algs[] = {
 		.finup          = stm32_crc_finup,
 		.digest         = stm32_crc_digest,
 		.descsize       = sizeof(struct stm32_crc_desc_ctx),
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32",
 			.cra_driver_name        = "stm32-crc32-crc32",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
-			.cra_alignmask          = 3,
 			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
 			.cra_module             = THIS_MODULE,
 			.cra_init               = stm32_crc32_cra_init,
 		}
 	},
 	/* CRC-32Castagnoli */
 	{
 		.setkey         = stm32_crc_setkey,
 		.init           = stm32_crc_init,
 		.update         = stm32_crc_update,
@@ -298,21 +297,20 @@ static struct shash_alg algs[] = {
 		.finup          = stm32_crc_finup,
 		.digest         = stm32_crc_digest,
 		.descsize       = sizeof(struct stm32_crc_desc_ctx),
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32c",
 			.cra_driver_name        = "stm32-crc32-crc32c",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
-			.cra_alignmask          = 3,
 			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
 			.cra_module             = THIS_MODULE,
 			.cra_init               = stm32_crc32c_cra_init,
 		}
 	}
 };
 
 static int stm32_crc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-- 
2.42.0

