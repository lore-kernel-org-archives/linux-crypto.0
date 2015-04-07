From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 01/10] crypto: atmel-aes: add new version
Date: Tue, 7 Apr 2015 17:45:02 +0800
Message-ID: <1428399911-23325-2-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32312 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbDGJrH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 05:47:07 -0400
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add new version of atmel-aes available with SAMA5D4 devices.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-aes.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6597aac..ddea772 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1246,6 +1246,11 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x200:
+		dd->caps.has_dualbuff = 1;
+		dd->caps.has_cfb64 = 1;
+		dd->caps.max_burst_size = 4;
+		break;
 	case 0x130:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
-- 
1.7.9.5
