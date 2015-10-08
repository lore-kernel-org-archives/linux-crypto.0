From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/jitterentropy-kcapi: fix a comment reflecting
 function name changed
Date: Thu, 8 Oct 2015 21:28:44 +0800
Message-ID: <20151008132844.GA24600@gondor.apana.org.au>
References: <1444239494-8906-1-git-send-email-kuleshovmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444239494-8906-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 07, 2015 at 11:38:14PM +0600, Alexander Kuleshov wrote:
> The clocksource does not provide clocksource_register() function since
> f893598 commit (clocksource: Mostly kill clocksource_register()), but
> __clocksource_register() instead.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  crypto/jitterentropy-kcapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index ceea83d..4b030df 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -101,7 +101,7 @@ void jent_get_nstime(__u64 *out)
>  	 *
>  	 * The list of available timers can be obtained from
>  	 * /sys/devices/system/clocksource/clocksource0/available_clocksource
> -	 * and are registered with clocksource_register()
> +	 * and are registered with __clocksource_register()

Please get rid of the reference to clocksource_register altogether.
It's simply unnecessary.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
