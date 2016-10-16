From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 4/7] crypto: doc - fix separation of cipher / req API
Date: Sun, 16 Oct 2016 05:18:48 +0200
Message-ID: <5908263.2TLWr89bHl@positron.chronox.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2721226.4nLlHD9uQ6@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Keep the cipher API and the request API function documentation in
separate sections.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-akcipher.rst | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
index 305e616..0d5899f 100644
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


