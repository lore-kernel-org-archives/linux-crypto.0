From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Wed, 28 Dec 2016 17:10:20 +0800
Message-ID: <20161228091020.GE11904@gondor.apana.org.au>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161227085745.GA10121@gondor.apana.org.au>
 <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56391 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751103AbcL1JKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:10:40 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 27, 2016 at 06:35:46PM +0000, Ard Biesheuvel wrote:
>
> OK, I will try to hack something up.
> 
> One thing to keep in mind though is that stacked chaining modes should
> present the data with the same granularity for optimal performance.
> E.g., xts(ecb(aes)) should pass 8 blocks at a time. How should this
> requirement be incorporated according to you?

xts tries to do a page at a time, which should be good enough, no?

In general this parameter should be visible to internal API users
such as xts so they could use it to determine how it wants to
structure its walks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
