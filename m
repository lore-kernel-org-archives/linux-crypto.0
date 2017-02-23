From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Thu, 23 Feb 2017 10:42:04 -0300
Message-ID: <20170223134204.GB10083@gallifrey>
References: <20170222221700.GA19026@gallifrey>
 <20170223112156.GA14038@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34328 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdBWNuH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 08:50:07 -0500
Received: by mail-qt0-f181.google.com with SMTP id n21so28600950qta.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2017 05:50:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170223112156.GA14038@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

It makes sense. Thanks for the clarification, Herbert.

One more question: are you planning to convert the ctr template to
skcipher?

--=20
Regards,
Marcelo

On Thu, Feb 23, 2017 at 07:21:56PM +0800, Herbert Xu wrote:
> Marcelo Cerri <marcelo.cerri@canonical.com> wrote:
> >
> > I noticed you used a similar approach in arch/s390/crypto/aes_s390.c
> > (commit 64e2680).
> >=20
> > How do you ensure the skcipher operation will not be asynchronous?=20
>=20
> You need to set the bit CRYPTO_ALG_ASYNC in the mask field when
> allocating the algorithm to ensure that it's synchronous.
>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYruarAAoJEM8aS8c01e1HL/wH/jJKDHdg6cZsell7H9IsbCNV
72OTfgTw+kWcz7fmtBCSdMjmhqfgQT7BHZ4sjz7vA2S+uCehnrVEsAB6pbKhUUkP
dHj//9c6kqwu5buA4i8UkobybW3jK/PXQPninyjo9pT4ajW+UdEjGjIVUBvL4EFA
tZeQZy8lfqeH1unEEtcmH2qGp9nuaIff9ZTscBT3+Kp6pCu95q2LNKY9licOiQnZ
KgqqdRdrT8mKGQu603295mCPOeE7hYzdaSsCrVjr1vfwLtv2XySiO4by/AHL1xyR
sqMVjy2GKpQo7uvZyApnuglgIzr6swxbRjj3zYENJFsJcsRrGzi+WjqfmL8L2Xg=
=zDZN
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
