From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 1/3] crypto: exynos - Support Exynos5250+ SoCs
Date: Wed, 06 Dec 2017 15:53:02 +0100
Message-ID: <87374naoxd.fsf%l.stelmach@samsung.com>
References: <CAJKOXPfep5BeJMz=qHqF4m05c2=5DgnFjPeA21n2EMJnyXvoQA@mail.gmail.com>
        <CGME20171206145312eucas1p226d52f60f15e45456aefd6270cc88e07@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBo?= =?utf-8?Q?=C5=82nierkiewicz?=
        <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAJKOXPfep5BeJMz=qHqF4m05c2=5DgnFjPeA21n2EMJnyXvoQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-06 =C5=9Bro 15:05>, when Krzysztof Kozlowski wrote:
> On Wed, Dec 6, 2017 at 2:42 PM, =C5=81ukasz Stelmach <l.stelmach@samsung.=
com> wrote:
>> It was <2017-12-05 wto 14:34>, when Krzysztof Kozlowski wrote:
>>> On Tue, Dec 5, 2017 at 1:35 PM, =C5=81ukasz Stelmach <l.stelmach@samsun=
g.com> wrote:
>>>> Add support for PRNG in Exynos5250+ SoCs.
>>>>
>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>> ---
>>>>  .../bindings/crypto/samsung,exynos-rng4.txt        |  4 ++-
>>>>  drivers/crypto/exynos-rng.c                        | 36 +++++++++++++=
+++++++--
>>>>  2 files changed, 36 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>>> b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>>> index 4ca8dd4d7e66..a13fbdb4bd88 100644
>>>> --- a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>>> +++ b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>>> @@ -2,7 +2,9 @@ Exynos Pseudo Random Number Generator
>>>>
>>>>  Required properties:
>>>>
>>>> -- compatible  : Should be "samsung,exynos4-rng".
>>>> +- compatible  : One of:
>>>> +                - "samsung,exynos4-rng" for Exynos4210 and Exynos4412
>>>> +                - "samsung,exynos5250-prng" for Exynos5250+
>>>>  - reg         : Specifies base physical address and size of the regis=
ters map.
>>>>  - clocks      : Phandle to clock-controller plus clock-specifier pair.
>>>>  - clock-names : "secss" as a clock name.
>>>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>>>> index 451620b475a0..894ef93ef5ec 100644
>>>> --- a/drivers/crypto/exynos-rng.c
>>>> +++ b/drivers/crypto/exynos-rng.c
>>>> @@ -22,12 +22,17 @@
>>>>  #include <linux/err.h>
>>>>  #include <linux/io.h>
>>>>  #include <linux/module.h>
>>>> +#include <linux/of_device.h>
>>>>  #include <linux/platform_device.h>
>>>>
>>>>  #include <crypto/internal/rng.h>
>>>>
>>>>  #define EXYNOS_RNG_CONTROL             0x0
>>>>  #define EXYNOS_RNG_STATUS              0x10
>>>> +
>>>> +#define EXYNOS_RNG_SEED_CONF           0x14
>>>> +#define EXYNOS_RNG_GEN_PRNG            0x02
>>>
>>> Use BIT(1) instead.

Done.

>>>> +
>>>>  #define EXYNOS_RNG_SEED_BASE           0x140
>>>>  #define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0=
x4))
>>>>  #define EXYNOS_RNG_OUT_BASE            0x160
>>>> @@ -43,6 +48,11 @@
>>>>  #define EXYNOS_RNG_SEED_REGS           5
>>>>  #define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
>>>>
>>>> +enum exynos_prng_type {
>>>> +       EXYNOS_PRNG_TYPE4 =3D 4,
>>>> +       EXYNOS_PRNG_TYPE5 =3D 5,
>>>
>>> That's unusual numbering and naming, so just:
>>> enum exynos_prng_type {
>>>       EXYNOS_PRNG_EXYNOS4,
>>>       EXYNOS_PRNG_EXYNOS5,
>>> };
>>>
>>> Especially that TYPE4 and TYPE5 suggest so kind of sub-type (like
>>> versions of some IP blocks, e.g. MFC) but it is just the family of
>>> Exynos.
>>
>> Half done. I've changed TYPE to EXYNOS.
>>
>> I used explicit numbering in the enum because I want both values to act
>> same true-false-wise. If one is 0 this condition is not met.
>
> First of all - that condition cannot happen. It is not possible from
> the device-matching code.

Let me explain what I didn't want. With the enum:

    enum exynos_prng_type {
            EXYNOS_PRNG_EXYNOS4,
            EXYNOS_PRNG_EXYNOS5,
    };

and a code like this

    if (rng->type) {
=20=20=20=20
    }

EXYNOS_PRNG_EXYNOS4 is identical to false while EXYNOS_PRNG_EXYNPOS5
evaluates as true. I think this is a bad idea. I don't want it ever to
happen. Because chips have their own numbers I thought using those
numbers would be OK.

> But if you want to indicate it explicitly
> (for code reviewing?) then how about:
> enum exynos_prng_type {
>        EXYNOS_PRNG_UNKNOWN =3D 0,
>        EXYNOS_PRNG_EXYNOS4,
>        EXYNOS_PRNG_EXYNOS5,
> };
>
> In such case you have the same effect but your intentions are clear
> (you expect possibility of =3D0... which is not possible :) ).

Fair enough.

>>>> +               dev_info(&pdev->dev,
>>>> +                        "Exynos Pseudo Random Number Generator (type:=
%d)\n",
>>>
>>> dev_dbg, this is not that important information to affect the boot time.
>>
>> Quite many devices report their presence during boot with such
>> messages. For example:
>>
>> [    3.390247] exynos-ehci 12110000.usb: EHCI Host Controller
>> [    3.395493] exynos-ehci 12110000.usb: new USB bus registered, assigne=
d bus number 1
>> [    3.403702] exynos-ehci 12110000.usb: irq 80, io mem 0x12110000
>> [    3.431793] exynos-ehci 12110000.usb: USB 2.0 started, EHCI 1.00
>>
>> From my experience it isn't printk() itself that slows down boot but the
>> serial console.
>
> True, the console is bottleneck (not necessarily serial) [1] but that
> does not change the fact there is no need to print the type of RNG.

With values of the enum not being meaningful themselves printing the
type does not make much sense for me too. Is it ok just to print report
the device presence?

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaKAROAAoJELCuHpyYpYAQBQcH/115cxhZ65LJqVPtROd76qzi
Hq191cpKOSA+By0HYACjEId14ZdKS+XkcpxPH//sUzNqrKf4zQ9WsxZjmNsd+Uvt
vnt65fRo2QFiWQFei634/Qb2CYsHysKpejK1NNXAqFICSos6HguABYrIxUq5NYgm
4FatSoLoJ1yhrqCR8SiDX7GjXG+vktwsQc8f7TrNpP4a0LL1hvCou/gZGNeSeiEn
hPdDiDTqI5sBDxTI8Sh51HXyINoAPTbwlrn/tK8KkwtEG12BJJwByhd7H3VpIPfJ
sB7h+5DcvhKMFfi7D6mVkhgMHNFMeuA/6Bw7o2Rh1nvmd/0aHy0cvwxuECLAcNQ=
=t5Cs
-----END PGP SIGNATURE-----
--=-=-=--
