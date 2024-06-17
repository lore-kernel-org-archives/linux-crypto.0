Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C019A29C
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718631338; cv=none; b=G4kDp13BuEQKr3w1tihvg/N3Ry/L1FawWCy8cQYACL73TtCtzlQxvGidsN6RD1kklG6YkjOE0hCDLJ0Hc/tAvtD83UsZV6znGOy8dG1oFdrmt1WVdSYAWB/LhwqR5hdeCbWQiJkLtk8A2fHzcG9rAfO56YeUk6ilVk49mlfHRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718631338; c=relaxed/simple;
	bh=UW0K7OnxFw7coHLlJ/M2EFOknoQqVivuNqXp7vWTkig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vck7FLtHFpNNoQC+npkmHtYjJ9HI5J9ekn2Qgr+4jIfwhMctAx+ERWWrEnVIuOKCQph0x0rtUUCvLwXDwXToQR6e2/KvFGMHEe4TqZv5L0sVjNN2dIm2AWiqYmLnJhcTo++t1FRau4ZydZvZx6wVRr4VqI4SxZ2qHzjIGD0A6m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=HfgEh9AT; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="HfgEh9AT"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52bc3130ae6so4880304e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 06:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1718631334; x=1719236134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPY+WCVSrJT8VM7qgQG/Zm8TWRZMOaoIrmbsekr+mBw=;
        b=HfgEh9ATnIJWWCqbv7gNzJt/vS/5j6q7hRK8j4pv6JAa3xRtOdgbNZcNuR2ogXhhEo
         3DrFH00xttGLbq4ugiEAanQ8SkW6jiCQ50nka0NBoFiWeanlkGp99JKIOL/3wEKNAvGt
         a/uDTKykJXBDnGwxyufCD9aAx4YGSgf1CGK6sAuU3aYJaPWvlklrj4DupyTAMeclot+u
         ZIGfqsYBXj+R/YzSScK9zkye14sM85pUQBG6ncO+vmKVKSCHkURtUHIa2v9TiZXU+oBB
         5/01w/N6ubf8oTsZyjY4iF9VO2qtzrAa8f6+6Ihd5mQn6GQ2XzAXwn/VPOhlc0Gtobzv
         3okQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718631334; x=1719236134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPY+WCVSrJT8VM7qgQG/Zm8TWRZMOaoIrmbsekr+mBw=;
        b=GhxdgaCx38pZ2WHjb2LzawOC2Xz39sqI6MGhza38MZ+EeYRmZ2T2YxhuJ5TTY7uXv1
         ARqbET/HDo9x5cGGPaQ/6GFyjLcI/1cEK6w7p0IIhZm1qTbA393K4hUjreNgCrgWjPYi
         T1NGGymmo33jBNMEWRfm6yo7k1NC5aG6/xhW6CGhEhOpVh0jiclK1GdV7TjJGAEzLwlH
         Tvgca+u4cBybt5nf/chYBo1mOayHQbnX8t/9Ztwt+99a3BBO7ecU/7We67NC4dECFNcS
         aDiVCINzL5b22uuwtb/43gOyR5YgL2G9rAFVxJMGJj6iex8plVx9WNFyG5lK+2L52D9N
         9TRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX6x8MQivTiV0n6YWfR7TD9hiFkIre0vk4tWEXa1qsEwF54342B3Nj4etZY2RVPt/Nw4SUanNP8wJ/z7J7dEG56iaRskenoZEKrZhO
X-Gm-Message-State: AOJu0YyZF2fnrgti2+vV+PSdFCx3YMwaToqrXflqo4aPoD3QF9tuVGXg
	Rgj06ZQqFwDpEptS4+OBbE8IGZQXSzNC6sWVF02RXFHM251O6zJXN5EhZ4N+NXwMuFQmo+nTS66
	EyWdrgpQXOpFN19z7GU38pM42TizwffhLZbR4qQ==
X-Google-Smtp-Source: AGHT+IGNef2oy5EzQBryr4JeW6jN39RtowdpZCXWHCeUZk9/ye+Jt2EZsh2sGNKB2+aJkjldb55ayidiJ0ctyrWPOw8=
X-Received: by 2002:a05:6512:4886:b0:52c:2b7a:ad51 with SMTP id
 2adb3069b0e04-52ca6e6d84amr5352044e87.37.1718631334338; Mon, 17 Jun 2024
 06:35:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605161851.13911-1-kabel@kernel.org> <20240605161851.13911-7-kabel@kernel.org>
 <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
 <CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com>
 <20240617105614.009be8cc@dellmb> <CAMRc=MfB26+CArmu6tHVkpA16OD6_b45FHr2WgzPh45KcdFc2A@mail.gmail.com>
 <CAHp75VcMzZnKi6WUoiSgky5fsvt77FuPr6XZ+X=AD+i_2JzP3Q@mail.gmail.com> <20240617133400.3e4d2910@dellmb>
