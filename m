From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 21/22] staging: crypto: skein: remove unnecessary line continuation
Date: Tue, 11 Mar 2014 21:32:53 +0000
Message-ID: <44383723f82fc37502f8732b2796c51bb61535a8.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52089 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755782AbaCKVzq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:46 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
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
1.9.0
