From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 6/8] crypto: DH - add PKCS#3 parameter handling
Date: Wed, 19 Apr 2017 01:06:47 +0200
Message-ID: <1537566.vYCfETrRsr@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58996 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758032AbdDRXKA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:10:00 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DH parameters are commonly handled in PKCS#3 ASN.1 DER encoded files.
The addition adds support for the parsing of such DER encoded parameter
sets. After parsing, the data is added to the DH context data structure.

This support allows using of parameter sets generated with the openssl
dhparam command.

Note, the privateValueLength parameter defined in PKCS#3 is not parsed
as it is not required for the DH operation.

The PKCS#3 parser is able to parse data created by other tools, such as:

        openssl dhparam -outform DER -out dhparam.der 2048

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile         |  7 ++++++-
 crypto/dh.c             | 15 ++++++++++++++
 crypto/dh_helper.c      | 53 ++++++++++++++++++++++++++++++++++++++++++++++---
 crypto/dhparameter.asn1 |  4 ++++
 include/crypto/dh.h     | 21 +++++++++++++++++---
 5 files changed, 93 insertions(+), 7 deletions(-)
 create mode 100644 crypto/dhparameter.asn1

diff --git a/crypto/Makefile b/crypto/Makefile
index 8a44057..a25cfdd 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -30,7 +30,12 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 obj-$(CONFIG_CRYPTO_KPP2) += kpp.o
 
-dh_generic-y := dh.o
+$(obj)/dhparameter-asn1.o: $(obj)/dhparameter-asn1.c $(obj)/dhparameter-asn1.h
+$(obj)/dh_helper.o: $(obj)/dhparameter-asn1.h
+clean-files += dhparameter-asn1.c dhparameter-asn1.h
+
+dh_generic-y := dhparameter-asn1.o
+dh_generic-y += dh.o
 dh_generic-y += dh_helper.o
 obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
 ecdh_generic-y := ecc.o
diff --git a/crypto/dh.c b/crypto/dh.c
index f7be48e..a82dceb 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -83,6 +83,20 @@ static int dh_set_params(struct dh_ctx *ctx, struct dh *params)
 	return 0;
 }
 
+static int dh_set_params_pkcs3(struct crypto_kpp *tfm, const void *param,
+			       unsigned int param_len)
+{
+	struct dh_ctx *ctx = dh_get_ctx(tfm);
+	struct dh parsed_params;
+	int ret;
+
+	ret = dh_parse_params_pkcs3(&parsed_params, param, param_len);
+	if (ret)
+		return ret;
+
+	return dh_set_params(ctx, &parsed_params);
+}
+
 static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 			 unsigned int len)
 {
@@ -163,6 +177,7 @@ static void dh_exit_tfm(struct crypto_kpp *tfm)
 }
 
 static struct kpp_alg dh = {
+	.set_params = dh_set_params_pkcs3,
 	.set_secret = dh_set_secret,
 	.generate_public_key = dh_compute_value,
 	.compute_shared_secret = dh_compute_value,
diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 02db76b..27bffc9 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <crypto/dh.h>
 #include <crypto/kpp.h>
+#include "dhparameter-asn1.h"
 
 #define DH_KPP_SECRET_MIN_SIZE (sizeof(struct kpp_secret) + 3 * sizeof(int))
 
@@ -53,13 +54,22 @@ int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params)
 	if (len != crypto_dh_key_len(params))
 		return -EINVAL;
 
+	/* Prevention of out-of-bounds access in decode code path */
+	if ((!params->key && params->key_size) ||
+	    (!params->p && params->p_size) ||
+	    (!params->g && params->g_size))
+		return -EINVAL;
+
 	ptr = dh_pack_data(ptr, &secret, sizeof(secret));
 	ptr = dh_pack_data(ptr, &params->key_size, sizeof(params->key_size));
 	ptr = dh_pack_data(ptr, &params->p_size, sizeof(params->p_size));
 	ptr = dh_pack_data(ptr, &params->g_size, sizeof(params->g_size));
-	ptr = dh_pack_data(ptr, params->key, params->key_size);
-	ptr = dh_pack_data(ptr, params->p, params->p_size);
-	dh_pack_data(ptr, params->g, params->g_size);
+	if (params->key)
+		ptr = dh_pack_data(ptr, params->key, params->key_size);
+	if (params->p)
+		ptr = dh_pack_data(ptr, params->p, params->p_size);
+	if (params->g)
+		dh_pack_data(ptr, params->g, params->g_size);
 
 	return 0;
 }
@@ -93,3 +103,40 @@ int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_dh_decode_key);
+
+int dh_get_p(void *context, size_t hdrlen, unsigned char tag, const void *value,
+	     size_t vlen)
+{
+	struct dh *dh = context;
+
+	/* invalid key provided */
+	if (!value || !vlen)
+		return -EINVAL;
+
+	dh->p = value;
+	dh->p_size = vlen;
+
+	return 0;
+}
+
+int dh_get_g(void *context, size_t hdrlen, unsigned char tag,
+	     const void *value, size_t vlen)
+{
+	struct dh *dh = context;
+
+	/* invalid base provided */
+	if (!value || !dh->p_size || !vlen || vlen > dh->p_size)
+		return -EINVAL;
+
+	dh->g = value;
+	dh->g_size = vlen;
+
+	return 0;
+}
+
+int dh_parse_params_pkcs3(struct dh *dh, const void *param,
+			 unsigned int param_len)
+{
+	return asn1_ber_decoder(&dhparameter_decoder, dh, param, param_len);
+}
+EXPORT_SYMBOL_GPL(dh_parse_params_pkcs3);
diff --git a/crypto/dhparameter.asn1 b/crypto/dhparameter.asn1
new file mode 100644
index 0000000..e9107c8
--- /dev/null
+++ b/crypto/dhparameter.asn1
@@ -0,0 +1,4 @@
+DHParameter ::= SEQUENCE {
+	prime			INTEGER ({ dh_get_p }),
+	base			INTEGER ({ dh_get_g })
+}
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index 6b424ad..ba4988a 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -35,9 +35,9 @@
  * @g_size:	Size of DH generator G
  */
 struct dh {
-	void *key;
-	void *p;
-	void *g;
+	const void *key;
+	const void *p;
+	const void *g;
 	unsigned int key_size;
 	unsigned int p_size;
 	unsigned int g_size;
@@ -84,4 +84,19 @@ int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params);
  */
 int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params);
 
+/**
+ * dh_parse_params_pkcs3() - decodes the PKCS#3 BER encoded buffer of the DH
+ *			    parameters and stores in the provided struct dh,
+ *			    pointers to the raw p and g parameters as is, so
+ *			    that the caller can copy it or MPI parse it, etc.
+ *
+ * @dh:		struct dh representation
+ * @param:	DH parameters in BER format following PKCS#3
+ * @param_len:	length of parameter buffer
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int dh_parse_params_pkcs3(struct dh *dh, const void *param,
+			  unsigned int param_len);
+
 #endif
-- 
2.9.3
