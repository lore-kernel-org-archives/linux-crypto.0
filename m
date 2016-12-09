From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/7] hwrng: core: remove unused PFX macro
Date: Fri,  9 Dec 2016 15:21:38 +0100
Message-ID: <1481293299-21697-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch remove the unused PFX macro.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1e1e385..5c654b5 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -25,7 +25,6 @@
 #include <linux/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
-#define PFX			RNG_MODULE_NAME ": "
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
-- 
2.7.3
