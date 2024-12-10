Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA05228372;
	Tue, 10 Dec 2024 05:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808507; cv=none; b=A6ZQTmNmJDeEeBU7I53c+k7rHFD/tMyXzBNP7WjNf9vPdxHY5DZ3scvqEFoGGprQPLRHqRwywYNoR2fmos/CducIbjhLkDwtUGPMjuzNhEBYIEPAszY/QIpK7w5twgjEajkhcmzYb17gEE9lBgbVg/7m1hk3nQRcZ52lKoosCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808507; c=relaxed/simple;
	bh=+DwSGOXuuqNabZsdzSbD+HwDHQWTNMD+nwplOuyHAhk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=eGSUGyn5fOj6Qb0iawsuQF2xjkBO5ByBx5kSaxmndnFw3dogyTyK69S4uBePMR3gHQ4tZ5Rry/WOnmjlOkBDzF1WqtZsfPN4VMCMPKQNlKSCAG948lcA1E3qKTjjgKcoSzRIvMpA9oH09vCc38txKFLV68KL+pnNvvYr8iQqWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r4E/7f7K; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r4E/7f7K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jS0KRHv3gisGkGaPcXBUeChmcT/fU7BjmCvQPNgWfQg=; b=r4E/7f7KUMd2ELmW7GfAM1kI8d
	QQhp2W3uyJbFMjHLvboh8hECFZsjD4HMIDaCzI75hoqNLwpaL4/izZtq6898nLEEKaQ6AlFzUetif
	XZ4uS1YyVVotNo+7EExeCxeRzGcrmy1Ce3Ogr0pvTSty5yljVO2+9Fh2Njbe5yPFctw7wxCqua88J
	Fn4JntnmlcwqQo+P9DZ8iZBSrsixMqtmSsLJYFPtWDiS7rkhPTsc/e6KUCesTPduCkOTnBfq01giQ
	Flohwb8YDNApLuvll9GGOWfazxgqAlc5Ln4cSRFjV5jN+4VAvXIIdbJFfRgjpy3U8oSvDhIjw+Ukf
	eozgGcsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKsaD-000O2Z-1T;
	Tue, 10 Dec 2024 13:28:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 13:28:14 +0800
Date: Tue, 10 Dec 2024 13:28:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: hadar.gat@arm.com, olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaopei01@kylinos.cn,
	Tian Tao <tiantao6@hisilicon.com>
Subject: Re: [PATCH] hwrng: cctrng: Add cancel_work_sync before module remove
Message-ID: <Z1fRbqh2_2gSpgkJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d71e0bcee781ebe12697df94083f16d651fb30c0.1732786634.git.xiaopei01@kylinos.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Pei Xiao <xiaopei01@kylinos.cn> wrote:
> Be ensured that the work is canceled before proceeding with
> the cleanup in cc_trng_pm_fini.
> 
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> ---
> drivers/char/hw_random/cctrng.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index 4db198849695..fd1ee3687782 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -127,6 +127,8 @@ static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
> {
>        struct device *dev = &(drvdata->pdev->dev);
> 
> +       cancel_work_sync(&drvdata->compwork);
> +       cancel_work_sync(&drvdata->startwork);
>        pm_runtime_disable(dev);
> }

I don't think this is right.  This is a problem with using devres:
you need to be very careful with unwinding things.  The remove
occurs before all devm resources are released.  So the device is
still registered with the hwrng core and potentially live.

These work tasks are created by the ISR.  So they should only be
cancelled after the IRQ handler has been unregistered.

Perhaps we should just rip out all the devm code and go back to
manual freeing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
