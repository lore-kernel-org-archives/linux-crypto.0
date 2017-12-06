From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: locking in prng
Date: Wed, 06 Dec 2017 13:42:45 +0100
Message-ID: <87r2s89ge2.fsf%l.stelmach@samsung.com>
References: <CGME20171206124255eucas1p1ba52696d686126cfad3942b5734f54b4@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46906 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdLFMm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 07:42:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am preparing some improvements for the exynos-rng PRNG driver. It is a
driver for hardware PRNG in Exynos SoCs. The hardware should not be
access simultaneously by more than one thread/processe or it may return
the same data to all of them.

Are there any locks betweend kernel consumers or userspace and the
driver or should the driver has its own lock to serialize hardware
access?

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaJ+XFAAoJELCuHpyYpYAQxDQH/1P4rsAOahP1ZRmKzW4EsT0X
nlMv3oVnBRgCJHW91+yxA/1FpnUTqZGB+8NHUZX7TszzmmYDASSeZAgpII+quWyk
rlgP/B6jvU5HzAORq854pu1wARatECVZdzDTOWRK7Ucc86o8M1xaIUWltkO5WKDg
QPWEgCB7RlkNx76dDb7W0LgvcteUpigfu0V7MnFAfCT86YDMG9c7rTj8GPY48vzX
a49S6Z3f58waSBtTOJaK3oiZJxsqL9lme0ol6MNsSe6I+O10CXlptpYnbhNiPar+
11haSCid72tZLquH46e1XRgvTrPONZbuvJZ5ev/bshgmvQxWB1rPHa8fJl2jQSo=
=8MjU
-----END PGP SIGNATURE-----
--=-=-=--
