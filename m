Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4143D16D332
	for <linux-crypto@vger.kernel.org>; Wed, 24 Apr 2024 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713977753; cv=none; b=sSTZpyQlgh3h9XcvLhEqeNeSIZyWScxqsHjMw8pHlcfsvjX8iFuEqsjQWJfhslC8QOGZST96Q6p15KZwoT8hJ4f4INP5AzXEDAf4dfBKGXO0O/TRSHVM4n3+31wYgsyN/EERW1KZXzL4b3F6A1qDfiTQfqV3k+eA2/zDophGuyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713977753; c=relaxed/simple;
	bh=RArGbTjywJoapBjOn9e2Rdum0BFmx8tdgHzlyAoGPLY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EF+0gdgR+UofyJ/thwu+6uh4iSEulmugzdnR42dVBawLtHXqlVUU1IdHqGi9XLUGfRRDPuIzgCmrU9JPt2Uu+mLWQkA0NTKwpJt9iDnnP9RcaMEVolmgBRZraCNEA0jelx1zBFbsL0HLGY6lbfQO7bAlvzd0iot7njKq2zxr0aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feJRYweR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feJRYweR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD803C2BD10;
	Wed, 24 Apr 2024 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713977752;
	bh=RArGbTjywJoapBjOn9e2Rdum0BFmx8tdgHzlyAoGPLY=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=feJRYweRIJNAtCLDEBPRIx3Mo5wBq2K4oJepu0wNdVpoJJBfmjeIA2mbOGsy1H7gG
	 GMkx0jQZWBpv6G/kJLJDhXNJP8FXU6hJB9KoNFBUlm++wnD53gGjJSArlMtfIiHdx2
	 /74sfrJ/snFjnz2ENHf+pXK/+kvgBfMjlWr6HbVnDf+7+jB73/t+yTa49yEFYUHT+R
	 9PmWT57QCCEQi5D4V25zkXhHzDATNpg8NXNV9Ch3rR+9B8lEykVxPdLg1nGS0x6lEn
	 LdhBoxyhTVfyXv1hnZO7H05WtMTppgIUTtHNyX4K+QpY+JxkVTDPqgQcvNvV/wbr8r
	 8w0d31RQuJxSg==
Date: Wed, 24 Apr 2024 18:55:47 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240424185547.4cf20408@dellmb>
In-Reply-To: <Zifu-l2o9ADkhMlW@smile.fi.intel.com>
References: <20240418121116.22184-1-kabel@kernel.org>
	<20240418121116.22184-8-kabel@kernel.org>
	<Zifamxfa18yjD_VS@smile.fi.intel.com>
	<20240423183225.6e4f90a7@thinkpad>
	<CAHp75VcfmTeG+G1DkteR6GN96y3+h_Mz1YQ8U5asHJ7oTq+KbQ@mail.gmail.com>
	<20240423185704.2237bc65@thinkpad>
	<Zifu-l2o9ADkhMlW@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2024 20:25:14 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Tue, Apr 23, 2024 at 06:57:04PM +0200, Marek Beh=C3=BAn wrote:
> > On Tue, 23 Apr 2024 19:43:41 +0300
> > Andy Shevchenko <andy.shevchenko@gmail.com> wrote: =20
> > > On Tue, Apr 23, 2024 at 7:32=E2=80=AFPM Marek Beh=C3=BAn <kabel@kerne=
l.org> wrote: =20
> > > > On Tue, 23 Apr 2024 18:58:19 +0300
> > > > Andy Shevchenko <andy@kernel.org> wrote:   =20
> > > > > On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Beh=C3=BAn wrote:=
   =20
>=20
> ...
>=20
> > > > > > +   irq_idx =3D omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > > > > +   irq =3D devm_irq_create_mapping(dev, mcu->gc.irq.domain, ir=
q_idx);
> > > > > > +   if (irq < 0)
> > > > > > +           return dev_err_probe(dev, irq, "Cannot map TRNG IRQ=
\n");   =20
> > > > >
> > > > > This looks like some workaround against existing gpiod_to_irq(). =
Why do you
> > > > > need this?   =20
> > > >
> > > > Hmmm, I thought that would not work because that line is only valid
> > > > as an IRQ, not as a GPIO (this is enforced via the valid_mask membe=
r of
> > > > gpio_chip and gpio_irq_chip).
> > > >
> > > > But looking at the code of gpiolib, if I do
> > > >   irq =3D gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> > > > the valid_mask is not enforced anywhere.   =20
> > >=20
> > > Which one? GPIO has two: one per GPIO realm and one for IRQ domain. =
=20
> >=20
> > The GPIO line validity is not enforced. The IRQ line validity is
> > enforced in the gpiochip_to_irq() method. =20
>=20
> Okay, but does it work for you as expected then?
>=20
> If not, we should fix GPIO library to have gpiod_to_irq() to work as expe=
cted.

Yes, it does. I am going to send a new version in a few minutes.

Marek
