Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3E7194AE3
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717677439; cv=none; b=bYvyaY+DZ3uUHq+xuyyjDiESKT3cEV1j2ojDuGhMvAbT96sXJEN1UgRGXH99v16yBFKfCpErIH/oX7wuQKlm2TRqnOZVgqPHe1AV3QQeBuwLx9yhUJ/RqivVbZjs8EnTlxUEMmXHuz5umPKnlA2xMWK2dzgpuhRTegXef7wtSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717677439; c=relaxed/simple;
	bh=HbWT6OYIoSMUdqEwFQCigxt9BAs94whDX4VRszXZAK4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1M+GE9qkcxDBQ+nXQwdpSKRBf35vI9d63g/WrfQbOaXuSXrAISdUUcpo40sNSlLFj8lA20UM3dCISd5U6d9aaYs7mUzH/ZBRJWQvk/7kiilRQCr30vnZcu3orVZdlh8J9hiFY+5EYPxbxuQ5+5xUuHsv7csQDai3vmGpbMY9kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQccY+ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQccY+ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023C2C4AF08;
	Thu,  6 Jun 2024 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717677438;
	bh=HbWT6OYIoSMUdqEwFQCigxt9BAs94whDX4VRszXZAK4=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=gQccY+ewYZ9OHq/FOFWHIatCTpmuuNfakUNTLpbzz1a1XQ6WAS3HMlq4NK3goUqLG
	 /EqwCMEDm8PanYBKvvdYg+14/Hnkh1BI4ahyRvNnk6kJBsa/4c3Sdm90R3JSVcBPTf
	 MsO0Ifak7hYWZ43G0XgdvRWoJHNAj0GWdh2BUxpV9S9hlU6idtZ2354u4lN2ZY5cEm
	 +Lw4kl2KV1HpkJ5iynjEuG3M/oN4l/aRa0XK/NJPPJi6IaqRDuhDZXS3jP8bvdsiKa
	 xe/21JIyoonhpVBTuoXFV/FqnwxmZroxe1KV7eV1hZ6Rb6GGO8Jz+GM+xnmjEouPmF
	 bdxIr+3TDj93g==
Date: Thu, 6 Jun 2024 14:37:12 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>,
 soc@kernel.org, arm@kernel.org, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Olivia Mackall
 <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240606143712.6b834d7c@dellmb>
In-Reply-To: <ZmGLPW6vUqOFEK4j@smile.fi.intel.com>
References: <20240605161851.13911-1-kabel@kernel.org>
	<20240605161851.13911-7-kabel@kernel.org>
	<CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
	<20240606105308.3e02cf1e@dellmb>
	<ZmGLPW6vUqOFEK4j@smile.fi.intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Jun 2024 13:11:09 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Thu, Jun 06, 2024 at 10:53:08AM +0200, Marek Beh=C3=BAn wrote:
> > On Wed, 5 Jun 2024 22:00:20 +0300
> > Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> >  =20
> > > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> > > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > > +       if (irq < 0)
> > > > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ=
\n");   =20
> > >=20
> > > Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> > > shouldn't be used. Bart, what can you suggest to do here? Opencoding
> > > it doesn't sound to me a (fully) correct approach in a long term. =20
> >=20
> > Note that I can't use gpiochip_request_own_desc(), nor any other
> > function that calls gpio_request_commit() (like gpiod_get()), because
> > that checks for gpiochip_line_is_valid(), and this returns false for
> > the TRNG line, cause that line is not a GPIO line, but interrupt only
> > line.
> >=20
> > That is why I used
> >   irq =3D irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> > until v7, with no reference to gpio descriptors, since this line is not
> > a GPIO line.
> >=20
> > We have discussed this back in April, in the thread
> >   https://lore.kernel.org/soc/20240418121116.22184-8-kabel@kernel.org/
> > where we concluded that
> >   irq =3D gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> > is better... =20
>=20
> That's fine to not use other APIs, the problem here is with reference cou=
nting
> on the GPIO device. The API you could use is gpio_device_get_desc(). But =
you
> need to have a GPIO device pointer somewhere in your driver being availab=
le.

Rewriting to gpio_device_get_desc() is simple, since
  gpiochip_get_desc(gc, hwnum)
is equivalent to
  gpio_device_get_desc(gc->gpiodev, hwnum)

Obviously neither of these take care of reference counting. But what
reference counting are you talking about?
Is it the
  try_module_get(desc->gdev->owner)
in gpiod_request()?
Or are we talking only about the FLAG_REQUESTED flag on the descriptor
flags? (This one should not be needed since the GPIO line cannot be
requested, becuase it is not a valid GPIO line.)

Since the line is not a valid GPIO line, I thought that we don't need
to refcount in GPIO code. gpiod_to_irq() will call the gpiochip's
.to_irq() method, which will call gpiochip_to_irq(), which will call
irq_create_mapping()
  gpiod_to_irq()
    gpiochip_to_irq()
      irq_create_mapping()

Then on gpiochip removal, the gpiochip_irqchip_remove() manually
disposes all IRQ mappings with irq_dispose_mapping().

Marek
