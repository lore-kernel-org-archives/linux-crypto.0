Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D14DC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 09:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB27A233A1
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbhAMJMY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727463AbhAMJMX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 04:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61A632339D;
        Wed, 13 Jan 2021 09:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610529102;
        bh=XyKUOXcQqhm/gBllxM6+ff9e2+a11GynxPuQMKKzyJg=;
        h=From:To:Cc:Subject:Date:From;
        b=MxQSJqlNcq7BUlYM5veTi8Ogw3r4upDqXsvAxdTV6CM49pCrtc9M+ItPoUWF+c3Vm
         rJDFMoCdKTg7PuAc58rb6XL2a3+A2eQj6xVjcfVBE7/FHdge4+axGYfrKwe+Dy4Uel
         X8PUWR/jXB+2nrZhNZqtmtCvYq+hzjG0T3d3d+7tqNpZWV/uTKlXkFiweCRB93i6P4
         wdmJBPbxWex+J1iIW1890KSF8+aWe+6d8dQYcUWPZPYmRQs17l1tGZSyojtEd6D7og
         eKxLqJbo4x2MKvbS7vTFr/x8qJplMQ4V/bmRDQuIrGqytxCsljY8XNY5COL7xugHpt
         QAtdvVz+Jmwbg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3] crypto - shash: reduce minimum alignment of shash_desc structure
Date:   Wed, 13 Jan 2021 10:11:35 +0100
Message-Id: <20210113091135.32579-1-ardb@kernel.org>
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
v3: - drop skcipher_request change again - this needs more careful thought

v2: - reduce alignment for SYNC_SKCIPHER_REQUEST_ON_STACK as well
    - update CRYPTO_MINALIGN_ATTR comment with DMA requirements.

 include/crypto/hash.h  | 8 ++++----
 include/linux/crypto.h | 9 ++++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

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
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9b55cd6b1f1b..da5e0d74bb2f 100644
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
+ * maintenance for non-coherent DMA (cache invalidation in particular) does not
+ * affect data that may be accessed by the CPU concurrently.
  */
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
 
-- 
2.17.1

