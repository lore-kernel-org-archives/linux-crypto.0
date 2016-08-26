From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: Remove check for max less than 4 bytes
Date: Sat, 27 Aug 2016 00:02:04 +0530
Message-ID: <1472236324-7067-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

HW RNG core never asks for data less than 4 bytes. The check whether max
is less than 4 bytes is unnecessary. Remove the check.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 3 ---
 drivers/char/hw_random/st-rng.c    | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 0cfd81b..58bef39 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -76,9 +76,6 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	struct meson_rng_data *data =
 			container_of(rng, struct meson_rng_data, rng);
 
-	if (max < sizeof(u32))
-		return 0;
-
 	*(u32 *)buf = readl_relaxed(data->base + RNG_DATA);
 
 	return sizeof(u32);
diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 1d35363..7e8aa6b 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -54,9 +54,6 @@ static int st_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	u32 status;
 	int i;
 
-	if (max < sizeof(u16))
-		return -EINVAL;
-
 	/* Wait until FIFO is full - max 4uS*/
 	for (i = 0; i < ST_RNG_FILL_FIFO_TIMEOUT; i++) {
 		status = readl_relaxed(ddata->base + ST_RNG_STATUS_REG);
-- 
2.5.0
