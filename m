Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBA1191461
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718624047; cv=none; b=SPKO6qasM52sEr5Wur8Ib46itN/4SllfJbF2gXv5vb1EK+AOTeHNig+f3RNaZe3GqzFpqaolfa1hEv7VfPI8ylxyVEmwilSi4AoLEvVK3pv9wYCEAHfP6QGKts1XQbNNEZX21woqcvt5jO0rP34TnHCYFP4nHd+H9GhdZx5YX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718624047; c=relaxed/simple;
	bh=ZSGNI1iJSZC37XqcitctPL3f0TlGNuf93YRTJTPLDeU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crQrcniJVEujHc34MKpNugbYUOo3uDitf7YT+BBt/i2Zw2Dix5Xlu5+hEMDPg9SB3awpp1UDtAJssGYjX1kmxjMz2Z/ZsmArY3wEMQGw3rr1uWTnE6d2wgU0FBmDkUqsq8xf1s+srKlUdDnYZekvvCq8exgJTwQItvD0z5Wuq7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfFPKqwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfFPKqwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FA8C2BD10;
	Mon, 17 Jun 2024 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718624046;
	bh=ZSGNI1iJSZC37XqcitctPL3f0TlGNuf93YRTJTPLDeU=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=dfFPKqwm6FLfQW++l80JZoaBrzq9ftA4ojIAGlHmPQFrJicz9fPUnhGISzPSRagt/
	 zfw68JbT7RZRAFPDRFUwHUFR0dwdyi8bS2oI5UN+6YDR5/Ro+iObycnP+JH7hKz6B/
	 RRMPhDAIB4jXOdKeDZERG1gMiWF63KGJMhbBcp5l9MBLXPKSZjs5tazz1GNGoGXfND
	 XmUvElVNuVsqSm7brORS+zhGkrSkAG0MRWsB3T9mGJrs1knpVIhvNQYc98plRTbYcR
	 +OfIwVszjfffoh5c2iR4Gypmh6bbHsp+/kLqloESD6ltUN1Xg+QiNyO22+TQ4OB9cr
	 7potbWXgxMnDA==
Date: Mon, 17 Jun 2024 13:34:00 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>,
 soc@kernel.org, arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de
 Goede <hdegoede@redhat.com>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240617133400.3e4d2910@dellmb>
In-Reply-To: <CAHp75VcMzZnKi6WUoiSgky5fsvt77FuPr6XZ+X=AD+i_2JzP3Q@mail.gmail.com>
References: <20240605161851.13911-1-kabel@kernel.org>
	<20240605161851.13911-7-kabel@kernel.org>
	<CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
	<CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com>
	<20240617105614.009be8cc@dellmb>
	<CAMRc=MfB26+CArmu6tHVkpA16OD6_b45FHr2WgzPh45KcdFc2A@mail.gmail.com>
	<CAHp75VcMzZnKi6WUoiSgky5fsvt77FuPr6XZ+X=AD+i_2JzP3Q@mail.gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Jun 2024 12:42:41 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Mon, Jun 17, 2024 at 11:07=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> > On Mon, Jun 17, 2024 at 10:56=E2=80=AFAM Marek Beh=C3=BAn <kabel@kernel=
.org> wrote: =20
> > > On Mon, 17 Jun 2024 10:38:31 +0200
> > > Bartosz Golaszewski <brgl@bgdev.pl> wrote: =20
> > > > On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
> > > > <andy.shevchenko@gmail.com> wrote: =20
> > > > > On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@ke=
rnel.org> wrote: =20
> > > > > >
> > > > > > Add support for true random number generator provided by the MC=
U.
> > > > > > New Omnia boards come without the Atmel SHA204-A chip. Instead =
the
> > > > > > crypto functionality is provided by new microcontroller, which =
has
> > > > > > a TRNG peripheral. =20
> > > > >
> > > > > +Cc: Bart for gpiochip_get_desc() usage. =20
>=20
> ...
>=20
> > > > > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TR=
NG)];
> > > > > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_id=
x));
> > > > > > +       if (irq < 0)
> > > > > > +               return dev_err_probe(dev, irq, "Cannot get TRNG=
 IRQ\n"); =20
> > > > >
> > > > > Okay, it's a bit more complicated than that. The gpiochip_get_des=
c()
> > > > > shouldn't be used. Bart, what can you suggest to do here? Opencod=
ing
> > > > > it doesn't sound to me a (fully) correct approach in a long term.=
 =20
> > > >
> > > > Andy's worried about reference counting of the GPIO device. Maybe y=
ou
> > > > should just ref the GPIO device in irq_request_resources() and unref
> > > > it in irq_release_resources()? Then you could use gpiochip_get_desc=
()
> > > > just fine. =20
> > >
> > > But this is already being done.
> > >
> > > The irqchip uses GPIOCHIP_IRQ_RESOURCE_HELPERS macro in its definitio=
n:
> > >
> > >   static const struct irq_chip omnia_mcu_irq_chip =3D {
> > >     ...
> > >     GPIOCHIP_IRQ_RESOURCE_HELPERS,
> > >   };
> > >
> > > This means that gpiochip_irq_reqres() and gpiochip_irq_relres() are
> > > used as irq_request_resources() and irq_release_resources().
> > >
> > > The gpiochip_reqres_irq() code increases the module refcount and even
> > > locks the line as IRQ:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/gpio/gpiolib.c?h=3Dv6.10-rc4#n3732 =20
> >
> > Andy: what is the issue here then exactly? =20
>=20
> The function in use is marked as DEPRECATED. If you are fine with its
> usage in this case, I have no issues with it.
> If you want it to be replaced with the respective
> gpio_device_get_desc(), it's fine, but then the question is how
> properly get a pointer to GPIO device object.
>=20

Aha, I did not notice that the function is deprecated.

What about

  irq =3D gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));

?

Note: I would prefer
  irq_create_mapping(mcu->gc.irq.domain, irq_idx)
since the irq_idx line is not a valid GPIO line and at this part of
the driver the fact that the IRQs are provided through a gpiochip are
semantically irrelevant (we are interested in "an IRQ", not "an IRQ from
a GPIO").

Marek
