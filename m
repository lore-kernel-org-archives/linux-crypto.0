Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A2BC001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjJVISq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVISp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C4BCF
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D422EC433C8
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962723;
        bh=fC5Fbz/RMupgQR+58ceTkl4xxSa+14LSQNn2gb5StbY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kwHzG6nD1ikQTT65zYH75jdGRwuXfaVKHx+8D0OrYlsOH4LcxuCR+qw5zQCqd4xt0
         Z9+vSZ6+QRspXi5TKiXCpLFge0cZDN5OFgSfSVLkTGv2raDN+Y+ZqwjFBPghD1ugDF
         5F81+m6V4bl3TbD41BzgNewJmi6DAvvwTl+rJhCY0+M+RKrOnh0Jb80f9WIUThXAC6
         rZDxfQaDEBo7yDK0wwQrNhKlNXXFdLLW5HHGiwzrdLv3l6EAmUEXjt83fM+zfRgmfu
         swNViDI2VZ+GlupyMhWVttxX7FjpF2wIkQZAdjvLugs4Ku22rhJz3QMpY2a/oibpRJ
         TKizL/6HvdunA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 01/30] crypto: shash - remove crypto_shash_ctx_aligned()
Date:   Sun, 22 Oct 2023 01:10:31 -0700
Message-ID: <20231022081100.123613-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_shash_ctx_aligned() is no longer used, and it is useless now that
shash algorithms don't support nonzero alignmasks, so remove it.

Also remove crypto_tfm_ctx_aligned() which was only called by
crypto_shash_ctx_aligned().  It's unlikely to be useful again, since it
seems inappropriate to use cra_alignmask to represent alignment for the
tfm context when it already means alignment for inputs/outputs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/algapi.h        | 5 -----
 include/crypto/internal/hash.h | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index ca86f4c6ba439..7a4a71af653fa 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -188,25 +188,20 @@ static inline void *crypto_tfm_ctx(struct crypto_tfm *tfm)
 
 static inline void *crypto_tfm_ctx_align(struct crypto_tfm *tfm,
 					 unsigned int align)
 {
 	if (align <= crypto_tfm_ctx_alignment())
 		align = 1;
 
 	return PTR_ALIGN(crypto_tfm_ctx(tfm), align);
 }
 
-static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
-{
-	return crypto_tfm_ctx_align(tfm, crypto_tfm_alg_alignmask(tfm) + 1);
-}
-
 static inline unsigned int crypto_dma_align(void)
 {
 	return CRYPTO_DMA_ALIGN;
 }
 
 static inline unsigned int crypto_dma_padding(void)
 {
 	return (crypto_dma_align() - 1) & ~(crypto_tfm_ctx_alignment() - 1);
 }
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index cf65676e45f4d..8d0cd0c591a09 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -262,22 +262,17 @@ static inline void *shash_instance_ctx(struct shash_instance *inst)
 {
 	return crypto_instance_ctx(shash_crypto_instance(inst));
 }
 
 static inline struct crypto_shash *crypto_spawn_shash(
 	struct crypto_shash_spawn *spawn)
 {
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-static inline void *crypto_shash_ctx_aligned(struct crypto_shash *tfm)
-{
-	return crypto_tfm_ctx_aligned(&tfm->base);
-}
-
 static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_shash, base);
 }
 
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.42.0

