Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794056192;
	b=KsCNWodMfCek5ZkC59L6yv7FAA4NupkYLJc/mwFrtQYTBqoXx8vdC7F51Ap4pulRL6FB
	 lxJ4hZKVgpL/yGd24cHyDpjyhfzM78OY9JI86Z3N+45dgaL41fhu1RQK0wRS7c6BBZKL9
	 61QFUSxe/CzEPzmyySeJTtgNVpXShvQSF6Y0Ah1zC/HLNpoEzNm582ZiMTc7CrgBKX+aH
	 n98dsoypUO86a8DqTghLf1Yl8IxGcgGefhIbXdgZPKFghUurCnzy13UVKFHPj1zKksWXN
	 AeaoCIQcbJ+U38x8/LcTYQp79H4u+VqvwWy62ezyybtXKVRQbzwlK0UfBiu12amRsAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794056192;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QqdYyo+1t3zSvcXUH6Yd+SMswjfuLmpYrfNH0rpYBcw=;
	b=SnNPPI0zjjd4pXIaf/A6+76vgvfZCO9v37sceDFiaBNkanssSlNYPxfisVWzYO9+/9sa
	 8XWmn2dR6t0QMxzLr5cf5l93i5E5jFjep38h/JMHVQeRrImiwlV5mnndjI2kpmajTySn6
	 qLfwh6fCESI81kJAb5qULl9p47fD7UIy4w/XmriGWY6AmB2JAx5dmtLMbZrZueEQ9BuJp
	 gK0eXbmQoZB8MyFqxFy4TcajD+i4FloEy1Ivbl067itxSYsLjGMORfcACMhEorjvpvf8g
	 woIw0dP15GI3nr0L5FrWN11qJau7hPb1xwk4JA4yUBlbUSndiowMcxagUsSw5VumiBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yc3unTgf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8896606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 12:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yc3unTgf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065001F0089F;
	Sat,  7 Nov 2026 12:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794056191;
	bh=QqdYyo+1t3zSvcXUH6Yd+SMswjfuLmpYrfNH0rpYBcw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yc3unTgfO4Tthr8WP2jmMq79s4r20ao4EfEMqr7P/r+UDqHBEX4bhUqdCkRpHX70b
	 EcZ8ZWTcpVCc+OTGMYhIF4842lF3fofT2T+FvImMr/tXHWclxCFrgRUHoAjGSFvq8Z
	 xEby8sU6vNaov7HPx0JZp3R1DR1XAV/usTkYSZIarP72LplODq4+ixiVvpH0fTUSW1
	 0Yz+L1EFhmnOff9sFfxzGoi/hw30CKMik+qMdBy2UGnY+VOHv/ca6ZXoHNoyjmudrs
	 1to91N884whbPqUobo9NxGjH7BpqMKSdBteA0/coTWB5aBYKEkYIlUSFaV9tosuoXO
	 DrPTE8uZLX0qA==
Message-ID: <sashiko-outbox-202899@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: omap-sham: remove redundant
 pm_runtime_dont_use_autosuspend() calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joshua Crofts" <crofts@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261107-crypto-dont-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org>
References: <20261107-crypto-dont-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 12:56:30 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] crypto: omap-sham: missing runtime suspend before
  pm_runtime_disable()
--

commit 3e6145ea4d9da519423f99c72ef5ab8b8512ee57
Author: Joshua Crofts <crofts@kernel.org>

crypto: omap-sham: remove redundant pm_runtime_dont_use_autosuspend() calls

This commit removes the pm_runtime_dont_use_autosuspend() calls from the
probe error path and driver remove callback in omap-sham.

> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 5e739415a0102..72182f1900849 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -2109,7 +2109,6 @@ static int omap_sham_probe(struct platform_device *=
pdev)
>  	list_del(&dd->list);
>  	spin_unlock_bh(&sham.lock);
>  err_pm:
> -	pm_runtime_dont_use_autosuspend(dev);
>  	pm_runtime_disable(dev);
>  	if (!dd->polling_mode)
>  		dma_release_channel(dd->dma_lch);
> @@ -2131,7 +2130,6 @@ static void omap_sham_remove(struct platform_device=
 *pdev)
>  	omap_sham_unregister_algs(dd->pdata);
>  	crypto_engine_exit(dd->engine);
>  	cancel_work_sync(&dd->done_task);
> -	pm_runtime_dont_use_autosuspend(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> =20
>  	if (!dd->polling_mode)

[Severity: High]
Does removing pm_runtime_dont_use_autosuspend() before pm_runtime_disable()
prevent .runtime_suspend from running on probe failure and driver removal?

Because autosuspend is enabled with a 1000 ms delay, pm_runtime_put_sync()
in omap_sham_probe() and in __device_release_driver() before
omap_sham_remove() only arms the autosuspend timer and leaves the device in
RPM_ACTIVE.  Previously, calling pm_runtime_dont_use_autosuspend() while
runtime PM was still enabled triggered a synchronous rpm_idle() ->
rpm_suspend() transition before pm_runtime_disable().

Without it, pm_runtime_disable() cancels the pending autosuspend timer and
disables runtime PM while the device is still active.  When
pm_runtime_reinit() later runs in device_unbind_cleanup(), runtime PM is
already disabled, so it only resets the software status to RPM_SUSPENDED via
pm_runtime_set_suspended() without invoking .runtime_suspend.  This leaves
hardware clocks and the power domain enabled, and on OMAP2/OMAP3 platforms
using omap_device_pm_domain, probe failure leaves od->_state at
OMAP_DEVICE_STATE_ENABLED while runtime_status is RPM_SUSPENDED, causing any
subsequent probe to fail with -EINVAL in omap_device_enable().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107-crypto-don=
t-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org?part=3D1
