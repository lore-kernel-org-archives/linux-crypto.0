Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7597170A5A
	for <linux-crypto@vger.kernel.org>; Mon, 25 Mar 2024 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711360667; cv=none; b=rQiU3x+4OPZfAYwZPryeX+O04J4b0vGWQqSEOYuzT1vccNYbRb3mw/jBPun2eM0icHPolUJRO7It/ddJDvbJxndADblpYzFfKKnSBPw8S2b/Jg3wRIbq0o1528KdT/Cr2DTpLOAdyoNqFl9LCALfpMRvrf81dzRDd2EPvmAuUrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711360667; c=relaxed/simple;
	bh=uJggmdCEy5qVc+JdGsZIsamqVNi9SsgkOafj6qmYN/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnMD/ZhjYrH8ff0PDgxxVoREKqHMWIByNP7/4KlCl4l2jb4dWlEH6wl4VKd3bU3Hi4FON9XMw13ePEWuVbEN4uyaK7tTgRa3Fgc52da3RfJ3funOns5zVVSeJijC21QPhjVDYGdCP8nI4hHmuctrZu+MTog6m4wyv3sY+668Rg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LX8wlBFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LX8wlBFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D67DC433F1;
	Mon, 25 Mar 2024 09:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711360667;
	bh=uJggmdCEy5qVc+JdGsZIsamqVNi9SsgkOafj6qmYN/Y=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=LX8wlBFV50sMIWwXwrYZ6t/fxX0pZ2hZQLC75vbMKhuga/ESKhs9LEiUjeWZ5DZ3K
	 wQ3GG7/UxVZxx7weOuhHGOECmqtJwLCoVEGFpiXE/QBd6nZKl/78gAAJpGqZbZnT6c
	 kZZ/D8Fwb8EmKtGcCZNreONmV6B8IY/T9wuVlOp2+3dKcj4a2Zhtua09nwNwAe1udD
	 bma7JsaraAVCuWPfUYIY2k8yH19uDGy+C1/lzWioEY7QfEOJs9OttlpZc6J7QaI4Z5
	 3ygnMPfL0Wtl25a+y1wMgI3Hw8i9LzN1ulg6Fqynd9iBU1aKCNsnjkdlQQ7yihl1SE
	 YiqqkCQQ8yNrg==
Date: Mon, 25 Mar 2024 10:57:42 +0100
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Gregory CLEMENT
 <gregory.clement@bootlin.com>, soc@kernel.org, arm@kernel.org, Hans de
 Goede <hdegoede@redhat.com>, Horia =?UTF-8?B?R2VhbnTEgw==?=
 <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain
 <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 06/11] devm-helpers: Add resource managed version of
 irq_create_mapping()
Message-ID: <20240325105742.0e1c8906@dellmb>
In-Reply-To: <dd4c655f-39c4-47c1-b5fb-4d6fc94cc430@gmail.com>
References: <20240323164359.21642-1-kabel@kernel.org>
	<20240323164359.21642-7-kabel@kernel.org>
	<dd4c655f-39c4-47c1-b5fb-4d6fc94cc430@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.39; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Mar 2024 11:40:20 +0200
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> On 3/23/24 18:43, Marek Beh=C3=BAn wrote:
> > Add resource managed version of irq_create_mapping(), to help drivers
> > automatically dispose a linux irq mapping when driver is detached.
> >=20
> > The new function devm_irq_create_mapping() is not yet used, but the
> > action function can be used in the FSL CAAM driver.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > ---
> >   drivers/crypto/caam/jr.c     |  8 ++----
> >   include/linux/devm-helpers.h | 54 ++++++++++++++++++++++++++++++++++++
> >   2 files changed, 56 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> > index 26eba7de3fb0..ad0295b055f8 100644
> > --- a/drivers/crypto/caam/jr.c
> > +++ b/drivers/crypto/caam/jr.c
> > @@ -7,6 +7,7 @@
> >    * Copyright 2019, 2023 NXP
> >    */
> >  =20
> > +#include <linux/devm-helpers.h>
> >   #include <linux/of_irq.h>
> >   #include <linux/of_address.h>
> >   #include <linux/platform_device.h>
> > @@ -576,11 +577,6 @@ static int caam_jr_init(struct device *dev)
> >   	return error;
> >   }
> >  =20
> > -static void caam_jr_irq_dispose_mapping(void *data)
> > -{
> > -	irq_dispose_mapping((unsigned long)data);
> > -}
> > -
> >   /*
> >    * Probe routine for each detected JobR subsystem.
> >    */
> > @@ -656,7 +652,7 @@ static int caam_jr_probe(struct platform_device *pd=
ev)
> >   		return -EINVAL;
> >   	}
> >  =20
> > -	error =3D devm_add_action_or_reset(jrdev, caam_jr_irq_dispose_mapping,
> > +	error =3D devm_add_action_or_reset(jrdev, devm_irq_mapping_drop,
> >   					 (void *)(unsigned long)jrpriv->irq);
> >   	if (error)
> >   		return error;
> > diff --git a/include/linux/devm-helpers.h b/include/linux/devm-helpers.h
> > index 74891802200d..3805551fd433 100644
> > --- a/include/linux/devm-helpers.h
> > +++ b/include/linux/devm-helpers.h
> > @@ -24,6 +24,8 @@
> >    */
> >  =20
> >   #include <linux/device.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/irqdomain.h>
> >   #include <linux/workqueue.h> =20
>=20
> My confidence level is not terribly high today, so I am likely to accept=
=20
> just about any counter arguments :) But ... More I think of this whole=20
> header, less convinced I am that this (the header) is a great idea. I=20
> wonder who has authored a concept like this... :rolleyes:
>=20
> Pulling punch of unrelated APIs (or, unrelated except the devm-usage) in=
=20
> one header has potential to be including a lot of unneeded stuff to the=20
> users. I am under impression this can be bad for example for the build=20
> times.
>=20
> I think that ideally the devm-APIs should live close to their non-devm=20
> counterparts, and this header should be just used as a last resort, when=
=20
> all the other options fail :) May I assume all other options have failed=
=20
> for the IRQ stuff?
>=20
> Well, I will leave the big picture to the bigger minds. When just=20
> looking at the important things like the function names and coding style=
=20
> - this change looks Ok to me ;)

If the authors of devm-helpers or someone else decide it should not
exist (due for example of long build times), I am OK with that.

But currently this seems to me to be the proper place to put this into.

Marek
