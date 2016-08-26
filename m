From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 4/8] hwrng: amd: Remove asm/io.h
Date: Fri, 26 Aug 2016 13:11:32 +0200
Message-ID: <1472209896-17197-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

checkpatch complains about <asm/io.h> used instead of linux/io.h.
In fact it is not needed.
This patch remove it, and in the process, alphabetize the other headers.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 93157af..de82fe3 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -24,12 +24,11 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hw_random.h>
-#include <linux/delay.h>
-#include <asm/io.h>
 
 #define DRV_NAME "AMD768-HWRNG"
 
-- 
2.7.3
