Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A454BC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F74A2076E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHRIZl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:25:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42326 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHRIZl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:25:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k7ww6-0000eO-LC; Tue, 18 Aug 2020 18:25:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 18:25:38 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 18 Aug 2020 18:25:38 +1000
Subject: [PATCH 5/6] crypto: ahash - Remove AHASH_REQUEST_ON_STACK
References: <20200818082410.GA24497@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, Ben Greear <greearb@candelatech.com>
Message-Id: <E1k7ww6-0000eO-LC@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch removes AHASH_REQUEST_ON_STACK which is unused.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/hash.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index c9d3fd3efa1b0..f16f5d4afc102 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -59,11 +59,6 @@ struct ahash_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-#define AHASH_REQUEST_ON_STACK(name, ahash) \
-	char __##name##_desc[sizeof(struct ahash_request) + \
-		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
-	struct ahash_request *name = (void *)__##name##_desc
-
 /**
  * struct ahash_alg - asynchronous message digest definition
  * @init: **[mandatory]** Initialize the transformation context. Intended only to initialize the
