Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAF7C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiDFREh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbiDFREI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831A44922DD
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33E0EB82252
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBD2C385A3;
        Wed,  6 Apr 2022 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255255;
        bh=2KqtO9ZfcftXFWtkQBPByUGxg2nETlz9BoiAzSQJ1ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHnZLKLo2GPUS6hSNJxWr7vy/wP0YLs8Xnm8yu7ADdxhclIS2HERLU2IP37UUI9HK
         IdQ5lsp2fz32lY/eKlXsM84nWp4PXqzsd2yTNL0VunagYvLgASWKDp02s2eoLgK5Fe
         XzVq12IUTyhCFnZYSgnPp7Y5zIyNIdOfL2qoNy8Q1HKG5Yfpn9o93gWVJbatF2yuOD
         D9kFDdrqLOQxMaVjciuPy79qbGMRI3HGI1Smgb5W++w9Nmu3FfLhKD9F0cXC4IzifE
         vJA/4xkxSbVE+s7ibOuspB8LohhbIpOKJjQwkeYk8Mui/VTkf/ZF3ZIF0+eAp0ZSFw
         gevw6HfwC43iw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7/8] crypto: ahash - avoid DMA alignment for request structures unless needed
Date:   Wed,  6 Apr 2022 16:27:14 +0200
Message-Id: <20220406142715.2270256-8-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2242; h=from:subject; bh=2KqtO9ZfcftXFWtkQBPByUGxg2nETlz9BoiAzSQJ1ME=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaNB72ErJCPBXR93LPKYLwjlp6ikb8R1gricj8QN pddACUKJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jQQAKCRDDTyI5ktmPJG4LC/ 9PG+G5I2qS0lZXHGekRj+aM6VF0dxtRpAQy9j1pPcsqHPvzL9vwmLtXVzdKsN6rVGEXstYXRfmgN4k YuFYnP+AOI4uB+UQhY0F2QTEa24tgCS6Mrhbq7YJV2YYiXqS+/l1EBPcnAXSTUwA2Y83ye8Op13vEU lheuUxBSm1YXEAefwCOMv/851XyvsC/bbBdb6sSFqWrLcOv+cRpxJepn5iTKRLylofdp+NFwb1G4Qe QSkplhp96RCvRGLVtNHDfoC5yP+J2K0e8QkM8Vzwx6aw14wxei3gNkt7PK76VHWCYqngr1DVfCfCKe 8ObeFswbCnX8oI2Vi3LKgEmEKJMHhuV4uLatrxnMJNDB6rAFHMmcLlmOJHpOEVICRJxviAOR7/NgbZ ohYO2pdrmaIcFPdITREL4RsHXF2I0zDt25PUBXk6XPEBp4Zi2ftE9Lsd/pvcIcXQdMo6ssVBrCs0q5 6HArpnv4mQ3ogHxpkATDHfnhoQc6icHSfmDVn69gJoXEc=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AHASH request structures are currently aligned to minimal DMA alignment
for the arcitecture, which defaults to 128 bytes on arm64. This is
excessive, and rarely needed, i.e., only when doing non-coherent inbound
DMA on the contents of the request context buffer. So let's relax this
requirement, and only use this alignment if the
CRYPTO_ALG_NEED_DMA_ALIGNMENT flag is set by the implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/hash.h          |  5 +++--
 include/crypto/internal/hash.h | 10 +++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f140e4643949..cd16c37c38af 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -56,7 +56,7 @@ struct ahash_request {
 	/* This field may only be used by the ahash API code. */
 	void *priv;
 
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+	void *__ctx[] CRYPTO_REQ_MINALIGN_ATTR;
 };
 
 /**
@@ -417,7 +417,8 @@ static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 
 static inline void *ahash_request_ctx(struct ahash_request *req)
 {
-	return req->__ctx;
+	return PTR_ALIGN(&req->__ctx,
+			 crypto_tfm_alg_req_alignmask(req->base.tfm) + 1);
 }
 
 /**
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 25806141db59..222c2df009c6 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -143,7 +143,15 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
 static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 					    unsigned int reqsize)
 {
-	tfm->reqsize = reqsize;
+	unsigned int align = crypto_tfm_alg_req_alignmask(crypto_ahash_tfm(tfm)) + 1;
+
+	/*
+	 * The request structure itself is only aligned to CRYPTO_REQ_MINALIGN,
+	 * so we need to add some headroom, allowing us to return a suitably
+	 * aligned context buffer pointer. We also need to round up the size so
+	 * we don't end up sharing a cacheline at the end of the buffer.
+	 */
+	tfm->reqsize = ALIGN(reqsize, align) + align - CRYPTO_REQ_MINALIGN;
 }
 
 static inline struct crypto_instance *ahash_crypto_instance(
-- 
2.30.2

