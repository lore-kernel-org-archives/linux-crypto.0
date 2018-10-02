From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: cavium/nitrox - Fix format strings
Date: Tue,  2 Oct 2018 23:00:03 +0200
Message-ID: <20181002210022.2369756-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The return type of atomic64_read() is unfortunately architecture
specific, it can be 'long', 'long long', or 's64'. When it is 'long',
we get a build warning:

drivers/crypto/cavium/nitrox/nitrox_debugfs.c: In function 'stats_show':
drivers/crypto/cavium/nitrox/nitrox_debugfs.c:62:30: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]
  seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
                           ~~~^
                           %ld
drivers/crypto/cavium/nitrox/nitrox_debugfs.c:63:33: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]
  seq_printf(s, "  Completed: %lld\n",
                              ~~~^
                              %ld
drivers/crypto/cavium/nitrox/nitrox_debugfs.c:65:31: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]

Add an explicit cast to 's64' to get a consistent behavior on all
architectures here during compile testing.

Fixes: 2a8780be9c26 ("crypto: cavium/nitrox - updated debugfs information.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
index 2f1e74ea846e..c5be91e5034c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -59,10 +59,10 @@ static int stats_show(struct seq_file *s, void *v)
 	struct nitrox_device *ndev = s->private;
 
 	seq_printf(s, "NITROX [%d] Request Statistics\n", ndev->idx);
-	seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
+	seq_printf(s, "  Posted: %lld\n", (s64)atomic64_read(&ndev->stats.posted));
 	seq_printf(s, "  Completed: %lld\n",
-		   atomic64_read(&ndev->stats.completed));
-	seq_printf(s, "  Dropped: %lld\n", atomic64_read(&ndev->stats.dropped));
+		   (s64)atomic64_read(&ndev->stats.completed));
+	seq_printf(s, "  Dropped: %lld\n", (s64)atomic64_read(&ndev->stats.dropped));
 
 	return 0;
 }
-- 
2.18.0
