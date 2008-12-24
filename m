From: Huang Ying <ying.huang@intel.com>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Wed, 24 Dec 2008 09:43:41 +0800
Message-ID: <1230083021.17529.98.camel@yhuang-dev.sh.intel.com>
References: <20081219202603.GA31265@lst.de>
	 <20081220032159.GA15615@gondor.apana.org.au>
	 <1230022166.17529.82.camel@yhuang-dev.sh.intel.com>
	 <20081223130154.GA23717@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-whTb7l66gUkeG2tKBcMe"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Christoph Hellwig <hch@lst.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54295 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYLXBno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2008 20:43:44 -0500
In-Reply-To: <20081223130154.GA23717@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-whTb7l66gUkeG2tKBcMe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-23 at 21:01 +0800, Sebastian Andrzej Siewior wrote:
> * Huang Ying | 2008-12-23 16:49:26 [+0800]:
>=20
> >If aes_x86_64 and aes_generic are compiled as builtin, the
> >initialization order is undetermined. That is, aes_x86_64 may be
> >initilized before aes_generic is initilized, but aes_x86_64 depends on
> >tables generated in aes_generic initialization code. aes_x86_64 can
> >not work before aes_generic is initialized, so that cause register
> >time testing failed with following error message:
>=20
> Couldn't we link arch/x/crypto after crypto ?

I think that is not easy. Not all architecture follow the same directory
structure arch/<x>/crypto. And arch/x86/crypto is used by user mode
linux too.

Best Regards,
Huang Ying


--=-whTb7l66gUkeG2tKBcMe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklRk8oACgkQKhFGF+eHlph7MACeJ+HSnPbn5vgiZ+KcvNW/yVCk
V9oAn3ddW9a9cn+tviCDwEfO9MsF0Ec2
=33J+
-----END PGP SIGNATURE-----

--=-whTb7l66gUkeG2tKBcMe--

