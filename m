From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 6/8] crypto: doc - remove crypto_alloc_ablkcipher
Date: Fri, 21 Oct 2016 04:58:46 +0200
Message-ID: <1614944.tJMVZKQD86@positron.chronox.de>
References: <2053893.WjF01BJSDF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53678 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbcJUDA5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:00:57 -0400
In-Reply-To: <2053893.WjF01BJSDF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the documentation reference to crypto_alloc_ablkcipher as the API
function call was removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-skcipher.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index eabd369..cd8830b 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -107,9 +107,6 @@ Asynchronous Block Cipher API - Deprecated
    :doc: Asynchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alloc_ablkcipher
-
-.. kernel-doc:: include/linux/crypto.h
    :functions: crypto_free_ablkcipher
 
 .. kernel-doc:: include/linux/crypto.h
-- 
2.7.4
