From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: relocate ALG_MAX_PAGES to uapi
Date: Fri, 25 Dec 2015 18:14:54 +0100
Message-ID: <2751031.ZCTdkaqdWA@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:40936 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbbLYRO6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Dec 2015 12:14:58 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The define of ALG_MAX_PAGES is relevant for user space as this macro
defines the maximum number of pages to be processed in one go by
vmsplice/splice. If user space does not obey that limit, the calling
thread will hang until a recvmsg is called (by another thread).

As user space should have the ability to prevent such blocks, it needs
to know about the limit. Therefore, the define is moved to the uapi
header file.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/if_alg.h     | 2 --
 include/uapi/linux/if_alg.h | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 018afb2..fb00376 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -20,8 +20,6 @@
 #include <linux/types.h>
 #include <net/sock.h>
 
-#define ALG_MAX_PAGES			16
-
 struct crypto_async_request;
 
 struct alg_sock {
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..96af72f 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -39,4 +39,7 @@ struct af_alg_iv {
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
 
+/* Maximum number of pages to be processed */
+#define ALG_MAX_PAGES			16
+
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.5.0
