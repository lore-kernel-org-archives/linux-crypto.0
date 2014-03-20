From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/6] SP800-90A Deterministic Random Bit Generator
Date: Thu, 20 Mar 2014 14:30:33 +0100
Message-ID: <13817639.cfCaQvh16D@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de> <532AA307.504@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com
To: Clemens Ladisch <clemens@ladisch.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:52037 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbaCTNao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 09:30:44 -0400
In-Reply-To: <532AA307.504@ladisch.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 20. M=E4rz 2014, 09:12:55 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > This is a clean-room implementation of the DRBG defined in SP800-90=
A.
>=20
> Why?  I guess it's for certification?

As per SP800-131A, the ANSI X9.31 DRNG is sunset by the end of 2014 and=
 not=20
allowed to be used in FIPS 140-2 compliant environments. The kernel cry=
pto API=20
implements an ANSI X9.31 DRNG in crypto/ansi_cprng.c as the only DRNG t=
hat=20
complies with FIPS 140-2 at this time.

Without a replacement for this ANSI X9.31 DRNG, the kernel will not hav=
e an=20
=46IPS 140-2 approved DRNG any more starting from 2015.
>=20
> > +static bool drbg_fips_continuous_test(struct drbg_state *drbg,
> > +				     unsigned char *buf)
> > ...
> > +	ret =3D memcmp(drbg->prev, buf, drbg_blocklen(drbg));
> > +	...
> > +	/* invert the memcmp result, because the test shall pass when the
> > +	 * two compared values do not match */
> > +	if (ret)
> > +		return true;
> > +	else
> > +		return false;
>=20
> This looks strange.  The return value of memcmp() is not really
> a boolean, and the code appears not to match the comment because the
> numeric value of ret is not actually inverted.  How about this:

Correct, the comment does not match the code as I had invered the logic=
 of=20
drbg_fips_continuous_test as per Rafael's comment. Yet, I did not updat=
e the=20
comment.
>=20
> 	ret =3D memcmp(...);
> 	...
> 	/* the test shall pass when the compared values are not equal */
> 	return ret !=3D 0;

I will add that change.
>=20
>=20
> Regards,
> Clemens


Thanks
Stephan
--=20
| Cui bono? |
