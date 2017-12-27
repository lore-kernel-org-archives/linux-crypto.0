From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [PATCH v4] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Wed, 27 Dec 2017 22:51:02 +0100
Message-ID: <CAOFm3uFbkFAbA5U_d8uDYZ-4+ezEWdjnuVyqkpXQ0tg8u3Ds9A@mail.gmail.com>
References: <CGME20171227101226eucas1p2baa0309227b8e6a1e77dd7ca88f6412b@eucas1p2.samsung.com>
 <CAOFm3uEj7MDa_7OtigHcUPwvxkR+8cRS=UQq3x_y9k+ypcJPrg@mail.gmail.com> <87shbwh43f.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Andrew F . Davis" <afd-l0cyMroinI0@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87shbwh43f.fsf%l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=C5=81ukasz,

On Wed, Dec 27, 2017 at 11:12 AM, =C5=81ukasz Stelmach
<l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> It was <2017-12-22 pi=C4=85 19:30>, when Philippe Ombredanne wrote:
>> On Fri, Dec 22, 2017 at 5:38 PM, =C5=81ukasz Stelmach <l.stelmach@samsun=
g.com> wrote:
>>> It was <2017-12-22 pi=C4=85 14:34>, when Philippe Ombredanne wrote:
>>>> =C5=81ukasz,
>>>>
>>>> On Fri, Dec 22, 2017 at 2:23 PM, =C5=81ukasz Stelmach <l.stelmach@sams=
ung.com> wrote:
>>>>> Add support for True Random Number Generator found in Samsung Exynos
>>>>> 5250+ SoCs.
>>>>>
>>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>> Reviewed-by: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>>
>>>> <snip>
>>>>
>>>>> --- /dev/null
>>>>> +++ b/drivers/char/hw_random/exynos-trng.c
>>>>> @@ -0,0 +1,245 @@
>>>>> +/*
>>>>> + * RNG driver for Exynos TRNGs
>>>>> + *
>>>>> + * Author: =C5=81ukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>> + *
>>>>> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
>>>>> + *
>>>>> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
>>>>> + * Krzysztof Koz=C5=82owski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or mod=
ify
>>>>> + * it under the terms of the GNU General Public License as published=
 by
>>>>> + * the Free Software Foundation;
>>>>> + *
>>>>> + * This program is distributed in the hope that it will be useful,
>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> + * GNU General Public License for more details.
>>>>> + */
>>>>
>>>>
>>>> Would you mind using the new SPDX tags documented in Thomas patch set
>>>> [1] rather than this fine but longer legalese?
>>>>
>>>> And if you could spread the word to others in your team this would be =
very nice.
>>>> See also this fine article posted by Mauro on the Samsung Open Source
>>>> Group Blog [2]
>>>> Thank you!
>>>
>>> Cool! We've been using SPDX to tag RPM packages in Tizen for three year=
s or
>>> more. ;-)
>>
>> Very nice! any pubic pointers?
>                  ^^^^^
>
> I assume you request an URL of a publicly available web-page ;-)
>
> https://wiki.tizen.org/Packaging/Guidelines#License_Tag

Thank you!
I reckon it took me a minute to figure why you were making a somewhat
cryptic URL related comment.
Then I realized that I had made a rather unfortunate typo, or may be
it was a freudian slip of sorts :D

--=20
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
