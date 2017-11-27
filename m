From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] X.509: use crypto_shash_digest()
Date: Sun, 26 Nov 2017 23:19:54 -0800
Message-ID: <20171127071954.26273-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37249 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdK0HUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:20:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Use crypto_shash_digest() instead of crypto_shash_init() followed by
crypto_shash_finup().  (For simplicity only; they are equivalent.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 9db20abe78a0..3b39c0659155 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -79,11 +79,7 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	desc->tfm = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	ret = crypto_shash_init(desc);
-	if (ret < 0)
-		goto error_2;
-	might_sleep();
-	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, sig->digest);
+	ret = crypto_shash_digest(desc, cert->tbs, cert->tbs_size, sig->digest);
 	if (ret < 0)
 		goto error_2;
 
-- 
2.15.0
