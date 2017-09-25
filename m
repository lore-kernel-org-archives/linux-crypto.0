From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] hwrng: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 13:15:00 +0530
Message-ID: <83efca3fa5f581e0d150fa72b4efa38340fb0a31.1506325384.git.arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: mpm@selenic.com, herbert@gondor.apana.org.au, mingo@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9701ac7..ff79844 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -423,7 +423,7 @@ static void start_khwrngd(void)
 {
 	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
 	if (IS_ERR(hwrng_fill)) {
-		pr_err("hwrng_fill thread creation failed");
+		pr_err("hwrng_fill thread creation failed\n");
 		hwrng_fill = NULL;
 	}
 }
-- 
1.9.1
