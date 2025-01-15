Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D914037F
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2025 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736953232; cv=none; b=pDS3lsfXsfYNwJRVxaorFqm9qSvLlGM8ysDOxvI/ZqAa44UP4DhEWlb5wEpsullDVDYVKDfIYzPBWhyeEtJ4IKCzA1GveweEouPceSn9MR8Az7ab9bA2gdYebxAPaLaQ4j9PhYGjrgPhh1ewIvSOxFM189s2iL9Lx5XIM6ohr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736953232; c=relaxed/simple;
	bh=UntSylC2L6sfQJFuYA22uDDylsFI+B+PwrEhYt7lYhU=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=RJ8byiB1TxXOLSCYXF3c5/5qXXoIY8SfT+nr/X3uAx17/zhUyuiuQ+pR/Q/dCAcmPyW8G2GzPtHcAiBNp154jjFv8iy1eIIhB407JU812x2uWh843X/MksQ9KZkZ/USPETQ3XsnJWbRLcBGKpk2Ypl1xD8W0lLd+2mv5+U2hYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=j+22FXBp; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="j+22FXBp"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1736953216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hYjA0uckeT9PIaLQBNGw0hDT8Bjk+gZkNUrJ4slmsSE=;
	b=j+22FXBpxO2A7IEjM34vcARnZN0ujeuj7TUv0WcZyfZVJGsuCHvrBD+L4yGmqLtdFtaFgY
	doBNzKWfhkh1zocynAiXRQ8CT2XjwWXQWcUl2xRwZKWqhXjwichVrko8RjcxkUo03ybpy5
	TcoPEf3DkxqhxoVWKcj4LsNpGQInei7ahxwG2sSh5SUVQsqDYO2/m892s4km8vShIeIfkv
	ouE5JibUXY1Fz2+lFqLCnZZkwJAv9Vn0MinJVWBiol0fZNtKv4lwnGvhpuCk6i5JCv8A8Q
	CB3Dv9XS+LKyqTdAinAZo1egDSqujum536tXQkVXNG8e+sWMRXv7fJtyeV3alA==
Content-Type: multipart/signed;
 boundary=7d0ba370591f7812cd34793d367ac235049d9873956641cdbc7da38db506;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Date: Wed, 15 Jan 2025 15:59:57 +0100
Message-Id: <D72QIRDR2M26.3R77PKFX7VWZ2@cknow.org>
To: "Dragan Simic" <dsimic@manjaro.org>, <linux-crypto@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <olivia@selenic.com>,
 <herbert@gondor.apana.org.au>, <heiko@sntech.de>
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM
 is the trigger
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
In-Reply-To: <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
X-Migadu-Flow: FLOW_OUT

--7d0ba370591f7812cd34793d367ac235049d9873956641cdbc7da38db506
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi,

