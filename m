From: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] doc: crypto: warning cleanup
Date: Sun, 23 Aug 2015 13:51:01 -0600
Message-ID: <20150823135101.270c6630@xps.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix up a missing field description and a misdirected doc inclusion to make
a couple of warnings go away.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/DocBook/crypto-API.tmpl | 2 +-
 include/crypto/aead.h                 | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 0992531ffefb..980bcc994913 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
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
index 7169ad04acc0..88c6cdf3a886 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -120,6 +120,7 @@ struct aead_givcrypt_request {
  * @exit: Deinitialize the cryptographic transformation object. This is a
  *	  counterpart to @init, used to remove various changes set in
  *	  @init.
+ * @base: Common crypto API algorithm data structure
  *
  * All fields except @ivsize is mandatory and must be filled.
  */
-- 
2.4.3

