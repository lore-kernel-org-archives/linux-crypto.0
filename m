From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: linux-image-2.6.24-1-686: airo hang when loading because of aes
Date: Tue, 02 Jun 2009 09:30:03 +0100
Message-ID: <1243931403.32406.125.camel@deadeye>
References: <20090602051234.GA24468@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0BzqauX7kTp3yLQ5hQnJ"
Cc: 478166@bugs.debian.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760482AbZFBIaH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 04:30:07 -0400
In-Reply-To: <20090602051234.GA24468@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-0BzqauX7kTp3yLQ5hQnJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 15:12 +1000, Herbert Xu wrote:
> Ben Hutchings <ben@decadent.org.uk> wrote:
> >=20
> > I believe geode_aes can be fixed by either (1) removing the MODULE_ALIA=
S
> > declaration or (2) making the module initialisation function fail if th=
e
> > device is not present.  The latter behaviour is generally wrong for PCI
> > drivers, but this device presumably cannot be hotplugged.
>=20
> I was going to remove this alias but found that it was already
> removed two years ago.  Please revise your theory based on this
> new discovery :)

As the subject says, this bug was found in 2.6.24.  Sorry I forgot to
check the current version; I generally would do that.  I think you've
confirmed that (1) is the correct fix.

Ben.

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-0BzqauX7kTp3yLQ5hQnJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKJOMG79ZNCRIGYgcRAoM6AKDGjzKvThljDNTGrozZIXqba5GqdACguQa2
UQwTdY7u9DaRzcO2uLjF4wM=
=haME
-----END PGP SIGNATURE-----

--=-0BzqauX7kTp3yLQ5hQnJ--
