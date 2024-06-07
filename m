Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3131850AA
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776923; cv=none; b=JRJNK916NMMMQYSbqYXRukcSam7Wxqp0mnlY15sdSV9i6rj4DaHAhwGNtzu1Oi2S9SYArE7YTZ56RJOfsABm7qSb40AKnerPYh5D7Esmeg/qn7/OLWnhkJETGKImZrHQ+kaoF9XbUdD+BLU4ZCZSaebaiNCNTg4GK6Op+w9sWEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776923; c=relaxed/simple;
	bh=EVU9N0licjs0UeJIOtiEuJJs/gF6eA2Qsud/PZcHqMY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qg7Kod4R/o2YsLYwCiCcvt65+AflNL1VGUX8bZE2lp7DqO8Qtjxpj4Qb2knFlVvpdY9r6rkaINyCFFo51Yxs+ifOjeO2COoaMYZZ3BqMndkTfOMpuzoB/G5mclkHnORvF8M9cWTgnf87CSfPPaVfwGCcM9fxJ6rfvZ5teQ1ltDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siH9tGIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siH9tGIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9DCC2BBFC;
	Fri,  7 Jun 2024 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717776922;
	bh=EVU9N0licjs0UeJIOtiEuJJs/gF6eA2Qsud/PZcHqMY=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=siH9tGINYS+RQSfGXjlHx2/ykdX/Teg1wxvSW1B/kiE5GxbUG0UjZD04NOgfBDVEr
	 wg1etkPy8l9TMT8JZmkCCxlhT15Llg1swybG3uGyxX9AcvRgnePzfPQwibUVsYRECg
	 4jk7AR24YxQgy3bNzBCRXCg+EENGe1kffAbEBt8/4nlCL7cKhIMGlP5x6W8129E2qO
	 76R6oyoEsyrXu5tWZ5EQeRTgR7sEejG4j8vcpnK3PoZ18OPPsQwRDl3uMw8vmvyWMz
	 q+F5J0XtamCzxiDvKegkF9t9nEsu28kCP3PE0Tw1kc9bpemzf+qJa173vXHEXLd7NG
	 Fve3WFN9OfOZw==
Date: Fri, 7 Jun 2024 18:15:16 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Andy Shevchenko
 <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Olivia Mackall
 <olivia@selenic.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240607181516.72edb60a@dellmb>
In-Reply-To: <ZmLhQBdmg613KdET@gondor.apana.org.au>
References: <20240605161851.13911-1-kabel@kernel.org>
	<20240605161851.13911-7-kabel@kernel.org>
	<ZmLhQBdmg613KdET@gondor.apana.org.au>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Jun 2024 18:30:24 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Jun 05, 2024 at 06:18:49PM +0200, Marek Beh=C3=BAn wrote:
> >
> > +static int omnia_trng_read(struct hwrng *rng, void *data, size_t max, =
bool wait)
> > +{
> > +	struct omnia_mcu *mcu =3D (struct omnia_mcu *)rng->priv; =20
>=20
> Please don't cast rng->priv in this manner.  Please take a look at
> drivers/char/hw_random/bcm2835-rng.c for how it should be done.
>=20
> Thanks,

THX, prepared for next version.
