Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5661D18FC62
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718615264; cv=none; b=uT5G6gvknjemiUMgh5eXWj9xIB918L8RfwQDcSp3kumihckupmXyeQ+u+4L3ZjyOk4U1tql4+HZPl1QXpM+OUgW033PrlqgVrrgoImpy5DaX56qaK/LjYsuCsVD2eKaXjnckVUSRNzXdAf5QYJaVel2mhWHdkNrjsFQ5nQC4vuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718615264; c=relaxed/simple;
	bh=B+/uZWQAP1l+QGZXjj0WXBCBcalsz16qKQkjR1npe1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=APOp7mngjZPmiRU2ynFi1gt/61gbztCdkJXSbAnYR6atyTYzdRRMgw+MGPqPPkRwk2Tm80nMrz2THfkFL4CXnYsTOqzn4nr1MgB3nB0nk/IFv6Zuij9QVNx1PbCIxrT8z3vDXfhRXRJ4guq+A4E0dn8RTHkYOGz0d62emMSqyFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=YfZQpw0l; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="YfZQpw0l"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eadaac1d28so44337701fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 02:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1718615260; x=1719220060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lx+2LB1DyYdaX0uEWLJbcZAfd2gRgzXYA8uTQQWgnm8=;
        b=YfZQpw0lrh5twXA3RXOhtpLlOxeuzcDTe93x615EXbG+FTj4uWwCoKrGmgA2UMCP9u
         KZbWrQl8Bo1R/8MZRRYQGIe4YkeURuRhQweEOzKtaYKJ6+60mtW/NXRG3WyTaXgra4Sw
         sevWlfYRCCrDcam+Qd/7/Dx6tWbyGUiCOgDOF6rJTt9n/+PyWiQpLrlmgJwp9FJMnbJ0
         MxkhGXpW/p2EM7K3xFlLaMfv3f3kSBgOl9ciz+Xi9DBiBP6TFiRJjViE63Sx97F/g8hl
         nZbr0udnb0/n4mvGlY2V1T51BggaN+sE2uXhe4MDHbF1V/WFAI5fNND4ukPnXiIVcac3
         mhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718615260; x=1719220060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lx+2LB1DyYdaX0uEWLJbcZAfd2gRgzXYA8uTQQWgnm8=;
        b=SbdVxcviDevL5YJz0ifYotsnIpSrt47wdL5r/HmET83dd4QHOLtMAluGHQGjnMm36q
         hhOgZgnwLe8yTSju0WEOziUIfkjDzk+Bh45eGxSCZYrs46HDdCZftEAnb2L6dLk3kJrH
         njADYGxlK+AGkfIZSR5WjPYNIegX2/TcpC3SSU/Bt6MNzuD/CoxuXVVfD1aVHSpGEsLU
         0N1fmyA81czPoe5XMAmboRC8VuOfOz7e3976pfho2MTEM7dlL2QvLSKw6a6WRyLTwVed
         PKGrHLcabmgo5mf1sKUXMyFhlktUD5a0ggioBAYBC+Etr6I+GVdVmX3J5TgOEH3sa84y
         p+iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs0Ozc3hPPIRufpjLT3DKlknryeVCeaEJGvsromVUw5vCVecc+TRNBa41sdsEYO6GUX/Z8jICKQOhJddpEXYY5SoUzV6kY1d8Bdtki
X-Gm-Message-State: AOJu0YyAZJH5KL1eqFIokhlzD0ZzH1U5KUGve5ZsFEbvEMrhJyQZFJft
	139RI7yneiOw3h563XhU1jwmjnFTPXnQNVb0eFJAWhdWj+GAYoVSJPGkLkWCuodS/cgkbUKkUGD
	ftuPA+PTDkCPR9Vch7d3658Cc5KdXT70OYr/dvA==
X-Google-Smtp-Source: AGHT+IFj6tIFtHkHrgkmpfqmirXSdUPag0786JMFxBaMI+9HbXB6HmvVH08NUGItXvvzIa1tjVugd9Ed4pCCeDgRCqk=
X-Received: by 2002:a2e:84c7:0:b0:2eb:d8d2:f909 with SMTP id
 38308e7fff4ca-2ec0e46deffmr65434411fa.16.1718615260493; Mon, 17 Jun 2024
 02:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605161851.13911-1-kabel@kernel.org> <20240605161851.13911-7-kabel@kernel.org>
 <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
 <CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com> <20240617105614.009be8cc@dellmb>
In-Reply-To: <20240617105614.009be8cc@dellmb>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 17 Jun 2024 11:07:29 +0200
Message-ID: <CAMRc=MfB26+CArmu6tHVkpA16OD6_b45FHr2WgzPh45KcdFc2A@mail.gmail.com>
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 10:56=E2=80=AFAM Marek Beh=C3=BAn <kabel@kernel.org=
> wrote:
>
> On Mon, 17 Jun 2024 10:38:31 +0200
> Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> > On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > >
> > > On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel=
.org> wrote:
> > > >
> > > > Add support for true random number generator provided by the MCU.
> > > > New Omnia boards come without the Atmel SHA204-A chip. Instead the
> > > > crypto functionality is provided by new microcontroller, which has
> > > > a TRNG peripheral.
> > >
> > > +Cc: Bart for gpiochip_get_desc() usage.
> > >
> > > ...
> > >
> > > > +#include <linux/bitfield.h>
> > > > +#include <linux/completion.h>
> > >
> > > + errno.h
> > >
> > > > +#include <linux/gpio/consumer.h>
> > > > +#include <linux/gpio/driver.h>
> > > > +#include <linux/hw_random.h>
> > > > +#include <linux/i2c.h>
> > > > +#include <linux/interrupt.h>
> > > > +#include <linux/minmax.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/string.h>
> > >
> > > > +#include <linux/turris-omnia-mcu-interface.h>
> > >
> > > As per other patches.
> > >
> > > > +#include <linux/types.h>
> > > > +
> > > > +#include "turris-omnia-mcu.h"
> > >
> > > ...
> > >
> > > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)]=
;
> > > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > > +       if (irq < 0)
> > > > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ=
\n");
> > >
> > > Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> > > shouldn't be used. Bart, what can you suggest to do here? Opencoding
> > > it doesn't sound to me a (fully) correct approach in a long term.
> > >
> >
> > Andy's worried about reference counting of the GPIO device. Maybe you
> > should just ref the GPIO device in irq_request_resources() and unref
> > it in irq_release_resources()? Then you could use gpiochip_get_desc()
> > just fine.
>
> But this is already being done.
>
> The irqchip uses GPIOCHIP_IRQ_RESOURCE_HELPERS macro in its definition:
>
>   static const struct irq_chip omnia_mcu_irq_chip =3D {
>     ...
>     GPIOCHIP_IRQ_RESOURCE_HELPERS,
>   };
>
> This means that gpiochip_irq_reqres() and gpiochip_irq_relres() are
> used as irq_request_resources() and irq_release_resources().
>
> The gpiochip_reqres_irq() code increases the module refcount and even
> locks the line as IRQ:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/gpio/gpiolib.c?h=3Dv6.10-rc4#n3732
>
> Marek

Andy: what is the issue here then exactly?

Bart
