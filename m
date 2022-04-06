Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2232C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiDFRE0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbiDFREI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BF6492195
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B021FB82150
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7B8C385A9;
        Wed,  6 Apr 2022 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255253;
        bh=4K3objhwHke48/stAu+jR0uE0LleMrqJu8VpcnmUwDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKfT19dwOKTznejE5mrWvfeorGDu9+omoG9zaWfDph4Q2q4LqAGz+d7K0ZqbtvCSG
         aXZBECEuOZ3scjRhjc9IzkK4Jta4NRbkt0bbcSZnwe0mDdU1C4KC8YRSPKx2JjTY++
         7cm5Qi00tw4QJ4bO6w8SIyXrB3ttueKpf53I8bkxA1nZbEr/2TiZE/mKDl0lBzWebB
         OmSat4ahyS2dNZtonCwxXbIlepQ+Wui6timlQlG+4sLfIi5pCNJ8SqthGb3tWzADwi
         U8eKZa6miJ8w5On7aBYxjTBSR3gW/HNCibbGsc6KLQaJqjIxTkh411MyrWvVa8E2uk
         DE7b09nheRyJw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6/8] crypto: aead - avoid DMA alignment for request structures unless needed
Date:   Wed,  6 Apr 2022 16:27:13 +0200
Message-Id: <20220406142715.2270256-7-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2249; h=from:subject; bh=4K3objhwHke48/stAu+jR0uE0LleMrqJu8VpcnmUwDY=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM/dC+N4PPi+vi4b7e7+6Gh2l1Z37L4kNAng/t1 OJqe/EuJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jPwAKCRDDTyI5ktmPJA6HDA CEKWh74dkKwMxoxxLSYYpR13E1WvYen82nEjUQQVkeePQux5188XsAvy3CbrWlGA5eHm/kUgHx7BsE iKPa3QBuHOOUDXiBZvmEjcDMGPEXNq9kFkKFNAyJHhYmn3CbmXSXsTeJnIJ+L82O34qyPX0wdBv0gl 7hxBwdizu7jZ9sCaQXKG0kPUt/ejnVTJRza2gLOV1vjTszLSrzY/4WMCexFw3n1Gyc5c0k60qEEOld 3ef8uJyOnCcW+pEr+/1U2357ABIdgc42PyinKH6APuXVIUjkMRcFvSQ+cr0jSAlVFkf1PbptyJYbbs 7dzRqWkb4KgRQv1d26R5zFvbHNEbpclWOnDisROPik7sEDjL7sR7uSM+W0cABnra5bWdgFGAP3EHLZ lVw2wZR0JFU3CRYgopH1wQLfQ/lVsFpUzf+OXiKDcU3kC2UwmS1AmRdlNbdHCB0Xjquce4h15kDHay jdpoPLkfXxJyBcPdHddCIFbTF7dE7dNSDXNVCGje04/mE=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AEAD request structures are currently aligned to minimal DMA alignment
for the arcitecture, which defaults to 128 bytes on arm64. This is
excessive, and rarely needed, i.e., only when doing non-coherent inbound
DMA on the contents of the request context buffer. So let's relax this
requirement, and only use this alignment if the
CRYPTO_ALG_NEED_DMA_ALIGNMENT flag is set by the implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/aead.h          |  2 +-
 include/crypto/internal/aead.h | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 14db3bee0519..3a09f540c38a 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -97,7 +97,7 @@ struct aead_request {
 	struct scatterlist *src;
 	struct scatterlist *dst;
 
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+	void *__ctx[] CRYPTO_REQ_MINALIGN_ATTR;
 };
 
 /**
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 27b7b0224ea6..b30bc33a0c75 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -62,7 +62,8 @@ static inline void *aead_instance_ctx(struct aead_instance *inst)
 
 static inline void *aead_request_ctx(struct aead_request *req)
 {
-	return req->__ctx;
+	return PTR_ALIGN(&req->__ctx,
+			 crypto_tfm_alg_req_alignmask(req->base.tfm) + 1);
 }
 
 static inline void aead_request_complete(struct aead_request *req, int err)
@@ -105,7 +106,15 @@ static inline struct crypto_aead *crypto_spawn_aead(
 static inline void crypto_aead_set_reqsize(struct crypto_aead *aead,
 					   unsigned int reqsize)
 {
-	aead->reqsize = reqsize;
+	unsigned int align = crypto_tfm_alg_req_alignmask(&aead->base) + 1;
+
+	/*
+	 * The request structure itself is only aligned to CRYPTO_REQ_MINALIGN,
+	 * so we need to add some headroom, allowing us to return a suitably
+	 * aligned context buffer pointer. We also need to round up the size so
+	 * we don't end up sharing a cacheline at the end of the buffer.
+	 */
+	aead->reqsize = ALIGN(reqsize, align) + align - CRYPTO_REQ_MINALIGN;
 }
 
 static inline void aead_init_queue(struct aead_queue *queue,
-- 
2.30.2

