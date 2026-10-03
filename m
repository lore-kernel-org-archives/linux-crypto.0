Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1239D6FD
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791065476; cv=none; b=ojsZCI/osqRB8uS/zqg44dEguAax/vy6uM/kmRX1N2ULGFUUnsW1c6QDd+9gpiu0bsNTjVoXtBvx1QxjBu0AnE/jBsX0zLmFA9KNVQFcMYJdMv4RqQSj/f59wtLdbLQzqqo1oFC6HK4DUIXNPOf0lVeNHjaGEcUwZe4AKw4rHVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791065476; c=relaxed/simple;
	bh=YdLb+UECdYOYR8sWTgVCqw/o0TzIrjRTUucwz7a0+fw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=bAONDujs3mmnatQFXQ80g50kF5Gbezx355g3j6A/YnqxcweuGCCTr5I762M6qfQzVaKwQHtUnpGsOaJoNPu4zrLoFx3BAtSta32EHc13ALBqC4UECLttzImcKyp5byOUAqahxxmD5NRfZAtU9a72F7EB6Uq9gbkJDjCkTlgJOQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ME6J3Zzd; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ME6J3Zzd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 7665E1A110E;
	Sat,  3 Oct 2026 22:11:11 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D0EAE604FF;
	Sat,  3 Oct 2026 22:11:10 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 59F6610328366;
	Sun,  4 Oct 2026 00:11:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791065470; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=vLIYpYbzpe+zZr7ujIrUdld5c1tY2PuBJWK9DL9g1vM=;
	b=ME6J3ZzdtRrq62A5MLnXaIDN7hOG4Ldxr389YyJvedeQ5VWMUNto2YA14JI4d4rOjQL+4M
	D7f9/YEOqBkY73L9P9n8NUEPlYkXwkYXpl9FQSOT6j9GCM9TAk0B/cVnSzb4fmiy+qG24D
	ukwmaWLXywlGu1baoH8C0Ri03+UIxnc5kVtwyyJV/Hc0HrT4m9JF6DuRKkgztwS6WGVGOs
	LfrbsGpdI0RXtUehGdFGwKARBY8THgts5JqI7dQ+HMwU8qctVaWMS84wqdMVk75chWTvaQ
	WBa9chQZtz9dVRCYdsAbIt0WLRtiD8+2RkeDqC1u987QXWWxHl+JecP3FS0m2Q==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 04 Oct 2026 00:11:04 +0200
Message-Id: <DLVJPVEV4SW7.16A8YC0SH3Z63@bootlin.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: talitos: fix probe IRQ ordering
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Rosen Penev" <rosenp@gmail.com>, <linux-crypto@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261003212359.126745-1-rosenp@gmail.com>
In-Reply-To: <20261003212359.126745-1-rosenp@gmail.com>
X-Last-TLS-Session-Version: TLSv1.3

On Sat Oct 3, 2026 at 11:23 PM CEST, Rosen Penev wrote:
> The talitos interrupt handlers schedule priv->done_task[] via
> tasklet_schedule().  In probe(), talitos_probe_irq() ran before
> tasklet_init(), so an interrupt arriving during that window (a shared
> IRQ, or a completion pending from an earlier transmission) would
> schedule an uninitialized tasklet.
>
> Resolve the IRQ numbers before the tasklet_init() calls so the
> done_task[] selection can see the secondary IRQ, and only request the
> IRQs after the channel fifos are allocated and the device is
> initialized.  Every structure the handlers touch is then fully set up
> before interrupts are enabled.  This matches remove(), which frees the
> IRQs before killing the tasklets.

LLM tends to be very verbose on commit messages and describe what the git d=
iff
could already tell us.
The second paragraph could be resumed to:

"Request IRQs after the necessary data structures are initialized, so that
interrupts do not schedule uninitialized tasklets."

>
> Assisted-by: LLM

There are some available skills to improve AI wording, or you can make one
yourself tell it to avoid verbosity.

> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v3: reshuffle again to fix IRQs.
>  v2: reshuffle code to avoid NULL derefs
>  drivers/crypto/talitos.c | 48 ++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 41a87d7c30a0..70f7ad9e09f9 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -3353,21 +3353,13 @@ static int talitos_probe_irq(struct platform_devi=
ce *ofdev)
>  	int err;
>  	bool is_sec1 =3D has_ftr_sec1(priv);
> =20
> -	priv->irq[0] =3D platform_get_irq(ofdev, 0);
> -	if (priv->irq[0] < 0)
> -		return priv->irq[0];
> -
>  	if (is_sec1) {
>  		err =3D request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
>  				  dev_driver_string(dev), priv);
>  		goto primary_out;
>  	}
> =20
> -	priv->irq[1] =3D platform_get_irq_optional(ofdev, 1);
> -	if (priv->irq[1] =3D=3D -EPROBE_DEFER)
> -		return priv->irq[1];
> -
> -	/* get the primary irq line */
> +	/* single (or primary) irq line */
>  	if (priv->irq[1] < 0) {
>  		err =3D request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
>  				  dev_driver_string(dev), priv);
> @@ -3379,13 +3371,11 @@ static int talitos_probe_irq(struct platform_devi=
ce *ofdev)
>  	if (err)
>  		goto primary_out;
> =20
> -	/* get the secondary irq line */
> +	/* secondary irq line */
>  	err =3D request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
>  			  dev_driver_string(dev), priv);
> -	if (err) {
> +	if (err)
>  		dev_err(dev, "failed to request secondary irq\n");
> -		priv->irq[1] =3D 0;
> -	}
> =20
>  	return err;
> =20
> @@ -3404,12 +3394,27 @@ static int talitos_probe(struct platform_device *=
ofdev)
>  	struct device_node *np =3D ofdev->dev.of_node;
>  	struct talitos_private *priv;
>  	unsigned int num_channels;
> +	void __iomem *reg;
>  	int i, err;
>  	int stride;
> +	int irq0;
> +	int irq1;
> =20
>  	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
>  		return -EINVAL;
> =20
> +	irq0 =3D platform_get_irq(ofdev, 0);
> +	if (irq0 < 0)
> +		return irq0;
> +
> +	irq1 =3D platform_get_irq_optional(ofdev, 1);
> +	if (irq1 =3D=3D -EPROBE_DEFER)
> +		return irq1;
> +
> +	reg =3D devm_platform_ioremap_resource(ofdev, 0);
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +

You are dropping a previous error message here, use dev_err_probe().

>  	priv =3D devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_K=
ERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> @@ -3425,12 +3430,7 @@ static int talitos_probe(struct platform_device *o=
fdev)
> =20
>  	spin_lock_init(&priv->reg_lock);
> =20
> -	priv->reg =3D devm_platform_ioremap_resource(ofdev, 0);
> -	if (IS_ERR(priv->reg)) {
> -		dev_err(dev, "failed to of_iomap\n");
> -		err =3D PTR_ERR(priv->reg);
> -		goto err_out;
> -	}
> +	priv->reg =3D reg;
> =20
>  	/* get SEC version capabilities from device tree */
>  	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
> @@ -3481,9 +3481,8 @@ static int talitos_probe(struct platform_device *of=
dev)
>  		stride =3D TALITOS2_CH_STRIDE;
>  	}
> =20
> -	err =3D talitos_probe_irq(ofdev);
> -	if (err)
> -		goto err_out;
> +	priv->irq[0] =3D irq0;
> +	priv->irq[1] =3D irq1;
> =20
>  	if (has_ftr_sec1(priv)) {
>  		if (priv->num_channels =3D=3D 1)
> @@ -3540,6 +3539,11 @@ static int talitos_probe(struct platform_device *o=
fdev)
>  		goto err_out;
>  	}
> =20
> +	/* enable interrupts once the channel fifos and tasklets are set up */
> +	err =3D talitos_probe_irq(ofdev);
> +	if (err)
> +		goto err_out;
> +
>  	/* register the RNG, if available */
>  	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
>  		err =3D talitos_register_rng(dev);

I guess to be 100% correct, IRQs could be masked at the beginning of probe
and unmasked at the end.

Thanks,
--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

