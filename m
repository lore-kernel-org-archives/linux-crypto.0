From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH v4] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Wed, 27 Dec 2017 11:12:20 +0100
Message-ID: <87shbwh43f.fsf%l.stelmach@samsung.com>
References: <CAOFm3uEj7MDa_7OtigHcUPwvxkR+8cRS=UQq3x_y9k+ypcJPrg@mail.gmail.com>
        <CGME20171227101226eucas1p2baa0309227b8e6a1e77dd7ca88f6412b@eucas1p2.samsung.com>
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
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CAOFm3uEj7MDa_7OtigHcUPwvxkR+8cRS=UQq3x_y9k+ypcJPrg@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-22 pi=C4=85 19:30>, when Philippe Ombredanne wrote:
> On Fri, Dec 22, 2017 at 5:38 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> It was <2017-12-22 pi=C4=85 14:34>, when Philippe Ombredanne wrote:
>>> =C5=81ukasz,
>>>
>>> On Fri, Dec 22, 2017 at 2:23 PM, =C5=81ukasz Stelmach <l.stelmach@samsu=
ng.com> wrote:
>>>> Add support for True Random Number Generator found in Samsung Exynos
>>>> 5250+ SoCs.
>>>>
>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>>>
>>> <snip>
>>>
>>>> --- /dev/null
>>>> +++ b/drivers/char/hw_random/exynos-trng.c
>>>> @@ -0,0 +1,245 @@
>>>> +/*
>>>> + * RNG driver for Exynos TRNGs
>>>> + *
>>>> + * Author: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>> + *
>>>> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
>>>> + *
>>>> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
>>>> + * Krzysztof Koz=C5=82owski <krzk@kernel.org>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modi=
fy
>>>> + * it under the terms of the GNU General Public License as published =
by
>>>> + * the Free Software Foundation;
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>
>>>
>>> Would you mind using the new SPDX tags documented in Thomas patch set
>>> [1] rather than this fine but longer legalese?
>>>
>>> And if you could spread the word to others in your team this would be v=
ery nice.
>>> See also this fine article posted by Mauro on the Samsung Open Source
>>> Group Blog [2]
>>> Thank you!
>>
>> Cool! We've been using SPDX to tag RPM packages in Tizen for three years=
 or
>> more. ;-)
>
> Very nice! any pubic pointers?
                 ^^^^^

I assume you request an URL of a publicly available web-page ;-)

https://wiki.tizen.org/Packaging/Guidelines#License_Tag

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaQ3IEAAoJELCuHpyYpYAQ/50H/0VDdhRdsKiDo9iZSdhyLHcy
xXvNzMyTjv5a60DuTRvcFX2+F/ICXv72+dixazYUAnO+9xteU4GZNO56KRPaYPN5
k/MM/rdwfvM7aJhJIhNHAbhYjMek2pUNWYcDMNXeOmPn1doSpyHSQzKQSRrgN2du
YaCpz+TQ0e7SYTl6DGm34Oh+XR02Pe1afNTSrcrrqCVL2YUHKX0U/g0m7L1IafvH
+WPz4RtxfmZmVbQkAAdORr+AuO3S09tFlsLgRuANOW51jMdLxTLofvq67MIiqnqW
PxFNjj1W0dDQjKDGUn26idqpQAePIcIW2ounCZq/g9uwpHJFfsJsGLtgn12cScI=
=U2X0
-----END PGP SIGNATURE-----
--=-=-=--
