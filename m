Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3D113B78A
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713890661; cv=none; b=Xv7H7/FSxZ6cGmdMDQV0/AN6t9U1ZIGQIlfmVv5d11HLaMXkgYnFg8cSfmLt5VXIm4k0fFKuV3ga/1h0sIMYvusheIFcCqB5zN2R5nn6mNL5or3wMDb9mSBwYYLEnbFbMogPpoEnECpREG2nDqftzddUsifVmWdXt+S3nVUTTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713890661; c=relaxed/simple;
	bh=KeLbUywqjRHBZwPfv0DWbGyqEfg9rEXQ0AE8b3/ZIMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ifUMkwtMwRhjALSFEjGFSQG6dd/JOuc1vK/DzCm7bdCa9YxZy7vB9JfTpgfZwnLKnlu1wljFJcyQIWezbEbwwq2ZEstDm9spF5JpT13LXtDDzGTMWNXFKt1B4lyFdlZdUaiHyFytwHKH4+vH4K5FD7fyAK5C6pGsL0qQXaeMIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXEeBSjJ; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXEeBSjJ"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a5224dfa9adso8614166b.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 09:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713890658; x=1714495458; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzHvPMI8jy4JoQIjALX1Zmza34aN1gCSFeb2zP8PLnY=;
        b=QXEeBSjJtWaTZLzcuWskN4dtoJmHl/TD422VRSazGAiOtcPIg65zD3P28P8/oxHZaT
         Sw7qvHqj/O5UEHDwPlvQl09IUwCh6F6JdU5UMjUDRzu1EKsmieecoLClY4Io4BGSmpjz
         ADg41Wq0x734JU1HjjFGa2VD0LJLgbKwBI4wdEMjBuH1UMAEERpLLQSCLgZSdIKely3P
         iDuyd3RZGU5in7nwyGFWDbSlITz7rYpIP1qJIhS/KXoy+wKGJ+7H+WbSZ5jzVR9I+2C/
         KX8TLFvBNfM+doUpR4gpt+WWcL/HZwehc8p1I39T5X2TVPaDQqRkVXr2LegwkZsjly1C
         yvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713890658; x=1714495458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzHvPMI8jy4JoQIjALX1Zmza34aN1gCSFeb2zP8PLnY=;
        b=EfmXepm5awv175Vj54gLczJzY33Dy+GDTTDhc60ov4EXQ+ZQFu6x/BGXVAPTmUtY+w
         f5tEbAXJY75/jDrBpcSFvdahmF8qYZsS0oEv1nicynt6Uh1ekCH4JrCqj0MsypcWBX+z
         p4rzu8JpRPb3YPe6EgTO2zxExca3Ljn8Ld0YVOW3bGzfXxBwEAJGJF422VmpSu5cL5iE
         kE2ARyhh3bNDcxz2Z/QLmPhH9Y9x7yK8h80w6I2R7IcmjP/iQqvm/VppQNutzFj/QOOr
         hSllCDSBSYX+VmZKLGrCvtjPQLXrHOmn1S21rln1+1fiS2H0EO0W541Yh1x6Jpdp7/FE
         Kf1A==
X-Forwarded-Encrypted: i=1; AJvYcCX460wtmCUDEA3D17vAMpeD7a16efobP73PKWrw/oLU7dHOuY75yWX7RbW+48iBepegL2x277ywp1R19cpQZLeC1fCEmHoYHxvf341v
X-Gm-Message-State: AOJu0Yzsf0CPvNTFgzjUVaW7k+iBPgg3Yx/zrlPyV3YHeuUIsnAK+4uo
	2DBTqOC5R2w8yMm+luQq9cIXoOMwpyGOIeea1aBSCsvU6hBAzYCMll9SEvWOeaqtBbj4PlZ2HAa
	YRjV7TOn85cnAriT0wcVgeIrXOvs=
X-Google-Smtp-Source: AGHT+IHSbCrYySuPw2JwMFZJ1BbFCsUQksBQF5BIagB21JFr3mV8NPTJAmKTRu8kFIXN4c3hM3Wotbg80bYc0sdO3hU=
X-Received: by 2002:a17:906:a2cf:b0:a55:75f7:42fb with SMTP id
 by15-20020a170906a2cf00b00a5575f742fbmr3582184ejb.24.1713890657677; Tue, 23
 Apr 2024 09:44:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418121116.22184-1-kabel@kernel.org> <20240418121116.22184-8-kabel@kernel.org>
 <Zifamxfa18yjD_VS@smile.fi.intel.com> <20240423183225.6e4f90a7@thinkpad>
In-Reply-To: <20240423183225.6e4f90a7@thinkpad>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 23 Apr 2024 19:43:41 +0300
Message-ID: <CAHp75VcfmTeG+G1DkteR6GN96y3+h_Mz1YQ8U5asHJ7oTq+KbQ@mail.gmail.com>
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>, Gregory CLEMENT <gregory.clement@bootlin.com>, 
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, arm@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 7:32=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.org>=
 wrote:
> On Tue, 23 Apr 2024 18:58:19 +0300
> Andy Shevchenko <andy@kernel.org> wrote:
> > On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Beh=C3=BAn wrote:

...

> > > +   irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > +   irq =3D devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx)=
;
> > > +   if (irq < 0)
> > > +           return dev_err_probe(dev, irq, "Cannot map TRNG IRQ\n");
> >
> > This looks like some workaround against existing gpiod_to_irq(). Why do=
 you
> > need this?
>
> Hmmm, I thought that would not work because that line is only valid
> as an IRQ, not as a GPIO (this is enforced via the valid_mask member of
> gpio_chip and gpio_irq_chip).
>
> But looking at the code of gpiolib, if I do
>   irq =3D gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> the valid_mask is not enforced anywhere.

Which one? GPIO has two: one per GPIO realm and one for IRQ domain.

> Is this semantically right to do even in spite of the fact that the
> line is not a valid GPIO line?

Yes. It's orthogonal to that.

--=20
With Best Regards,
Andy Shevchenko
