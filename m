From: Ryan Corder <ryanc@greengrey.org>
Subject: Re: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 12:03:22 -0700
Message-ID: <20120328190322.GA16113@greengrey.org>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Cc: Dale Amon <amon@vnl.com>, linux-crypto@vger.kernel.org,
	"roosa, william MAJ RES" <william-roosa@us.army.mil>
To: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.greengrey.org ([204.13.164.209]:54843 "EHLO
	mail.greengrey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2C1TSY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 15:18:24 -0400
Content-Disposition: inline
In-Reply-To: <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 28, 2012 at 09:37:16AM -0700, C.J. Adams-Collier KF7BMP wrote:
| card be inserted at boot time.  Ryan's history administering the
| intranet for a company in the medical field have set his bar probably
| higher than DISA's in many ways, but may not require that the physical
| token be inserted at boot.

It really depends on which machine it is.  The nice thing about LUKS is that
you can define multiple keys per encrypted volume.  In the case of one of my
headless machine, I have two defined: one passphrase I physically type in a=
nd
a giant on that is on a USB key (in the event I need to reboot the machine =
but
don't want to have to find a monitor and keyboard).

Full disk encryption with LUKS is actually pretty easy, and I do have the f=
ull
process written down.  I've been looking for a reason to actually type it o=
ut
for later use...I'll do that later today and then send it on for reference.

later.
ryanc

--=20
http://pgp.mit.edu:11371/pks/lookup?search=3Dryanc%40greengrey.org

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (OpenBSD)

iEYEARECAAYFAk9zYHoACgkQhYjGp77jeBP4TwCfbX0k6Brgpz0K/2cugTL25GzL
vhQAn0fssmXl5pkvz6CbtJikFlsNZF51
=dBQ8
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
