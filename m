From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#485070: cryptsetup: "FATAL" padlock_{aes,sha} error during
 boot
Date: Sat, 30 Jul 2011 11:15:03 +0200
Message-ID: <1312017303.2677.7.camel@deadeye>
References: <20110730061307.GA24394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-GY22luavbYpKzFX7mxoN"
Cc: Ralf Jung <ralfjung-e@gmx.de>, linux-crypto@vger.kernel.org,
	katzj@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	485070-done@bugs.debian.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1G3JPP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jul 2011 05:15:15 -0400
In-Reply-To: <20110730061307.GA24394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-GY22luavbYpKzFX7mxoN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Version: 3.7-pre2-1

On Sat, 2011-07-30 at 14:13 +0800, Herbert Xu wrote:
> Ralf Jung <ralfjung-e@gmx.de> wrote:
> > Hi,
> >=20
> > as per request of Jonathan at http://bugs.debian.org/cgi-
> > bin/bugreport.cgi?bug=3D485070, I am reporting the mentioned bug to thi=
s list as=20
> > well:
> >=20
> > With current Debian testing (Kernel 2.6.39), I am getting this error on=
 each=20
> > boot:
> > FATAL: Error inserting padlock_sha (/lib/modules/2.6.39-2-
> > amd64/kernel/drivers/crypto/padlock-sha.ko): No such device
> > I understand it is harmless, but it should still be fixed since it irri=
tates=20
> > users suggesting something is seriously going wrong.
>=20
> That message comes from user-space and needs to be fixed there.

Right, it comes from modprobe.

Fixed in module-init-tools version 3.5, commit
cdafffbadc5831ad56fe00ecd420ca9c36e9474f ("don't warn noisely if loading
multiple module aliases").

Ben.


--=-GY22luavbYpKzFX7mxoN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATjPLjee/yOyVhhEJAQoDgw//cAU4HBhLYatgpwvgqEE2i2Y8dGCFr7gE
0s/7G7wPlKZYFO/oGJUD4+yEspYJh9Su763OOrZJubD1yVBfa3z6WYjLGUdGbDLv
2V/f1S4Tau0ATheMRCyH0FTiYJbu6ncJVcmweyTCmkpIxbTwOzq1YzXt10MAD57F
ExLpgJ2BQole/66JRCfvAftLVBAgocVXomPDT2G7iGqyWeyHlWbRnlpxKHWzTBJZ
WRQDOpuptsxUTZBB7nIPG+KfrfR2FkSfnHrw9FV6KyRj5HCKzkJnBrnLqbYY42dM
3rGRR9Bfyct2LC8HrLVLXIi5q2IxuQn8PUBIZOJnM3aCxxABKqxhAZTMmqJxtum3
tOdyicSfQlK/rqrX+KZh/QKGZWRjkgvBWdgHL5YSw8w2s+V8dwJGCfgWKdSbc66F
LE2a7J1iUQCvSAOLiKZhqPQ0g7Q/4CaUd6uuDTk1T0aQ9klHZnA8pxE7eT8cqZRF
DebrDzj01sYbU045nq35UKHZNDGPW850UUEJXkeLbBrDaPP2AKLiPQf7tPuBDpu0
yyKuirtfqkxV1e0/FQsuZ++Gl/tnPzTBqmwBZAL+hN9m6IgJX6N6sNyBofw4JkuR
TTLkJpcaImtk2ZhGDrPP1pzVlQOz2buJgFG5vmnhL0SGrQlHBM1muRoC5PA+8WVV
StO5+X2Vios=
=axcO
-----END PGP SIGNATURE-----

--=-GY22luavbYpKzFX7mxoN--
