From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/5] hwrng: amd: Remove asm/io.h
Date: Fri, 19 Aug 2016 15:42:56 +0200
Message-ID: <1471614177-12380-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35659 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754080AbcHSN5q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 09:57:46 -0400
In-Reply-To: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

checkpatch complains about <asm/io.h> used instead of linux/io.h.
In fact it is not needed.
This patch remove it, and in the process, alphabetize the other headers.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index d0a806a..9ddc99c 100644
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
