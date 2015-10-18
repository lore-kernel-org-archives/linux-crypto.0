From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] Documentation: crypto - add akcipher API
Date: Mon, 19 Oct 2015 01:18:35 +0200
Message-ID: <1764843.9mR2beFdVv@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Reference the new akcipher API calls in the kernel crypto API DocBook.

Also, fix the comments in the akcipher.h file: double dashes do not look
good in the DocBook and fix a typo.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 24 ++++++++++++++++++++++++
 include/crypto/akcipher.h             | 28 ++++++++++++++--------------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 07df23e..80971db 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -485,6 +485,9 @@
       <para>CRYPTO_ALG_TYPE_RNG Random Number Generation</para>
      </listitem>
      <listitem>
+      <para>CRYPTO_ALG_TYPE_AKCIPHER Asymmetric cipher</para>
+     </listitem>
+     <listitem>
       <para>CRYPTO_ALG_TYPE_PCOMPRESS Enhanced version of
        CRYPTO_ALG_TYPE_COMPRESS allowing for segmented compression /
        decompression instead of performing the operation on one
@@ -1830,6 +1833,27 @@ read(opfd, out, outlen);
 !Finclude/crypto/rng.h crypto_rng_seedsize
 !Cinclude/crypto/rng.h
    </sect1>
+
+   <sect1><title>Asymmetric Cipher API</title>
+!Pinclude/crypto/akcipher.h Generic Public Key API
+!Finclude/crypto/akcipher.h akcipher_alg
+!Finclude/crypto/akcipher.h akcipher_request
+!Finclude/crypto/akcipher.h crypto_alloc_akcipher
+!Finclude/crypto/akcipher.h crypto_free_akcipher
+!Finclude/crypto/akcipher.h crypto_akcipher_set_pub_key
+!Finclude/crypto/akcipher.h crypto_akcipher_set_priv_key
+   </sect1>
+   <sect1><title>Asymmetric Cipher Request Handle</title>
+!Finclude/crypto/akcipher.h akcipher_request_alloc
+!Finclude/crypto/akcipher.h akcipher_request_free
+!Finclude/crypto/akcipher.h akcipher_request_set_callback
+!Finclude/crypto/akcipher.h akcipher_request_set_crypt
+!Finclude/crypto/akcipher.h crypto_akcipher_maxsize
+!Finclude/crypto/akcipher.h crypto_akcipher_encrypt
+!Finclude/crypto/akcipher.h crypto_akcipher_decrypt
+!Finclude/crypto/akcipher.h crypto_akcipher_sign
+!Finclude/crypto/akcipher.h crypto_akcipher_verify
+   </sect1>
   </chapter>
 
   <chapter id="Code"><title>Code Examples</title>
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 45cd5b3..63d8ffa 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -114,7 +114,7 @@ struct akcipher_alg {
  */
 
 /**
- * crypto_alloc_akcipher() -- allocate AKCIPHER tfm handle
+ * crypto_alloc_akcipher() - allocate AKCIPHER tfm handle
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
  *	      public key algorithm e.g. "rsa"
  * @type: specifies the type of the algorithm
@@ -171,7 +171,7 @@ static inline struct crypto_akcipher *crypto_akcipher_reqtfm(
 }
 
 /**
- * crypto_free_akcipher() -- free AKCIPHER tfm handle
+ * crypto_free_akcipher() - free AKCIPHER tfm handle
  *
  * @tfm: AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
  */
@@ -181,7 +181,7 @@ static inline void crypto_free_akcipher(struct crypto_akcipher *tfm)
 }
 
 /**
- * akcipher_request_alloc() -- allocates public key request
+ * akcipher_request_alloc() - allocates public key request
  *
  * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
  * @gfp:	allocation flags
@@ -201,7 +201,7 @@ static inline struct akcipher_request *akcipher_request_alloc(
 }
 
 /**
- * akcipher_request_free() -- zeroize and free public key request
+ * akcipher_request_free() - zeroize and free public key request
  *
  * @req:	request to free
  */
@@ -211,14 +211,14 @@ static inline void akcipher_request_free(struct akcipher_request *req)
 }
 
 /**
- * akcipher_request_set_callback() -- Sets an asynchronous callback.
+ * akcipher_request_set_callback() - Sets an asynchronous callback.
  *
  * Callback will be called when an asynchronous operation on a given
  * request is finished.
  *
  * @req:	request that the callback will be set for
  * @flgs:	specify for instance if the operation may backlog
- * @cmlp:	callback which will be called
+ * @cmpl:	callback which will be called
  * @data:	private data used by the caller
  */
 static inline void akcipher_request_set_callback(struct akcipher_request *req,
@@ -232,7 +232,7 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
 }
 
 /**
- * akcipher_request_set_crypt() -- Sets reqest parameters
+ * akcipher_request_set_crypt() - Sets reqest parameters
  *
  * Sets parameters required by crypto operation
  *
@@ -255,7 +255,7 @@ static inline void akcipher_request_set_crypt(struct akcipher_request *req,
 }
 
 /**
- * crypto_akcipher_maxsize() -- Get len for output buffer
+ * crypto_akcipher_maxsize() - Get len for output buffer
  *
  * Function returns the dest buffer size required for a given key
  *
@@ -271,7 +271,7 @@ static inline int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 }
 
 /**
- * crypto_akcipher_encrypt() -- Invoke public key encrypt operation
+ * crypto_akcipher_encrypt() - Invoke public key encrypt operation
  *
  * Function invokes the specific public key encrypt operation for a given
  * public key algorithm
@@ -289,7 +289,7 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_decrypt() -- Invoke public key decrypt operation
+ * crypto_akcipher_decrypt() - Invoke public key decrypt operation
  *
  * Function invokes the specific public key decrypt operation for a given
  * public key algorithm
@@ -307,7 +307,7 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_sign() -- Invoke public key sign operation
+ * crypto_akcipher_sign() - Invoke public key sign operation
  *
  * Function invokes the specific public key sign operation for a given
  * public key algorithm
@@ -325,7 +325,7 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_verify() -- Invoke public key verify operation
+ * crypto_akcipher_verify() - Invoke public key verify operation
  *
  * Function invokes the specific public key verify operation for a given
  * public key algorithm
@@ -343,7 +343,7 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_set_pub_key() -- Invoke set public key operation
+ * crypto_akcipher_set_pub_key() - Invoke set public key operation
  *
  * Function invokes the algorithm specific set key function, which knows
  * how to decode and interpret the encoded key
@@ -364,7 +364,7 @@ static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
 }
 
 /**
- * crypto_akcipher_set_priv_key() -- Invoke set private key operation
+ * crypto_akcipher_set_priv_key() - Invoke set private key operation
  *
  * Function invokes the algorithm specific set key function, which knows
  * how to decode and interpret the encoded key
-- 
2.5.0


