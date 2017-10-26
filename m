From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: core: Remove unnecessary new line in MODULE_PARM_DESC
Date: Thu, 26 Oct 2017 22:00:29 +0530
Message-ID: <20171026163029.23532-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:47383 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932137AbdJZQbe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 12:31:34 -0400
Received: by mail-pf0-f196.google.com with SMTP id z11so2890530pfk.4
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 09:31:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While using MODULE_PARM_DESC there is a new line which is not required.
Remove it.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 328d065..323f04c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -43,11 +43,10 @@ static unsigned short current_quality;
 static unsigned short default_quality; /* = 0; default to "off" */
 
 module_param(current_quality, ushort, 0644);
-MODULE_PARM_DESC(current_quality,
-		 "current hwrng entropy estimation per mill");
+MODULE_PARM_DESC(current_quality, "current hwrng entropy estimation per mill");
+
 module_param(default_quality, ushort, 0644);
-MODULE_PARM_DESC(default_quality,
-		 "default entropy content of hwrng per mill");
+MODULE_PARM_DESC(default_quality, "default entropy content of hwrng per mill");
 
 static size_t rng_buffer_size(void)
 {
-- 
2.10.0
