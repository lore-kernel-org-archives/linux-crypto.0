Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.238.236.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794759540;
	b=SHsbcTUbMne3nyRzruH5AuYrChzkxaIoeoPf4pjuJKzlLTRkNNnbcVrsgcrI0aBGrbnM
	 WuenjmeCgv/Euc2nzRon/J3DYX3+GnR+9Ifiam6WEW3BHuzwcOApB3aNyACVfTN4veq+l
	 8QkmiyeoR0n/GP4bw0gFB8yYJyMQRmKf2HLzd63sRI12fV+0TXb6KlDKZW535DEMgWy9k
	 wWeoLA4ERHDusJEX0IGwmUXjj5ra8rveXu7cYFtOdBxNjCcajs3Uje1I7ZdKv1q8CAuSL
	 fDktEGhnvLLvMb0h9aE9UQI3pxwgA4X1TqTCRvQFceS4ALWHqNv8dSm2QxphI5yQTAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794759540;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=j9WU+1CjSv2jxs9dt8exoheP8N0Wgk/Y19soIda22ZI=;
	b=wCpw/+mfDUtxohBEVcOx+cftW8XL/2l6U9CAIFlVVPvJlq4T2kjE0EHxs0X2G3ZXaA7e
	 osSpEL6cYyUzRzB/jzbQKduzXSw4ef5rGgmUh823T4/uqDh18JBYbpVN0BydxGtMvyI9g
	 G8CEQoJYTT+YUsbEn8mY2PLBngd3Vo0d0pFL62kdY5iOk8j/ko8E/Kd43KAr7rBOIHBwP
	 Cvvhq7QcwgCq58gfEqcmyn02YnO5EQXAVXS3h+jjiHgkym7tkW3zk9h4aq2MzoGOMjVpq
	 9dR+b20NwuRsRrTRBf8CbjfGcTS1DVOs/gm26+3OkZBzPIhJlR+ZGufhwvFCXZwFusw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kemnade.info;
	spf=pass smtp.mailfrom=kemnade.info;
	dkim=pass header.d=kemnade.info header.i=@kemnade.info header.a=rsa-sha256 header.s=20220719 header.b="C/l6sHzq";
	arc=none smtp.remote-ip=178.238.236.174
Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E67606A897;
	Sun, 15 Nov 2026 16:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28E67606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kemnade.info header.i=@kemnade.info header.a=rsa-sha256 header.s=20220719 header.b=C/l6sHzq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=j9WU+1CjSv2jxs9dt8exoheP8N0Wgk/Y19soIda22ZI=; t=1794759539; x=1795969139; 
	b=C/l6sHzqC+IlM1CIhKhhVA/OFVQnOq9fPJb0xTivZ+hXE4m2/yNLaiHxDLkNb4LYmnmiQEjzvD3
	RVOJNIVsGqs5EWqXZyv0cPLnJSluAgZgVy0LqXJpTrXF2E0kXOKPeWvzg0EiwMAF17MnIXQ9dg83P
	cQQbf3Kk7fNgrIPits/Xbcv6edKfEldpbzLi4/CH/Nye6RlQefdZKF43udq2RopibMmJochxc8gx6
	0SopXENGDLks12d2IExq8gVed+yBN4uDZJNXhb84hebf7KPURTun+rmS3C5LwaxlvsjVS6iG23QfC
	pDJ4SXT6FJr47XlZY8pegnuIdjgVjW8ee5CA==;
Date: Sun, 15 Nov 2026 17:18:43 +0100
From: Andreas Kemnade <andreas@kemnade.info>
To: Nhat Tran <nhat.tranminhk2@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Olivia Mackall
 <olivia@selenic.com>, Deepak Saxena <dsaxena@plexity.net>,
 linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Unregister hwrng before disabling the
 device on remove
Message-ID: <20261115171843.063c11c9@kemnade.info>
In-Reply-To: <20261115145050.88427-1-nhat.tranminhk2@gmail.com>
References: <20261115145050.88427-1-nhat.tranminhk2@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 15 Nov 2026 21:50:50 +0700
Nhat Tran <nhat.tranminhk2@gmail.com> wrote:

> Commit 3e75241be808 ("hwrng: drivers - Use device-managed registration
> API") switched omap-rng to devm_hwrng_register() and dropped the
> hwrng_unregister() call from the start of omap_rng_remove(). Since then
> the hwrng is unregistered by devres only after omap_rng_remove() has
> returned, i.e. after the device has been runtime suspended and its
> runtime PM disabled.
> 
> When the omap-rng is the current hwrng, hwrng_unregister() drops the
> last reference and schedules cleanup_rng_work(), which calls
> omap_rng_cleanup() and in turn omap4_rng_cleanup(). That reads and
> writes RNG_CONTROL_REG while the module clock is gated. On a
> BeagleBone Black (AM335x) unbinding the driver triggers:
> 
>   # echo 48310000.rng > /sys/bus/platform/drivers/omap_rng/unbind
>   Unhandled fault: external abort on non-linefetch (0x1028) at 0xfa310014
>   Internal error: : 1028 [#1] SMP ARM
>   Workqueue: events cleanup_rng_work
>   PC is at omap4_rng_cleanup+0x14/0x24
>   LR is at cleanup_rng_work+0x30/0x48
>   Call trace:
>    omap4_rng_cleanup from cleanup_rng_work+0x30/0x48
>    cleanup_rng_work from process_scheduled_works+0xf0/0x518
>    process_scheduled_works from worker_thread+0x140/0x2f0
>    worker_thread from kthread+0xfc/0x134
>    kthread from ret_from_fork+0x14/0x28
> 
> The worker dies before it completes rng->cleanup_done, so the unbind
> also never returns because hwrng_unregister() waits for that
> completion. The same window lets the hwrng fill thread call
> omap_rng_do_read() on the suspended device.
> 
> Restore the original teardown order: register with hwrng_register()
> and call hwrng_unregister() first in omap_rng_remove(), while the
> device is still powered.
> 
> Fixes: 3e75241be808 ("hwrng: drivers - Use device-managed registration API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Tran <nhat.tranminhk2@gmail.com>
> ---
>  drivers/char/hw_random/omap-rng.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index 49d7f021fd31..e5b14ab1b7e4 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -493,7 +493,7 @@ static int omap_rng_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_register;
>  
> -	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
> +	ret = hwrng_register(&priv->rng);
>  	if (ret)
>  		goto err_register;
>  
> @@ -520,6 +520,7 @@ static void omap_rng_remove(struct platform_device *pdev)
>  {
>  	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
>  
> +	hwrng_unregister(&priv->rng);
>  
>  	priv->pdata->cleanup(priv);
>  
what about going forward add add a devm_add_action_or_reset() for this instead.
And use some devm_runtime for enabling runtime?

I guess we are done then.

Regards,
Andreas


