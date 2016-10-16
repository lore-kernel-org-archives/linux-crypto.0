From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 7/7] crypto: doc - clarify AEAD memory structure
Date: Sun, 16 Oct 2016 05:22:55 +0200
Message-ID: <2836054.OXHgEonhSr@positron.chronox.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        Harsh Jain <harshjain.prof@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2721226.4nLlHD9uQ6@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The previous description have been misleading and partially incorrect.

Reported-by: Harsh Jain <harshjain.prof@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c   | 14 ++------------
 include/crypto/aead.h | 35 +++++++++++------------------------
 2 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 80a0f1a..a0d8377 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -551,18 +551,8 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	lock_sock(sk);
 
 	/*
-	 * AEAD memory structure: For encryption, the tag is appended to the
-	 * ciphertext which implies that the memory allocated for the ciphertext
-	 * must be increased by the tag length. For decryption, the tag
-	 * is expected to be concatenated to the ciphertext. The plaintext
-	 * therefore has a memory size of the ciphertext minus the tag length.
-	 *
-	 * The memory structure for cipher operation has the following
-	 * structure:
-	 *	AEAD encryption input:  assoc data || plaintext
-	 *	AEAD encryption output: cipherntext || auth tag
-	 *	AEAD decryption input:  assoc data || ciphertext || auth tag
-	 *	AEAD decryption output: plaintext
+	 * Please see documentation of aead_request_set_crypt for the
+	 * description of the AEAD memory structure expected from the caller.
 	 */
 
 	if (ctx->more) {
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 1bd3a2f..b7f3373 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -483,30 +483,17 @@ static inline void aead_request_set_callback(struct aead_request *req,
  * destination is the ciphertext. For a decryption operation, the use is
  * reversed - the source is the ciphertext and the destination is the plaintext.
  *
- * For both src/dst the layout is associated data, plain/cipher text,
- * authentication tag.
- *
- * The content of the AD in the destination buffer after processing
- * will either be untouched, or it will contain a copy of the AD
- * from the source buffer.  In order to ensure that it always has
- * a copy of the AD, the user must copy the AD over either before
- * or after processing.  Of course this is not relevant if the user
- * is doing in-place processing where src == dst.
- *
- * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
- *		  the caller must concatenate the ciphertext followed by the
- *		  authentication tag and provide the entire data stream to the
- *		  decryption operation (i.e. the data length used for the
- *		  initialization of the scatterlist and the data length for the
- *		  decryption operation is identical). For encryption, however,
- *		  the authentication tag is created while encrypting the data.
- *		  The destination buffer must hold sufficient space for the
- *		  ciphertext and the authentication tag while the encryption
- *		  invocation must only point to the plaintext data size. The
- *		  following code snippet illustrates the memory usage
- *		  buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
- *		  sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
- *		  aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
+ * The memory structure for cipher operation has the following structure:
+ *	AEAD encryption input:  assoc data || plaintext
+ *	AEAD encryption output: assoc data || cipherntext || auth tag
+ *	AEAD decryption input:  assoc data || ciphertext || auth tag
+ *	AEAD decryption output: assoc data || plaintext
+ *
+ * Albeit the kernel requires the presence of the AAD buffer, however,
+ * the kernel does not fill the AAD buffer in the output case. If the
+ * caller wants to have that data buffer filled, the caller must either
+ * use an in-place cipher operation (i.e. same memory location for
+ * input/output memory location).
  */
 static inline void aead_request_set_crypt(struct aead_request *req,
 					  struct scatterlist *src,
-- 
2.7.4


