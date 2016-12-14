From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Tue, 13 Dec 2016 18:48:07 -0800
Message-ID: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        dhowells@redhat.com, keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver put a constant buffer of all zeros on the stack and
pointed a scatterlist entry at it in two places.  This doesn't work
with virtual stacks.  Use ZERO_PAGE instead.

Cc: stable@vger.kernel.org # 4.9 only
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 security/keys/encrypted-keys/encrypted.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 17a06105ccb6..e963160ed26a 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -481,7 +481,6 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	unsigned int encrypted_datalen;
 	u8 iv[AES_BLOCK_SIZE];
 	unsigned int padlen;
-	char pad[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -493,11 +492,10 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 		goto out;
 	dump_decrypted_data(epayload);
 
-	memset(pad, 0, sizeof pad);
 	sg_init_table(sg_in, 2);
 	sg_set_buf(&sg_in[0], epayload->decrypted_data,
 		   epayload->decrypted_datalen);
-	sg_set_buf(&sg_in[1], pad, padlen);
+	sg_set_page(&sg_in[1], ZERO_PAGE(0), padlen, 0);
 
 	sg_init_table(sg_out, 1);
 	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
@@ -584,7 +582,6 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 	struct skcipher_request *req;
 	unsigned int encrypted_datalen;
 	u8 iv[AES_BLOCK_SIZE];
-	char pad[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -594,13 +591,12 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 		goto out;
 	dump_encrypted_data(epayload, encrypted_datalen);
 
-	memset(pad, 0, sizeof pad);
 	sg_init_table(sg_in, 1);
 	sg_init_table(sg_out, 2);
 	sg_set_buf(sg_in, epayload->encrypted_data, encrypted_datalen);
 	sg_set_buf(&sg_out[0], epayload->decrypted_data,
 		   epayload->decrypted_datalen);
-	sg_set_buf(&sg_out[1], pad, sizeof pad);
+	sg_set_buf(&sg_out[1], empty_zero_page, 16);
 
 	memcpy(iv, epayload->iv, sizeof(iv));
 	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
-- 
2.9.3
