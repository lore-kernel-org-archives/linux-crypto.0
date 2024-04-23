Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C513217
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889977; cv=none; b=dDE5DUK2IV5ktsv4pG2/phO5JV1uI63RDZnzYL1BpBuzxnTVzWTZ5TeyLkz7JQU6spCpkmffQR4KRiUqHqEB+Na90Lc0PGBiY9wLRD/B62KHh2+lZ6waBeyvwb++JvTrJTfWuh7mnmIkWNaWY9bBTEJnR2GKx8A/TLrOyfSrwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889977; c=relaxed/simple;
	bh=Me1MiIwDSiRo4TXmDOcSQJGJ8gYkeYRCW6xsRrmX9T0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWcpieS57PKWQ18hRD5v4g4NNK3WKJodKpVK4I/74LGjoxry1TeO2NC/XvkwnS5RHu53U4KguJ9WNtUZ6Z44vWb4cV7s5Rdo5u8IQg0yFEEaRPqCBY6WrsA0VMVeV2dNWmwX2Dcn16LOM0li3F2HtS/apE+TCEMq4FUFncFswG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6bvRFub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6bvRFub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE4C116B1;
	Tue, 23 Apr 2024 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713889977;
	bh=Me1MiIwDSiRo4TXmDOcSQJGJ8gYkeYRCW6xsRrmX9T0=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=A6bvRFubDq/QplV53zNBVqI2+qKeIvR6VWBREohWyLoH3Td2B9OjZaJA5ITbibRPc
	 xHhwiFkm841mDUB6prl7ylhuJ8viEBnp3CHenlIWOtEGl0za0Lk8s9P2znJWEPtZF1
	 AdRrqbgU/2HYAE9/HHsM9H5NGod7TNH3XmXzTCLikPHdookIDmPm48iiH5nTOw7Bni
	 flFGBB/1DSbwUYDKud4hM36cJ9rDGQAIl/XlLe5mCAGBA3jAzYI4pV/Au283O3Yp+d
	 W0//2c1prPAgevdgtrMa3EuXDmJ9Ti2dDHAy4vqzZlGWObw7f8Mi779ky7bEi5+2j1
	 1vbeJGn1exYpg==
Date: Tue, 23 Apr 2024 18:32:25 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240423183225.6e4f90a7@thinkpad>
In-Reply-To: <Zifamxfa18yjD_VS@smile.fi.intel.com>
References: <20240418121116.22184-1-kabel@kernel.org>
	<20240418121116.22184-8-kabel@kernel.org>
	<Zifamxfa18yjD_VS@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2024 18:58:19 +0300
Andy Shevchenko <andy@kernel.org> wrote:

> On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Beh=C3=BAn wrote:
> > Add support for true random number generator provided by the MCU.
> > New Omnia boards come without the Atmel SHA204-A chip. Instead the
> > crypto functionality is provided by new microcontroller, which has
> > a TRNG peripheral. =20
>=20
> ...
>=20
> > +int omnia_mcu_register_trng(struct omnia_mcu *mcu)
> > +{
> > +	struct device *dev =3D &mcu->client->dev;
> > +	int irq, err;
> > +	u8 irq_idx;
> > +
> > +	if (!(mcu->features & FEAT_TRNG))
> > +		return 0; =20
>=20
> > +	irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > +	irq =3D devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> > +	if (irq < 0)
> > +		return dev_err_probe(dev, irq, "Cannot map TRNG IRQ\n"); =20
>=20
> This looks like some workaround against existing gpiod_to_irq(). Why do y=
ou
> need this?

Hmmm, I thought that would not work because that line is only valid
as an IRQ, not as a GPIO (this is enforced via the valid_mask member of
gpio_chip and gpio_irq_chip).

But looking at the code of gpiolib, if I do
  irq =3D gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
the valid_mask is not enforced anywhere.

Is this semantically right to do even in spite of the fact that the
line is not a valid GPIO line?

Marek
