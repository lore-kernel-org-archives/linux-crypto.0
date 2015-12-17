From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 22/24] crypto: atmel-aes: change the DMA threshold
Date: Thu, 17 Dec 2015 18:13:06 +0100
Message-ID: <4b6dbda450970ac204c1b561278396d02b27dc7f.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58825 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbLQRO1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 12:14:27 -0500
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increase the DMA threshold to 256: PIO accesses offer better performances
than the DMA when processing small amounts of data.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index a34919f6b7d7..ea645b4ee997 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -76,7 +76,7 @@
 
 #define ATMEL_AES_QUEUE_LENGTH	50
 
-#define ATMEL_AES_DMA_THRESHOLD		16
+#define ATMEL_AES_DMA_THRESHOLD		256
 
 
 struct atmel_aes_caps {
-- 
1.8.2.2
