From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 10/11] crypto: sun4i-ss: fix large block size support
Date: Mon, 29 May 2017 10:29:31 +0200
Message-ID: <20170529082931.ocoatlnpl7fvtgfu@flea.lan>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
 <20170524190652.13278-11-antoine.tenart@free-electrons.com>
 <20170526145501.GA19284@Red>
 <20170529080944.GA3169@kwain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rynuluogfa56aubc"
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52804 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdE2IaE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 04:30:04 -0400
Content-Disposition: inline
In-Reply-To: <20170529080944.GA3169@kwain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--rynuluogfa56aubc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2017 at 10:09:44AM +0200, Antoine Tenart wrote:
> > Which speed are the SS clocks ?
>=20
> The AHB SS clk is running at 300 MHz and the SS clk at 150 MHz. SS clk
> is at the expected rate but the AHB SS clk has a higher rate that what's
> expected.
>=20
> In the probing function only the SS clk rate is explicitly set. I tried
> to set the AHB clk rate as well and removed the delays. This didn't fix
> the framework selftests at boot time. Is there any reason the AHB SS clk
> rate isn't explicitly set when probing the driver? (Should it?)

It probably shouldn't.

The AHB clock is shared by most of the drivers, some of them actually
using that clock to generate their signals.

You would have to unbreak all those drivers first, which is probably
not needed at all. I haven't seen a case where a block had a module
clock and did care for its AHB clock rate.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--rynuluogfa56aubc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZK9vrAAoJEBx+YmzsjxAg/w8P/j/SF3hzSk7Z3EdPc5iZXGVL
Sacbi9DDpFLXpbVeQrSHmLERMbEjDqrfMb0sHnF/qY0SkMsDIG3uwV8wEV0FY2R+
5G2irsmRSN06/2Qv9Tk6KUao+npcVYZy7IpRNqIj4IiZMChHiUbM/UOyYqqRklc6
mn+Ki834rBj+IHUBCZblPvyV3lNFll0xp9dbiuE+2qjOvujtuCH19qFOk2UCub7Q
p32EIj9tXTg2HxWFJOSfP8BXc7Endo0zgWWoqk5f7d4emDznSOMW5WGJUmgkoTdq
1RnvfxQZPTYvXl8gUu7cqvkKi+G4yWXdbjNs8VWtfotWd2wI26AZ+WNAuPDUZwc3
k5Q3DNri80SpAPouHb9oGYU60nvtSu2ygsCf7TlW3mdyN8dYrBjLWHxbbUkfUpgQ
GxzcO7qdpJulGkUnOvAbobFJkK95zathBnxJe3jZEsGIHiOBfD5lVpXqYkNERMuz
xV5EWYOaoIlZsaHC7dIPgYiMTdu+DS5S5YsikFk515H+qfO4QMHj7m7Avl6+bm5J
Qs6v3+ACMtg54qyb2gWRsBShFTpfJPqn5koV7bSuM/oYpDM89vSQo77FzxfeF7+b
oaasIEifGYUYeSH1JeEzuKEk269D3uOKxF9W7BJBv5lmqpLhaXfVUcSNG0fQQxvG
N+o17BlAfDY7k9/988MW
=bNfV
-----END PGP SIGNATURE-----

--rynuluogfa56aubc--
