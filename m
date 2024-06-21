Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F9478C8D
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 09:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718962388; cv=none; b=Rr0UO5O4KWkL8d85ZIvrKRZbbze5CHO6s7FLvl60l6beqPmxc4KuoawV3w7tect2FCUDRACI9sPphH+8PB+YFLDYeJDfJV0he16pdUItXQ1UpF1e+aUF7rcEi3wG9BRqJIg1sdsKsBL3xPGXeh7mS1t6wtweeAvVPD870c7V7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718962388; c=relaxed/simple;
	bh=E9cYpE4iW5KxYJc5t6VcgPWDNJ7zI+gXmn7e5IvxHj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzEy7E+6QYnFYdD/2b1s7UMa8sMOVAKMhyXppzbQFgMnuKAyDX6FtMzdvvRBmJuc8t8Ir82mgqtlq5gdKOgUh2qQckPFrdr12LJEez5AVEFJ5xIorTlUWcccCXTeKxGXNBs5EvIkDPhA1u/yYlbpny+6+u+mojkVpaxyZDdhjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=VhKjjRrK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="VhKjjRrK"
X-Envelope-To: daniel@makrotopia.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1718962383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OwyKB6XsVezaf31h9Csn0ERhorbwkY4Vv9b4XERmN7w=;
	b=VhKjjRrKfeDUSL0Fh1j6EQQMHRry83jtwLDLaOIMKjyfXh+pgxkMifNrIfDOzzo/9fKAeG
	YqM6f6xi2NT3CLK9VU2VB+OdaltyUI8XQMzp8Jwwg9/7EvnT4NibVV/vbgcMg7q0U5IWvK
	gXSqgEaG2qhQdtlXnmc8nY6Z/PR0qndd/4FgYvCXRrD+kyy5vQdIwUuA1FZY6tJJtmbye7
	s9U7nEVgH5XPimBn0pOKOoMvoz9sG/6OtXVbMRtkCyGZoTpVcRhT+z/PYCdfr289tkWpc8
	yW8W7BBCRbLQ8010+5JASTc8cpMAi4asNiI7BFq2uVLIENtdAEeZG54c0U5iGg==
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: olivia@selenic.com
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: robh@kernel.org
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: heiko@sntech.de
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: linux.amoon@gmail.com
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: ardb@kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: daniel@makrotopia.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Dragan Simic <dsimic@manjaro.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
Date: Fri, 21 Jun 2024 11:32:47 +0200
Message-ID: <2947104.hVmBtEWnvU@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1935094.npV3YSaYj1";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart1935094.npV3YSaYj1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
Date: Fri, 21 Jun 2024 11:32:47 +0200
Message-ID: <2947104.hVmBtEWnvU@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

Hi,

On Friday, 21 June 2024 03:25:18 CEST Daniel Golle wrote:
> diff --git a/drivers/char/hw_random/rockchip-rng.c
> b/drivers/char/hw_random/rockchip-rng.c new file mode 100644
> index 000000000000..6070abb73847
> --- /dev/null
> +++ b/drivers/char/hw_random/rockchip-rng.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * rockchip-rng.c True Random Number Generator driver for Rockchip SoCs
> + *
> + * Copyright (c) 2018, Fuzhou Rockchip Electronics Co., Ltd.
> + * Copyright (c) 2022, Aurelien Jarno
> + * Authors:
> + *  Lin Jinhan <troy.lin@rock-chips.com>
> + *  Aurelien Jarno <aurelien@aurel32.net>
> + */
> +#include <linux/clk.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/reset.h>
> +#include <linux/slab.h>

I've been using a modified version of Aurelien's patch myself and I added the 
following to my commit description:

```
hwrng: rockchip: Explicitly include correct DT includes

Similar to commit 
045a44d4c9b3 ("regulator: Explicitly include correct DT includes")
replace ``of_platform.h`` include with ``of.h`` and ``platform_device.h``.

Link: https://git.kernel.org/linus/045a44d4c9b32578aacf0811063e5bb741c7c32c
```

BUT I don't (really) know what I'm doing, so could you verify whether there is 
some merit to it?

Cheers,
  Diederik
--nextPart1935094.npV3YSaYj1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZnVIvwAKCRDXblvOeH7b
bqE7AQDF37/CXTAUyN3awVxvukKshJxjy4bD/LzGPF6vKKjeMwD+OQtj9mn9qg9S
9VINqYzabKxos3rXWoGeIEgjc7TYkwM=
=DxWI
-----END PGP SIGNATURE-----

--nextPart1935094.npV3YSaYj1--



