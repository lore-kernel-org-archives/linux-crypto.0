Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168771;
	b=yJ+Zo12vj/9ibGQUwmTwC33YwkCFig3i+Xll5f2PM9jVG0R7/HRtZvJUe/3KHtV3NF/2
	 ZZjUlXkzyl5b+FUwpXgTzFtprqEs9WaxyfOdSamJZjRLtuuxX0eVFSprJkfTKd5hvQNz3
	 YOQSdRsCjECdfxcp/W8+Z5WxAxcqkl4y8B5o56hABS/+bL7OEKW3z4He/UZe0dR15Qyx/
	 0+XNiwdnTic6g8r8kXFJ/lE7gYEIlmZM6OLgQpGyvXVBQYGEoykzQskxAfVratJpGf8xD
	 3O81AZa4CGN83DG+pi+1f+SMwi1HMVfeULEOhE2PuAH0+cjY7lH7EKCa3kTMiT0M2Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168771;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=54MAWfFgyDXgdTIKy5UVC0oKpZt8Q+PuEtG+8qm+8/8=;
	b=CN2uiCnIad3KdNdaxa9kP6CqE2WghjKImiYz2rgEZVqzfFeTY2QQOP3xx/gF/FBetxA0
	 0ju1lu+SLM4MsSKrXRa5PeW9TW913+XitFAiGF6/0kdatzRGK7EMA+nggllVpzzA7sbnL
	 pSyqNwpEvb4wYRn4KbWtksDvpeWHPwSJi4ar7lgSeKsvo9WjW9IO6U0LREjNwvhBSuf1l
	 kovTPPWqMZ9jPQIZQOPrAWTyemR3SxnTM/u1QA1ajpoqTBpbKXAqzV2PL1E8B1D+oh1zX
	 F6Jxx5/OXb5oGbgynI93ytyflQnB+vuOO+yrq86JMPv/ODKqzVXR0qRzH75RNDQRxOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=D2M9T2oI;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ABF606A320;
	Fri, 20 Nov 2026 09:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19ABF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=D2M9T2oI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=54MAWfFgyDXgdTIKy5UVC0oKpZt8Q+PuEtG+8qm+8/8=; 
	b=D2M9T2oISXFsdJNM4+8zDbgXzvyGracayVxkPtRHdQmoC3EQcacj3jKjajMPAxfQGkIRPYvfW5I
	1+3SGg6XhyIpDk1o1rejiTjaSkZOfxlyjC7Qbw/fFNaKYbOW4qzF5gtm4QkeqY0K0QuT70OKFk3Lz
	78mjMSS2Cwl/xWaJjkE7dPZ8BfVyde2OUN0iPfAQzPa1zrOOMtsYlgE8p8eymeptRO2BdnS//5ynr
	nH7HaUeYVQgkVQ6QyHwpjf1fRXsq3cFm4MnlH+FvlFIP5AxatxEhTmP2/tyyPoaLYQJe4h7CYBhl3
	NUqbl8C+BXvpB4W78gNptLyvepEKACpCjcRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULOx-0000000HYsL-0yVc;
	Fri, 20 Nov 2026 17:59:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:59:27 +0800
Date: Fri, 20 Nov 2026 17:59:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nhat Tran <nhat.tranminhk2@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Unregister hwrng before disabling the
 device on remove
Message-ID: <awAZ_4SngFhAPq0l@gondor.apana.org.au>
References: <20261115145050.88427-1-nhat.tranminhk2@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115145050.88427-1-nhat.tranminhk2@gmail.com>

On Sun, Nov 15, 2026 at 09:50:50PM +0700, Nhat Tran wrote:
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
