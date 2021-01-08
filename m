Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B415EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 17:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8048A23A00
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 17:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAHRR5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 12:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbhAHRR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 12:17:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC9D2396F;
        Fri,  8 Jan 2021 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610126236;
        bh=jow+8aH4ySsGT4PKJREAxu3enNyghMuJxQzXzC5rYxs=;
        h=From:To:Cc:Subject:Date:From;
        b=kGYt3/EaKN/wpgI9i8TVnSEPkzBySwOVTovGxOIJsgn0FFLKOsxfXp2ag0vCNZ2Aw
         AvLEU8Esss4tzDirPAV5DzSdfHtE8TtzceXKF5B6Z/LI3dk1kdTylhMroZ/x0CGMrm
         Ro9iYNpJk8rz6E5ENpTvwPo4q5P4cO3T0vgxV/87wNaRwWGQEpQEcUA8XsYq209jF7
         L3uf1+lsx4+LeHmSX3WAbFlqy3NebL+pUalYa2MBzOH9+IHnV6PrjkqIhtP4kaPViZ
         v+1q2+bbFHIPSTzzJ6bkLd9jXiXS0N0RR/p/RxAqxhCjJYFgwahKJQ1kQ92ZSl/Zak
         tfchJY/cOwNgg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] crypto: reduce minimum alignment of on-stack structures
Date:   Fri,  8 Jan 2021 18:17:06 +0100
Message-Id: <20210108171706.10306-1-ardb@kernel.org>
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

By the same reasoning, we can reduce the alignment of the skcipher_request
structure when it lives on the stack. Note that in this case, we cannot
reduce the alignment of the __ctx[] struct member, because the structure
type is shared between synchronous and asynchronous users. However, there
is no need to apply CRYPTO_MINALIGN_ATTR to SYNC_SKCIPHER_REQUEST_ON_STACK
so let's use ARCH_SLAB_MINALIGN here as well.

Also, document the DMA aspect of this in the comment that explains the
purpose of CRYPTO_MINALIGN_ATTR.

Note that this is a no-op for x86.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: - reduce alignment for SYNC_SKCIPHER_REQUEST_ON_STACK as well
    - update CRYPTO_MINALIGN_ATTR comment with DMA requirements.

 include/crypto/hash.h     | 8 ++++----
 include/crypto/skcipher.h | 2 +-
 include/linux/crypto.h    | 9 ++++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

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
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 6a733b171a5d..aa133dc3bf39 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -128,7 +128,7 @@ struct skcipher_alg {
 			     MAX_SYNC_SKCIPHER_REQSIZE + \
 			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
 				       (typeof(tfm))1))) \
-			    ] CRYPTO_MINALIGN_ATTR; \
+			    ] __aligned(ARCH_SLAB_MINALIGN); \
 	struct skcipher_request *name = (void *)__##name##_desc
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9b55cd6b1f1b..aec33c95f9c3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -151,9 +151,12 @@
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
  * declaration) is used to ensure that the crypto_tfm context structure is
  * aligned correctly for the given architecture so that there are no alignment
- * faults for C data types.  In particular, this is required on platforms such
- * as arm where pointers are 32-bit aligned but there are data types such as
- * u64 which require 64-bit alignment.
+ * faults for C data types.  On architectures that support non-cache coherent
+ * DMA, such as ARM or arm64, it also takes into account the minimal alignment
+ * that is required to ensure that the context struct member does not share any
+ * cachelines with the rest of the struct. This is needed to ensure that cache
+ * maintenance for non-coherent DMA does not affect data that may be accessed
+ * by the CPU concurrently.
  */
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
 
-- 
2.17.1

