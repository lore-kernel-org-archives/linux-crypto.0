From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 4/8] crypto: doc - fix separation of cipher / req API
Date: Fri, 21 Oct 2016 04:57:57 +0200
Message-ID: <5095646.nMOEH1Url6@positron.chronox.de>
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

Keep the cipher API and the request API function documentation in
separate sections.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-akcipher.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
index 305e616..49e0ab6 100644
--- a/Documentation/crypto/api-akcipher.rst
+++ b/Documentation/crypto/api-akcipher.rst
@@ -25,32 +25,32 @@ Asymmetric Cipher API
 .. kernel-doc:: include/crypto/akcipher.h
    :functions: crypto_akcipher_set_priv_key
 
-Asymmetric Cipher Request Handle
---------------------------------
-
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_alloc
+   :functions: crypto_akcipher_maxsize
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_free
+   :functions: crypto_akcipher_encrypt
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_set_callback
+   :functions: crypto_akcipher_decrypt
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: akcipher_request_set_crypt
+   :functions: crypto_akcipher_sign
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_maxsize
+   :functions: crypto_akcipher_verify
+
+Asymmetric Cipher Request Handle
+--------------------------------
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_encrypt
+   :functions: akcipher_request_alloc
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_decrypt
+   :functions: akcipher_request_free
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_sign
+   :functions: akcipher_request_set_callback
 
 .. kernel-doc:: include/crypto/akcipher.h
-   :functions: crypto_akcipher_verify
+   :functions: akcipher_request_set_crypt
-- 
2.7.4


