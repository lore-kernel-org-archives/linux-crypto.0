From: Pierre <pinaraf@pinaraf.info>
Subject: Re: [PATCH] Fix NULL pointer deref. on no default_rng
Date: Wed, 20 Dec 2017 20:49:35 +0100
Message-ID: <2759758.0ipnKPUmi8@peanuts2>
References: <20171112142432.20186-1-pinaraf@pinaraf.info> <20171129063430.GD21575@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6883289.PLTocLC3K7"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50198 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755929AbdLTTuE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 14:50:04 -0500
In-Reply-To: <20171129063430.GD21575@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart6883289.PLTocLC3K7
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, November 29, 2017 5:34:30 PM CET Herbert Xu wrote:
> On Sun, Nov 12, 2017 at 03:24:32PM +0100, Pierre Ducroquet wrote:
> > If crypto_get_default_rng returns an error, the
> > function ecc_gen_privkey should return an error.
> > Instead, it currently tries to use the default_rng
> > nevertheless, thus creating a kernel panic with a
> > NULL pointer dereference.
> > Returning the error directly, as was supposedly
> > intended when looking at the code, fixes this.
> > 
> > Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
> 
> Patch applied.  Thanks.

Hi

How long will it take for the patch to be merged in an official release ?
This simple patch fixes a kernel panic at boot, it would be great for it to be 
merged in 4.15.

Thanks
 Pierre
--nextPart6883289.PLTocLC3K7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEds3aTMo5n1dvXH/GYkPWy+GpSGUFAlo6vs8ACgkQYkPWy+Gp
SGVB5A//QRovQhzDAJmr/SkgYY4ufb/vY+SxgekezdRMQGXVs6p0VCQIpUvkFOQw
OK4VqnhQt2DJsNnPez41P5oTqFlQXPXQH4s3wdrEoxfjkSv0pvrSoYchivCBAw7z
Nf16O/hSMdY+T3cu0HhEeYOnTB8UeiWQdHGj8eo28gU+L/JX92bFEwxTNAgWT8sD
MVR6xh75VG154gnw5Jz6hSG3sKbblVgkWTDLYouqAteYpebKRjbcNwVEaOAEZsR+
uGqNc6uv/EXKseYOxCgrM9s52h+PGnGjgBmhKOjyy5xIP4EHepiSl4jszW9C0NXc
OY3y4F3h42oJvTVhi2NxI7IG/raSDeOdnycRXn4DQAodof4TETWmC3BCm7ePq2Wb
CruYrDHWXYMw9I0dL3BRKwzwLObOSZHZnGjZaUJ1okLBgT560/9kUMt1TxQqTL3f
18lA7eWPBScbIUsjap/o7iKT1ZZzwfXGe8crywPqzCvGlbtETLaZvdU86mGZbmSP
T7SGrAIeLI3X0yeexDi/lZvF+hOISq3wN16WN6jXtR9YDkrFD1HMYFEpbbpN6yg5
ERXUoEAo/mfLXA6k2hgZUX56OtuRiU9bvgPC1g5ikZI9YlxmODY+qF3VGE9TKB03
PUb3GODc2VMUALCaviao7uglYSl8AyzRMvhixFRpp/CxBMQpmT4=
=pLp6
-----END PGP SIGNATURE-----

--nextPart6883289.PLTocLC3K7--
