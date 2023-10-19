Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB59FCDB485
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSFyR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjJSFyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E875111B
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D89C433CC
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694853;
        bh=/jzM6v2stiOvtt+IkxG/WMBv2h4LRliFs5rirhlpdJY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qKU3FgssrmOlztJEIqXsTjp/Zal42NBzK1VFPd0J5q6DBiGZcj4LuCsm4StrvTp3G
         mZheuaK89/gXMIwqU4MKWyIkS5VYKU2FpRvGQAhDXZ2CGuwCwjRKZ+sh3615wGBfvL
         8+5LJn0nk82wu8aT41NX9Ljkri0zKiQH73yzVZ63LQcJBRQhTuDx9B4q+zyeH59QdI
         NTE7YY0PFy7Ij9+3YAlIn0LCqCZM/I75CtsBdGTs+aD7D/nJETjO/T4NaZnoA0SvhV
         NZ7hwXa3/M0IouDKCioPVeMNvtFSU9j0fgbipdwKC24mbsU7VH8HDvW4MiOzTHNv9L
         7+cmyLgCfSIgw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 05/17] crypto: loongarch/crc32 - remove redundant setting of alignmask to 0
Date:   Wed, 18 Oct 2023 22:53:31 -0700
Message-ID: <20231019055343.588846-6-ebiggers@kernel.org>
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
 arch/loongarch/crypto/crc32-loongarch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/loongarch/crypto/crc32-loongarch.c b/arch/loongarch/crypto/crc32-loongarch.c
index 1f2a2c3839bcb..a49e507af38c0 100644
--- a/arch/loongarch/crypto/crc32-loongarch.c
+++ b/arch/loongarch/crypto/crc32-loongarch.c
@@ -232,21 +232,20 @@ static struct shash_alg crc32_alg = {
 	.final			=	chksum_final,
 	.finup			=	chksum_finup,
 	.digest			=	chksum_digest,
 	.descsize		=	sizeof(struct chksum_desc_ctx),
 	.base			=	{
 		.cra_name		=	"crc32",
 		.cra_driver_name	=	"crc32-loongarch",
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
@@ -254,21 +253,20 @@ static struct shash_alg crc32c_alg = {
 	.final			=	chksumc_final,
 	.finup			=	chksumc_finup,
 	.digest			=	chksumc_digest,
 	.descsize		=	sizeof(struct chksum_desc_ctx),
 	.base			=	{
 		.cra_name		=	"crc32c",
 		.cra_driver_name	=	"crc32c-loongarch",
 		.cra_priority		=	300,
 		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
-		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	chksumc_cra_init,
 	}
 };
 
 static int __init crc32_mod_init(void)
 {
 	int err;
 
-- 
2.42.0

