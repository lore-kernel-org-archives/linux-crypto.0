Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C740194C7C
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718621002; cv=none; b=rLgHf877MHz3bIMIOdD/hPGcTXjT1RUYabzsSr5rQ/WCPnLpgmazzkAtbjZzZh+ECbbnI0fGHBH7cHv3LooHu+5ZistF/vur9ielc21/vtQmNIw3HwsX7oNC08oGKALZOKfRm+MlDEpsfKLRHQY6sNzLtr7pajOVeJP71Y4Eou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718621002; c=relaxed/simple;
	bh=n1hVPrJtHesRrjLbNjFMSgnDJvOTYS3aRJID624P+xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9lk5mt9l4KInYmw5+nY62cSXD5D48BS94+zWf3heZ6BY34Kz3Zs8ZQxkEWNz5m+84EoitYz2n99gvfLnYmCjW7erJUAJpTgVctDdam52HDZPRT+DgEDZ/PfY4lMWn0nlSX/l/0VH9BCkJEy2zAGMfzP5ahZUB+Xm7/FOOo4NF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SPcMNNqL; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SPcMNNqL"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57cc1c00b97so2960330a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 03:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718620999; x=1719225799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yG/uu801c17jNBp3Q6D+uIgxb2+x0+IM8usXqGLPPp0=;
        b=SPcMNNqLQMuxEH2G0qrFN28wya5fxDyn9UAqbOrHmALhVRzgVRcIF/vujeEjp0Z9RF
         Y94p1TWvZ8/dDjIMzLkpDWAknuUQo78uzzp4hisAzl6v8lTIZUagwA6PS+pVBISgH8vj
         OW/leQ8VHewLCk0/XWbTyidd2NU8wSCvkM3ADF+WA+BZaU7HlTPMEuluAzzUko4bTIsA
         SMR9TeTdK8bk7uLJFZU6FiQSKWeMLOQkr+5V3XQEWwGuSkeTsq+G1qfBa/gNUePUZqpE
         muIk4eaKNtwmYLRqGSk4aTbDE9nwcS0UKYohK4b8v2+NW0DFwFF7O5276j0GVTM0dl4R
         IqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718620999; x=1719225799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yG/uu801c17jNBp3Q6D+uIgxb2+x0+IM8usXqGLPPp0=;
        b=laukElcDoCUfa//aKwdm4aYOFRPrFa5D8LN2975fhPAQrRPvOABpw/t8ZrWCIsh2eL
         EG5LoOwQdxcJb92GReZRgjLVuwhXSEpyvlrjl6sD4amwP1jhjjpPfyCPCDOFXdpRMtOY
         +M3yqqOFxL+HhV5hIG2AS8e6GKDRTj8mjTSJoTdUvi/SURoTwcc34Y82YDmoY5jXyRzF
         iuKUdxmRhJu1lvuytwbrfZrNtlFhnxgsEbt6ZM4aIri8RkWOBybDkPwykRnyiSb3aD6p
         s9Inq22TByFo/1uHzSO0SoT+hSkOIguQYmK7texSJw/XlU0GsnJbMfjdIwVQ1atfYlnt
         YYeA==
X-Forwarded-Encrypted: i=1; AJvYcCW0QE/OrM3TgP/CIue6i1EmDV5pi3dlhjw24Qx7lkLO4JrPXBkWbNoFwgLOTFWEY7IdhapSAYMYDensIuUS4ZcQM2KbfqnAUHktQJkS
X-Gm-Message-State: AOJu0YxKKDSiEH0ZS+HQqCgza7vikS3QHkjpbkzZRYUgLulU3ky0UV2W
	bCFtVl1l1lj2fTUhqJXMLpDTbG/3quFVnvc2Pun+N3+Fesv/FsCgRVFHNuS2IKDe/nbA9yWa0aC
	7kCZYJP5Sb+TuOdOHXIACDSRY9qE=
X-Google-Smtp-Source: AGHT+IH3dyn+P+21hwIcjrDsuqyVWL/3oMGnmFJ2srgeI0E6Fu7TNJjmqBkWwOUFKFtWA6pamBGK/q5YkrVv2WwVhIs=
X-Received: by 2002:a17:906:b350:b0:a6e:f6b0:c49d with SMTP id
 a640c23a62f3a-a6f60d4294cmr577390066b.34.1718620998405; Mon, 17 Jun 2024
 03:43:18 -0700 (PDT)
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
In-Reply-To: <CAMRc=MfB26+CArmu6tHVkpA16OD6_b45FHr2WgzPh45KcdFc2A@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 17 Jun 2024 12:42:41 +0200
Message-ID: <CAHp75VcMzZnKi6WUoiSgky5fsvt77FuPr6XZ+X=AD+i_2JzP3Q@mail.gmail.com>
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 11:07=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
> On Mon, Jun 17, 2024 at 10:56=E2=80=AFAM Marek Beh=C3=BAn <kabel@kernel.o=
rg> wrote:
> > On Mon, 17 Jun 2024 10:38:31 +0200
> > Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > > On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@kern=
el.org> wrote:
> > > > >
> > > > > Add support for true random number generator provided by the MCU.
> > > > > New Omnia boards come without the Atmel SHA204-A chip. Instead th=
e
> > > > > crypto functionality is provided by new microcontroller, which ha=
s
> > > > > a TRNG peripheral.
> > > >
> > > > +Cc: Bart for gpiochip_get_desc() usage.

...

> > > > > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG=
)];
> > > > > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx)=
);
> > > > > +       if (irq < 0)
> > > > > +               return dev_err_probe(dev, irq, "Cannot get TRNG I=
RQ\n");
> > > >
> > > > Okay, it's a bit more complicated than that. The gpiochip_get_desc(=
)
> > > > shouldn't be used. Bart, what can you suggest to do here? Opencodin=
g
> > > > it doesn't sound to me a (fully) correct approach in a long term.
> > >
> > > Andy's worried about reference counting of the GPIO device. Maybe you
> > > should just ref the GPIO device in irq_request_resources() and unref
> > > it in irq_release_resources()? Then you could use gpiochip_get_desc()
> > > just fine.
> >
> > But this is already being done.
> >
> > The irqchip uses GPIOCHIP_IRQ_RESOURCE_HELPERS macro in its definition:
> >
> >   static const struct irq_chip omnia_mcu_irq_chip =3D {
> >     ...
> >     GPIOCHIP_IRQ_RESOURCE_HELPERS,
> >   };
> >
> > This means that gpiochip_irq_reqres() and gpiochip_irq_relres() are
> > used as irq_request_resources() and irq_release_resources().
> >
> > The gpiochip_reqres_irq() code increases the module refcount and even
> > locks the line as IRQ:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/drivers/gpio/gpiolib.c?h=3Dv6.10-rc4#n3732
>
> Andy: what is the issue here then exactly?

The function in use is marked as DEPRECATED. If you are fine with its
usage in this case, I have no issues with it.
If you want it to be replaced with the respective
gpio_device_get_desc(), it's fine, but then the question is how
properly get a pointer to GPIO device object.

--=20
With Best Regards,
Andy Shevchenko
