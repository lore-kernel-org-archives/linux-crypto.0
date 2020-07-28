Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F62BC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00576207F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgG1HTl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54924 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jti-0006Vi-Dx; Tue, 28 Jul 2020 17:19:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:38 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:38 +1000
Subject: [v3 PATCH 26/31] crypto: essiv - Set final_chunksize
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jti-0006Vi-Dx@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The essiv template does not support partial operation and therefore
this patch sets its final_chunksize to -1 to mark this fact.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/essiv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index d012be23d496d..dd19cfefe559c 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -580,6 +580,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		skcipher_inst->alg.ivsize	= ivsize;
 		skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
 		skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
+		skcipher_inst->alg.final_chunksize = -1;
 
 		skcipher_inst->free		= essiv_skcipher_free_instance;
 
