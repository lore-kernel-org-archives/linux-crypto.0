From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH V2 00/27] Drivers: ccree - align block comments
Date: Tue, 30 May 2017 08:49:41 +0200
Message-ID: <20170530064941.GA5802@kwain>
References: <20170530060937.12981-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Derek Robson <robsonde@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41751 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdE3Gtx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:49:53 -0400
Content-Disposition: inline
In-Reply-To: <20170530060937.12981-1-robsonde@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Derek,

On Tue, May 30, 2017 at 06:09:37PM +1200, Derek Robson wrote:
> Fixed block comments across whole ccree driver

Since all these commits are doing the same logical change across a
single driver, you could probably squash them all into a single one.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZLRYDAAoJEFxNi8it27zYpQQP/RUucoo+wnNxYCOgfJodcL5c
xbLAtDLI6rBjKvC8i93vsIyvt5lvPEgnp2BGrxTvdpousWNq74vzEIocsl+tqx7F
BonpY+WZNwnO0H26naTwhLCEVmx4kaq1JWkuNpZK+hlNb+4tnn/p3HGqaJstmiIV
LtyuDEGG7rDOmUaQIRDeh+IAESAta+vVUIcxPtk/curbpQR/F94KYd8VuDbT9U3P
B8vY8Mqs0DRxktD68pUB64KXQs4SxRmv8/Va1IZirN1WpevvQgSz6OhPE9BCt6GO
+pPbrwJN93yCcNKVR0pZdpkao+8SCg7AI5Lgkfkd5VLAvvs10oyA/jkhkRiTf68Z
3xgRFhzRrrZQVM8ys+s/DV2XWKQnfTVVUZcF0BBT0PF+n7zcVs5clmGHTGpd2UyA
HyAnlO2XpNxkxSf9qEftTwDECvSAo63PrFnGZCBrN51wy982nLI/mexGAFmUg0uL
00JF+ERQ5y4Qflt+XVKdqCxZfB3DeY4qj7vx3v6P6KGkbWWon4TPthohSgm977h1
AsPl0TB+Mvjlq9fzIKQpSIUykbW2wcL21EDjqEzGWJ+/zVNJc2OogkMU6mtoHnA4
lzDC3nuXbj7XIPZFzSmXTDPvaJEvyl0rMpEbRfzDHikIEoNY9xnfcd7dx41cym6R
8lTKbwQtzIWEQgcnhnso
=uXrm
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
