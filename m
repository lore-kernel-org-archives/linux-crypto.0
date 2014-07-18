From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Fri, 18 Jul 2014 18:36:45 +0200
Message-ID: <1883713.E4uoxDXDyt@caliban.sf-tec.de>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart22677037.uztPAu2aTS"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--nextPart22677037.uztPAu2aTS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Theodore Ts'o wrote:

> DESCRIPTION
> 
> 	The system call getrandom() fills the buffer pointed to by buf
> 	with up to buflen random bytes which can be used to seed user
> 	space random number generators (i.e., DRBG's) or for other
> 	cryptographic processes.  It should not be used Monte Carlo
> 	simulations or for other probabilistic sampling applications.

The "for" looks misplaced, shouldn't this be "for Monte Carlo simulations or 
other ..."?

Greetings,

Eike
--nextPart22677037.uztPAu2aTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlPJTSMACgkQXKSJPmm5/E6o7gCggoszbVeh52J3cF1yROIdHqc9
yOAAnA8gcIcFthALvU++/WoUU0HNhDVX
=YeqZ
-----END PGP SIGNATURE-----

--nextPart22677037.uztPAu2aTS--
