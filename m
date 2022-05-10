Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E041C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 10 May 2022 11:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiEJLLg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 May 2022 07:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiEJLL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 May 2022 07:11:29 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15196106365;
        Tue, 10 May 2022 04:07:31 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1noNhy-00BzVR-Si; Tue, 10 May 2022 21:07:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 May 2022 19:07:15 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 10 May 2022 19:07:15 +0800
Subject: [RFC PATCH 4/7] crypto: hash - Add ctx helpers with DMA alignment
References: <YnpGnsr4k7yVUR54@gondor.apana.org.au>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1noNhy-00BzVR-Si@fornost.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds helpers to access the ahash context structure and
request context structure with an added alignment for DMA access.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 25806141db591..f635a61fd1a0e 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -134,6 +134,11 @@ static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 	return crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 }
 
+static inline void *crypto_ahash_ctx_dma(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_ctx_dma(crypto_ahash_tfm(tfm));
+}
+
 static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
 {
 	return container_of(__crypto_hash_alg_common(alg), struct ahash_alg,
@@ -146,6 +151,15 @@ static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 	tfm->reqsize = reqsize;
 }
 
+static inline void crypto_ahash_set_reqsize_dma(struct crypto_ahash *ahash,
+						unsigned int reqsize)
+{
+#ifdef ARCH_DMA_MINALIGN
+	reqsize += ARCH_DMA_MINALIGN & ~(crypto_tfm_ctx_alignment() - 1);
+#endif
+	ahash->reqsize = reqsize;
+}
+
 static inline struct crypto_instance *ahash_crypto_instance(
 	struct ahash_instance *inst)
 {
@@ -169,6 +183,20 @@ static inline void *ahash_instance_ctx(struct ahash_instance *inst)
 	return crypto_instance_ctx(ahash_crypto_instance(inst));
 }
 
+static inline void *ahash_request_ctx_dma(struct ahash_request *req)
+{
+	unsigned int align = 1;
+
+#ifdef ARCH_DMA_MINALIGN
+	align = ARCH_DMA_MINALIGN;
+#endif
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+
+	return PTR_ALIGN(ahash_request_ctx(req), align);
+}
+
 static inline void ahash_request_complete(struct ahash_request *req, int err)
 {
 	req->base.complete(&req->base, err);
