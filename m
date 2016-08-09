From: miaoqing@codeaurora.org
Subject: [PATCH 1/2] ath9k: change entropy formula for easier understanding
Date: Tue,  9 Aug 2016 15:02:26 +0800
Message-ID: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	jason@lakedaemon.net, pouyans@qti.qualcomm.com,
	Miaoqing Pan <miaoqing@codeaurora.org>
To: kvalo@qca.qualcomm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33158 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcHIHCj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:02:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

The quality of ADC entropy is 10 bits of min-entropy for
a 32-bit value, change '(((x) * 8 * 320) >> 10)' to
'(((x) * 8 * 10) >> 5)' for easier understanding.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index d38e50f..568b1c6 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -22,7 +22,7 @@
 #include "ar9003_phy.h"
 
 #define ATH9K_RNG_BUF_SIZE	320
-#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 320) >> 10) /* quality: 320/1024 */
+#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
 
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 {
-- 
1.9.1
