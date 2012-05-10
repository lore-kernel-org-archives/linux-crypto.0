From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: CRYPTO_ALG_ASYNC
Date: Thu, 10 May 2012 13:52:00 +0300
Message-ID: <CALLzPKaWQsC0ZqYvoF5gvV8JPkqs-GXcgGTwBd2-RppewZRC_Q@mail.gmail.com>
References: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
	<20120510101611.GA21025@gondor.apana.org.au>
	<CALLzPKZWvFvPeA2ZKkRBPKA9WK7oDtzymDmG4Y-u=pmq8khXNA@mail.gmail.com>
	<20120510104736.GA21213@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2EJKwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 06:52:01 -0400
Received: by dano14 with SMTP id o14so5358824dan.25
        for <linux-crypto@vger.kernel.org>; Thu, 10 May 2012 03:52:00 -0700 (PDT)
In-Reply-To: <20120510104736.GA21213@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 1:47 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, May 10, 2012 at 01:31:10PM +0300, Kasatkin, Dmitry wrote:
>>
>> But why do we need it for AHASH or ABLKCIPHER?
>> It is obvious without it that they can be async?
>
> It makes sense for ahash/ablkcipher since even though you're
> using the async API you can still request for a sync implementation.

What I can see this flag is not tested and used.
Where is the place of code where it "returns" sync implementation?

- Dmitry

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
