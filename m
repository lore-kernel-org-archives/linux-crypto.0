Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9090FC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Apr 2022 01:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347136AbiDTBaT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Apr 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDTBaT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Apr 2022 21:30:19 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A46E245A2
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 18:27:34 -0700 (PDT)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23K1RECK068633;
        Wed, 20 Apr 2022 10:27:14 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Wed, 20 Apr 2022 10:27:14 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23K1RDNr068630
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 20 Apr 2022 10:27:14 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
Date:   Wed, 20 Apr 2022 10:27:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] crypto: atmel - Avoid flush_scheduled_work() usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Flushing system-wide workqueues is dangerous and will be forbidden.
Replace system_wq with local atmel_wq.

Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Note: This patch is only compile tested.

 drivers/crypto/atmel-ecc.c     |  2 +-
 drivers/crypto/atmel-i2c.c     | 24 +++++++++++++++++++++++-
 drivers/crypto/atmel-i2c.h     |  1 +
 drivers/crypto/atmel-sha204a.c |  2 +-
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 333fbefbbccb..59a57279e77b 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -398,7 +398,7 @@ static int __init atmel_ecc_init(void)
 
 static void __exit atmel_ecc_exit(void)
 {
-	flush_scheduled_work();
+	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_ecc_driver);
 }
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 6fd3e969211d..226c55bfb9d6 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -263,6 +263,8 @@ static void atmel_i2c_work_handler(struct work_struct *work)
 	work_data->cbk(work_data, work_data->areq, status);
 }
 
+static struct workqueue_struct *atmel_wq;
+
 void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
 		       void (*cbk)(struct atmel_i2c_work_data *work_data,
 				   void *areq, int status),
@@ -272,10 +274,16 @@ void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
 	work_data->areq = areq;
 
 	INIT_WORK(&work_data->work, atmel_i2c_work_handler);
-	schedule_work(&work_data->work);
+	queue_work(atmel_wq, &work_data->work);
 }
 EXPORT_SYMBOL(atmel_i2c_enqueue);
 
+void atmel_i2c_flush_queue(void)
+{
+	flush_workqueue(atmel_wq);
+}
+EXPORT_SYMBOL(atmel_i2c_flush_queue);
+
 static inline size_t atmel_i2c_wake_token_sz(u32 bus_clk_rate)
 {
 	u32 no_of_bits = DIV_ROUND_UP(TWLO_USEC * bus_clk_rate, USEC_PER_SEC);
@@ -372,6 +380,20 @@ int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 }
 EXPORT_SYMBOL(atmel_i2c_probe);
 
+static int __init atmel_i2c_init(void)
+{
+	atmel_wq = alloc_workqueue("atmel_wq", 0, 0);
+	return atmel_wq ? 0 : -ENOMEM;
+}
+
+static void __exit atmel_i2c_exit(void)
+{
+	destroy_workqueue(atmel_wq);
+}
+
+module_init(atmel_i2c_init);
+module_exit(atmel_i2c_exit);
+
 MODULE_AUTHOR("Tudor Ambarus <tudor.ambarus@microchip.com>");
 MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 63b97b104f16..48929efe2a5b 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -173,6 +173,7 @@ void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
 		       void (*cbk)(struct atmel_i2c_work_data *work_data,
 				   void *areq, int status),
 		       void *areq);
+void atmel_i2c_flush_queue(void);
 
 int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd);
 
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index c96c14e7dab1..2168f877bd43 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -159,7 +159,7 @@ static int __init atmel_sha204a_init(void)
 
 static void __exit atmel_sha204a_exit(void)
 {
-	flush_scheduled_work();
+	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_sha204a_driver);
 }
 
-- 
2.32.0
