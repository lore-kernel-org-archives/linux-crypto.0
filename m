From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 02/11] omap-sham: remove unused code
Date: Thu,  2 Jun 2011 21:10:04 +0300
Message-ID: <63475b714e870f1d2ee8b40cfbbfc833de8cdae4.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8a45fb7..ac12a60 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -658,7 +658,6 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 {
 	struct crypto_async_request *async_req, *backlog;
 	struct omap_sham_reqctx *ctx;
-	struct ahash_request *prev_req;
 	unsigned long flags;
 	int err = 0, ret = 0;
 
@@ -682,16 +681,12 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 		backlog->complete(backlog, -EINPROGRESS);
 
 	req = ahash_request_cast(async_req);
-
-	prev_req = dd->req;
 	dd->req = req;
-
 	ctx = ahash_request_ctx(req);
 
 	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %d\n",
 						ctx->op, req->nbytes);
 
-
 	err = omap_sham_hw_init(dd);
 	if (err)
 		goto err1;
-- 
1.7.4.1

