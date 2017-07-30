From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Sun, 30 Jul 2017 12:44:53 +0200
Message-ID: <20170730104453.GA15517@amd>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com>
 <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
 <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
 <20170719015133.aijabk36g7m6daek@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
To: Theodore Ts'o <tytso@mit.edu>,
        Sandy Harris <sandyinchina@gmail.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39571 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbdG3Koz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2017 06:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20170719015133.aijabk36g7m6daek@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Tue 2017-07-18 21:51:33, Theodore Ts'o wrote:
> On Tue, Jul 18, 2017 at 09:00:10PM -0400, Sandy Harris wrote:
> > The only really good solution I know of is to find a way to provide a
> > chunk of randomness early in the boot process. John Denker has a good
> > discussion of doing this by modifying the kernel image & Ted talks of
> > doing it via the boot loader. Neither looks remarkably easy. Other
> > approaches like making the kernel read a seed file or passing a
> > parameter on the kernel command line have been suggested but, if I
> > recall right, rejected.
>=20
> It's actually not that _hard_ to modify the boot loader.  It's not
> finicky work like, say, adding support for metadata checksums or xattr
> deduplication to ext4.  It's actually mostly plumbing.  It's just that
> we haven't found a lot of people willing to do it as paid work, and
> the hobbyists haven't been interested.

Modifying the boot loader sources is not hard, right.

Deploying the modified boot loader is another story; these are
bootloaders -- they normally don't need updating, so they are often
not easy to update, or maybe updating them is risky.

Anyway, if you want to pay for some bootloader modifications... I'm
working for a company that can help :-). (Sometimes I use
pavel@denx.de address.)

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll9uKUACgkQMOfwapXb+vI5wwCgqSPGfi4E9DLuNMqAPlQ93y/j
LnwAn1cn50SUMRq+zFO/O597BPPp4gaw
=4V8m
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
