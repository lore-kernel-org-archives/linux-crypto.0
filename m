From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: linux-image-2.6.24-1-686: airo hang when loading because of aes
Date: Mon, 01 Jun 2009 03:02:50 +0100
Message-ID: <1243821770.14399.190.camel@deadeye>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6eUApQ/jnxhE39wrO8uO"
To: 478166@bugs.debian.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbZFACCz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 May 2009 22:02:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-6eUApQ/jnxhE39wrO8uO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

matthieu castet <castet.matthieu@free.fr> wrote:
> airo driver hang with 2.6.24-6 on a PIII.
> It seems it it because it need aes crypto.
> It will first try to load padlock-aes, but it fails to load
> Then it load geode_aes which load, and airo hang (airo seems to use
> geode_aes). [1]
[...]

geode_aes is a PCI driver and should be automatically loaded if the PCI
device it handles is present.  However, since it also declares the alias
"aes", when the crypto system attempts to load the "aes" module it may
load this module and then wait for up to a minute for it to initialise
and register the "aes" algorithm.  geode_aes will never do this, since
if there was a suitable device present it would already have been
loaded.

(The padlock modules don't seem to have the same problem because their
module initialisation functions immediately return failure if the CPU
doesn't support.)

I believe geode_aes can be fixed by either (1) removing the MODULE_ALIAS
declaration or (2) making the module initialisation function fail if the
device is not present.  The latter behaviour is generally wrong for PCI
drivers, but this device presumably cannot be hotplugged.

Ben.

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-6eUApQ/jnxhE39wrO8uO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKIzbG79ZNCRIGYgcRAqvHAKCJx7vR1QgVu4FNobf4Dfk55mT27ACg2iLW
FqSaO/JiNTUoTeFBXdPQu/Y=
=YKPM
-----END PGP SIGNATURE-----

--=-6eUApQ/jnxhE39wrO8uO--
