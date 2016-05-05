From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Thu, 5 May 2016 17:50:20 +0800
Message-ID: <20160505095020.GA5473@gondor.apana.org.au>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
 <20160504040731.GA25758@gondor.apana.org.au>
 <CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
 <20160505084249.GA4971@gondor.apana.org.au>
 <CADxRZqwxB-+DTV-qKFK6CVXwVV0h9yDkH6GxcjmA-M9KY2HM7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADxRZqwxB-+DTV-qKFK6CVXwVV0h9yDkH6GxcjmA-M9KY2HM7g@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 05, 2016 at 12:40:18PM +0300, Anatoly Pugachev wrote:
> 
> sure, based on your cryptodev git, just tried 4.3 (6a13feb , good)
> kernel in attempt to find (bisect) when RSA code break, already tested
> 4.5 (44d1b6d , bad) , 4.4 (afd2ff9 , bad).
> Going to try your patch soon (when I'm back home).
> So far 4.3 passes RSA stage without OOPS, but for other reason does
> not boot to login prompt. Boot log exempt (4.3), this is with
> CONFIG_CRYPTO_RSA=y :

That jibes with this being a problem with the SG list since it
was only added in 4.4.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
