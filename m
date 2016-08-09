From: miaoqing@codeaurora.org
Subject: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue,  9 Aug 2016 15:02:27 +0800
Message-ID: <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	jason@lakedaemon.net, pouyans@qti.qualcomm.com,
	Miaoqing Pan <miaoqing@codeaurora.org>
To: kvalo@qca.qualcomm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcHIHCq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:02:46 -0400
In-Reply-To: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

ath9k RNG will dominates all the noise sources from the real HW
RNG, disable it by default. But we strongly recommand to enable
it if the system without HW RNG, especially on embedded systems.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index f68cb00..8f231c6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -180,7 +180,7 @@ config ATH9K_HTC_DEBUGFS
 config ATH9K_HWRNG
 	bool "Random number generator support"
 	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
-	default y
+	default n
 	---help---
 	  This option incorporates the ADC register output as a source of
 	  randomness into Linux entropy pool (/dev/urandom and /dev/random)
-- 
1.9.1
