From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: atmel-ecc: fix signed integer to u8 assignment
Date: Thu, 20 Jul 2017 16:35:49 +0300
Message-ID: <20170720133549.27078-1-tudor.ambarus@microchip.com>
References: <20170720094140.3y36xergecw6eysj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:14239 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932561AbdGTNgj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 09:36:39 -0400
In-Reply-To: <20170720094140.3y36xergecw6eysj@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

static checker warning:
        drivers/crypto/atmel-ecc.c:281 atmel_ecdh_done()
        warn: assigning (-22) to unsigned variable 'status'

Similar warning can be raised in atmel_ecc_work_handler()
when atmel_ecc_send_receive() returns an error. Fix this too.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-ecc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 66ab1021..647a994 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -99,7 +99,7 @@ struct atmel_ecdh_ctx {
  *        @work_data: data structure representing the work
  *        @areq     : optional pointer to an argument passed with the original
  *                    request.
- *        @status   : status returned from the device.
+ *        @status   : status returned from the i2c client device or i2c error.
  * @areq: optional pointer to a user argument for use at callback time.
  * @work: describes the task to be executed.
  * @cmd : structure used for communicating with the device.
@@ -107,7 +107,7 @@ struct atmel_ecdh_ctx {
 struct atmel_ecc_work_data {
 	struct atmel_ecdh_ctx *ctx;
 	void (*cbk)(struct atmel_ecc_work_data *work_data, void *areq,
-		    u8 status);
+		    int status);
 	void *areq;
 	struct work_struct work;
 	struct atmel_ecc_cmd cmd;
@@ -263,7 +263,7 @@ static int atmel_ecc_sleep(struct i2c_client *client)
 }
 
 static void atmel_ecdh_done(struct atmel_ecc_work_data *work_data, void *areq,
-			    u8 status)
+			    int status)
 {
 	struct kpp_request *req = areq;
 	struct atmel_ecdh_ctx *ctx = work_data->ctx;
@@ -344,7 +344,7 @@ static void atmel_ecc_work_handler(struct work_struct *work)
 			container_of(work, struct atmel_ecc_work_data, work);
 	struct atmel_ecc_cmd *cmd = &work_data->cmd;
 	struct i2c_client *client = work_data->ctx->client;
-	u8 status;
+	int status;
 
 	status = atmel_ecc_send_receive(client, cmd);
 	work_data->cbk(work_data, work_data->areq, status);
@@ -352,7 +352,7 @@ static void atmel_ecc_work_handler(struct work_struct *work)
 
 static void atmel_ecc_enqueue(struct atmel_ecc_work_data *work_data,
 			      void (*cbk)(struct atmel_ecc_work_data *work_data,
-					  void *areq, u8 status),
+					  void *areq, int status),
 			      void *areq)
 {
 	work_data->cbk = (void *)cbk;
-- 
2.9.4
