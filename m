From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 04/13] crypto: crypto4xx: increase context and scatter ring buffer elements
Date: Wed,  4 Oct 2017 01:00:08 +0200
Message-ID: <81f5ee6cd79bd9ac319ace2cd7d778336b01b2d2.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34917 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXAX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:23 -0400
Received: by mail-wr0-f196.google.com with SMTP id y44so1822403wry.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:22 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If crypto4xx is used in conjunction with dm-crypt, the available
ring buffer elements are not enough to handle the load properly.

On an aes-cbc-essiv:sha256 encrypted swap partition the read
performance is abyssal: (tested with hdparm -t)

/dev/mapper/swap_crypt:
 Timing buffered disk reads:  14 MB in  3.68 seconds =   3.81 MB/sec

The patch increases both PPC4XX_NUM_SD and PPC4XX_NUM_PD to 256.
This improves the performance considerably:

/dev/mapper/swap_crypt:
 Timing buffered disk reads: 104 MB in  3.03 seconds =  34.31 MB/sec

Furthermore, PPC4XX_LAST_SD, PPC4XX_LAST_GD and PPC4XX_LAST_PD
can be easily calculated from their respective PPC4XX_NUM_*
constant.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 97fb8288ab30..27e439c1f5bf 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -36,12 +36,12 @@
 #define PPC405EX_CE_RESET                       0x00000008
 
 #define CRYPTO4XX_CRYPTO_PRIORITY		300
-#define PPC4XX_LAST_PD				63
-#define PPC4XX_NUM_PD				64
-#define PPC4XX_LAST_GD				1023
+#define PPC4XX_NUM_PD				256
+#define PPC4XX_LAST_PD				(PPC4XX_NUM_PD - 1)
 #define PPC4XX_NUM_GD				1024
-#define PPC4XX_LAST_SD				63
-#define PPC4XX_NUM_SD				64
+#define PPC4XX_LAST_GD				(PPC4XX_NUM_GD - 1)
+#define PPC4XX_NUM_SD				256
+#define PPC4XX_LAST_SD				(PPC4XX_NUM_SD - 1)
 #define PPC4XX_SD_BUFFER_SIZE			2048
 
 #define PD_ENTRY_INUSE				1
-- 
2.14.2
