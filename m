From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Fri, 20 Jul 2018 12:25:32 +0200
Message-ID: <20180720102532.GA20284@amd>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
 <20180719132003.GA30981@sandybridge-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
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
In-Reply-To: <20180719132003.GA30981@sandybridge-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > As security becomes more and more important, we add the in-kernel
> > > > > encryption support for hibernation.
> > > >=20
> > > > Sorry, this does not really explain what security benefit it is
> > > > supposed have to against what attack scenarios.
> > > >=20
> > > > Which unfortunately means it can not reviewed.
> > > >=20
> > > > Note that uswsusp already provides encryption. If this is supposed =
to
> > > > have advantages over it, please say so.
> > > >=20
> > > The advantages are described in detail in=20
> > > [PATCH 1/4]'s log, please refer to that.
> >=20
> > Are you refering to this?
> >
> Not this one. I've sent v2 of this patch set which
> explain more on this:
> https://patchwork.kernel.org/patch/10532935/

Aha, sorry about that.

> Let me paste the log here:
>=20
> 1. (This is not to compare with uswsusp but other
>     tools) One advantage is: Users do not have to
>     encrypt the whole swap partition as other tools.

Well.. encrypting the partition seems like good idea anyway.=20

> 2. Ideally kernel memory should be encrypted by the
>    kernel itself. We have uswsusp to support user
>    space hibernation, however doing the encryption
>    in kernel space has more advantages:
>    2.1 Not having to transfer plain text kernel memory to
>        user space. Per Lee, Chun-Yi, uswsusp is disabled
>        when the kernel is locked down:
>        https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
>        linux-fs.git/commit/?h=3Dlockdown-20180410&
>        id=3D8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
>        due to:
>        "There have some functions be locked-down because
>        there have no appropriate mechanisms to check the
>        integrity of writing data."
>        https://patchwork.kernel.org/patch/10476751/

So your goal is to make hibernation compatible with kernel
lockdown? Do your patches provide sufficient security that hibernation
can be enabled with kernel lockdown?

>    2.2 Not having to copy each page to user space
>        one by one not in parallel, which might introduce
>        significant amount of copy_to_user() and it might
>        not be efficient on servers having large amount of DRAM.

So how big speedup can be attributed by not doing copy_to_user?

>    2.3 Distribution has requirement to do snapshot
>        signature for verification, which can be built
>        by leveraging this patch set.

Signatures can be done by uswsusp, too, right?

>    2.4 The encryption is in the kernel, so it doesn't
>        have to worry too much about bugs in user space
>        utilities and similar, for example.

Answer to bugs in userspace is _not_ to move code from userspace to kernel.

> > Also note that joeyli <jlee@suse.com> has patch series which encrypts
> > both in-kernel and uswsusp hibernation methods. His motivation is
> > secure boot. How does this compare to his work?
> >
> Joey Lee and I had a discussion on his previous work at
> https://patchwork.kernel.org/patch/10476751
> We collaborate on this task and his snapshot signature
> feature can be based on this patch set.

Well, his work can also work without your patchset, right?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltRuJwACgkQMOfwapXb+vKoLwCeNp7X2wxMaONvzvgt9uMDavdt
k+0An2rCHACwENvM76lCmYBRfo+H+9h2
=giC4
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
