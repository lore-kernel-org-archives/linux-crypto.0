From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 7/8] omap-sham: FLAGS_FIRST is redundant and removed
Date: Fri, 19 Nov 2010 16:04:28 +0200
Message-ID: <d6513e13801b26221067cd1893960f6c58989dd0.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

bufcnt is 0 if it was no update requests before,
which is exact meaning of FLAGS_FIRST.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index c8d30eb..d88d7eb 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -72,7 +72,6 @@
 
 #define DEFAULT_TIMEOUT_INTERVAL	HZ
 
-#define FLAGS_FIRST		0x0001
 #define FLAGS_FINUP		0x0002
 #define FLAGS_FINAL		0x0004
 #define FLAGS_FAST		0x0008
@@ -513,8 +512,6 @@ static int omap_sham_init(struct ahash_request *req)
 
 	ctx->flags = 0;
 
-	ctx->flags |= FLAGS_FIRST;
-
 	dev_dbg(dd->dev, "init: digest size: %d\n",
 		crypto_ahash_digestsize(tfm));
 
@@ -739,12 +736,9 @@ static int omap_sham_update(struct ahash_request *req)
 			/* may be can use faster functions */
 			int aligned = IS_ALIGNED((u32)ctx->sg->offset,
 								sizeof(u32));
-
-			if (aligned && (ctx->flags & FLAGS_FIRST))
+			if (aligned)
 				/* digest: first and final */
 				ctx->flags |= FLAGS_FAST;
-
-			ctx->flags &= ~FLAGS_FIRST;
 		}
 	} else if (ctx->bufcnt + ctx->total <= ctx->buflen) {
 		/* if not finaup -> not fast */
-- 
1.7.0.4

