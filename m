From: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] crypto: tegra-aes: Fix NULL pointer dereference
Date: Mon, 16 Sep 2013 09:01:10 +0530
Message-ID: <1379302271-22438-1-git-send-email-sachin.kamat@linaro.org>
Cc: linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org, sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

'dd' is tested for NULL. However, it is derefenced in the error
message print. Change the print to pr_err to avoid this.

Signed-off-by: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/crypto/tegra-aes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 403282f..33f9530 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -27,6 +27,8 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -716,7 +718,7 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 	u8 *dt;
 
 	if (!ctx || !dd) {
-		dev_err(dd->dev, "ctx=0x%x, dd=0x%x\n",
+		pr_err("ctx=0x%x, dd=0x%x\n",
 			(unsigned int)ctx, (unsigned int)dd);
 		return -EINVAL;
 	}
-- 
1.7.9.5
