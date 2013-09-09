From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] crypto: tegra: use kernel entropy instead of ad-hoc
Date: Mon,  9 Sep 2013 09:35:54 +0200
Message-ID: <1378712154-30602-1-git-send-email-linus.walleij@linaro.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The way I read the Tegra AES RNG is that it has a homebrew
algorithm for initializing the 128bit RNG using timespec and
the unique chip ID. This looks like reinventing the (square)
wheel, instead just grab 128bits from the kernel entropy pool
where the time and (after another patch) chip unique ID is
already mixed in.

Incidentally this also gets rid of a rather ugly
cross-dependence on the machine using an extern declaration.

Cc: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
Only compile-tested as I don't have this platform.
---
 drivers/crypto/tegra-aes.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 2d58da9..7f42bfe 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -199,8 +199,6 @@ static void aes_workqueue_handler(struct work_struct *work);
 static DECLARE_WORK(aes_work, aes_workqueue_handler);
 static struct workqueue_struct *aes_wq;
 
-extern unsigned long long tegra_chip_uid(void);
-
 static inline u32 aes_readl(struct tegra_aes_dev *dd, u32 offset)
 {
 	return readl(dd->io_base + offset);
@@ -713,9 +711,8 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 	struct tegra_aes_dev *dd = aes_dev;
 	struct tegra_aes_ctx *ctx = &rng_ctx;
 	struct tegra_aes_slot *key_slot;
-	struct timespec ts;
 	int ret = 0;
-	u64 nsec, tmp[2];
+	u8 tmp[16]; /* 16 bytes = 128 bits of entropy */
 	u8 *dt;
 
 	if (!ctx || !dd) {
@@ -778,14 +775,8 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 	if (dd->ivlen >= (2 * DEFAULT_RNG_BLK_SZ + AES_KEYSIZE_128)) {
 		dt = dd->iv + DEFAULT_RNG_BLK_SZ + AES_KEYSIZE_128;
 	} else {
-		getnstimeofday(&ts);
-		nsec = timespec_to_ns(&ts);
-		do_div(nsec, 1000);
-		nsec ^= dd->ctr << 56;
-		dd->ctr++;
-		tmp[0] = nsec;
-		tmp[1] = tegra_chip_uid();
-		dt = (u8 *)tmp;
+		get_random_bytes(tmp, sizeof(tmp));
+		dt = tmp;
 	}
 	memcpy(dd->dt, dt, DEFAULT_RNG_BLK_SZ);
 
-- 
1.8.3.1
