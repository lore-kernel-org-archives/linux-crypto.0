From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Tue, 17 Jan 2017 17:25:19 +0800
Message-ID: <20170117092519.GB31379@gondor.apana.org.au>
References: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170117091152.GA31379@gondor.apana.org.au>
 <CAKv+Gu_8dkkMUpd5FoNqXoPM-1LQcALWYxZ5c-Er9xWBFmMJgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55195 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750986AbdAQKAF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 05:00:05 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_8dkkMUpd5FoNqXoPM-1LQcALWYxZ5c-Er9xWBFmMJgQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 17, 2017 at 09:20:11AM +0000, Ard Biesheuvel wrote:
> 
> So to be clear, it is part of the API that after calling
> crypto_skcipher_encrypt(req), and completing the request, req->iv
> should contain a value that could potentially be used to encrypt
> additional data? That sounds highly specific to CBC (e.g., this could
> never work with XTS, since the tweak generation is only performed
> once), so it does not make sense for skciphers in general. For
> instance, drivers for h/w peripherals that never need to map the data
> to begin with (since they only pass the physical addresses to the
> hardware) will need to explicitly map the destination buffer to
> retrieve those bytes, on the off chance that the transform may be
> wrapped by CTS.

Yes this is part of the API.  There was a patch to test this in
testmgr but I wanted to give the drivers some more time before
adding it.

It isn't just CBC that uses chaining.  Other modes such as CTR
use it too.  Disk encryption in general don't chaining but that's
because they are sector-oriented.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
