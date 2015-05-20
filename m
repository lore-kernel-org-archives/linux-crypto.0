From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] documentation: change header file locations
Date: Wed, 20 May 2015 15:21:54 +0200
Message-ID: <2568733.jyKSVuFE5b@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57990 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbbETNWt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 09:22:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to the recent update of the kernel crypto API header files,
locations of function definitions and their documentation have changed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 40 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index efc8d90..5b05510 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1671,7 +1671,7 @@ read(opfd, out, outlen);
   <chapter id="API"><title>Programming Interface</title>
    <sect1><title>Block Cipher Context Data Structures</title>
 !Pinclude/linux/crypto.h Block Cipher Context Data Structures
-!Finclude/linux/crypto.h aead_request
+!Finclude/crypto/aead.h aead_request
    </sect1>
    <sect1><title>Block Cipher Algorithm Definitions</title>
 !Pinclude/linux/crypto.h Block Cipher Algorithm Definitions
@@ -1680,7 +1680,7 @@ read(opfd, out, outlen);
 !Finclude/linux/crypto.h aead_alg
 !Finclude/linux/crypto.h blkcipher_alg
 !Finclude/linux/crypto.h cipher_alg
-!Finclude/linux/crypto.h rng_alg
+!Finclude/crypto/rng.h rng_alg
    </sect1>
    <sect1><title>Asynchronous Block Cipher API</title>
 !Pinclude/linux/crypto.h Asynchronous Block Cipher API
@@ -1704,26 +1704,26 @@ read(opfd, out, outlen);
 !Finclude/linux/crypto.h ablkcipher_request_set_crypt
    </sect1>
    <sect1><title>Authenticated Encryption With Associated Data (AEAD) Cipher API</title>
-!Pinclude/linux/crypto.h Authenticated Encryption With Associated Data (AEAD) Cipher API
-!Finclude/linux/crypto.h crypto_alloc_aead
-!Finclude/linux/crypto.h crypto_free_aead
-!Finclude/linux/crypto.h crypto_aead_ivsize
-!Finclude/linux/crypto.h crypto_aead_authsize
-!Finclude/linux/crypto.h crypto_aead_blocksize
-!Finclude/linux/crypto.h crypto_aead_setkey
-!Finclude/linux/crypto.h crypto_aead_setauthsize
-!Finclude/linux/crypto.h crypto_aead_encrypt
-!Finclude/linux/crypto.h crypto_aead_decrypt
+!Pinclude/crypto/aead.h Authenticated Encryption With Associated Data (AEAD) Cipher API
+!Finclude/crypto/aead.h crypto_alloc_aead
+!Finclude/crypto/aead.h crypto_free_aead
+!Finclude/crypto/aead.h crypto_aead_ivsize
+!Finclude/crypto/aead.h crypto_aead_authsize
+!Finclude/crypto/aead.h crypto_aead_blocksize
+!Finclude/crypto/aead.h crypto_aead_setkey
+!Finclude/crypto/aead.h crypto_aead_setauthsize
+!Finclude/crypto/aead.h crypto_aead_encrypt
+!Finclude/crypto/aead.h crypto_aead_decrypt
    </sect1>
    <sect1><title>Asynchronous AEAD Request Handle</title>
-!Pinclude/linux/crypto.h Asynchronous AEAD Request Handle
-!Finclude/linux/crypto.h crypto_aead_reqsize
-!Finclude/linux/crypto.h aead_request_set_tfm
-!Finclude/linux/crypto.h aead_request_alloc
-!Finclude/linux/crypto.h aead_request_free
-!Finclude/linux/crypto.h aead_request_set_callback
-!Finclude/linux/crypto.h aead_request_set_crypt
-!Finclude/linux/crypto.h aead_request_set_assoc
+!Pinclude/crypto/aead.h Asynchronous AEAD Request Handle
+!Finclude/crypto/aead.h crypto_aead_reqsize
+!Finclude/crypto/aead.h aead_request_set_tfm
+!Finclude/crypto/aead.h aead_request_alloc
+!Finclude/crypto/aead.h aead_request_free
+!Finclude/crypto/aead.h aead_request_set_callback
+!Finclude/crypto/aead.h aead_request_set_crypt
+!Finclude/crypto/aead.h aead_request_set_assoc
    </sect1>
    <sect1><title>Synchronous Block Cipher API</title>
 !Pinclude/linux/crypto.h Synchronous Block Cipher API
-- 
2.1.0
