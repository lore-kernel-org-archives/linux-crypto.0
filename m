Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87938C001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjJVISu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjJVISr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8611F93
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22633C433C9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962725;
        bh=fOXBC+AS9/ID2WA3s2FG5UUqbbs3rkcny53YOaMWtOA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WiC6aYXMgJIj8Z2d6SBHUkWIQWvzz6O2DUqwhudo0SqDitty5uLrFXNCPYQSD51nJ
         HOt6CT4PEJ811F+cIDYWDv4Jp0jC1L9LVZYnozZnQ7zyuyiuBMFEI78kb0rJ16zDoU
         TnH6WannUE57Gy4kHVXvSgXK2USwTla+tYlAH/QTsaRe/6UrsGvheZ3QKGObP6rjOV
         FgvJafsmjrC53dtkDaGlYY0Cnak0oM2Tja3+zB7s1b65X49dloMx2GoFwTkWgonOgR
         DwKtM3yOSpB/EUyJcW8lMm2sgGVNHvztKZXJrSF84cDyKr7xL/3EbJCg4PhCa3bRQe
         sKFDac5d+Tdow==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 07/30] crypto: mxs-dcp - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:37 -0700
Message-ID: <20231022081100.123613-8-ebiggers@kernel.org>
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
makes the mxs-dcp driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in dcp_sha_req_to_buf(),
using a bytewise copy.  And this driver only supports unkeyed hash
algorithms, so the key buffer need not be considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/mxs-dcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f6b7bce0e6568..5c91b49b0fc71 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -901,21 +901,20 @@ static struct ahash_alg dcp_sha1_alg = {
 	.digest	= dcp_sha_digest,
 	.import = dcp_sha_import,
 	.export = dcp_sha_export,
 	.halg	= {
 		.digestsize	= SHA1_DIGEST_SIZE,
 		.statesize	= sizeof(struct dcp_export_state),
 		.base		= {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "sha1-dcp",
 			.cra_priority		= 400,
-			.cra_alignmask		= 63,
 			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA1_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
 			.cra_module		= THIS_MODULE,
 			.cra_init		= dcp_sha_cra_init,
 			.cra_exit		= dcp_sha_cra_exit,
 		},
 	},
 };
 
@@ -928,21 +927,20 @@ static struct ahash_alg dcp_sha256_alg = {
 	.digest	= dcp_sha_digest,
 	.import = dcp_sha_import,
 	.export = dcp_sha_export,
 	.halg	= {
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.statesize	= sizeof(struct dcp_export_state),
 		.base		= {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "sha256-dcp",
 			.cra_priority		= 400,
-			.cra_alignmask		= 63,
 			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
 			.cra_module		= THIS_MODULE,
 			.cra_init		= dcp_sha_cra_init,
 			.cra_exit		= dcp_sha_cra_exit,
 		},
 	},
 };
 
-- 
2.42.0

