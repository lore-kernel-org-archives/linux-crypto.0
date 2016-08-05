From: Stephan Mueller <smueller@chronox.de>
Subject: [RFC][PATCH] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Fri, 05 Aug 2016 17:08:14 +0200
Message-ID: <34197429.2CvoIfft9B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
To: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34042 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759865AbcHEPIW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 11:08:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted, Herbert,

I sent a question to the ATH9K RNG some time ago to the developers.
See https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg19115.html

I have not yet received a word and I think this issue should be resolved.

Thanks
Stephan

---8<---

The ATH9K driver implements an RNG which is completely bypassing the
standard Linux HW generator logic.

The RNG may or may not deliver entropy. Considering the conservative
approach in treating entropy with respect to non-auditable sources, this
patch changes the delivered entropy value to zero. The RNG still feeds
data into the input_pool but it is assumed to have no entropy.

When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
the entropy estimation considering that a user can change that value at
boot and runtime.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/net/wireless/ath/ath9k/rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index d38e50f..d63dc48 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -92,8 +92,7 @@ static int ath9k_rng_kthread(void *data)
 		fail_stats = 0;
 
 		/* sleep until entropy bits under write_wakeup_threshold */
-		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
-					   ATH9K_RNG_ENTROPY(bytes_read));
+		add_hwgenerator_randomness((void *)rng_buf, bytes_read, 0);
 	}
 
 	kfree(rng_buf);
-- 
2.7.4
