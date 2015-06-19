From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: nx - Check for bogus firmware properties
Date: Fri, 19 Jun 2015 12:07:54 +0800
Message-ID: <20150619040754.GA8782@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ondrej =?utf-8?B?TW9yacWh?= <omoris@redhat.com>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37855 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbbFSEH7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 00:07:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The nx driver reads two crucial paramters from the firmware for
each crypto algorithm, the maximum SG list length and byte limit.
Unfortunately those two parameters may be bogus, or worse they
may be absent altogether.  When this happens the algorithms will
still register successfully but will fail when used or tested.

This patch adds checks to report any firmware entries which are
found to be bogus, and avoid registering algorithms which have
bogus parameters.  A warning is also printed when an algorithm
is not registered because of this as there may have been no firmware
entries for it at all.

Reported-by: Ondrej Mori=C5=A1 <omoris@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx.c |  150 ++++++++++++++++++++++++++++++++++++++--=
---------
 1 file changed, 118 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 8473505..f6198f2 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -32,6 +32,7 @@
 #include <linux/scatterlist.h>
 #include <linux/device.h>
 #include <linux/of.h>
+#include <linux/types.h>
 #include <asm/hvcall.h>
 #include <asm/vio.h>
=20
@@ -398,6 +399,13 @@ static void nx_of_update_msc(struct device   *dev,
 				goto next_loop;
 			}
=20
+			if (!trip->sglen || trip->databytelen < NX_PAGE_SIZE) {
+				dev_warn(dev, "bogus sglen/databytelen: "
+					 "%u/%u (ignored)\n", trip->sglen,
+					 trip->databytelen);
+				goto next_loop;
+			}
+
 			switch (trip->keybitlen) {
 			case 128:
 			case 160:
@@ -490,6 +498,72 @@ static void nx_of_init(struct device *dev, struct =
nx_of *props)
 		nx_of_update_msc(dev, p, props);
 }
