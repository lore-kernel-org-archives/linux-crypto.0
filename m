From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] crypto: remove duplicated include
Date: Sun, 26 Aug 2012 09:34:06 +0800
Message-ID: <CAPgLHd8k0L5vBBhsZv3H0aAbLPUqfN2GHUcLFswzCPx93i94yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33447 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2HZBeH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Aug 2012 21:34:07 -0400
Received: by qcro28 with SMTP id o28so1933984qcr.19
        for <linux-crypto@vger.kernel.org>; Sat, 25 Aug 2012 18:34:07 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/atmel-aes.c  | 5 -----
 drivers/crypto/atmel-sha.c  | 5 -----
 drivers/crypto/atmel-tdes.c | 5 -----
 3 files changed, 15 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6bb20ff..fb81f87 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -24,15 +24,10 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/clk.h>
 #include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index f938b9d..bcdf55f 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -24,15 +24,10 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/clk.h>
 #include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index eb2b61e..1f36365 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -24,15 +24,10 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/clk.h>
 #include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
