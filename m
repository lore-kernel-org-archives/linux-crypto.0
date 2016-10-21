From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 8/8] crypto: doc - optimize compilation
Date: Fri, 21 Oct 2016 05:00:02 +0200
Message-ID: <1694367.Q0xO3KaO9D@positron.chronox.de>
References: <2053893.WjF01BJSDF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2053893.WjF01BJSDF@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The :functions: definition allows the specification of multiple
function references which prevents parsing the header file multiple
times.

Reported-by: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-aead.rst     |  51 +-----------
 Documentation/crypto/api-akcipher.rst |  42 +---------
 Documentation/crypto/api-digest.rst   |  95 +--------------------
 Documentation/crypto/api-kpp.rst      |  64 ++------------
 Documentation/crypto/api-rng.rst      |  20 +----
 Documentation/crypto/api-skcipher.rst | 152 ++--------------------------------
 6 files changed, 23 insertions(+), 401 deletions(-)

diff --git a/Documentation/crypto/api-aead.rst b/Documentation/crypto/api-aead.rst
index 78a7ce4..d15256f 100644
--- a/Documentation/crypto/api-aead.rst
+++ b/Documentation/crypto/api-aead.rst
@@ -5,40 +5,13 @@ Authenticated Encryption With Associated Data (AEAD) Algorithm Definitions
    :doc: Authenticated Encryption With Associated Data (AEAD) Cipher API
 
 .. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_alg
+   :functions: aead_request aead_alg
 
 Authenticated Encryption With Associated Data (AEAD) Cipher API
 ---------------------------------------------------------------
 
 .. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_alloc_aead
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_free_aead
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_ivsize
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_authsize
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_blocksize
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_setkey
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_setauthsize
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_encrypt
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_decrypt
+   :functions: crypto_alloc_aead crypto_free_aead crypto_aead_ivsize crypto_aead_authsize crypto_aead_blocksize crypto_aead_setkey crypto_aead_setauthsize crypto_aead_encrypt crypto_aead_decrypt
 
 Asynchronous AEAD Request Handle
 --------------------------------
@@ -47,22 +20,4 @@ Asynchronous AEAD Request Handle
    :doc: Asynchronous AEAD Request Handle
 
 .. kernel-doc:: include/crypto/aead.h
-   :functions: crypto_aead_reqsize
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_set_tfm
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_alloc
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_free
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_set_callback
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_set_crypt
-
-.. kernel-doc:: include/crypto/aead.h
-   :functions: aead_request_set_ad
+   :functions: crypto_aead_reqsize aead_request_set_tfm aead_request_alloc aead_request_free aead_request_set_callback aead_request_set_crypt aead_request_set_ad
diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
index 49e0ab6..40aa874 100644
--- a/Documentation/crypto/api-akcipher.rst
+++ b/Documentation/crypto/api-akcipher.rst
@@ -2,10 +2,7 @@ Asymmetric Cipher Algorithm Definitions
 ---------------------------------------
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_alg
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request
+   :functions: akcipher_alg akcipher_request
 
 Asymmetric Cipher API
 ---------------------
@@ -14,43 +11,10 @@ Asymmetric Cipher API
    :doc: Generic Public Key API
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_alloc_akcipher
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_free_akcipher
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_set_pub_key
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_set_priv_key
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_maxsize
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_encrypt
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_decrypt
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_sign
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_verify
+   :functions: crypto_alloc_akcipher crypto_free_akcipher crypto_akcipher_set_pub_key crypto_akcipher_set_priv_key crypto_akcipher_maxsize crypto_akcipher_encrypt crypto_akcipher_decrypt crypto_akcipher_sign crypto_akcipher_verify
 
 Asymmetric Cipher Request Handle
 --------------------------------
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_alloc
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_free
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_set_callback
-
-.. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_set_crypt
+   :functions: akcipher_request_alloc akcipher_request_free akcipher_request_set_callback akcipher_request_set_crypt
diff --git a/Documentation/crypto/api-digest.rst b/Documentation/crypto/api-digest.rst
index b5eaf0f..07356fa 100644
--- a/Documentation/crypto/api-digest.rst
+++ b/Documentation/crypto/api-digest.rst
@@ -5,13 +5,7 @@ Message Digest Algorithm Definitions
    :doc: Message Digest Algorithm Definitions
 
 .. kernel-doc:: include/crypto/hash.h
-   :functions: hash_alg_common
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_alg
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: shash_alg
+   :functions: hash_alg_common ahash_alg shash_alg
 
 Asynchronous Message Digest API
 -------------------------------
