From: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Subject: Re: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 09:37:16 -0700
Message-ID: <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
References: <20120328121744.GY32725@vnl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-W/+LCZmw4owx4+IdcdE5"
Cc: linux-crypto@vger.kernel.org,
	"roosa, william MAJ RES" <william-roosa@us.army.mil>,
	ryanc <ryanc@greengrey.org>
To: Dale Amon <amon@vnl.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57977 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2C1Qh2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 12:37:28 -0400
Received: by gghe5 with SMTP id e5so872443ggh.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Mar 2012 09:37:27 -0700 (PDT)
In-Reply-To: <20120328121744.GY32725@vnl.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-W/+LCZmw4owx4+IdcdE5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey there Dale & List,

I believe Ryan and Bill (CC'd) are using AES full disk crypto on their
systems.  It seems complicated to me, but they can probably give you
tips.  I think Bill is using Debian and Ryan is using Arch.  Bill's
(DISA's) policies are pretty strict and probably require that his smart
card be inserted at boot time.  Ryan's history administering the
intranet for a company in the medical field have set his bar probably
higher than DISA's in many ways, but may not require that the physical
token be inserted at boot.

Cheers && 73,

C.J.

On Wed, 2012-03-28 at 13:17 +0100, Dale Amon wrote:
> Been away from the list for awhile and you went
> and moved the list on me!
>=20
> Yesterday I pulled out my notes from the last time
> I set up a crypto disk and found that basically,
> nothing worked.
>=20
> The losetup lists all the appropriate crypto types
> in its Man page but when I try to actually use AES256,
> it throws a fit. When I look in modules for the
> current kernel, I do not see a module for aes at all.
>=20
> I might also note that I was surprised to find the -k
> switch for specifying key size is gone.
>=20
> I tried downloading a package with aes in it, but it
> turns out to require local build. So... I tried that.
>=20
> I discovered that the module failed to declare kpkg
> as a prerequisite. I eventually figured that error out
> and selected it manually.
>=20
> And then I tried everything I could think of short of
> going 'all the way in': I tried module-assistant; I
> tried m-a; I tried the commands from the INSTALL file
> one at a time. All of them failed.
>=20
> This is just SOOooo 1999... aren't things supposed to
> get better with time? ;-)
>=20
> I would be happy to supply any information required
> or to run a few tests in between other work. Test=20
> server is an ancient (perhaps 2003) box with Ubuntu
> Oneiric, fully up to date.
>=20
> If I want to use something like this for a production
> environment, it has to be solid and update and work
> forever into the future.=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-W/+LCZmw4owx4+IdcdE5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJPcz43AAoJEEyimPmPQm23+LwIAJUYCI2RiHCC5jTp3ySLw8vF
zTnluJkiNoIQSz31JGgho43wPagUT+zfCPM+E2oa6udZONGwyh3gVwnvfamGfI6+
7I+14tsoBoyOM7oCTpTn1NWx3s0SIB4oQgbHPthyZAX/o0V9qrg3tP/GIwBEoYi8
yIY19pf3NKF9lkc/hGJ70DIEd3Dt0GA1kFext3M6srNasG2o3afZF+Nn8T6Fdvwc
o8GZqz9VPKF1EPVzcn0iXmEJKViDt1TwgRBXvCOLoHY1C1LouwC4dvndWEvvUPjD
HFfhbiC4OULrcA/BtE03nol/uYgvAOLPSyrwJr+bqpqLIz7IYCBoh2FQUK2vlfE=
=XSyQ
-----END PGP SIGNATURE-----

--=-W/+LCZmw4owx4+IdcdE5--
