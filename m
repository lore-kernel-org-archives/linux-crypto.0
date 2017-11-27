From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] pkcs7: use crypto_shash_digest()
Date: Sun, 26 Nov 2017 23:20:05 -0800
Message-ID: <20171127072005.26333-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40269 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbdK0HUL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:20:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Use crypto_shash_digest() instead of crypto_shash_init() followed by
crypto_shash_finup().  (For simplicity only; they are equivalent.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 063d6745c741..1647313872aa 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -59,11 +59,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	/* Digest the message [RFC2315 9.3] */
-	ret = crypto_shash_init(desc);
-	if (ret < 0)
-		goto error;
-	ret = crypto_shash_finup(desc, pkcs7->data, pkcs7->data_len,
-				 sig->digest);
+	ret = crypto_shash_digest(desc, pkcs7->data, pkcs7->data_len,
+				  sig->digest);
 	if (ret < 0)
 		goto error;
 	pr_devel("MsgDigest = [%*ph]\n", 8, sig->digest);
-- 
2.15.0