In-Reply-To: <20240617133400.3e4d2910@dellmb>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 17 Jun 2024 15:35:23 +0200
Message-ID: <CAMRc=McrXn99TXZtYokMdMOVw-BoY7HovRoF+Bb53we-Ha2VGQ@mail.gmail.com>
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 1:34=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.org>=
 wrote:
>
> On Mon, 17 Jun 2024 12:42:41 +0200
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>
> > On Mon, Jun 17, 2024 at 11:07=E2=80=AFAM Bartosz Golaszewski <brgl@bgde=
v.pl> wrote:
> > > On Mon, Jun 17, 2024 at 10:56=E2=80=AFAM Marek Beh=C3=BAn <kabel@kern=
el.org> wrote:
> > > > On Mon, 17 Jun 2024 10:38:31 +0200
> > > > Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > > > On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
> > > > > <andy.shevchenko@gmail.com> wrote:
> > > > > > On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@=
kernel.org> wrote:
> > > > > > >
> > > > > > > Add support for true random number generator provided by the =
MCU.
> > > > > > > New Omnia boards come without the Atmel SHA204-A chip. Instea=
d the
> > > > > > > crypto functionality is provided by new microcontroller, whic=
h has
> > > > > > > a TRNG peripheral.
> > > > > >
> > > > > > +Cc: Bart for gpiochip_get_desc() usage.
> >
> > ...
> >
> > > > > > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_=
TRNG)];
> > > > > > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_=
idx));
> > > > > > > +       if (irq < 0)
> > > > > > > +               return dev_err_probe(dev, irq, "Cannot get TR=
NG IRQ\n");
> > > > > >
> > > > > > Okay, it's a bit more complicated than that. The gpiochip_get_d=
esc()
> > > > > > shouldn't be used. Bart, what can you suggest to do here? Openc=
oding
> > > > > > it doesn't sound to me a (fully) correct approach in a long ter=
m.
> > > > >
> > > > > Andy's worried about reference counting of the GPIO device. Maybe=
 you
> > > > > should just ref the GPIO device in irq_request_resources() and un=
ref
> > > > > it in irq_release_resources()? Then you could use gpiochip_get_de=
sc()
> > > > > just fine.
> > > >
> > > > But this is already being done.
> > > >
> > > > The irqchip uses GPIOCHIP_IRQ_RESOURCE_HELPERS macro in its definit=
ion:
> > > >
> > > >   static const struct irq_chip omnia_mcu_irq_chip =3D {
> > > >     ...
> > > >     GPIOCHIP_IRQ_RESOURCE_HELPERS,
> > > >   };
> > > >
> > > > This means that gpiochip_irq_reqres() and gpiochip_irq_relres() are
> > > > used as irq_request_resources() and irq_release_resources().
> > > >
> > > > The gpiochip_reqres_irq() code increases the module refcount and ev=
en
> > > > locks the line as IRQ:
> > > >
> > > >   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/gpio/gpiolib.c?h=3Dv6.10-rc4#n3732
> > >
> > > Andy: what is the issue here then exactly?
> >
> > The function in use is marked as DEPRECATED. If you are fine with its
> > usage in this case, I have no issues with it.
> > If you want it to be replaced with the respective
> > gpio_device_get_desc(), it's fine, but then the question is how
> > properly get a pointer to GPIO device object.
> >
>
> Aha, I did not notice that the function is deprecated.
>
> What about
>
>   irq =3D gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));
>
> ?
>
> Note: I would prefer
>   irq_create_mapping(mcu->gc.irq.domain, irq_idx)
> since the irq_idx line is not a valid GPIO line and at this part of
> the driver the fact that the IRQs are provided through a gpiochip are
> semantically irrelevant (we are interested in "an IRQ", not "an IRQ from
> a GPIO").
>
> Marek

The reason to deprecate it was the fact that it's dangerous to use
from outside of the GPIO provider code. I actually plan to soon make
this function private to gpiolib, there's just one pinctrl driver left
to convert.

So maybe it's better to not use it here. Please keep in mind that
gpio_device_get_desc() doesn't increase the reference count of
gpio_device so you need to make sure it stays alive. But it seems to
be the case here as you're within the driver code still.

Bart
