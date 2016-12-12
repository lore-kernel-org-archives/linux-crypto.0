From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Mon, 12 Dec 2016 12:53:24 -0800
Message-ID: <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        dhowells@redhat.com, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753397AbcLLUx3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 15:53:29 -0500
In-Reply-To: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver put a constant buffer of all zeros on the stack and
pointed a scatterlist entry at it in two places.  This doesn't work
with virtual stacks.  Use a static 16-byte buffer of zeros instead.

Cc: stable@vger.kernel.org # 4.9 only
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 security/keys/encrypted-keys/encrypted.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 17a06105ccb6..fab2fb864002 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -46,6 +46,7 @@ static const char key_format_default[] = "default";
 static const char key_format_ecryptfs[] = "ecryptfs";
 static unsigned int ivsize;
 static int blksize;
+static const char zero_pad[16] = {0};
 
 #define KEY_TRUSTED_PREFIX_LEN (sizeof (KEY_TRUSTED_PREFIX) - 1)
 #define KEY_USER_PREFIX_LEN (sizeof (KEY_USER_PREFIX) - 1)
@@ -481,7 +482,6 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	unsigned int encrypted_datalen;
 	u8 iv[AES_BLOCK_SIZE];
 	unsigned int padlen;
-	char pad[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -493,11 +493,10 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 		goto out;
 	dump_decrypted_data(epayload);
 
-	memset(pad, 0, sizeof pad);
 	sg_init_table(sg_in, 2);
 	sg_set_buf(&sg_in[0], epayload->decrypted_data,
 		   epayload->decrypted_datalen);
-	sg_set_buf(&sg_in[1], pad, padlen);
+	sg_set_buf(&sg_in[1], zero_pad, padlen);
 
 	sg_init_table(sg_out, 1);
 	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
@@ -584,7 +583,6 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 	struct skcipher_request *req;
 	unsigned int encrypted_datalen;
 	u8 iv[AES_BLOCK_SIZE];
-	char pad[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -594,13 +592,12 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 		goto out;
 	dump_encrypted_data(epayload, encrypted_datalen);
 
-	memset(pad, 0, sizeof pad);
 	sg_init_table(sg_in, 1);
 	sg_init_table(sg_out, 2);
 	sg_set_buf(sg_in, epayload->encrypted_data, encrypted_datalen);
 	sg_set_buf(&sg_out[0], epayload->decrypted_data,
 		   epayload->decrypted_datalen);
-	sg_set_buf(&sg_out[1], pad, sizeof pad);
+	sg_set_buf(&sg_out[1], zero_pad, sizeof zero_pad);
 
 	memcpy(iv, epayload->iv, sizeof(iv));
 	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
-- 
2.9.3
