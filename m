Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C677CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E50E21D82
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032728;
	bh=UcliuV/VWiEpagz0yACJlGbHZNOn3dQe93jGPyghd6o=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Qu1XnRgVWPTM/yFvU4CXtV/ergdYjOL4yJItZ4gmjz+2HKCAJvDpaZ+OY98uSe8tL
	 mybnWF8KHmRzQBe3xl9B6ODjhZXeZRATw6rKWmn5tQFxDwb1Y/ZVALDhwmbDXuwmO6
	 1Mx7gRu92NumXjSvhSOvuLfMC/XUZCnTA+eza0T8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfJYTp1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfJYTp0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54848222BD
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032724;
        bh=UcliuV/VWiEpagz0yACJlGbHZNOn3dQe93jGPyghd6o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LDHy1yYXeWC1IUn3OAQE7HQOYU381ion+pbZVP1h90Bm4fSRXgb+6HqiN046tT4Ud
         AxraGKeRUpaYsf39I+kqVwAiCFK6shQe3xcXCZVFDnuPyEfvDmRvF0IX6a6/NDLZEt
         VvMxUYy+PrYj7gPOFR4F4OArCF6tRpAF/fLz7+BU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/5] crypto: remove the "blkcipher" algorithm type
Date:   Fri, 25 Oct 2019 12:41:12 -0700
Message-Id: <20191025194113.217451-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all "blkcipher" algorithms have been converted to "skcipher",
remove the blkcipher algorithm type.

The skcipher (symmetric key cipher) algorithm type was introduced a few
years ago to replace both blkcipher and ablkcipher (synchronous and
asynchronous block cipher).  The advantages of skcipher include:

  - A much less confusing name, since none of these algorithm types have
    ever actually been for raw block ciphers, but rather for all
    length-preserving encryption modes including block cipher modes of
    operation, stream ciphers, and other length-preserving modes.

  - It unified blkcipher and ablkcipher into a single algorithm type
    which supports both synchronous and asynchronous implementations.
    Note, blkcipher already operated only on scatterlists, so the fact
    that skcipher does too isn't a regression in functionality.

  - Better type safety by using struct skcipher_alg, struct
    crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.

  - It sometimes simplifies the implementations of algorithms.

Also, the blkcipher API was no longer being tested.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/api-skcipher.rst |  11 +-
 Documentation/crypto/architecture.rst |   2 -
 Documentation/crypto/devel-algos.rst  |  27 +-
 crypto/Makefile                       |   1 -
 crypto/api.c                          |   2 +-
 crypto/blkcipher.c                    | 548 --------------------------
 crypto/cryptd.c                       |   2 +-
 crypto/crypto_user_stat.c             |   4 -
 crypto/essiv.c                        |   6 +-
 crypto/skcipher.c                     | 107 +----
 include/crypto/algapi.h               |  74 ----
 include/crypto/internal/skcipher.h    |  12 -
 include/crypto/skcipher.h             |   8 -
 include/linux/crypto.h                | 395 +------------------
 net/xfrm/xfrm_algo.c                  |   4 +-
 15 files changed, 22 insertions(+), 1181 deletions(-)
 delete mode 100644 crypto/blkcipher.c

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index 55e0851f6fed..56274109ee56 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -5,7 +5,7 @@ Block Cipher Algorithm Definitions
    :doc: Block Cipher Algorithm Definitions
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alg ablkcipher_alg blkcipher_alg cipher_alg compress_alg
+   :functions: crypto_alg ablkcipher_alg cipher_alg compress_alg
 
 Symmetric Key Cipher API
 ------------------------
@@ -51,12 +51,3 @@ Asynchronous Cipher Request Handle - Deprecated
 
 .. kernel-doc:: include/linux/crypto.h
    :functions: crypto_ablkcipher_reqsize ablkcipher_request_set_tfm ablkcipher_request_alloc ablkcipher_request_free ablkcipher_request_set_callback ablkcipher_request_set_crypt
-
-Synchronous Block Cipher API - Deprecated
------------------------------------------
-
-.. kernel-doc:: include/linux/crypto.h
-   :doc: Synchronous Block Cipher API
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_blkcipher crypto_free_blkcipher crypto_has_blkcipher crypto_blkcipher_name crypto_blkcipher_ivsize crypto_blkcipher_blocksize crypto_blkcipher_setkey crypto_blkcipher_encrypt crypto_blkcipher_encrypt_iv crypto_blkcipher_decrypt crypto_blkcipher_decrypt_iv crypto_blkcipher_set_iv crypto_blkcipher_get_iv
diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index 3eae1ae7f798..da90bb006ab0 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -201,8 +201,6 @@ the aforementioned cipher types:
 -  CRYPTO_ALG_TYPE_AEAD Authenticated Encryption with Associated Data
    (MAC)
 
--  CRYPTO_ALG_TYPE_BLKCIPHER Synchronous multi-block cipher
-
 -  CRYPTO_ALG_TYPE_ABLKCIPHER Asynchronous multi-block cipher
 
 -  CRYPTO_ALG_TYPE_KPP Key-agreement Protocol Primitive (KPP) such as
diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index c45c6f400dbd..f9d288015acc 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -128,25 +128,20 @@ process requests that are unaligned. This implies, however, additional
 overhead as the kernel crypto API needs to perform the realignment of
 the data which may imply moving of data.
 
-Cipher Definition With struct blkcipher_alg and ablkcipher_alg
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Cipher Definition With struct skcipher_alg
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-Struct blkcipher_alg defines a synchronous block cipher whereas struct
-ablkcipher_alg defines an asynchronous block cipher.
+Struct skcipher_alg defines a multi-block cipher, or more generally, a
+length-preserving symmetric cipher algorithm.
 
-Please refer to the single block cipher description for schematics of
-the block cipher usage.
+Scatterlist handling
+~~~~~~~~~~~~~~~~~~~~
 
-Specifics Of Asynchronous Multi-Block Cipher
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-There are a couple of specifics to the asynchronous interface.
-
-First of all, some of the drivers will want to use the Generic
-ScatterWalk in case the hardware needs to be fed separate chunks of the
-scatterlist which contains the plaintext and will contain the
-ciphertext. Please refer to the ScatterWalk interface offered by the
-Linux kernel scatter / gather list implementation.
+Some drivers will want to use the Generic ScatterWalk in case the
+hardware needs to be fed separate chunks of the scatterlist which
+contains the plaintext and will contain the ciphertext. Please refer
+to the ScatterWalk interface offered by the Linux kernel scatter /
+gather list implementation.
 
 Hashing [HASH]
 --------------
