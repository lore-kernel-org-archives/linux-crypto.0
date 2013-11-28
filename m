From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: remove unnecessary includes
Date: Thu, 28 Nov 2013 19:16:27 +0200
Message-ID: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:43468
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577Ab3K1RQj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 12:16:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/authenc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 1875e70..7d4bfaa 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -17,11 +17,8 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
 
 typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int flags);
 
-- 
1.7.11.7
