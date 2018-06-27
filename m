From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 10:38:53 +0530
Message-ID: <20180627050853.GE22377@vkoul-mobl>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
 <6782b1c0-ea94-b07c-2fae-3fe3223bb22a@linaro.org>
 <20180622143829.rd2ys6ci7q3aupst@gondor.apana.org.au>
 <20180622144809.GP27187@vkoul-mobl>
 <20180622145047.dqyxwptttivaca2s@gondor.apana.org.au>
 <70ED61EB-BD3E-48D1-8B4D-D7835494C035@chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ED61EB-BD3E-48D1-8B4D-D7835494C035@chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 22-06-18, 19:57, Stephan Mueller wrote:
> Hi
> 
> 
> > Am 22.06.2018 um 16:50 schrieb Herbert Xu <herbert@gondor.apana.org.au>:
> > 
> >> On Fri, Jun 22, 2018 at 08:18:09PM +0530, Vinod wrote:
> >> 
> >> Okay I am doing the port taking the exynos-rng as a ref.
> >> Question is how to test it, how is one supposed to exercise the rng, any
> >> test utils/apps for that? Sorry for noob question, new to crypto
> >> interfaces.
> > 
> > algif_rng is available through the af_alg socket interface.
> > 
> You can use the libkcapi library at http://www.chronox.de/libkcapi.html
> 
> The RNG API is documented at http://chronox.de/libkcapi/html/ch03s15.html and http://chronox.de/libkcapi/html/ch03s16.html
> 
> A command line app is also present with kcapi-rng as documented at https://github.com/smuellerDD/libkcapi/blob/master/README.md

Thanks for the pointers, it helped me to test the driver :)

I have two follow up question on crypto:

 - If there a way to avoid using a global variable in driver to hold the
   pointer for driver memory? Looks like exynos driver does that.

   I understand that the crypto callback don't provide driver context as
   they copy the data structures passed in registration API, but a simpler
   way to get driver context would be desirable.

 - .seed seems to be mandatory, if I do not set it and even use
   .seedsize = 0, it panics at crypto_rng_reset(). So is .seed
   mandatory?

Thanks
-- 
~Vinod
