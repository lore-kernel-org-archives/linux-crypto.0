From: Harald Freudenberger <freude-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] hw_random: Always drop the RNG in hwrng_unregister()
Date: Fri, 15 Jun 2018 10:08:12 +0200
Message-ID: <8f1f5be1-979c-7601-1419-907b1980d974@linux.ibm.com>
References: <20180614200811.76401d95@wiggum>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180614200811.76401d95@wiggum>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 14.06.2018 20:08, Michael Büsch wrote:
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
>
> ---
>
> See this discussion for a crash in b43's hwrng caused by this problem:
> https://www.spinics.net/lists/linux-wireless/msg173089.html
>
>
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 91bb98c42a1c..aaf9e5afaad4 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
>  
>  void hwrng_unregister(struct hwrng *rng)
>  {
> +	int err;
> +
>  	mutex_lock(&rng_mutex);
>  
>  	list_del(&rng->list);
> -	if (current_rng == rng)
> -		enable_best_rng();
> +	if (current_rng == rng) {
> +		err = enable_best_rng();
> +		if (err) {
> +			drop_current_rng();
> +			cur_rng_set_by_user = 0;
> +		}
> +	}
>  
>  	if (list_empty(&rng_list)) {
>  		mutex_unlock(&rng_mutex);
>
>
>
Yes, if the hw_init() of the newly chosen rng fails, enable_best_rng() comes
back with an error and did not drop the current rng. The patch handles
this case. I did not test it, but the code looks fine.

reviewed-by Harald Freudenberger <freude-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
