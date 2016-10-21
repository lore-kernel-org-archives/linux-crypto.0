From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 5/8] crypto: doc - add KPP documentation
Date: Fri, 21 Oct 2016 04:58:20 +0200
Message-ID: <3780020.gKnnXCaCUy@positron.chronox.de>
References: <2053893.WjF01BJSDF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2053893.WjF01BJSDF@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the KPP API documentation to the kernel crypto API Sphinx
documentation. This addition includes the documentation of the
ECDH and DH helpers which are needed to create the approrpiate input
data for the crypto_kpp_set_secret function.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-kpp.rst      | 92 +++++++++++++++++++++++++++++++++++
 Documentation/crypto/api.rst          |  1 +
 Documentation/crypto/architecture.rst |  6 +++
 include/crypto/dh.h                   | 58 ++++++++++++++++++++++
 include/crypto/ecdh.h                 | 58 ++++++++++++++++++++++
 include/crypto/kpp.h                  | 15 ++++--
 6 files changed, 227 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/crypto/api-kpp.rst

diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/crypto/api-kpp.rst
new file mode 100644
index 0000000..d87be92
--- /dev/null
+++ b/Documentation/crypto/api-kpp.rst
@@ -0,0 +1,92 @@
+Key-agreement Protocol Primitives (KPP) Cipher Algorithm Definitions
+--------------------------------------------------------------------
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_kpp
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_alg
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_secret
+
+Key-agreement Protocol Primitives (KPP) Cipher API
+--------------------------------------------------
+
+.. kernel-doc:: include/crypto/kpp.h
+   :doc: Generic Key-agreement Protocol Primitives API
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_alloc_kpp
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_free_kpp
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_kpp_set_secret
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_kpp_generate_public_key
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_kpp_compute_shared_secret
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: crypto_kpp_maxsize
+
+Key-agreement Protocol Primitives (KPP) Cipher Request Handle
+-------------------------------------------------------------
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request_alloc
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request_free
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request_set_callback
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request_set_input
+
+.. kernel-doc:: include/crypto/kpp.h
+   :functions: kpp_request_set_output
+
+ECDH Helper Functions
+---------------------
+
+.. kernel-doc:: include/crypto/ecdh.h
+   :doc: ECDH Helper Functions
+
+.. kernel-doc:: include/crypto/ecdh.h
+   :functions: ecdh
+
+.. kernel-doc:: include/crypto/ecdh.h
+   :functions: crypto_ecdh_key_len
+
+.. kernel-doc:: include/crypto/ecdh.h
+   :functions: crypto_ecdh_encode_key
+
+.. kernel-doc:: include/crypto/ecdh.h
+   :functions: crypto_ecdh_decode_key
+
+DH Helper Functions
+-------------------
+
+.. kernel-doc:: include/crypto/dh.h
+   :doc: DH Helper Functions
+
+.. kernel-doc:: include/crypto/dh.h
+   :functions: dh
+
+.. kernel-doc:: include/crypto/dh.h
+   :functions: crypto_dh_key_len
+
+.. kernel-doc:: include/crypto/dh.h
+   :functions: crypto_dh_encode_key
+
+.. kernel-doc:: include/crypto/dh.h
+   :functions: crypto_dh_decode_key
diff --git a/Documentation/crypto/api.rst b/Documentation/crypto/api.rst
index f2bbeb0..2e51919 100644
--- a/Documentation/crypto/api.rst
+++ b/Documentation/crypto/api.rst
@@ -22,3 +22,4 @@ the IV. Different IV generators are available.
    api-digest
    api-rng
    api-akcipher
+   api-kpp
diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index 34e396b..ca2d09b 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -161,6 +161,9 @@ applicable to a cipher, it is not displayed:
       entry below for the specification of the IV generator type used by
       the cipher implementation)
 
+   -  kpp for a Key-agreement Protocol Primitive (KPP) cipher such as
+      an ECDH or DH implementation
+
 -  blocksize: blocksize of cipher in bytes
 
 -  keysize: key size in bytes
@@ -219,6 +222,9 @@ the aforementioned cipher types:
    together with an IV generator (see geniv field in the /proc/crypto
    listing for the known IV generators)
 
+-  CRYPTO_ALG_TYPE_KPP Key-agreement Protocol Primitive (KPP) such as
+   an ECDH or DH implementation
+
 -  CRYPTO_ALG_TYPE_DIGEST Raw message digest
 
 -  CRYPTO_ALG_TYPE_HASH Alias for CRYPTO_ALG_TYPE_DIGEST
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index 5102a8f..6b424ad 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -13,6 +13,27 @@
 #ifndef _CRYPTO_DH_
 #define _CRYPTO_DH_
 
+/**
+ * DOC: DH Helper Functions
+ *
+ * To use DH with the KPP cipher API, the following data structure and
+ * functions should be used.
+ *
+ * To use DH with KPP, the following functions should be used to operate on
+ * a DH private key. The packet private key that can be set with
+ * the KPP API function call of crypto_kpp_set_secret.
+ */
+
+/**
+ * struct dh - define a DH private key
+ *
+ * @key:	Private DH key
+ * @p:		Diffie-Hellman parameter P
+ * @g:		Diffie-Hellman generator G
+ * @key_size:	Size of the private DH key
+ * @p_size:	Size of DH parameter P
+ * @g_size:	Size of DH generator G
+ */
 struct dh {
 	void *key;
 	void *p;
@@ -22,8 +43,45 @@ struct dh {
 	unsigned int g_size;
 };
 
+/**
+ * crypto_dh_key_len() - Obtain the size of the private DH key
+ * @params:	private DH key
+ *
+ * This function returns the packet DH key size. A caller can use that
+ * with the provided DH private key reference to obtain the required
+ * memory size to hold a packet key.
+ *
+ * Return: size of the key in bytes
+ */
 int crypto_dh_key_len(const struct dh *params);
+
+/**
+ * crypto_dh_encode_key() - encode the private key
+ * @buf:	Buffer allocated by the caller to hold the packet DH
+ *		private key. The buffer should be at least crypto_dh_key_len
+ *		bytes in size.
+ * @len:	Length of the packet private key buffer
+ * @params:	Buffer with the caller-specified private key
+ *
+ * The DH implementations operate on a packet representation of the private
+ * key.
+ *
+ * Return:	-EINVAL if buffer has insufficient size, 0 on success
+ */
 int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params);
