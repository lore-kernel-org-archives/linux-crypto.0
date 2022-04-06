Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DADC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbiDFRET (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbiDFREE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1926621B401
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A99E9619C6
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1D6C385A1;
        Wed,  6 Apr 2022 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255252;
        bh=V1OGQRWPJCynj5h8j4wCI0ybdc6a65Wa0Adc7dB0pVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjDP+ud+i4GVZS6NJMLYVC+qrz9uTFOyJNDGrvDhBWWMajlc1kxbvWUF7mz0hav2d
         UcNT64gUZHxERKHXdrfgKRewm9lqGQaCRfx+6NdcAWrroeCuCTtx9LeL4Sj69oQVvS
         8iFoH4mlR3jpfQ9FeyRtOXoN/35b+ZbelMDDOlr6n7WmAYCObwCHzIs+u8e+mP6wUw
         xNJcQ2VaLtSE0wJmDyrIm/nuzWDmq6usmyoUAPRgrbehSYlSPuPBmMh5TjV48ZIMSA
         IOXQD8UsDussf/5iifozwfGglYaBnJSUlfoPH5dLKAPekrGe4OdO63jVTm1iZTWHWg
         xITGxhwhO81yg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5/8] crypto: skcipher - avoid rounding up request size to DMA alignment
Date:   Wed,  6 Apr 2022 16:27:12 +0200
Message-Id: <20220406142715.2270256-6-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4551; h=from:subject; bh=V1OGQRWPJCynj5h8j4wCI0ybdc6a65Wa0Adc7dB0pVE=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM+UAt+fDCU+OMaO68KlC4Is4cqdKAyuDnN+wIK 5l5rxveJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jPgAKCRDDTyI5ktmPJGbgC/ sFr0+Hu24R+LgZJTFqaiJf8+vk+/bHqn7Wlqb8FD/ooWGd8c3LOPz/vf4UJFBbXLGMOCxaNfingM35 qhPheDcsqGbHwYccCikOc6nOVk5K4UBTm/sHGFldPYONW2Q7L/2DoHauJ2S9KRvTvLfNttWOc2ZAYg c7eJC/t6yKj3w9wi7eHwhTP9/zwnwjLTC97Tfe5t9yZoJ19GDsfnxcWLN/QMI3FdYJLpyJ4lqyJpBe 0hFmshfe9WvU2bW6PZaqQXNv3K6wLsyTpv9mR5Ay/ouL01peH6hLMH1/VZ55R0YxJAx+MM/W0494WC DlMkduqotOmLmA0Lcaeu991jXEaTznburiEzhd6uUEBKNRXYs/rkZQRtjarW+QmSLvxi4v/4QnBE0D PceSyZsISgn2CpWV0O/zGac0xAdCltm9gw6fvg9zZSoZ4EskxoMNdWKVimEEAgVJ88QHWuY76uG44F bmvdHA+2rvwNmCstmyBGzjAtspMZGyMdpIOz3j33olOHk=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that algo implementations that require it will set the new
CRYPTO_ALG_NEED_DMA_ALIGNMENT flag, we can reduce the static footprint
of the skcipher request structure, and increase the request context size
to include the headroom needed for DMA alignment, but only when it is
actually needed.

On arm64, this (and reordering the 'base' field) reduces the size of the
skcipher request structure from 128 bytes to 72 bytes. It also reduces
the minimum alignment of the struct type, which is relevant because the
SYNC_SKCIPHER_ON_STACK() macro places such a struct on the stack, and
here, the alignment requirement increases the memory footprint
substantially, given that the stack pointer can only be assumed to be
aligned to 16 bytes, as per the AArch64 ABI.

Since DMA to the stack is never allowed, we can ignore the flag here,
and simply align the whole allocation to CRYPTO_REQ_MINALIGN.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/internal/skcipher.h | 13 +++++++++++--
 include/crypto/skcipher.h          |  8 ++++----
 include/linux/crypto.h             | 14 ++++++++++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a2339f80a615..8c825bef2b43 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -119,7 +119,15 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
 static inline void crypto_skcipher_set_reqsize(
 	struct crypto_skcipher *skcipher, unsigned int reqsize)
 {
-	skcipher->reqsize = reqsize;
+	unsigned int align = crypto_tfm_alg_req_alignmask(&skcipher->base) + 1;
+
+	/*
+	 * The request structure itself is only aligned to CRYPTO_REQ_MINALIGN,
+	 * so we need to add some headroom, allowing us to return a suitably
+	 * aligned context buffer pointer. We also need to round up the size so
+	 * we don't end up sharing a cacheline at the end of the buffer.
+	 */
+	skcipher->reqsize = ALIGN(reqsize, align) + align - CRYPTO_REQ_MINALIGN;
 }
 
 int crypto_register_skcipher(struct skcipher_alg *alg);
@@ -153,7 +161,8 @@ static inline void *crypto_skcipher_ctx(struct crypto_skcipher *tfm)
 
 static inline void *skcipher_request_ctx(struct skcipher_request *req)
 {
-	return req->__ctx;
+	return PTR_ALIGN(&req->__ctx,
+			 crypto_tfm_alg_req_alignmask(req->base.tfm) + 1);
 }
 
 static inline u32 skcipher_request_flags(struct skcipher_request *req)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 39f5b67c3069..0b477878f100 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -26,6 +26,8 @@ struct scatterlist;
  *	@__ctx: Start of private context data
  */
 struct skcipher_request {
+	struct crypto_async_request base;
+
 	unsigned int cryptlen;
 
 	u8 *iv;
@@ -33,9 +35,7 @@ struct skcipher_request {
 	struct scatterlist *src;
 	struct scatterlist *dst;
 
-	struct crypto_async_request base;
-
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+	void *__ctx[] CRYPTO_REQ_MINALIGN_ATTR;
 };
 
 struct crypto_skcipher {
@@ -132,7 +132,7 @@ struct skcipher_alg {
 			     MAX_SYNC_SKCIPHER_REQSIZE + \
 			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
 				       (typeof(tfm))1))) \
-			    ] CRYPTO_MINALIGN_ATTR; \
+			    ] CRYPTO_REQ_MINALIGN_ATTR;\
 	struct skcipher_request *name = (void *)__##name##_desc
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f2e95fb6cedb..d02a112914c3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -178,6 +178,10 @@
 
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
 
+/* minimum alignment for request structures */
+#define CRYPTO_REQ_MINALIGN ARCH_SLAB_MINALIGN
+#define CRYPTO_REQ_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_REQ_MINALIGN)))
+
 struct scatterlist;
 struct crypto_async_request;
 struct crypto_tfm;
@@ -706,6 +710,16 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_alignmask;
 }
 
+static inline unsigned int crypto_tfm_alg_req_alignmask(struct crypto_tfm *tfm)
+{
+#ifdef ARCH_DMA_MINALIGN
+	if (ARCH_DMA_MINALIGN > CRYPTO_REQ_MINALIGN &&
+	    (tfm->__crt_alg->cra_flags & CRYPTO_ALG_NEED_DMA_ALIGNMENT))
+		return ARCH_DMA_MINALIGN - 1;
+#endif
+	return CRYPTO_REQ_MINALIGN - 1;
+}
+
 static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
 {
 	return tfm->crt_flags;
-- 
2.30.2

