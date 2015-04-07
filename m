From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 02/10] crypto: atmel-sha: add new version
Date: Tue, 7 Apr 2015 17:45:03 +0800
Message-ID: <1428399911-23325-3-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add new version of atmel-sha available with SAMA5D4 devices.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-sha.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 34db04a..d092313 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1266,6 +1266,12 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x420:
+		dd->caps.has_dma = 1;
+		dd->caps.has_dualbuff = 1;
+		dd->caps.has_sha224 = 1;
+		dd->caps.has_sha_384_512 = 1;
+		break;
 	case 0x410:
 		dd->caps.has_dma = 1;
 		dd->caps.has_dualbuff = 1;
-- 
1.7.9.5
