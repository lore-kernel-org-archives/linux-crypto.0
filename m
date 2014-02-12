From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] AES: Add soft module dependency to load other accelerated
 AES modules
Date: Wed, 12 Feb 2014 10:54:13 -0800
Message-ID: <1392231253.27116.38.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaBLSyR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


We added the soft module dependency of AES module alias
to generic aes module, inducing other hardware accelerated AES
modules to get loaded and used when available.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/aes_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index fd0d6b4..0d9f519 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1475,3 +1475,4 @@ module_exit(aes_fini);
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("aes");
+MODULE_SOFTDEP("pre: aes");
-- 
1.7.11.7
