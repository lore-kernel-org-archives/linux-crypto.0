From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH v2 2/4] crypto: exynos - Improve performance of PRNG
Date: Tue, 12 Dec 2017 15:49:47 +0100
Message-ID: <877ets6lx0.fsf%l.stelmach@samsung.com>
References: <CAJKOXPf-Znkiq49ny=uOuTrY+=LX+CxZOQyqbKTy5EBi5MQSTg@mail.gmail.com>
        <CGME20171212144953eucas1p2079156cb46dc72e2a73868ca2d88ba05@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41688 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdLLOt7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 09:49:59 -0500
In-reply-to: <CAJKOXPf-Znkiq49ny=uOuTrY+=LX+CxZOQyqbKTy5EBi5MQSTg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-11 pon 15:54>, when Krzysztof Kozlowski wrote:
> On Mon, Dec 11, 2017 at 3:06 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej
>> Zolnierkiewicz <b.zolnierkie@samsung.com>
>
> This should not appear here.

A glitch in a scripted invocation of git-format-patch, fixed.

>> Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
>> to retrieve generated numbers from the registers of PRNG.
>>
>> Rearrange the loop around cpu_relax(). In a loop with while() at the
>> beginning and the cpu_relax() removed the retry variable is decremented
>> twice (down to 98).
>
> I had troubles with understanding this sentence... and then I figured
> out that you are referring to some case without cpu_relax(). I do not
> see how it is relevant to this case. Compare the new code with old,
> not with some imaginary case without barriers (thus maybe reordered?).
>
> Your solution is strictly performance oriented so it would be nice to
> see here the exact difference in numbers justifying the change. But
> only the change for while() -> do-while(), not mixed with
> memcpy_fromio.

Apparently, after trhough tests, I must admit, the way the status
register is being polled is insignificant for the performance. I will
remove from the patch any changes in the loop.

It is the way, the random bytes are copied from the regiesteres, that
makes the difference (5.9 MB/s vs 7.1 MB/s)

Thank you very much for your assistance in reaching this conclusion.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaL+yMAAoJELCuHpyYpYAQDDEIAJEkaEUo7tLg/+kYYdmhBa2a
PgYBu4rSJ/xF4MDLpFOZJCW4iuspSBc2nLjnqScQ0h5C9IDlcQS5cRy400pY9x6U
X5o6NOPJ8R3QrbUYeMZoUIPuMOzQOMKwPAHdXq6HAx0nPHd4gDLfUIUiInLHHZ9o
+O9nlOvH/AZ/i4KizNJK4CDpbTV/0tRJWLBs3ajmNxh6kkc/a+RvF3OAojutPre8
lPY11Q+MyEugnuhVGdU4rrHuJvZ3fUydWtiiCXnZ4vpWgOemNdQjC5yrWXCBkoUu
fbW8OOGhZphKoNd1iQWuQ4rvCjt3tqetWUcHMNM6aUFuu0XgW1myAq7RJvYE8Ds=
=L6rH
-----END PGP SIGNATURE-----
--=-=-=--
