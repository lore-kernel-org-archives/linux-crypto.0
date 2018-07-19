From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 19 Jul 2018 13:01:49 +0200
Message-ID: <20180719110149.GA4679@amd>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
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
In-Reply-To: <20180718235851.GA22170@sandybridge-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-07-19 07:58:51, Yu Chen wrote:
> Hi,
> On Wed, Jul 18, 2018 at 10:22:35PM +0200, Pavel Machek wrote:
> > On Thu 2018-07-19 00:38:06, Chen Yu wrote:
> > > As security becomes more and more important, we add the in-kernel
> > > encryption support for hibernation.
> >=20
> > Sorry, this does not really explain what security benefit it is
> > supposed have to against what attack scenarios.
> >=20
> > Which unfortunately means it can not reviewed.
> >=20
> > Note that uswsusp already provides encryption. If this is supposed to
> > have advantages over it, please say so.
> >=20
> The advantages are described in detail in=20
> [PATCH 1/4]'s log, please refer to that.

Are you refering to this?

# Generally the advantage is: Users do not have to
# encrypt the whole swap partition as other tools.
# After all, ideally kernel memory should be encrypted
# by the kernel itself.

Sorry, this does not really explain what security benefit it is
supposed have to against what attack scenarios.

Note that uswsusp already provides encryption. If this is supposed to
have advantages over it, please say so.

Also note that joeyli <jlee@suse.com> has patch series which encrypts
both in-kernel and uswsusp hibernation methods. His motivation is
secure boot. How does this compare to his work?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltQb50ACgkQMOfwapXb+vJRegCfdloEMqo/8OjQ8iUXht7vmf1J
/jwAn1qMR2BSC4CNsYN7BUmawMByRuzR
=wdh8
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
