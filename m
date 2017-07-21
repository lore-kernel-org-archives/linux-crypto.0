From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] crypto: Kconfig: Correct help text about feeding entropy pool
Date: Fri, 21 Jul 2017 22:55:56 +0530
Message-ID: <20170721172556.6877-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35756 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdGUR1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 13:27:10 -0400
Received: by mail-pf0-f193.google.com with SMTP id q85so5256973pfq.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 10:27:10 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify Kconfig help text to reflect the fact that random data from hwrng
is fed into kernel random number generator's entropy pool.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/Kconfig | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1b223c3..2f45e15 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -13,10 +13,8 @@ menuconfig HW_RANDOM
 	  that's usually called /dev/hwrng, and which exposes one
 	  of possibly several hardware random number generators.
 
-	  These hardware random number generators do not feed directly
-	  into the kernel's random number generator.  That is usually
-	  handled by the "rngd" daemon.  Documentation/hw_random.txt
-	  has more information.
+	  These hardware random number generators do feed into the
+	  kernel's random number generator entropy pool.
 
 	  If unsure, say Y.
 
-- 
2.10.0
