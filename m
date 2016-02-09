From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/2] crypto: extended acomp api for supporting deflate algorithm parameters
Date: Tue,  9 Feb 2016 17:31:09 +0000
Message-ID: <1455039069-17475-3-git-send-email-giovanni.cabiddu@intel.com>
References: <20160209105355.GA10652@gondor.apana.org.au>
 <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853AbcBIRbb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 12:31:31 -0500
In-Reply-To: <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/acompress.c                  |   16 +++++
 include/crypto/acompress.h          |  116 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |   24 +++++++
 3 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4c54ec9..37acc9d 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -114,5 +114,21 @@ int crypto_unregister_acomp(struct acomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_acomp);
 
+int crypto_register_acomp_deflate(struct acomp_deflate_alg *deflate_alg)
+{
+	struct acomp_alg *alg = &deflate_alg->base;
+
+	return crypto_register_acomp(alg);
+}
+EXPORT_SYMBOL_GPL(crypto_register_acomp_deflate);
+
+int crypto_unregister_acomp_deflate(struct acomp_deflate_alg *deflate_alg)
+{
+	struct acomp_alg *alg = &deflate_alg->base;
+
+	return crypto_unregister_acomp(alg);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_acomp_deflate);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index b460d31..2069b41 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -80,6 +80,22 @@ struct acomp_alg {
 };
 
 /**
+ * struct acomp_deflate_alg - asynchronous deflate compression algorithm
+ *
+ * @compress_setup:	Configures the compressor
+ *		This function configures a deflate compressor. Input parameters
+ *		are encoded in netlink format. Allowed parameters are defined
+ *		by the acomp_deflate_params enum.
+ *
+ * @base:	Generic acomp algorithm data structure
+ */
+struct acomp_deflate_alg {
+	int (*compress_setup)(struct crypto_acomp *tfm, const void *params,
+				      unsigned int len);
+	struct acomp_alg base;
+};
+
+/**
  * DOC: Asynchronous Compression API
  *
  * The Asynchronous Compression API is used with the algorithms of type
@@ -319,4 +335,104 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
 	return alg->decompress(req);
 }
 
+/**
+ * acomp_deflate_compression_levels -- Supported list of compression levels
+ *
+ * Lower values will result in less compressibility in less time
+ */
+enum acomp_deflate_compression_levels {
+	ACOMP_DEFLATE_COMP_LEVEL_DEFAULT = (-1),
+	ACOMP_DEFLATE_COMP_LEVEL_NO_COMPRESSION = 0,
+	ACOMP_DEFLATE_COMP_LEVEL_1 = 1,
+	ACOMP_DEFLATE_COMP_LEVEL_2 = 2,
+	ACOMP_DEFLATE_COMP_LEVEL_3 = 3,
+	ACOMP_DEFLATE_COMP_LEVEL_4 = 4,
+	ACOMP_DEFLATE_COMP_LEVEL_5 = 5,
+	ACOMP_DEFLATE_COMP_LEVEL_6 = 6,
+	ACOMP_DEFLATE_COMP_LEVEL_7 = 7,
+	ACOMP_DEFLATE_COMP_LEVEL_8 = 8,
+	ACOMP_DEFLATE_COMP_LEVEL_9 = 9
+};
+
+/**
+ * acomp_deflate_huff_types -- Supported list of Huffman Tree types
+ *
+ * Specifies the Huffman tree type for the deflate algorithm
+ *
+ * ACOMP_DEFLATE_HT_DEFAULT:	default encoding
+ * ACOMP_DEFLATE_HT_STATIC:	compressor generates blocks
+ *		"compressed with fixed Huffman trees" as defined by RFC 1951
+ * ACOMP_DEFLATE_HT_FULL_DYNAMIC:	compressor generates blocks
+ *		"compressed with dynamic Huffman codes" as defined by RFC 1951
+ */
+enum acomp_deflate_huff_type {
+	ACOMP_DEFLATE_HT_DEFAULT,
+	ACOMP_DEFLATE_HT_STATIC,
+	ACOMP_DEFLATE_HT_FULL_DYNAMIC
+};
+
+/**
+ * acomp_deflate_format_type -- Supported format types
+ *
+ * Specifies the format output
+ *
+ * ACOMP_DEFLATE_HF_RAW:	output is raw deflate as defined by RFC 1951,
+ *		no header and no trailer
+ * ACOMP_DEFLATE_HF_ZLIB:	output is in compliance with RFC 1950,
+ *		i.e. the deflate stream starts and finishes with a zlib header
+ *		and footer
+ * ACOMP_DEFLATE_HF_GZIP:	output is in compliance with RFC 1952,
+ *		i.e. the deflate stream starts and finishes with a gzip header
+ *		and footer
+ */
+enum acomp_deflate_header_type {
+	ACOMP_DEFLATE_FORMAT_RAW,
+	ACOMP_DEFLATE_FORMAT_ZLIB,
+	ACOMP_DEFLATE_FORMAT_GZIP
+};
+
+/**
+ * acomp_deflate_params -- Allowed deflate parameters
+ *
+ * ACOMP_DEFLATE_COMP_LEVEL:	compression level, an integer
+ *		between -1 and 9.  The allowed list of values is specified by
+ *		acomp_deflate_compression_levels
+ * ACOMP_DEFLATE_HUFF_TYPE:	Huffman encoding, allowed values
+ *		are specified by acomp_deflate_huff_type
+ * ACOMP_DEFLATE_WINDOWS_SIZE:	base two logarithm of the size of the
+ *		history buffer. Allowed values are in the range 8..15
+ * ACOMP_DEFLATE_FORMAT_TYPE:	specifies the format type, allowed
+ *		values are specified by acomp_deflate_header_type
+ */
+enum acomp_deflate_params {
+	ACOMP_DEFLATE_COMP_LEVEL = 1,
+	ACOMP_DEFLATE_HUFF_TYPE,
+	ACOMP_DEFLATE_WINDOWS_SIZE,
+	ACOMP_DEFLATE_FORMAT_TYPE,
+	__ACOMP_DEFLATE_MAX,
+};
+
+#define ACOMP_DEFLATE_PARAMS_MAX	(__ACOMP_DEFLATE_MAX - 1)
+
+/**
+ * crypto_acomp_deflate_compress_setup() -- Invoke compressor setup
+ *
+ * Function invokes the deflate compress setup operation
+ *
+ * @tfm:	ACOMPRESS tfm handle
+ * @params:	compressor input parameters in netlink format.
+ *			Allowed parameters are defined by acomp_deflate_params
+ * @len:	size of the parameters
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_acomp_deflate_compress_setup(
+					  struct crypto_acomp *tfm,
+					  const void *params, unsigned int len)
+{
+	struct acomp_alg *alg = crypto_acomp_alg(tfm);
+	struct acomp_deflate_alg *deflate_alg =
+			container_of(alg, struct acomp_deflate_alg, base);
+	return deflate_alg->compress_setup(tfm, params, len);
+}
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2061532..8218c8f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -63,4 +63,28 @@ int crypto_register_acomp(struct acomp_alg *alg);
  */
 int crypto_unregister_acomp(struct acomp_alg *alg);
 
+/**
+ * crypto_register_acomp_deflate() -- Register async deflate algorithm
+ *
+ * Function registers an implementation of an asynchronous deflate
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_register_acomp_deflate(struct acomp_deflate_alg *deflate_alg);
+
+/**
+ * crypto_unregister_acomp_deflate() -- Unregister async deflate algorithm
+ *
+ * Function unregisters an implementation of an asynchronous deflate
+ * compression algorithm
+ *
+ * @alg:	algorithm definition
+ *
+ * Return: zero on success; error code in case of error
+ */
+int crypto_unregister_acomp_deflate(struct acomp_deflate_alg *deflate_alg);
+
 #endif
-- 
1.7.4.1
