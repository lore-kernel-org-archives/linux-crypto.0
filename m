From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 1/1] omap-sham: backlog handling fix
Date: Wed, 29 Dec 2010 11:58:28 +0200
Message-ID: <16ffeda30b634b3ee0c9b55220b30dd689c5d182.1293616613.git.dmitry.kasatkin@nokia.com>
References: <cover.1293616613.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1293616613.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1293616613.git.dmitry.kasatkin@nokia.com>
References: <cover.1293616613.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Previous commit "removed redundant locking" introduced
a bug in handling backlog.
In certain cases, when async request complete callback will
call complete() on -EINPROGRESS code, it will cause uncompleted requests.
It does not happen in implementation similar to crypto test manager,
but it will happen in implementation similar to dm-crypt.
Backlog needs to be checked before dequeuing next request.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index eb988e7..2e71123 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -664,7 +664,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 				  struct ahash_request *req)
 {
-	struct crypto_async_request *async_req, *backlog = 0;
+	struct crypto_async_request *async_req, *backlog;
 	struct omap_sham_reqctx *ctx;
 	struct ahash_request *prev_req;
 	unsigned long flags;
@@ -677,11 +677,10 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 		spin_unlock_irqrestore(&dd->lock, flags);
 		return ret;
 	}
+	backlog = crypto_get_backlog(&dd->queue);
 	async_req = crypto_dequeue_request(&dd->queue);
-	if (async_req) {
+	if (async_req)
 		dd->flags |= FLAGS_BUSY;
-		backlog = crypto_get_backlog(&dd->queue);
-	}
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
-- 
1.7.0.4

