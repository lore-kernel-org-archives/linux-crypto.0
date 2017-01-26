From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 10/12] crypto: atmel-aes: fix atmel_aes_handle_queue()
Date: Thu, 26 Jan 2017 17:07:55 +0100
Message-ID: <ae7f0ea6eba2040050948b91a40ca9bc1df2d8ee.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes the value returned by atmel_aes_handle_queue(), which
could have been wrong previously when the crypto request was started
synchronously but became asynchronous during the ctx->start() call.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 0e3d0d655b96..9fd2f63b8bc0 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -879,6 +879,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	struct crypto_async_request *areq, *backlog;
 	struct atmel_aes_base_ctx *ctx;
 	unsigned long flags;
+	bool start_async;
 	int err, ret = 0;
 
 	spin_lock_irqsave(&dd->lock, flags);
@@ -904,10 +905,12 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 
 	dd->areq = areq;
 	dd->ctx = ctx;
-	dd->is_async = (areq != new_areq);
+	start_async = (areq != new_areq);
+	dd->is_async = start_async;
 
+	/* WARNING: ctx->start() MAY change dd->is_async. */
 	err = ctx->start(dd);
-	return (dd->is_async) ? ret : err;
+	return (start_async) ? ret : err;
 }
 
 
-- 
2.7.4
