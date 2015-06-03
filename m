From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] Doc:crypto: Fix typo in crypto-API.xml
Date: Thu,  4 Jun 2015 00:01:21 +0900
Message-ID: <1433343681-10060-2-git-send-email-standby24x7@gmail.com>
References: <20150603032848.GA3126@gondor.apana.org.au>
 <1433343681-10060-1-git-send-email-standby24x7@gmail.com>
Cc: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34702 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbbFCPBc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 11:01:32 -0400
In-Reply-To: <1433343681-10060-1-git-send-email-standby24x7@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix some typos found in crypto-API.xml.
It is because the file is generated from comments in sources,
so I had to fix typo in sources.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 include/crypto/aead.h  | 2 +-
 include/crypto/hash.h  | 2 +-
 include/crypto/rng.h   | 2 +-
 include/linux/crypto.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 61306ed..fad7cd1 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -33,7 +33,7 @@
  *
  * The example code provided for the asynchronous block cipher operation
  * applies here as well. Naturally all *ablkcipher* symbols must be exchanged
- * the *aead* pendants discussed in the following. In addtion, for the AEAD
+ * the *aead* pendants discussed in the following. In addition, for the AEAD
  * operation, the aead_request_set_assoc function must be used to set the
  * pointer to the associated data memory location before performing the
  * encryption or decryption operation. In case of an encryption, the associated
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 98abda9..57c8a6e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -66,7 +66,7 @@ struct ahash_request {
 /**
  * struct ahash_alg - asynchronous message digest definition
  * @init: Initialize the transformation context. Intended only to initialize the
- *	  state of the HASH transformation at the begining. This shall fill in
+ *	  state of the HASH transformation at the beginning. This shall fill in
  *	  the internal structures used during the entire duration of the whole
  *	  transformation. No data processing happens at this point.
  * @update: Push a chunk of data into the driver for transformation. This
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index c5d4684..b95ede3 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -28,7 +28,7 @@ struct crypto_rng;
  *		if provided to the call.
  * @seed:	Seed or reseed the random number generator.  With the
  *		invocation of this function call, the random number
- *		generator shall become ready fo generation.  If the
+ *		generator shall become ready for generation.  If the
  *		random number generator requires a seed for setting
  *		up a new state, the seed must be provided by the
  *		consumer while invoking this function. The required
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7d290a9..25a4b71 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -451,7 +451,7 @@ struct compress_alg {
  *		     transformation algorithm.
  * @cra_type: Type of the cryptographic transformation. This is a pointer to
  *	      struct crypto_type, which implements callbacks common for all
- *	      trasnformation types. There are multiple options:
+ *	      transformation types. There are multiple options:
  *	      &crypto_blkcipher_type, &crypto_ablkcipher_type,
  *	      &crypto_ahash_type, &crypto_aead_type, &crypto_rng_type.
  *	      This field might be empty. In that case, there are no common
-- 
2.4.2.339.g77bd3ea
