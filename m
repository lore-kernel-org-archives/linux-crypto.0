From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/4] Documentation: crypto - update AEAD AD handling
Date: Tue, 16 Feb 2016 11:33:13 +0100
Message-ID: <2896245.8YejBjdtIG@positron.chronox.de>
References: <1550901.OUzcZboqul@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1550901.OUzcZboqul@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The associated data handling with the kernel crypto API has been
updated. This needs to be reflected in the documentation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 1 -
 include/crypto/aead.h                 | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index a2986b2..50efc5a 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1736,7 +1736,6 @@ read(opfd, out, outlen);
 !Finclude/crypto/aead.h aead_request_free
 !Finclude/crypto/aead.h aead_request_set_callback
 !Finclude/crypto/aead.h aead_request_set_crypt
-!Finclude/crypto/aead.h aead_request_set_assoc
 !Finclude/crypto/aead.h aead_request_set_ad
    </sect1>
    <sect1><title>Synchronous Block Cipher API</title>
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 84d13b1..957bb87 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -31,10 +31,10 @@
  *
  * For example: authenc(hmac(sha256), cbc(aes))
  *
- * The example code provided for the asynchronous block cipher operation
- * applies here as well. Naturally all *ablkcipher* symbols must be exchanged
+ * The example code provided for the symmetric key cipher operation
+ * applies here as well. Naturally all *skcipher* symbols must be exchanged
  * the *aead* pendants discussed in the following. In addition, for the AEAD
- * operation, the aead_request_set_assoc function must be used to set the
+ * operation, the aead_request_set_ad function must be used to set the
  * pointer to the associated data memory location before performing the
  * encryption or decryption operation. In case of an encryption, the associated
  * data memory is filled during the encryption operation. For decryption, the
-- 
2.5.0


