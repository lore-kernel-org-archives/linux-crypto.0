From: Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: scomp - delete unused comments
Date: Wed, 20 Dec 2017 16:03:12 +0800
Message-ID: <1513756992-175134-1-git-send-email-wangzhou1@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <giovanni.cabiddu@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752446AbdLTHQl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 02:16:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are no init and exit callbacks, so delete its comments.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 include/crypto/internal/scompress.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index ccad9b2..0f6ddac 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -28,17 +28,6 @@ struct crypto_scomp {
  * @free_ctx:	Function frees context allocated with alloc_ctx
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
- * @init:	Initialize the cryptographic transformation object.
- *		This function is used to initialize the cryptographic
- *		transformation object. This function is called only once at
- *		the instantiation time, right after the transformation context
- *		was allocated. In case the cryptographic hardware has some
- *		special requirements which need to be handled by software, this
- *		function shall check for the precise requirement of the
- *		transformation and put any software fallbacks in place.
- * @exit:	Deinitialize the cryptographic transformation object. This is a
- *		counterpart to @init, used to remove various changes set in
- *		@init.
  * @base:	Common crypto API algorithm data structure
  */
 struct scomp_alg {
-- 
1.9.1
