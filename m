From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH v4] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 22 Dec 2017 17:38:56 +0100
Message-ID: <87y3luhg4f.fsf%l.stelmach@samsung.com>
References: <CAOFm3uG2aBHWUgVyzPuU8XJaLbm78cWEuWvgLEvNfc-hiefAbw@mail.gmail.com>
        <CGME20171222163901eucas1p253c4258fb141ea955c40185cd2f38197@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
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
To: Philippe Ombredanne <pombredanne@nexb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56962 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753456AbdLVQjG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 11:39:06 -0500
In-reply-to: <CAOFm3uG2aBHWUgVyzPuU8XJaLbm78cWEuWvgLEvNfc-hiefAbw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-22 pi=C4=85 14:34>, when Philippe Ombredanne wrote:
> =C5=81ukasz,
>
> On Fri, Dec 22, 2017 at 2:23 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> Add support for True Random Number Generator found in Samsung Exynos
>> 5250+ SoCs.
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> <snip>
>
>> --- /dev/null
>> +++ b/drivers/char/hw_random/exynos-trng.c
>> @@ -0,0 +1,245 @@
>> +/*
>> + * RNG driver for Exynos TRNGs
>> + *
>> + * Author: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> + *
>> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
>> + *
>> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
>> + * Krzysztof Koz=C5=82owski <krzk@kernel.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation;
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>
>
> Would you mind using the new SPDX tags documented in Thomas patch set
> [1] rather than this fine but longer legalese?
>
> And if you could spread the word to others in your team this would be ver=
y nice.
> See also this fine article posted by Mauro on the Samsung Open Source
> Group Blog [2]
> Thank you!

Cool! We've been using SPDX to tag RPM packages in Tizen for three years or
more. ;-)

>> +MODULE_LICENSE("GPL");
>
> Per module.h this means GPL2 or later. This is not matching your
> license above which does not state any version and therefore would
> mean GPL1 or later,

Thanks for spotting. My intention is GPL-2.0.

> Please make sure you use something and common rather than this and
> make sure your MODULE_LICENSE is consistent with the top level
> license.
>
> Was it this way in the code from Krzysztof?

Yes. And omap-rng, the second of my sources of reference, too. Actually,
the majority of modules still specify "GPL".

 281 | "Dual */*"
2082 | "GPL v2"
6359 | "GPL"
=2D--- +---------
8784 | Total

Fixing.

> [1] https://lkml.org/lkml/2017/12/4/934
> [2] https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spdx/

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaPTUgAAoJELCuHpyYpYAQ/OkIAKYGU0bLnSiPYYpkSPelFEpo
O9BvqvnYHbZFIuUU1OEpiJcHk2ITBFvyxAewA3+1tkwVKuY5iG2zdY3yM91PWO5Q
qpyFODOfsJznEOrEI7Q81D2pzcur/Vs4fai38VqRKmDyYb7BnlPdWEl6mznT5fed
GhgS9uLbOIb+UL9Nj4vBRcNoPjViZgB3rZ3xCiRHFean7mjhfK5pxedHCDmdWq4m
+ZRmAaMByuxPN78gFE3ZxYIyTACNq3UFljoP0X5wJ6LT2WlSSQJ30QqmORkhs275
T7EtdjDAI2NAO9PJYzBWVwBE+Yie8sXFyuLe02fThzho+nz1nRgGz4WQ3RGdBBA=
=8cE6
-----END PGP SIGNATURE-----
--=-=-=--
