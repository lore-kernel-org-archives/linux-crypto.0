From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Tue, 17 Jan 2017 17:11:52 +0800
Message-ID: <20170117091152.GA31379@gondor.apana.org.au>
References: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37543 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751263AbdAQJaA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 04:30:00 -0500
Content-Disposition: inline
In-Reply-To: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 16, 2017 at 09:16:35AM +0000, Ard Biesheuvel wrote:
> Since the skcipher conversion in commit 0605c41cc53c ("crypto:
> cts - Convert to skcipher"), the cts code tacitly assumes that
> the underlying CBC encryption transform performed on the first
> part of the plaintext returns an IV in req->iv that is suitable
> for encrypting the final bit.
> 
> While this is usually the case, it is not mandated by the API, and
> given that the CTS code already accesses the ciphertext scatterlist
> to retrieve those bytes, we can simply copy them into req->iv before
> proceeding.

Ugh while there are some legacy drivers that break this is certainly
part of the API.

Which underlying CBC implementation is breaking this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
