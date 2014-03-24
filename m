From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 20/21] staging: crypto: skein: remove unnecessary line continuation
Date: Mon, 24 Mar 2014 01:49:17 +0000
Message-ID: <947013ede454b1293a1670817c52ce40196516b7.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30565 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaCXBtr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:47 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/skein_block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 707a21ae53c6..fd96ca0ad0ed 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -477,7 +477,7 @@ unsigned int Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 				size_t blkCnt, size_t byteCntAdd)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
-- 
1.9.1
