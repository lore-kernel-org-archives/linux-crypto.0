From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 8/8] hwrng: amd: Convert to new hwrng read() API
Date: Fri, 26 Aug 2016 13:11:36 +0200
Message-ID: <1472209896-17197-9-git-send-email-clabbe.montjoie@gmail.com>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the hwrng interface used by amd768-rng to its new API
by replacing data_read()/data_present() by read().

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 47 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index bfa14b9..9959c76 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -58,27 +58,37 @@ struct amd768_priv {
 	u32 pmbase;
 };
 
-static int amd_rng_data_present(struct hwrng *rng, int wait)
+static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
+	u32 *data = buf;
 	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
-	int data, i;
-
-	for (i = 0; i < 20; i++) {
-		data = !!(ioread32(priv->iobase + RNGDONE) & 1);
-		if (data || !wait)
-			break;
-		udelay(10);
+	size_t read = 0;
+	/* We will wait at maximum one time per read */
+	int timeout = max / 4 + 1;
+
+	/*
+	 * RNG data is available when RNGDONE is set to 1
+	 * New random numbers are generated approximately 128 microseconds
+	 * after RNGDATA is read
+	 */
+	while (read < max) {
+		if (ioread32(priv->iobase + RNGDONE) == 0) {
+			if (wait) {
+				/* Delay given by datasheet */
+				usleep_range(128, 196);
+				if (timeout-- == 0)
+					return read;
+			} else {
+				return 0;
+			}
+		} else {
+			*data = ioread32(priv->iobase + RNGDATA);
+			data++;
+			read += 4;
+		}
 	}
-	return data;
-}
-
-static int amd_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
-
-	*data = ioread32(priv->iobase + RNGDATA);
 
-	return 4;
+	return read;
 }
 
 static int amd_rng_init(struct hwrng *rng)
@@ -111,8 +121,7 @@ static struct hwrng amd_rng = {
 	.name		= "amd",
 	.init		= amd_rng_init,
 	.cleanup	= amd_rng_cleanup,
-	.data_present	= amd_rng_data_present,
-	.data_read	= amd_rng_data_read,
+	.read		= amd_rng_read,
 };
 
 static int __init mod_init(void)
-- 
2.7.3
