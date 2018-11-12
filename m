Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbeKLUVV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:21:21 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH 02/12] rsa: add parser of raw format
Date: Mon, 12 Nov 2018 11:24:13 +0100
Message-ID: <20181112102423.30415-3-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Parse the RSA key with RAW format if the ASN.1 parser returns an error.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/rsa.c                  | 14 +++++--
 crypto/rsa_helper.c           | 69 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/rsa.h |  6 +++
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4167980c243d..d33aa039de6e 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -275,8 +275,11 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_free_mpi_key(mpi_key);
 
 	ret = rsa_parse_pub_key(&raw_key, key, keylen);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = rsa_parse_pub_key_raw(&raw_key, key, keylen);
+		if (ret)
+			return ret;
+	}
 
 	mpi_key->e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
 	if (!mpi_key->e)
@@ -309,8 +312,11 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_free_mpi_key(mpi_key);
 
 	ret = rsa_parse_priv_key(&raw_key, key, keylen);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = rsa_parse_priv_key_raw(&raw_key, key, keylen);
+		if (ret)
+			return ret;
+	}
 
 	mpi_key->d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
 	if (!mpi_key->d)
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index efc78fe7ae2e..fda85fbe2e38 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/mpi.h>
 #include <crypto/internal/rsa.h>
 #include "rsapubkey.asn1.h"
 #include "rsaprivkey.asn1.h"
@@ -153,6 +154,32 @@ int rsa_get_qinv(void *context, size_t hdrlen, unsigned char tag,
 	return 0;
 }
 
+typedef int (*rsa_get_func)(void *, size_t, unsigned char,
+			    const void *, size_t);
+
+static int rsa_parse_key_raw(struct rsa_key *rsa_key,
+			     const void *key, unsigned int key_len,
+			     rsa_get_func *func, int n_func)
+{
+	unsigned int nbytes, len = key_len;
+	const void *key_ptr = key;
+	int ret, i;
+
+	for (i = 0; i < n_func; i++) {
+		ret = mpi_key_length(key_ptr, len, NULL, &nbytes);
+		if (ret < 0)
+			return ret;
+
+		ret = func[i](rsa_key, 0, 0, key_ptr + 2, nbytes);
+		if (ret < 0)
+			return ret;
+
+		key_ptr += nbytes + 2;
+	}
+
+	return (key_ptr == key + key_len) ? 0 : -EINVAL;
+}
+
 /**
  * rsa_parse_pub_key() - decodes the BER encoded buffer and stores in the
  *                       provided struct rsa_key, pointers to the raw key as is,
@@ -171,6 +198,27 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 }
 EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
 
+/**
+ * rsa_parse_pub_key_raw() - parse the RAW key and store in the provided struct
+ *                           rsa_key, pointers to the raw key as is, so that
+ *                           the caller can copy it or MPI parse it, etc.
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in RAW format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_pub_key_raw(struct rsa_key *rsa_key, const void *key,
+			  unsigned int key_len)
+{
+	rsa_get_func pub_func[] = {rsa_get_n, rsa_get_e};
+
+	return rsa_parse_key_raw(rsa_key, key, key_len,
+				 pub_func, ARRAY_SIZE(pub_func));
+}
+EXPORT_SYMBOL_GPL(rsa_parse_pub_key_raw);
+
 /**
  * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
  *                        provided struct rsa_key, pointers to the raw key
@@ -189,3 +237,24 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 	return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
 }
 EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+
+/**
+ * rsa_parse_priv_key_raw() - parse the RAW key and store in the provided struct
+ *                            rsa_key, pointers to the raw key as is, so that
+ *                            the caller can copy it or MPI parse it, etc.
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in RAW format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_priv_key_raw(struct rsa_key *rsa_key, const void *key,
+			   unsigned int key_len)
+{
+	rsa_get_func priv_func[] = {rsa_get_n, rsa_get_e, rsa_get_d};
+
+	return rsa_parse_key_raw(rsa_key, key, key_len,
+				 priv_func, ARRAY_SIZE(priv_func));
+}
+EXPORT_SYMBOL_GPL(rsa_parse_priv_key_raw);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index 9e8f1590de98..6bc672daa175 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -55,8 +55,14 @@ struct rsa_key {
 int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 		      unsigned int key_len);
 
+int rsa_parse_pub_key_raw(struct rsa_key *rsa_key, const void *key,
+			  unsigned int key_len);
+
 int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 		       unsigned int key_len);
 
+int rsa_parse_priv_key_raw(struct rsa_key *rsa_key, const void *key,
+			   unsigned int key_len);
+
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
2.17.1
