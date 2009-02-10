From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 3/3] crypto: Uses kcrypto_wq instead of keventd_wq in
	chainiv
Date: Tue, 10 Feb 2009 14:14:03 +0800
Message-ID: <1234246443.20270.77.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xJJ/yNjf7cwkOyM2RhAu"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBJGOG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Feb 2009 01:14:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-xJJ/yNjf7cwkOyM2RhAu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Uses kcrypto_wq instead of keventd_wq in chainiv

keventd_wq has potential starvation problem, so use dedicated
kcrypto_wq instead.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig   |    1 +
 crypto/chainiv.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -56,6 +56,7 @@ config CRYPTO_BLKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_RNG2
+	select CRYPTO_WORKQUEUE
=20
 config CRYPTO_HASH
 	tristate
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -15,6 +15,7 @@
=20
 #include <crypto/internal/skcipher.h>
 #include <crypto/rng.h>
+#include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -133,7 +134,7 @@ static int async_chainiv_schedule_work(s
 			goto out;
 	}
=20
-	queued =3D schedule_work(&ctx->postponed);
+	queued =3D queue_work(kcrypto_wq, &ctx->postponed);
 	BUG_ON(!queued);
=20
 out:


--=-xJJ/yNjf7cwkOyM2RhAu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmRGygACgkQKhFGF+eHlpge6QCgnAgXhoEMUXmim/cBf9SSI+/G
Pn4AmgMafVabhvgO+aln++QEKfB2nkHQ
=ZYnO
-----END PGP SIGNATURE-----

--=-xJJ/yNjf7cwkOyM2RhAu--

