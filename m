From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: akcipher: fix typos in include/crypto/akcipher.h
Date: Tue,  8 Dec 2015 09:00:23 +0100
Message-ID: <1449561627-6085-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35788 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbLHIA7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2015 03:00:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix numerous spelling error in include/crypto/akcipher.h

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/crypto/akcipher.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 45cd5b3..354de15 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -21,9 +21,9 @@
  * @src:	Source data
  * @dst:	Destination data
  * @src_len:	Size of the input buffer
- * @dst_len:	Size of the output buffer. It needs to be at leaset
+ * @dst_len:	Size of the output buffer. It needs to be at least
  *		as big as the expected result depending	on the operation
- *		After operation it will be updated with the acctual size of the
+ *		After operation it will be updated with the actual size of the
  *		result.
  *		In case of error where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
@@ -59,7 +59,7 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @encrypt:	Function performs an encrytp operation as defined by public key
+ * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
@@ -73,7 +73,7 @@ struct crypto_akcipher {
  * @set_priv_key: Function invokes the algorithm specific set private key
  *		function, which knows how to decode and interpret
  *		the BER encoded private key
- * @max_size:	Function returns dest buffer size reqired for a given key.
+ * @max_size:	Function returns dest buffer size required for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -232,7 +232,7 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
 }
 
 /**
- * akcipher_request_set_crypt() -- Sets reqest parameters
+ * akcipher_request_set_crypt() -- Sets request parameters
  *
  * Sets parameters required by crypto operation
  *
-- 
2.4.10
