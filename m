From: Huang Ying <ying.huang@intel.com>
Subject: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Fri, 16 Jan 2009 11:10:36 +0800
Message-ID: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yQm4J2R5nORAQuLHb0py"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZAPDKj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 22:10:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-yQm4J2R5nORAQuLHb0py
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Herbert,

The scalability of current cryptd implementation is not good. So a
per-CPU cryptd kthread implementation is necessary. The per-CPU kthread
pool implementation need to consider many issues such as CPU hotplug, so
I suggest to base cryptd kthread implementation on workqueue, that is,
create a dedicate workqueue for crypto subsystem. This way, chainiv can
use this crypto workqueue too.

I will implement it if you have no plan to do it yourself.

Best Regards,
Huang Ying


--=-yQm4J2R5nORAQuLHb0py
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklv+qoACgkQKhFGF+eHlphKzACfQlNVSZUsKiPeCypAnCNlqJxZ
tGYAoIH/NMlRCMUcGKKGv3dGifeC+WEj
=Dn+/
-----END PGP SIGNATURE-----

--=-yQm4J2R5nORAQuLHb0py--

