Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A49C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 09:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiKVJYM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiKVJYH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 04:24:07 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFDD49B52
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 01:24:04 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxPVZ-00H2dC-6m; Tue, 22 Nov 2022 17:24:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 17:24:01 +0800
Date:   Tue, 22 Nov 2022 17:24:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: kpp - Add helper to set reqsize
Message-ID: <Y3yVMSUxJa/omeY5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize should only be changed through a helper.
To do so we need to first add a helper for this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/internal/kpp.h b/include/crypto/internal/kpp.h
index 9cb0662ebe87..31ff3c1986ef 100644
--- a/include/crypto/internal/kpp.h
+++ b/include/crypto/internal/kpp.h
@@ -50,6 +50,12 @@ static inline void *kpp_request_ctx(struct kpp_request *req)
 	return req->__ctx;
 }
 
+static inline void kpp_set_reqsize(struct crypto_kpp *kpp,
+				   unsigned int reqsize)
+{
+	crypto_kpp_alg(kpp)->reqsize = reqsize;
+}
+
 static inline void *kpp_tfm_ctx(struct crypto_kpp *tfm)
 {
 	return tfm->base.__crt_ctx;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
