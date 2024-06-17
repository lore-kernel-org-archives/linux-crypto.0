Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44D190672
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 08:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718614580; cv=none; b=tKYqWYAyYADtxLoR2NdTLkwE95P6AqpD++6U75nC/s/nxoKM/k1S+83tX1MXTNP1UYCJF2XOnNCfDuATOE7F+DYAtiXjXQDv+yVhoWKR7FyKxpQ78GrXbKUTfDFfab1K/uWi1pyP9/YT9x52g632Zl3TWNroEpe6rG6GdjBchtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718614580; c=relaxed/simple;
	bh=7O0g2l1Jt/mWEIOTC5VRVrbrcyYd0XeiqSS5n8FpnTg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsSTrunF4ozqkDoXwPogd3/1X12nnyh2jRc3jWvYZZKCRH4Sdv7yuEsDodEB2of4QZX32Rl+W4XleV6DlLVj5Lz0ROEWjcnIHehKbMspJIY9PXGEfms9N+sRm/MpyPNkLMgeEAb00F2+/WYDzHe9uxWKYhHOG2K+RIKP7zgFR1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+zltdtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+zltdtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF42CC2BD10;
	Mon, 17 Jun 2024 08:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718614580;
	bh=7O0g2l1Jt/mWEIOTC5VRVrbrcyYd0XeiqSS5n8FpnTg=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=E+zltdtAGLYTDffTjVeg+WXIdXvq+1KFJBA1B96lyzXSSldTzb/JEbTUITSW5xqvW
	 GWBgmMYA1fTyumXIRPrcIONcj88ZuFa2xgB3yQdn7GcXXZVj1VeKj9bl3QqB4hiGDB
	 zzWkTGLcNKufctgKQ91AZ0FQBHcbnbxBB48O9olIsjfSPqPEtf4Dd0eVpVCKooiWSD
	 jWVmKAUuzSDcTSX6HxSzjPhsEey2P5taMOQy1tqmh/jKDhuKRyzsWjdR/KaVYtJGre
	 1eubLmlNC5knNhgNGHItXR5eKKjGOzz8fdNLdhkJV7yOtpmq0Z9ommoBkxxoWo21XP
	 vi+p6Jsy3k6Zg==
Date: Mon, 17 Jun 2024 10:56:14 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>,
 soc@kernel.org, arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de
 Goede <hdegoede@redhat.com>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240617105614.009be8cc@dellmb>
In-Reply-To: <CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com>
References: <20240605161851.13911-1-kabel@kernel.org>
	<20240605161851.13911-7-kabel@kernel.org>
	<CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
	<CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Jun 2024 10:38:31 +0200
Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.o=
rg> wrote: =20
> > >
> > > Add support for true random number generator provided by the MCU.
> > > New Omnia boards come without the Atmel SHA204-A chip. Instead the
> > > crypto functionality is provided by new microcontroller, which has
> > > a TRNG peripheral. =20
> >
> > +Cc: Bart for gpiochip_get_desc() usage.
> >
> > ...
> > =20
> > > +#include <linux/bitfield.h>
> > > +#include <linux/completion.h> =20
> >
> > + errno.h
> > =20
> > > +#include <linux/gpio/consumer.h>
> > > +#include <linux/gpio/driver.h>
> > > +#include <linux/hw_random.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/minmax.h>
> > > +#include <linux/module.h>
> > > +#include <linux/string.h> =20
> > =20
> > > +#include <linux/turris-omnia-mcu-interface.h> =20
> >
> > As per other patches.
> > =20
> > > +#include <linux/types.h>
> > > +
> > > +#include "turris-omnia-mcu.h" =20
> >
> > ...
> > =20
> > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > +       if (irq < 0)
> > > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n=
"); =20
> >
> > Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> > shouldn't be used. Bart, what can you suggest to do here? Opencoding
> > it doesn't sound to me a (fully) correct approach in a long term.
> > =20
>=20
> Andy's worried about reference counting of the GPIO device. Maybe you
> should just ref the GPIO device in irq_request_resources() and unref
> it in irq_release_resources()? Then you could use gpiochip_get_desc()
> just fine.

But this is already being done.

The irqchip uses GPIOCHIP_IRQ_RESOURCE_HELPERS macro in its definition:

  static const struct irq_chip omnia_mcu_irq_chip =3D {
    ...
    GPIOCHIP_IRQ_RESOURCE_HELPERS,
  };

This means that gpiochip_irq_reqres() and gpiochip_irq_relres() are
used as irq_request_resources() and irq_release_resources().

The gpiochip_reqres_irq() code increases the module refcount and even
locks the line as IRQ:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/gpio/gpiolib.c?h=3Dv6.10-rc4#n3732

Marek
