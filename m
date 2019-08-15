Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C5EC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 04:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674BB208C2
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 04:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfHOEy0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 00:54:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57012 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfHOEy0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 00:54:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hy7mJ-0004v7-SW; Thu, 15 Aug 2019 14:54:23 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hy7mH-0006S4-J2; Thu, 15 Aug 2019 14:54:21 +1000
Date:   Thu, 15 Aug 2019 14:54:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        horia.geanta@nxp.com
Subject: Re: [PATCH v4 06/30] crypto: caam/des - switch to new verification
 routines
Message-ID: <20190815045421.GA24765@gondor.apana.org.au>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805170037.31330-7-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 05, 2019 at 08:00:13PM +0300, Ard Biesheuvel wrote:
>
> @@ -644,14 +643,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
>  	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
>  		goto badkey;
>  
> -	flags = crypto_aead_get_flags(aead);
> -	err = __des3_verify_key(&flags, keys.enckey);
> -	if (unlikely(err)) {
> -		crypto_aead_set_flags(aead, flags);
> -		goto out;
> -	}
> -
> -	err = aead_setkey(aead, key, keylen);
> +	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
> +	      aead_setkey(aead, key, keylen);

Please don't use crypto_aead_tfm in new code (except in core crypto
API code).

You should instead provide separate helpers that are type-specific.
So crypto_aead_des3_ede_verify_key or verify_aead_des3_key to be
more succinct.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
