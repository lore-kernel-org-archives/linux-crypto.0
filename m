From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Wed, 27 Apr 2016 12:17:44 +0800
Message-ID: <20160427041744.GA27044@gondor.apana.org.au>
References: <20160318144240.GA20816@gondor.apana.org.au>
 <20160318173423.GB19137@kroah.com>
 <20160319022307.GA25338@gondor.apana.org.au>
 <1461670976.14569.40.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461670976.14569.40.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 26, 2016 at 01:42:56PM +0200, Ben Hutchings wrote:
>
> It looks like the bug was introduced in 3.10 by:
>=20
> d733ac90f9fe8ac284e523f9920b507555b12f6d
> Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Date:=A0=A0=A0Sun Apr 7 16:43:46 2013 +0300
>=20
> =A0=A0=A0=A0crypto: gcm - fix rfc4543 to handle async crypto correctl=
y
> =A0 =A0=A0
> So 3.2.y and 3.4.y don't need this fix - or should they get both fixe=
s?

If that patch is not present then my fix can't be applied.  However,
I think this change itself is probably needed in 3.2/3.4 as otherwise
GCM would be broken if the underlying cipher is async.  It's not a
big deal on x86 because the main async AES provider also provides
GCM directly, but on other architectures it may be an issue.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
