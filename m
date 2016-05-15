From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Sun, 15 May 2016 20:48:35 +0100
Message-ID: <1463341715.2631.49.camel@decadent.org.uk>
References: <20160318144240.GA20816@gondor.apana.org.au>
	 <20160318173423.GB19137@kroah.com>
	 <20160319022307.GA25338@gondor.apana.org.au>
	 <1461670976.14569.40.camel@decadent.org.uk>
	 <20160427041744.GA27044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i9AS1ZBjTzt09AAKhlc9"
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160427041744.GA27044@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-i9AS1ZBjTzt09AAKhlc9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-04-27 at 12:17 +0800, Herbert Xu wrote:
> On Tue, Apr 26, 2016 at 01:42:56PM +0200, Ben Hutchings wrote:
> >=20
> >=20
> > It looks like the bug was introduced in 3.10 by:
> >=20
> > d733ac90f9fe8ac284e523f9920b507555b12f6d
> > Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> > Date:=C2=A0=C2=A0=C2=A0Sun Apr 7 16:43:46 2013 +0300
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0crypto: gcm - fix rfc4543 to handle async crypt=
o correctly
> > =C2=A0 =C2=A0=C2=A0
> > So 3.2.y and 3.4.y don't need this fix - or should they get both
> > fixes?
> If that patch is not present then my fix can't be applied.=C2=A0=C2=A0How=
ever,
> I think this change itself is probably needed in 3.2/3.4 as otherwise
> GCM would be broken if the underlying cipher is async.=C2=A0=C2=A0It's no=
t a
> big deal on x86 because the main async AES provider also provides
> GCM directly, but on other architectures it may be an issue.

I've queued up both of these for 3.2.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-i9AS1ZBjTzt09AAKhlc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXONKTAAoJEOe/yOyVhhEJr2kQAJk8ketckVbiqoTMtnCV9Lqj
QYl255B1L+gA0/6oupOi5rRVBnfPEyw7PDA7JMW7ELilTCdN7MFNP+5ytoHUrb/4
dVaUhSJmOPUnQ/xceo9Ky4u6P9TO7gNJhKe2arK2sZt2DrYlV3xQ1LvswO2EJvki
gcPWWNy3SEy+fj2cjT5DHV5tJS8MFQ7fUKQwSi4Y5d30z1gqi+jIJoHYJbF/BrKL
U93wTLBfTs2vJEge4IW8Xa4Nv9wQXLf0CcGwOZqaTcUwiqPBGSNUeXFTNJIYeO0j
2KfllfjUgzsglcxv0T2nACnXF5ImBeU+d9Il/xmO/WUf1BJ8a+WcbDTaGdG3s5XN
ET4QifbE5t5VtlIOJvGIoih9MBXteowCadfsn2mP73YhijYqhWDGgeREyOOHycrK
ma90Do4VhrPdPaBgtekUlvjBplgRs/saUtVO3T0LpRghp8hlNBZqQlx8+yReJSg+
HAkv+3/zuVOufajVkmhTNPWesfucXk1N1G5KMZzjSU2R5gwJ10S3+ZhjNurdxEM9
SmkQrC6ibdYtw/kklBnvUuUEd65fmUIhXN887YysLaO27yG08fAcV0B3kI3byMPL
+HM0ocNtUH5sn4fbFuYw8nEBUbzUj53dMt/KcedY45SNktSeDItymJl8LhmCf2c+
kwptCenJFu2cHoLzFoIN
=wLMI
-----END PGP SIGNATURE-----

--=-i9AS1ZBjTzt09AAKhlc9--
