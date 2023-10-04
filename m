Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA9AE8FDD4
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Oct 2023 07:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbjJDHID (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Oct 2023 03:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbjJDHIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2023 03:08:02 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D171CC1
        for <linux-crypto@vger.kernel.org>; Wed,  4 Oct 2023 00:07:58 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qnvz4-0007mC-Np; Wed, 04 Oct 2023 09:07:50 +0200
Message-ID: <edf349c4-0ba3-4df3-8c83-f10072e24018@leemhuis.info>
Date:   Wed, 4 Oct 2023 09:07:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Content-Language: en-US, de-DE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230905232757.36459-1-wahrenst@gmx.net>
 <ZQQ1tgDEGGXwfu/4@gondor.apana.org.au>
 <436a7e20-082f-4aa9-bfbd-703d149d5463@leemhuis.info>
 <ZRy9cvCZMdo0QbIz@gondor.apana.org.au>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <ZRy9cvCZMdo0QbIz@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1696403278;d9c09131;
X-HE-SMSGID: 1qnvz4-0007mC-Np
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[CCing Linus in case he wants to voice in to clarify how fixes for
regressions that are nearly a year old should be handled]

On 04.10.23 03:18, Herbert Xu wrote:
> On Tue, Oct 03, 2023 at 01:35:29PM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
>>
>> Hi Herbert, I there a strong reason why you merged this to what from
>> here looks like the branch that targets the next merge window? The patch
>> fixes a regression introduced during the last 12 months and thus
>> normally should not wait for the next merge window. For details see
>> "Expectations and best practices for fixing regressions" in
>> Documentation/process/handling-regressions.rst; or if you want to hear
>> it from Linus directly, check these out:
>> https://lore.kernel.org/all/CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com/
>> https://lore.kernel.org/all/CAHk-=wgD98pmSK3ZyHk_d9kZ2bhgN6DuNZMAJaV0WTtbkf=RDw@mail.gmail.com/
> 
> This is a one-year-old regression,

From day the culprit was authored and merged to mainline: yes, nearly;
but it's only roughly 9 months from the release of 6.1 till the report
and the posting of the fix you applied.

But that's splitting hairs; pretty sure Linus meant those 12 months just
as a rough estimate. Other things also matter, among them how many
people are affected and how risky the fix is; but to my untrained eyes
this one doesn't look very dangerous (but I of course might be totally
wrong with that).

> and the fix is not a trivial reversion.

What makes you think the strategy outlined earlier is only relevant for
reverts? Yes, one of those links above points to a discussion about a
revert, but the other is not about it.

>  So there is no urgency in pushing this out.

I don't care to much about this particular case, but it would help my
work to know how Linus think about it. That's why I CCed him, that way
he can comment on this if he wants to.

Linus, FWIW, the thread starts here with the fix for the regression:
https://lore.kernel.org/all/20230905232757.36459-1-wahrenst@gmx.net/

Is also in -next for a while as b58a36008bfa1a. Quoting from there below
for convenience.

Ciao, Thorsten

"""> From b58a36008bfa1aadf55f516bcbfae40c779eb54b Mon Sep 17 00:00:00 2001
> From: Stefan Wahren <wahrenst@gmx.net>
> Date: Wed, 6 Sep 2023 01:27:57 +0200
> Subject: hwrng: bcm2835 - Fix hwrng throughput regression
> 
> The last RCU stall fix caused a massive throughput regression of the
> hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
> and usleep_range doesn't allow scheduling. So try to restore the
> best possible throughput by introducing hwrng_yield which interruptable
> sleeps for one jiffy.
> 
> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
> 
> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
> 
> cpu_relax              ~138025 Bytes / sec
> hwrng_msleep(1000)         ~13 Bytes / sec
> hwrng_yield              ~2510 Bytes / sec
> 
> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 2 +-
>  drivers/char/hw_random/core.c        | 6 ++++++
>  include/linux/hw_random.h            | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index eb04b12f9f01b..b03e803006275 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -70,7 +70,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
>  	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
>  		if (!wait)
>  			return 0;
> -		hwrng_msleep(rng, 1000);
> +		hwrng_yield(rng);
>  	}
>  
>  	num_words = rng_readl(priv, RNG_STATUS) >> 24;
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index e3598ec9cfca8..420f155d251fb 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -678,6 +678,12 @@ long hwrng_msleep(struct hwrng *rng, unsigned int msecs)
>  }
>  EXPORT_SYMBOL_GPL(hwrng_msleep);
>  
> +long hwrng_yield(struct hwrng *rng)
> +{
> +	return wait_for_completion_interruptible_timeout(&rng->dying, 1);
> +}
> +EXPORT_SYMBOL_GPL(hwrng_yield);
> +
>  static int __init hwrng_modinit(void)
>  {
>  	int ret;
> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index 8a3115516a1ba..136e9842120e8 100644
> --- a/include/linux/hw_random.h
> +++ b/include/linux/hw_random.h
> @@ -63,5 +63,6 @@ extern void hwrng_unregister(struct hwrng *rng);
>  extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
>  
>  extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
> +extern long hwrng_yield(struct hwrng *rng);
>  
>  #endif /* LINUX_HWRANDOM_H_ */
"""
