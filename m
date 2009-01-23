From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Clarification of allowed context for crypto routines
Date: Fri, 23 Jan 2009 22:29:46 +0300
Message-ID: <200901232229.47885.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1351120.y7ki5iFoNh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:37970 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753699AbZAWT3x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2009 14:29:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart1351120.y7ki5iFoNh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

According to Documentation/crypto/api-intro.txt:

DEVELOPER NOTES

Transforms may only be allocated in user context, and cryptographic
methods may only be called from softirq and user contexts.  For
transforms with a setkey method it too should only be called from
user context.

As I can understand, user context requirement is due to potential for=20
setkey to sleep (although it appears, that currently the only module=20
that can sleep is shash which is calling kmalloc with GFP_KERNEL). Is it=20
correct?

But where is the difference between hard and softirq contexts? I fail to=20
see any technical reason for this requirement.

Thank you!

=2Dandrey

--nextPart1351120.y7ki5iFoNh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6GqsACgkQR6LMutpd94wabgCgz9YRcaGpNcysA8t6WMH8YIS1
2GoAoInnK/mDJP+wp00/nu2fEM4dBR+M
=2w+r
-----END PGP SIGNATURE-----

--nextPart1351120.y7ki5iFoNh--
