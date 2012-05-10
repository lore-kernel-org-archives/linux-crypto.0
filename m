From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CRYPTO_ALG_ASYNC
Date: Thu, 10 May 2012 20:47:36 +1000
Message-ID: <20120510104736.GA21213@gondor.apana.org.au>
References: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
 <20120510101611.GA21025@gondor.apana.org.au>
 <CALLzPKZWvFvPeA2ZKkRBPKA9WK7oDtzymDmG4Y-u=pmq8khXNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:36488 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918Ab2EJKri (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 06:47:38 -0400
Content-Disposition: inline
In-Reply-To: <CALLzPKZWvFvPeA2ZKkRBPKA9WK7oDtzymDmG4Y-u=pmq8khXNA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 01:31:10PM +0300, Kasatkin, Dmitry wrote:
>
> But why do we need it for AHASH or ABLKCIPHER?
> It is obvious without it that they can be async?

It makes sense for ahash/ablkcipher since even though you're
using the async API you can still request for a sync implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
