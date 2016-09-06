From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: pasemi-rng - Use linux/io.h instead of asm/io.h
Date: Tue,  6 Sep 2016 13:58:39 +0530
Message-ID: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: olof@lixom.net, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34317 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbcIFI3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 04:29:02 -0400
Received: by mail-pf0-f195.google.com with SMTP id g202so11059884pfb.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Sep 2016 01:28:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Checkpatch.pl warns about usage of asm/io.h. Use linux/io.h instead.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/pasemi-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index b4e32f7..545df48 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -26,7 +26,7 @@
 #include <linux/delay.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define SDCRNG_CTL_REG			0x00
 #define   SDCRNG_CTL_FVLD_M		0x0000f000
-- 
2.5.0
