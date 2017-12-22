From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [PATCH v4] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 22 Dec 2017 19:30:38 +0100
Message-ID: <CAOFm3uEj7MDa_7OtigHcUPwvxkR+8cRS=UQq3x_y9k+ypcJPrg@mail.gmail.com>
References: <CGME20171222163901eucas1p253c4258fb141ea955c40185cd2f38197@eucas1p2.samsung.com>
 <CAOFm3uG2aBHWUgVyzPuU8XJaLbm78cWEuWvgLEvNfc-hiefAbw@mail.gmail.com> <87y3luhg4f.fsf%l.stelmach@samsung.com>
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
In-Reply-To: <87y3luhg4f.fsf%l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 22, 2017 at 5:38 PM, =C5=81ukasz Stelmach <l.stelmach@samsung.c=
om> wrote:
> It was <2017-12-22 pi=C4=85 14:34>, when Philippe Ombredanne wrote:
>> =C5=81ukasz,
>>
>> On Fri, Dec 22, 2017 at 2:23 PM, =C5=81ukasz Stelmach <l.stelmach@samsun=
g.com> wrote:
>>> Add support for True Random Number Generator found in Samsung Exynos
>>> 5250+ SoCs.
>>>
>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>> Reviewed-by: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>> <snip>
>>
>>> --- /dev/null
>>> +++ b/drivers/char/hw_random/exynos-trng.c
>>> @@ -0,0 +1,245 @@
>>> +/*
>>> + * RNG driver for Exynos TRNGs
>>> + *
>>> + * Author: =C5=81ukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>> + *
>>> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
>>> + *
>>> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
>>> + * Krzysztof Koz=C5=82owski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modif=
y
>>> + * it under the terms of the GNU General Public License as published b=
y
>>> + * the Free Software Foundation;
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>
>>
>> Would you mind using the new SPDX tags documented in Thomas patch set
>> [1] rather than this fine but longer legalese?
>>
>> And if you could spread the word to others in your team this would be ve=
ry nice.
>> See also this fine article posted by Mauro on the Samsung Open Source
>> Group Blog [2]
>> Thank you!
>
> Cool! We've been using SPDX to tag RPM packages in Tizen for three years =
or
> more. ;-)

Very nice! any pubic pointers?


>>> +MODULE_LICENSE("GPL");
>>
>> Per module.h this means GPL2 or later. This is not matching your
>> license above which does not state any version and therefore would
>> mean GPL1 or later,
>
> Thanks for spotting. My intention is GPL-2.0.
>
>> Please make sure you use something and common rather than this and
>> make sure your MODULE_LICENSE is consistent with the top level
>> license.
>>
>> Was it this way in the code from Krzysztof?
>
> Yes. And omap-rng, the second of my sources of reference, too. Actually,
> the majority of modules still specify "GPL".
>
>  281 | "Dual */*"
> 2082 | "GPL v2"
> 6359 | "GPL"
> ---- +---------
> 8784 | Total
>
> Fixing.


Sigh. That's a lot! Now I have the tool to spot all these differences.
I need to run this and review.
As a first pass aligning the MODULE_LICENSE with the top level would
be something that requires minimal discussion I guess.

>> [1] https://lkml.org/lkml/2017/12/4/934
>> [2] https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spd=
x/
>
> --
> =C5=81ukasz Stelmach
> Samsung R&D Institute Poland
> Samsung Electronics

--=20
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
