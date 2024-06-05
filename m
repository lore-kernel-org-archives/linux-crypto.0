Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2E8E573
	for <linux-crypto@vger.kernel.org>; Wed,  5 Jun 2024 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614061; cv=none; b=T3jUKPFK6abULXqMMqw5isKB+ZQTCR3wHLDTwg1IfFrigzqsPWccYYwT9+b4ioxwpuF42P2CFNtFagoCB5IspddyzzGlvspjz6I+m95JJ+QUJ6tDAYYjoWmh8mKj0KiG/XccGwJtkQrh5P3Fc71pGI7ZUyDl8yCZO5CEX4R7GV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614061; c=relaxed/simple;
	bh=gqCSIzRysYcLX1mW1haocZgmshdPQ0djW6+REb56uQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z15mc5k8Xb2cJDHvXhEHUH19AGD0TaTXsQZkq48u9RcCvJNV0zYQTWnLb0omfQK8iZsImZDOZc6kO2vcHGQcu5aWKN5VRf50MBzaioVXmEaRSm0NDZiacdkNrzTpEH7QLM6chWx4F6ODp3lC4E+v32DOJY3fffNaqf2SP3tqHd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZgeh4+s; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZgeh4+s"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52b962c4bb6so256345e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jun 2024 12:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717614058; x=1718218858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYhIOyPTOMDfxI0+KR+naWl8/lGKtywkm84N4Cz6eKM=;
        b=IZgeh4+sLJlw/gBY08Jmsr1XXIxfekxF8kc1wRSGMd1HoeYaH9H7V17Gke0bfRI0t6
         tXWmSJmSg7HLqruI1OXLxdDLR+QarZMqs0a0znE0edYZSex+SWow8lEe2qOb66bMLPeK
         4ZkZ2K31LlgINwD0p/E48ARw4sZKr5aufX5ZlffhcS83rWgWkFTpx8KS3rf+AFmebqWX
         0WTT24eLap9NZzqd688KVrg8EnDE5mmXiCytFgCP58XoJG/QIDrdGUThLqpQK7X6zpWw
         LBuyf8Vns4xPQ0dfitoBCDbG6PU3QHRBtJVfWZv6MKs2RC+Q3+J4iJ3OuFii6Q8AsxVo
         b2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717614058; x=1718218858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CYhIOyPTOMDfxI0+KR+naWl8/lGKtywkm84N4Cz6eKM=;
        b=CejVDnuuyyUBtTrB9fqkyoCo4Hvngde4i3a6Vk2ctq6WLxD3eHfqbxH6OBzLF/fWGO
         kUTntFYoV+4U+XXPml+rAzOd1F+ZqxI19Qy31Bd8iuIJ+3XU8YdkUJxhpMJEbJCewcQp
         xYrMYymg1BiTKGOU5j2ryWCsSteOc+4XjQYCkLXlXBAFgFST4Z2/4DfKrh3kQFbkWIcm
         SQJoKmASRReVXakCmdzZtCnIJOingm+QdUW66TBJg0jGLcTEe4TExVA8d0yToWXNYiUo
         tzABA1L4QmFjgTHDLYYTKfiW773upVPEAkI+p7XUa3vPg+aiyER/8h4nfdq/e62poKXN
         +xtg==
X-Forwarded-Encrypted: i=1; AJvYcCX5CsM7pkPACxJcxVsTcxwJF57qABoXf5juK33L97RsTCMzUucQpOOhM+UBsbnExIh9lazbPLefLBEXDIC24ZDDLJrOaCAtrA8I/eW3
X-Gm-Message-State: AOJu0YxVp4pdjd3HRV5GMC2HXLJniYd5C/7VHZzdcnL++fz+gheGLfpt
	IRfSoqb4gyNb11S8Sk+7FdCNHZ9IXePm4OqQY9RU/cBNDjo4611MsIczLW/v7QgcC11MDLMrwwT
	PITIT2mDgPhSAdrmJgakvf5ljKHJT4X82
X-Google-Smtp-Source: AGHT+IGcDozObRVYZ76zXZPRUAXMF/4meZiWPArCnmpa0e4ramK0EiWLTzgfvAF+nimAD5HnaXqqnbcxwOLaFVcBMUA=
X-Received: by 2002:a05:6512:1285:b0:52b:7a44:e17b with SMTP id
 2adb3069b0e04-52bab4ca4d2mr3449911e87.13.1717614057475; Wed, 05 Jun 2024
 12:00:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605161851.13911-1-kabel@kernel.org> <20240605161851.13911-7-kabel@kernel.org>
In-Reply-To: <20240605161851.13911-7-kabel@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 5 Jun 2024 22:00:20 +0300
Message-ID: <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 7:19=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.org> =
wrote:
>
> Add support for true random number generator provided by the MCU.
> New Omnia boards come without the Atmel SHA204-A chip. Instead the
> crypto functionality is provided by new microcontroller, which has
> a TRNG peripheral.

+Cc: Bart for gpiochip_get_desc() usage.

...

> +#include <linux/bitfield.h>
> +#include <linux/completion.h>

+ errno.h

> +#include <linux/gpio/consumer.h>
> +#include <linux/gpio/driver.h>
> +#include <linux/hw_random.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/minmax.h>
> +#include <linux/module.h>
> +#include <linux/string.h>

> +#include <linux/turris-omnia-mcu-interface.h>

As per other patches.

> +#include <linux/types.h>
> +
> +#include "turris-omnia-mcu.h"

...

> +       irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> +       irq =3D gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> +       if (irq < 0)
> +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");

Okay, it's a bit more complicated than that. The gpiochip_get_desc()
shouldn't be used. Bart, what can you suggest to do here? Opencoding
it doesn't sound to me a (fully) correct approach in a long term.

--
With Best Regards,
Andy Shevchenko
