From: Michael Halcrow <mike@halcrow.us>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Tue, 23 Oct 2007 22:22:23 -0500
Message-ID: <20071024032223.GV1635@halcrow.us>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com> <20071023204007.GT1635@halcrow.us> <20071024004230.GA3806@gondor.apana.org.au> <20071024005922.GU1635@halcrow.us> <20071024011905.GA4063@gondor.apana.org.au>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="wu6d9FdQ4ohoCGf7"
Cc: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org,
	mikko.herranen@cs.helsinki.fi
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:25380 "EHLO
	nlpi015.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXJXDbo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 23:31:44 -0400
Content-Disposition: inline
In-Reply-To: <20071024011905.GA4063@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--wu6d9FdQ4ohoCGf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 24, 2007 at 09:19:05AM +0800, Herbert Xu wrote:
> These paths can be triggered from user-space in future so printks
> are not appropriate.

I am familiar with CryptoDev and Cryproc. Will you be implementing
anything similar to what these projects are currently doing? Or do you
have something else entirely in mind?

Mike

--wu6d9FdQ4ohoCGf7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRx66bttAhTFtyodpAQNWEQf9FSrZtYixnoSdWL2sQFl4XNm1q5ikH4qE
viXWvIu3cHEvI4Y5CyY93ycGgsl+zXEdd9xSh9TzxWEeI9ED+AQKUDx/5qekyDky
zRIwgEkQbSMwJ4vL+TqANYqzDkLj9M3OHCv+HmlRpkpPaZW4/rl3+FL3CYggJNi8
Rn+kp8MXb3TkBvhOeGEriO+elIPoL1nbpBJaYGvY74gozQ75KZPTPoE1fPBPrw4u
IQHGV15kPEurPB9lrCLMWkXkc8QasaXjkFZYize/LpBu/3PteH4TrEaQbNXfSZhB
P6ekS3BGq21jV7lXX4OAfTA2fhbPpqe6ZhknHCOPw+3yqg4xc/MCMg==
=ZjHr
-----END PGP SIGNATURE-----

--wu6d9FdQ4ohoCGf7--
