From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH] trusted-keys: skcipher bug info
Date: Tue, 20 Sep 2016 08:11:51 -0400
Message-ID: <1474373511.14532.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751635AbcITMMO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 08:12:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8KC8ejq122218
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2016 08:12:14 -0400
Received: from e28smtp04.in.ibm.com (e28smtp04.in.ibm.com [125.16.236.4])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25jnp6x54j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2016 08:12:14 -0400
Received: from localhost
        by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 20 Sep 2016 17:42:09 +0530
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The initial random iv value, initialized in encrypted_init(), should
not be modified.  Commit c3917fd "KEYS: Use skcipher", which replaced
the blkcipher with skcipher, modifies the iv in
crypto_skcipher_encrypt()/decrypt().

The following example creates an encrypted key, writes the key to a
file, and then loads the key from the file.  To illustrate the problem,
this patch provides crypto_skcipher_encrypt()/decrypt() with a copy of
the iv.  With this change, the resulting test-key and test-key1 keys
are the same.

keyctl add user kmk "`dd if=/dev/urandom bs=1 count=32 2>/dev/null`" @u
keyctl pipe `keyctl search @u user kmk` > ~/tmp/kmk
keyctl add encrypted test-key "new user:kmk 64" @u
keyctl pipe `keyctl search @u encrypted test-key` > /tmp/test-key1
keyctl add encrypted test-key1 "load `cat /tmp/test-key1`" @u

keyctl print `keyctl search @u encrypted test-key`
keyctl print `keyctl search @u encrypted test-key1`

Either the underlying problem should be fixed or commit c3917fd 
"KEYS: Use skcipher" should be reverted.

thanks,

Mimi

---
 security/keys/encrypted-keys/encrypted.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 5adbfc3..e94f586 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -480,6 +480,7 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	unsigned int encrypted_datalen;
 	unsigned int padlen;
 	char pad[16];
+	u8 iv[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -500,9 +501,19 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	sg_init_table(sg_out, 1);
 	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
 
+	memcpy(iv, epayload->iv, 16);	/* iv is modified */
 	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen,
-				   epayload->iv);
+				   iv);
+print_hex_dump(KERN_INFO, "original iv: ", DUMP_PREFIX_NONE, 32, 1,
+	       epayload->iv, ivsize, 0);
+print_hex_dump(KERN_INFO, "copied iv: ", DUMP_PREFIX_NONE, 32, 1,
+	       iv, ivsize, 0);
 	ret = crypto_skcipher_encrypt(req);
+print_hex_dump(KERN_INFO, "original iv: ", DUMP_PREFIX_NONE, 32, 1,
+	       epayload->iv, ivsize, 0);
+print_hex_dump(KERN_INFO, "modified iv: ", DUMP_PREFIX_NONE, 32, 1,
+	       iv, ivsize, 0);
+
 	tfm = crypto_skcipher_reqtfm(req);
 	skcipher_request_free(req);
 	crypto_free_skcipher(tfm);
@@ -582,6 +593,7 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 	struct skcipher_request *req;
 	unsigned int encrypted_datalen;
 	char pad[16];
+	u8 iv[16];
 	int ret;
 
 	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
@@ -599,8 +611,9 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 		   epayload->decrypted_datalen);
 	sg_set_buf(&sg_out[1], pad, sizeof pad);
 
+	memcpy(iv, epayload->iv, 16);	/* iv is modified */
 	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen,
-				   epayload->iv);
+				   iv);
 	ret = crypto_skcipher_decrypt(req);
 	tfm = crypto_skcipher_reqtfm(req);
 	skcipher_request_free(req);
@@ -778,8 +791,11 @@ static int encrypted_init(struct encrypted_key_payload *epayload,
 
 		get_random_bytes(epayload->decrypted_data,
 				 epayload->decrypted_datalen);
-	} else
+	} else {
 		ret = encrypted_key_decrypt(epayload, format, hex_encoded_iv);
+print_hex_dump(KERN_INFO, "init iv: ", DUMP_PREFIX_NONE, 32, 1,
+	       epayload->iv, ivsize, 0);
+	}
 	return ret;
 }
 
-- 
2.7.4
