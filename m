Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37278 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbeKITZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:25:13 -0500
Date: Fri, 9 Nov 2018 17:45:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Qian Cai <cai@gmx.us>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
Message-ID: <20181109094525.3shpcmj4uqxfx33z@gondor.apana.org.au>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
 <20181109094447.v4fqirpmx7owayr7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109094447.v4fqirpmx7owayr7@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 09, 2018 at 05:44:47PM +0800, Herbert Xu wrote:
> On Fri, Nov 09, 2018 at 12:33:23AM +0100, Ard Biesheuvel wrote:
> >
> > This should be
> > 
> > reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
> >        crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
> > 
> > since the cryptd path in simd still needs some space in the subreq for
> > the completion.
> 
> OK this is what I applied to the cryptodev tree, please double-check
> to see if I did anything silly:

I meant the crypto tree rather than cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
