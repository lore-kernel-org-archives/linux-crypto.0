From: Michael Halcrow <mike@halcrow.us>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Tue, 23 Oct 2007 19:59:22 -0500
Message-ID: <20071024005922.GU1635@halcrow.us>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com> <20071023204007.GT1635@halcrow.us> <20071024004230.GA3806@gondor.apana.org.au>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="h/77pM/XNBmEJr8g"
Cc: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org,
	mikko.herranen@cs.helsinki.fi
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:6215 "EHLO
	nlpi001.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXJXBIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 21:08:42 -0400
Content-Disposition: inline
In-Reply-To: <20071024004230.GA3806@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--h/77pM/XNBmEJr8g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2007 at 08:42:30AM +0800, Herbert Xu wrote:
> On Tue, Oct 23, 2007 at 03:40:08PM -0500, Michael Halcrow wrote:
> > On Tue, Oct 23, 2007 at 03:26:29PM -0500, Joy Latten wrote:
> > > +	unsigned int countersize;
> >=20
> > It's somewhat nicer to just use size_t in the kernel for these sorts
> > of data types. If you care about the exact number of bytes used by the
> > variable, types like u32 make the code more parsable.
>=20
> I don't see how this makes a difference here at all.

Functionally, it makes no difference. It's just a common kernel
convention to use size_t rather than unsigned int. I don't think this
is a big deal though.

> > > +	err =3D crypto_attr_u32(tb[4], &countersize);
> > > +	if (err)
> > > +		goto out_put_alg;
> >=20
> > It's also nice to have printk's along error paths. Syslogs down the
> > road tend to be less cryptic.
>=20
> Please don't.  That's what error return values are for.  Adding
> printk's means that we'd have to think about limiting them later
> when this is opened up for user-space access.

It is usually appropriate to print something to the system log when
there is an error condition in the kernel code. That can help triage
down the road when people have troubles.

The only reason I can think of as to why we would *not* want
explanations in the syslog for failures is if frequent failures are
expected in a significant fraction of deployments.

> > > -		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
> > > +		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
> > >  			    AES_CTR_ENC_TEST_VECTORS);
> > > -		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
> > > +		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
> > >  			    AES_CTR_DEC_TEST_VECTORS);
> >=20
> > I have never been particularly thrilled about the the string-based
> > method of parameterizing block ciphers for in-kernel API calls.
>=20
> If you have a better suggestion I'd love to hear it!

Well, for calls made internally from kernel functions to kernel
functions, pretty much anything other than writing sequences of
comma-delimited parameters into to a character string.

For instance, define regular old-fashioned C data structs for the
various ciphers and modes. Fill in those structures with their
requisite parameters, and pass pointers to those structs into the
crypto API. Just as we would do with objects for any other subsystem
of the kernel.

Mike

--h/77pM/XNBmEJr8g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRx6Y6ttAhTFtyodpAQMEdQgAhlCA2i6uk20eN5ZnvVDXhkKWMdQeO23t
8ZShAD7c+pP5I0cMJ3kcxFb23WdCyUcReRttctItgLkSLk2jws7YJ2LlL4WHc69c
DkIBIPFHfiREN4S/gf+D1ygGzaTGXjaJacD4N2cm5/iLOe36f+N6CkjdWa7PgVml
s7V8i7tPy9RuMbqPIv/iFxNOyJeSPYw0LmVuFG1d08rS5hbQsIE4mBLNXQnNWssJ
BO9+2COgp4Z1JoSm6W3uAYUmH2FdQPxCrFNazGJg7B3N6ouMSxrd03WUjyLoW1L7
1Al5yhChfCp1R++xdCBzAix0Xy9C/8LVkqlNV4oxCgKIJ43tBwctdg==
=qR5b
-----END PGP SIGNATURE-----

--h/77pM/XNBmEJr8g--
