From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 14:01:33 +0200
Message-ID: <20180724120133.GD26036@amd>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
 <20180719132003.GA30981@sandybridge-desktop>
 <20180720102532.GA20284@amd>
 <1532346156.3057.11.camel@suse.com>
 <20180723162302.GA4503@sandybridge-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Cc: Oliver Neukum <oneukum@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Yu Chen <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723162302.GA4503@sandybridge-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > >        "There have some functions be locked-down because
> > > >        there have no appropriate mechanisms to check the
> > > >        integrity of writing data."
> > > >        https://patchwork.kernel.org/patch/10476751/
> > >=20
> > > So your goal is to make hibernation compatible with kernel
> > > lockdown? Do your patches provide sufficient security that hibernation
> > > can be enabled with kernel lockdown?
> >=20
> > OK, maybe I am dense, but if the key comes from user space, will that
> > be enough?
> >=20
> Good point, we once tried to generate key in kernel, but people
> suggest to generate key in userspace and provide it to the
> kernel, which is what ecryptfs do currently, so it seems this
> should also be safe for encryption in kernel.

Safe against what kind of attack? Please describe what kind of
security you are trying to provide.

I don't think generating key in userspace is good enough for providing
guarantees for secure-boot.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltXFR0ACgkQMOfwapXb+vIR8gCfc62TqugayS53rcVP2MnxmUwN
Y90AoJNYo4QqdyjaJNvfaQ4OiWXLKyF9
=X7DD
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
