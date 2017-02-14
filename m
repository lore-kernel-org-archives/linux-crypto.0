From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: fix typo in doc
Date: Tue, 14 Feb 2017 08:21:45 +0200
Message-ID: <1487053305-1790-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        gilad.benyossef@arm.com
To: dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:38934 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdBNGV7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 01:21:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a single letter typo in api-skcipher.rst.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 Documentation/crypto/api-skcipher.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index b20028a..4eec4a9 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -59,4 +59,4 @@ Synchronous Block Cipher API - Deprecated
    :doc: Synchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_blkcipher rypto_free_blkcipher crypto_has_blkcipher crypto_blkcipher_name crypto_blkcipher_ivsize crypto_blkcipher_blocksize crypto_blkcipher_setkey crypto_blkcipher_encrypt crypto_blkcipher_encrypt_iv crypto_blkcipher_decrypt crypto_blkcipher_decrypt_iv crypto_blkcipher_set_iv crypto_blkcipher_get_iv
+   :functions: crypto_alloc_blkcipher crypto_free_blkcipher crypto_has_blkcipher crypto_blkcipher_name crypto_blkcipher_ivsize crypto_blkcipher_blocksize crypto_blkcipher_setkey crypto_blkcipher_encrypt crypto_blkcipher_encrypt_iv crypto_blkcipher_decrypt crypto_blkcipher_decrypt_iv crypto_blkcipher_set_iv crypto_blkcipher_get_iv
-- 
2.1.4