=20
+static bool nx_check_prop(struct device *dev, u32 fc, u32 mode, int sl=
ot)
+{
+	struct alg_props *props =3D &nx_driver.of.ap[fc][mode][slot];
+
+	if (!props->sglen || props->databytelen < NX_PAGE_SIZE) {
+		if (dev)
+			dev_warn(dev, "bogus sglen/databytelen for %u/%u/%u: "
+				 "%u/%u (ignored)\n", fc, mode, slot,
+				 props->sglen, props->databytelen);
+		return false;
+	}
+
+	return true;
+}
+
+static bool nx_check_props(struct device *dev, u32 fc, u32 mode)
+{
+	int i;
+
+	for (i =3D 0; i < 3; i++)
+		if (!nx_check_prop(dev, fc, mode, i))
+			return false;
+
+	return true;
+}
+
+static int nx_register_alg(struct crypto_alg *alg, u32 fc, u32 mode)
+{
+	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
+	       crypto_register_alg(alg) : 0;
+}
+
+static int nx_register_aead(struct aead_alg *alg, u32 fc, u32 mode)
+{
+	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
+	       crypto_register_aead(alg) : 0;
+}
+
+static int nx_register_shash(struct shash_alg *alg, u32 fc, u32 mode, =
int slot)
+{
+	return (slot >=3D 0 ? nx_check_prop(&nx_driver.viodev->dev,
+					  fc, mode, slot) :
+			    nx_check_props(&nx_driver.viodev->dev, fc, mode)) ?
+	       crypto_register_shash(alg) : 0;
+}
+
+static void nx_unregister_alg(struct crypto_alg *alg, u32 fc, u32 mode=
)
+{
+	if (nx_check_props(NULL, fc, mode))
+		crypto_unregister_alg(alg);
+}
+
+static void nx_unregister_aead(struct aead_alg *alg, u32 fc, u32 mode)
+{
+	if (nx_check_props(NULL, fc, mode))
+		crypto_unregister_aead(alg);
+}
+
+static void nx_unregister_shash(struct shash_alg *alg, u32 fc, u32 mod=
e,
+				int slot)
+{
+	if (slot >=3D 0 ? nx_check_prop(NULL, fc, mode, slot) :
+			nx_check_props(NULL, fc, mode))
+		crypto_unregister_shash(alg);
+}
+
 /**
  * nx_register_algs - register algorithms with the crypto API
  *
@@ -514,72 +588,77 @@ static int nx_register_algs(void)
=20
 	nx_driver.of.status =3D NX_OKAY;
=20
-	rc =3D crypto_register_alg(&nx_ecb_aes_alg);
+	rc =3D nx_register_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 	if (rc)
 		goto out;
=20
-	rc =3D crypto_register_alg(&nx_cbc_aes_alg);
+	rc =3D nx_register_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 	if (rc)
 		goto out_unreg_ecb;
=20
-	rc =3D crypto_register_alg(&nx_ctr_aes_alg);
+	rc =3D nx_register_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 	if (rc)
 		goto out_unreg_cbc;
=20
-	rc =3D crypto_register_alg(&nx_ctr3686_aes_alg);
+	rc =3D nx_register_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CT=
R);
 	if (rc)
 		goto out_unreg_ctr;
=20
-	rc =3D crypto_register_aead(&nx_gcm_aes_alg);
+	rc =3D nx_register_aead(&nx_gcm_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 	if (rc)
 		goto out_unreg_ctr3686;
=20
-	rc =3D crypto_register_aead(&nx_gcm4106_aes_alg);
+	rc =3D nx_register_aead(&nx_gcm4106_aes_alg, NX_FC_AES, NX_MODE_AES_G=
CM);
 	if (rc)
 		goto out_unreg_gcm;
=20
-	rc =3D crypto_register_alg(&nx_ccm_aes_alg);
+	rc =3D nx_register_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 	if (rc)
 		goto out_unreg_gcm4106;
=20
-	rc =3D crypto_register_alg(&nx_ccm4309_aes_alg);
+	rc =3D nx_register_alg(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CC=
M);
 	if (rc)
 		goto out_unreg_ccm;
=20
-	rc =3D crypto_register_shash(&nx_shash_sha256_alg);
+	rc =3D nx_register_shash(&nx_shash_sha256_alg, NX_FC_SHA, NX_MODE_SHA=
,
+			       NX_PROPS_SHA256);
 	if (rc)
 		goto out_unreg_ccm4309;
=20
-	rc =3D crypto_register_shash(&nx_shash_sha512_alg);
+	rc =3D nx_register_shash(&nx_shash_sha512_alg, NX_FC_SHA, NX_MODE_SHA=
,
+			       NX_PROPS_SHA512);
 	if (rc)
 		goto out_unreg_s256;
=20
-	rc =3D crypto_register_shash(&nx_shash_aes_xcbc_alg);
+	rc =3D nx_register_shash(&nx_shash_aes_xcbc_alg,
+			       NX_FC_AES, NX_MODE_AES_XCBC_MAC, -1);
 	if (rc)
 		goto out_unreg_s512;
=20
 	goto out;
=20
 out_unreg_s512:
-	crypto_unregister_shash(&nx_shash_sha512_alg);
+	nx_unregister_shash(&nx_shash_sha512_alg, NX_FC_SHA, NX_MODE_SHA,
+			    NX_PROPS_SHA512);
 out_unreg_s256:
-	crypto_unregister_shash(&nx_shash_sha256_alg);
+	nx_unregister_shash(&nx_shash_sha256_alg, NX_FC_SHA, NX_MODE_SHA,
+			    NX_PROPS_SHA256);
 out_unreg_ccm4309:
-	crypto_unregister_alg(&nx_ccm4309_aes_alg);
+	nx_unregister_alg(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 out_unreg_ccm:
-	crypto_unregister_alg(&nx_ccm_aes_alg);
+	nx_unregister_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 out_unreg_gcm4106:
-	crypto_unregister_aead(&nx_gcm4106_aes_alg);
+	nx_unregister_aead(&nx_gcm4106_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 out_unreg_gcm:
-	crypto_unregister_aead(&nx_gcm_aes_alg);
+	nx_unregister_aead(&nx_gcm_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 out_unreg_ctr3686:
-	crypto_unregister_alg(&nx_ctr3686_aes_alg);
+	nx_unregister_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 out_unreg_ctr:
-	crypto_unregister_alg(&nx_ctr_aes_alg);
+	nx_unregister_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 out_unreg_cbc:
-	crypto_unregister_alg(&nx_cbc_aes_alg);
+	nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 out_unreg_ecb:
-	crypto_unregister_alg(&nx_ecb_aes_alg);
+	nx_unregister_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 out:
 	return rc;
 }
@@ -725,17 +804,24 @@ static int nx_remove(struct vio_dev *viodev)
 	if (nx_driver.of.status =3D=3D NX_OKAY) {
 		NX_DEBUGFS_FINI(&nx_driver);
=20
-		crypto_unregister_alg(&nx_ccm_aes_alg);
-		crypto_unregister_alg(&nx_ccm4309_aes_alg);
-		crypto_unregister_aead(&nx_gcm_aes_alg);
-		crypto_unregister_aead(&nx_gcm4106_aes_alg);
-		crypto_unregister_alg(&nx_ctr_aes_alg);
-		crypto_unregister_alg(&nx_ctr3686_aes_alg);
-		crypto_unregister_alg(&nx_cbc_aes_alg);
-		crypto_unregister_alg(&nx_ecb_aes_alg);
-		crypto_unregister_shash(&nx_shash_sha256_alg);
-		crypto_unregister_shash(&nx_shash_sha512_alg);
-		crypto_unregister_shash(&nx_shash_aes_xcbc_alg);
+		nx_unregister_shash(&nx_shash_aes_xcbc_alg,
+				    NX_FC_AES, NX_MODE_AES_XCBC_MAC, -1);
+		nx_unregister_shash(&nx_shash_sha512_alg,
+				    NX_FC_SHA, NX_MODE_SHA, NX_PROPS_SHA256);
+		nx_unregister_shash(&nx_shash_sha256_alg,
+				    NX_FC_SHA, NX_MODE_SHA, NX_PROPS_SHA512);
+		nx_unregister_alg(&nx_ccm4309_aes_alg,
+				  NX_FC_AES, NX_MODE_AES_CCM);
+		nx_unregister_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+		nx_unregister_aead(&nx_gcm4106_aes_alg,
+				   NX_FC_AES, NX_MODE_AES_GCM);
+		nx_unregister_aead(&nx_gcm_aes_alg,
+				   NX_FC_AES, NX_MODE_AES_GCM);
+		nx_unregister_alg(&nx_ctr3686_aes_alg,
+				  NX_FC_AES, NX_MODE_AES_CTR);
+		nx_unregister_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
+		nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
+		nx_unregister_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 	}
=20
 	return 0;
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
