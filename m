From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Sun, 07 Aug 2016 11:36:05 +0200
Message-ID: <1654172.XfclnXhRmn@positron.chronox.de>
References: <34197429.2CvoIfft9B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Jason Cooper <jason@lakedaemon.net>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34212 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbcHGJgN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Aug 2016 05:36:13 -0400
In-Reply-To: <34197429.2CvoIfft9B@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ATH9K driver implements an RNG which is completely bypassing the
standard Linux HW generator logic.

The RNG may or may not deliver entropy. Considering the conservative
approach in treating entropy with respect to non-auditable sources, this
patch changes the delivered entropy value to zero. The RNG still feeds
data into the input_pool but it is assumed to have no entropy.

When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
the entropy estimation considering that a user can change that value at
boot and runtime.

Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/net/wireless/ath/ath9k/rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index d38e50f..1ed8338 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -22,7 +22,6 @@
 #include "ar9003_phy.h"
 
 #define ATH9K_RNG_BUF_SIZE	320
-#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 320) >> 10) /* quality: 320/1024 */
 
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 {
@@ -92,8 +91,7 @@ static int ath9k_rng_kthread(void *data)
 		fail_stats = 0;
 
 		/* sleep until entropy bits under write_wakeup_threshold */
-		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
-					   ATH9K_RNG_ENTROPY(bytes_read));
+		add_hwgenerator_randomness((void *)rng_buf, bytes_read, 0);
 	}
 
 	kfree(rng_buf);
-- 
2.7.4