@@ -20,40 +14,7 @@ Asynchronous Message Digest API
    :doc: Asynchronous Message Digest API
 
 .. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_alloc_ahash
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_free_ahash
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_init
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_digestsize
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_reqtfm
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_reqsize
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_setkey
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_finup
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_final
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_digest
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_export
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_ahash_import
+   :functions: crypto_alloc_ahash crypto_free_ahash crypto_ahash_init crypto_ahash_digestsize crypto_ahash_reqtfm crypto_ahash_reqsize crypto_ahash_setkey crypto_ahash_finup crypto_ahash_final crypto_ahash_digest crypto_ahash_export crypto_ahash_import
 
 Asynchronous Hash Request Handle
 --------------------------------
@@ -62,19 +23,7 @@ Asynchronous Hash Request Handle
    :doc: Asynchronous Hash Request Handle
 
 .. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_request_set_tfm
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_request_alloc
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_request_free
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_request_set_callback
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: ahash_request_set_crypt
+   :functions: ahash_request_set_tfm ahash_request_alloc ahash_request_free ahash_request_set_callback ahash_request_set_crypt
 
 Synchronous Message Digest API
 ------------------------------
@@ -83,40 +32,4 @@ Synchronous Message Digest API
    :doc: Synchronous Message Digest API
 
 .. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_alloc_shash
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_free_shash
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_blocksize
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_digestsize
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_descsize
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_setkey
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_digest
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_export
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_import
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_init
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_update
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_final
-
-.. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_shash_finup
+   :functions: crypto_alloc_shash crypto_free_shash crypto_shash_blocksize crypto_shash_digestsize crypto_shash_descsize crypto_shash_setkey crypto_shash_digest crypto_shash_export crypto_shash_import crypto_shash_init crypto_shash_update crypto_shash_final crypto_shash_finup
diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/crypto/api-kpp.rst
index d87be92..7d86ab9 100644
--- a/Documentation/crypto/api-kpp.rst
+++ b/Documentation/crypto/api-kpp.rst
@@ -2,16 +2,7 @@ Key-agreement Protocol Primitives (KPP) Cipher Algorithm Definitions
 --------------------------------------------------------------------
 
 .. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_kpp
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_alg
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_secret
+   :functions: kpp_request crypto_kpp kpp_alg kpp_secret
 
 Key-agreement Protocol Primitives (KPP) Cipher API
 --------------------------------------------------
@@ -20,40 +11,13 @@ Key-agreement Protocol Primitives (KPP) Cipher API
    :doc: Generic Key-agreement Protocol Primitives API
 
 .. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_alloc_kpp
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_free_kpp
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_kpp_set_secret
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_kpp_generate_public_key
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_kpp_compute_shared_secret
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: crypto_kpp_maxsize
+   :functions: crypto_alloc_kpp crypto_free_kpp crypto_kpp_set_secret crypto_kpp_generate_public_key crypto_kpp_compute_shared_secret crypto_kpp_maxsize
 
 Key-agreement Protocol Primitives (KPP) Cipher Request Handle
 -------------------------------------------------------------
 
 .. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request_alloc
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request_free
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request_set_callback
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request_set_input
-
-.. kernel-doc:: include/crypto/kpp.h
-   :functions: kpp_request_set_output
+   :functions: kpp_request_alloc kpp_request_free kpp_request_set_callback kpp_request_set_input kpp_request_set_output
 
 ECDH Helper Functions
 ---------------------
@@ -62,16 +26,7 @@ ECDH Helper Functions
    :doc: ECDH Helper Functions
 
 .. kernel-doc:: include/crypto/ecdh.h
-   :functions: ecdh
-
-.. kernel-doc:: include/crypto/ecdh.h
-   :functions: crypto_ecdh_key_len
-
-.. kernel-doc:: include/crypto/ecdh.h
-   :functions: crypto_ecdh_encode_key
-
-.. kernel-doc:: include/crypto/ecdh.h
-   :functions: crypto_ecdh_decode_key
+   :functions: ecdh crypto_ecdh_key_len crypto_ecdh_encode_key crypto_ecdh_decode_key
 
 DH Helper Functions
 -------------------
@@ -80,13 +35,4 @@ DH Helper Functions
    :doc: DH Helper Functions
 
 .. kernel-doc:: include/crypto/dh.h
-   :functions: dh
-
-.. kernel-doc:: include/crypto/dh.h
-   :functions: crypto_dh_key_len
-
-.. kernel-doc:: include/crypto/dh.h
-   :functions: crypto_dh_encode_key
-
-.. kernel-doc:: include/crypto/dh.h
-   :functions: crypto_dh_decode_key
+   :functions: dh crypto_dh_key_len crypto_dh_encode_key crypto_dh_decode_key
diff --git a/Documentation/crypto/api-rng.rst b/Documentation/crypto/api-rng.rst
index 0d7ee78..10ba743 100644
--- a/Documentation/crypto/api-rng.rst
+++ b/Documentation/crypto/api-rng.rst
@@ -11,22 +11,4 @@ Crypto API Random Number API
    :doc: Random number generator API
 
 .. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_alloc_rng
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_rng_alg
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_free_rng
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_rng_generate
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_rng_get_bytes
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_rng_reset
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_rng_seedsize
+   :functions: crypto_alloc_rng crypto_rng_alg crypto_free_rng crypto_rng_generate crypto_rng_get_bytes crypto_rng_reset crypto_rng_seedsize
diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index cd8830b..b20028a 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -5,16 +5,7 @@ Block Cipher Algorithm Definitions
    :doc: Block Cipher Algorithm Definitions
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alg
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_alg
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: blkcipher_alg
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: cipher_alg
+   :functions: crypto_alg ablkcipher_alg blkcipher_alg cipher_alg
 
 Symmetric Key Cipher API
 ------------------------
