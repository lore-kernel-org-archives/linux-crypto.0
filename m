Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31CB1CFA9
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 10:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714041696; cv=none; b=btjNtIwarL9YEaTUxgP7sewcOk+pU1DYh+O+kYNtG515wxCnoirWRvPaJwya5pGWHTg45VfKwls1X4RZFyDzIy8pmICh1X08t5lP8XqABzS883b295WCf+21Q2HmybWpRbhNmT+wCLXkBS8TfGqOmdLmq6Y+cwmxIrMobUiysi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714041696; c=relaxed/simple;
	bh=iv7SUIiaG9s3NVPGgli4gIp/ZnPvi4cNgaMFQtY+byk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6xTSVkCZ5+MPWtvvAONwKjcFLTLTLH1eKHgyHiIXbh3XO9Rditv7M6aXPeHbfBrWH5vz0Vs6twEgbQf7IaESpg43yc1QtzSgfd+PRFeCsslvPHCe38sX3qLlr8KEtYGBDFZKhOWSHw4FqAYRDZOU2BA0PPDTAoA2h0lRPiyj/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZBGxiQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZBGxiQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57289C113CE;
	Thu, 25 Apr 2024 10:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714041695;
	bh=iv7SUIiaG9s3NVPGgli4gIp/ZnPvi4cNgaMFQtY+byk=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=ZZBGxiQhHpjKRskelCMvza4VK8UoRlAXvP+wVoXNvcSOS1xd8zmnxQ+EKfw9JnZSH
	 gQOnpjjUenCi1O/QuAM57Scw9eCpw8KxgYQUBOuEY1BuRtFEO0aTzSL2Wuxb3DTSBU
	 YvwmyYhcqpIX/dCveRtCiNry2qwslldOGNyz3oaUGGQ7Hn+tDetHvq9z0MwEDxywaO
	 OUrAQHyY893fLSH61HgXnZNQJPBVu7F0b/G0CFXmhhqZixfM4JYX6B3tZ4gGKK46WL
	 kYxp2G5rcovPXNGGzNR2keKoTWMc+umnwmG7i0yi1xAsrS2rOxV15U5c+D63IgONUl
	 23vNHsI13d4qA==
Date: Thu, 25 Apr 2024 12:41:30 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Hans de Goede
 <hdegoede@redhat.com>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v7 6/9] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240425124130.6c96e273@dellmb>
In-Reply-To: <Zioql5TSzTLtMsX7@smile.fi.intel.com>
References: <20240424173809.7214-1-kabel@kernel.org>
	<20240424173809.7214-7-kabel@kernel.org>
	<ZilQiHLLj1eQxP2L@smile.fi.intel.com>
	<20240424205123.5fc82a1a@dellmb>
	<Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
	<20240425113447.5d4b21f4@dellmb>
	<Zioql5TSzTLtMsX7@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Apr 2024 13:04:07 +0300
Andy Shevchenko <andy@kernel.org> wrote:

> On Thu, Apr 25, 2024 at 11:34:47AM +0200, Marek Beh=C3=BAn wrote:
> > On Wed, 24 Apr 2024 22:47:10 +0300
> > Andy Shevchenko <andy@kernel.org> wrote: =20
> > > On Wed, Apr 24, 2024 at 08:51:23PM +0200, Marek Beh=C3=BAn wrote: =20
>=20
> ...
>=20
> > > For what purpose? I don't see drivers doing that. Are you expecting t=
hat
> > > the same IRQ mapping will be reused for something else? Can you elabo=
rate
> > > how? (I can imagine one theoretical / weird case how to achieve that,
> > > but impractical.) =20
> >=20
> > I do a lot of binding/unbinding of that driver. I was under the
> > impression that all resources should be dropped on driver unbind.
> >  =20
> > > Besides above, this is asymmetrical call to gpiod_to_irq(). If we rea=
lly care
> > > about this, it should be provided by GPIO library. =20
> >=20
> > Something like the following? =20
>=20
> Not needed. IRQ mappings are per domain, and GPIO chip has its own associ=
ated
> with the respective lifetime, AFAIU when you remove the GPIO chip, all ma=
ppings
> will be disposed (as I pointed out in previous mail).
>=20

OMG you are right :) of course. OK, I shall drop this.

Marek
