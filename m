From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Sun, 5 Aug 2018 11:44:32 +0200
Message-ID: <20180805094432.GA22948@amd>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
 <20180718142625.GA5942@thunk.org>
 <20180804215209.GA3201@localhost>
 <20180805002514.GF4461@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Yann Droneaud <ydroneaud@opteya.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180805002514.GF4461@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2018-08-04 20:25:14, Theodore Y. Ts'o wrote:
> On Sat, Aug 04, 2018 at 11:52:10PM +0200, Pavel Machek wrote:
> > > However, enabling config option means that the CRNG will be
> > > initialized with potentially information available to the CPU
> > > manufacturer and/or Nation States, and this persists *after*
> > > initialization / early boot.  So to say, "we're perfectly safe after
> > > we leave initialization / early boot" is not true.
> >=20
> > This should really be explained in the help text.
> >=20
> > I assume that after 10 seconds of moving mouse, user is safe even when
> > rdrand is backoored?
>=20
> You'll hate this answer, but "it depends".  Suppose someone is using
> an init script which generates ssh keys upon first boot if they are
> missing.  If this is the case, *and* RDRAND is backdoored, then the
> keys will be generated in such a way that they *might* be succeptible
> to being guessed by a nation state.  Moving your mouse around for 1000
> or 10,000 seconds won't help if the host's ssh keys has already been
> generated.

Yep, understood, but after moving the mouse, /dev/random &
/dev/urandom can be trusted afaict.

> Depending on your hardware, no mouse motion might be necessary at all.
> On my laptop (a Dell XPS 13 model 9370) using an dm-crypt protected
> root disk, and running a Debian testing userspace, with a 4.18-rc6
> based kernel, the "CRNG is initialized" message is printed *before*
> the root file system is mounted.

Entropy is easy to gather on any laptop. cat /dev/sda > /dev/null :-).

> On other systems, where the hardware does not issue as many
> interrupts, the mouse motion might be extremely important in order to
> get the "CRNG is initialized" message.
>=20
> > (Plus, I'd say this should be kernel command line option, not config
> > option...?)
>=20
> Agreed, there should be a command line option as well.  I just haven't
> gotten around to it yet, and in the meantime, having a config option
> is better than nothing.   Patches gratefully accepted...  :-)

Well, this was RFC :-). I actually don't think config option is good
idea. Command line option is enough.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltmxwAACgkQMOfwapXb+vIjlgCgnqUZ7Qv6cY/V9TqL13r+UIEB
KMoAn1XlG4RzYJsKqFZOOgBvVwiKU6Aq
=/iEp
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
