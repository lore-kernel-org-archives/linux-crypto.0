From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: crypto: xts: regression in 4.10
Date: Wed, 22 Feb 2017 14:42:09 -0300
Message-ID: <20170222174209.GA20626@gallifrey>
References: <20170221231717.GA7186@nicolas-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Nicolas Porcel <nicolasporcel06@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36395 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754252AbdBVRso (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 12:48:44 -0500
Received: by mail-qk0-f180.google.com with SMTP id x71so9751167qkb.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2017 09:48:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170221231717.GA7186@nicolas-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

What XTS implementations do you have available on /proc/crypto after the
error?

Some drivers that allocate fallback implementations using the older API
started to fail after the generic templates were converted to skcipher.


On Wed, Feb 22, 2017 at 12:17:17AM +0100, Nicolas Porcel wrote:
> Hello,
>=20
> I am using aes-xts-plain64 with LUKS headers to crypt the root. In 4.10,
> the partition cannot be opened and I have the following errors when
> booting:
>=20
>     device-mapper: table: 253:0: crypt: Error allocating crypto tfm
>     device-mapper: ioctl: error adding target to table
>     device-mapper: reload ioctl on  failed: No such file or directory
>     Failed to setup dm-crypt key mapping for device /dev/mmcblk0p2
>     Check that the kernel supports aes-xts-plain64 cipher (check syslog f=
or more info)
>=20
> I found that this commit is responsible for the regression (reverting it
> solves the problem):
>=20
> > commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Tue Nov 22 20:08:19 2016 +0800
> >=20
> >     crypto: xts - Convert to skcipher
>=20
> Some precision: I am using the vanilla kernel source for 4.10. The aes,
> xts and dm-crypt modules are directly compiled in the kernel and not as
> modules. I also had the same problem with kernel 4.10-rc*.
>=20
> Is it a known issue? I found 1 related email with no answer on the
> dm-crypt mailing. If this is a regression, I can start digging, although
> any guidance would be greatly appreciated.
>=20
> Thank you in advance,
>=20
> Best regards,
>=20
> --=20
> Nicolas Porcel

--=20
Regards,
Marcelo


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYrc1xAAoJEM8aS8c01e1HKdoIALuD+LT1GUWdnarNN9VP2FLs
Sy6g6GnnpTnIHLm+3mlqWLDwJAvd3BtswGxjKjVKXbk5B4tKlYiSuawS153UEcs0
YXtRJqcSnkJfc7IwAP/Iqzhru2sTnE+yfOE1UFMMQPn/YILuuAHcBsmeVjldLPwn
lEfnkZUSyYVneA08eyx04HDurSWPtGNtuB3y/BbXAncPJCZneFId43AOZkj3aVcM
I+5K/I3H/B6iM/a2tiuYQqVqY9AI0fK/r9+CJLfFOfDwCnwBRgKfS4JCrK0bchNz
fwxHazauOm5OR+J81h0djnrifD1M2n7QsEEULtT1d0xtRCLOtrIQn2xpTF9VBBU=
=SHKd
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
