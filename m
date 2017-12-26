From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] hash import and request initialization
Date: Tue, 26 Dec 2017 21:40:10 +1100
Message-ID: <20171226104010.GA28275@gondor.apana.org.au>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au>
 <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48572 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdLZKkR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 05:40:17 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 26, 2017 at 11:06:02AM +0200, Gilad Ben-Yossef wrote:
>
> The hash state needs to be DMAed in and out of the hardware on each operation
> and I have no guarantee that the ahash request is allocated from DMAable memory
> (i.e. AHASH_REQUEST_ON_STACK).

AHASH_REQUEST_ON_STACK cannot possibly be used on an async ahash
implementation for obvious reasons so this shouldn't be an issue.

The construct is simply a compatibility aid for sync-only users
to use the ahash interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
