From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 15/21] staging: crypto: skein: fix do/while brace formatting
Date: Mon, 24 Mar 2014 01:49:12 +0000
Message-ID: <77ee3c0f13526887a395138d9eb464cdf43a5120.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33207 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbaCXBtq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:46 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/skein_block.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 780b4936f783..6e0f4a21aae3 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -215,8 +215,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-	}
-	while (--blkCnt);
+	} while (--blkCnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
@@ -434,8 +433,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-	}
-	while (--blkCnt);
+	} while (--blkCnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
@@ -717,8 +715,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 		blkPtr += SKEIN1024_BLOCK_BYTES;
-	}
-	while (--blkCnt);
+	} while (--blkCnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
-- 
1.9.1
