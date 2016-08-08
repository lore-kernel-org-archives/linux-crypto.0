From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Subject: RE: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Mon, 8 Aug 2016 02:03:36 +0000
Message-ID: <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Jason Cooper" <jason@lakedaemon.net>
To: Stephan Mueller <smueller@chronox.de>, Ted Tso <tytso@mit.edu>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbcHHCDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Aug 2016 22:03:41 -0400
In-Reply-To: <1654172.XfclnXhRmn@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The entropy was evaluated by crypto expert,  the analysis report show the ADC with at least 10bits and up to 22 bits of min-entropy for a 32 bits value, we conservatively assume the min-entropy is 10 bits out of 32 bits, so that's why set entropy quality  to  320/1024 = 10/32.  Also we have explained in the commit message why can't use the HW RNG framework.

Otherwise, your patch will cause high CPU load,  as continuously read ADC data if entropy bits under write_wakeup_threshold.

--
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Sunday, August 07, 2016 5:36 PM
To: Ted Tso <tytso@mit.edu>
Cc: herbert@gondor.apana.org.au; linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org; Kalle Valo <kvalo@codeaurora.org>; Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy

The ATH9K driver implements an RNG which is completely bypassing the standard Linux HW generator logic.

The RNG may or may not deliver entropy. Considering the conservative approach in treating entropy with respect to non-auditable sources, this patch changes the delivered entropy value to zero. The RNG still feeds data into the input_pool but it is assumed to have no entropy.

When the ATH9K RNG changes to use the HW RNG framework, it may re-enable the entropy estimation considering that a user can change that value at boot and runtime.

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
 
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)  { @@ -92,8 +91,7 @@ static int ath9k_rng_kthread(void *data)
 		fail_stats = 0;
 
 		/* sleep until entropy bits under write_wakeup_threshold */
-		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
-					   ATH9K_RNG_ENTROPY(bytes_read));
+		add_hwgenerator_randomness((void *)rng_buf, bytes_read, 0);
 	}
 
 	kfree(rng_buf);
--
2.7.4
