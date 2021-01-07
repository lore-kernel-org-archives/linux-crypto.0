Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7418C4332B
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BB523370
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbhAGMmb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbhAGMma (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:42:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4200F23372;
        Thu,  7 Jan 2021 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610023309;
        bh=wqAU9UBg0l1btGzmZfdDt4TAWT8oFgSDqmdTs9vWD64=;
        h=From:To:Cc:Subject:Date:From;
        b=P/LS7QyI9Mbjuvy6KshQe1qy50C2gN426uxz1J2FIC4jXQssxGmSJlUqVicSg7Cmm
         aqcnEyEfyJ2ilpy9/aYAtcczkzljt+Q8rawmPjT5Iv/kDLo3Ru4N+KNCm8p3qApcpK
         bnkNCJ3sPDSVXqc3gOur5mC1Fu8SG8TH3P3KA1sMaYzDpt9iPpm8zirL4vv/BVepjq
         uT0Y/dgLxCDd3Bcy26oWXs2OXHYwkpWQXJ/ivNq67CPk8RG2plpfi8elq5DcdGUjfq
         3VE1N/GJhEmNDqrQl2syEb27Oi3uY8l3SIom5gLcbXsxuasFXWMRk8VqdCee14OboQ
         sBFkwqt0ZOsSQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
Date:   Thu,  7 Jan 2021 13:41:28 +0100
Message-Id: <20210107124128.19791-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unlike many other structure types defined in the crypto API, the
'shash_desc' structure is permitted to live on the stack, which
implies its contents may not be accessed by DMA masters. (This is
due to the fact that the stack may be located in the vmalloc area,
which requires a different virtual-to-physical translation than the
one implemented by the DMA subsystem)

Our definition of CRYPTO_MINALIGN_ATTR is based on ARCH_KMALLOC_MINALIGN,
which may take DMA constraints into account on architectures that support
non-cache coherent DMA such as ARM and arm64. In this case, the value is
chosen to reflect the largest cacheline size in the system, in order to
ensure that explicit cache maintenance as required by non-coherent DMA
masters does not affect adjacent, unrelated slab allocations. On arm64,
this value is currently set at 128 bytes.

This means that applying CRYPTO_MINALIGN_ATTR to struct shash_desc is both
unnecessary (as it is never used for DMA), and undesirable, given that it
wastes stack space (on arm64, performing the alignment costs 112 bytes in
the worst case, and the hole between the 'tfm' and '__ctx' members takes
up another 120 bytes, resulting in an increased stack footprint of up to
232 bytes.) So instead, let's switch to the minimum SLAB alignment, which
does not take DMA constraints into account.

Note that this is a no-op for x86.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/hash.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index af2ff31ff619..13f8a6a54ca8 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -149,7 +149,7 @@ struct ahash_alg {
 
 struct shash_desc {
 	struct crypto_shash *tfm;
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+	void *__ctx[] __aligned(ARCH_SLAB_MINALIGN);
 };
 
 #define HASH_MAX_DIGESTSIZE	 64
@@ -162,9 +162,9 @@ struct shash_desc {
 
 #define HASH_MAX_STATESIZE	512
 
-#define SHASH_DESC_ON_STACK(shash, ctx)				  \
-	char __##shash##_desc[sizeof(struct shash_desc) +	  \
-		HASH_MAX_DESCSIZE] CRYPTO_MINALIGN_ATTR; \
+#define SHASH_DESC_ON_STACK(shash, ctx)					     \
+	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
+		__aligned(__alignof__(struct shash_desc));		     \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
 /**
-- 
2.17.1

