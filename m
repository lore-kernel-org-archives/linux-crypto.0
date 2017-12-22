From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] hwrng: exynos - add Samsung Exynos True RNG
 driver
Date: Fri, 22 Dec 2017 13:41:18 +0100
Message-ID: <878tdvhr4h.fsf%l.stelmach@samsung.com>
References: <20171222083551.GF29663@gondor.apana.org.au>
        <CGME20171222124132eucas1p281d0ae6925ec5358baa3bbbc4e35b628@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        "Andrew F . Davis" <afd-l0cyMroinI0@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20171222083551.GF29663-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-22 pi=C4=85 09:35>, when Herbert Xu wrote:
> On Fri, Dec 22, 2017 at 09:29:38AM +0100, Marek Szyprowski wrote:
>> Hi,
>>=20
>> On 2017-12-22 09:24, Herbert Xu wrote:
>> >On Mon, Dec 04, 2017 at 01:53:50PM +0100, =C5=81ukasz Stelmach wrote:
>> >>Add support for True Random Number Generator found in Samsung Exynos
>> >>5250+ SoCs.
>> >>
>> >>Signed-off-by: =C5=81ukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> >This doesn't build for me:
>> >
>> >   CC [M]  drivers/char/hw_random/exynos-trng.o
>> >../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018exynos_rng_=
dt_match\u2019 undeclared here (not in a function)
>> >../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018__mod_of__e=
xynos_rng_dt_match_device_table\u2019 aliased to undefined symbol \u2018exy=
nos_rng_dt_match\u2019
>> >make[2]: *** [drivers/char/hw_random/exynos-trng.o] Error 1
>> >make[1]: *** [_module_drivers/char/hw_random] Error 2
>>=20
>> This looks like a missing dependency on "OF" when "COMPILE_TEST" is
>> selected.
>
> Actually it looks like a typo.  The variable is actually called
> exynos_trng_dt_match as opposed to exynos_rng_dt_match.

Indeed. Honestly, I haven't seen this problem, not even once. Right, I
have never compiled it as a module. Thanks for spotting.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaPP1vAAoJELCuHpyYpYAQZ7YH/38P2/ByWqbh4RAvQ/L3diOt
DaQhoivn62rb57snikdvkWaX4QspIUyGFBb1E+bPeFBbVr3Fthq3ZrCqea5fV7ev
6mh+NdjnoGq/bpzZ+uH24uX61MSd2UIICd+l20y7DnoqgrLGW6+q2zrSrWyiijnQ
UGSmezEKlhemftRit1wykKkMipr0iHnLYT2aL9PmcqIxTEmh7y85MMk3CgVstt1K
79UXufCcPnmg0AOIrwY2NlrB0XyGPVZXQT54XKy2vzU5drd2BpmIyKZKixbrTZSj
0SMnqhQJESGbARh2LNyop9o1UiWXpqzTjuQRN5HeH37aRYiQHBsQ376JwXYQB8A=
=u3N/
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
