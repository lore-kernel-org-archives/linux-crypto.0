From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser actions
Date: Wed, 6 Apr 2016 16:37:05 +0300
Message-ID: <1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <tadeusz.struk@intel.com>,
	<smueller@chronox.de>, <cristian.stoica@nxp.com>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:58270
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbcDFNhc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 09:37:32 -0400
In-Reply-To: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dedicated to RSA (hardware) implementations that want to use
raw integers instead of MPI keys.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/rsa.c                  |  15 ----
 crypto/rsa_helper.c           | 182 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/rsa.h |  28 +++++++
 3 files changed, 210 insertions(+), 15 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 7cb0153..37ac189 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -235,21 +235,6 @@ err_free_m:
 	return ret;
 }
 
-static int rsa_check_key_length(unsigned int len)
-{
-	switch (len) {
-	case 512:
-	case 1024:
-	case 1536:
-	case 2048:
-	case 3072:
-	case 4096:
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 			   unsigned int keylen)
 {
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 0149ed3..df1f480 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -14,6 +14,9 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/device.h>
 #include <crypto/internal/rsa.h>
 #include "rsapubkey-asn1.h"
 #include "rsaprivkey-asn1.h"
@@ -239,3 +242,182 @@ error:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rsa_parse_mpi_priv_key);
+
+int rsa_check_key_length(unsigned int len)
+{
+	switch (len) {
+	case 512:
+	case 1024:
+	case 1536:
+	case 2048:
+	case 3072:
+	case 4096:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(rsa_check_key_length);
+
+void raw_rsa_free_key(struct rsa_raw_key *key)
+{
+	kzfree(key->d);
+	key->d = NULL;
+
+	kfree(key->e);
+	key->e = NULL;
+
+	kfree(key->n);
+	key->n = NULL;
+
+	key->n_sz = 0;
+	key->e_sz = 0;
+}
+EXPORT_SYMBOL_GPL(raw_rsa_free_key);
+
+void raw_rsa_free_coherent_key(struct device *dev, struct rsa_raw_key *key)
+{
+	if (key->d) {
+		memset(key->d, '\0', key->n_sz);
+		dma_free_coherent(dev, key->n_sz, key->d, key->dma_d);
+		key->d = NULL;
+	}
+
+	if (key->e) {
+		dma_free_coherent(dev, key->n_sz, key->e, key->dma_e);
+		key->e = NULL;
+	}
+
+	if (key->n) {
+		dma_free_coherent(dev, key->n_sz, key->n, key->dma_n);
+		key->n = NULL;
+	}
+
+	key->n_sz = 0;
+	key->e_sz = 0;
+}
+EXPORT_SYMBOL_GPL(raw_rsa_free_coherent_key);
+
+int raw_rsa_get_n(void *context, const void *value, size_t vlen)
+{
+	struct rsa_raw_ctx *ctx = context;
+	struct rsa_raw_key *key = &ctx->key;
+	const char *ptr = value;
+	int ret = -EINVAL;
+
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
+
+	key->n_sz = vlen;
+	/* In FIPS mode only allow key size 2K & 3K */
+	if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
+		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
+		goto err;
+	}
+	/* invalid key size provided */
+	ret = rsa_check_key_length(key->n_sz << 3);
+	if (ret)
+		goto err;
+
+	if (key->is_coherent)
+		key->n = kzalloc(key->n_sz, key->flags);
+	else
+		key->n = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_n,
+					     key->flags);
+
+	if (!key->n) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memcpy(key->n, ptr, key->n_sz);
+
+	return 0;
+err:
+	key->n_sz = 0;
+	key->n = NULL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(raw_rsa_get_n);
+
+int raw_rsa_get_e(void *context, const void *value, size_t vlen)
+{
+	struct rsa_raw_ctx *ctx = context;
+	struct rsa_raw_key *key = &ctx->key;
+	const char *ptr = value;
+	size_t offset = 0;
+
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
+
+	key->e_sz = vlen;
+
+	if (!key->n_sz || !vlen || vlen > key->n_sz) {
+		key->e = NULL;
+		return -EINVAL;
+	}
+
+	if (key->is_coherent) {
+		key->e = kzalloc(key->e_sz, key->flags);
+	} else {
+		key->e = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_e,
+					     key->flags);
+		offset = key->n_sz - vlen;
+	}
+
+	if (!key->e)
+		return -ENOMEM;
+
+	memcpy(key->e + offset, ptr, vlen);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(raw_rsa_get_e);
+
+int raw_rsa_get_d(void *context, const void *value, size_t vlen)
+{
+	struct rsa_raw_ctx *ctx = context;
+	struct rsa_raw_key *key = &ctx->key;
+	const char *ptr = value;
+	size_t offset = 0;
+	int ret = -EINVAL;
+
+	while (!*ptr && vlen) {
+		ptr++;
+		vlen--;
+	}
+
+	if (!key->n_sz || !vlen || vlen > key->n_sz)
+		goto err;
+
+	/* In FIPS mode only allow key size 2K & 3K */
+	if (fips_enabled && (vlen != 256 && vlen != 384)) {
+		dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
+		goto err;
+	}
+
+	if (key->is_coherent) {
+		key->d = kzalloc(key->n_sz, key->flags);
+	} else {
+		key->d = dma_zalloc_coherent(ctx->dev, key->n_sz, &key->dma_d,
+					     key->flags);
+		offset = key->n_sz - vlen;
+	}
+
+	if (!key->d) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memcpy(key->d + offset, ptr, vlen);
+
+	return 0;
+err:
+	key->d = NULL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(raw_rsa_get_d);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index f8ef7b1..854b9b7 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -31,11 +31,30 @@ struct rsa_mpi_key {
 	MPI d;
 };
 
+struct rsa_raw_key {
+	u8 *n;
+	u8 *e;
+	u8 *d;
+	dma_addr_t dma_n;
+	dma_addr_t dma_e;
+	dma_addr_t dma_d;
+	size_t n_sz;
+	size_t e_sz;
+	bool is_coherent;
+	gfp_t flags;
+};
+
 struct rsa_ctx {
 	const struct rsa_asn1_action *action;
 	struct rsa_mpi_key key;
 };
 
+struct rsa_raw_ctx {
+	const struct rsa_asn1_action *action;
+	struct rsa_raw_key key;
+	struct device *dev;
+};
+
 int rsa_get_mpi_n(void *context, const void *value, size_t vlen);
 int rsa_get_mpi_e(void *context, const void *value, size_t vlen);
 int rsa_get_mpi_d(void *context, const void *value, size_t vlen);
@@ -47,5 +66,14 @@ int rsa_parse_mpi_pub_key(struct rsa_ctx *ctx, const void *key,
 int rsa_parse_mpi_priv_key(struct rsa_ctx *ctx, const void *key,
 			   unsigned int key_len);
 
+int rsa_check_key_length(unsigned int len);
+
+void raw_rsa_free_key(struct rsa_raw_key *key);
+void raw_rsa_free_coherent_key(struct device *dev, struct rsa_raw_key *key);
+
+int raw_rsa_get_n(void *context, const void *value, size_t vlen);
+int raw_rsa_get_e(void *context, const void *value, size_t vlen);
+int raw_rsa_get_d(void *context, const void *value, size_t vlen);
+
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
1.8.3.1
