Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F88C2FE571;
	Mon, 26 Jan 2026 04:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769402440; cv=none; b=mxrIpxTwm6VrXO5A0esfUPc+S3Yan0mPTGx5jALol+HUW55ogEgjl9aWUuYH4OTDAJkbMdvNVBcUA7bc0zdTQPXi/bIVPZbpbl8Og2d4igN87DgBIdgwycj/3e16vkqw+IdC5UBoYnwT9DdfH3wDWz1+KonGEMcmkiMauqmUot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769402440; c=relaxed/simple;
	bh=jQ2Q1laXwAlsdt9jarJdpA8FVJIoiPYZ1UE80jCr0ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/dRP5OmStUxK3XpC2VexLtot92CQCF1jPIYs5yqIESFlpm614/in0Wvzdk4psVIPovmy7KkcCkWBuy0wdmEMLiKpEp8ZdxkArUU9zWoYOlo8MM/Tk0HgN9kV6zhSe+EpP5EFjCXg2F5oNR2MBVegG0wvngSS2LinGgVo7YpTHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hyPtIWUf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hyPtIWUf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ywqHLjVYk/p1KrDeKEFo/9K2tsO1DYVOCG79V4vgnUU=; 
	b=hyPtIWUfV+SjFIXQ7xoR330cX13pWB3L7dgjx+f9aVBYJvjHH5Pty9sx9vu2LYyhi7ZR2iwkxV1
	MKwFf0u0/bYDa4KB2gmqV3ZBG4VhxYhhZS9Jb8VJAHU4yKbBIab1U2pjYIXfpje9T49t2kD7h8McU
	UN/eGofzpSIgkzo8HrqMO+Zf1UNszeY2IPXMgyGs/rC6v9GQmnB6Q8Aihn2o860tqfgbTsBhjG+4l
	RJABzDoBB+6pNFI97aShOHq1kPuXmCvoBsGPy2n+4NkByNQhinC/Zv6cAdhloBdcF23sd48AXbt/s
	rmaO2nT8RMhgYJnAUJeOAFtPBOd8BGj8gC7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vkEOh-002716-2T;
	Mon, 26 Jan 2026 12:40:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Jan 2026 12:40:19 +0800
Date: Mon, 26 Jan 2026 12:40:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lianjie Wang <karin0.zst@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: core - use RCU for current_rng to fix race
 condition
Message-ID: <aXbwM1wiPKqmC94v@gondor.apana.org.au>
References: <20260124195555.851117-1-karin0.zst@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124195555.851117-1-karin0.zst@gmail.com>

On Sun, Jan 25, 2026 at 04:55:55AM +0900, Lianjie Wang wrote:
> Currently, hwrng_fill is not cleared until the hwrng_fillfn() thread
> exits. Since hwrng_unregister() reads hwrng_fill outside the rng_mutex
> lock, a concurrent hwrng_unregister() may call kthread_stop() again on
> the same task.
> 
> Additionally, if the hwrng_unregister() call happens immediately after a
> hwrng_register() before, the stopped thread may have never been running,
> and thus hwrng_fill remains dirty even after the hwrng_unregister() call
> returns. In this case, further calls to hwrng_register() may not start
> new threads, and hwrng_unregister() will also call kthread_stop() on the
> same task, causing use-after-free and sometimes lockups:
> 
> refcount_t: addition on 0; use-after-free.
> WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
> Call Trace:
>  kthread_stop+0x181/0x360
>  hwrng_unregister+0x288/0x380
>  virtrng_remove+0xe3/0x200
> 
> This patch fixes the race by protecting the global hwrng_fill pointer
> inside the rng_mutex lock, so that hwrng_fillfn() thread is stopped only
> once, and calls to kthread_create() and kthread_stop() are serialized
> with the lock held.
> 
> To avoid deadlock in hwrng_fillfn() while being stopped,
> get_current_rng() and put_rng() no longer hold the rng_mutex lock now.
> Instead, we convert current_rng to RCU.
> 
> With hwrng_fill protected by the rng_mutex lock, hwrng_fillfn() can no
> longer clear hwrng_fill itself. Therefore, the kthread_stop() call is
> moved from hwrng_unregister() to drop_current_rng(), where the lock is
> already held. This ensures the task is joined via kthread_stop() on all
> possible paths (whether kthread_should_stop() is set, or
> get_current_rng() starts returning NULL).
> 
> Since get_current_rng() no longer returns ERR_PTR values, the IS_ERR()
> checks are removed from its callers. The NULL check is also moved from
> put_rng() to its caller rng_current_show(), since all the other callers
> of put_rng() already check for NULL.
> 
> Fixes: be4000bc4644 ("hwrng: create filler thread")
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
> ---
> v2:
>  - Convert the lock for get_current_rng() to RCU to break the deadlock, as
>    suggested by Herbert Xu.
>  - Remove rng_mutex from put_rng() and move NULL check to rng_current_show().
>  - Move kthread_stop() to drop_current_rng() inside the lock to join the task
>    on all paths, avoiding modifying hwrng_fill inside hwrng_fillfn().
>  - Revert changes to rng_fillbuf.
> 
> v1: https://lore.kernel.org/linux-crypto/20251221122448.246531-1-karin0.zst@gmail.com/
> 
>  drivers/char/hw_random/core.c | 145 +++++++++++++++++++---------------
>  1 file changed, 81 insertions(+), 64 deletions(-)

Thanks, this looks pretty good!

>  static struct hwrng *get_current_rng(void)
>  {
>  	struct hwrng *rng;
> 
> -	if (mutex_lock_interruptible(&rng_mutex))
> -		return ERR_PTR(-ERESTARTSYS);
> +	rcu_read_lock();
> +	rng = rcu_dereference(current_rng);
> +	if (rng && !kref_get_unless_zero(&rng->ref))
> +		rng = NULL;

rng->ref should never be zero here as the final kref_put is delayed
by RCU.  So this should be a plain kref_get.

>  static void put_rng(struct hwrng *rng)
>  {
> -	/*
> -	 * Hold rng_mutex here so we serialize in case they set_current_rng
> -	 * on rng again immediately.
> -	 */
> -	mutex_lock(&rng_mutex);
> -	if (rng)
> -		kref_put(&rng->ref, cleanup_rng);
> -	mutex_unlock(&rng_mutex);
> +	kref_put(&rng->ref, cleanup_rng);
>  }

I think the mutex needs to be kept here as otherwise there is
a risk of a slow cleanup_rng racing against a subsequent hwrng_init
on the same RNG.

> @@ -371,11 +385,10 @@ static ssize_t rng_current_show(struct device *dev,
>  	struct hwrng *rng;
> 
>  	rng = get_current_rng();
> -	if (IS_ERR(rng))
> -		return PTR_ERR(rng);
> 
>  	ret = sysfs_emit(buf, "%s\n", rng ? rng->name : "none");
> -	put_rng(rng);
> +	if (rng)
> +		put_rng(rng);

I don't think this NULL check is necessary as put_rng can handle
rng == NULL.

> @@ -489,8 +502,17 @@ static int hwrng_fillfn(void *unused)
>  		struct hwrng *rng;
> 
>  		rng = get_current_rng();
> -		if (IS_ERR(rng) || !rng)
> +		if (!rng) {
> +			/* This is only possible within drop_current_rng(),
> +			 * so just wait until we are stopped.
> +			 */
> +			while (!kthread_should_stop()) {
> +				set_current_state(TASK_INTERRUPTIBLE);
> +				schedule();
> +			}
>  			break;
> +		}
> +

Is the schedule necessary? Shouldn't the break just work as it
did before?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
