Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E98CDB484
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjJSFyR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjJSFyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA317116
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A2C433CB
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694853;
        bh=OwOWNeLfTUGViMlwD4hC/ObiKumOEI6sEF7PWE5f/Gc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iGCjWIvRk1sEFa6VFFJ0Rh0237kxRVi6SPJcsdC7uXvLMjPdpnEdr6Abll8MkszyA
         8ysTFroaWbkxK1p/OwI4aqH2Uoh6Q9gdARhoh4ytm/vgffvPRIYPJbduw1JhXF0kMH
         trl0TbB8dwyxjfc1NWwKn0A1IlpguPklgTCjv9wGuQ/0sf5rxqKPRqPXnL7wU8uajH
         rhsU6RDZ1c7vRSi366+wAYRJBW4sMZPMpGMQpaol5cEBxM7R295XLQ/8z6RWJkVpN1
         2Wv2V4pLGhvjZIK7fCqnBzELnhtjvi3q+v+W36RlbLXN+75nyVTjlFw5Zw+nxhqZPl
         3W+TJ9xHm86Ow==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 04/17] crypto: mips/crc32 - remove redundant setting of alignmask to 0
Date:   Wed, 18 Oct 2023 22:53:30 -0700
Message-ID: <20231019055343.588846-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This unnecessary explicit setting of cra_alignmask to 0 shows up when
grepping for shash algorithms that set an alignmask.  Remove it.  No
change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/mips/crypto/crc32-mips.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
index 3e4f5ba104f89..ec6d58008f8e1 100644
--- a/arch/mips/crypto/crc32-mips.c
+++ b/arch/mips/crypto/crc32-mips.c
@@ -283,21 +283,20 @@ static struct shash_alg crc32_alg = {
 	.final			=	chksum_final,
 	.finup			=	chksum_finup,
 	.digest			=	chksum_digest,
 	.descsize		=	sizeof(struct chksum_desc_ctx),
 	.base			=	{
 		.cra_name		=	"crc32",
 		.cra_driver_name	=	"crc32-mips-hw",
 		.cra_priority		=	300,
 		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
-		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	chksum_cra_init,
 	}
 };
 
 static struct shash_alg crc32c_alg = {
 	.digestsize		=	CHKSUM_DIGEST_SIZE,
 	.setkey			=	chksum_setkey,
 	.init			=	chksum_init,
@@ -305,21 +304,20 @@ static struct shash_alg crc32c_alg = {
 	.final			=	chksumc_final,
 	.finup			=	chksumc_finup,
 	.digest			=	chksumc_digest,
 	.descsize		=	sizeof(struct chksum_desc_ctx),
 	.base			=	{
 		.cra_name		=	"crc32c",
 		.cra_driver_name	=	"crc32c-mips-hw",
 		.cra_priority		=	300,
 		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
-		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	chksum_cra_init,
 	}
 };
 
 static int __init crc32_mod_init(void)
 {
 	int err;
 
-- 
2.42.0

