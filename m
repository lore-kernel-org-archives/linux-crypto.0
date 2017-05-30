From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 1/2] crypto: ecdh - add privkey generation support
Date: Tue, 30 May 2017 17:52:48 +0300
Message-ID: <1496155969-13765-2-git-send-email-tudor.ambarus@microchip.com>
References: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40144 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdE3O4H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 10:56:07 -0400
In-Reply-To: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for generating ecc private keys.

Generation of ecc private keys is helpful in a user-space to kernel
ecdh offload because the keys are not revealed to user-space. Private
key generation is also helpful to implement forward secrecy.

If the user provides a NULL ecc private key, the kernel will generate it
and further use it for ecdh.

Move ecdh's object files below drbg's. drbg must be present in the kernel
at the time of calling.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/Kconfig  |  1 +
 crypto/Makefile |  9 +++++----
 crypto/ecc.c    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/ecc.h    | 14 ++++++++++++++
 crypto/ecdh.c   |  4 ++++
 5 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aac4bc9..caa770e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -130,6 +130,7 @@ config CRYPTO_DH
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
 	select CRYTPO_KPP
+	select CRYPTO_RNG_DEFAULT
 	help
 	  Generic implementation of the ECDH algorithm
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 8a44057..d41f033 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -33,10 +33,6 @@ obj-$(CONFIG_CRYPTO_KPP2) += kpp.o
 dh_generic-y := dh.o
 dh_generic-y += dh_helper.o
 obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
-ecdh_generic-y := ecc.o
-ecdh_generic-y += ecdh.o
-ecdh_generic-y += ecdh_helper.o
-obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
 $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
@@ -138,6 +134,11 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 
+ecdh_generic-y := ecc.o
+ecdh_generic-y += ecdh.o
+ecdh_generic-y += ecdh_helper.o
+obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
+
 #
 # generic algorithms and the async_tx api
 #
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6c33c43..633a9bc 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -29,6 +29,7 @@
 #include <linux/swab.h>
 #include <linux/fips.h>
 #include <crypto/ecdh.h>
+#include <crypto/rng.h>
 
 #include "ecc.h"
 #include "ecc_curve_defs.h"
@@ -927,6 +928,61 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 	return 0;
 }
 
+/*
+ * ECC private keys are generated using the method of extra random bits,
+ * equivalent to that described in FIPS 186-4, Appendix B.4.1.
+ *
+ * d = (c mod(n–1)) + 1    where c is a string of random bits, 64 bits longer
+ *                         than requested
+ * 0 <= c mod(n-1) <= n-2  and implies that
+ * 1 <= d <= n-1
+ *
+ * This method generates a private key uniformly distributed in the range
+ * [1, n-1].
+ */
+int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
+{
+	const struct ecc_curve *curve = ecc_get_curve(curve_id);
+	u64 priv[ndigits];
+	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	unsigned int nbits = vli_num_bits(curve->n, ndigits);
+	int err;
+
+	/* Check that N is included in Table 1 of FIPS 186-4, section 6.1.1 */
+	if (nbits < 160)
+		return -EINVAL;
+
+	/*
+	 * FIPS 186-4 recommends that the private key should be obtained from a
+	 * RBG with a security strength equal to or greater than the security
+	 * strength associated with N.
+	 *
+	 * The maximum security strength identified by NIST SP800-57pt1r4 for
+	 * ECC is 256 (N >= 512).
+	 *
+	 * This condition is met by the default RNG because it selects a favored
+	 * DRBG with a security strength of 256.
+	 */
+	if (crypto_get_default_rng())
+		err = -EFAULT;
+
+	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
+	crypto_put_default_rng();
+	if (err)
+		return err;
+
+	if (vli_is_zero(priv, ndigits))
+		return -EINVAL;
+
+	/* Make sure the private key is in the range [1, n-1]. */
+	if (vli_cmp(curve->n, priv, ndigits) != 1)
+		return -EINVAL;
+
+	ecc_swap_digits(priv, privkey, ndigits);
+
+	return 0;
+}
+
 int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, u64 *public_key)
 {
diff --git a/crypto/ecc.h b/crypto/ecc.h
index e13fe88..e4fd449 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -44,6 +44,20 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, unsigned int private_key_len);
 
 /**
+ * ecc_gen_privkey() -  Generates an ECC private key.
+ * The private key is a random integer in the range 0 < random < n, where n is a
+ * prime that is the order of the cyclic subgroup generated by the distinguished
+ * point G.
+ * @curve_id:		id representing the curve to use
+ * @ndigits:		curve number of digits
+ * @private_key:	buffer for storing the generated private key
+ *
+ * Returns 0 if the private key was generated successfully, a negative value
+ * if an error occurred.
+ */
+int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey);
+
+/**
  * ecc_make_pub_key() - Compute an ECC public key
  *
  * @curve_id:		id representing the curve to use
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 4aa0b0c..61c7708 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -55,6 +55,10 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	ctx->curve_id = params.curve_id;
 	ctx->ndigits = ndigits;
 
+	if (!params.key || !params.key_size)
+		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
+				       ctx->private_key);
+
 	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
 			     (const u64 *)params.key, params.key_size) < 0)
 		return -EINVAL;
-- 
2.7.4
