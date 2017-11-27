From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Mon, 27 Nov 2017 08:23:50 +0100
Message-ID: <87indwchh5.fsf%l.stelmach@samsung.com>
References: <CANc+2y4=Eas-i0jRwgTxqFeAngpPMKoUjVwsXWeU7G24g4252w@mail.gmail.com>
        <CGME20171127072355eucas1p218e3cbaeb1ba16b5a1262deda350d850@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37529 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdK0HYA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:24:00 -0500
In-reply-to: <CANc+2y4=Eas-i0jRwgTxqFeAngpPMKoUjVwsXWeU7G24g4252w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-11-24 pi=C4=85 16:25>, when PrasannaKumar Muralidharan wrote:
>> +}
>> +
>> +static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t ma=
x,
>> +                              bool wait)
>> +{
>> +       struct exynos_trng_dev *trng;
>> +       u32 val;
>> +
>> +       max =3D max > (EXYNOS_TRNG_FIFO_LEN * 4) ?
>> +               (EXYNOS_TRNG_FIFO_LEN * 4) : max;
>
> max is always > 32. This condition is not required.

No, it is not. http://elixir.free-electrons.com/linux/latest/source/drivers=
/char/hw_random/core.c#L67
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaG72GAAoJELCuHpyYpYAQ7TwH/RluMZvecCAMUJ+TOwqhwmo8
Pnd91DSwwzYfQdNuXapahStONC3jjrQOd6eRaKrxo6084H9iUpSeJIiZhBMvduDu
jvgi3Se+IkrlNZgsXeLHeTrxDoUvutib7tklV2yhrNEx5K/Yduf5/h5cK+jwCTzU
8ptGH41kAbRcMSwEau2MBYf48a0gWru27cFiSTIymdIjqHMBZH41BZSpdh0ivKnW
7nDd3+ZIANec+xyzt03fvHijtPOJlDjTN5N1ai+BC7DSc18EnPb58TaoYa1A1LQD
NjXi3SlzW9c2Xa3KdogCxQcOdLGMcGmEMq+KsFIkN0uJzS3aHMed2b+Gudo7GvU=
=mKSe
-----END PGP SIGNATURE-----
--=-=-=--
