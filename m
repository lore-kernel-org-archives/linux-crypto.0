From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 17/24] crypto: atmel-aes: use SIZE_IN_WORDS() helper macro
Date: Thu, 17 Dec 2015 18:13:01 +0100
Message-ID: <d0bee31dc217a559cbef2326ba17c006c7619578.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58681 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbbLQRNK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 12:13:10 -0500
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a dummy cosmetic patch.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9ef38eca4ae7..176ab3878583 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -689,10 +689,10 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 	atmel_aes_write(dd, AES_MR, valmr);
 
 	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
-						dd->ctx->keylen >> 2);
+			  SIZE_IN_WORDS(dd->ctx->keylen));
 
 	if (iv && (valmr & AES_MR_OPMOD_MASK) != AES_MR_OPMOD_ECB)
-		atmel_aes_write_n(dd, AES_IVR(0), iv, 4);
+		atmel_aes_write_block(dd, AES_IVR(0), iv);
 }
 
 static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
-- 
1.8.2.2