@@ -23,31 +14,7 @@ Symmetric Key Cipher API
    :doc: Symmetric Key Cipher API
 
 .. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_alloc_skcipher
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_free_skcipher
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_has_skcipher
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_ivsize
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_blocksize
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_setkey
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_reqtfm
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_encrypt
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_decrypt
+   :functions: crypto_alloc_skcipher crypto_free_skcipher crypto_has_skcipher crypto_skcipher_ivsize crypto_skcipher_blocksize crypto_skcipher_setkey crypto_skcipher_reqtfm crypto_skcipher_encrypt crypto_skcipher_decrypt
 
 Symmetric Key Cipher Request Handle
 -----------------------------------
@@ -56,22 +23,7 @@ Symmetric Key Cipher Request Handle
    :doc: Symmetric Key Cipher Request Handle
 
 .. kernel-doc:: include/crypto/skcipher.h
-   :functions: crypto_skcipher_reqsize
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: skcipher_request_set_tfm
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: skcipher_request_alloc
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: skcipher_request_free
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: skcipher_request_set_callback
-
-.. kernel-doc:: include/crypto/skcipher.h
-   :functions: skcipher_request_set_crypt
+   :functions: crypto_skcipher_reqsize skcipher_request_set_tfm skcipher_request_alloc skcipher_request_free skcipher_request_set_callback skcipher_request_set_crypt
 
 Single Block Cipher API
 -----------------------
@@ -80,25 +32,7 @@ Single Block Cipher API
    :doc: Single Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_cipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_free_cipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_has_cipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_cipher_blocksize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_cipher_setkey
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_cipher_encrypt_one
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_cipher_decrypt_one
+   :functions: crypto_alloc_cipher crypto_free_cipher crypto_has_cipher crypto_cipher_blocksize crypto_cipher_setkey crypto_cipher_encrypt_one crypto_cipher_decrypt_one
 
 Asynchronous Block Cipher API - Deprecated
 ------------------------------------------
@@ -107,28 +41,7 @@ Asynchronous Block Cipher API - Deprecated
    :doc: Asynchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_free_ablkcipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_has_ablkcipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_ivsize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_blocksize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_setkey
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_reqtfm
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_encrypt
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_decrypt
+   :functions: crypto_free_ablkcipher crypto_has_ablkcipher crypto_ablkcipher_ivsize crypto_ablkcipher_blocksize crypto_ablkcipher_setkey crypto_ablkcipher_reqtfm crypto_ablkcipher_encrypt crypto_ablkcipher_decrypt
 
 Asynchronous Cipher Request Handle - Deprecated
 -----------------------------------------------
@@ -137,22 +50,7 @@ Asynchronous Cipher Request Handle - Deprecated
    :doc: Asynchronous Cipher Request Handle
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_ablkcipher_reqsize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_request_set_tfm
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_request_alloc
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_request_free
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_request_set_callback
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: ablkcipher_request_set_crypt
+   :functions: crypto_ablkcipher_reqsize ablkcipher_request_set_tfm ablkcipher_request_alloc ablkcipher_request_free ablkcipher_request_set_callback ablkcipher_request_set_crypt
 
 Synchronous Block Cipher API - Deprecated
 -----------------------------------------
@@ -161,40 +59,4 @@ Synchronous Block Cipher API - Deprecated
    :doc: Synchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_blkcipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_free_blkcipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_has_blkcipher
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_name
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_ivsize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_blocksize
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_setkey
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_encrypt
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_encrypt_iv
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_decrypt
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_decrypt_iv
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_set_iv
-
-.. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_blkcipher_get_iv
+   :functions: crypto_alloc_blkcipher rypto_free_blkcipher crypto_has_blkcipher crypto_blkcipher_name crypto_blkcipher_ivsize crypto_blkcipher_blocksize crypto_blkcipher_setkey crypto_blkcipher_encrypt crypto_blkcipher_encrypt_iv crypto_blkcipher_decrypt crypto_blkcipher_decrypt_iv crypto_blkcipher_set_iv crypto_blkcipher_get_iv
-- 
2.7.4


