Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400EB2D052;
	Sat, 22 Jun 2024 20:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719088005; cv=none; b=sEGgXsVzB5II1N/raez0Lq34mYGqLCe9iSbVLX562pMh66DUGzP8J+/7SscCHkn9h5UU5MQUobZ3ndHt0sbhcDjDsntA5kgCgEr1Vd9t+jBUEquxZq9TbWp5uB/Am/cmcxmqMpftY1RcdoJvBI/10AP6ZdVbGsOWgWT6htsMQXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719088005; c=relaxed/simple;
	bh=ao+837YjdmlP6HZftP9TxacWBYhLQoAsFjco+i0cLQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiUxr9BpVa58vD+VUR3kbODVZqzFpKyN3o7qsOBYoJT5V2ENxISXb/LczE4okEg2oWj9wAxhBEvURqrqNOAwnX3tnajzzgYnkV7JA7HIS6oSd4HenkpFhAllDlxAKtoHwefuctH5jzS9rPAQX3MzL9/dZoAipF211GJ9gY+/OkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Received: from i53875a87.versanet.de ([83.135.90.135] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1sL7JC-0007Ef-VY; Sat, 22 Jun 2024 22:26:03 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@kernel.org>,
 Dragan Simic <dsimic@manjaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
Date: Sat, 22 Jun 2024 22:26:01 +0200
Message-ID: <3660160.WbyNdk4fJJ@diego>
In-Reply-To: <07fba45d99e9eabf9bcca71b86651074@manjaro.org>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
 <07fba45d99e9eabf9bcca71b86651074@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Samstag, 22. Juni 2024, 12:29:33 CEST schrieb Dragan Simic:
> Hello Uwe,
>=20
> On 2024-06-22 00:16, Uwe Kleine-K=F6nig wrote:
> > On 6/21/24 20:13, Dragan Simic wrote:
> >> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
> >>> On 21/06/2024 03:25, Daniel Golle wrote:
> >>>> From: Aurelien Jarno <aurelien@aurel32.net>
> >>=20
> >> [snip]
> >>=20
> >>>> +    pm_runtime_set_autosuspend_delay(dev,=20
> >>>> RK_RNG_AUTOSUSPEND_DELAY);
> >>>> +    pm_runtime_use_autosuspend(dev);
> >>>> +    pm_runtime_enable(dev);
> >>>> +
> >>>> +    ret =3D devm_hwrng_register(dev, &rk_rng->rng);
> >>>> +    if (ret)
> >>>> +        return dev_err_probe(&pdev->dev, ret, "Failed to register=20
> >>>> Rockchip hwrng\n");
> >>>> +
> >>>> +    dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
> >>>=20
> >>> Drop, driver should be silent on success.
> >>=20
> >> I respectfully disagree.  Many drivers print a single line upon
> >> successful probing, which I find very useful.  In this particular
> >> case, it's even more useful, because some people may be concerned
> >> about the use of hardware TRNGs, so we should actually make sure
> >> to announce it.
> >=20
> > I agree to Krzysztof here. From the POV of a driver author, your own
> > driver is very important and while you write it, it really interests
> > *you* if the driver is successfully probed. However from a system
> > perspective these are annoying: There are easily >50 devices[1] on a
> > system, if all of these print a message in probe, you have little=20
> > chance
> > to see the relevant messages. Even if every driver author thinks their
> > work is a special snow flake that is worth announcing, in practice=20
> > users
> > only care about your driver if there is a problem. Additionally each
> > message takes time and so delays the boot process. Additionally each
> > message takes place in the printk ring buffer and so edges out earlier
> > messages that might be more important.
>=20
> Well, I don't find those messages annoying, for the drivers I've had
> nothing to do with.  Also, in my experience, 99.9% of users don't care
> about the kernel messages at all, be it everything hunky-dory, or be
> it something really wrong somewhere.
>=20
> > So +1 for dropping the dev_info() or at least using dev_debug() for it.

Just for 2ct ... I'm also in the don't print too much camp ;-) .
When parsing kernel logs to see where things fail, messages just
telling me about sucesses make things more difficult.

So really this message should be dropped or at least as Uwe suggests
made a dev_dbg.


Heiko


