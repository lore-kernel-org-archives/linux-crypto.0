From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/8] crypto: akcipher: fix typos in include/crypto/akcipher.h
Date: Mon, 12 Oct 2015 18:53:43 +0200
Message-ID: <1444668826-6531-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	thomas.lendacky@amd.com, geert+renesas@glider.be,
	ulf.hansson@linaro.org, wsa@the-dreams.de, keescook@chromium.org,
	maxime.ripard@free-electrons.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix numerous spelling error in include/crypto/akcipher.h

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/crypto/akcipher.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 69d163e..0c9fa68 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -19,12 +19,12 @@
  *
  * @base:	Common attributes for async crypto requests
  * @src:	Pointer to memory containing the input parameters
- *		The format of the parameter(s) is expeted to be Octet String
- * @dst:	Pointer to memory whare the result will be stored
+ *		The format of the parameter(s) is expected to be Octet String
+ * @dst:	Pointer to memory where the result will be stored
  * @src_len:	Size of the input parameter
- * @dst_len:	Size of the output buffer. It needs to be at leaset
+ * @dst_len:	Size of the output buffer. It needs to be at least
  *		as big as the expected result depending	on the operation
- *		After operation it will be updated with the acctual size of the
+ *		After operation it will be updated with the actual size of the
  *		result. In case of error, where the dst_len was insufficient,
  *		it will be updated to the size required for the operation.
  * @__ctx:	Start of private context data
@@ -59,7 +59,7 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @encrypt:	Function performs an encrytp operation as defined by public key
+ * @encrypt:	Function performs an encrypt operation as defined by public key
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
@@ -224,7 +224,7 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
 }
 
 /**
- * akcipher_request_set_crypt() -- Sets reqest parameters
+ * akcipher_request_set_crypt() -- Sets request parameters
  *
  * Sets parameters required by crypto operation
  *
@@ -233,7 +233,7 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
  * @dst:	ptr of output parameter
  * @src_len:	size of the input buffer
  * @dst_len:	size of the output buffer. It will be updated by the
- *		implementation to reflect the acctual size of the result
+ *		implementation to reflect the actual size of the result
  */
 static inline void akcipher_request_set_crypt(struct akcipher_request *req,
 					      void *src, void *dst,
-- 
2.4.9
