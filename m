From: Martin Hicks <mort@bork.org>
Subject: [PATCH] crypto: talitos: Extend max key length for SHA384/512-HMAC
Date: Thu, 27 Apr 2017 11:40:46 -0400
Message-ID: <20170427154046.GA5041@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from darwin.bork.org ([65.49.60.145]:43206 "EHLO darwin.bork.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030419AbdD0Pqf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2017 11:46:35 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The max keysize for both of these is 128, not 96.  Before, with keysizes
over 96, the memcpy in ahash_setkey() would overwrite memory beyond the
key field.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0bba6a1..97dc85e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,7 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#define TALITOS_MAX_KEY_SIZE		96
+#define TALITOS_MAX_KEY_SIZE		SHA512_BLOCK_SIZE /* SHA512 has the largest keysize input */
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 struct talitos_ctx {
-- 
1.7.10.4


-- 
Martin Hicks P.Eng.    |      mort@bork.org
Bork Consulting Inc.   |  +1 (613) 266-2296
