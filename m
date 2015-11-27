From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: core, sleep interruptible in read
Date: Fri, 27 Nov 2015 21:06:03 +0800
Message-ID: <20151127130603.GA29503@gondor.apana.org.au>
References: <1448567789-2470-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	linux-crypto@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51017 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbK0NGN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 08:06:13 -0500
Content-Disposition: inline
In-Reply-To: <1448567789-2470-1-git-send-email-jslaby@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 26, 2015 at 08:56:29PM +0100, Jiri Slaby wrote:
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index a064237ff362..f003df162e09 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -238,7 +238,10 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			goto out;
>  		}
>  
> -		mutex_lock(&reading_mutex);
> +		if (mutex_lock_interruptible(&reading_mutex)) {
> +			err = -EINTR;

Shouldn't this be ERESTARTSYS?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
