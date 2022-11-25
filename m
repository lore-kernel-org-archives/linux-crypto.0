Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0FEC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 04:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiKYEhT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 23:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiKYEg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 23:36:58 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC022613C;
        Thu, 24 Nov 2022 20:36:54 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyQS9-000dkR-IC; Fri, 25 Nov 2022 12:36:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 12:36:41 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 25 Nov 2022 12:36:41 +0800
Subject: [v2 PATCH 7/9] crypto: akcipher - Add ctx helpers with DMA alignment
References: <Y4BGC2BPesy3qsEm@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1oyQS9-000dkR-IC@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds helpers to access the akcipher context structure and
request context structure with an added alignment for DMA access.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/akcipher.h |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 1474a2d890fc..aaf1092b93b8 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -33,15 +33,37 @@ static inline void *akcipher_request_ctx(struct akcipher_request *req)
 	return req->__ctx;
 }
 
+static inline void *akcipher_request_ctx_dma(struct akcipher_request *req)
+{
+	unsigned int align = crypto_dma_align();
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+
+	return PTR_ALIGN(akcipher_request_ctx(req), align);
+}
+
 static inline void akcipher_set_reqsize(struct crypto_akcipher *akcipher,
 					unsigned int reqsize)
 {
 	akcipher->reqsize = reqsize;
 }
 
+static inline void akcipher_set_reqsize_dma(struct crypto_akcipher *akcipher,
+					    unsigned int reqsize)
+{
+	reqsize += crypto_dma_align() & ~(crypto_tfm_ctx_alignment() - 1);
+	akcipher->reqsize = reqsize;
+}
+
 static inline void *akcipher_tfm_ctx(struct crypto_akcipher *tfm)
 {
-	return tfm->base.__crt_ctx;
+	return crypto_tfm_ctx(&tfm->base);
+}
+
+static inline void *akcipher_tfm_ctx_dma(struct crypto_akcipher *tfm)
+{
+	return crypto_tfm_ctx_dma(&tfm->base);
 }
 
 static inline void akcipher_request_complete(struct akcipher_request *req,
