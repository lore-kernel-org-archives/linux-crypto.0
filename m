From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: geode-rng - Use linux/io.h instead of asm/io.h
Date: Sun, 11 Sep 2016 20:54:26 +0530
Message-ID: <1473607466-25929-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com,
        linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34332 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751044AbcIKPZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Sep 2016 11:25:13 -0400
Received: by mail-pf0-f194.google.com with SMTP id g202so6797439pfb.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Sep 2016 08:25:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix checkpatch.pl warning by changing from asm/io.h to linux/io.h. In
the mean time arrange the includes in alphabetical order.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/geode-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 79e7482..0cae210 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -24,12 +24,12 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hw_random.h>
-#include <linux/delay.h>
-#include <asm/io.h>
 
 #define GEODE_RNG_DATA_REG   0x50
 #define GEODE_RNG_STATUS_REG 0x54
-- 
2.5.0
