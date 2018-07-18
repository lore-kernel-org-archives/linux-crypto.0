From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Wed, 18 Jul 2018 22:22:35 +0200
Message-ID: <20180718202235.GA4132@amd>
References: <cover.1531924968.git.yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Len Brown <len.brown@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1531924968.git.yu.c.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-07-19 00:38:06, Chen Yu wrote:
> As security becomes more and more important, we add the in-kernel
> encryption support for hibernation.

Sorry, this does not really explain what security benefit it is
supposed have to against what attack scenarios.

Which unfortunately means it can not reviewed.

Note that uswsusp already provides encryption. If this is supposed to
have advantages over it, please say so.

								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltPoYsACgkQMOfwapXb+vKdrgCfUQP2u+ZlEhNDSLldzKr8dcxd
ne0An1BJyqc3NUoaj8S10n3/0GMlehL5
=xZmc
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
