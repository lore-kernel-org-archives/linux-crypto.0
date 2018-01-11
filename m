From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH] hwrng: exynos - Signedness bug in exynos_trng_do_read()
Date: Thu, 11 Jan 2018 13:38:29 +0100
Message-ID: <87373czi2i.fsf%l.stelmach@samsung.com>
References: <20180110093658.kxnmhqkoow7o2xab@mwanda>
        <CGME20180111123843eucas1p1d074063cbd2fc3b408caeeb7ec3cedcc@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20180110093658.kxnmhqkoow7o2xab@mwanda>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2018-01-10 =C5=9Bro 10:36>, when Dan Carpenter wrote:
> "val" needs to be signed for the error handling to work.
>
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaV1rFAAoJELCuHpyYpYAQUK4H/jaPr27lLBudkUq4jzviACaD
rKRfP6hlOfKSY3XRGmas2w+3uY0uN78c9ddqSU/pyXNaTI+/QSRFis8dBI036vKv
hj/6OGirFyqpFEGWE3wWF5zoTTt3vtLIPQHSQtuajQoG5T0zuhPkvVeo9klxLCL+
l7F2l/ckhoZBcveoU0Z2rY7pcJfTOemPZVvsU8Lprw1jbEwvf7lLIYjbMWM+1YVW
b/gxZgZDczJXukj+5iFLEEf1phjugE1TvuxGsRUQhKUxpes7NEVFo5RSYCw7y1NP
wUTly1nZOsYSygDhiuYjmpCBNw7hvan43PGWva4TfchiwKiKrVM3bDZqlRVRD5o=
=MQNj
-----END PGP SIGNATURE-----
--=-=-=--
