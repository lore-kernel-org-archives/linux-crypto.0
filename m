From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: documentation - cover new AEAD interface
Date: Thu, 28 May 2015 08:52:42 +0200
Message-ID: <29243893.aiPfC1p5hR@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58334 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbbE1Gwu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 02:52:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch updates the DocBook to cover the new AEAD interface
implementation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 23 +++++++++++++++++------
 include/crypto/aead.h                 |  5 ++++-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 5b05510..f3fc077 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -536,8 +536,8 @@
 
      <para>
       For other use cases of AEAD ciphers, the ASCII art applies as
-      well, but the caller may not use the GIVCIPHER interface. In
-      this case, the caller must generate the IV.
+      well, but the caller may not use the AEAD cipher with a separate
+      IV generator. In this case, the caller must generate the IV.
      </para>
 
      <para>
@@ -584,8 +584,8 @@ kernel crypto API                                |   IPSEC Layer
                                                  |
 +-----------+                                    |
 |           |            (1)
-| givcipher | <-----------------------------------  esp_output
-|  (seqiv)  | ---+
+|   aead    | <-----------------------------------  esp_output
+| (seqniv)  | ---+
 +-----------+    |
                  | (2)
 +-----------+    |
@@ -620,8 +620,8 @@ kernel crypto API                                |   IPSEC Layer
      <orderedlist>
       <listitem>
        <para>
-        esp_output() invokes crypto_aead_givencrypt() to trigger an encryption
-        operation of the GIVCIPHER implementation.
+        esp_output() invokes crypto_aead_encrypt() to trigger an encryption
+        operation of the AEAD cipher with IV generator.
        </para>
 
        <para>
@@ -1669,6 +1669,16 @@ read(opfd, out, outlen);
   </chapter>
 
   <chapter id="API"><title>Programming Interface</title>
+   <para>
+    Please note that the kernel crypto API contains the AEAD givcrypt
+    API (crypto_aead_giv* and aead_givcrypt_* function calls in
+    include/crypto/aead.h). This API is obsolete and will be removed
+    in the future. To obtain the functionality of an AEAD cipher with
+    internal IV generation, use the IV generator as a regular cipher.
+    For example, rfc4106(gcm(aes)) is the AEAD cipher with external
+    IV generation and seqniv(rfc4106(gcm(aes))) implies that the kernel
+    crypto API generates the IV. Different IV generators are available.
+   </para>
    <sect1><title>Block Cipher Context Data Structures</title>
 !Pinclude/linux/crypto.h Block Cipher Context Data Structures
 !Finclude/crypto/aead.h aead_request
@@ -1724,6 +1734,7 @@ read(opfd, out, outlen);
 !Finclude/crypto/aead.h aead_request_set_callback
 !Finclude/crypto/aead.h aead_request_set_crypt
 !Finclude/crypto/aead.h aead_request_set_assoc
+!Finclude/crypto/aead.h aead_request_set_ad
    </sect1>
    <sect1><title>Synchronous Block Cipher API</title>
 !Pinclude/linux/crypto.h Synchronous Block Cipher API
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 61306ed..1a273bc 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -50,6 +50,7 @@
 /**
  *	struct aead_request - AEAD request
  *	@base: Common attributes for async crypto requests
+ *	@old: Boolean whether the old or new AEAD API is used
  *	@assoclen: Length in bytes of associated data for authentication
  *	@cryptlen: Length of data to be encrypted or decrypted
  *	@iv: Initialisation vector
@@ -467,7 +468,9 @@ static inline void aead_request_set_callback(struct aead_request *req,
  * @iv: IV for the cipher operation which must comply with the IV size defined
  *      by crypto_aead_ivsize()
  *
- * Setting the source data and destination data scatter / gather lists.
+ * Setting the source data and destination data scatter / gather lists which
+ * hold the associated data concatenated with the plaintext or ciphertext. See
+ * below for the authentication tag.
  *
  * For encryption, the source is treated as the plaintext and the
  * destination is the ciphertext. For a decryption operation, the use is
-- 
2.1.0
