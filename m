From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH v4] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 22 Dec 2017 14:34:35 +0100
Message-ID: <CAOFm3uG2aBHWUgVyzPuU8XJaLbm78cWEuWvgLEvNfc-hiefAbw@mail.gmail.com>
References: <CGME20171222132349eucas1p2270e45b81c9d77cb09addfd769877098@eucas1p2.samsung.com>
 <20171204125351.26805-3-l.stelmach@samsung.com> <20171222132338.30054-1-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35886 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdLVNfR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 08:35:17 -0500
Received: by mail-wm0-f66.google.com with SMTP id b76so21811131wmg.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 05:35:16 -0800 (PST)
In-Reply-To: <20171222132338.30054-1-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=C5=81ukasz,

On Fri, Dec 22, 2017 at 2:23 PM, =C5=81ukasz Stelmach <l.stelmach@samsung.c=
om> wrote:
> Add support for True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
>
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

<snip>

> --- /dev/null
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -0,0 +1,245 @@
> +/*
> + * RNG driver for Exynos TRNGs
> + *
> + * Author: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> + *
> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
> + *
> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
> + * Krzysztof Koz=C5=82owski <krzk@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */


Would you mind using the new SPDX tags documented in Thomas patch set
[1] rather than this fine but longer legalese?

And if you could spread the word to others in your team this would be very =
nice.
See also this fine article posted by Mauro on the Samsung Open Source
Group Blog [2]
Thank you!

> +MODULE_LICENSE("GPL");

Per module.h this means GPL2 or later. This is not matching your
license above which does not state any version and therefore would
mean GPL1 or later,
Please make sure you use something and common rather than this and
make sure your MODULE_LICENSE is consistent with the top level
license.

Was it this way in the code from Krzysztof?


[1] https://lkml.org/lkml/2017/12/4/934
[2] https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spdx/