diff --git a/crypto/Makefile b/crypto/Makefile
index aa740c8492b9..220d86271923 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 
 crypto_blkcipher-y := ablkcipher.o
-crypto_blkcipher-y += blkcipher.o
 crypto_blkcipher-y += skcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
diff --git a/crypto/api.c b/crypto/api.c
index d8ba54142620..3e1f9e95095a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -406,7 +406,7 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *
  *	The returned transform is of a non-determinate type.  Most people
  *	should use one of the more specific allocation functions such as
- *	crypto_alloc_blkcipher.
+ *	crypto_alloc_skcipher().
  *
  *	In case of error the return value is an error pointer.
  */
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
deleted file mode 100644
index 48a33817de11..000000000000
--- a/crypto/blkcipher.c
+++ /dev/null
@@ -1,548 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Block chaining cipher operations.
- *
- * Generic encrypt/decrypt wrapper for ciphers, handles operations across
- * multiple page boundaries by using temporary blocks.  In user context,
- * the kernel is given a chance to schedule us once per page.
- *
- * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <crypto/aead.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/cryptouser.h>
-#include <linux/compiler.h>
-#include <net/netlink.h>
-
-#include "internal.h"
-
-enum {
-	BLKCIPHER_WALK_PHYS = 1 << 0,
-	BLKCIPHER_WALK_SLOW = 1 << 1,
-	BLKCIPHER_WALK_COPY = 1 << 2,
-	BLKCIPHER_WALK_DIFF = 1 << 3,
-};
-
-static int blkcipher_walk_next(struct blkcipher_desc *desc,
-			       struct blkcipher_walk *walk);
-static int blkcipher_walk_first(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk);
-
-static inline void blkcipher_map_src(struct blkcipher_walk *walk)
-{
-	walk->src.virt.addr = scatterwalk_map(&walk->in);
-}
-
-static inline void blkcipher_map_dst(struct blkcipher_walk *walk)
-{
-	walk->dst.virt.addr = scatterwalk_map(&walk->out);
-}
-
-static inline void blkcipher_unmap_src(struct blkcipher_walk *walk)
-{
-	scatterwalk_unmap(walk->src.virt.addr);
-}
-
-static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
-{
-	scatterwalk_unmap(walk->dst.virt.addr);
-}
-
-/* Get a spot of the specified length that does not straddle a page.
- * The caller needs to ensure that there is enough space for this operation.
- */
-static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
-{
-	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
-	return max(start, end_page);
-}
-
-static inline void blkcipher_done_slow(struct blkcipher_walk *walk,
-				       unsigned int bsize)
-{
-	u8 *addr;
-
-	addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
-	addr = blkcipher_get_spot(addr, bsize);
-	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
-}
-
-static inline void blkcipher_done_fast(struct blkcipher_walk *walk,
-				       unsigned int n)
-{
-	if (walk->flags & BLKCIPHER_WALK_COPY) {
-		blkcipher_map_dst(walk);
-		memcpy(walk->dst.virt.addr, walk->page, n);
-		blkcipher_unmap_dst(walk);
-	} else if (!(walk->flags & BLKCIPHER_WALK_PHYS)) {
-		if (walk->flags & BLKCIPHER_WALK_DIFF)
-			blkcipher_unmap_dst(walk);
-		blkcipher_unmap_src(walk);
-	}
-
-	scatterwalk_advance(&walk->in, n);
-	scatterwalk_advance(&walk->out, n);
-}
-
-int blkcipher_walk_done(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk, int err)
-{
-	unsigned int n; /* bytes processed */
-	bool more;
-
-	if (unlikely(err < 0))
-		goto finish;
-
-	n = walk->nbytes - err;
-	walk->total -= n;
-	more = (walk->total != 0);
-
-	if (likely(!(walk->flags & BLKCIPHER_WALK_SLOW))) {
-		blkcipher_done_fast(walk, n);
-	} else {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
-			err = -EINVAL;
-			goto finish;
-		}
-		blkcipher_done_slow(walk, n);
-	}
-
-	scatterwalk_done(&walk->in, 0, more);
-	scatterwalk_done(&walk->out, 1, more);
-
-	if (more) {
-		crypto_yield(desc->flags);
-		return blkcipher_walk_next(desc, walk);
-	}
-	err = 0;
-finish:
-	walk->nbytes = 0;
-	if (walk->iv != desc->info)
-		memcpy(desc->info, walk->iv, walk->ivsize);
-	if (walk->buffer != walk->page)
-		kfree(walk->buffer);
-	if (walk->page)
-		free_page((unsigned long)walk->page);
-	return err;
-}
-EXPORT_SYMBOL_GPL(blkcipher_walk_done);
-
-static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk,
-				      unsigned int bsize,
-				      unsigned int alignmask)
-{
-	unsigned int n;
-	unsigned aligned_bsize = ALIGN(bsize, alignmask + 1);
-
-	if (walk->buffer)
-		goto ok;
-
-	walk->buffer = walk->page;
-	if (walk->buffer)
-		goto ok;
-
-	n = aligned_bsize * 3 - (alignmask + 1) +
-	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
-	walk->buffer = kmalloc(n, GFP_ATOMIC);
-	if (!walk->buffer)
-		return blkcipher_walk_done(desc, walk, -ENOMEM);
-
-ok:
-	walk->dst.virt.addr = (u8 *)ALIGN((unsigned long)walk->buffer,
-					  alignmask + 1);
-	walk->dst.virt.addr = blkcipher_get_spot(walk->dst.virt.addr, bsize);
-	walk->src.virt.addr = blkcipher_get_spot(walk->dst.virt.addr +
-						 aligned_bsize, bsize);
-
-	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
-
-	walk->nbytes = bsize;
-	walk->flags |= BLKCIPHER_WALK_SLOW;
-
-	return 0;
-}
-
-static inline int blkcipher_next_copy(struct blkcipher_walk *walk)
-{
-	u8 *tmp = walk->page;
-
-	blkcipher_map_src(walk);
-	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
-	blkcipher_unmap_src(walk);
-
-	walk->src.virt.addr = tmp;
-	walk->dst.virt.addr = tmp;
-
-	return 0;
-}
-
-static inline int blkcipher_next_fast(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk)
-{
-	unsigned long diff;
-
-	walk->src.phys.page = scatterwalk_page(&walk->in);
-	walk->src.phys.offset = offset_in_page(walk->in.offset);
-	walk->dst.phys.page = scatterwalk_page(&walk->out);
-	walk->dst.phys.offset = offset_in_page(walk->out.offset);
-
-	if (walk->flags & BLKCIPHER_WALK_PHYS)
-		return 0;
-
-	diff = walk->src.phys.offset - walk->dst.phys.offset;
-	diff |= walk->src.virt.page - walk->dst.virt.page;
-
-	blkcipher_map_src(walk);
-	walk->dst.virt.addr = walk->src.virt.addr;
-
-	if (diff) {
-		walk->flags |= BLKCIPHER_WALK_DIFF;
-		blkcipher_map_dst(walk);
-	}
-
-	return 0;
-}
-
-static int blkcipher_walk_next(struct blkcipher_desc *desc,
-			       struct blkcipher_walk *walk)
-{
-	unsigned int bsize;
-	unsigned int n;
-	int err;
-
-	n = walk->total;
-	if (unlikely(n < walk->cipher_blocksize)) {
-		desc->flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		return blkcipher_walk_done(desc, walk, -EINVAL);
-	}
-
-	bsize = min(walk->walk_blocksize, n);
-
-	walk->flags &= ~(BLKCIPHER_WALK_SLOW | BLKCIPHER_WALK_COPY |
-			 BLKCIPHER_WALK_DIFF);
-	if (!scatterwalk_aligned(&walk->in, walk->alignmask) ||
-	    !scatterwalk_aligned(&walk->out, walk->alignmask)) {
-		walk->flags |= BLKCIPHER_WALK_COPY;
-		if (!walk->page) {
-			walk->page = (void *)__get_free_page(GFP_ATOMIC);
-			if (!walk->page)
-				n = 0;
-		}
-	}
-
-	n = scatterwalk_clamp(&walk->in, n);
-	n = scatterwalk_clamp(&walk->out, n);
-
-	if (unlikely(n < bsize)) {
-		err = blkcipher_next_slow(desc, walk, bsize, walk->alignmask);
-		goto set_phys_lowmem;
-	}
-
-	walk->nbytes = n;
-	if (walk->flags & BLKCIPHER_WALK_COPY) {
-		err = blkcipher_next_copy(walk);
-		goto set_phys_lowmem;
-	}
-
-	return blkcipher_next_fast(desc, walk);
-
-set_phys_lowmem:
-	if (walk->flags & BLKCIPHER_WALK_PHYS) {
-		walk->src.phys.page = virt_to_page(walk->src.virt.addr);
-		walk->dst.phys.page = virt_to_page(walk->dst.virt.addr);
-		walk->src.phys.offset &= PAGE_SIZE - 1;
-		walk->dst.phys.offset &= PAGE_SIZE - 1;
-	}
-	return err;
-}
-
-static inline int blkcipher_copy_iv(struct blkcipher_walk *walk)
-{
-	unsigned bs = walk->walk_blocksize;
-	unsigned aligned_bs = ALIGN(bs, walk->alignmask + 1);
-	unsigned int size = aligned_bs * 2 +
-			    walk->ivsize + max(aligned_bs, walk->ivsize) -
-			    (walk->alignmask + 1);
-	u8 *iv;
-
-	size += walk->alignmask & ~(crypto_tfm_ctx_alignment() - 1);
-	walk->buffer = kmalloc(size, GFP_ATOMIC);
-	if (!walk->buffer)
-		return -ENOMEM;
-
-	iv = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
-	iv = blkcipher_get_spot(iv, bs) + aligned_bs;
-	iv = blkcipher_get_spot(iv, bs) + aligned_bs;
-	iv = blkcipher_get_spot(iv, walk->ivsize);
-
-	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
-	return 0;
-}
-
-int blkcipher_walk_virt(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk)
-{
-	walk->flags &= ~BLKCIPHER_WALK_PHYS;
-	walk->walk_blocksize = crypto_blkcipher_blocksize(desc->tfm);
-	walk->cipher_blocksize = walk->walk_blocksize;
-	walk->ivsize = crypto_blkcipher_ivsize(desc->tfm);
-	walk->alignmask = crypto_blkcipher_alignmask(desc->tfm);
-	return blkcipher_walk_first(desc, walk);
-}
-EXPORT_SYMBOL_GPL(blkcipher_walk_virt);
-
-int blkcipher_walk_phys(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk)
-{
-	walk->flags |= BLKCIPHER_WALK_PHYS;
-	walk->walk_blocksize = crypto_blkcipher_blocksize(desc->tfm);
-	walk->cipher_blocksize = walk->walk_blocksize;
-	walk->ivsize = crypto_blkcipher_ivsize(desc->tfm);
-	walk->alignmask = crypto_blkcipher_alignmask(desc->tfm);
-	return blkcipher_walk_first(desc, walk);
-}
-EXPORT_SYMBOL_GPL(blkcipher_walk_phys);
-
-static int blkcipher_walk_first(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
-{
-	if (WARN_ON_ONCE(in_irq()))
-		return -EDEADLK;
-
-	walk->iv = desc->info;
-	walk->nbytes = walk->total;
-	if (unlikely(!walk->total))
-		return 0;
-
-	walk->buffer = NULL;
-	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
-		int err = blkcipher_copy_iv(walk);
-		if (err)
-			return err;
-	}
-
-	scatterwalk_start(&walk->in, walk->in.sg);
-	scatterwalk_start(&walk->out, walk->out.sg);
-	walk->page = NULL;
-
-	return blkcipher_walk_next(desc, walk);
-}
-
-int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
-			      struct blkcipher_walk *walk,
-			      unsigned int blocksize)
-{
-	walk->flags &= ~BLKCIPHER_WALK_PHYS;
-	walk->walk_blocksize = blocksize;
-	walk->cipher_blocksize = crypto_blkcipher_blocksize(desc->tfm);
-	walk->ivsize = crypto_blkcipher_ivsize(desc->tfm);
-	walk->alignmask = crypto_blkcipher_alignmask(desc->tfm);
-	return blkcipher_walk_first(desc, walk);
-}
-EXPORT_SYMBOL_GPL(blkcipher_walk_virt_block);
-
-int blkcipher_aead_walk_virt_block(struct blkcipher_desc *desc,
-				   struct blkcipher_walk *walk,
-				   struct crypto_aead *tfm,
-				   unsigned int blocksize)
-{
-	walk->flags &= ~BLKCIPHER_WALK_PHYS;
-	walk->walk_blocksize = blocksize;
-	walk->cipher_blocksize = crypto_aead_blocksize(tfm);
-	walk->ivsize = crypto_aead_ivsize(tfm);
-	walk->alignmask = crypto_aead_alignmask(tfm);
-	return blkcipher_walk_first(desc, walk);
-}
-EXPORT_SYMBOL_GPL(blkcipher_aead_walk_virt_block);
-
-static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-	int ret;
-	u8 *buffer, *alignbuffer;
-	unsigned long absize;
-
-	absize = keylen + alignmask;
-	buffer = kmalloc(absize, GFP_ATOMIC);
-	if (!buffer)
-		return -ENOMEM;
-
-	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-	memcpy(alignbuffer, key, keylen);
-	ret = cipher->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
-	return ret;
-}
-
-static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
-{
-	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-
-	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
-	if ((unsigned long)key & alignmask)
-		return setkey_unaligned(tfm, key, keylen);
-
-	return cipher->setkey(tfm, key, keylen);
-}
-
-static int async_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
-			unsigned int keylen)
-{
-	return setkey(crypto_ablkcipher_tfm(tfm), key, keylen);
-}
-
-static int async_encrypt(struct ablkcipher_request *req)
-{
-	struct crypto_tfm *tfm = req->base.tfm;
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-	struct blkcipher_desc desc = {
-		.tfm = __crypto_blkcipher_cast(tfm),
-		.info = req->info,
-		.flags = req->base.flags,
-	};
-
-
-	return alg->encrypt(&desc, req->dst, req->src, req->nbytes);
-}
-
-static int async_decrypt(struct ablkcipher_request *req)
-{
-	struct crypto_tfm *tfm = req->base.tfm;
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-	struct blkcipher_desc desc = {
-		.tfm = __crypto_blkcipher_cast(tfm),
-		.info = req->info,
-		.flags = req->base.flags,
-	};
-
-	return alg->decrypt(&desc, req->dst, req->src, req->nbytes);
-}
-
-static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg, u32 type,
-					     u32 mask)
-{
-	struct blkcipher_alg *cipher = &alg->cra_blkcipher;
-	unsigned int len = alg->cra_ctxsize;
-
-	if ((mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_MASK &&
-	    cipher->ivsize) {
-		len = ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
-		len += cipher->ivsize;
-	}
-
-	return len;
-}
-
-static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
-{
-	struct ablkcipher_tfm *crt = &tfm->crt_ablkcipher;
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-
-	crt->setkey = async_setkey;
-	crt->encrypt = async_encrypt;
-	crt->decrypt = async_decrypt;
-	crt->base = __crypto_ablkcipher_cast(tfm);
-	crt->ivsize = alg->ivsize;
-
-	return 0;
-}
-
-static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
-{
-	struct blkcipher_tfm *crt = &tfm->crt_blkcipher;
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-	unsigned long align = crypto_tfm_alg_alignmask(tfm) + 1;
-	unsigned long addr;
-
-	crt->setkey = setkey;
-	crt->encrypt = alg->encrypt;
-	crt->decrypt = alg->decrypt;
-
-	addr = (unsigned long)crypto_tfm_ctx(tfm);
-	addr = ALIGN(addr, align);
-	addr += ALIGN(tfm->__crt_alg->cra_ctxsize, align);
-	crt->iv = (void *)addr;
-
-	return 0;
-}
-
-static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-
-	if (alg->ivsize > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	if ((mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_MASK)
-		return crypto_init_blkcipher_ops_sync(tfm);
-	else
-		return crypto_init_blkcipher_ops_async(tfm);
-}
-
-#ifdef CONFIG_NET
-static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_blkcipher rblkcipher;
-
-	memset(&rblkcipher, 0, sizeof(rblkcipher));
-
-	strscpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, "<default>", sizeof(rblkcipher.geniv));
-
-	rblkcipher.blocksize = alg->cra_blocksize;
-	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-	rblkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
-	rblkcipher.ivsize = alg->cra_blkcipher.ivsize;
-
-	return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
-		       sizeof(rblkcipher), &rblkcipher);
-}
-#else
-static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	seq_printf(m, "type         : blkcipher\n");
-	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "min keysize  : %u\n", alg->cra_blkcipher.min_keysize);
-	seq_printf(m, "max keysize  : %u\n", alg->cra_blkcipher.max_keysize);
-	seq_printf(m, "ivsize       : %u\n", alg->cra_blkcipher.ivsize);
-	seq_printf(m, "geniv        : <default>\n");
-}
-
-const struct crypto_type crypto_blkcipher_type = {
-	.ctxsize = crypto_blkcipher_ctxsize,
-	.init = crypto_init_blkcipher_ops,
-#ifdef CONFIG_PROC_FS
-	.show = crypto_blkcipher_show,
-#endif
-	.report = crypto_blkcipher_report,
-};
-EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 927760b316a4..2c6649b10923 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -919,7 +919,7 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_BLKCIPHER:
+	case CRYPTO_ALG_TYPE_SKCIPHER:
 		return cryptd_create_skcipher(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_HASH:
 		return cryptd_create_hash(tmpl, tb, &queue);
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 1be95432fa23..154884bf9275 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -213,10 +213,6 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		if (crypto_report_cipher(skb, alg))
 			goto nla_put_failure;
 		break;
-	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		if (crypto_report_cipher(skb, alg))
-			goto nla_put_failure;
-		break;
 	case CRYPTO_ALG_TYPE_CIPHER:
 		if (crypto_report_cipher(skb, alg))
 			goto nla_put_failure;
diff --git a/crypto/essiv.c b/crypto/essiv.c
index a8befc8fb06e..fc248de88590 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -486,7 +486,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	type = algt->type & algt->mask;
 
 	switch (type) {
-	case CRYPTO_ALG_TYPE_BLKCIPHER:
+	case CRYPTO_ALG_TYPE_SKCIPHER:
 		skcipher_inst = kzalloc(sizeof(*skcipher_inst) +
 					sizeof(*ictx), GFP_KERNEL);
 		if (!skcipher_inst)
@@ -586,7 +586,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	base->cra_alignmask	= block_base->cra_alignmask;
 	base->cra_priority	= block_base->cra_priority;
 
-	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
+	if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
 		skcipher_inst->alg.setkey	= essiv_skcipher_setkey;
 		skcipher_inst->alg.encrypt	= essiv_skcipher_encrypt;
 		skcipher_inst->alg.decrypt	= essiv_skcipher_decrypt;
@@ -628,7 +628,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 out_free_hash:
 	crypto_mod_put(_hash_alg);
 out_drop_skcipher:
-	if (type == CRYPTO_ALG_TYPE_BLKCIPHER)
+	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
 		crypto_drop_skcipher(&ictx->u.skcipher_spawn);
 	else
 		crypto_drop_aead(&ictx->u.aead_spawn);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 490a3f4b5102..1ce8fbb85f95 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -580,9 +580,6 @@ EXPORT_SYMBOL_GPL(skcipher_walk_aead_decrypt);
 
 static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
 {
-	if (alg->cra_type == &crypto_blkcipher_type)
-		return sizeof(struct crypto_blkcipher *);
-
 	if (alg->cra_type == &crypto_ablkcipher_type)
 		return sizeof(struct crypto_ablkcipher *);
 
@@ -595,105 +592,6 @@ static void skcipher_set_needkey(struct crypto_skcipher *tfm)
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
-static int skcipher_setkey_blkcipher(struct crypto_skcipher *tfm,
-				     const u8 *key, unsigned int keylen)
-{
-	struct crypto_blkcipher **ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_blkcipher *blkcipher = *ctx;
-	int err;
-
-	crypto_blkcipher_clear_flags(blkcipher, ~0);
-	crypto_blkcipher_set_flags(blkcipher, crypto_skcipher_get_flags(tfm) &
-					      CRYPTO_TFM_REQ_MASK);
-	err = crypto_blkcipher_setkey(blkcipher, key, keylen);
-	crypto_skcipher_set_flags(tfm, crypto_blkcipher_get_flags(blkcipher) &
-				       CRYPTO_TFM_RES_MASK);
-	if (unlikely(err)) {
-		skcipher_set_needkey(tfm);
-		return err;
-	}
-
-	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
-	return 0;
-}
-
-static int skcipher_crypt_blkcipher(struct skcipher_request *req,
-				    int (*crypt)(struct blkcipher_desc *,
-						 struct scatterlist *,
-						 struct scatterlist *,
-						 unsigned int))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_blkcipher **ctx = crypto_skcipher_ctx(tfm);
-	struct blkcipher_desc desc = {
-		.tfm = *ctx,
-		.info = req->iv,
-		.flags = req->base.flags,
-	};
-
-
-	return crypt(&desc, req->dst, req->src, req->cryptlen);
-}
-
-static int skcipher_encrypt_blkcipher(struct skcipher_request *req)
-{
-	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-
-	return skcipher_crypt_blkcipher(req, alg->encrypt);
-}
-
-static int skcipher_decrypt_blkcipher(struct skcipher_request *req)
-{
-	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
-	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
-
-	return skcipher_crypt_blkcipher(req, alg->decrypt);
-}
-
-static void crypto_exit_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
-{
-	struct crypto_blkcipher **ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_blkcipher(*ctx);
-}
-
-static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
-{
-	struct crypto_alg *calg = tfm->__crt_alg;
-	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
-	struct crypto_blkcipher **ctx = crypto_tfm_ctx(tfm);
-	struct crypto_blkcipher *blkcipher;
-	struct crypto_tfm *btfm;
-
-	if (!crypto_mod_get(calg))
-		return -EAGAIN;
-
-	btfm = __crypto_alloc_tfm(calg, CRYPTO_ALG_TYPE_BLKCIPHER,
-					CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(btfm)) {
-		crypto_mod_put(calg);
-		return PTR_ERR(btfm);
-	}
-
-	blkcipher = __crypto_blkcipher_cast(btfm);
-	*ctx = blkcipher;
-	tfm->exit = crypto_exit_skcipher_ops_blkcipher;
-
-	skcipher->setkey = skcipher_setkey_blkcipher;
-	skcipher->encrypt = skcipher_encrypt_blkcipher;
-	skcipher->decrypt = skcipher_decrypt_blkcipher;
-
-	skcipher->ivsize = crypto_blkcipher_ivsize(blkcipher);
-	skcipher->keysize = calg->cra_blkcipher.max_keysize;
-
-	skcipher_set_needkey(skcipher);
-
-	return 0;
-}
-
 static int skcipher_setkey_ablkcipher(struct crypto_skcipher *tfm,
 				      const u8 *key, unsigned int keylen)
 {
@@ -888,9 +786,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
 
-	if (tfm->__crt_alg->cra_type == &crypto_blkcipher_type)
-		return crypto_init_skcipher_ops_blkcipher(tfm);
-
 	if (tfm->__crt_alg->cra_type == &crypto_ablkcipher_type)
 		return crypto_init_skcipher_ops_ablkcipher(tfm);
 
@@ -973,7 +868,7 @@ static const struct crypto_type crypto_skcipher_type = {
 #endif
 	.report = crypto_skcipher_report,
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
-	.maskset = CRYPTO_ALG_TYPE_BLKCIPHER_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.tfmsize = offsetof(struct crypto_skcipher, base),
 };
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e5bd302f2c49..cadc5257c612 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -85,36 +85,6 @@ struct scatter_walk {
 	unsigned int offset;
 };
 
-struct blkcipher_walk {
-	union {
-		struct {
-			struct page *page;
-			unsigned long offset;
-		} phys;
-
-		struct {
-			u8 *page;
-			u8 *addr;
-		} virt;
-	} src, dst;
-
-	struct scatter_walk in;
-	unsigned int nbytes;
-
-	struct scatter_walk out;
-	unsigned int total;
-
-	void *page;
-	u8 *buffer;
-	u8 *iv;
-	unsigned int ivsize;
-
-	int flags;
-	unsigned int walk_blocksize;
-	unsigned int cipher_blocksize;
-	unsigned int alignmask;
-};
-
 struct ablkcipher_walk {
 	struct {
 		struct page *page;
@@ -133,7 +103,6 @@ struct ablkcipher_walk {
 };
 
 extern const struct crypto_type crypto_ablkcipher_type;
-extern const struct crypto_type crypto_blkcipher_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
@@ -233,20 +202,6 @@ static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
 	}
 }
 
-int blkcipher_walk_done(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk, int err);
-int blkcipher_walk_virt(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk);
-int blkcipher_walk_phys(struct blkcipher_desc *desc,
-			struct blkcipher_walk *walk);
-int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
-			      struct blkcipher_walk *walk,
-			      unsigned int blocksize);
-int blkcipher_aead_walk_virt_block(struct blkcipher_desc *desc,
-				   struct blkcipher_walk *walk,
-				   struct crypto_aead *tfm,
-				   unsigned int blocksize);
-
 int ablkcipher_walk_done(struct ablkcipher_request *req,
 			 struct ablkcipher_walk *walk, int err);
 int ablkcipher_walk_phys(struct ablkcipher_request *req,
@@ -286,25 +241,6 @@ static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
 	return crypto_tfm_ctx_aligned(&tfm->base);
 }
 
-static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
-	struct crypto_spawn *spawn)
-{
-	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_blkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
-}
-
-static inline void *crypto_blkcipher_ctx(struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_ctx(&tfm->base);
-}
-
-static inline void *crypto_blkcipher_ctx_aligned(struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_ctx_aligned(&tfm->base);
-}
-
 static inline struct crypto_cipher *crypto_spawn_cipher(
 	struct crypto_spawn *spawn)
 {
@@ -319,16 +255,6 @@ static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
 	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
 }
 
-static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
-				       struct scatterlist *dst,
-				       struct scatterlist *src,
-				       unsigned int nbytes)
-{
-	walk->in.sg = src;
-	walk->out.sg = dst;
-	walk->total = nbytes;
-}
-
 static inline void ablkcipher_walk_init(struct ablkcipher_walk *walk,
 					struct scatterlist *dst,
 					struct scatterlist *src,
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 3175dfeaed2c..454e898d5f5f 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -182,10 +182,6 @@ static inline u32 skcipher_request_flags(struct skcipher_request *req)
 static inline unsigned int crypto_skcipher_alg_min_keysize(
 	struct skcipher_alg *alg)
 {
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blkcipher.min_keysize;
-
 	if (alg->base.cra_ablkcipher.encrypt)
 		return alg->base.cra_ablkcipher.min_keysize;
 
@@ -195,10 +191,6 @@ static inline unsigned int crypto_skcipher_alg_min_keysize(
 static inline unsigned int crypto_skcipher_alg_max_keysize(
 	struct skcipher_alg *alg)
 {
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blkcipher.max_keysize;
-
 	if (alg->base.cra_ablkcipher.encrypt)
 		return alg->base.cra_ablkcipher.max_keysize;
 
@@ -208,10 +200,6 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
 static inline unsigned int crypto_skcipher_alg_walksize(
 	struct skcipher_alg *alg)
 {
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
 	if (alg->base.cra_ablkcipher.encrypt)
 		return alg->base.cra_blocksize;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index e34993f5d190..8c5a31e810da 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -241,10 +241,6 @@ static inline struct skcipher_alg *crypto_skcipher_alg(
 
 static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
 {
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blkcipher.ivsize;
-
 	if (alg->base.cra_ablkcipher.encrypt)
 		return alg->base.cra_ablkcipher.ivsize;
 
@@ -290,10 +286,6 @@ static inline unsigned int crypto_skcipher_blocksize(
 static inline unsigned int crypto_skcipher_alg_chunksize(
 	struct skcipher_alg *alg)
 {
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
 	if (alg->base.cra_ablkcipher.encrypt)
 		return alg->base.cra_blocksize;
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7855743f7e3..e9f2c6b5d800 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -41,7 +41,6 @@
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
-#define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_SKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_KPP		0x00000008
@@ -55,7 +54,6 @@
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
-#define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000e
 
 #define CRYPTO_ALG_LARVAL		0x00000010
@@ -141,7 +139,6 @@
 struct scatterlist;
 struct crypto_ablkcipher;
 struct crypto_async_request;
-struct crypto_blkcipher;
 struct crypto_tfm;
 struct crypto_type;
 
@@ -176,12 +173,6 @@ struct ablkcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-struct blkcipher_desc {
-	struct crypto_blkcipher *tfm;
-	void *info;
-	u32 flags;
-};
-
 /**
  * DOC: Block Cipher Algorithm Definitions
  *
@@ -240,32 +231,6 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
 
-/**
- * struct blkcipher_alg - synchronous block cipher definition
- * @min_keysize: see struct ablkcipher_alg
- * @max_keysize: see struct ablkcipher_alg
- * @setkey: see struct ablkcipher_alg
- * @encrypt: see struct ablkcipher_alg
- * @decrypt: see struct ablkcipher_alg
- * @ivsize: see struct ablkcipher_alg
- *
- * All fields except @ivsize are mandatory and must be filled.
- */
-struct blkcipher_alg {
-	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
-	              unsigned int keylen);
-	int (*encrypt)(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes);
-	int (*decrypt)(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes);
-
-	unsigned int min_keysize;
-	unsigned int max_keysize;
-	unsigned int ivsize;
-};
-
 /**
  * struct cipher_alg - single-block symmetric ciphers definition
  * @cia_min_keysize: Minimum key size supported by the transformation. This is
@@ -451,7 +416,6 @@ struct crypto_istat_rng {
 #endif /* CONFIG_CRYPTO_STATS */
 
 #define cra_ablkcipher	cra_u.ablkcipher
-#define cra_blkcipher	cra_u.blkcipher
 #define cra_cipher	cra_u.cipher
 #define cra_compress	cra_u.compress
 
@@ -499,9 +463,8 @@ struct crypto_istat_rng {
  *		     transformation algorithm.
  * @cra_type: Type of the cryptographic transformation. This is a pointer to
  *	      struct crypto_type, which implements callbacks common for all
- *	      transformation types. There are multiple options:
- *	      &crypto_blkcipher_type, &crypto_ablkcipher_type,
- *	      &crypto_ahash_type, &crypto_rng_type.
+ *	      transformation types. There are multiple options, such as
+ *	      &crypto_skcipher_type, &crypto_ahash_type, &crypto_rng_type.
  *	      This field might be empty. In that case, there are no common
  *	      callbacks. This is the case for: cipher, compress, shash.
  * @cra_u: Callbacks implementing the transformation. This is a union of
@@ -522,8 +485,6 @@ struct crypto_istat_rng {
  *	      @cra_init.
  * @cra_u.ablkcipher: Union member which contains an asynchronous block cipher
  *		      definition. See @struct @ablkcipher_alg.
- * @cra_u.blkcipher: Union member which contains a synchronous block cipher
- * 		     definition See @struct @blkcipher_alg.
  * @cra_u.cipher: Union member which contains a single-block symmetric cipher
  *		  definition. See @struct @cipher_alg.
  * @cra_u.compress: Union member which contains a (de)compression algorithm.
@@ -566,7 +527,6 @@ struct crypto_alg {
 
 	union {
 		struct ablkcipher_alg ablkcipher;
-		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct compress_alg compress;
 	} cra_u;
@@ -727,16 +687,6 @@ struct ablkcipher_tfm {
 	unsigned int reqsize;
 };
 
-struct blkcipher_tfm {
-	void *iv;
-	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
-		      unsigned int keylen);
-	int (*encrypt)(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes);
-	int (*decrypt)(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes);
-};
-
 struct cipher_tfm {
 	int (*cit_setkey)(struct crypto_tfm *tfm,
 	                  const u8 *key, unsigned int keylen);
@@ -754,7 +704,6 @@ struct compress_tfm {
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
-#define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_compress	crt_u.compress
 
@@ -764,7 +713,6 @@ struct crypto_tfm {
 	
 	union {
 		struct ablkcipher_tfm ablkcipher;
-		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
 		struct compress_tfm compress;
 	} crt_u;
@@ -780,10 +728,6 @@ struct crypto_ablkcipher {
 	struct crypto_tfm base;
 };
 
-struct crypto_blkcipher {
-	struct crypto_tfm base;
-};
-
 struct crypto_cipher {
 	struct crypto_tfm base;
 };
@@ -1232,341 +1176,6 @@ static inline void ablkcipher_request_set_crypt(
 	req->info = iv;
 }
 
-/**
- * DOC: Synchronous Block Cipher API
- *
- * The synchronous block cipher API is used with the ciphers of type
- * CRYPTO_ALG_TYPE_BLKCIPHER (listed as type "blkcipher" in /proc/crypto)
- *
- * Synchronous calls, have a context in the tfm. But since a single tfm can be
- * used in multiple calls and in parallel, this info should not be changeable
- * (unless a lock is used). This applies, for example, to the symmetric key.
- * However, the IV is changeable, so there is an iv field in blkcipher_tfm
- * structure for synchronous blkcipher api. So, its the only state info that can
- * be kept for synchronous calls without using a big lock across a tfm.
- *
- * The block cipher API allows the use of a complete cipher, i.e. a cipher
- * consisting of a template (a block chaining mode) and a single block cipher
- * primitive (e.g. AES).
- *
- * The plaintext data buffer and the ciphertext data buffer are pointed to
- * by using scatter/gather lists. The cipher operation is performed
- * on all segments of the provided scatter/gather lists.
- *
- * The kernel crypto API supports a cipher operation "in-place" which means that
- * the caller may provide the same scatter/gather list for the plaintext and
- * cipher text. After the completion of the cipher operation, the plaintext
- * data is replaced with the ciphertext data in case of an encryption and vice
- * versa for a decryption. The caller must ensure that the scatter/gather lists
- * for the output data point to sufficiently large buffers, i.e. multiples of
- * the block size of the cipher.
- */
-
-static inline struct crypto_blkcipher *__crypto_blkcipher_cast(
-	struct crypto_tfm *tfm)
-{
-	return (struct crypto_blkcipher *)tfm;
-}
-
-static inline struct crypto_blkcipher *crypto_blkcipher_cast(
-	struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_BLKCIPHER);
-	return __crypto_blkcipher_cast(tfm);
-}
-
-/**
- * crypto_alloc_blkcipher() - allocate synchronous block cipher handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      blkcipher cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for a block cipher. The returned struct
- * crypto_blkcipher is the cipher handle that is required for any subsequent
- * API invocation for that block cipher.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
-	const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, type, mask));
-}
-
-static inline struct crypto_tfm *crypto_blkcipher_tfm(
-	struct crypto_blkcipher *tfm)
-{
-	return &tfm->base;
-}
-
-/**
- * crypto_free_blkcipher() - zeroize and free the block cipher handle
- * @tfm: cipher handle to be freed
- */
-static inline void crypto_free_blkcipher(struct crypto_blkcipher *tfm)
-{
-	crypto_free_tfm(crypto_blkcipher_tfm(tfm));
-}
-
-/**
- * crypto_has_blkcipher() - Search for the availability of a block cipher
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      block cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the block cipher is known to the kernel crypto API; false
- *	   otherwise
- */
-static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
-}
-
-/**
- * crypto_blkcipher_name() - return the name / cra_name from the cipher handle
- * @tfm: cipher handle
- *
- * Return: The character string holding the name of the cipher
- */
-static inline const char *crypto_blkcipher_name(struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_alg_name(crypto_blkcipher_tfm(tfm));
-}
-
-static inline struct blkcipher_tfm *crypto_blkcipher_crt(
-	struct crypto_blkcipher *tfm)
-{
-	return &crypto_blkcipher_tfm(tfm)->crt_blkcipher;
-}
-
-static inline struct blkcipher_alg *crypto_blkcipher_alg(
-	struct crypto_blkcipher *tfm)
-{
-	return &crypto_blkcipher_tfm(tfm)->__crt_alg->cra_blkcipher;
-}
-
-/**
- * crypto_blkcipher_ivsize() - obtain IV size
- * @tfm: cipher handle
- *
- * The size of the IV for the block cipher referenced by the cipher handle is
- * returned. This IV size may be zero if the cipher does not need an IV.
- *
- * Return: IV size in bytes
- */
-static inline unsigned int crypto_blkcipher_ivsize(struct crypto_blkcipher *tfm)
-{
-	return crypto_blkcipher_alg(tfm)->ivsize;
-}
-
-/**
- * crypto_blkcipher_blocksize() - obtain block size of cipher
- * @tfm: cipher handle
- *
- * The block size for the block cipher referenced with the cipher handle is
- * returned. The caller may use that information to allocate appropriate
- * memory for the data returned by the encryption or decryption operation.
- *
- * Return: block size of cipher
- */
-static inline unsigned int crypto_blkcipher_blocksize(
-	struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_alg_blocksize(crypto_blkcipher_tfm(tfm));
-}
-
-static inline unsigned int crypto_blkcipher_alignmask(
-	struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_blkcipher_tfm(tfm));
-}
-
-static inline u32 crypto_blkcipher_get_flags(struct crypto_blkcipher *tfm)
-{
-	return crypto_tfm_get_flags(crypto_blkcipher_tfm(tfm));
-}
-
-static inline void crypto_blkcipher_set_flags(struct crypto_blkcipher *tfm,
-					      u32 flags)
-{
-	crypto_tfm_set_flags(crypto_blkcipher_tfm(tfm), flags);
-}
-
-static inline void crypto_blkcipher_clear_flags(struct crypto_blkcipher *tfm,
-						u32 flags)
-{
-	crypto_tfm_clear_flags(crypto_blkcipher_tfm(tfm), flags);
-}
-
-/**
- * crypto_blkcipher_setkey() - set key for cipher
- * @tfm: cipher handle
- * @key: buffer holding the key
- * @keylen: length of the key in bytes
- *
- * The caller provided key is set for the block cipher referenced by the cipher
- * handle.
- *
- * Note, the key length determines the cipher type. Many block ciphers implement
- * different cipher modes depending on the key size, such as AES-128 vs AES-192
- * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
- * is performed.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-static inline int crypto_blkcipher_setkey(struct crypto_blkcipher *tfm,
-					  const u8 *key, unsigned int keylen)
-{
-	return crypto_blkcipher_crt(tfm)->setkey(crypto_blkcipher_tfm(tfm),
-						 key, keylen);
-}
-
-/**
- * crypto_blkcipher_encrypt() - encrypt plaintext
- * @desc: reference to the block cipher handle with meta data
- * @dst: scatter/gather list that is filled by the cipher operation with the
- *	ciphertext
- * @src: scatter/gather list that holds the plaintext
- * @nbytes: number of bytes of the plaintext to encrypt.
- *
- * Encrypt plaintext data using the IV set by the caller with a preceding
- * call of crypto_blkcipher_set_iv.
- *
- * The blkcipher_desc data structure must be filled by the caller and can
- * reside on the stack. The caller must fill desc as follows: desc.tfm is filled
- * with the block cipher handle; desc.flags is filled with either
- * CRYPTO_TFM_REQ_MAY_SLEEP or 0.
- *
- * Return: 0 if the cipher operation was successful; < 0 if an error occurred
- */
-static inline int crypto_blkcipher_encrypt(struct blkcipher_desc *desc,
-					   struct scatterlist *dst,
-					   struct scatterlist *src,
-					   unsigned int nbytes)
-{
-	desc->info = crypto_blkcipher_crt(desc->tfm)->iv;
-	return crypto_blkcipher_crt(desc->tfm)->encrypt(desc, dst, src, nbytes);
-}
-
-/**
- * crypto_blkcipher_encrypt_iv() - encrypt plaintext with dedicated IV
- * @desc: reference to the block cipher handle with meta data
- * @dst: scatter/gather list that is filled by the cipher operation with the
- *	ciphertext
- * @src: scatter/gather list that holds the plaintext
- * @nbytes: number of bytes of the plaintext to encrypt.
- *
- * Encrypt plaintext data with the use of an IV that is solely used for this
- * cipher operation. Any previously set IV is not used.
- *
- * The blkcipher_desc data structure must be filled by the caller and can
- * reside on the stack. The caller must fill desc as follows: desc.tfm is filled
- * with the block cipher handle; desc.info is filled with the IV to be used for
- * the current operation; desc.flags is filled with either
- * CRYPTO_TFM_REQ_MAY_SLEEP or 0.
- *
- * Return: 0 if the cipher operation was successful; < 0 if an error occurred
- */
-static inline int crypto_blkcipher_encrypt_iv(struct blkcipher_desc *desc,
-					      struct scatterlist *dst,
-					      struct scatterlist *src,
-					      unsigned int nbytes)
-{
-	return crypto_blkcipher_crt(desc->tfm)->encrypt(desc, dst, src, nbytes);
-}
-
-/**
- * crypto_blkcipher_decrypt() - decrypt ciphertext
- * @desc: reference to the block cipher handle with meta data
- * @dst: scatter/gather list that is filled by the cipher operation with the
- *	plaintext
- * @src: scatter/gather list that holds the ciphertext
- * @nbytes: number of bytes of the ciphertext to decrypt.
- *
- * Decrypt ciphertext data using the IV set by the caller with a preceding
- * call of crypto_blkcipher_set_iv.
- *
- * The blkcipher_desc data structure must be filled by the caller as documented
- * for the crypto_blkcipher_encrypt call above.
- *
- * Return: 0 if the cipher operation was successful; < 0 if an error occurred
- *
- */
-static inline int crypto_blkcipher_decrypt(struct blkcipher_desc *desc,
-					   struct scatterlist *dst,
-					   struct scatterlist *src,
-					   unsigned int nbytes)
-{
-	desc->info = crypto_blkcipher_crt(desc->tfm)->iv;
-	return crypto_blkcipher_crt(desc->tfm)->decrypt(desc, dst, src, nbytes);
-}
-
-/**
- * crypto_blkcipher_decrypt_iv() - decrypt ciphertext with dedicated IV
- * @desc: reference to the block cipher handle with meta data
- * @dst: scatter/gather list that is filled by the cipher operation with the
- *	plaintext
- * @src: scatter/gather list that holds the ciphertext
- * @nbytes: number of bytes of the ciphertext to decrypt.
- *
- * Decrypt ciphertext data with the use of an IV that is solely used for this
- * cipher operation. Any previously set IV is not used.
- *
- * The blkcipher_desc data structure must be filled by the caller as documented
- * for the crypto_blkcipher_encrypt_iv call above.
- *
- * Return: 0 if the cipher operation was successful; < 0 if an error occurred
- */
-static inline int crypto_blkcipher_decrypt_iv(struct blkcipher_desc *desc,
-					      struct scatterlist *dst,
-					      struct scatterlist *src,
-					      unsigned int nbytes)
-{
-	return crypto_blkcipher_crt(desc->tfm)->decrypt(desc, dst, src, nbytes);
-}
-
-/**
- * crypto_blkcipher_set_iv() - set IV for cipher
- * @tfm: cipher handle
- * @src: buffer holding the IV
- * @len: length of the IV in bytes
- *
- * The caller provided IV is set for the block cipher referenced by the cipher
- * handle.
- */
-static inline void crypto_blkcipher_set_iv(struct crypto_blkcipher *tfm,
-					   const u8 *src, unsigned int len)
-{
-	memcpy(crypto_blkcipher_crt(tfm)->iv, src, len);
-}
-
-/**
- * crypto_blkcipher_get_iv() - obtain IV from cipher
- * @tfm: cipher handle
- * @dst: buffer filled with the IV
- * @len: length of the buffer dst
- *
- * The caller can obtain the IV set for the block cipher referenced by the
- * cipher handle and store it into the user-provided buffer. If the buffer
- * has an insufficient space, the IV is truncated to fit the buffer.
- */
-static inline void crypto_blkcipher_get_iv(struct crypto_blkcipher *tfm,
-					   u8 *dst, unsigned int len)
-{
-	memcpy(dst, crypto_blkcipher_crt(tfm)->iv, len);
-}
-
 /**
  * DOC: Single Block Cipher API
  *
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 32a378e7011f..4dae3ab8d030 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -626,8 +626,8 @@ static const struct xfrm_algo_list xfrm_aalg_list = {
 static const struct xfrm_algo_list xfrm_ealg_list = {
 	.algs = ealg_list,
 	.entries = ARRAY_SIZE(ealg_list),
-	.type = CRYPTO_ALG_TYPE_BLKCIPHER,
-	.mask = CRYPTO_ALG_TYPE_BLKCIPHER_MASK,
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+	.mask = CRYPTO_ALG_TYPE_MASK,
 };
 
 static const struct xfrm_algo_list xfrm_calg_list = {
-- 
2.23.0

