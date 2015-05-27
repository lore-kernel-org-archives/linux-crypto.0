From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/11] crypto: aead - Document behaviour of AD in destination buffer
Date: Wed, 27 May 2015 14:37:26 +0800
Message-ID: <E1YxUxy-0006ku-MQ@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47039 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbE0Gh3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:29 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUxz-0005bB-0X
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:27 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch defines the behaviour of AD in the new interface more
clearly.  In particular, it specifies that if the user must copy
the AD to the destination manually when src != dst if they wish
to guarantee that the destination buffer contains a copy of the
AD.

The reason for this is that otherwise every AEAD implementation
would have to perform such a copy when src != dst.  In reality
most users do in-place processing where src == dst so this is
not an issue.

This patch also kills some remaining references to cryptoff.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/aead.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 94141dc..61306ed 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -473,8 +473,15 @@ static inline void aead_request_set_callback(struct aead_request *req,
  * destination is the ciphertext. For a decryption operation, the use is
  * reversed - the source is the ciphertext and the destination is the plaintext.
  *
- * For both src/dst the layout is associated data, skipped data,
- * plain/cipher text, authentication tag.
+ * For both src/dst the layout is associated data, plain/cipher text,
+ * authentication tag.
+ *
+ * The content of the AD in the destination buffer after processing
+ * will either be untouched, or it will contain a copy of the AD
+ * from the source buffer.  In order to ensure that it always has
+ * a copy of the AD, the user must copy the AD over either before
+ * or after processing.  Of course this is not relevant if the user
+ * is doing in-place processing where src == dst.
  *
  * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
  *		  the caller must concatenate the ciphertext followed by the
@@ -525,8 +532,7 @@ static inline void aead_request_set_assoc(struct aead_request *req,
  * @assoclen: number of bytes in associated data
  *
  * Setting the AD information.  This function sets the length of
- * the associated data and the number of bytes to skip after it to
- * access the plain/cipher text.
+ * the associated data.
  */
 static inline void aead_request_set_ad(struct aead_request *req,
 				       unsigned int assoclen)
