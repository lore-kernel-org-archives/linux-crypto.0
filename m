From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour
 iv_out
Date: Thu, 2 Feb 2017 13:13:00 +0800
Message-ID: <20170202051300.GA4349@gondor.apana.org.au>
References: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55253 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750953AbdBBGAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 01:00:04 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 01, 2017 at 08:08:09PM +0000, Ard Biesheuvel wrote:
>
> Could you please forward this patch to Linus as well? I noticed that the patch

Sure, I will do that.

> crypto: arm64/aes-blk - honour iv_out requirement in CBC and CTR modes
> 
> is now in mainline, which means CCM is now broken on arm64, given that
> the iv_out requirement for CTR apparently isn't honored by *any*
> implementation, and CCM wrongly assumes that req->iv retains its value
> across the call into the CTR skcipher

Hmm, I wonder why we don't see this breakage with the generic
CTR as it seems to do exactly the same thing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
