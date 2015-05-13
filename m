From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in
 descriptor mode
Date: Wed, 13 May 2015 10:23:55 +0200
Message-ID: <20150513082355.GT10961@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <1431445063-20226-3-git-send-email-maxime.ripard@free-electrons.com>
 <20150512174936.284783d4@free-electrons.com>
 <20150512155824.GJ19927@lunn.ch>
 <20150512180539.4ea5d158@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
Cc: Andrew Lunn <andrew@lunn.ch>, Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753955AbbEMIZE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 04:25:04 -0400
Content-Disposition: inline
In-Reply-To: <20150512180539.4ea5d158@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2015 at 06:05:39PM +0200, Thomas Petazzoni wrote:
> Andrew,
>=20
> On Tue, 12 May 2015 17:58:24 +0200, Andrew Lunn wrote:
>=20
> > A quick grep for marvell,orion, marvell,kirkwood and marvell,dove
> > suggests it should have the - if we want to be consistent with older
> > Marvell devices. As you said, starting with marvell,armanda it gets
> > pretty inconsistent :-(
>=20
> Yes, with the "-" would be better IMO.

changed to armada-380-xor, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUwobAAoJEBx+YmzsjxAgsCEQAJRestbJeFlabTOFZsveCDq+
9B/XlgQ4JNLG5eLTod3aUv8IwM0JIhCKzvS+IBb2TsOZfl6PCnu5JXyZEaQOrQ/n
J1wC58wYbDluVDMKh5pVMpNf6rVEN3P2u6b62K7Iq287wdb2+8vb90g3fdq9ZH0w
Wz9vCLgEZVMFgsNMillBjEnSGbt9acOA1kqcP2kiQcmzTK6+ZP4BO+lL5+GAhZzC
iuDB0h+4HyidKA5tKhOFOYdzU3/qH4mjp0lQ+zjrDDAVZZgGO+NivjUupdBKWSHt
gEIWmsC2W7+4pDkLV/nG25h9PcSq0K0WqP+nHFG8UmB0bsaCOye3jRQ3GS+PGI4S
j4XxxCrLR9ElIriDM6qaAndmuxd50uLDRgdelIEhubU7aGx1rLZ2ZYRfSUwNs5bx
LKD5Ya2EE7aRqHhqXYTrZDmLw8Hh12rfxgteYkCqQpiQ+IelY9zUu9mYXfwk5Zuh
juxRiCbJsws6zVE8DwDTZO1nA+rEAq2pk0PUOYsXw/d7R+XsmDAMfJLYQRgIu0Ec
0JIAze+d2CY48tDP4Vjm1+YZ9ZM/Vila6T3cEa5Wo4qtQHbrnDt1gsGwbuXfYtoa
cZUro2SnPaLU0ErIsYZCf+Smx7PLVxP47Gnvdl1R8CVqdZQHNBI1I8bakkuOXVEz
nwoJGpvHGchdIEmfpjwo
=sxVF
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
