From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] CRC32C: crc32c module soft dependency
Date: Thu, 23 Jan 2014 11:35:20 -0800
Message-ID: <1390505720.3138.77.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbaAWTfl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jan 2014 14:35:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

It seems like we haven't folded in changes for adding
soft dependency to crc32c to ensure that the accelerated
version is loaded when available.

I take a crack with the patch below.

Tim

---->o-----
commit 016a709ef06bce5451a4b88e49f207a838c348e5
Author: Tim Chen <tim.c.chen@linux.intel.com>
Date:   Thu Jan 23 03:25:47 2014 -0800

    CRC32C: Add soft module dependency to load other accelerated crc32c
    modules
    
    We add the soft module dependency of crc32c module alias
    to generic crc32c module so other hardware accelerated crc32c
    modules could get loaded and used before the generic version.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 06f7018..d9c7beb 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -170,3 +170,5 @@ module_exit(crc32c_mod_fini);
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("crc32c");
+MODULE_SOFTDEP("pre: crc32c");
