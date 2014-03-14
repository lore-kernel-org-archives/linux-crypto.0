From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH cryptodev 2/4] crypto: export NULL algorithms defines
Date: Fri, 14 Mar 2014 17:46:50 +0200
Message-ID: <1394812012-13714-2-git-send-email-horia.geanta@freescale.com>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:54735
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbaCNPr2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2014 11:47:28 -0400
In-Reply-To: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These defines might be needed by crypto drivers.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 crypto/crypto_null.c  |  6 +-----
 include/crypto/null.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 5 deletions(-)
 create mode 100644 include/crypto/null.h

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index fee7265cd35d..1dc54bb95a87 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <crypto/null.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
@@ -24,11 +25,6 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 
-#define NULL_KEY_SIZE		0
-#define NULL_BLOCK_SIZE		1
-#define NULL_DIGEST_SIZE	0
-#define NULL_IV_SIZE		0
-
 static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen)
 {
diff --git a/include/crypto/null.h b/include/crypto/null.h
new file mode 100644
index 000000000000..b7c864cc70df
--- /dev/null
+++ b/include/crypto/null.h
@@ -0,0 +1,11 @@
+/* Values for NULL algorithms */
+
+#ifndef _CRYPTO_NULL_H
+#define _CRYPTO_NULL_H
+
+#define NULL_KEY_SIZE		0
+#define NULL_BLOCK_SIZE		1
+#define NULL_DIGEST_SIZE	0
+#define NULL_IV_SIZE		0
+
+#endif
-- 
1.8.3.1
