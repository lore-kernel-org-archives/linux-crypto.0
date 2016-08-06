From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC][PATCH] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Sat, 6 Aug 2016 19:45:51 +0000
Message-ID: <20160806194551.GA4511@io.lakedaemon.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34197429.2CvoIfft9B@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On Fri, Aug 05, 2016 at 05:08:14PM +0200, Stephan Mueller wrote:
> Hi Ted, Herbert,
> 
> I sent a question to the ATH9K RNG some time ago to the developers.
> See https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg19115.html
> 
> I have not yet received a word and I think this issue should be resolved.
> 
> Thanks
> Stephan
> 
> ---8<---

If the above text is placed below the three dashes, "---", below ...

> The ATH9K driver implements an RNG which is completely bypassing the
> standard Linux HW generator logic.
> 
> The RNG may or may not deliver entropy. Considering the conservative
> approach in treating entropy with respect to non-auditable sources, this
> patch changes the delivered entropy value to zero. The RNG still feeds
> data into the input_pool but it is assumed to have no entropy.
> 
> When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
> the entropy estimation considering that a user can change that value at
> boot and runtime.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---

here, then the mail can be applied directly without editing.

>  drivers/net/wireless/ath/ath9k/rng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
> index d38e50f..d63dc48 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -92,8 +92,7 @@ static int ath9k_rng_kthread(void *data)
>  		fail_stats = 0;
>  
>  		/* sleep until entropy bits under write_wakeup_threshold */
> -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> -					   ATH9K_RNG_ENTROPY(bytes_read));

This is the only use of this macro.  I'd remove the #define on line 25
as well.

> +		add_hwgenerator_randomness((void *)rng_buf, bytes_read, 0);
>  	}
>  
>  	kfree(rng_buf);

Other than that,

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
