From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 1/4] crypto: cavium/nitrox - fix warnings while printing atomic64_t types
Date: Sat, 29 Sep 2018 13:49:07 +0530
Message-ID: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

fix compilation warnings with nitrox_debugfs.c while printing
atomic64_t types on arm64. typecast the atomic64_read() value to u64

This issue is reported by Ard Biesheuvel

drivers/crypto/cavium/nitrox/nitrox_debugfs.c:62:30:
warning: format ‘%lld’ expects argument of type ‘long long int’,
         but argument 3 has type ‘long int’ [-Wformat=]
  seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
                              ^
Fixes: 2a8780be9c26 (crypto: cavium/nitrox - updated debugfs information)
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
index 2f1e74ea846e..5f3cd5fafe04 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -59,10 +59,12 @@ static int stats_show(struct seq_file *s, void *v)
 	struct nitrox_device *ndev = s->private;
 
 	seq_printf(s, "NITROX [%d] Request Statistics\n", ndev->idx);
-	seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
-	seq_printf(s, "  Completed: %lld\n",
-		   atomic64_read(&ndev->stats.completed));
-	seq_printf(s, "  Dropped: %lld\n", atomic64_read(&ndev->stats.dropped));
+	seq_printf(s, "  Posted: %llu\n",
+		   (u64)atomic64_read(&ndev->stats.posted));
+	seq_printf(s, "  Completed: %llu\n",
+		   (u64)atomic64_read(&ndev->stats.completed));
+	seq_printf(s, "  Dropped: %llu\n",
+		   (u64)atomic64_read(&ndev->stats.dropped));
 
 	return 0;
 }
-- 
2.17.1
