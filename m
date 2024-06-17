Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1579917F5
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 08:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718613526; cv=none; b=f3gRRtJQ1dMMPqahlHL9BxSHfuQHZ6qG52r/slKgqQHDHnOCnBNa+xeVsH4EkDpUweEkvy3oSLsVBwoISh5Rs8IuQWAEB/eLaiuqzm2hwedYQtkzloQLhggezKz3hApw/fHZfh7lfNvMZYEQSGt3td4KcGZPfA5TKDLGwIu1aWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718613526; c=relaxed/simple;
	bh=QpIBUbFUwITybbgXDmAIghUybYCdLEwK0kT2XeOg9O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f1SzYDbv1iB8un/WrIjqLU85r1GBdskdP67Eah1HPErhSU31MKCUzzTI31nOk2D4gZ/ZQPfluXUj87Er+b4t+AaBf6KHRXCfIq5S+GtjJ/5F+G2NuqWUOmhLGvBhany2abzTsVzE4zQdqE73jfn1mYc6CjSdCiqCnz72xrTq11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=lavVrEu6; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="lavVrEu6"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52cc129c78fso63044e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 01:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1718613523; x=1719218323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thWfJ5vNt6k/FERjkc7rTQHov2e1QQhet46euWcD5F0=;
        b=lavVrEu6Dbtr+DFYxTb9Q3Uz+kWkYwxpnhYngGFyKOY8qzdXvpN49y96rIITsZn2Z4
         T+9VsnyAx1m4dlHCSGwmMKVGA/brTMxJ/t11M/mvYQYfj9i0f2rdguwSGs9RRmZFDoHh
         2aDXWUYGpJtui/upKn/7BAB87tauJio4i//Zwr1sgsKnNWf/hxCe5Y+mE+QxeyaPStAd
         4VwlpOaE1nfadLjvAxXAdO467vXyP6RnW/Fg2V0IhoX7nNedKkIoTthmICWA3+FzmT+e
         o0rOaBYbGGs/LWPv5sTZnXeiq/8FFoh2UA40ERrDteyM4yUNKSfTALDWoNczT9B/jByP
         MD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718613523; x=1719218323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thWfJ5vNt6k/FERjkc7rTQHov2e1QQhet46euWcD5F0=;
        b=QeR9qcpSmBwh7OgQ5l7D1iuSAF7kddQf63in5G9XHN8vggT6Em5e8IyhA4klo7rEOM
         StLnp4JcmTptOaMDQf/1OW8Myij7ajSKXKwLJYDXsP2eKL0KEWsaSwvxM0T+KSDrM30d
         VMeow283Y4+5fzyiFRSwUc9B4+PDRkydr1/R0Hk8I7l/uMcQwZaPQmaPcpR1BHVqkWt8
         kdcE4F3EkwmiX5bOonXxjtWrxp6ehMqnNzomE/wN/JQvzz3Om/TRuv7G4BEvjPzclbMC
         6DhQ74f+imVB8IpMYj2q2iYUIewZgrNAaS+7mV3MJ7fOD4cRE4I6cKu+McAAS/94fg5s
         DRcg==
X-Forwarded-Encrypted: i=1; AJvYcCVU0LzRJ+pK4kc+eNXrJHUthy3CP0Gu18JCSYiFuID9t6qQufN9gH5uHQwm4IBwb0MgC/1CIsGXA9UllDkdjB0PaNzMg9xv+v3gORdo
X-Gm-Message-State: AOJu0YxWihtEm2VRHF8Jl5dJpEeJFpa2YfIlVMR3UqgLNDjiDdu0Hmn6
	fFcGwYYqPOtGLrO9Oip6YjPMPeN981SCiGGwNzvw7XgLjkCwPYd5yNysB+/ZSoKKKbbtvX5vBS5
	6oO5jcIs20T9v8KZUaF+2ESoHmDhW6y5YpiZRyA==
X-Google-Smtp-Source: AGHT+IGJlK0vVGGIsg6Q2X3INPPuJtHFwrlG6rzUW0S8GOjQaYt/T9rHb608AEKHM4d82TMbppTRKL6tXg7B/CaJKnc=
X-Received: by 2002:ac2:46e3:0:b0:52c:247d:2cfa with SMTP id
 2adb3069b0e04-52ca6e55075mr6615465e87.13.1718613523038; Mon, 17 Jun 2024
 01:38:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605161851.13911-1-kabel@kernel.org> <20240605161851.13911-7-kabel@kernel.org>
 <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
In-Reply-To: <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 17 Jun 2024 10:38:31 +0200
Message-ID: <CAMRc=McmiZFwPneeCtYtqgLiapf9jP9=L8WBmCwQTsZdZVeaqg@mail.gmail.com>
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 9:00=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.org=
> wrote:
> >
> > Add support for true random number generator provided by the MCU.
> > New Omnia boards come without the Atmel SHA204-A chip. Instead the
> > crypto functionality is provided by new microcontroller, which has
> > a TRNG peripheral.
>
> +Cc: Bart for gpiochip_get_desc() usage.
>
> ...
>
> > +#include <linux/bitfield.h>
> > +#include <linux/completion.h>
>
> + errno.h
>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/gpio/driver.h>
> > +#include <linux/hw_random.h>
> > +#include <linux/i2c.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/minmax.h>
> > +#include <linux/module.h>
> > +#include <linux/string.h>
>
> > +#include <linux/turris-omnia-mcu-interface.h>
>
> As per other patches.
>
> > +#include <linux/types.h>
> > +
> > +#include "turris-omnia-mcu.h"
>
> ...
>
> > +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> > +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > +       if (irq < 0)
> > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n")=
;
>
> Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> shouldn't be used. Bart, what can you suggest to do here? Opencoding
> it doesn't sound to me a (fully) correct approach in a long term.
>

Andy's worried about reference counting of the GPIO device. Maybe you
should just ref the GPIO device in irq_request_resources() and unref
it in irq_release_resources()? Then you could use gpiochip_get_desc()
just fine.

Bart
