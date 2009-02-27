From: Huang Ying <ying.huang@intel.com>
Subject: Bug of dm-crypt?
Date: Fri, 27 Feb 2009 13:31:56 +0800
Message-ID: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C8aD9h2TUTjVKanprVlB"
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZB0FcA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 00:32:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-C8aD9h2TUTjVKanprVlB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Herbert,

I had ever heard from you that the only thing guaranteed in the
completion function of async ablkcipher cryption is the req->data has
the value you set before. The request pointer itself may be changed. But
in dm-crypt, I found they rely on request pointer in completion
function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.

Do you think that is a bug?

Best Regards,
Huang Ying


--=-C8aD9h2TUTjVKanprVlB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmneskACgkQKhFGF+eHlphtiwCfQ9im6KaQMLtOzmVh3i++vMum
KNEAn2iRukI6aTTMK19O6JcRkHW4GPQf
=36Y9
-----END PGP SIGNATURE-----

--=-C8aD9h2TUTjVKanprVlB--

