From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 16/22] staging: crypto: skein: fix do/while brace formatting
Date: Tue, 11 Mar 2014 21:32:48 +0000
Message-ID: <2f243f3b49ec31d57e4f44c9eb1168feca232ed0.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52034 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755781AbaCKVzp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:45 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
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
1.9.0
