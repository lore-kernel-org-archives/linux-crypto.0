From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: n2: set array of const as const
Date: Wed, 14 Oct 2015 21:15:13 +0200
Message-ID: <1444850114-17194-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some array of const char are not set as const.
This patch fix that.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/n2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8ea6c32..febbd5e 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -34,7 +34,7 @@
 #define DRV_MODULE_VERSION	"0.2"
 #define DRV_MODULE_RELDATE	"July 28, 2011"
 
-static char version[] =
+static const char version[] =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
-- 
2.4.9
