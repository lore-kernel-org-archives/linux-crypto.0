From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: Documentation: remove colons in comments
Date: Mon, 19 Jan 2015 00:13:39 +0100
Message-ID: <4431066.AhB5zCO9nr@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59535 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbbASFZ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 00:25:27 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S10B59> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 19 Jan 2015 06:25:22 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As documented in Documentation/kernel-doc-nano-HOWTO.txt lines
terminated with a colon are treated as headings.

The current layout of the documentation when compiling the kernel
crypto API DocBook documentation is messed up by by treating some lines
as headings. The patch removes colons from comments that shall not be
treated as headings.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9099834..fb5ef16 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1147,7 +1147,7 @@ static inline void ablkcipher_request_free(struct ablkcipher_request *req)
  * cipher operation completes.
  *
  * The callback function is registered with the ablkcipher_request handle and
- * must comply with the following template:
+ * must comply with the following template
  *
  *	void callback_function(struct crypto_async_request *req, int error)
  */
@@ -1174,7 +1174,7 @@ static inline void ablkcipher_request_set_callback(
  *
  * For encryption, the source is treated as the plaintext and the
  * destination is the ciphertext. For a decryption operation, the use is
- * reversed: the source is the ciphertext and the destination is the plaintext.
+ * reversed - the source is the ciphertext and the destination is the plaintext.
  */
 static inline void ablkcipher_request_set_crypt(
 	struct ablkcipher_request *req,
@@ -1509,7 +1509,7 @@ static inline void aead_request_free(struct aead_request *req)
  * completes
  *
  * The callback function is registered with the aead_request handle and
- * must comply with the following template:
+ * must comply with the following template
  *
  *	void callback_function(struct crypto_async_request *req, int error)
  */
@@ -1536,7 +1536,7 @@ static inline void aead_request_set_callback(struct aead_request *req,
  *
  * For encryption, the source is treated as the plaintext and the
  * destination is the ciphertext. For a decryption operation, the use is
- * reversed: the source is the ciphertext and the destination is the plaintext.
+ * reversed - the source is the ciphertext and the destination is the plaintext.
  *
  * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
  *		  the caller must concatenate the ciphertext followed by the
-- 
2.1.0
