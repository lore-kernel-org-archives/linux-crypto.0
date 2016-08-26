From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 5/8] hwrng: amd: release_region must be called after hwrng_unregister
Date: Fri, 26 Aug 2016 13:11:33 +0200
Message-ID: <1472209896-17197-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver release the memory region before being sure that nobody use
it.

This patch made hwrng_unregister ran before any release was done.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index de82fe3..383e197 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -151,8 +151,9 @@ static void __exit mod_exit(void)
 {
 	u32 pmbase = (unsigned long)amd_rng.priv;
 
-	release_region(pmbase + 0xF0, 8);
 	hwrng_unregister(&amd_rng);
+
+	release_region(pmbase + 0xF0, 8);
 }
 
 module_init(mod_init);
-- 
2.7.3
