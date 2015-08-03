From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: documentation - AEAD API conversion
Date: Mon, 03 Aug 2015 09:08:05 +0200
Message-ID: <1757399.eaVjudjyCK@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48070 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbbHCHIK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:08:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AEAD API changes are now reflected in the crypto API doc book.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl |  4 ++--
 include/crypto/aead.h                 | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 0992531..8e17a41 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -585,7 +585,7 @@ kernel crypto API                                |   IPSEC Layer
 +-----------+                                    |
 |           |            (1)
 |   aead    | <-----------------------------------  esp_output
-| (seqniv)  | ---+
+|  (seqiv)  | ---+
 +-----------+    |
                  | (2)
 +-----------+    |
@@ -1687,7 +1687,7 @@ read(opfd, out, outlen);
 !Pinclude/linux/crypto.h Block Cipher Algorithm Definitions
 !Finclude/linux/crypto.h crypto_alg
 !Finclude/linux/crypto.h ablkcipher_alg
-!Finclude/linux/crypto.h aead_alg
+!Finclude/crypto/aead.h aead_alg
 !Finclude/linux/crypto.h blkcipher_alg
 !Finclude/linux/crypto.h cipher_alg
 !Finclude/crypto/rng.h rng_alg
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 7169ad0..14e35364 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -45,6 +45,30 @@
  * a breach in the integrity of the message. In essence, that -EBADMSG error
  * code is the key bonus an AEAD cipher has over "standard" block chaining
  * modes.
+ *
+ * Memory Structure:
+ *
+ * To support the needs of the most prominent user of AEAD ciphers, namely
+ * IPSEC, the AEAD ciphers have a special memory layout the caller must adhere
+ * to.
+ *
+ * The scatter list pointing to the input data must contain:
+ *
+ * * for RFC4106 ciphers, the concatenation of
+ * associated authentication data || IV || plaintext or ciphertext. Note, the
+ * same IV (buffer) is also set with the aead_request_set_crypt call. Note,
+ * the API call of aead_request_set_ad must provide the length of the AAD and
+ * the IV. The API call of aead_request_set_crypt only points to the size of
+ * the input plaintext or ciphertext.
+ *
+ * * for "normal" AEAD ciphers, the concatenation of
+ * associated authentication data || plaintext or ciphertext.
+ *
+ * It is important to note that if multiple scatter gather list entries form
+ * the input data mentioned above, the first entry must not point to a NULL
+ * buffer. If there is any potential where the AAD buffer can be NULL, the
+ * calling code must contain a precaution to ensure that this does not result
+ * in the first scatter gather list entry pointing to a NULL buffer.
  */
 
 /**
-- 
2.1.0
