From: "Pathak, Rahul (R.)" <rpathak@visteon.com>
Subject: [PATCH 1/2] crypto: atmel-sha: Removed unused variable "err"
Date: Mon, 14 Dec 2015 08:44:19 +0000
Message-ID: <20151214084411.GA8727@visteon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <549615F6E6C7B748B9C36D9F873D6859@eurprd06.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rahul Pathak <rpathak@visteon.com>

Removed unused variable "err" and directly return "0"

Reported by coccicheck -
./drivers/crypto/atmel-sha.c:758:5-8: Unneeded variable: "err". Return "0" on line 766

Signed-off-by: Rahul Pathak <rpathak@visteon.com>
---
 drivers/crypto/atmel-sha.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 660d8c0..20de861 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -755,7 +755,6 @@ static int atmel_sha_finish(struct ahash_request *req)
 {
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = ctx->dd;
-	int err = 0;
 
 	if (ctx->digcnt[0] || ctx->digcnt[1])
 		atmel_sha_copy_ready_hash(req);
@@ -763,7 +762,7 @@ static int atmel_sha_finish(struct ahash_request *req)
 	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %d\n", ctx->digcnt[1],
 		ctx->digcnt[0], ctx->bufcnt);
 
-	return err;
+	return 0;
 }
 
 static void atmel_sha_finish_req(struct ahash_request *req, int err)
-- 
1.9.1
