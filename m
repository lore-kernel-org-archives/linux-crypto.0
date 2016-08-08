From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Mon, 08 Aug 2016 08:41:36 +0200
Message-ID: <1830987.VF9l4XmGxv@tauon.atsec.com>
References: <34197429.2CvoIfft9B@positron.chronox.de> <1654172.XfclnXhRmn@positron.chronox.de> <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jason Cooper <jason@lakedaemon.net>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34230 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcHHGlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 02:41:40 -0400
In-Reply-To: <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 8. August 2016, 02:03:36 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> The entropy was evaluated by crypto expert,  the analysis report show the
> ADC with at least 10bits and up to 22 bits of min-entropy for a 32 bits
> value, we conservatively assume the min-entropy is 10 bits out of 32 bits,
> so that's why set entropy quality  to  320/1024 = 10/32.  Also we have
> explained in the commit message why can't use the HW RNG framework.

Where is the description of the RNG, where is the test implementation? 
> 
> Otherwise, your patch will cause high CPU load,  as continuously read ADC
> data if entropy bits under write_wakeup_threshold.

The issue is that although you may have analyzed it, others are unable to 
measure the quality of the RNG and assess the design as well as the 
implementation of the RNG. This RNG is the only implementation of a hardware 
RNG that per default and without being able to change it at runtime injects 
data into the input_pool where the noise source cannot be audited. Note, even 
other respected RNG noise sources like the Intel RDRAND will not feed into /
dev/random per default in a way that dominates all other noise sources.

I would like to be able to deactivate that noise source to the extent that it 
does not cause /dev/random to unblock. The reason is that your noise source 
starts to dominate all other noise sources.

If you think that this patch is a challenge because your driver starts to 
spin, please help and offer another solution.
> 
> --
> Miaoqing
> 
> -----Original Message-----
> From: Stephan Mueller [mailto:smueller@chronox.de]
> Sent: Sunday, August 07, 2016 5:36 PM
> To: Ted Tso <tytso@mit.edu>
> Cc: herbert@gondor.apana.org.au; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>;
> linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org; Kalle Valo
> <kvalo@codeaurora.org>; Jason Cooper <jason@lakedaemon.net> Subject: [PATCH
> v2] RANDOM: ATH9K RNG delivers zero bits of entropy
> 
> The ATH9K driver implements an RNG which is completely bypassing the
> standard Linux HW generator logic.
> 
> The RNG may or may not deliver entropy. Considering the conservative
> approach in treating entropy with respect to non-auditable sources, this
> patch changes the delivered entropy value to zero. The RNG still feeds data
> into the input_pool but it is assumed to have no entropy.
> 
> When the ATH9K RNG changes to use the HW RNG framework, it may re-enable 
the
> entropy estimation considering that a user can change that value at boot
> and runtime.
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  drivers/net/wireless/ath/ath9k/rng.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c
> b/drivers/net/wireless/ath/ath9k/rng.c index d38e50f..1ed8338 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -22,7 +22,6 @@
>  #include "ar9003_phy.h"
> 
>  #define ATH9K_RNG_BUF_SIZE	320
> -#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 320) >> 10) /* quality: 320/1024
> */
> 
>  static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32
> buf_size)  { @@ -92,8 +91,7 @@ static int ath9k_rng_kthread(void *data)
> fail_stats = 0;
> 
>  		/* sleep until entropy bits under write_wakeup_threshold */
> -		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> -					   ATH9K_RNG_ENTROPY(bytes_read));
> +		add_hwgenerator_randomness((void *)rng_buf, bytes_read, 0);
>  	}
> 
>  	kfree(rng_buf);
> --
> 2.7.4



Ciao
Stephan
