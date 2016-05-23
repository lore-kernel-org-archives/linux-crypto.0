From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Mon, 23 May 2016 22:35:49 +0200
Message-ID: <6297051.TAxtzW5OIB@wuerfel>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:59815 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbcEWUg2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 16:36:28 -0400
In-Reply-To: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, May 23, 2016 6:14:08 PM CEST Sudip Mukherjee wrote:
> We have been getting build warning about:
> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
> 					uninitialized in this function
> 
> On checking the code it turns out that sr can never be used
> uninitialized as sr is getting initialized in the while loop and while
> loop will always execute as the minimum value of max can be 32.
> So just initialize sr to 0 while declaring it to silence the compiler.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---

I notice that you are using a really old compiler. While this warning
seems to be valid in the sense that the compiler should figure out that
the variable might be used uninitialized, please update your toolchain
before reporting other such problems, as gcc-4.6 had a lot more false
positives that newer ones (5.x or 6.x) have.

> 
> build log at:
> https://travis-ci.org/sudipm-mukherjee/parport/jobs/132180906
> 
>  drivers/char/hw_random/stm32-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index 92a8106..0533370 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -52,7 +52,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  {
>  	struct stm32_rng_private *priv =
>  	    container_of(rng, struct stm32_rng_private, rng);
> -	u32 sr;
> +	u32 sr = 0;
>  	int retval = 0;
>  
>  	pm_runtime_get_sync((struct device *) priv->rng.priv);

Does this work as well?

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 92a810648bd0..5c836b0afa40 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -79,7 +79,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
-	if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
+	if (WARN_ONCE(retval > 0 && (sr & (RNG_SR_SEIS | RNG_SR_CEIS)),
 		      "bad RNG status - %x\n", sr))
 		writel_relaxed(0, priv->base + RNG_SR);
 
I think it would be nicer to not add a bogus initialization.

	Arnd
