Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2189FC43441
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 09:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E196F20827
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 09:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E196F20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbeKITYi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:24:38 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:37268 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKITYi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:24:38 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gL3LP-0001zQ-1a; Fri, 09 Nov 2018 17:44:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gL3LL-0005ds-DZ; Fri, 09 Nov 2018 17:44:47 +0800
Date:   Fri, 9 Nov 2018 17:44:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Qian Cai <cai@gmx.us>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
Message-ID: <20181109094447.v4fqirpmx7owayr7@gondor.apana.org.au>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181109094447.YahkDYBEFTJYuPQ6FOJ1xMEoLXAKhBbS_wuD5LHwx-s@z>

On Fri, Nov 09, 2018 at 12:33:23AM +0100, Ard Biesheuvel wrote:
>
> This should be
> 
> reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
>        crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
> 
> since the cryptd path in simd still needs some space in the subreq for
> the completion.

OK this is what I applied to the cryptodev tree, please double-check
to see if I did anything silly:

diff --git a/crypto/simd.c b/crypto/simd.c
index ea7240be3001..78e8d037ae2b 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -124,8 +124,9 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 
 	ctx->cryptd_tfm = cryptd_tfm;
 
-	reqsize = sizeof(struct skcipher_request);
-	reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
+	reqsize = crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
+	reqsize = max(reqsize, crypto_skcipher_reqsize(&cryptd_tfm->base));
+	reqsize += sizeof(struct skcipher_request);
 
 	crypto_skcipher_set_reqsize(tfm, reqsize);
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
