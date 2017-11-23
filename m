From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Thu, 23 Nov 2017 19:46:24 +0100
Message-ID: <87o9nsde9r.fsf%l.stelmach@samsung.com>
References: <CAJKOXPfaofwB7Sp5Lg0JuZzFwC2RahdWDG5KfsJyNcKDt3b_mA@mail.gmail.com>
        <CGME20171123184736eucas1p15d4e73d5a6596a6cba1f940dcc473c9a@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CAJKOXPfaofwB7Sp5Lg0JuZzFwC2RahdWDG5KfsJyNcKDt3b_mA@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-11-23 czw 17:31>, when Krzysztof Kozlowski wrote:
> On Thu, Nov 23, 2017 at 4:09 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> Add support for True Random Number Generator found in Samsung Exynos
>> 5250+ SoCs.
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  MAINTAINERS                          |   7 +
>>  drivers/char/hw_random/Kconfig       |  12 ++
>>  drivers/char/hw_random/Makefile      |   1 +
>>  drivers/char/hw_random/exynos-trng.c | 256 ++++++++++++++++++++++++++++=
+++++++
>>  4 files changed, 276 insertions(+)
>>  create mode 100644 drivers/char/hw_random/exynos-trng.c
>>

[...]

>>  endif # HW_RANDOM
>
> Thanks for working on TRNG.
>
> 1. I was rather thinking about extending existing exynos-rng.c [1] so
> it would be using TRNG as seed for PRNG as this gives you much more
> random data. Instead you developed totally separate driver which has
> its own benefits - one can choose which interface he wants. Although
> it is a little bit duplication.

As far as I can tell, these are two different devices. However, PRNG
shares hardware with the hash engine. Indeed there is a hardware to
connect TRNG and PRNG, but, IMHO, it might be hard to model that
dependency in kernel. To me it seems easier to read TRNG (or
/dev/random) and and write the result to PRNG manually (in software).

> 2. I understand that in your current version of TRNG driver there is
> no conflict with PRNG and they can work both at the same time?

I guess so. I expect no problems as long as TRNG_SEED_START is not set
in the HASH_SEED_CONF register.

> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/crypto/exynos-rng.c
>

>> +
>> +       trng->rng.init =3D exynos_trng_init;
>> +       trng->rng.read =3D exynos_trng_do_read;
>> +       trng->rng.priv =3D (unsigned long) trng;
>> +
>> +       platform_set_drvdata(pdev, trng);
>> +       trng->dev =3D &pdev->dev;
>> +
>> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       trng->mem =3D devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(trng->mem)) {
>> +               dev_err(&pdev->dev, "Couldn't map IO resources.\n");
>> +               ret =3D PTR_ERR(trng->mem);
>> +               goto err_ioremap;
>> +       }
>> +
>> +       pm_runtime_enable(&pdev->dev);
>> +       ret =3D pm_runtime_get_sync(&pdev->dev);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "pm_runtime_get_sync() failed: %d.\n=
", ret);
>> +               goto err_ioremap;
>
> Missing pm_runtime_disable?

Added a separate label down below.

>> +               dev_err(&pdev->dev, "Couldn't get clock.\n");
>> +               ret =3D PTR_ERR(trng->clk);
>> +               goto err_clock;
>> +       }
>> +
>> +       ret =3D clk_prepare_enable(trng->clk);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Unable to enable the clk: %d.\n", r=
et);
>> +               goto err_clock;
>> +       }
>> +
>> +       ret =3D hwrng_register(&trng->rng);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Couldn't register hwrng device.\n");
>> +               goto err_register;
>> +       }
>> +
>> +       dev_info(&pdev->dev, "Exynos True Random Number Generator.\n");
>> +
>> +       return 0;
>> +
>> +err_register:
>> +       clk_disable_unprepare(trng->clk);
>> +
>> +err_clock:
>> +       trng->mem =3D NULL;
>
> Why this has to be null-ified?

I found this pattern in omap-rng.c.

Removed.

I'll wait a little bit more before posting v2.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaFxeAAAoJELCuHpyYpYAQlbgH/3M4djvomtz2/xlNiURwk5xG
XEao8jOBO8voEi17NR3rOSkSTQ/w+tEBEdKntlmCms4z0KfOzwQF4CbKubLtb56K
cdpRzvXNd6BxrV998in2pDfLYPHRvpL0IJnDVxnhCzYBv7eBitXaYizogokRTQgI
hldTBgzBKU8ul1hQXjDOd6PIR8DLUTcXMnyV1Xtw2P9jENMvupWWDzxO1Thp51uB
wC6XdX6YC89wvu5p3PevzxiHaRQCok7fLiLNth6zlPpXVG+Cy5vOmXO9q8cSI4Qz
wurANxC/KMbZBovNP+LzKKfkvV9Vaoy4kjGVzwdyfqeYKaLK48l2Eqtnjtspo/U=
=IiNf
-----END PGP SIGNATURE-----
--=-=-=--
