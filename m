From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: exynos: Add nodes for True Random
 Number Generator
Date: Tue, 12 Dec 2017 11:35:56 +0100
Message-ID: <87k1xs6xo3.fsf%l.stelmach@samsung.com>
References: <20171211184913.n67q7vbv2gzknjeb@kozik-lap>
        <CGME20171212103557eucas1p202966a9335d52149ce69ef122f1758d8@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20171211184913.n67q7vbv2gzknjeb@kozik-lap>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-11 pon 19:49>, when Krzysztof Kozlowski wrote:
> On Mon, Dec 04, 2017 at 01:53:51PM +0100, =C5=81ukasz Stelmach wrote:
>> Add nodes for the True Random Number Generator found in Samsung Exynos
>> 5250+ SoCs.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
>>  arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
>>  arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
>>  arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
>>  4 files changed, 20 insertions(+)
>>
>
> Unfortunately the same story as with your PRNG patch - does not apply on
> top of my next/dt (after taking PRNG). Also did not apply on v4.15-rc1 +
> PRNG.
>
> Could you rebase on my next/dt?

Sure. Should I send it as along with the other two patches, if there were
no changes in them since?

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaL7EMAAoJELCuHpyYpYAQm8gH/1fXvDs208U1zfesgTY1okfO
HD7Gzp8aRLP3s99nD89fncOtjp21EfC+uDPFlbtR9q1rkNs95USfzMj+1axGBnJb
sp2/VKDaGAY6Pa/nV3y42fIR0U1jBghMoUO//Vu8VPUgJVFCeWk6o7cq/aJB9oqW
LtJn2tmNlEclRRDe0hKJuX/b3TSAQKOjwlfpFtQpO/U4NIOrbpn3UOO1e/SEADNK
DYJa25df21/mGmZAUpT6f5D+DSj8CnlDsDO2k0JyWPUUcpVo39it42cVeiY7p9x1
hx+xke5oIa2tWL6ehxec0NXDibKQ+FwVSVzk1aGsPhmSSUOyfFLif/78vPmW1mQ=
=PWl1
-----END PGP SIGNATURE-----
--=-=-=--
