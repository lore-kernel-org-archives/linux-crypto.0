From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 19/22] staging: crypto: skein: remove externs from .c files
Date: Tue, 11 Mar 2014 21:32:51 +0000
Message-ID: <8a6a45bda19d51521b7e0022d063fe41982c3c0d.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52064 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755798AbaCKVzq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:46 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein_block.h | 22 ++++++++++++++++++++++
 drivers/staging/skein/skein.c               | 10 +---------
 2 files changed, 23 insertions(+), 9 deletions(-)
 create mode 100644 drivers/staging/skein/include/skein_block.h

diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/include/skein_block.h
new file mode 100644
index 000000000000..b15c079b5bd4
--- /dev/null
+++ b/drivers/staging/skein/include/skein_block.h
@@ -0,0 +1,22 @@
+/***********************************************************************
+**
+** Implementation of the Skein hash function.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+************************************************************************/
+#ifndef _SKEIN_BLOCK_H_
+#define _SKEIN_BLOCK_H_
+
+#include <skein.h> /* get the Skein API definitions   */
+
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+
+#endif
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 0d8c70c02c6f..096b86bf9430 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -13,15 +13,7 @@
 #include <linux/string.h>       /* get the memcpy/memset functions */
 #include <skein.h> /* get the Skein API definitions   */
 #include <skein_iv.h>    /* get precomputed IVs */
-
-/*****************************************************************/
-/* External function to process blkCnt (nonzero) full block(s) of data. */
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
+#include <skein_block.h>
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
-- 
1.9.0
