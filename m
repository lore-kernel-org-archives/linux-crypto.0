From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: Include device.h instead of declaring struct device
Date: Thu, 26 Oct 2017 19:12:08 +0530
Message-ID: <20171026134208.31368-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:51618 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbdJZNnU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 09:43:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Include linux/device.h instead of declaring struct device.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 include/linux/hw_random.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index bee0827..2ec9af7 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -13,6 +13,7 @@
 #define LINUX_HWRANDOM_H_
 
 #include <linux/completion.h>
+#include <linux/device.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
@@ -51,8 +52,6 @@ struct hwrng {
 	struct completion cleanup_done;
 };
 
-struct device;
-
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
 extern int devm_hwrng_register(struct device *dev, struct hwrng *rng);
-- 
2.10.0
