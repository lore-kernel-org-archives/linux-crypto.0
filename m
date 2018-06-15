From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] hw_random: Always drop the RNG in hwrng_unregister()
Date: Fri, 15 Jun 2018 23:15:03 +0800
Message-ID: <20180615151503.ryml5ixzv66stwge@gondor.apana.org.au>
References: <20180614200811.76401d95@wiggum>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180614200811.76401d95@wiggum>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Michael Büsch <m@bues.ch> wrote:
> [-- text/plain, encoding quoted-printable, charset: UTF-8, 57 lines --]
> 
> enable_best_rng() is used in hwrng_unregister() to switch away from the
> currently active RNG, if that is the one currently being removed.
> However enable_best_rng() might fail, if the next RNG's init routine
> fails. In that case enable_best_rng() will return an error code and
> the currently active RNG will remain active.
> After unregistering this might lead to crashes due to use-after-free.
> 
> Fix this by dropping the currently active RNG, if enable_best_rng()
> failed. This will result in no RNG to be active, if the next-best
> one failed to initialize.
> 
> This problem was introduced by 142a27f0a731ddcf467546960a5585970ca98e21
> 
> 
> Reported-by: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
> Tested-by: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
> Signed-off-by: Michael Büsch <m@bues.ch>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