+
+/**
+ * crypto_dh_decode_key() - decode a private key
+ * @buf:	Buffer holding a packet key that should be decoded
+ * @len:	Lenth of the packet private key buffer
+ * @params:	Buffer allocated by the caller that is filled with the
+ *		unpacket DH private key.
+ *
+ * The unpacking obtains the private key by pointing @p to the correct location
+ * in @buf. Thus, both pointers refer to the same memory.
+ *
+ * Return:	-EINVAL if buffer has insufficient size, 0 on success
+ */
 int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params);
 
 #endif
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 84bad54..03a64f6 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -13,18 +13,76 @@
 #ifndef _CRYPTO_ECDH_
 #define _CRYPTO_ECDH_
 
+/**
+ * DOC: ECDH Helper Functions
+ *
+ * To use ECDH with the KPP cipher API, the following data structure and
+ * functions should be used.
+ *
+ * The ECC curves known to the ECDH implementation are specified in this
+ * header file.
+ *
+ * To use ECDH with KPP, the following functions should be used to operate on
+ * an ECDH private key. The packet private key that can be set with
+ * the KPP API function call of crypto_kpp_set_secret.
+ */
+
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
 #define ECC_CURVE_NIST_P256	0x0002
 
+/**
+ * struct ecdh - define an ECDH private key
+ *
+ * @curve_id:	ECC curve the key is based on.
+ * @key:	Private ECDH key
+ * @key_size:	Size of the private ECDH key
+ */
 struct ecdh {
 	unsigned short curve_id;
 	char *key;
 	unsigned short key_size;
 };
 
+/**
+ * crypto_ecdh_key_len() - Obtain the size of the private ECDH key
+ * @params:	private ECDH key
+ *
+ * This function returns the packet ECDH key size. A caller can use that
+ * with the provided ECDH private key reference to obtain the required
+ * memory size to hold a packet key.
+ *
+ * Return: size of the key in bytes
+ */
 int crypto_ecdh_key_len(const struct ecdh *params);
+
+/**
+ * crypto_ecdh_encode_key() - encode the private key
+ * @buf:	Buffer allocated by the caller to hold the packet ECDH
+ *		private key. The buffer should be at least crypto_ecdh_key_len
+ *		bytes in size.
+ * @len:	Length of the packet private key buffer
+ * @p:		Buffer with the caller-specified private key
+ *
+ * The ECDH implementations operate on a packet representation of the private
+ * key.
+ *
+ * Return:	-EINVAL if buffer has insufficient size, 0 on success
+ */
 int crypto_ecdh_encode_key(char *buf, unsigned int len, const struct ecdh *p);
+
+/**
+ * crypto_ecdh_decode_key() - decode a private key
+ * @buf:	Buffer holding a packet key that should be decoded
+ * @len:	Lenth of the packet private key buffer
+ * @p:		Buffer allocated by the caller that is filled with the
+ *		unpacket ECDH private key.
+ *
+ * The unpacking obtains the private key by pointing @p to the correct location
+ * in @buf. Thus, both pointers refer to the same memory.
+ *
+ * Return:	-EINVAL if buffer has insufficient size, 0 on success
+ */
 int crypto_ecdh_decode_key(const char *buf, unsigned int len, struct ecdh *p);
 
 #endif
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 30791f7..4307a2f 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -71,7 +71,7 @@ struct crypto_kpp {
  *
  * @reqsize:		Request context size required by algorithm
  *			implementation
- * @base		Common crypto API algorithm data structure
+ * @base:		Common crypto API algorithm data structure
  */
 struct kpp_alg {
 	int (*set_secret)(struct crypto_kpp *tfm, void *buffer,
@@ -89,7 +89,7 @@ struct kpp_alg {
 };
 
 /**
- * DOC: Generic Key-agreement Protocol Primitevs API
+ * DOC: Generic Key-agreement Protocol Primitives API
  *
  * The KPP API is used with the algorithm type
  * CRYPTO_ALG_TYPE_KPP (listed as type "kpp" in /proc/crypto)
@@ -264,6 +264,12 @@ struct kpp_secret {
  * Function invokes the specific kpp operation for a given alg.
  *
  * @tfm:	tfm handle
+ * @buffer:	Buffer holding the packet representation of the private
+ *		key. The structure of the packet key depends on the particular
+ *		KPP implementation. Packing and unpacking helpers are provided
+ *		for ECDH and DH (see the respective header files for those
+ *		implementations).
+ * @len:	Length of the packet private key buffer.
  *
  * Return: zero on success; error code in case of error
  */
@@ -279,7 +285,10 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm, void *buffer,
  * crypto_kpp_generate_public_key() - Invoke kpp operation
  *
  * Function invokes the specific kpp operation for generating the public part
- * for a given kpp algorithm
+ * for a given kpp algorithm.
+ *
+ * To generate a private key, the caller should use a random number generator.
+ * The output of the requested length serves as the private key.
  *
  * @req:	kpp key request
  *
-- 
2.7.4


