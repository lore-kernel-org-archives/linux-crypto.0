Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329B36E
	for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711532065; cv=none; b=GwSO3/tqH98Yq75p8NZKmybSBsMvjkeggClR+tYPAi+Iw///j17uL0QGjnIkX28q8vGsGf4hiL2emd+wVN7q5NLf+57u1e4I/nx88PglHRwg5NLH9/fZqDl9m4T9+Z1GzpRcIC8VMcV+Hd0Rn9Ip/MMGZCOOJb12DhayfrT9p/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711532065; c=relaxed/simple;
	bh=XOchda7odJ/zW6uaAUv9JGZx87HRnkrBQzCLGmin4Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xji8YEEdIg5m5v87ZYcFK3GkgVvQWW+dU/i8eE05lVEzFQRPkI9BHjnJBLt45fpLCo0w1U9aORilIpcrvcwqFwqhpEIE6qgD28MGJo5UcBi1hoA3Uf0hnKzOakCBBULFMkNhbqUBBFiiS30VfmeTzfQMc4j4EG4uzhefBJUaUrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyzhW8nQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyzhW8nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363F1C43390;
	Wed, 27 Mar 2024 09:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711532064;
	bh=XOchda7odJ/zW6uaAUv9JGZx87HRnkrBQzCLGmin4Dw=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=KyzhW8nQpffWoB4I/r3U7sDPkbl9c2jA0qOvFbYuE+RveNigmNv4z3wSkRTbPLcbQ
	 gJsFalp8TAIJYTys0jclVwt+KkW2+21zPfii39f44hIsXBYjlM01aJ0MinTHZE0TXE
	 2Av2yHlBqgCC0ehpERNrcf1Dy1wFcdt8nhBsrN7ZEmIWmZvZXhP05hGdGBUXMkhvmO
	 ZJNYAu7QkSrEGNoTadYhovLm8gfPEH7qoiPS6laVr0oGXv4vGi+FGqLV29YyiWb/eQ
	 Wry0PyjKgPIiXIYbnEBEwHW/MQfQMaXWP5xZB77CJWlEpalv4h3dZyjQLU19Qjg3rD
	 oKmQAC7m+SRJg==
Date: Wed, 27 Mar 2024 10:34:19 +0100
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, soc@kernel.org, arm@kernel.org, Hans de
 Goede <hdegoede@redhat.com>, Matti Vaittinen <mazziesaccount@gmail.com>,
 Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>, Pankaj Gupta
 <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 06/11] devm-helpers: Add resource managed version of
 irq_create_mapping()
Message-ID: <20240327103419.3918953a@dellmb>
In-Reply-To: <72bf31c3-337d-4747-8353-639492507a7b@moroto.mountain>
References: <20240323164359.21642-1-kabel@kernel.org>
	<20240323164359.21642-7-kabel@kernel.org>
	<72bf31c3-337d-4747-8353-639492507a7b@moroto.mountain>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.39; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Mar 2024 12:00:25 +0300
Dan Carpenter <dan.carpenter@linaro.org> wrote:

> On Sat, Mar 23, 2024 at 05:43:54PM +0100, Marek Beh=C3=BAn wrote:
> > +/**
> > + * devm_irq_create_mapping - Resource managed version of irq_create_ma=
pping()
> > + * @dev:	Device which lifetime the mapping is bound to
> > + * @domain:	domain owning this hardware interrupt or NULL for default =
domain
> > + * @hwirq:	hardware irq number in that domain space
> > + *
> > + * Create an irq mapping to linux irq space which is automatically dis=
posed when
> > + * the driver is detached.
> > + * devm_irq_create_mapping() can be used to omit the explicit
> > + * irq_dispose_mapping() call when driver is detached.
> > + *
> > + * Returns a linux irq number on success, 0 if mapping could not be cr=
eated, or =20
>                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^
>=20
> > + * a negative error number if devm action could not be added.
> > + */
> > +static inline int devm_irq_create_mapping(struct device *dev,
> > +					  struct irq_domain *domain,
> > +					  irq_hw_number_t hwirq)
> > +{
> > +	unsigned int virq =3D irq_create_mapping(domain, hwirq);
> > +
> > +	if (!virq)
> > +		return 0; =20
>=20
> What is the point of returning zero instead of an error code?  Neither
> of the callers that are introduced later in the patchset use this.
>=20
> I understand that it matches some of the other legacy irq function
> behaviors, but I think we are trying to move away from that because it
> just leads to bugs.
>=20
> Since we don't need the zero now, let's wait until we have a user before
> introducing this behavior.  Then we can add a new function that returns
> zero, but we'll still encourage people to use the standard error code
> function where possible.  And at the same time, when we do introduce the
> zero is an error code, function you should contact
> kernel-janitors@vger.kernel.org so someone an write a static checker
> rule to detect the bugs that result from it.

Hi Dan,

the first user of this function is the very next patch of this series,
and it does this:

+	irq =3D devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
+	if (irq <=3D 0)
+		return dev_err_probe(dev, irq ?: -ENXIO,
+				     "Cannot map MESSAGE_SIGNED IRQ\n");

So it handles !irq as -ENXIO.

I looked into several users who do
  virq =3D irq_create_mapping()
and then reutrn errno if !virq:

  git grep -A 3 'virq =3D irq_create_mapping'

Some return -ENOMEM, some -ENXIO, some -EINVAL.

What do you think?

Or should I send this driver without introducing this helper for now?

Marek
