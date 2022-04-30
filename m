Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFECDC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Apr 2022 07:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiD3HFc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Apr 2022 03:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiD3HFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Apr 2022 03:05:31 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175AE5BD0E
        for <linux-crypto@vger.kernel.org>; Sat, 30 Apr 2022 00:02:08 -0700 (PDT)
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23U71jon080544;
        Sat, 30 Apr 2022 16:01:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Sat, 30 Apr 2022 16:01:45 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23U71iT2080480
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 30 Apr 2022 16:01:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <15b21200-c639-7d62-bd7f-a559d2ee0ac5@I-love.SAKURA.ne.jp>
Date:   Sat, 30 Apr 2022 16:01:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH v2] crypto: atmel - Avoid flush_scheduled_work() usage
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org
References: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
 <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
 <5de198b9-7488-13e4-bf22-6c58c1c8b401@I-love.SAKURA.ne.jp>
 <YmulfBqsSON47lDR@gondor.apana.org.au>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YmulfBqsSON47lDR@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Flushing system-wide workqueues is dangerous and will be forbidden.
Replace system_wq with local atmel_wq.

If CONFIG_CRYPTO_DEV_ATMEL_{I2C,ECC,SHA204A}=y, the ordering in Makefile
guarantees that module_init() for atmel-i2c runs before module_init()
for atmel-ecc and atmel-sha204a runs.

Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Changes in v2:
  Add a comment for built-in case to Makefile, suggested by Herbert Xu <herbert@gondor.apana.org.au>

 drivers/crypto/Makefile        |  1 +
 drivers/crypto/atmel-ecc.c     |  2 +-
 drivers/crypto/atmel-i2c.c     | 24 +++++++++++++++++++++++-
 drivers/crypto/atmel-i2c.h     |  1 +
 drivers/crypto/atmel-sha204a.c |  2 +-
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0a4fff23d272..f81703a86b98 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_CRYPTO_DEV_ALLWINNER) += allwinner/
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
+# __init ordering requires atmel-i2c being before atmel-ecc and atmel-sha204a.
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o
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
2.34.1


