From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Mon, 23 Jul 2018 14:22:27 +0200
Message-ID: <20180723122227.GA30092@amd>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
 <20180719132003.GA30981@sandybridge-desktop>
 <20180720102532.GA20284@amd>
 <1532346156.3057.11.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Cc: Yu Chen <yu.c.chen@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Oliver Neukum <oneukum@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1532346156.3057.11.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > 2. Ideally kernel memory should be encrypted by the
> > >    kernel itself. We have uswsusp to support user
> > >    space hibernation, however doing the encryption
> > >    in kernel space has more advantages:
> > >    2.1 Not having to transfer plain text kernel memory to
> > >        user space. Per Lee, Chun-Yi, uswsusp is disabled
> > >        when the kernel is locked down:
> > >        https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
> > >        linux-fs.git/commit/?h=3Dlockdown-20180410&
> > >        id=3D8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
> > >        due to:
> > >        "There have some functions be locked-down because
> > >        there have no appropriate mechanisms to check the
> > >        integrity of writing data."
> > >        https://patchwork.kernel.org/patch/10476751/
> >=20
> > So your goal is to make hibernation compatible with kernel
> > lockdown? Do your patches provide sufficient security that hibernation
> > can be enabled with kernel lockdown?
>=20
> OK, maybe I am dense, but if the key comes from user space, will that
> be enough?

Yes, that seems to be one of problems of Yu Chen's patchset.

> > > Joey Lee and I had a discussion on his previous work at
> > > https://patchwork.kernel.org/patch/10476751
> > > We collaborate on this task and his snapshot signature
> > > feature can be based on this patch set.
> >=20
> > Well, his work can also work without your patchset, right?
>=20
> Yes. But you are objecting to encryption in kernel space at all,
> aren't you?

I don't particulary love the idea of doing hibernation encryption in
the kernel, correct.

But we have this weird thing called secure boot, some people seem to
want. So we may need some crypto in the kernel -- but I'd like
something that works with uswsusp, too. Plus, it is mandatory that
patch explains what security guarantees they want to provide against
what kinds of attacks...

Lee, Chun-Yi's patch seemed more promising.				Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltVyIMACgkQMOfwapXb+vIOHwCfWnqIbC9JuKoYO//G3dJDkF4H
cqYAnReOwwOusvgY1EgOrXWVBygOU3+J
=lsnx
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
