From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] trusted-keys: skcipher bug info
Date: Tue, 20 Sep 2016 20:35:55 +0800
Message-ID: <20160920123555.GA22272@gondor.apana.org.au>
References: <1474373511.14532.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        keyrings@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60372 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcITMgB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 08:36:01 -0400
Content-Disposition: inline
In-Reply-To: <1474373511.14532.9.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 20, 2016 at 08:11:51AM -0400, Mimi Zohar wrote:
> Hi Herbert,
> 
> The initial random iv value, initialized in encrypted_init(), should
> not be modified.  Commit c3917fd "KEYS: Use skcipher", which replaced
> the blkcipher with skcipher, modifies the iv in
> crypto_skcipher_encrypt()/decrypt().
> 
> The following example creates an encrypted key, writes the key to a
> file, and then loads the key from the file.  To illustrate the problem,
> this patch provides crypto_skcipher_encrypt()/decrypt() with a copy of
> the iv.  With this change, the resulting test-key and test-key1 keys
> are the same.

Sorry, I missed the subtlety.  This patch should fix the problem.

---8<---
Subject: KEYS: Fix skcipher IV clobbering

The IV must not be modified by the skcipher operation so we need
to duplicate it.

Fixes: c3917fd9dfbc ("KEYS: Use skcipher")
Cc: stable@vger.kernel.org
Reported-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 5adbfc3..17a0610 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/scatterlist.h>
 #include <linux/ctype.h>
+#include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <crypto/skcipher.h>
@@ -478,6 +479,7 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	struct crypto_skcipher *tfm;
 	struct skcipher_request *req;
 	unsigned int encrypted_datalen;
+	u8 iv[AES_BLOCK_SIZE];
 	unsigned int padlen;
 	char pad[16];
 	int ret;
@@ -500,8 +502,8 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	sg_init_table(sg_out, 1);
 	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen,
-				   epayload->iv);
+	memcpy(iv, epayload->iv, sizeof(iv));
+	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
 	ret = crypto_skcipher_encrypt(req);
 	tfm = crypto_skcipher_reqtfm(req);
 	skcipher_request_free(req);
@@ -581,6 +583,7 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 	struct crypto_skcipher *tfm;
 	struct skcipher_request *req;
 	unsigned int encrypted_datalen;
+	u8 iv[AES_BLOCK_SIZE];
 	char pad[16];
 	int ret;
 
@@ -599,8 +602,8 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 		   epayload->decrypted_datalen);
 	sg_set_buf(&sg_out[1], pad, sizeof pad);
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen,
-				   epayload->iv);
+	memcpy(iv, epayload->iv, sizeof(iv));
+	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
 	ret = crypto_skcipher_decrypt(req);
 	tfm = crypto_skcipher_reqtfm(req);
 	skcipher_request_free(req);

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
