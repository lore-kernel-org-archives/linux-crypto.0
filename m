From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 6/7] crypto: doc - remove crypto_alloc_ablkcipher
Date: Sun, 16 Oct 2016 05:19:46 +0200
Message-ID: <1582841.7YjsasGI6D@positron.chronox.de>
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

Remove the documentation reference to crypto_alloc_ablkcipher as the API
function call was removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-skcipher.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index eabd369..cd8830b 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -107,9 +107,6 @@ Asynchronous Block Cipher API - Deprecated
    :doc: Asynchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_ablkcipher
-
-.. kernel-doc:: include/linux/crypto.h
    :functions: crypto_free_ablkcipher
 
 .. kernel-doc:: include/linux/crypto.h
-- 
2.7.4


