Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8AD208A9
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713891439; cv=none; b=U4lyiBlWhWAsZFzHqbSUJBTpC2b+bvdOxXHuk437S8Tjd/dDQvc5W+G10RMvcX/4Enxr8EC4mMi5KJnrG7GzUAa/StIlaqBqjXFg6lBfvDExqAz+t8isX4RI0vFVoNOtvl7HLfFyO5zWWG28P/OOq+3t1YMVlvim++HVdbnzMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713891439; c=relaxed/simple;
	bh=wRXkZL3Vk3FOwKk4hkbiS0cu2M9QuAIKg6wsi1/ladw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMNuzz1HciTeFY/mOGH7PaQ6JV5nYGnRpJX348n6P8alz/sz+xRS3C4NwhM8tnRtfYn3/scTBSC+ijJzHb+hc3WRSYykJTkdOw3DJCPauVzvKvpMWI+mqvxaA+2OWDxwqmrbsAg68pULs19E8wRrjKTHoqjJBftl5KVbwth8u4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WL6OFmV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WL6OFmV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FC0C116B1;
	Tue, 23 Apr 2024 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713891439;
	bh=wRXkZL3Vk3FOwKk4hkbiS0cu2M9QuAIKg6wsi1/ladw=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=WL6OFmV2VP5pqJw4cLZUBEmamiIYpcQ3EkvB5eDTgmqILGMD/2eHaXogCObBgI6U9
	 xJL8tUX+V/+bJ/5T8HtFOiekXmj9tWF2a4FFT/gncIJ0zpF22elmRp2YjkmN6FIkc5
	 0EpqIbXVDfat4n+nLNSz58up6wbJuQDsi0HsNrsk1ITgmmPw3VWHp4oCmcQxCDX7XA
	 4uza1ivbouHCHEuuBPssgBMOv19J4pLIlgEapFjSR+/xfCNjKioNRzexbYlAMNmrZu
	 JTqvP6h/5yrMpiZVBfgwgWpiTgdsOh7HERgL44U0XkYYGx7PdUe8ENLJHuX1wWWIH7
	 +9GVjptW+PQyw==
Date: Tue, 23 Apr 2024 18:57:04 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andy@kernel.org>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, Arnd Bergmann <arnd@arndb.de>,
 soc@kernel.org, Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240423185704.2237bc65@thinkpad>
In-Reply-To: <CAHp75VcfmTeG+G1DkteR6GN96y3+h_Mz1YQ8U5asHJ7oTq+KbQ@mail.gmail.com>
References: <20240418121116.22184-1-kabel@kernel.org>
	<20240418121116.22184-8-kabel@kernel.org>
	<Zifamxfa18yjD_VS@smile.fi.intel.com>
	<20240423183225.6e4f90a7@thinkpad>
	<CAHp75VcfmTeG+G1DkteR6GN96y3+h_Mz1YQ8U5asHJ7oTq+KbQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2024 19:43:41 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Tue, Apr 23, 2024 at 7:32=E2=80=AFPM Marek Beh=C3=BAn <kabel@kernel.or=
g> wrote:
> > On Tue, 23 Apr 2024 18:58:19 +0300
> > Andy Shevchenko <andy@kernel.org> wrote: =20
> > > On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Beh=C3=BAn wrote: =20
>=20
> ...
>=20
> > > > +   irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > > +   irq =3D devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_id=
x);
> > > > +   if (irq < 0)
> > > > +           return dev_err_probe(dev, irq, "Cannot map TRNG IRQ\n")=
; =20
> > >
> > > This looks like some workaround against existing gpiod_to_irq(). Why =
do you
> > > need this? =20
> >
> > Hmmm, I thought that would not work because that line is only valid
> > as an IRQ, not as a GPIO (this is enforced via the valid_mask member of
> > gpio_chip and gpio_irq_chip).
> >
> > But looking at the code of gpiolib, if I do
> >   irq =3D gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> > the valid_mask is not enforced anywhere. =20
>=20
> Which one? GPIO has two: one per GPIO realm and one for IRQ domain.

The GPIO line validity is not enforced. The IRQ line validity is
enforced in the gpiochip_to_irq() method.

> > Is this semantically right to do even in spite of the fact that the
> > line is not a valid GPIO line? =20
>=20
> Yes. It's orthogonal to that.
>=20

