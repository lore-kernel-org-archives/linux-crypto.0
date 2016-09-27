From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Tue, 27 Sep 2016 16:46:44 -0300
Message-ID: <20160927194644.GB15729@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33218 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753284AbcI0Tqw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 15:46:52 -0400
Received: by mail-qk0-f172.google.com with SMTP id g67so27542645qkd.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2016 12:46:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160927120414.GC21317@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jan,=20

Can you check if the problem occurs with this patch?

---
 drivers/crypto/vmx/ghash.c | 28 +++++++++++++++++-----------
 drivers/crypto/vmx/vmx.c   |  9 +++++++++
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 6c999cb0..033aba1 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -36,6 +36,8 @@
 #define GHASH_DIGEST_SIZE (16)
 #define GHASH_KEY_LEN (16)
=20
+#define GHASH_FALLBACK_ALG "ghash-generic"
+
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
 void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
 void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
@@ -53,18 +55,26 @@ struct p8_ghash_desc_ctx {
 	struct shash_desc fallback_desc;
 };
=20
+int p8_ghash_fallback_descsize(void)
+{
+	int descsize;
+	struct crypto_shash *fallback;
+	fallback =3D crypto_alloc_shash(GHASH_FALLBACK_ALG, 0,
+				      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback)) {
+		return PTR_ERR(fallback);
+	}
+	descsize =3D crypto_shash_descsize(fallback);
+	crypto_free_shash(fallback);
+	return descsize;
+}
+
 static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg =3D GHASH_FALLBACK_ALG;
 	struct crypto_shash *fallback;
-	struct crypto_shash *shash_tfm =3D __crypto_shash_cast(tfm);
 	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(tfm);
=20
-	if (!(alg =3D crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback =3D crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
@@ -79,10 +89,6 @@ static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 			       crypto_shash_get_flags((struct crypto_shash
 						       *) tfm));
 	ctx->fallback =3D fallback;
-
-	shash_tfm->descsize =3D sizeof(struct p8_ghash_desc_ctx)
-	    + crypto_shash_descsize(fallback);
-
 	return 0;
 }
=20
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index 31a98dc..8a51149 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -28,6 +28,8 @@
 #include <asm/cputable.h>
 #include <crypto/internal/hash.h>
=20
+int p8_ghash_fallback_descsize(void);
+
 extern struct shash_alg p8_ghash_alg;
 extern struct crypto_alg p8_aes_alg;
 extern struct crypto_alg p8_aes_cbc_alg;
@@ -45,6 +47,7 @@ int __init p8_init(void)
 {
 	int ret =3D 0;
 	struct crypto_alg **alg_it;
+	int ghash_descsize;
=20
 	for (alg_it =3D algs; *alg_it; alg_it++) {
 		ret =3D crypto_register_alg(*alg_it);
@@ -59,6 +62,12 @@ int __init p8_init(void)
 	if (ret)
 		return ret;
=20
+	ghash_descsize =3D p8_ghash_fallback_descsize();
+	if (ghash_descsize < 0) {
+		printk(KERN_ERR "Cannot get descsize for p8_ghash fallback\n");
+		return ghash_descsize;
+	}
+	p8_ghash_alg.descsize +=3D ghash_descsize;
 	ret =3D crypto_register_shash(&p8_ghash_alg);
 	if (ret) {
 		for (alg_it =3D algs; *alg_it; alg_it++)
--=20
2.7.4


--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX6sykAAoJEM8aS8c01e1Hh6QH/16cT8y9Wxk7FCzdW+GxHCfw
OEWV7Ze/CsNRtyBW8kNumkQRiusRm2eFH1DdUuHgWwm8D1UYdwlCHQffPM3j12KG
sDos0HDMFne8tFeDF0S9D+ZL0DKbRaBCuUV3Q3udjyCGK8ySugO/m3a8132Zv3ul
i4sWNiT/BrRP7ti/pG3PxFIcv/x3+XbJOXQUeyjWCq+b0JzYur53OJuPDr1M3Sqw
B9GFs1J3fZ0uKlteCev2e4J6TpwJSyA9cdcM90/JzwVbp15NAIZhAhUaLVftUgYr
aipRnOPzOv01fXCfSu8O/mAHJ8up1p7MjuorvwOD9Mr09tVO/dZcOcMdYwZ+B0s=
=o5Hy
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
