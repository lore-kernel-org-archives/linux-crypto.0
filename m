From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH v2 0/2] Propagate fallback bit for cbc and ctr
Date: Mon, 6 Mar 2017 09:20:14 -0300
Message-ID: <20170306122014.GF5364@gallifrey>
References: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34181 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdCFMUU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2017 07:20:20 -0500
Received: by mail-qk0-f174.google.com with SMTP id p64so31281692qke.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Mar 2017 04:20:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Any thoughts on this?

On Mon, Feb 27, 2017 at 09:38:24AM -0300, Marcelo Henrique Cerri wrote:
> Hi Hebert,
>=20
> For v2:
>=20
> - fixed the memory leakage in cbc.
> - included crypto/algapi.h in crypto/cbc.c for crypto_requires_off();
> - ERR_CAST instead PTR_ERR in ctr.
> - Also propagated the fallback bit for rfc3686.
>=20
> Marcelo Henrique Cerri (2):
>   crypto: cbc - Propagate NEED_FALLBACK bit
>   crypto: ctr - Propagate NEED_FALLBACK bit
>=20
>  crypto/cbc.c | 15 +++++++++++++--
>  crypto/ctr.c | 23 ++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 7 deletions(-)
>=20
> --=20
> 2.7.4
>=20

--=20
Regards,
Marcelo


--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYvVP+AAoJEM8aS8c01e1HyfQH/3Gt3TNtYHiJNRmpCfbXAn03
tP7/LEOniRtAmijmEADpy3TK/0cBWyvxW0qJ7mFqMyhR7oaW6/sy9+cMM0d2jOKj
miSoHM9ua66h/hjk3YXGF/obaNr9DgOwCdagpBmwpJiZK4PK+W02UkoEEb8deWHr
/8xQLLrgUkeMjVbwPPiT8Wm6cxqB0eAdZPX1mEqJujpk7WF/90KN+t8DMB6NaSFW
i99xMwWCstG4CIWj5IomXx+qDVXY+4vgFOhsgVgUFmRO8QvMajr1IjX4esCseC00
FrTuYkHFquuHQZ4/5+Xoj2kfUXJl6Yg7iy8fu1lEdmXn55ABduae4no3bRgPGCY=
=b5Zn
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
