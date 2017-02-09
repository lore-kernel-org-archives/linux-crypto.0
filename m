From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: asymmetric_keys - Fix error return code on failure
Date: Thu,  9 Feb 2017 15:57:24 +0000
Message-ID: <20170209155724.19737-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33539 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751818AbdBIP5a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 10:57:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the akcipher_request_alloc()
error handling case instead of 0.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 crypto/asymmetric_keys/public_key.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 3a23274..3131bba 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -184,8 +184,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 		return PTR_ERR(tfm);
 
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		ret = -ENOMEM;
 		goto error_free_tfm;
+	}
 
 	if (pkey->key_is_private)
 		ret = crypto_akcipher_set_priv_key(tfm,
@@ -268,8 +270,10 @@ int public_key_verify_signature(const struct public_key *pkey,
 		return PTR_ERR(tfm);
 
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		ret = -ENOMEM;
 		goto error_free_tfm;
+	}
 
 	if (pkey->key_is_private)
 		ret = crypto_akcipher_set_priv_key(tfm,
