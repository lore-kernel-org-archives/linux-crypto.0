From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 7/7] hwrng: core: Remove linux/sched.h from includes
Date: Tue, 13 Dec 2016 15:51:15 +0100
Message-ID: <20161213145115.30082-7-clabbe.montjoie@gmail.com>
References: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

linux/sched.h is useless for hw_random/core.c.
This patch remove it.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---

Change since v1:
- linux/fs.h was needed, keep it

 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 5c654b5..1c5949b 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -20,7 +20,6 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
-- 
2.10.2
