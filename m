From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 06/11] omap-sham: remove unnecessary local variable
Date: Thu,  2 Jun 2011 21:10:08 +0300
Message-ID: <34981be4c02475c2e77401d27b6b6951adf6ec6d.1306926921.git.dmitry.kasatkin@gmail.com>
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
 drivers/crypto/omap-sham.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b959dc6..84e5890 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1033,7 +1033,6 @@ static struct ahash_alg algs[] = {
 static void omap_sham_done_task(unsigned long data)
 {
 	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
-	struct ahash_request *req = dd->req;
 	int ready = 0, err = 0;
 
 	if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
@@ -1050,7 +1049,7 @@ static void omap_sham_done_task(unsigned long data)
 	if (err != -EINPROGRESS && (ready || err)) {
 		dev_dbg(dd->dev, "update done: err: %d\n", err);
 		/* finish curent request */
-		omap_sham_finish_req(req, err);
+		omap_sham_finish_req(dd->req, err);
 		/* start new request */
 		omap_sham_handle_queue(dd, NULL);
 	}
-- 
1.7.4.1