On Wed Jan 15, 2025 at 2:07 PM CET, Dragan Simic wrote:
> Since the commit 72d3e093afae (um: random: Register random as hwrng-core
> device), selecting the UML_RANDOM option may result in various HW_RANDOM_=
*
> options becoming selected as well, which doesn't make much sense for UML
> that obviously cannot use any of those HWRNG devices.
>
> Let's have the HW_RANDOM_* options selected by default only when UML_RAND=
OM
> actually isn't already selected.  With that in place, selecting UML_RANDO=
M
> no longer "triggers" the selection of various HW_RANDOM_* options.
>
> Fixes: 72d3e093afae (um: random: Register random as hwrng-core device)
> Reported-by: Diederik de Haas <didi.debian@cknow.org>
> Signed-off-by: Dragan Simic <dsimic@manjaro.org>
> ---
>  drivers/char/hw_random/Kconfig | 76 +++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kcon=
fig
> index e84c7f431840..283aba711af5 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -38,47 +38,47 @@ config HW_RANDOM_TIMERIOMEM
>  config HW_RANDOM_INTEL
>  	tristate "Intel HW Random Number Generator support"
>  	depends on (X86 || COMPILE_TEST) && PCI
> -	default HW_RANDOM
> +	default HW_RANDOM if !UML_RANDOM
>  	help
>  	  This driver provides kernel-side support for the Random Number
>  	  Generator hardware found on Intel i8xx-based motherboards.
> =20
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called intel-rng.
> =20
>  	  If unsure, say Y.
> =20
>  config HW_RANDOM_AMD
>  	tristate "AMD HW Random Number Generator support"
>  	depends on (X86 || COMPILE_TEST)
>  	depends on PCI && HAS_IOPORT_MAP
> -	default HW_RANDOM
> +	default HW_RANDOM if !UML_RANDOM
>  	help
>  	  This driver provides kernel-side support for the Random Number
>  	  Generator hardware found on AMD 76x-based motherboards.
> =20
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called amd-rng.
> =20
>  	  If unsure, say Y.
> =20
>  config HW_RANDOM_AIROHA
> ...
> @@ -603,7 +603,7 @@ config HW_RANDOM_ROCKCHIP
>  	tristate "Rockchip True Random Number Generator"
>  	depends on HW_RANDOM && (ARCH_ROCKCHIP || COMPILE_TEST)
>  	depends on HAS_IOMEM
> -	default HW_RANDOM
> +	default HW_RANDOM if !UML_RANDOM
>  	help
>  	  This driver provides kernel-side support for the True Random Number
>  	  Generator hardware found on some Rockchip SoC like RK3566 or RK3568.

Context:
I wanted to enable the HW_RANDOM_ROCKCHIP module in the Debian kernel
so I send a MR to enable it as module. One of the reviewers remarked
that this would *change* the module config from ``=3Dy`` to ``=3Dm`` as
``HW_RANDOM`` is configured ``=3Dy`` due to Debian bug #1041007 [1].
IOW: if you don't say you want a HWRNG module, it will be built-in to
the Debian kernel, while Debian normally uses ``=3Dm`` if possible.

So that's when I realized almost all modules have ``default HW_RANDOM``
and then found that UML_RANDOM selects HW_RANDOM which in turn would
enable (almost) all HWRNG modules unless you specify otherwise.
It's actually the depends which would mostly 'prevent' that.
This to me looks excessive, discussed the problem with Dragan which
resulted in this patch set.

But why not just remove (most of) the ``default HW_RANDOM`` lines
whereby a HWRNG module thus becomes opt-in instead of opt-out?

For ``HW_RANDOM_ROCKCHIP`` it's for the SoC found in *only* the rk3566
and rk3568 SoCs, but none of the others, and it's (currently) effective
only on rk3568 based devices (due to deliberate DT config).
In the help text of other modules I see mention of specific (series of)
motherboards, so also there it may not be useful for all.

I did a partial ``git blame`` to get an idea as to why those defaults
were there and found the following:

fed806f4072b ("[PATCH] allow hwrandom core to be a module")
from 2006-12-06 with the goal to have them modular

2d9cab5194c8 ("hwrng: Fix a few driver dependencies and defaults")
from 2014-04-08 which added several ... for consistency sake

e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
from 2024-10-17 with no explicit mention why it was done, so that was
most likely as that was used elsewhere (thus consistency)

So while this patch does prevent accidental enablement due to UML_RANDOM
enablement, it does seem to me to be needlessly complex and making it
opt-in, which was the assumption of my MR to begin with, much simpler.

I can be missing other considerations why the current solution would be
better, but I figured I'd mention my perspective.

Cheers,
  Diederik

[1] https://bugs.debian.org/1041007

--7d0ba370591f7812cd34793d367ac235049d9873956641cdbc7da38db506
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZ4fNeQAKCRDXblvOeH7b
bieCAP4o4jgafiEbxwkFyfpTyPJSryQnIhxpzGhPNkJB3UJekAD7BoxI6g6mHGBK
mamXqCohnNr/2Tn21N+D6joDpMF8PAI=
=ot8d
-----END PGP SIGNATURE-----

--7d0ba370591f7812cd34793d367ac235049d9873956641cdbc7da38db506--
